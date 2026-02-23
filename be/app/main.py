"""
Módulo: main.py
Descripción: Punto de entrada de la aplicación FastAPI — configura y arranca el servidor.
¿Para qué? Crear la instancia principal de FastAPI, configurar CORS, incluir routers.
¿Impacto? Este es el archivo que Uvicorn ejecuta. Sin él, no hay servidor.
"""

from contextlib import asynccontextmanager
from collections.abc import AsyncGenerator

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.config import settings
from app.database import engine, Base
from app.routers.auth import router as auth_router
from app.routers.users import router as users_router

# Importar modelos para que SQLAlchemy los registre en Base.metadata
from app.models import role, user, password_reset_token  # noqa: F401


@asynccontextmanager
async def lifespan(app: FastAPI) -> AsyncGenerator[None, None]:
    """Gestiona el ciclo de vida de la aplicación FastAPI."""
    print("🚀 CALZADO J&R — Backend iniciando...")
    Base.metadata.create_all(bind=engine)
    print("✅ Tablas verificadas / creadas correctamente.")
    print(f"📡 CORS habilitado para: {settings.FRONTEND_URL}")
    yield
    print("🛑 CALZADO J&R — Backend cerrando...")


app = FastAPI(
    title="CALZADO J&R API",
    description=(
        "👟 Sistema de gestión y producción de calzado. "
        "Incluye registro, login, cambio y recuperación de contraseña. "
        "Proyecto educativo — SENA."
    ),
    version="0.1.0",
    docs_url="/docs",
    redoc_url="/redoc",
    lifespan=lifespan,
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=[
        settings.FRONTEND_URL,
    ],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# ────────────────────────────
# 📍 Incluir routers
# ────────────────────────────
app.include_router(auth_router)
app.include_router(users_router)


# ────────────────────────────
# 📍 Endpoint de salud (health check)
# ────────────────────────────
@app.get(
    "/api/v1/health",
    tags=["health"],
    summary="Verificar estado del servidor",
)
async def health_check() -> dict[str, str]:
    """Endpoint de verificación de salud del servidor."""
    return {
        "status": "healthy",
        "project": "CALZADO J&R",
        "version": "0.1.0",
    }
