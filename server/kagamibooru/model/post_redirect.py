import sqlalchemy as sa

from kagamibooru.model.base import Base


class PostRedirect(Base):
    """Maps a deleted (merged-away) post id to the post it was merged into.

    Created when a post is merged into another, so that old links /
    bookmarks to /post/{old} can be redirected to the surviving post
    instead of 404ing.
    """

    __tablename__ = "post_redirect"

    old_post_id = sa.Column("old_post_id", sa.Integer, primary_key=True)
    new_post_id = sa.Column(
        "new_post_id",
        sa.Integer,
        sa.ForeignKey("post.id", ondelete="CASCADE"),
        nullable=False,
        index=True,
    )
    creation_time = sa.Column("creation_time", sa.DateTime, nullable=False)

    new_post = sa.orm.relationship("Post")
