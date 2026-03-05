# 👟 CALZADO J&R - Sistema de Gestión y Producción de Calzado

> Sistema de autenticación y gestión para fábrica de calzado con 3 roles: Administrador, Empleado y Cliente.

---

## 📋 Descripción

Sistema de gestión integral para CALZADO J&R que permite:

- Registro y validación de usuarios (Clientes y Empleados)
- Gestión de roles y permisos
- Control de inventario de insumos y productos
- Gestión de pedidos y asignación de tareas

---

## 🛠️ Stack Tecnológico

| Capa              | Tecnologías                                         |
| ----------------- | --------------------------------------------------- |
| **Backend**       | Python 3.12+, FastAPI, SQLAlchemy 2.0, Alembic, JWT |
| **Frontend**      | React 18+, Vite, TypeScript, TailwindCSS 4+         |
| **Base de datos** | PostgreSQL 17+ (Docker Compose)                     |
| **Testing**       | pytest + httpx (BE), Vitest + Testing Library (FE)  |

---

## 👥 Roles del Sistema

### 1. 🔧 Administrador

- Cuenta creada manualmente en la base de datos
- Valida cuentas de Clientes
- Crea cuentas de Empleados y envía credenciales por correo
- Puede crear más cuentas de Administrador
- Acceso completo al sistema

### 2. 👷 Empleado

- **NO puede registrarse por sí mismo**
- Cuenta creada SOLO por el Administrador o por el Jefe
- Recibe credenciales temporales por correo
- Debe cambiar contraseña en el primer inicio de sesión
- Ocupaciones: Jefe (gestión y validación), Cortador, Guarnecedor, Solador, Emplantillador
- Dashboard de tareas asignadas
- Campos: Nombres, Apellidos, Teléfono, Email, Ocupación

### 3. 👤 Cliente

- **Puede registrarse libremente** desde el formulario público
- Cuenta creada con `is_validated=False`
- Espera validación del Administrador para activar su cuenta
- Dashboard de pedidos y catálogo
- Campos: Nombres, Apellidos, Teléfono, Email, Contraseña, Nombre de comercio (opcional)

---

## ✅ Prerrequisitos

Antes de comenzar, asegúrate de tener instalado:

| Herramienta        | Versión mínima | Verificar con            |
| ------------------ | -------------- | ------------------------ |
| **Python**         | 3.12+          | `python --version`       |
| **uv**             | 0.1+           | `uv --version`           |
| **Node.js**        | 20 LTS+        | `node --version`         |
| **pnpm**           | 9+             | `pnpm --version`         |
| **Docker**         | 24+            | `docker --version`       |
| **Docker Compose** | 2.20+          | `docker compose version` |

---

## � Ejecución con Docker (recomendado)

> **¿Qué es Docker Compose?**
> Herramienta que define y ejecuta aplicaciones multi-contenedor. Un solo archivo
> `docker-compose.yml` describe todos los servicios (BD, backend, frontend), sus
> relaciones y configuración. Un solo comando los levanta todos en orden correcto.

### 1. Clonar el repositorio

```bash
git clone <url-del-repositorio>
cd calzado-jyr
```

### 2. Configurar variables de entorno

```bash
# Copiar la plantilla de variables de entorno
cp .env.example .env
```

Editar `.env` con tus valores reales. Los campos **obligatorios** de cambiar son:

| Variable            | Por defecto                     | Qué hacer                    |
| ------------------- | ------------------------------- | ---------------------------- |
| `POSTGRES_PASSWORD` | `cambia_esta_contrasena_segura` | Poner una contraseña real    |
| `SECRET_KEY`        | `CAMBIA_ESTO_...`               | Generar con el comando abajo |
| `MAIL_PASSWORD`     | `tu_contrasena_de_app_smtp`     | Credencial SMTP real         |

```bash
# Generar SECRET_KEY segura
python -c "import secrets; print(secrets.token_urlsafe(48))"
```

