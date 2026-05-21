from datetime import datetime
from typing import Dict, Optional

import sqlalchemy as sa

from kagamibooru import config, rest
from kagamibooru.func import auth, oauth, posts, users, util
from kagamibooru.model.post import Post


def _get_disk_usage() -> int:
    from kagamibooru import db

    return int(
        db.session.query(
            sa.func.coalesce(sa.func.sum(Post.file_size), 0)
        ).scalar()
    )


@rest.routes.get("/info/?")
def get_info(ctx: rest.Context, _params: Dict[str, str] = {}) -> rest.Response:
    post_feature = posts.try_get_current_post_feature()
    ret = {
        "postCount": posts.get_post_count(),
        "diskUsage": _get_disk_usage(),
        "serverTime": datetime.utcnow(),
        "config": {
            "name": config.config["name"],
            "userNameRegex": config.config["user_name_regex"],
            "passwordRegex": config.config["password_regex"],
            "tagNameRegex": config.config["tag_name_regex"],
            "tagCategoryNameRegex": config.config["tag_category_name_regex"],
            "defaultUserRank": config.config["default_rank"],
            "enableSafety": config.config["enable_safety"],
            "contactEmail": config.config["contact_email"],
            "canSendMails": bool(config.config["smtp"]["host"]),
            "privileges": util.snake_case_to_lower_camel_case_keys(
                config.config["privileges"]
            ),
            "welcomeMessage": config.config.get("welcome_message", ""),
        },
    }
    if oauth.is_enabled():
        oauth_cfg = oauth.get_oauth_config()
        ret["config"]["oauth"] = {
            "enabled": True,
            "providerName": oauth_cfg.get("provider_name", "OAuth"),
            "providerIcon": oauth_cfg.get("provider_icon", ""),
        }

    if auth.has_privilege(ctx.user, "posts:view:featured"):
        ret["featuredPost"] = (
            posts.serialize_post(post_feature.post, ctx.user)
            if post_feature
            else None
        )
        ret["featuringUser"] = (
            users.serialize_user(post_feature.user, ctx.user)
            if post_feature
            else None
        )
        ret["featuringTime"] = post_feature.time if post_feature else None
    return ret
