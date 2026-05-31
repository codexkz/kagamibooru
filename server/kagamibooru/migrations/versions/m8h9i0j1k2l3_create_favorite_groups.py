"""
Create favorite_group tables (user-owned post collections)

Revision ID: m8h9i0j1k2l3
Created at: 2026-05-31
"""

import sqlalchemy as sa
from alembic import op

revision = "m8h9i0j1k2l3"
down_revision = "l7g8h9i0j1k2"
branch_labels = None
depends_on = None


def upgrade():
    op.create_table(
        "favorite_group",
        sa.Column("id", sa.Integer(), nullable=False),
        sa.Column("user_id", sa.Integer(), nullable=False),
        sa.Column("name", sa.Unicode(128), nullable=False),
        sa.Column("description", sa.Unicode(2048), nullable=True),
        sa.Column("creation_time", sa.DateTime(), nullable=False),
        sa.Column("last_edit_time", sa.DateTime(), nullable=True),
        sa.ForeignKeyConstraint(
            ["user_id"], ["user.id"], ondelete="CASCADE"
        ),
        sa.PrimaryKeyConstraint("id"),
        sa.UniqueConstraint(
            "user_id", "name", name="uq_favorite_group_user_name"
        ),
    )
    op.create_index(
        "ix_favorite_group_user_id", "favorite_group", ["user_id"]
    )

    op.create_table(
        "favorite_group_post",
        sa.Column("favorite_group_id", sa.Integer(), nullable=False),
        sa.Column("post_id", sa.Integer(), nullable=False),
        sa.Column("ord", sa.Integer(), nullable=False),
        sa.Column("time", sa.DateTime(), nullable=True),
        sa.ForeignKeyConstraint(
            ["favorite_group_id"],
            ["favorite_group.id"],
            ondelete="CASCADE",
        ),
        sa.ForeignKeyConstraint(
            ["post_id"], ["post.id"], ondelete="CASCADE"
        ),
        sa.PrimaryKeyConstraint("favorite_group_id", "post_id"),
    )
    op.create_index(
        "ix_favorite_group_post_favorite_group_id",
        "favorite_group_post",
        ["favorite_group_id"],
    )
    op.create_index(
        "ix_favorite_group_post_post_id",
        "favorite_group_post",
        ["post_id"],
    )


def downgrade():
    op.drop_table("favorite_group_post")
    op.drop_table("favorite_group")
