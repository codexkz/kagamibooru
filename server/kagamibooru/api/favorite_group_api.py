from typing import Dict

from kagamibooru import rest
from kagamibooru.func import (
    auth,
    favorite_groups,
    oauth,
    posts,
    serialization,
)


def _serialize(
    ctx: rest.Context, group, include_posts: bool = False
) -> rest.Response:
    options = serialization.get_serialization_options(ctx)
    if include_posts and "posts" not in options:
        options = options + ["posts"]
    return favorite_groups.serialize_group(group, ctx.user, options)


def _require(ctx: rest.Context) -> None:
    auth.verify_privilege(ctx.user, "favorite_groups:manage")
    if not ctx.user.user_id:
        raise favorite_groups.FavoriteGroupNotFoundError(
            "Must be logged in to use favorite groups."
        )


@rest.routes.get("/favorite-groups/?")
def get_favorite_groups(
    ctx: rest.Context, _params: Dict[str, str] = {}
) -> rest.Response:
    _require(ctx)
    return {
        "results": [
            favorite_groups.serialize_group(group, ctx.user)
            for group in favorite_groups.get_groups_for_user(ctx.user)
        ]
    }


@rest.routes.post("/favorite-groups/?")
def create_favorite_group(
    ctx: rest.Context, _params: Dict[str, str] = {}
) -> rest.Response:
    _require(ctx)
    name = ctx.get_param_as_string("name")
    description = (
        ctx.get_param_as_string("description")
        if ctx.has_param("description")
        else None
    )
    group = favorite_groups.create_group(ctx.user, name, description)
    ctx.session.commit()
    return _serialize(ctx, group)


@rest.routes.get("/favorite-group/(?P<group_id>[^/]+)/?")
def get_favorite_group(
    ctx: rest.Context, params: Dict[str, str] = {}
) -> rest.Response:
    _require(ctx)
    group = favorite_groups.get_group_by_id(
        int(params["group_id"]), ctx.user
    )
    return _serialize(ctx, group, include_posts=True)


@rest.routes.put("/favorite-group/(?P<group_id>[^/]+)/?")
def update_favorite_group(
    ctx: rest.Context, params: Dict[str, str] = {}
) -> rest.Response:
    _require(ctx)
    group = favorite_groups.get_group_by_id(
        int(params["group_id"]), ctx.user
    )
    name = (
        ctx.get_param_as_string("name")
        if ctx.has_param("name")
        else None
    )
    description = (
        ctx.get_param_as_string("description")
        if ctx.has_param("description")
        else None
    )
    favorite_groups.update_group(group, name=name, description=description)
    ctx.session.commit()
    return _serialize(ctx, group)


@rest.routes.delete("/favorite-group/(?P<group_id>[^/]+)/?")
def delete_favorite_group(
    ctx: rest.Context, params: Dict[str, str] = {}
) -> rest.Response:
    _require(ctx)
    group = favorite_groups.get_group_by_id(
        int(params["group_id"]), ctx.user
    )
    favorite_groups.delete_group(group)
    ctx.session.commit()
    return {}


@rest.routes.post("/favorite-group/(?P<group_id>[^/]+)/posts/?")
def add_post_to_favorite_group(
    ctx: rest.Context, params: Dict[str, str] = {}
) -> rest.Response:
    _require(ctx)
    group = favorite_groups.get_group_by_id(
        int(params["group_id"]), ctx.user
    )
    post = posts.get_post_by_id(ctx.get_param_as_int("postId"))
    favorite_groups.add_post(group, post)
    ctx.session.commit()
    return _serialize(ctx, group, include_posts=True)


@rest.routes.delete(
    "/favorite-group/(?P<group_id>[^/]+)/post/(?P<post_id>[^/]+)/?"
)
def remove_post_from_favorite_group(
    ctx: rest.Context, params: Dict[str, str] = {}
) -> rest.Response:
    _require(ctx)
    group = favorite_groups.get_group_by_id(
        int(params["group_id"]), ctx.user
    )
    post = posts.get_post_by_id(int(params["post_id"]))
    favorite_groups.remove_post(group, post)
    ctx.session.commit()
    return _serialize(ctx, group, include_posts=True)


# --------------------------------------------------------------------------- #
# On-behalf-of variants (himari-bot proxy).
#
# A privileged service account (administrator, posts:favorite:any) manages a
# Himari user's favorite groups. The target user is resolved by OAuth subject
# (the Himari user id), exactly like the favorite-for endpoints.
# --------------------------------------------------------------------------- #


