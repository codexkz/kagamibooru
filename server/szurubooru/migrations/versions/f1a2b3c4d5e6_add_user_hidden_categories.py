"""
add user hidden_categories column

Revision ID: f1a2b3c4d5e6
Created at: 2026-05-10
"""

import sqlalchemy as sa
from alembic import op

revision = "f1a2b3c4d5e6"
down_revision = ("b1c2d3e4f5a6", "adcd63ff76a2")
branch_labels = None
depends_on = None


def upgrade():
    op.add_column(
        "user",
        sa.Column(
            "hidden_categories",
            sa.JSON,
            nullable=False,
            server_default='["nsfw"]',
        ),
    )


def downgrade():
    op.drop_column("user", "hidden_categories")
