"""
Drop post_favorite table — favorites are now favorite groups

The plain heart/favorite is replaced by user-owned favorite groups; the
"star" is a shortcut for the default group. Old post_favorite data is
intentionally discarded (not migrated).

Revision ID: o0j1k2l3m4n5
Created at: 2026-05-31
"""

import sqlalchemy as sa
from alembic import op

revision = "o0j1k2l3m4n5"
down_revision = "n9i0j1k2l3m4"
branch_labels = None
depends_on = None


def upgrade():
    op.drop_table("post_favorite")


def downgrade():
    op.create_table(
        "post_favorite",
        sa.Column("post_id", sa.Integer(), nullable=False),
        sa.Column("user_id", sa.Integer(), nullable=False),
        sa.Column("time", sa.DateTime(), nullable=False),
        sa.ForeignKeyConstraint(["post_id"], ["post.id"]),
        sa.ForeignKeyConstraint(["user_id"], ["user.id"]),
        sa.PrimaryKeyConstraint("post_id", "user_id"),
    )
