import sqlalchemy as sa
from sqlalchemy.ext.associationproxy import association_proxy
from sqlalchemy.ext.orderinglist import ordering_list

from kagamibooru.model.base import Base


class FavoriteGroupPost(Base):
    __tablename__ = "favorite_group_post"

    favorite_group_id = sa.Column(
        "favorite_group_id",
        sa.Integer,
        sa.ForeignKey("favorite_group.id", ondelete="CASCADE"),
        nullable=False,
        primary_key=True,
        index=True,
    )
    post_id = sa.Column(
        "post_id",
        sa.Integer,
        sa.ForeignKey("post.id", ondelete="CASCADE"),
        nullable=False,
        primary_key=True,
        index=True,
    )
    order = sa.Column("ord", sa.Integer, nullable=False, default=0)
    time = sa.Column("time", sa.DateTime, nullable=True)

    group = sa.orm.relationship("FavoriteGroup", back_populates="_posts")
    post = sa.orm.relationship("Post")

    def __init__(self, post) -> None:
        self.post_id = post.post_id


class FavoriteGroup(Base):
    """A user-owned, private collection of posts (independent of the
    plain post_favorite "heart"). Many-to-many: a post may belong to
    multiple groups."""

    __tablename__ = "favorite_group"

    favorite_group_id = sa.Column("id", sa.Integer, primary_key=True)
    user_id = sa.Column(
        "user_id",
        sa.Integer,
        sa.ForeignKey("user.id", ondelete="CASCADE"),
        nullable=False,
        index=True,
    )
    name = sa.Column("name", sa.Unicode(128), nullable=False)
    description = sa.Column("description", sa.Unicode(2048), nullable=True)
    # The default group is the one the "favorite" (heart) shortcut targets.
    # Each user has exactly one; it is auto-created and cannot be deleted.
    is_default = sa.Column(
        "is_default", sa.Boolean, nullable=False, default=False
    )
    creation_time = sa.Column("creation_time", sa.DateTime, nullable=False)
    last_edit_time = sa.Column("last_edit_time", sa.DateTime, nullable=True)

    user = sa.orm.relationship("User", back_populates="favorite_groups")
    _posts = sa.orm.relationship(
        "FavoriteGroupPost",
        cascade="all, delete-orphan",
        lazy="select",
        back_populates="group",
        order_by="FavoriteGroupPost.order",
        collection_class=ordering_list("order"),
    )
    posts = association_proxy("_posts", "post")

    post_count = sa.orm.column_property(
        sa.sql.expression.select(
            sa.sql.expression.func.count(FavoriteGroupPost.post_id)
        )
        .where(FavoriteGroupPost.favorite_group_id == favorite_group_id)
        .scalar_subquery(),
        deferred=True,
    )

    __table_args__ = (
        sa.UniqueConstraint(
            "user_id", "name", name="uq_favorite_group_user_name"
        ),
    )
