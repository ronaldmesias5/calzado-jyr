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

-- ============================================================
-- TIPOS ENUMERADOS (ENUM TYPES)
-- ============================================================
-- Los siguientes tipos ENUM definen conjuntos predefinidos de valores
-- que se utilizan en columnas de tablas para asegurar integridad de datos
-- y restringir valores solo a opciones válidas del negocio.

-- Tipo ENUM para las ocupaciones de empleados
-- Valores permitidos:
--   - 'jefe': Encargado de orquestar tareas, validar cuentas y gestionar la producción
--   - 'cortador': Encargado de cortar materiales
--   - 'guarnecedor': Encargado de elaborar guarniciones
--   - 'solador': Encargado de preparar suelas y bases
--   - 'emplantillador': Encargado de emplantar/armar calzado
CREATE TYPE occupation_type AS ENUM ('jefe', 'cortador', 'guarnecedor', 'solador', 'emplantillador');

-- Tipo ENUM para el estado de los movimientos de insumos
-- Valores: 'entrada' (ingreso al inventario) o 'salida' (egreso del inventario)
CREATE TYPE supplies_movement_type AS ENUM ('entrada', 'salida');

-- Tipo ENUM para el estado de los movimientos de inventario
-- Valores: 'entrada', 'salida', 'ajuste'
CREATE TYPE inventory_movement_type AS ENUM ('entrada', 'salida', 'ajuste');

-- Tipo ENUM para el estado de los pedidos
-- Valores: 'pendiente', 'en_progreso', 'completado', 'cancelado'
CREATE TYPE order_status AS ENUM ('pendiente', 'en_progreso', 'completado', 'cancelado');

-- Tipo ENUM para el estado de las tareas
-- Valores: 'pendiente', 'en_progreso', 'completado', 'cancelado'
CREATE TYPE task_status AS ENUM ('pendiente', 'en_progreso', 'completado', 'cancelado');

-- Tipo ENUM para la prioridad de las tareas
-- Valores: 'baja', 'media', 'alta'
CREATE TYPE task_priority AS ENUM ('baja', 'media', 'alta');

-- Tipo ENUM para el tipo de tarea (ocupación)
-- Valores: 'corte', 'guarnicion', 'soladura', 'emplantillado'
CREATE TYPE task_type AS ENUM ('corte', 'guarnicion', 'soladura', 'emplantillado');

-- Tipo ENUM para el estado de las incidencias
-- Valores: 'abierta', 'en_progreso', 'resuelta', 'cerrada'
CREATE TYPE incidence_status AS ENUM ('abierta', 'en_progreso', 'resuelta', 'cerrada');

-- Tipo ENUM para el tipo de notificación
-- Valores: 'info', 'advertencia', 'error', 'éxito'
CREATE TYPE notification_type AS ENUM ('info', 'advertencia', 'error', 'exito');

-- ============================================================
-- TABLA: roles
-- DESCRIPCIÓN EN ESPAÑOL:
-- Tabla principal de roles del sistema. Define los tres roles fundamentales:
-- - Admin: Administrador del sistema con acceso completo a código y configuración
-- - Employee: Empleado de fábrica que puede tener diferentes ocupaciones
-- - Client: Cliente externo que realiza pedidos
-- 
-- ATRIBUTOS:
--   id (UUID): Identificador único
--   name (VARCHAR): Nombre único del rol
--   description (VARCHAR): Descripción del rol
--   created_at (TIMESTAMP): Fecha de creación
--   updated_at (TIMESTAMP): Última actualización
--   deleted_at (TIMESTAMP): Soft delete para auditoría
-- ============================================================
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
    ('admin', 'Administrador del sistema — acceso completo a código, configuración y datos'),
    ('employee', 'Empleado de la fábrica — gestión de tareas, producción y operaciones'),
    ('client', 'Cliente — gestión de pedidos, visualización de catálogo y seguimiento')
ON CONFLICT (name) DO NOTHING;

