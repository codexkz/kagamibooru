import logging
import os
import threading
from typing import Dict

import sqlalchemy as sa

from kagamibooru import config, rest
from kagamibooru.func import auth, mime, pools, posts
from kagamibooru.model.pool import PoolPost
from kagamibooru.model.post import Post
from kagamibooru.rest import errors

logger = logging.getLogger(__name__)


@rest.routes.post("/cache/warmup/?")
def warmup_cache(
    ctx: rest.Context, _params: Dict[str, str] = {}
) -> rest.Response:
    from kagamibooru import db

    auth.verify_privilege(ctx.user, "cache:warmup")

    pool_name = ctx.get_param_as_string("pool", default="")

    if pool_name:
        pool = pools.get_pool_by_name(pool_name)
        rows = (
            db.session.query(Post.post_id, Post.mime_type)
            .join(PoolPost, PoolPost.post_id == Post.post_id)
            .filter(PoolPost.pool_id == pool.pool_id)
            .all()
        )
    else:
        rows = (
            db.session.query(Post.post_id, Post.mime_type)
            .all()
        )

    paths = []
    for post_id, mime_type in rows:
        ext = mime.get_extension(mime_type) or "dat"
        security_hash = posts.get_post_security_hash(post_id)
        subdir = security_hash[0:2]
        paths.append(f"posts/{subdir}/{post_id}_{security_hash}.{ext}")
        paths.append(f"generated-thumbnails/{subdir}/{post_id}_{security_hash}.jpg")

    data_dir = config.config["data_dir"]

    def _warmup(file_paths: list) -> None:
        warmed = 0
        for rel_path in file_paths:
            full_path = os.path.join(data_dir, rel_path)
            try:
                with open(full_path, "rb") as f:
                    while f.read(65536):
                        pass
                warmed += 1
            except OSError:
                pass
        logger.info(
            "Cache warmup complete: %d/%d files", warmed, len(file_paths)
        )

    thread = threading.Thread(target=_warmup, args=(paths,), daemon=True)
    thread.start()

    return {
        "message": "Cache warmup started",
        "pool": pool_name or "(all)",
        "fileCount": len(paths),
    }
