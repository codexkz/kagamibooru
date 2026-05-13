"""
add user_oauth table for OAuth 2.0 login

Revision ID: i4d5e6f7g8h9
Created at: 2026-05-11
"""

import sqlalchemy as sa
from alembic import op

revision = "i4d5e6f7g8h9"
down_revision = "h3c4d5e6f7g8"
branch_labels = None
depends_on = None


def upgrade():
    op.create_table(
        "user_oauth",
        sa.Column("id", sa.Integer, primary_key=True),
        sa.Column(
            "user_id",
            sa.Integer,
            sa.ForeignKey("user.id", ondelete="CASCADE"),
            nullable=False,
            index=True,
        ),
        sa.Column("provider", sa.Unicode(64), nullable=False),
        sa.Column("oauth_sub", sa.Unicode(256), nullable=False),
        sa.Column("creation_time", sa.DateTime, nullable=False),
        sa.UniqueConstraint("provider", "oauth_sub", name="uq_user_oauth_provider_sub"),
    )


def downgrade():
    op.drop_table("user_oauth")
