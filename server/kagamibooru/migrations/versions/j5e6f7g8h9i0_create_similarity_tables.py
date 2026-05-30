"""
Create similarity scan tables (and merge oauth + tag-category-m2m heads)

Revision ID: j5e6f7g8h9i0
Created at: 2026-05-30
"""

import sqlalchemy as sa
from alembic import op

revision = "j5e6f7g8h9i0"
down_revision = ("i4d5e6f7g8h9", "b1c2d3e4f5a6")
branch_labels = None
depends_on = None


def upgrade():
    op.create_table(
        "similarity_scan",
        sa.Column("id", sa.Integer(), nullable=False),
        sa.Column("creation_time", sa.DateTime(), nullable=False),
        sa.Column("finish_time", sa.DateTime(), nullable=True),
        sa.Column("status", sa.Unicode(32), nullable=False),
        sa.Column("threshold", sa.Float(), nullable=False),
        sa.Column("processed_count", sa.Integer(), nullable=False),
        sa.Column("total_count", sa.Integer(), nullable=False),
        sa.Column("group_count", sa.Integer(), nullable=False),
        sa.Column("user_id", sa.Integer(), nullable=True),
        sa.Column("error", sa.Unicode(2048), nullable=True),
        sa.ForeignKeyConstraint(
            ["user_id"], ["user.id"], ondelete="SET NULL"
        ),
        sa.PrimaryKeyConstraint("id"),
    )
    op.create_index(
        "ix_similarity_scan_user_id", "similarity_scan", ["user_id"]
    )

    op.create_table(
        "similarity_group",
        sa.Column("id", sa.Integer(), nullable=False),
        sa.Column("scan_id", sa.Integer(), nullable=False),
        sa.Column("status", sa.Unicode(32), nullable=False),
        sa.Column("keep_post_id", sa.Integer(), nullable=True),
        sa.Column("creation_time", sa.DateTime(), nullable=False),
        sa.ForeignKeyConstraint(
            ["scan_id"], ["similarity_scan.id"], ondelete="CASCADE"
        ),
        sa.ForeignKeyConstraint(
            ["keep_post_id"], ["post.id"], ondelete="SET NULL"
        ),
        sa.PrimaryKeyConstraint("id"),
    )
    op.create_index(
        "ix_similarity_group_scan_id", "similarity_group", ["scan_id"]
    )

    op.create_table(
        "similarity_group_post",
        sa.Column("id", sa.Integer(), nullable=False),
        sa.Column("scan_id", sa.Integer(), nullable=False),
        sa.Column("group_id", sa.Integer(), nullable=False),
        sa.Column("post_id", sa.Integer(), nullable=False),
        sa.Column("distance", sa.Float(), nullable=False),
        sa.Column("action", sa.Unicode(32), nullable=False),
        sa.Column("dismissed", sa.Boolean(), nullable=False),
        sa.ForeignKeyConstraint(
            ["scan_id"], ["similarity_scan.id"], ondelete="CASCADE"
        ),
        sa.ForeignKeyConstraint(
            ["group_id"], ["similarity_group.id"], ondelete="CASCADE"
        ),
        sa.ForeignKeyConstraint(
            ["post_id"], ["post.id"], ondelete="CASCADE"
        ),
        sa.PrimaryKeyConstraint("id"),
        sa.UniqueConstraint(
            "scan_id", "post_id", name="uq_similarity_group_post_scan_post"
        ),
    )
    op.create_index(
        "ix_similarity_group_post_scan_id",
        "similarity_group_post",
        ["scan_id"],
    )
    op.create_index(
        "ix_similarity_group_post_group_id",
        "similarity_group_post",
        ["group_id"],
    )
    op.create_index(
        "ix_similarity_group_post_post_id",
        "similarity_group_post",
        ["post_id"],
    )


def downgrade():
    op.drop_table("similarity_group_post")
    op.drop_table("similarity_group")
    op.drop_table("similarity_scan")
