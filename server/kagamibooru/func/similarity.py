import logging
import threading
from collections import Counter, defaultdict
from datetime import datetime
from typing import Any, Dict, List, Optional, Tuple

import numpy as np
import sqlalchemy as sa

from kagamibooru import db, errors, model
from kagamibooru.func import image_hash, posts, snapshots

logger = logging.getLogger(__name__)

# Candidates per post are capped the same way reverse-search caps them
# (search_by_image uses "ORDER BY score DESC LIMIT 100").
MAX_CANDIDATES_PER_POST = 100

# Word buckets larger than this are skipped during candidate generation to
# avoid O(n^2) blow-up on near-ubiquitous words. Skips are logged, never silent.
MAX_WORD_BUCKET = 5000

# How often the background scan flushes progress to the database.
PROGRESS_COMMIT_EVERY = 500


class SimilarityScanNotFoundError(errors.NotFoundError):
    pass


class SimilarityGroupNotFoundError(errors.NotFoundError):
    pass


class SimilarityGroupPostNotFoundError(errors.NotFoundError):
    pass


class InvalidSimilarityParamError(errors.ValidationError):
    pass


# --------------------------------------------------------------------------- #
# Union-find
# --------------------------------------------------------------------------- #


class _UnionFind:
    def __init__(self) -> None:
        self.parent = {}  # type: Dict[int, int]

    def find(self, x: int) -> int:
        self.parent.setdefault(x, x)
        root = x
        while self.parent[root] != root:
            root = self.parent[root]
        while self.parent[x] != root:
            self.parent[x], x = root, self.parent[x]
        return root

    def union(self, a: int, b: int) -> None:
        ra, rb = self.find(a), self.find(b)
        if ra != rb:
            self.parent[rb] = ra


# --------------------------------------------------------------------------- #
# Lookups
# --------------------------------------------------------------------------- #


def get_scan_by_id(scan_id: int) -> model.SimilarityScan:
    scan = (
        db.session.query(model.SimilarityScan)
        .filter(model.SimilarityScan.scan_id == scan_id)
        .one_or_none()
    )
    if not scan:
        raise SimilarityScanNotFoundError(
            "Similarity scan %r not found." % scan_id
        )
    return scan


def get_group_by_id(group_id: int) -> model.SimilarityGroup:
    group = (
        db.session.query(model.SimilarityGroup)
        .filter(model.SimilarityGroup.group_id == group_id)
        .one_or_none()
    )
    if not group:
        raise SimilarityGroupNotFoundError(
            "Similarity group %r not found." % group_id
        )
    return group


def get_group_post_by_id(member_id: int) -> model.SimilarityGroupPost:
    member = (
        db.session.query(model.SimilarityGroupPost)
        .filter(model.SimilarityGroupPost.similarity_group_post_id == member_id)
        .one_or_none()
    )
    if not member:
        raise SimilarityGroupPostNotFoundError(
            "Similarity group member %r not found." % member_id
        )
    return member


def get_scans() -> List[model.SimilarityScan]:
    return (
        db.session.query(model.SimilarityScan)
        .order_by(model.SimilarityScan.creation_time.desc())
        .all()
    )


def get_groups(
    scan: model.SimilarityScan, status: Optional[str] = None
) -> List[model.SimilarityGroup]:
    query = db.session.query(model.SimilarityGroup).filter(
        model.SimilarityGroup.scan_id == scan.scan_id
    )
    if status is not None:
        query = query.filter(model.SimilarityGroup.status == status)
    return query.order_by(model.SimilarityGroup.group_id.asc()).all()


# --------------------------------------------------------------------------- #
# Serialization
# --------------------------------------------------------------------------- #


def serialize_scan(scan: model.SimilarityScan) -> Dict[str, Any]:
    return {
        "id": scan.scan_id,
        "creationTime": scan.creation_time,
        "finishTime": scan.finish_time,
        "status": scan.status,
        "threshold": scan.threshold,
        "processedCount": scan.processed_count,
        "totalCount": scan.total_count,
        "groupCount": scan.group_count,
        "userId": scan.user_id,
        "error": scan.error,
    }


def serialize_group(
    group: model.SimilarityGroup, auth_user: model.User
) -> Dict[str, Any]:
    return {
        "id": group.group_id,
        "scanId": group.scan_id,
        "status": group.status,
        "keepPostId": group.keep_post_id,
        "creationTime": group.creation_time,
        "members": [
            serialize_group_post(member, auth_user)
            for member in sorted(
                group.members, key=lambda m: m.distance
            )
        ],
    }