-- ============================================================
-- TABLA: users
-- DESCRIPCIÓN EN ESPAÑOL:
-- Tabla central de usuarios del sistema. Almacena información de
-- administradores, empleados y clientes. Incluye campos específicos
-- para diferentes tipos de usuario (ocupación para empleados,
-- nombre comercial para clientes).
-- 
-- ATRIBUTOS:
--   id (UUID): Identificador único del usuario
--   email (VARCHAR): Correo electrónico único
--   hashed_password (VARCHAR): Contraseña cifrada con bcrypt
--   name (VARCHAR): Nombres del usuario
--   last_name (VARCHAR): Apellidos del usuario
--   phone (VARCHAR): Teléfono de contacto
--   role_id (UUID): Referencia del rol (admin/employee/client)
--   is_active (BOOLEAN): Indica si la cuenta está activa
--   is_validated (BOOLEAN): Indica si la cuenta fue validada por admin
--   must_change_password (BOOLEAN): Fuerza cambio de contraseña en próximo login
--   business_name (VARCHAR): Nombre del comercio/empresa (solo clientes)
--   occupation (occupation_type): Ocupación laboral (solo empleados)
--   validated_by (UUID): ID del admin que validó la cuenta
--   validated_at (TIMESTAMP): Fecha de validación de la cuenta
--   created_at (TIMESTAMP): Fecha de creación del usuario
--   updated_at (TIMESTAMP): Última actualización de datos
--   deleted_at (TIMESTAMP): Soft delete para auditoría
-- ============================================================
CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email VARCHAR(255) UNIQUE NOT NULL,
    hashed_password VARCHAR(255) NOT NULL,
    name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    role_id UUID NOT NULL REFERENCES roles(id),
    is_active BOOLEAN DEFAULT FALSE NOT NULL,
    is_validated BOOLEAN DEFAULT FALSE NOT NULL,
    must_change_password BOOLEAN DEFAULT FALSE NOT NULL,
    business_name VARCHAR(255),
    occupation occupation_type,
    validated_by UUID REFERENCES users(id),
    validated_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
    deleted_at TIMESTAMP WITH TIME ZONE
);

-- Índice en email para búsquedas rápidas en login
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);

-- ============================================================
-- TABLA: password_reset_tokens
-- DESCRIPCIÓN EN ESPAÑOL:
-- Tokens de recuperación de contraseña. Almacena códigos temporales
-- generados cuando un usuario solicita resetear su contraseña.
-- Los tokens tienen una fecha de expiración y se marcan como utilizados
-- una vez que se ha completado el reseteo.
-- 
-- ATRIBUTOS:
--   id (UUID): Identificador único del token
--   user_id (UUID): Referencia del usuario propietario del token
--   token (VARCHAR): Token único generado para el reseteo
--   expires_at (TIMESTAMP): Fecha y hora de expiración del token
--   used (BOOLEAN): Indica si el token ya fue utilizado
--   created_at (TIMESTAMP): Fecha de creación del token
-- ============================================================
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    token VARCHAR(255) UNIQUE NOT NULL,
    expires_at TIMESTAMP WITH TIME ZONE NOT NULL,
    used BOOLEAN DEFAULT FALSE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL
);

-- Índice en token para búsquedas rápidas
CREATE INDEX IF NOT EXISTS idx_password_reset_tokens_token ON password_reset_tokens(token);

-- ============================================================
-- TIPOS ENUMERADOS ADICIONALES
-- ============================================================

-- Tipo ENUM para el estado de los movimientos de insumos
-- Valores: 'entrada' (ingreso al inventario) o 'salida' (egreso del inventario)
CREATE TYPE supplies_movement_type AS ENUM ('entrada', 'salida');

-- Tipo ENUM para el estado de los movimientos de inventario
-- Valores: 'entrada', 'salida', 'ajuste'
CREATE TYPE inventory_movement_type AS ENUM ('entrada', 'salida', 'ajuste');

