import sqlalchemy as sa

from kagamibooru.model.base import Base


class SimilarityScan(Base):
    __tablename__ = "similarity_scan"

    STATUS_RUNNING = "running"
    STATUS_DONE = "done"
    STATUS_FAILED = "failed"

    KIND_FULL = "full"
    KIND_SINGLE = "single"

    scan_id = sa.Column("id", sa.Integer, primary_key=True)
    kind = sa.Column(
        "kind", sa.Unicode(16), nullable=False, default=KIND_FULL
    )
    query_post_id = sa.Column(
        "query_post_id",
        sa.Integer,
        sa.ForeignKey("post.id", ondelete="SET NULL"),
        nullable=True,
    )
    query_label = sa.Column("query_label", sa.Unicode(512), nullable=True)
    creation_time = sa.Column("creation_time", sa.DateTime, nullable=False)
    finish_time = sa.Column("finish_time", sa.DateTime, nullable=True)
    status = sa.Column(
        "status",
        sa.Unicode(32),
        nullable=False,
        default=STATUS_RUNNING,
    )
    threshold = sa.Column("threshold", sa.Float, nullable=False)
    processed_count = sa.Column(
        "processed_count", sa.Integer, nullable=False, default=0
    )
    total_count = sa.Column(
        "total_count", sa.Integer, nullable=False, default=0
    )
    group_count = sa.Column(
        "group_count", sa.Integer, nullable=False, default=0
    )
    user_id = sa.Column(
        "user_id",
        sa.Integer,
        sa.ForeignKey("user.id", ondelete="SET NULL"),
        nullable=True,
        index=True,
    )
    error = sa.Column("error", sa.Unicode(2048), nullable=True)

    user = sa.orm.relationship("User")
    query_post = sa.orm.relationship("Post")
    groups = sa.orm.relationship(
        "SimilarityGroup",
        back_populates="scan",
        cascade="all, delete-orphan",
        passive_deletes=True,
    )


class SimilarityGroup(Base):
    __tablename__ = "similarity_group"

    STATUS_PENDING = "pending"
    STATUS_RESOLVED = "resolved"
    STATUS_IGNORED = "ignored"

    group_id = sa.Column("id", sa.Integer, primary_key=True)
    scan_id = sa.Column(
        "scan_id",
        sa.Integer,
        sa.ForeignKey("similarity_scan.id", ondelete="CASCADE"),
        nullable=False,
        index=True,
    )
    status = sa.Column(
        "status",
        sa.Unicode(32),
        nullable=False,
        default=STATUS_PENDING,
    )
    keep_post_id = sa.Column(
        "keep_post_id",
        sa.Integer,
        sa.ForeignKey("post.id", ondelete="SET NULL"),
        nullable=True,
    )
    creation_time = sa.Column("creation_time", sa.DateTime, nullable=False)

    scan = sa.orm.relationship("SimilarityScan", back_populates="groups")
    keep_post = sa.orm.relationship("Post")
    members = sa.orm.relationship(
        "SimilarityGroupPost",
        back_populates="group",
        cascade="all, delete-orphan",
        passive_deletes=True,
    )


class SimilarityGroupPost(Base):
    __tablename__ = "similarity_group_post"

    ACTION_NONE = "none"
    ACTION_DELETE = "delete"

    similarity_group_post_id = sa.Column("id", sa.Integer, primary_key=True)
    scan_id = sa.Column(
        "scan_id",
        sa.Integer,
        sa.ForeignKey("similarity_scan.id", ondelete="CASCADE"),
        nullable=False,
        index=True,
    )
    group_id = sa.Column(
        "group_id",
        sa.Integer,
        sa.ForeignKey("similarity_group.id", ondelete="CASCADE"),
        nullable=False,
        index=True,
    )
    post_id = sa.Column(
        "post_id",
        sa.Integer,
        sa.ForeignKey("post.id", ondelete="CASCADE"),
        nullable=False,
        index=True,
    )
    distance = sa.Column("distance", sa.Float, nullable=False, default=0.0)
    action = sa.Column(
        "action",
        sa.Unicode(32),
        nullable=False,
        default=ACTION_NONE,
    )
    dismissed = sa.Column(
        "dismissed", sa.Boolean, nullable=False, default=False
    )

    __table_args__ = (
        sa.UniqueConstraint(
            "scan_id", "post_id", name="uq_similarity_group_post_scan_post"
        ),
    )

    group = sa.orm.relationship("SimilarityGroup", back_populates="members")
    post = sa.orm.relationship("Post")
