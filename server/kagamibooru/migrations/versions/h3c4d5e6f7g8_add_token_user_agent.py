"""
add user_agent column to user_token

Revision ID: h3c4d5e6f7g8
Created at: 2026-05-10
"""

import sqlalchemy as sa
from alembic import op

revision = "h3c4d5e6f7g8"
down_revision = "g2b3c4d5e6f7"
branch_labels = None
depends_on = None


def upgrade():
    op.add_column(
        "user_token",
        sa.Column("user_agent", sa.Unicode(512), nullable=True),
    )


def downgrade():
    op.drop_column("user_token", "user_agent")