-- Tipo ENUM para el estado de los pedidos
-- Valores: 'pendiente', 'en_progreso', 'completado', 'cancelado'
CREATE TYPE order_status AS ENUM ('pendiente', 'en_progreso', 'completado', 'cancelado');

-- Tipo ENUM para el estado de las tareas
-- Valores: 'pendiente', 'en_progreso', 'completado', 'cancelado'
CREATE TYPE task_status AS ENUM ('pendiente', 'en_progreso', 'completado', 'cancelado');

-- Tipo ENUM para la prioridad de las tareas
-- Valores: 'baja', 'media', 'alta'
CREATE TYPE task_priority AS ENUM ('baja', 'media', 'alta');

-- Tipo ENUM para el tipo de tarea (ocupación)
-- Valores: 'corte', 'guarnicion', 'soladura', 'emplantillado'
CREATE TYPE task_type AS ENUM ('corte', 'guarnicion', 'soladura', 'emplantillado');

-- Tipo ENUM para el estado de las incidencias
-- Valores: 'abierta', 'en_progreso', 'resuelta', 'cerrada'
CREATE TYPE incidence_status AS ENUM ('abierta', 'en_progreso', 'resuelta', 'cerrada');

-- Tipo ENUM para el tipo de notificación
-- Valores: 'info', 'advertencia', 'error', 'éxito'
CREATE TYPE notification_type AS ENUM ('info', 'advertencia', 'error', 'exito');

-- ============================================================
-- TABLA: supplies
-- DESCRIPCIÓN EN ESPAÑOL:
-- Registro centralizado de insumos (materiales) utilizados en la 
-- fabricación de calzado. Incluye cueros, telas, pegamentos, 
-- herrajes, plantillas y todos los componentes necesarios.
-- 
-- ATRIBUTOS:
--   id (UUID): Identificador único del insumo
--   name (VARCHAR): Nombre descriptivo del insumo
--   description (TEXT): Descripción detallada y especificaciones
--   created_at (TIMESTAMP): Fecha de registro
--   updated_at (TIMESTAMP): Última actualización
--   deleted_at (TIMESTAMP): Soft delete para auditoría
-- ============================================================
CREATE TABLE IF NOT EXISTS supplies (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(255) NOT NULL,
    description TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
    deleted_at TIMESTAMP WITH TIME ZONE
);

-- ============================================================
-- TABLA: supplies_movement
-- DESCRIPCIÓN EN ESPAÑOL:
-- Registro de movimientos de insumos (entradas y salidas del 
-- inventario). Cada registro representa una transacción de materiales.
-- Controla el flujo de insumos desde compra hasta su uso en producción.
-- 
-- ATRIBUTOS:
--   id (UUID): Identificador único del movimiento
--   supplies_id (UUID): Referencia del insumo movido
--   user_id (UUID): ID del usuario que realizó el movimiento
--   type_of_movement (supplies_movement_type): 'entrada' o 'salida'
--   amount (NUMERIC): Cantidad del insumo movido
--   colour (VARCHAR): Color del insumo (cuando aplique)
--   size (VARCHAR): Talla o tamaño del insumo
--   movement_date (TIMESTAMP): Fecha y hora del movimiento
--   created_at (TIMESTAMP): Fecha de registro del movimiento
--   updated_at (TIMESTAMP): Última actualización
--   deleted_at (TIMESTAMP): Soft delete para auditoría
-- ============================================================
CREATE TABLE IF NOT EXISTS supplies_movement (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    supplies_id UUID NOT NULL REFERENCES supplies(id),
    user_id UUID NOT NULL REFERENCES users(id),
    type_of_movement supplies_movement_type NOT NULL,
    amount NUMERIC(10, 2) NOT NULL,
    colour VARCHAR(100),
    size VARCHAR(50),
    movement_date TIMESTAMP WITH TIME ZONE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
    deleted_at TIMESTAMP WITH TIME ZONE
);

