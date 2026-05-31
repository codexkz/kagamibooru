"""
Create post_redirect table (merged-post id -> surviving post)

Revision ID: l7g8h9i0j1k2
Created at: 2026-05-31
"""

import sqlalchemy as sa
from alembic import op

revision = "l7g8h9i0j1k2"
down_revision = "k6f7g8h9i0j1"
branch_labels = None
depends_on = None


def upgrade():
    op.create_table(
        "post_redirect",
        sa.Column("old_post_id", sa.Integer(), nullable=False),
        sa.Column("new_post_id", sa.Integer(), nullable=False),
        sa.Column("creation_time", sa.DateTime(), nullable=False),
        sa.ForeignKeyConstraint(
            ["new_post_id"], ["post.id"], ondelete="CASCADE"
        ),
        sa.PrimaryKeyConstraint("old_post_id"),
    )
    op.create_index(
        "ix_post_redirect_new_post_id", "post_redirect", ["new_post_id"]
    )


def downgrade():
    op.drop_table("post_redirect")
