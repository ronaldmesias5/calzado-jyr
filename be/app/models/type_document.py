"""
Módulo: models/type_document.py
Descripción: Modelo ORM que representa los tipos de documentos de identidad válidos.
¿Para qué? Categorizar los tipos de documentos que pueden usar los usuarios.
¿Impacto? Los usuarios deben seleccionar un tipo de documento válido.
"""

import uuid

from sqlalchemy import String
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.database import Base


class TypeDocument(Base):
    """Modelo ORM para la tabla `type_document` de tipos de documentos."""

    __tablename__ = "type_document"

    id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True),
        primary_key=True,
        default=uuid.uuid4,
    )

    name: Mapped[str] = mapped_column(
        String(100),
        unique=True,
        nullable=False,
        index=True,
    )

    # Relación inversa con usuarios
    users = relationship("User", back_populates="identity_document_type")
