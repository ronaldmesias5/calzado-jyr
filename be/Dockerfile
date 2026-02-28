# ============================================================
# CALZADO J&R — Dockerfile Backend (FastAPI + Uvicorn)
# ============================================================
# ¿Qué?    Imagen Docker multi-stage para el backend Python.
# ¿Para?   Empaquetar la aplicación con sus dependencias en una
#           imagen reproducible y ligera (slim).
# ¿Impacto? Elimina el "en mi máquina funciona": todos ejecutan
#           exactamente el mismo Python 3.12, mismas librerías,
#           misma configuración. Multi-stage reduce el tamaño
#           final al separar construcción de ejecución.
# ============================================================

# ────────────────────────────
# Stage 1 — base
# ¿Por qué "slim"? La imagen slim excluye utilidades del SO
# que no necesita una API (compiladores, man pages, etc.),
# reduciendo la superficie de ataque y el tamaño de imagen.
# ────────────────────────────
FROM python:3.12-slim AS base

# PYTHONDONTWRITEBYTECODE=1 → No genera archivos .pyc (bytecode cache).
#   ¿Impacto? Menos archivos en el contenedor; necesario porque el código
#             ya viene copiado/montado y el cache no sirve entre builds.
# PYTHONUNBUFFERED=1 → Los logs (print/logging) se escriben inmediatamente
#   ¿Impacto? Los logs aparecen en tiempo real en `docker compose logs`.
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

# Copiar SOLO requirements primero para aprovechar la caché de capas de Docker.
# ¿Por qué? Si el código cambia pero requirements.txt no, Docker reutiliza
#           la capa de pip install → builds mucho más rápidos.
COPY requirements.txt .

RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir -r requirements.txt

# ────────────────────────────
# Stage 2 — dev
# ¿Qué?    Target para desarrollo local con Docker Compose.
# ¿Para?   El código se monta como volumen (./be:/app) para
#           que --reload detecte cambios en tiempo real sin
#           reconstruir la imagen.
# ¿Impacto? Ciclo de desarrollo ágil: guardas un archivo → la
#           API se reinicia automáticamente en ~1 segundo.
# ────────────────────────────
FROM base AS dev

EXPOSE 8000

# --reload: Uvicorn reinicia al detectar cambios en archivos Python.
# --host 0.0.0.0: Escucha en todas las interfaces, no solo localhost
#   dentro del contenedor (necesario para que el host pueda conectarse).
CMD ["uvicorn", "app.main:app", \
     "--host", "0.0.0.0", \
     "--port", "8000", \
     "--reload"]

# ────────────────────────────
# Stage 3 — prod
# ¿Qué?    Target para despliegue en producción.
# ¿Para?   Imagen autónoma con el código incluido (sin volúmenes)
#           y múltiples workers para manejar más tráfico.
# ¿Impacto? --workers 2 permite atender 2 peticiones en paralelo.
#           Ajustar según RAM: regla práctica = (2 × CPU cores) + 1.
# ────────────────────────────
FROM base AS prod

# Copiar código fuente dentro de la imagen
COPY . .

EXPOSE 8000

CMD ["uvicorn", "app.main:app", \
     "--host", "0.0.0.0", \
     "--port", "8000", \
     "--workers", "2"]
