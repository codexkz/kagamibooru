from datetime import datetime
from typing import List, Optional

from kagamibooru import db, errors, model
from kagamibooru.func import posts


class FavoriteGroupNotFoundError(errors.NotFoundError):
    pass


class FavoriteGroupAlreadyExistsError(errors.ValidationError):
    pass


class InvalidFavoriteGroupNameError(errors.ValidationError):
    pass


class FavoriteGroupPostNotFoundError(errors.NotFoundError):
    pass


# --------------------------------------------------------------------------- #
# Lookups (always scoped to a user)
# --------------------------------------------------------------------------- #


def get_group_by_id(
    group_id: int, user: model.User
) -> model.FavoriteGroup:
    group = (
        db.session.query(model.FavoriteGroup)
        .filter(model.FavoriteGroup.favorite_group_id == group_id)
        .one_or_none()
    )
    if not group or group.user_id != user.user_id:
        raise FavoriteGroupNotFoundError(
            "Favorite group %r not found." % group_id
        )
    return group


def get_groups_for_user(
    user: model.User,
) -> List[model.FavoriteGroup]:
    return (
        db.session.query(model.FavoriteGroup)
        .filter(model.FavoriteGroup.user_id == user.user_id)
        .order_by(
            model.FavoriteGroup.is_default.desc(),
            model.FavoriteGroup.name.asc(),
        )
        .all()
    )


DEFAULT_GROUP_NAME = "Favorites"


def get_or_create_default_group(
    user: model.User,
) -> model.FavoriteGroup:
    """The group that the heart (favorite) shortcut targets. One per user."""
    group = (
        db.session.query(model.FavoriteGroup)
        .filter(model.FavoriteGroup.user_id == user.user_id)
        .filter(model.FavoriteGroup.is_default == True)  # noqa: E712
        .first()
    )
    if group:
        return group
    # Auto-create. Avoid colliding with an existing same-named manual group.
    name = DEFAULT_GROUP_NAME
    suffix = 0
    while (
        db.session.query(model.FavoriteGroup)
        .filter(model.FavoriteGroup.user_id == user.user_id)
        .filter(model.FavoriteGroup.name == name)
        .first()
    ):
        suffix += 1
        name = "%s (%d)" % (DEFAULT_GROUP_NAME, suffix)
    group = model.FavoriteGroup()
    group.user_id = user.user_id
    group.name = name
    group.is_default = True
    group.creation_time = datetime.utcnow()
    db.session.add(group)
    db.session.flush()
    return group


# --------------------------------------------------------------------------- #
# Serialization
# --------------------------------------------------------------------------- #


def serialize_group(
    group: model.FavoriteGroup,
    auth_user: model.User,
    options: Optional[List[str]] = None,
) -> dict:
    result = {
        "id": group.favorite_group_id,
        "name": group.name,
        "description": group.description,
        "isDefault": group.is_default,
        "creationTime": group.creation_time,
        "lastEditTime": group.last_edit_time,
        "postCount": group.post_count,
    }
    if options and "posts" in options:
        result["posts"] = [
            posts.serialize_micro_post(member.post, auth_user)
            for member in group._posts
        ]
    return result


# --------------------------------------------------------------------------- #
# CRUD
# --------------------------------------------------------------------------- #


def _validate_name(name: str) -> str:
    name = (name or "").strip()
    if not name:
        raise InvalidFavoriteGroupNameError(
            "Favorite group name cannot be empty."
        )
    if len(name) > 128:
        raise InvalidFavoriteGroupNameError(
            "Favorite group name is too long (max 128)."
        )
    return name


def create_group(
    user: model.User, name: str, description: Optional[str] = None
) -> model.FavoriteGroup:
    name = _validate_name(name)
    existing = (
        db.session.query(model.FavoriteGroup)
        .filter(model.FavoriteGroup.user_id == user.user_id)
        .filter(model.FavoriteGroup.name == name)
        .one_or_none()
    )
    if existing:
        raise FavoriteGroupAlreadyExistsError(
            "You already have a favorite group named %r." % name
        )
    group = model.FavoriteGroup()
    group.user_id = user.user_id
    group.name = name
    group.description = description
    group.creation_time = datetime.utcnow()
    db.session.add(group)
    db.session.flush()
    return group


