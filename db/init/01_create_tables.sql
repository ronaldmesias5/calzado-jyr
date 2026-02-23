-- ============================================================
-- CALZADO J&R — Script de inicialización de la base de datos
-- ============================================================
-- ¿Qué? Crea la tabla de roles e inserta los 3 roles del sistema.
-- ¿Para qué? Tener los roles disponibles desde el inicio sin migración manual.
-- ¿Impacto? Sin roles, no se pueden crear usuarios con su rol correspondiente.

-- Este script se ejecuta automáticamente al crear el contenedor por primera vez
-- gracias al volumen montado en /docker-entrypoint-initdb.d

-- Habilitar extensión UUID
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Crear tabla de roles
CREATE TABLE IF NOT EXISTS roles (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(50) UNIQUE NOT NULL,
    description VARCHAR(255),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
    deleted_at TIMESTAMP WITH TIME ZONE
);

-- Insertar roles del sistema
INSERT INTO roles (name, description) VALUES
    ('admin', 'Administrador del sistema — acceso completo'),
    ('employee', 'Empleado de la fábrica — gestión de tareas asignadas'),
    ('client', 'Cliente — gestión de pedidos y catálogo')
ON CONFLICT (name) DO NOTHING;

-- Crear tabla de usuarios
CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email VARCHAR(255) UNIQUE NOT NULL,
    hashed_password VARCHAR(255) NOT NULL,
    full_name VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    role_id UUID NOT NULL REFERENCES roles(id),
    is_active BOOLEAN DEFAULT FALSE NOT NULL,
    is_validated BOOLEAN DEFAULT FALSE NOT NULL,
    must_change_password BOOLEAN DEFAULT FALSE NOT NULL,
    business_name VARCHAR(255),
    occupation VARCHAR(100),
    validated_by UUID REFERENCES users(id),
    validated_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
    deleted_at TIMESTAMP WITH TIME ZONE
);

-- Índice en email para búsquedas rápidas en login
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);

-- Crear tabla de tokens de recuperación de contraseña
CREATE TABLE IF NOT EXISTS password_reset_tokens (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    token VARCHAR(255) UNIQUE NOT NULL,
    expires_at TIMESTAMP WITH TIME ZONE NOT NULL,
    used BOOLEAN DEFAULT FALSE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL
);

-- Índice en token para búsquedas rápidas
CREATE INDEX IF NOT EXISTS idx_password_reset_tokens_token ON password_reset_tokens(token);