> **¿Por qué `.env` y no editar `docker-compose.yml` directamente?**
> El `docker-compose.yml` se versiona en git. Si pones las contraseñas ahí,
> quedan expuestas en el historial de commits. El `.env` está en `.gitignore`
> y **nunca** llega al repositorio.

### 3. Levantar el stack completo

```bash
# Construye las imágenes y levanta los 3 servicios en background
docker compose up -d --build

# Ver estado de los servicios
docker compose ps

# Ver logs en tiempo real (todos los servicios)
docker compose logs -f

# Ver logs solo del backend
docker compose logs -f be
```

Una vez levantado, los servicios están disponibles en:

| Servicio          | URL                        | Descripción                 |
| ----------------- | -------------------------- | --------------------------- |
| Frontend          | http://localhost:5173      | Interfaz React              |
| Backend API       | http://localhost:8000      | API REST FastAPI            |
| Documentación API | http://localhost:8000/docs | Swagger UI interactivo      |
| PostgreSQL        | localhost:5432             | Conexión directa (DB tools) |

> **¿Por qué `--build` en el primer arranque?**
> Docker Compose necesita construir las imágenes a partir de los Dockerfiles
> antes de iniciar los contenedores. Las veces siguientes, si el código no
> cambió, no es necesario: `docker compose up -d`.

### 4. Crear el usuario administrador inicial

```bash
# Ejecutar el script dentro del contenedor del backend
docker compose exec be python scripts/create_admin.py
```

> **¿Qué hace `docker compose exec`?**
> Ejecuta un comando dentro de un contenedor ya corriendo. `be` es el nombre
> del servicio en `docker-compose.yml`. El script `create_admin.py` crea el
> primer usuario admin directamente en la BD.

### 5. Comandos útiles del día a día

```bash
# Detener los servicios (conserva los datos)
docker compose down

# Detener Y BORRAR todos los datos de la BD (reset completo)
docker compose down -v

# Reconstruir solo el backend (después de cambiar pyproject.toml)
docker compose build be

# Conectarse al shell del contenedor de la BD
docker compose exec db psql -U jyr_user -d calzado_jyr_db

# Ver consumo de recursos de los contenedores
docker stats
```

---

## 🚀 Instalación sin Docker (desarrollo local)

> Solo necesario si no quieres usar Docker. Requiere Python 3.12+, Node.js 20+ y
> PostgreSQL 17+ instalados localmente.

### Backend

```bash
cd be

# Instalar uv (si aún no lo tienes)
pip install uv

# Instalar dependencias y crear entorno virtual automáticamente
uv sync

# Crear archivo .env desde plantilla
cp .env.example .env
# Editar .env: DATABASE_URL debe apuntar a tu PostgreSQL local

# Crear usuario administrador inicial
uv run python scripts/create_admin.py
```

### Frontend

```bash
cd fe

# Instalar dependencias
pnpm install

# Crear archivo .env desde plantilla
cp .env.example .env
```

---

## ▶️ Ejecución sin Docker

### Backend

```bash
cd be
uv run uvicorn app.main:app --reload
```

- API: http://localhost:8000
- Documentación: http://localhost:8000/docs

### Frontend

```bash
cd fe
pnpm run dev
```

- App: http://localhost:5173

---

## 🗄️ Estructura de Base de Datos

### Tabla `roles`

- id (UUID, PK)
- name (varchar: 'admin', 'employee', 'client')
- description (varchar)
- created_at (timestamp)
- updated_at (timestamp)
- deleted_at (timestamp, nullable) - Soft delete

### Tabla `users`

- id (UUID, PK)
- email (varchar, unique, index)
- hashed_password (varchar)
- name (varchar) - Nombres
- last_name (varchar) - Apellidos
- phone (varchar)
- identity_document (varchar) - Documento de identidad
- role_id (UUID, FK → roles)
- is_active (boolean, default False)
- is_validated (boolean, default False)
- must_change_password (boolean, default False) - Para empleados nuevos
- business_name (varchar, nullable) - Solo clientes
- occupation (occupation_type ENUM, nullable) - Solo empleados. Valores: 'jefe', 'cortador', 'guarnecedor', 'solador', 'emplantillador'
- created_at (timestamp)
- updated_at (timestamp)
- deleted_at (timestamp, nullable) - Soft delete
- validated_by (UUID, FK → users, nullable) - Qué admin validó
- validated_at (timestamp, nullable)

