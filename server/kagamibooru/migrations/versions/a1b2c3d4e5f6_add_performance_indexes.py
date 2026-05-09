"""
add performance indexes

Revision ID: a1b2c3d4e5f6
Created at: 2026-05-07 12:00:00.000000
"""

import sqlalchemy as sa
from alembic import op

revision = "a1b2c3d4e5f6"
down_revision = "5b5c940b4e78"
branch_labels = None
depends_on = None


def upgrade():
    op.create_index(
        op.f("ix_pool_post_pool_id"), "pool_post", ["pool_id"], unique=False
    )
    op.create_index(
        op.f("ix_pool_name_pool_id"), "pool_name", ["pool_id"], unique=False
    )
    op.create_index(
        op.f("ix_pool_category_id"), "pool", ["category_id"], unique=False
    )
    op.create_index(
        op.f("ix_post_checksum"), "post", ["checksum"], unique=False
    )
    op.create_index(
        op.f("ix_post_checksum_md5"), "post", ["checksum_md5"], unique=False
    )
    op.create_index(
        op.f("ix_post_safety"), "post", ["safety"], unique=False
    )
    op.create_index(
        op.f("ix_post_type"), "post", ["type"], unique=False
    )
    op.create_index(
        op.f("ix_post_feature_time"), "post_feature", ["time"], unique=False
    )
    op.create_index(
        op.f("ix_snapshot_user_id"), "snapshot", ["user_id"], unique=False
    )


def downgrade():
    op.drop_index(op.f("ix_snapshot_user_id"), table_name="snapshot")
    op.drop_index(op.f("ix_post_feature_time"), table_name="post_feature")
    op.drop_index(op.f("ix_post_type"), table_name="post")
    op.drop_index(op.f("ix_post_safety"), table_name="post")
    op.drop_index(op.f("ix_post_checksum_md5"), table_name="post")
    op.drop_index(op.f("ix_post_checksum"), table_name="post")
    op.drop_index(op.f("ix_pool_category_id"), table_name="pool")
    op.drop_index(op.f("ix_pool_name_pool_id"), table_name="pool_name")
    op.drop_index(op.f("ix_pool_post_pool_id"), table_name="pool_post")
