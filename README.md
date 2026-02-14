# 👟 CALZADO J&R - Sistema de Gestión

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
- Valida cuentas de Empleados y Clientes
- Puede crear más cuentas de Administrador
- Acceso completo al sistema

### 2. 👷 Empleado
- Registro libre (pendiente de validación)
- Ocupaciones: Guarnición, Solador, Cortador, Emplantillador
- Dashboard de tareas asignadas
- Campos: Nombre, Teléfono, Email, Ocupación, Contraseña

### 3. 👤 Cliente
- Registro libre (pendiente de validación)
- Dashboard de pedidos y catálogo
- Campos: Nombre, Teléfono, Email, Contraseña, Nombre de comercio (opcional)

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

# Verificar que esta corriendo
docker compose ps
```

### 3. Configurar el Backend

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

# Crear usuario administrador inicial (script pendiente)
python scripts/create_admin.py
```

### 4. Configurar el Frontend

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

### Tabla `users`
- id (UUID, PK)
- email (varchar, unique, index)
- hashed_password (varchar)
- full_name (varchar)
- phone (varchar)
- role_id (UUID, FK → roles)
- is_active (boolean, default False)
- is_validated (boolean, default False)
- business_name (varchar, nullable) - Solo clientes
- occupation (varchar, nullable) - Solo empleados
- created_at (timestamp)
- updated_at (timestamp)
- validated_by (UUID, FK → users) - Qué admin validó
- validated_at (timestamp, nullable)

---

## 🔐 Autenticación

- **Método:** JWT (JSON Web Tokens)
- **Access Token:** 15 minutos
- **Refresh Token:** 7 días
- **Hashing:** bcrypt

### Flujo de Registro
1. Cliente/Empleado llena formulario según su rol
2. Cuenta creada con `is_validated=False`
3. Mensaje: "Cuenta pendiente de validación por administrador"
4. Admin valida cuenta desde su dashboard
5. Usuario puede hacer login

### Flujo de Login
1. Seleccionar rol (Admin/Empleado/Cliente)
2. Ingresar email y contraseña
3. Sistema valida credenciales y estado de cuenta
4. Redirección según rol a su dashboard

---

## 📂 Estructura del Proyecto

```
calzado-jyr/
├── docker-compose.yml          # PostgreSQL
├── README.md                   # Este archivo
├── .gitignore                  # Archivos ignorados
│
├── be/                         # Backend
│   ├── app/
│   │   ├── models/             # Modelos ORM (Role, User)
│   │   ├── schemas/            # Schemas Pydantic
│   │   ├── routers/            # Endpoints (auth, admin)
│   │   ├── services/           # Lógica de negocio
│   │   └── utils/              # Utilidades (security, email)
│   ├── alembic/                # Migraciones
│   └── requirements.txt        # Dependencias Python
│
└── fe/                         # Frontend
    ├── src/
    │   ├── pages/              # Páginas por rol
    │   ├── components/         # Componentes reutilizables
    │   ├── api/                # Clientes HTTP
    │   └── context/            # Estado global
    └── package.json            # Dependencias Node.js
```

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