---

## 🔐 Autenticación

- **Método:** JWT (JSON Web Tokens)
- **Access Token:** 15 minutos
- **Refresh Token:** 7 días
- **Hashing:** bcrypt

### Flujo de Registro de Cliente

1. Cliente diligencia formulario de registro público
2. Cuenta creada con `is_validated=False` e `is_active=False`
3. Mensaje: "Cuenta creada exitosamente. Pendiente de validación por administrador"
4. Admin valida cuenta desde su dashboard
5. Sistema activa cuenta (`is_active=True`, `is_validated=True`)
6. Cliente puede hacer login

### Flujo de Creación de Empleado (por Admin)

1. Admin diligencia formulario de creación de empleado
2. Sistema genera contraseña temporal segura
3. Sistema envía email con credenciales (email + contraseña temporal)
4. Cuenta creada con `is_active=True`, `is_validated=True`, `must_change_password=True`
5. Empleado hace login con credenciales recibidas
6. Sistema fuerza cambio de contraseña antes de acceder al dashboard

### Flujo de Login

1. Ingresar email y contraseña
2. Sistema valida credenciales y estado de cuenta
3. Sistema detecta automáticamente el rol del usuario
4. Si es primer login de Empleado → forzar cambio de contraseña
5. Redirección automática según rol:
   - **Admin** → Dashboard administrativo
   - **Empleado** → Dashboard de tareas
   - **Cliente** → Dashboard de pedidos y catálogo

---

## 📂 Estructura del Proyecto

```
calzado-jyr/
├── docker-compose.yml          # Orquesta los 3 servicios (BD + BE + FE)
├── .env.example                # Plantilla de variables de entorno (raíz)
├── README.md                   # Este archivo
├── docs/                       # Documentación complementaria
│   └── manual-identidad-corporativa.md # Guía de colores, logos y marca
│
├── db/                         # Scripts SQL de la base de datos
│   └── init/
│       ├── 01_create_tables.sql       # Tablas, roles iniciales e índices básicos
│       └── 02_triggers_and_indexes.sql # Triggers updated_at, índices parciales y constraints
│
├── be/                         # Backend (FastAPI)
│   ├── Dockerfile              # Build multi-stage: base → dev → prod
│   ├── .dockerignore           # Excluye .venv, __pycache__, .env del contexto Docker
│   ├── .env.example            # Plantilla de variables para desarrollo sin Docker
│   ├── pyproject.toml          # Configuración de proyecto y dependencias Python
│   ├── uv.lock                 # Lock file para reproducibilidad exacta de dependencias
│   ├── app/
│   │   ├── models/             # Modelos ORM (Role, User, PasswordResetToken)
│   │   ├── schemas/            # Schemas Pydantic para validación
│   │   ├── routers/            # Endpoints (auth, users)
│   │   ├── services/           # Lógica de negocio
│   │   └── utils/              # Utilidades (security, email)
│   ├── alembic/                # Migraciones de BD (Alembic)
│   └── scripts/                # Scripts utilitarios (crear admin)
│
└── fe/                         # Frontend (React + Vite)
    ├── Dockerfile              # Build multi-stage: base → dev → builder → prod(nginx)
    ├── .dockerignore           # Excluye node_modules y dist del contexto Docker
    ├── nginx.conf              # Config nginx para SPA (React Router + caché de assets)
    ├── .env.example            # Plantilla VITE_API_URL
    ├── src/
    │   ├── pages/              # Páginas (Login, Dashboard, Register, etc.)
    │   ├── components/         # Componentes reutilizables
    │   ├── api/                # Clientes HTTP (axios)
    │   └── context/            # Estado global (AuthContext)
    └── package.json            # Dependencias Node.js
```

---

## 📄 Licencia

Proyecto académico - SENA

---

## 👨‍💻 Autor

CALZADO J&R - Sistema de Gestión