def update_group(
    group: model.FavoriteGroup,
    name: Optional[str] = None,
    description: Optional[str] = None,
) -> None:
    if name is not None:
        new_name = _validate_name(name)
        if new_name != group.name:
            clash = (
                db.session.query(model.FavoriteGroup)
                .filter(
                    model.FavoriteGroup.user_id == group.user_id
                )
                .filter(model.FavoriteGroup.name == new_name)
                .one_or_none()
            )
            if clash:
                raise FavoriteGroupAlreadyExistsError(
                    "You already have a favorite group named %r."
                    % new_name
                )
            group.name = new_name
    if description is not None:
        group.description = description
    group.last_edit_time = datetime.utcnow()


def delete_group(group: model.FavoriteGroup) -> None:
    db.session.delete(group)


# --------------------------------------------------------------------------- #
# Membership
# --------------------------------------------------------------------------- #


def is_member(group: model.FavoriteGroup, post_id: int) -> bool:
    """Read-only membership check (does not create anything)."""
    return any(m.post_id == post_id for m in group._posts)


def get_group_ids_for_post(post_id: int, user: model.User) -> List[int]:
    """IDs of the user's own favorite groups that contain this post."""
    rows = (
        db.session.query(model.FavoriteGroup.favorite_group_id)
        .join(
            model.FavoriteGroupPost,
            model.FavoriteGroupPost.favorite_group_id
            == model.FavoriteGroup.favorite_group_id,
        )
        .filter(model.FavoriteGroup.user_id == user.user_id)
        .filter(model.FavoriteGroupPost.post_id == post_id)
        .all()
    )
    return [r[0] for r in rows]


def get_favoriting_users(post_id: int) -> List[model.User]:
    """Distinct users who put this post in any of their favorite groups."""
    # NOTE: distinct on the User row itself fails on Postgres because
    # User.hidden_categories is a JSON column (no equality operator).
    # Select distinct user_ids first, then load the User rows by id.
    id_rows = (
        db.session.query(model.FavoriteGroup.user_id)
        .join(
            model.FavoriteGroupPost,
            model.FavoriteGroupPost.favorite_group_id
            == model.FavoriteGroup.favorite_group_id,
        )
        .filter(model.FavoriteGroupPost.post_id == post_id)
        .distinct()
        .all()
    )
    user_ids = [r[0] for r in id_rows]
    if not user_ids:
        return []
    return (
        db.session.query(model.User)
        .filter(model.User.user_id.in_(user_ids))
        .all()
    )


def is_favorited(post_id: int, user: model.User) -> bool:
    """Read-only: is the post in the user's default group? (the "star").

    Safe for serialization — does NOT auto-create the default group.
    """
    group = (
        db.session.query(model.FavoriteGroup)
        .filter(model.FavoriteGroup.user_id == user.user_id)
        .filter(model.FavoriteGroup.is_default == True)  # noqa: E712
        .first()
    )
    if not group:
        return False
    return is_member(group, post_id)


def add_post(group: model.FavoriteGroup, post: model.Post) -> bool:
    """Add a post to the group. Returns False if already present."""
    existing = (
        db.session.query(model.FavoriteGroupPost)
        .filter(
            model.FavoriteGroupPost.favorite_group_id
            == group.favorite_group_id
        )
        .filter(model.FavoriteGroupPost.post_id == post.post_id)
        .one_or_none()
    )
    if existing:
        return False
    member = model.FavoriteGroupPost(post)
    member.favorite_group_id = group.favorite_group_id
    member.order = group.post_count
    member.time = datetime.utcnow()
    db.session.add(member)
    group.last_edit_time = datetime.utcnow()
    return True


def remove_post(group: model.FavoriteGroup, post: model.Post) -> None:
    member = (
        db.session.query(model.FavoriteGroupPost)
        .filter(
            model.FavoriteGroupPost.favorite_group_id
            == group.favorite_group_id
        )
        .filter(model.FavoriteGroupPost.post_id == post.post_id)
        .one_or_none()
    )
    if not member:
        raise FavoriteGroupPostNotFoundError(
            "Post %r is not in this favorite group." % post.post_id
        )
    db.session.delete(member)
    group.last_edit_time = datetime.utcnow()