-- ============================================================
-- TABLA: categories
-- DESCRIPCIÓN EN ESPAÑOL:
-- Categorías de productos finales (zapatos, botas, sandalias, 
-- botines, mocasines, etc.). Define la clasificación jerárquica 
-- de productos para mejor organización y navegación del catálogo.
-- 
-- ATRIBUTOS:
--   id (UUID): Identificador único de la categoría
--   name (VARCHAR): Nombre de la categoría
--   description (TEXT): Descripción detallada de la categoría
--   created_at (TIMESTAMP): Fecha de creación
--   updated_at (TIMESTAMP): Última actualización
--   deleted_at (TIMESTAMP): Soft delete para auditoría
-- ============================================================
CREATE TABLE IF NOT EXISTS categories (
    ESCRIPCIÓN EN ESPAÑOL:
-- Marcas o fabricantes de referencias y productos. Puede incluir
-- marcas propias de CALZADO J&R o terceros. Ej: Nike, Adidas, 
-- Puma, marcas propias, etc.
-- 
-- ATRIBUTOS:
--   id (UUID): Identificador único de la marca
--   name (VARCHAR): Nombre de la marca
--   description (TEXT): Descripción de la marca y sus características
--   created_at (TIMESTAMP): Fecha de creación
--   updated_at (TIMESTAMP): Última actualización
--   deleted_at (TIMESTAMP): Soft delete para auditoría
    description TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
    deleted_at TIMESTAMP WITH TIME ZONE
);

-- ============================================================
-- TABLA: brands
-- Descripción: Marcas o fabricantes de referencias utilizadas
-- en los productos. Ej: Nike, Adidas, Puma.
-- ============================================================
CREATE TABLE IF NOT EXISTS brands (
    ESCRIPCIÓN EN ESPAÑOL:
-- Referencias o estilos específicos de producto. Define las 
-- características de diseño, modelo, forma y especificaciones
-- particulares de cada variante de producto.
-- 
-- ATRIBUTOS:
--   id (UUID): Identificador único de la referencia
--   brand_id (UUID): Referencia de la marca a la que pertenece
--   name (VARCHAR): Nombre o código de la referencia/estilo
--   description (TEXT): Descripción detallada del diseño y características
--   created_at (TIMESTAMP): Fecha de creación
--   updated_at (TIMESTAMP): Última actualización
--   deleted_at (TIMESTAMP): Soft delete para auditoría
    description TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
    deleted_at TIMESTAMP WITH TIME ZONE
);

-- ============================================================
-- TABLA: references
-- Descripción: Referencias o estilos de productos. Define las 
-- características específicas de diseño para cada producto.
-- ============================================================
CREATE TABLE IF NOT EXISTS references (
    ESCRIPCIÓN EN ESPAÑOL:
-- Catálogo completo de productos finales de calzado. Cada producto
-- es la combinación de una categoría, marca y referencia específica.
-- Representa el artículo que se vende a clientes finales.
-- 
-- ATRIBUTOS:
--   id (UUID): Identificador único del producto
--   category_id (UUID): Referencia de la categoría del producto
--   brand_id (UUID): Referencia de la marca del producto
--   reference_id (UUID): Referencia al estilo/modelo específico
--   name (VARCHAR): Nombre comercial del producto
--   description (TEXT): Descripción completa para catálogo
--   state (BOOLEAN): Estado activo/inactivo del producto
--   created_at (TIMESTAMP): Fecha de creación
--   updated_at (TIMESTAMP): Última actualización
--   deleted_at (TIMESTAMP): Soft delete para auditoría
    name VARCHAR(255) NOT NULL,
    description TEXT,
    ESCRIPCIÓN EN ESPAÑOL:
-- Inventario de productos finales en bodega. Registra existencias
-- por talla y color con control de cantidades y stock mínimo para
-- reorden automático cuando sea necesario.
-- 
-- ATRIBUTOS:
--   id (UUID): Identificador único del registro de inventario
--   product_id (UUID): Referencia del producto en inventario
--   size (VARCHAR): Talla del producto
--   amount (NUMERIC): Cantidad de unidades
--   colour (VARCHAR): Color específico del producto
--   amount_quantity (INTEGER): Cantidad total de pares/unidades
--   minimum_stock (INTEGER): Stock mínimo para generar alerta de reorden
--   created_at (TIMESTAMP): Fecha de creación
--   updated_at (TIMESTAMP): Última actualización
--   deleted_at (TIMESTAMP): Soft delete para auditoría
    deleted_at TIMESTAMP WITH TIME ZONE
);

