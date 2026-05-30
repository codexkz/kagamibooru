from typing import Dict

from kagamibooru import rest
from kagamibooru.func import auth, similarity


@rest.routes.get("/similarity-scans/?")
def get_similarity_scans(
    ctx: rest.Context, _params: Dict[str, str] = {}
) -> rest.Response:
    auth.verify_privilege(ctx.user, "posts:similarity:list")
    return {
        "results": [
            similarity.serialize_scan(scan)
            for scan in similarity.get_scans()
        ]
    }


@rest.routes.post("/similarity-scans/?")
def create_similarity_scan(
    ctx: rest.Context, _params: Dict[str, str] = {}
) -> rest.Response:
    auth.verify_privilege(ctx.user, "posts:similarity:create")
    threshold = float(ctx.get_param_as_string("threshold", default="0.45"))
    scan = similarity.create_scan(threshold, ctx.user)
    return similarity.serialize_scan(scan)


@rest.routes.get("/similarity-scan/(?P<scan_id>[^/]+)/?")
def get_similarity_scan(
    ctx: rest.Context, params: Dict[str, str] = {}
) -> rest.Response:
    auth.verify_privilege(ctx.user, "posts:similarity:list")
    scan = similarity.get_scan_by_id(int(params["scan_id"]))
    return similarity.serialize_scan(scan)


@rest.routes.delete("/similarity-scan/(?P<scan_id>[^/]+)/?")
def delete_similarity_scan(
    ctx: rest.Context, params: Dict[str, str] = {}
) -> rest.Response:
    auth.verify_privilege(ctx.user, "posts:similarity:delete")
    scan = similarity.get_scan_by_id(int(params["scan_id"]))
    similarity.delete_scan(scan)
    ctx.session.commit()
    return {}


@rest.routes.get("/similarity-scan/(?P<scan_id>[^/]+)/groups/?")
def get_similarity_groups(
    ctx: rest.Context, params: Dict[str, str] = {}
) -> rest.Response:
    auth.verify_privilege(ctx.user, "posts:similarity:list")
    scan = similarity.get_scan_by_id(int(params["scan_id"]))
    status = ctx.get_param_as_string("status", default="") or None
    return {
        "results": [
            similarity.serialize_group(group, ctx.user)
            for group in similarity.get_groups(scan, status)
        ]
    }


@rest.routes.post("/similarity-scan/(?P<scan_id>[^/]+)/apply-deletions/?")
def apply_similarity_deletions(
    ctx: rest.Context, params: Dict[str, str] = {}
) -> rest.Response:
    auth.verify_privilege(ctx.user, "posts:similarity:apply")
    scan = similarity.get_scan_by_id(int(params["scan_id"]))
    deleted = similarity.apply_deletions(scan, ctx.user)
    ctx.session.commit()
    return {"deletedCount": deleted}


@rest.routes.put("/similarity-group/(?P<group_id>[^/]+)/?")
def update_similarity_group(
    ctx: rest.Context, params: Dict[str, str] = {}
) -> rest.Response:
    auth.verify_privilege(ctx.user, "posts:similarity:annotate")
    group = similarity.get_group_by_id(int(params["group_id"]))
    status = (
        ctx.get_param_as_string("status")
        if ctx.has_param("status")
        else None
    )
    clear_keep = False
    keep_post_id = None
    if ctx.has_param("keepPostId"):
        raw = ctx.get_param_as_string("keepPostId")
        if raw == "":
            clear_keep = True
        else:
            keep_post_id = int(raw)
    similarity.update_group(
        group,
        status=status,
        keep_post_id=keep_post_id,
        clear_keep=clear_keep,
    )
    ctx.session.commit()
    return similarity.serialize_group(group, ctx.user)


@rest.routes.put("/similarity-group-post/(?P<member_id>[^/]+)/?")
def update_similarity_group_post(
    ctx: rest.Context, params: Dict[str, str] = {}
) -> rest.Response:
    member = similarity.get_group_post_by_id(int(params["member_id"]))
    action = (
        ctx.get_param_as_string("action")
        if ctx.has_param("action")
        else None
    )
    dismissed = (
        ctx.get_param_as_bool("dismissed")
        if ctx.has_param("dismissed")
        else None
    )
    group_id = (
        ctx.get_param_as_int("groupId")
        if ctx.has_param("groupId")
        else None
    )
    # Moving a member between groups is a structural change; flagging /
    # dismissing is a soft annotation. Require the stronger privilege only
    # when the request actually restructures.
    if group_id is not None and group_id != member.group_id:
        auth.verify_privilege(ctx.user, "posts:similarity:restructure")
    if action is not None or dismissed is not None:
        auth.verify_privilege(ctx.user, "posts:similarity:annotate")
    similarity.update_group_post(
        member,
        action=action,
        dismissed=dismissed,
        group_id=group_id,
    )
    ctx.session.commit()
    return similarity.serialize_group_post(member, ctx.user)


@rest.routes.post("/similarity-groups-merge/?")
def merge_similarity_groups(
    ctx: rest.Context, _params: Dict[str, str] = {}
) -> rest.Response:
    auth.verify_privilege(ctx.user, "posts:similarity:restructure")
    source = similarity.get_group_by_id(
        ctx.get_param_as_int("sourceGroupId")
    )
    target = similarity.get_group_by_id(
        ctx.get_param_as_int("targetGroupId")
    )
    similarity.merge_groups(source, target)
    ctx.session.commit()
    return similarity.serialize_group(target, ctx.user)
