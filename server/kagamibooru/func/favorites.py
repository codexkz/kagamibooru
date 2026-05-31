"""Backwards-compatible "favorite" (now: the star) operations.

The heart/star is a shortcut for "add to my default favorite group".
It no longer touches the user's score (favoriting and liking are fully
decoupled). Only posts can be favorited.
"""

from typing import Optional

from kagamibooru import errors, model
from kagamibooru.func import favorite_groups


class InvalidFavoriteTargetError(errors.ValidationError):
    pass


def _require_post(entity: model.Base) -> model.Post:
    resource_type, _, _ = model.util.get_resource_info(entity)
    if resource_type != "post":
        raise InvalidFavoriteTargetError()
    return entity


def has_favorited(entity: model.Base, user: model.User) -> bool:
    assert entity
    assert user
    post = _require_post(entity)
    group = favorite_groups.get_or_create_default_group(user)
    return any(m.post_id == post.post_id for m in group._posts)


def unset_favorite(entity: model.Base, user: Optional[model.User]) -> None:
    assert entity
    assert user
    post = _require_post(entity)
    group = favorite_groups.get_or_create_default_group(user)
    try:
        favorite_groups.remove_post(group, post)
    except favorite_groups.FavoriteGroupPostNotFoundError:
        pass


def set_favorite(entity: model.Base, user: Optional[model.User]) -> None:
    assert entity
    assert user
    post = _require_post(entity)
    group = favorite_groups.get_or_create_default_group(user)
    favorite_groups.add_post(group, post)
