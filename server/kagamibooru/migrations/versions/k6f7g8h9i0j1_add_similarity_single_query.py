"""
Add single-image query columns to similarity_scan

Revision ID: k6f7g8h9i0j1
Created at: 2026-05-31
"""

import sqlalchemy as sa
from alembic import op

revision = "k6f7g8h9i0j1"
down_revision = "j5e6f7g8h9i0"
branch_labels = None
depends_on = None


def upgrade():
    op.add_column(
        "similarity_scan",
        sa.Column(
            "kind",
            sa.Unicode(16),
            nullable=False,
            server_default="full",
        ),
    )
    op.add_column(
        "similarity_scan",
        sa.Column("query_post_id", sa.Integer(), nullable=True),
    )
    op.add_column(
        "similarity_scan",
        sa.Column("query_label", sa.Unicode(512), nullable=True),
    )
    op.create_foreign_key(
        "fk_similarity_scan_query_post",
        "similarity_scan",
        "post",
        ["query_post_id"],
        ["id"],
        ondelete="SET NULL",
    )


def downgrade():
    op.drop_constraint(
        "fk_similarity_scan_query_post", "similarity_scan", type_="foreignkey"
    )
    op.drop_column("similarity_scan", "query_label")
    op.drop_column("similarity_scan", "query_post_id")
    op.drop_column("similarity_scan", "kind")
