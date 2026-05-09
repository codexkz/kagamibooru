import sqlalchemy as sa

from kagamibooru.db import get_session
from kagamibooru.model.base import Base


class CommentScore(Base):
    __tablename__ = "comment_score"

    comment_id = sa.Column(
        "comment_id",
        sa.Integer,
        sa.ForeignKey("comment.id"),
        nullable=False,
        primary_key=True,
    )
    user_id = sa.Column(
        "user_id",
        sa.Integer,
        sa.ForeignKey("user.id"),
        nullable=False,
        primary_key=True,
        index=True,
    )
    time = sa.Column("time", sa.DateTime, nullable=False)
    score = sa.Column("score", sa.Integer, nullable=False)

    comment = sa.orm.relationship("Comment")
    user = sa.orm.relationship("User", back_populates="comment_scores")


class Comment(Base):
    __tablename__ = "comment"

    comment_id = sa.Column("id", sa.Integer, primary_key=True)
    post_id = sa.Column(
        "post_id",
        sa.Integer,
        sa.ForeignKey("post.id"),
        nullable=False,
        index=True,
    )
    user_id = sa.Column(
        "user_id",
        sa.Integer,
        sa.ForeignKey("user.id", ondelete="SET NULL"),
        nullable=True,
        index=True,
    )
    version = sa.Column("version", sa.Integer, default=1, nullable=False)
    creation_time = sa.Column("creation_time", sa.DateTime, nullable=False)
    last_edit_time = sa.Column("last_edit_time", sa.DateTime)
    text = sa.Column("text", sa.UnicodeText, default=None)

    user = sa.orm.relationship("User", back_populates="comments")
    post = sa.orm.relationship("Post", back_populates="comments")
    scores = sa.orm.relationship(
        "CommentScore", cascade="all, delete-orphan", lazy="joined"
    )

    @property
    def score(self) -> int:
        return (
            get_session()
            .query(sa.sql.expression.func.sum(CommentScore.score))
            .filter(CommentScore.comment_id == self.comment_id)
            .one()[0]
            or 0
        )

    __mapper_args__ = {
        "version_id_col": version,
        "version_id_generator": False,
    }
