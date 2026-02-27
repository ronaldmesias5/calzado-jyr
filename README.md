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

| Capa        | Tecnologías                                         |
| ----------- | --------------------------------------------------- |
| **Backend** | Python 3.12+, FastAPI, SQLAlchemy 2.0, Alembic, JWT |
| **Frontend**| React 18+, Vite, TypeScript, TailwindCSS 4+         |
| **Base de datos** | PostgreSQL 17+ (Docker Compose)                |
| **Testing** | pytest + httpx (BE), Vitest + Testing Library (FE)  |

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
- Cuenta creada SOLO por el Administrador
- Recibe credenciales temporales por correo
- Debe cambiar contraseña en el primer inicio de sesión
- Ocupaciones: Guarnición, Solador, Cortador, Emplantillador
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

| Herramienta     | Versión mínima | Verificar con              |
| --------------- | -------------- | -------------------------- |
| **Python**      | 3.12+          | `python --version`        |
| **Node.js**     | 20 LTS+        | `node --version`           |
| **pnpm**        | 9+             | `pnpm --version`           |
| **Docker**      | 24+            | `docker --version`         |
| **Docker Compose** | 2.20+       | `docker compose version`   |

---


## 🚀 Instalación y Setup

### 1. Clonar el repositorio

```bash
git clone <url-del-repositorio>
cd calzado-jyr
```


### 2. Levantar la base de datos

```bash
# Inicia PostgreSQL 17 en Docker
docker compose up -d

# Verificar que está corriendo
docker compose ps
```

**Credenciales de conexión (por defecto):**

- Usuario: `jyr_user`
- Contraseña: *(vacía, sin contraseña)*
- Base de datos: `calzado_jyr_db`

> ⚠️ Por facilidad de pruebas, la base de datos no requiere contraseña. Si necesitas mayor seguridad, puedes establecer una contraseña en el archivo `docker-compose.yml`.

### 3. Inicializar la base de datos (opcional)

El proyecto incluye una carpeta `db/` con scripts SQL de inicialización. Si necesitas crear las tablas manualmente o restaurar el estado inicial, puedes ejecutar los scripts de `db/init/`:

```bash
# (Opcional) Ejecutar scripts SQL manualmente si no usas Alembic
# Ejemplo usando psql:
psql -h localhost -U <usuario> -d <nombre_db> -f db/init/01_create_tables.sql
```

> **Nota:** Normalmente, la creación de tablas y migraciones se gestiona automáticamente con Alembic desde el backend, pero los scripts en `db/` pueden ser útiles para restauraciones o setups iniciales.

### 4. Configurar el Backend

```bash
cd be

# Crear entorno virtual
python -m venv .venv

# Activar entorno virtual
.venv\Scripts\activate     # Windows
source .venv/bin/activate  # Linux/macOS

# Instalar dependencias
pip install -r requirements.txt

# Crear archivo .env desde plantilla
copy .env.example .env     # Windows
cp .env.example .env       # Linux/macOS

# Ejecutar migraciones
alembic upgrade head

# Crear usuario administrador inicial
python scripts/create_admin.py
```

### 5. Configurar el Frontend

```bash
cd ../fe

# Instalar dependencias
pnpm install

# Crear archivo .env desde plantilla
copy .env.example .env     # Windows
cp .env.example .env       # Linux/macOS
```

---

## ▶️ Ejecución

### Backend
```bash
cd be
.venv\Scripts\activate     # Windows
uvicorn app.main:app --reload
```
- API: http://localhost:8000
- Documentación: http://localhost:8000/docs

### Frontend
```bash
cd fe
pnpm dev
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
- role_id (UUID, FK → roles)
- is_active (boolean, default False)
- is_validated (boolean, default False)
- must_change_password (boolean, default False) - Para empleados nuevos
- business_name (varchar, nullable) - Solo clientes
- occupation (varchar, nullable) - Solo empleados
- created_at (timestamp)
- updated_at (timestamp)
- deleted_at (timestamp, nullable) - Soft delete
- validated_by (UUID, FK → users) - Qué admin validó
- validated_at (timestamp, nullable)

---

## 🔐 Autenticación

- **Método:** JWT (JSON Web Tokens)
- **Access Token:** 15 minutos
- **Refresh Token:** 7 días
- **Hashing:** bcrypt

### Flujo de Registro de Cliente
1. Cliente llena formulario de registro público
2. Cuenta creada con `is_validated=False` e `is_active=False`
3. Mensaje: "Cuenta creada exitosamente. Pendiente de validación por administrador"
4. Admin valida cuenta desde su dashboard
5. Sistema activa cuenta (`is_active=True`, `is_validated=True`)
6. Cliente puede hacer login

### Flujo de Creación de Empleado (por Admin)
1. Admin llena formulario de creación de empleado
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
├── docker-compose.yml          # Configuración de PostgreSQL en Docker
├── README.md                   # Este archivo
├── .gitignore                  # Archivos ignorados
│
├── db/                         # Scripts SQL de inicialización de la base de datos
│   └── init/
│       └── 01_create_tables.sql  # Script para crear tablas iniciales
│
├── be/                         # Backend (FastAPI)
│   ├── app/
│   │   ├── models/             # Modelos ORM (Role, User)
│   │   ├── schemas/            # Schemas Pydantic
│   │   ├── routers/            # Endpoints (auth, admin, users)
│   │   ├── services/           # Lógica de negocio
│   │   └── utils/              # Utilidades (security, email)
│   ├── alembic/                # Migraciones (Alembic)
│   ├── scripts/                # Scripts utilitarios (ej: crear admin)
│   └── requirements.txt        # Dependencias Python
│
└── fe/                         # Frontend (React + Vite)
    ├── src/
    │   ├── pages/              # Páginas por rol
    │   ├── components/         # Componentes reutilizables
    │   ├── api/                # Clientes HTTP
    │   └── context/            # Estado global
    └── package.json            # Dependencias Node.js
```

> **Nota:** La carpeta `db/` contiene scripts SQL útiles para inicialización manual, restauraciones o pruebas. El flujo normal de trabajo utiliza migraciones automáticas con Alembic desde el backend.

---

## 🎨 Colores de la Marca

- **Primario:** Azul Navy #1e40af (del águila del logo)
- **Secundario:** Dorado #d97706 (del texto J&R)
- **Fondo claro:** #f9fafb
- **Fondo oscuro:** #111827
- **Sin degradados:** Colores sólidos únicamente

---

## 📄 Licencia

Proyecto académico - SENA

---

## 👨‍💻 Autor

CALZADO J&R - Sistema de Gestión
