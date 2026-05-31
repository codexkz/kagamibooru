"""
Add is_default flag to favorite_group (the heart-shortcut target group)

Revision ID: n9i0j1k2l3m4
Created at: 2026-05-31
"""

import sqlalchemy as sa
from alembic import op

revision = "n9i0j1k2l3m4"
down_revision = "m8h9i0j1k2l3"
branch_labels = None
depends_on = None


def upgrade():
    op.add_column(
        "favorite_group",
        sa.Column(
            "is_default",
            sa.Boolean(),
            nullable=False,
            server_default=sa.false(),
        ),
    )


def downgrade():
    op.drop_column("favorite_group", "is_default")