-- ============================================================
-- TABLA: products
-- Descripción: Catálogo de productos finales de calzado.
-- Cada producto está asociado a una categoría, marcay referencia.
-- ============================================================
CREATE TABLE IF NOT EXISTS products (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    category_id UUID NOT NULL REFERENCES categories(id),
    brand_id UUID NOT NULL REFERENCES brands(id),
    reference_id UUID NOT NULL REFERENCES references(id),
    ESCRIPCIÓN EN ESPAÑOL:
-- Registro detallado de todos los movimientos de inventario 
-- (entradas, salidas y ajustes). Proporciona auditoría completa
-- del historial de cambios en stock de productos terminados.
-- 
-- ATRIBUTOS:
--   id (UUID): Identificador único del movimiento
--   product_id (UUID): Referencia del producto movido
--   user_id (UUID): ID del usuario que realizó el movimiento
--   type_of_movement (inventory_movement_type): 'entrada', 'salida' o 'ajuste'
--   size (VARCHAR): Talla del producto movido
--   colour (VARCHAR): Color del producto movido
--   amount (NUMERIC): Cantidad movida
--   reason (VARCHAR): Motivo del movimiento (compra, venta, ajuste, etc)
--   movement_date (TIMESTAMP): Fecha y hora del movimiento
--   created_at (TIMESTAMP): Fecha de registro del movimiento
--   updated_at (TIMESTAMP): Última actualización
--   deleted_at (TIMESTAMP): Soft delete para auditoría
    state BOOLEAN DEFAULT TRUE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
    deleted_at TIMESTAMP WITH TIME ZONE
);

-- ============================================================
-- TABLA: inventory
-- Descripción: Inventario de productos finales en bodega.
-- Registra la cantidad, tallas, colores y existencias mínimas.
-- ============================================================
CREATE TABLE IF NOT EXISTS inventory (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    product_id UUID NOT NULL REFERENCES products(id),
    size VARCHAR(50) NOT NULL,
    amount NUMERIC(10, 2) NOT NULL,
    ESCRIPCIÓN EN ESPAÑOL:
-- Pedidos realizados por clientes. Registra la información
-- completa del cliente, cantidad total de pares, estado del
-- pedido y fecha de entrega prometida.
-- 
-- ATRIBUTOS:
--   id (UUID): Identificador único del pedido
--   customer_id (UUID): Referencia del cliente que realizó el pedido
--   total_pairs (INTEGER): Cantidad total de pares en el pedido
--   state (order_status): Estado del pedido (pendiente/en_progreso/completado/cancelado)
--   delivery_date (TIMESTAMP): Fecha prometida de entrega
--   creation_date (TIMESTAMP): Fecha original de creación del pedido
--   created_at (TIMESTAMP): Timestamp de creación en sistema
--   updated_at (TIMESTAMP): Última actualización
--   deleted_at (TIMESTAMP): Soft delete para auditoría
    minimum_stock INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
    ESCRIPCIÓN EN ESPAÑOL:
-- Detalles específicos de cada línea de pedido. Especifica los
-- productos individuales, cantidades, tallas, colores y estado
-- de cada artículo dentro de un pedido general.
-- 
-- ATRIBUTOS:
--   id (UUID): Identificador único del detalle
--   order_id (UUID): Referencia al pedido padre
--   product_id (UUID): Referencia al producto solicitado
--   size (VARCHAR): Talla especificada en el detalle
--   colour (VARCHAR): Color específico solicitado
--   amount (INTEGER): Cantidad de unidades en este detalle
--   state (order_status): Estado individual del detalle de pedido
--   order_date (TIMESTAMP): Fecha del pedido en este detalle
--   created_at (TIMESTAMP): Fecha de creación del detalle
--   updated_at (TIMESTAMP): Última actualización
--   deleted_at (TIMESTAMP): Soft delete para auditoría
);