def serialize_group_post(
    member: model.SimilarityGroupPost, auth_user: model.User
) -> Dict[str, Any]:
    return {
        "id": member.similarity_group_post_id,
        "groupId": member.group_id,
        "postId": member.post_id,
        "distance": member.distance,
        "action": member.action,
        "dismissed": member.dismissed,
        "post": posts.serialize_micro_post(member.post, auth_user),
    }


# --------------------------------------------------------------------------- #
# Scan
# --------------------------------------------------------------------------- #


def create_scan(
    threshold: float, user: Optional[model.User]
) -> model.SimilarityScan:
    if threshold < 0.0 or threshold > 1.0:
        raise InvalidSimilarityParamError(
            "Threshold must be between 0.0 and 1.0."
        )
    scan = model.SimilarityScan()
    scan.creation_time = datetime.utcnow()
    scan.status = model.SimilarityScan.STATUS_RUNNING
    scan.threshold = threshold
    scan.processed_count = 0
    scan.total_count = 0
    scan.group_count = 0
    scan.user_id = user.user_id if user and user.user_id else None
    db.session.add(scan)
    db.session.commit()

    scan_id = scan.scan_id
    threading.Thread(
        target=_run_scan, args=(scan_id, threshold), daemon=False
    ).start()
    return scan


def _load_signatures() -> Tuple[List[int], Dict[int, Any], Dict[int, List[int]]]:
    """Returns (post_ids, post_id -> unpacked signature, post_id -> words)."""
    rows = db.session.execute(
        sa.text("SELECT post_id, signature, words FROM post_signature")
    )
    post_ids = []
    signatures = {}
    words_map = {}
    for post_id, packed, words in rows:
        post_ids.append(post_id)
        signatures[post_id] = image_hash.unpack_signature(packed)
        words_map[post_id] = list(words)
    return post_ids, signatures, words_map


def _run_scan(scan_id: int, threshold: float) -> None:
    """Background worker. Runs in its own thread with its own session."""
    try:
        post_ids, signatures, words_map = _load_signatures()
        total = len(post_ids)

        scan = get_scan_by_id(scan_id)
        scan.total_count = total
        db.session.commit()

        # Inverted index: word -> [post_id, ...]
        word_index = defaultdict(list)  # type: Dict[int, List[int]]
        for post_id in post_ids:
            for word in words_map[post_id]:
                word_index[word].append(post_id)

        oversized = {
            w for w, bucket in word_index.items()
            if len(bucket) > MAX_WORD_BUCKET
        }
        if oversized:
            logger.info(
                "Similarity scan %d: skipping %d oversized word buckets "
                "(>%d posts) during candidate generation.",
                scan_id, len(oversized), MAX_WORD_BUCKET,
            )

        uf = _UnionFind()
        # member post_id -> smallest incident edge distance
        min_distance = {}  # type: Dict[int, float]

        for processed, post_id in enumerate(post_ids, start=1):
            counter = Counter()  # type: Counter
            for word in words_map[post_id]:
                if word in oversized:
                    continue
                for other in word_index[word]:
                    if other != post_id:
                        counter[other] += 1

            if counter:
                candidate_ids = [
                    cid for cid, _ in counter.most_common(
                        MAX_CANDIDATES_PER_POST
                    )
                ]
                target_sig = signatures[post_id]
                candidate_sigs = np.array(
                    [signatures[cid] for cid in candidate_ids]
                )
                distances = image_hash.normalized_distance(
                    candidate_sigs, target_sig
                )
                for cid, distance in zip(candidate_ids, distances):
                    distance = float(distance)
                    if distance <= threshold:
                        uf.union(post_id, cid)
                        if (
                            post_id not in min_distance
                            or distance < min_distance[post_id]
                        ):
                            min_distance[post_id] = distance
                        if (
                            cid not in min_distance
                            or distance < min_distance[cid]
                        ):
                            min_distance[cid] = distance

            if processed % PROGRESS_COMMIT_EVERY == 0:
                scan = get_scan_by_id(scan_id)
                scan.processed_count = processed
                db.session.commit()

        # Collect connected components of size >= 2.
        components = defaultdict(list)  # type: Dict[int, List[int]]
        for post_id in min_distance:
            components[uf.find(post_id)].append(post_id)

        group_count = 0
        for member_ids in components.values():
            if len(member_ids) < 2:
                continue
            group_count += 1
            group = model.SimilarityGroup()
            group.scan_id = scan_id
            group.status = model.SimilarityGroup.STATUS_PENDING
            group.creation_time = datetime.utcnow()
            db.session.add(group)
            db.session.flush()
            for member_post_id in member_ids:
                member = model.SimilarityGroupPost()
                member.scan_id = scan_id
                member.group_id = group.group_id
                member.post_id = member_post_id
                member.distance = min_distance.get(member_post_id, 0.0)
                member.action = model.SimilarityGroupPost.ACTION_NONE
                member.dismissed = False
                db.session.add(member)
            db.session.commit()

        scan = get_scan_by_id(scan_id)
        scan.processed_count = total
        scan.group_count = group_count
        scan.status = model.SimilarityScan.STATUS_DONE
        scan.finish_time = datetime.utcnow()
        db.session.commit()
        logger.info(
            "Similarity scan %d done: %d posts, %d groups.",
            scan_id, total, group_count,
        )
    except Exception as ex:
        logger.exception(ex)
        try:
            db.session.rollback()
            scan = get_scan_by_id(scan_id)
            scan.status = model.SimilarityScan.STATUS_FAILED
            scan.finish_time = datetime.utcnow()
            scan.error = str(ex)[:2048]
            db.session.commit()
        except Exception as inner:
            logger.exception(inner)
    finally:
        db.session.remove()


