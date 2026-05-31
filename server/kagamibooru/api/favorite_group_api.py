from typing import Dict

from kagamibooru import rest
from kagamibooru.func import auth, favorite_groups, posts, serialization


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
