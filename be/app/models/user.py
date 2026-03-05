"""
Módulo: models/user.py
Descripción: Modelo ORM que representa la tabla `users` en PostgreSQL.
¿Para qué? Definir la estructura de la tabla de usuarios con todos los campos
           necesarios para el sistema de CALZADO J&R.
¿Impacto? Cada registro en esta tabla representa un usuario del sistema.
"""

import uuid
from datetime import datetime

from sqlalchemy import Boolean, DateTime, Enum, ForeignKey, String, func
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.database import Base


class User(Base):
    """Modelo ORM para la tabla `users`."""

    __tablename__ = "users"

    # ────────────────────────────
    # 📌 Columnas principales
    # ────────────────────────────

    id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True),
        primary_key=True,
        default=uuid.uuid4,
    )

    email: Mapped[str] = mapped_column(
        String(255),
        unique=True,
        index=True,
        nullable=False,
    )

    hashed_password: Mapped[str] = mapped_column(
        String(255),
        nullable=False,
    )

    name: Mapped[str] = mapped_column(
        String(255),
        nullable=False,
    )

    last_name: Mapped[str] = mapped_column(
        String(255),
        nullable=False,
    )

    phone: Mapped[str | None] = mapped_column(
        String(20),
        nullable=True,
    )

    identity_document: Mapped[str | None] = mapped_column(
        String(20),
        nullable=True,
    )

    identity_document_type_id: Mapped[uuid.UUID | None] = mapped_column(
        UUID(as_uuid=True),
        ForeignKey("type_document.id"),
        nullable=True,
    )

    # ────────────────────────────
    # 🔗 Relaciones
    # ────────────────────────────

    identity_document_type = relationship("TypeDocument", back_populates="users", lazy="selectin")

    # ────────────────────────────
    # 🔗 Relación con roles
    # ────────────────────────────

    role_id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True),
        ForeignKey("roles.id"),
        nullable=False,
    )

    role = relationship("Role", lazy="selectin")

    # ────────────────────────────
    # 🔐 Estado de la cuenta
    # ────────────────────────────

    is_active: Mapped[bool] = mapped_column(
        Boolean,
        default=False,
        nullable=False,
    )

    is_validated: Mapped[bool] = mapped_column(
        Boolean,
        default=False,
        nullable=False,
    )

    must_change_password: Mapped[bool] = mapped_column(
        Boolean,
        default=False,
        nullable=False,
    )

    # ────────────────────────────
    # 📋 Campos específicos por rol
    # ────────────────────────────

    # Solo para clientes
    business_name: Mapped[str | None] = mapped_column(
        String(255),
        nullable=True,
    )

    # Solo para empleados (guarnición, solador, cortador, emplantillador)
    occupation: Mapped[str | None] = mapped_column(
        Enum("jefe", "cortador", "guarnecedor", "solador", "emplantillador", name="occupation_type"),
        nullable=True,
    )

    # ────────────────────────────
    # ✅ Validación por admin
    # ────────────────────────────

    validated_by: Mapped[uuid.UUID | None] = mapped_column(
        UUID(as_uuid=True),
        ForeignKey("users.id"),
        nullable=True,
    )

    validated_at: Mapped[datetime | None] = mapped_column(
        DateTime(timezone=True),
        nullable=True,
    )

    # ────────────────────────────
    # 🕐 Timestamps
    # ────────────────────────────

    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        server_default=func.now(),
        nullable=False,
    )

    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        server_default=func.now(),
        onupdate=func.now(),
        nullable=False,
    )

    deleted_at: Mapped[datetime | None] = mapped_column(
        DateTime(timezone=True),
        nullable=True,
    )

    def __repr__(self) -> str:
        return f"User(id={self.id}, email={self.email}, is_active={self.is_active})"