-- ============================================================
-- TABLA: inventory_movement
-- Descripción: Registro de movimientos de inventario (entradas, 
-- salidas y ajustes). Controla el historial de cambios en stock.
-- ============================================================
CREATE TABLE IF NOT EXISTS inventory_movement (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    product_id UUID NOT NULL REFERENCES products(id),
    user_id UUID NOT NULL REFERENCES users(id),
    type_of_movement inventory_movement_type NOT NULL,
    size VARCHAR(50),
    colour VARCHAR(100),
    amount NUMERIC(10, 2) NOT NULL,
    reason VARCHAR(255),
    ESCRIPCIÓN EN ESPAÑOL:
-- Tareas asignadas a empleados en diferentes operaciones de la
-- fábrica. Incluye tareas de corte, guarnición, soladura y 
-- emplantillado con control de prioridad, estado y fechas límite.
-- 
-- ATRIBUTOS:
--   id (UUID): Identificador único de la tarea
--   description (TEXT): Descripción detallada de la tarea a realizar
--   priority (task_priority): Prioridad de la tarea (baja/media/alta)
--   type (task_type): Tipo de tarea (corte/guarnicion/soladura/emplantillado)
--   status (task_status): Estado actual de la tarea (pendiente/en_progreso/completado/cancelado)
--   deadline (TIMESTAMP): Fecha límite para completar la tarea
--   assignment_date (TIMESTAMP): Fecha de asignación de la tarea
--   created_at (TIMESTAMP): Fecha de creación del registro
--   updated_at (TIMESTAMP): Última actualización
--   deleted_at (TIMESTAMP): Soft delete para auditoría
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
    deleted_at TIMESTAMP WITH TIME ZONE
);

