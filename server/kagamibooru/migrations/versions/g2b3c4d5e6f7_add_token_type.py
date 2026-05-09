"""
add token type column

Revision ID: g2b3c4d5e6f7
Created at: 2026-05-10
"""

import sqlalchemy as sa
from alembic import op

revision = "g2b3c4d5e6f7"
down_revision = "f1a2b3c4d5e6"
branch_labels = None
depends_on = None


def upgrade():
    op.add_column(
        "user_token",
        sa.Column("type", sa.Unicode(16), nullable=False, server_default="api"),
    )
    # Migrate existing Web Login Tokens
    op.execute(
        "UPDATE user_token SET type = 'web' WHERE note = 'Web Login Token'"
    )


def downgrade():
    op.drop_column("user_token", "type")
