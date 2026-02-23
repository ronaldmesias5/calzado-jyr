"""
Módulo: database.py
Descripción: Configuración de la conexión a PostgreSQL con SQLAlchemy 2.0.
¿Para qué? Proveer el engine, la sesión y la clase base que todos los modelos ORM heredan.
¿Impacto? Este módulo es el puente entre Python y PostgreSQL.
"""

from sqlalchemy import create_engine
from sqlalchemy.orm import DeclarativeBase, sessionmaker

from app.config import settings

engine = create_engine(
    settings.DATABASE_URL,
    pool_pre_ping=True,
    echo=False,
)

SessionLocal = sessionmaker(
    autocommit=False,
    autoflush=False,
    bind=engine,
)


class Base(DeclarativeBase):
    """Clase base para todos los modelos ORM del proyecto."""
    pass