-- ============================================================
-- TABLA: orders
-- Descripción: Pedidos realizados por clientes.
-- Almacena la información del cliente, fecha de entrega y estado.
-- ============================================================
CREATE TABLE IF NOT EXISTS orders (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    customer_id UUID NOT NULL REFERENCES users(id),
    total_pairs INTEGER NOT NULL,
    state order_status DEFAULT 'pendiente' NOT NULL,
    delivery_date TIMESTAMP WITH TIME ZONE,
    creation_date TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
    ESCRIPCIÓN EN ESPAÑOL:
-- Tipos de documentos de identificación válidos en el sistema.
-- Incluye cédula de ciudadanía, tarjeta de identidad, pasaporte,
-- cédula de extranjería, etc. para validación de usuarios.
-- 
-- ATRIBUTOS:
--   id (UUID): Identificador único del tipo de documento
--   etype_document (VARCHAR): Nombre del tipo de documento (CC, TI, etc)
--   created_at (TIMESTAMP): Fecha de creación
--   updated_at (TIMESTAMP): Última actualización
--   deleted_at (TIMESTAMP): Soft delete para auditoría

-- ============================================================
-- TESCRIPCIÓN EN ESPAÑOL:
-- Comprobante o vale de entrega de productos. Registra
-- información del producto entregado incluyendo talla, color
-- y cantidad. Documento de apoyo en el proceso de producción.
-- 
-- ATRIBUTOS:
--   id (UUID): Identificador único del vale
--   size (VARCHAR): Talla del producto en el vale
--   colour (VARCHAR): Color del producto entregado
--   amount (NUMERIC): Cantidad de unidades en el vale
--   creation_date (TIMESTAMP): Fecha de creación del vale
--   created_at (TIMESTAMP): Timestamp de creación en sistema
--   updated_at (TIMESTAMP): Última actualización
--   deleted_at (TIMESTAMP): Soft delete para auditoríactos,
-- cantidades, tallas y colores de cada línea del pedido.
-- ============================================================
CREATE TABLE IF NOT EXISTS order_details (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    order_id UUID NOT NULL REFERENCES orders(id),
    product_id UUID NOT NULL REFERENCES products(id),
    size VARCHAR(50) NOT NULL,
    colour VARCHAR(100),
    amount INTEGER NOT NULL,
    state order_status DEFAULT 'pendiente' NOT NULL,
    order_date TIMESTAMP WITH TIME ZONE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
    deleted_at TIMESTAMP WITH TIME ZONE
);
ESCRIPCIÓN EN ESPAÑOL:
-- Detalles específicos de cada vale. Relaciona el vale con
-- la tarea asignada, el producto específico y el usuario
-- responsable, proporcionando trazabilidad completa.
-- 
-- ATRIBUTOS:
--   id (UUID): Identificador único del detalle de vale
--   task_id (UUID): Referencia a la tarea asociada
--   product_id (UUID): Referencia al producto en el vale
--   user_id (UUID): Referencia al usuario responsable
--   vale_id (UUID): Referencia al vale padre
--   size (VARCHAR): Talla en el detalle
--   colour (VARCHAR): Color en el detalle
--   amount (NUMERIC): Cantidad en el detalle
--   creation_date (TIMESTAMP): Fecha de creación del detalle
--   created_at (TIMESTAMP): Timestamp de creación en sistema
--   updated_at (TIMESTAMP): Última actualización
--   deleted_at (TIMESTAMP): Soft delete para auditoría
-- TABLA: tasks
-- Descripción: Tareas asignadas a empleados de la fábrica.
-- IESCRIPCIÓN EN ESPAÑOL:
-- Registro de incidencias o problemas ocurridos durante la
-- ejecución de tareas en la fábrica. Permite seguimiento de
-- defectos, retrasos y otros problemas con solución.
-- 
-- ATRIBUTOS:
--   id (UUID): Identificador único de la incidencia
--   task_id (UUID): Referencia a la tarea donde ocurrió
--   type (VARCHAR): Tipo de incidencia (defecto, retraso, accidente, etc)
--   description (TEXT): Descripción detallada del problema
--   state (incidence_status): Estado (abierta/en_progreso/resuelta/cerrada)
--   report_date (TIMESTAMP): Fecha de reporte del problema
--   created_at (TIMESTAMP): Fecha de creación del registro
--   updated_at (TIMESTAMP): Última actualización
--   deleted_at (TIMESTAMP): Soft delete para auditoría============
CREATE TABLE IF NOT EXISTS tasks (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    description TEXT NOT NULL,
    priority task_priority NOT NULL,
    type task_type NOT NULL,
    status task_status DEFAULT 'pendiente' NOT NULL,
    deadline TIMESTAMP WITH TIME ZONE,
    assignment_date TIMESTAMP WITH TIME ZONE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
    deleted_at TIMESTAMP WITH TIME ZONE
);

-- ============================================================
-- TABLA: type_document
-- Descripción: Tipos de documentos (CC, TI, Cédula de Extranjería, etc.)
-- para identificación de usuarios.
-- =ESCRIPCIÓN EN ESPAÑOL:
-- Sistema centralizado de notificaciones para usuarios.
-- Permite envío de mensajes, alertas e información importante
-- a través del panel del usuario con control de lectura.
-- 
-- ATRIBUTOS:
--   id (UUID): Identificador único de la notificación
--   user_id (UUID): Referencia al usuario destinatario
--   title (VARCHAR): Título o asunto de la notificación
--   message (TEXT): Contenido detallado del mensaje
--   type (notification_type): Tipo de notificación (info/advertencia/error/exito)
--   state (BOOLEAN): Indica si fue leída (true) o no leída (false)
--   creation_date (TIMESTAMP): Fecha de creación de la notificación
--   created_at (TIMESTAMP): Timestamp de creación en sistema
--   updated_at (TIMESTAMP): Última actualización
--   deleted_at (TIMESTAMP): Soft delete para auditoría
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    etype_document VARCHAR(100) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
    deleted_at TIMESTAMP WITH TIME ZONE
);

