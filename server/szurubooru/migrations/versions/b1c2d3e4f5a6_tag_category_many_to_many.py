"""
tag category many to many

Revision ID: b1c2d3e4f5a6
Created at: 2026-05-07 18:00:00.000000
"""

import sqlalchemy as sa
from alembic import op

revision = "b1c2d3e4f5a6"
down_revision = "a1b2c3d4e5f6"
branch_labels = None
depends_on = None


def upgrade():
    # Create junction table
    op.create_table(
        "tag_tag_category",
        sa.Column(
            "tag_id",
            sa.Integer,
            sa.ForeignKey("tag.id", ondelete="CASCADE"),
            nullable=False,
        ),
        sa.Column(
            "category_id",
            sa.Integer,
            sa.ForeignKey("tag_category.id", ondelete="CASCADE"),
            nullable=False,
        ),
        sa.PrimaryKeyConstraint("tag_id", "category_id"),
    )
    op.create_index(
        op.f("ix_tag_tag_category_tag_id"),
        "tag_tag_category",
        ["tag_id"],
        unique=False,
    )
    op.create_index(
        op.f("ix_tag_tag_category_category_id"),
        "tag_tag_category",
        ["category_id"],
        unique=False,
    )

    # Migrate existing data from tag.category_id into junction table
    op.execute(
        """
        INSERT INTO tag_tag_category (tag_id, category_id)
        SELECT id, category_id FROM tag WHERE category_id IS NOT NULL
        """
    )

    # Drop the old FK and make category_id nullable (keep column for safety)
    op.drop_constraint("tag_category_id_fkey", "tag", type_="foreignkey")
    op.alter_column("tag", "category_id", nullable=True)


def downgrade():
    # Restore FK
    op.alter_column("tag", "category_id", nullable=False)
    op.create_foreign_key(
        "tag_category_id_fkey", "tag", "tag_category", ["category_id"], ["id"]
    )

    # Drop junction table
    op.drop_index(
        op.f("ix_tag_tag_category_category_id"), table_name="tag_tag_category"
    )
    op.drop_index(
        op.f("ix_tag_tag_category_tag_id"), table_name="tag_tag_category"
    )
    op.drop_table("tag_tag_category")