def _resolve_target_user(ctx: rest.Context, create: bool):
    auth.verify_privilege(ctx.user, "posts:favorite:any")
    sub = ctx.get_param_as_string("sub")
    if create:
        username = ctx.get_param_as_string("username", default="")
        picture = ctx.get_param_as_string("picture", default="")
        return oauth.find_or_create_user(
            sub, username or "user_{0}".format(sub[:8]), picture
        )
    provider = oauth.get_oauth_config().get("provider_name", "oauth")
    return oauth.find_user_by_oauth(provider, sub)


def _require_target_user(ctx: rest.Context):
    user = _resolve_target_user(ctx, create=False)
    if user is None or not user.user_id:
        raise favorite_groups.FavoriteGroupNotFoundError(
            "Target user has no favorite groups."
        )
    return user


def _serialize_for(
    ctx: rest.Context, group, user, include_posts: bool = False
) -> rest.Response:
    options = serialization.get_serialization_options(ctx)
    base_options = [opt for opt in options if opt != "posts"]
    result = favorite_groups.serialize_group(group, user, base_options)
    if include_posts:
        # Serialize members with contentUrl (serialize_micro_post omits it),
        # so the picker can insert images straight from a group.
        result["posts"] = [
            posts.serialize_post(
                member.post,
                user,
                options=["id", "thumbnailUrl", "contentUrl", "tags"],
            )
            for member in group._posts
        ]
    return result


@rest.routes.get("/favorite-groups-for/?")
def get_favorite_groups_for_user(
    ctx: rest.Context, _params: Dict[str, str] = {}
) -> rest.Response:
    user = _resolve_target_user(ctx, create=False)
    if user is None or not user.user_id:
        return {"results": []}
    return {
        "results": [
            favorite_groups.serialize_group(group, user)
            for group in favorite_groups.get_groups_for_user(user)
        ]
    }


@rest.routes.post("/favorite-groups-for/?")
def create_favorite_group_for_user(
    ctx: rest.Context, _params: Dict[str, str] = {}
) -> rest.Response:
    user = _resolve_target_user(ctx, create=True)
    name = ctx.get_param_as_string("name")
    description = (
        ctx.get_param_as_string("description")
        if ctx.has_param("description")
        else None
    )
    group = favorite_groups.create_group(user, name, description)
    ctx.session.commit()
    return _serialize_for(ctx, group, user)


@rest.routes.get("/favorite-group-for/(?P<group_id>[^/]+)/?")
def get_favorite_group_for_user(
    ctx: rest.Context, params: Dict[str, str] = {}
) -> rest.Response:
    user = _require_target_user(ctx)
    group = favorite_groups.get_group_by_id(int(params["group_id"]), user)
    return _serialize_for(ctx, group, user, include_posts=True)


@rest.routes.put("/favorite-group-for/(?P<group_id>[^/]+)/?")
def update_favorite_group_for_user(
    ctx: rest.Context, params: Dict[str, str] = {}
) -> rest.Response:
    user = _require_target_user(ctx)
    group = favorite_groups.get_group_by_id(int(params["group_id"]), user)
    name = ctx.get_param_as_string("name") if ctx.has_param("name") else None
    description = (
        ctx.get_param_as_string("description")
        if ctx.has_param("description")
        else None
    )
    favorite_groups.update_group(group, name=name, description=description)
    ctx.session.commit()
    return _serialize_for(ctx, group, user)


@rest.routes.delete("/favorite-group-for/(?P<group_id>[^/]+)/?")
def delete_favorite_group_for_user(
    ctx: rest.Context, params: Dict[str, str] = {}
) -> rest.Response:
    user = _require_target_user(ctx)
    group = favorite_groups.get_group_by_id(int(params["group_id"]), user)
    favorite_groups.delete_group(group)
    ctx.session.commit()
    return {}


@rest.routes.post("/favorite-group-for/(?P<group_id>[^/]+)/posts/?")
def add_post_to_favorite_group_for_user(
    ctx: rest.Context, params: Dict[str, str] = {}
) -> rest.Response:
    user = _resolve_target_user(ctx, create=True)
    group = favorite_groups.get_group_by_id(int(params["group_id"]), user)
    post = posts.get_post_by_id(ctx.get_param_as_int("postId"))
    favorite_groups.add_post(group, post)
    ctx.session.commit()
    return _serialize_for(ctx, group, user, include_posts=True)


@rest.routes.delete(
    "/favorite-group-for/(?P<group_id>[^/]+)/post/(?P<post_id>[^/]+)/?"
)
def remove_post_from_favorite_group_for_user(
    ctx: rest.Context, params: Dict[str, str] = {}
) -> rest.Response:
    user = _require_target_user(ctx)
    group = favorite_groups.get_group_by_id(int(params["group_id"]), user)
    post = posts.get_post_by_id(int(params["post_id"]))
    favorite_groups.remove_post(group, post)
    ctx.session.commit()
    return _serialize_for(ctx, group, user, include_posts=True)