-- ============================================================
-- TABLA: vale
-- Descripción: Comprobante o vale de entrega.
-- Registra información de talla, color y cantidad entregada.
-- ============================================================
CREATE TABLE IF NOT EXISTS vale (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    size VARCHAR(50),
    colour VARCHAR(100),
    amount NUMERIC(10, 2),
    creation_date TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
    deleted_at TIMESTAMP WITH TIME ZONE
);

-- ============================================================
-- TABLA: detail_vale
-- Descripción: Detalles específicos de cada vale.
-- Relaciona el vale con la tarea, producto y usuario involucrados.
-- ============================================================
CREATE TABLE IF NOT EXISTS detail_vale (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    task_id UUID NOT NULL REFERENCES tasks(id),
    product_id UUID NOT NULL REFERENCES products(id),
    user_id UUID NOT NULL REFERENCES users(id),
    vale_id UUID NOT NULL REFERENCES vale(id),
    size VARCHAR(50),
    colour VARCHAR(100),
    amount NUMERIC(10, 2),
    creation_date TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
    deleted_at TIMESTAMP WITH TIME ZONE
);

-- ============================================================
-- TABLA: incidence
-- Descripción: Registro de incidencias o problemas ocurridos
-- durante la ejecución de una tarea en la fábrica.
-- ============================================================
CREATE TABLE IF NOT EXISTS incidence (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    task_id UUID NOT NULL REFERENCES tasks(id),
    type VARCHAR(100) NOT NULL,
    description TEXT,
    state incidence_status DEFAULT 'abierta' NOT NULL,
    report_date TIMESTAMP WITH TIME ZONE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
    deleted_at TIMESTAMP WITH TIME ZONE
);

-- ============================================================
-- TABLA: notifications
-- Descripción: Sistema de notificaciones para usuarios.
-- Permite enviar mensajes, alertas e información a través del panel.
-- ============================================================
CREATE TABLE IF NOT EXISTS notifications (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id),
    title VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    type notification_type DEFAULT 'info' NOT NULL,
    state BOOLEAN DEFAULT FALSE NOT NULL,
    creation_date TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
    deleted_at TIMESTAMP WITH TIME ZONE
);

-- ============================================================
-- ÍNDICES PARA OPTIMIZACIÓN DE BÚSQUEDAS
-- ============================================================

CREATE INDEX IF NOT EXISTS idx_supplies_movement_supplies_id ON supplies_movement(supplies_id);
CREATE INDEX IF NOT EXISTS idx_supplies_movement_user_id ON supplies_movement(user_id);
CREATE INDEX IF NOT EXISTS idx_categories_name ON categories(name);
CREATE INDEX IF NOT EXISTS idx_brands_name ON brands(name);
CREATE INDEX IF NOT EXISTS idx_products_category_id ON products(category_id);
CREATE INDEX IF NOT EXISTS idx_products_brand_id ON products(brand_id);
CREATE INDEX IF NOT EXISTS idx_inventory_product_id ON inventory(product_id);
CREATE INDEX IF NOT EXISTS idx_inventory_movement_product_id ON inventory_movement(product_id);
CREATE INDEX IF NOT EXISTS idx_inventory_movement_user_id ON inventory_movement(user_id);
CREATE INDEX IF NOT EXISTS idx_orders_customer_id ON orders(customer_id);
CREATE INDEX IF NOT EXISTS idx_order_details_order_id ON order_details(order_id);
CREATE INDEX IF NOT EXISTS idx_order_details_product_id ON order_details(product_id);
CREATE INDEX IF NOT EXISTS idx_tasks_status ON tasks(status);
CREATE INDEX IF NOT EXISTS idx_incidence_task_id ON incidence(task_id);
CREATE INDEX IF NOT EXISTS idx_notifications_user_id ON notifications(user_id);
CREATE INDEX IF NOT EXISTS idx_notifications_state ON notifications(state);