def delete_scan(scan: model.SimilarityScan) -> None:
    assert scan
    db.session.delete(scan)


# --------------------------------------------------------------------------- #
# Editing
# --------------------------------------------------------------------------- #


def update_group(
    group: model.SimilarityGroup,
    status: Optional[str] = None,
    keep_post_id: Optional[int] = None,
    clear_keep: bool = False,
) -> None:
    if status is not None:
        valid = {
            model.SimilarityGroup.STATUS_PENDING,
            model.SimilarityGroup.STATUS_RESOLVED,
            model.SimilarityGroup.STATUS_IGNORED,
        }
        if status not in valid:
            raise InvalidSimilarityParamError(
                "Invalid group status %r." % status
            )
        group.status = status
    if clear_keep:
        group.keep_post_id = None
    elif keep_post_id is not None:
        member_ids = {m.post_id for m in group.members}
        if keep_post_id not in member_ids:
            raise InvalidSimilarityParamError(
                "Post %r is not a member of this group." % keep_post_id
            )
        group.keep_post_id = keep_post_id


def update_group_post(
    member: model.SimilarityGroupPost,
    action: Optional[str] = None,
    dismissed: Optional[bool] = None,
    group_id: Optional[int] = None,
) -> None:
    if action is not None:
        valid = {
            model.SimilarityGroupPost.ACTION_NONE,
            model.SimilarityGroupPost.ACTION_DELETE,
        }
        if action not in valid:
            raise InvalidSimilarityParamError(
                "Invalid member action %r." % action
            )
        member.action = action
    if dismissed is not None:
        member.dismissed = dismissed
    if group_id is not None and group_id != member.group_id:
        target = get_group_by_id(group_id)
        if target.scan_id != member.scan_id:
            raise InvalidSimilarityParamError(
                "Cannot move a member to a group from a different scan."
            )
        member.group_id = group_id


def merge_groups(
    source: model.SimilarityGroup, target: model.SimilarityGroup
) -> None:
    if source.group_id == target.group_id:
        raise InvalidSimilarityParamError("Cannot merge a group with itself.")
    if source.scan_id != target.scan_id:
        raise InvalidSimilarityParamError(
            "Cannot merge groups from different scans."
        )
    target_post_ids = {m.post_id for m in target.members}
    for member in list(source.members):
        if member.post_id in target_post_ids:
            # The same post already exists in the target group; drop the dup.
            db.session.delete(member)
        else:
            member.group_id = target.group_id
    db.session.flush()
    db.session.delete(source)


def apply_deletions(
    scan: model.SimilarityScan, auth_user: Optional[model.User] = None
) -> int:
    """Permanently deletes every post flagged action=delete in this scan.

    A group's keep_post is never deleted, even if it was somehow flagged.
    Returns the number of posts deleted.
    """
    keep_ids = {
        group.keep_post_id
        for group in scan.groups
        if group.keep_post_id is not None
    }
    flagged = (
        db.session.query(model.SimilarityGroupPost)
        .filter(model.SimilarityGroupPost.scan_id == scan.scan_id)
        .filter(
            model.SimilarityGroupPost.action
            == model.SimilarityGroupPost.ACTION_DELETE
        )
        .all()
    )
    deleted = 0
    seen = set()
    for member in flagged:
        if member.post_id in keep_ids or member.post_id in seen:
            continue
        seen.add(member.post_id)
        post = posts.try_get_post_by_id(member.post_id)
        if post:
            snapshots.delete(post, auth_user)
            posts.delete(post)
            deleted += 1
    db.session.flush()
    return deleted
