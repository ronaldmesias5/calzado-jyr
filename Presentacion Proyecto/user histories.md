# HISTORIAS DE USUARIO

**HU-001: Creación de Cuentas de Acceso**

**Prioridad:** Alta

**Como** administrador del sistema,  
**Quiero** crear cuentas de acceso para clientes mayoristas y empleados,  
**Para** controlar quién puede ingresar al sistema y garantizar la seguridad de los datos.

**Criterios de Aceptación:**

* Puedo completar un formulario con: nombre completo, correo electrónico, teléfono, tipo de usuario, documento de identidad, dirección y ciudad

* El sistema valida que el correo y documento no estén duplicados antes de crear la cuenta

* Se genera automáticamente una contraseña temporal segura (mínimo 10 caracteres con mayúscula, minúscula, número y símbolo)

* El usuario recibe un correo con sus credenciales y un enlace válido por 24 horas

* El usuario debe cambiar su contraseña en el primer acceso

* Recibo mensaje "Cuenta creada exitosamente" cuando todo es correcto

* Si hay duplicidad, el sistema bloquea la creación y me informa

**HU-002: Inicio de Sesión en el Sistema**

**Prioridad:** Alta

**Como** usuario registrado (cliente, empleado o administrador),  
**Quiero** iniciar sesión con mi correo y contraseña,  
**Para** acceder a las funcionalidades que corresponden a mi rol.

**Criterios de Aceptación:**

* Puedo ingresar mi correo electrónico y contraseña

* El sistema valida mis credenciales y me redirige al panel según mi rol

* Si omito campos, no puedo acceder

* Si mis credenciales son incorrectas, recibo mensaje específico

* Después de 3 intentos fallidos en 5 minutos, mi cuenta se bloquea por 30 minutos

* Mi sesión se cierra automáticamente después de 20 minutos de inactividad

* Todos mis intentos de acceso quedan registrados en auditoría

**HU-003: Recuperación de Contraseña Olvidada**

**Prioridad:** Alta

**Como** usuario registrado,  
**Quiero** recuperar el acceso a mi cuenta cuando olvido mi contraseña,  
**Para** poder continuar usando el sistema sin perder mis datos.

**Criterios de Aceptación:**

* Puedo ingresar mi correo electrónico en el formulario de recuperación

* Recibo un enlace seguro válido por 60 minutos si mi correo está registrado

* Puedo establecer una nueva contraseña que cumpla los requisitos de seguridad

* Mi contraseña anterior queda invalidada automáticamente

* Recibo confirmación "Su contraseña ha sido actualizada exitosamente"

* Si el enlace expira, debo solicitar uno nuevo

* Si mi correo no está registrado, no se envía el enlace

* Todo el proceso queda registrado en auditoría

**HU-004: Solicitud de Reactivación de Cuenta Suspendida**

**Prioridad:** Alta

**Como** usuario con cuenta suspendida,  
**Quiero** solicitar la reactivación de mi acceso,  
**Para** volver a utilizar el sistema después de resolver el motivo de suspensión.

**Criterios de Aceptación:**

* Puedo acceder al formulario de reactivación con mi correo suspendido

* Debo completar: correo, motivo detallado, documento de identidad, teléfono y evidencia opcional

* Se genera un ticket único que envía al panel del administrador

* El administrador puede aprobar o rechazar mi solicitud con comentario obligatorio

* Si se aprueba, mi cuenta cambia a "activa" y recibo notificación

* Si se rechaza, recibo el motivo del rechazo

* Si mi cuenta no está suspendida, no puedo enviar la solicitud

* Todas las acciones quedan registradas en auditoría

**HU-005: Registro de Productos en el Catálogo**

**Prioridad:** Alta

**Como** administrador,  
**Quiero** registrar productos nuevos en el catálogo digital,  
**Para** que los clientes y empleados puedan consultarlos y realizar pedidos de fabricación.

**Criterios de Aceptación:**

* Puedo completar: nombre, referencia única, descripción, imagen principal, tallas, colores, categoría, marca y estado

* El sistema valida que la referencia sea única

* Las imágenes deben ser JPG o PNG 

* Los productos "inactivos" no aparecen en catálogo público

* No puedo eliminar productos con pedidos asociados, solo desactivarlos

* Recibo mensaje "Producto registrado exitosamente" cuando todo es correcto

* Todas las acciones quedan registradas en auditoría

**HU-006: Clasificación de Productos por Categorías**

**Prioridad:** Alta

**Como** administrador,  
**Quiero** organizar los productos en categorías definidas,  
**Para** facilitar la navegación y búsqueda de los usuarios en el catálogo.

**Criterios de Aceptación:**

* Puedo crear, editar y eliminar categorías con nombres únicos

* No puedo eliminar categorías vinculadas a productos activos

* Debo reasignar productos antes de eliminar su categoría

* Las categorías inactivas ocultan sus productos del catálogo público

* Los clientes pueden filtrar por categoría 

* Todas las acciones quedan registradas en auditoría

**HU-007: Gestión de Marcas y Estilos de Productos**

**Prioridad:** Alta

**Como** administrador,  
**Quiero** registrar y gestionar marcas y sus estilos asociados,  
**Para** organizar el portafolio de calzado según identidad corporativa y líneas de diseño.

**Criterios de Aceptación:**

* Puedo crear, editar y eliminar marcas con nombres únicos

* Puedo crear estilos dentro de cada marca con nombres únicos

* No puedo eliminar marca o estilo vinculado a productos activos

* Cada marca y estilo puede tener descripción y estado activo/inactivo

* Los estilos inactivos ocultan sus productos del catálogo

* Los clientes pueden buscar por marca y ver solo modelos correspondientes

* Todas las operaciones quedan registradas en auditoría

**HU-008: Visualización Pública del Catálogo**

**Prioridad:** Alta

**Como** visitante sin cuenta,  
**Quiero** explorar el catálogo de productos desde la página principal,  
**Para** conocer la oferta disponible antes de registrarme.

**Criterios de Aceptación:**

* Puedo acceder al catálogo sin iniciar sesión

* Veo solo productos activos y marcados como públicos

* Cada producto muestra: imagen, referencia, tallas, colores, marca y estilo

* No veo precios ni información de inventario

* Puedo aplicar filtros por categoría, marca, estilo, talla y color

* Si intento acceder a funciones restringidas, soy redirigido al registro

* Si no hay productos, veo mensaje "No hay productos disponibles"

**HU-009: Consulta de Catálogo como Cliente Mayorista**

**Prioridad:** Alta

**Como** cliente mayorista autenticado,  
**Quiero** consultar el catálogo completo con disponibilidad,  
**Para** preparar mis pedidos según la oferta actual.

**Criterios de Aceptación:**

* Debo iniciar sesión para acceder al catálogo interno

* Veo productos activos con: imagen, referencia, tallas, colores, marca y estilo 

* Puedo guardar modelos como favoritos y se mantienen entre sesiones

* Puedo aplicar filtros avanzados con información actualizada en tiempo real

* Puedo seleccionar modelos e iniciar proceso de pedido

* Si cierro sesión, mis favoritos se mantienen al volver

* No puedo acceder sin autenticación

**HU-010: Filtrado y Búsqueda Avanzada de Productos**

**Prioridad:** Alta

**Como** usuario del catálogo,  
**Quiero** filtrar y buscar productos por múltiples criterios,  
**Para** localizar rápidamente lo que necesito sin navegar todo el catálogo.

**Criterios de Aceptación:**

* Puedo aplicar filtros por: categoría, marca, estilo, talla, color y disponibilidad

* Puedo combinar múltiples filtros simultáneamente

* Puedo buscar por texto libre con coincidencias parciales

* Los resultados se actualizan en tiempo real sin recargar

* Existe botón visible para limpiar todos los filtros

* Si no hay coincidencias, veo mensaje "No se encontraron productos"

* Todas las búsquedas quedan registradas para análisis

**HU-011: Creación de Pedidos de Fabricación**

**Prioridad:** Alta

**Como** cliente mayorista,  
**Quiero** registrar pedidos de calzado seleccionando modelos, tallas, colores y cantidades,  
**Para** solicitar la fabricación o entrega de productos.

**Criterios de Aceptación:**

* Puedo seleccionar uno o más productos del catálogo activo

* Puedo especificar talla, color y cantidad para cada producto

* El sistema valida que la cantidad total sea mayor o igual al mínimo configurable

* El pedido se marca como "aprobado para entrega" si hay stock o "pendiente de fabricación" si no

* Recibo un número único de pedido con estado "pendiente de revisión"

* Si la cantidad es menor al mínimo, veo mensaje bloqueando el envío

* Si intento enviar sin productos, recibo mensaje de error

* Todas las acciones quedan registradas en auditoría

**HU-012: Notificación Automática de Nuevos Pedidos**

**Prioridad:** Alta

**Como** administrador/gerente comercial/planificador,  
**Quiero** recibir notificación inmediata cuando un cliente registra un pedido,  
**Para** poder procesarlo rápidamente.

**Criterios de Aceptación:**

* Recibo notificación en tiempo real 

* La notificación incluye: ID pedido, cliente, fecha, cantidad total, combinaciones y estado

* Aparece en mi panel con enlace directo al detalle del pedido

* Recibo correo electrónico si está habilitado

* La notificación indica si será por entrega directa o producción

* No recibo notificaciones duplicadas

* Si el pedido no se registra correctamente, no hay alerta

* Todas las notificaciones quedan registradas

**HU-013: Consulta de Estado de Mis Pedidos**

**Prioridad:** Alta

**Como** cliente mayorista,  
**Quiero** consultar el historial y estado actual de mis pedidos,  
**Para** hacer seguimiento a mis órdenes y verificar su avance.

**Criterios de Aceptación:**

* Veo todos mis pedidos organizados cronológicamente

* Cada pedido muestra: número, fecha, estado, productos, tallas, colores, cantidades y ruta de procesamiento

* Veo línea de tiempo con cambios de estado y fechas

* Veo alertas automáticas si hay retrasos (fecha prometida, fecha actual y estado completado)

* Puedo filtrar por estado, fecha o referencia

* Solo veo mis propios pedidos (no de otros clientes)

* No veo información de costos ni márgenes

**HU-014: Actualización de Estado de Pedidos**

**Prioridad:** Alta

**Como** administrador/gerente comercial,  
**Quiero** modificar el estado de los pedidos según su disponibilidad o avance de fabricación,  
**Para** mantener informados a los clientes.

**Criterios de Aceptación:**

* Puedo cambiar el estado entre: pendiente, aprobado, en producción, completado, cancelado, entregado

* Solo puedo aplicar transiciones lógicas y coherentes

* Debo registrar obligatoriamente el motivo del cambio

* Al cambiar a "aprobado", se genera automáticamente la orden de producción

* Al marcar "aprobado para entrega", se verifica disponibilidad en bodega

* Al marcar "fabricado", se valida que pasó por producción

* Al marcar "entregado", se valida que pasó por "aprobado para entrega"

* Si intento transición inválida, el sistema la bloquea

* Todos los cambios quedan en el historial del pedido

**HU-015: Control de Inventario de Calzado Fabricado**

**Prioridad:** Alta

**Como** administrador/jefe de bodega,  
**Quiero** registrar y controlar el inventario de calzado fabricado,  
**Para** garantizar que el sistema refleje la disponibilidad real de productos terminados.

**Criterios de Aceptación:**

* Puedo registrar ingresos especificando: referencia, talla, color, cantidad, fecha y origen

* Cada movimiento requiere: motivo, cantidad, fecha y responsable

* El sistema valida que la referencia exista en el catálogo

* Al aprobar pedido para entrega, se descuenta automáticamente del inventario

* Recibo alerta si la cantidad baja del umbral mínimo configurado

* Puedo consultar por filtros y realizar ajustes manuales con motivo

* Si intento registrar salida mayor al stock, recibo bloqueo

* Todos los movimientos quedan en el historial

**HU-016: Actualización Automática de Inventario desde Producción**

**Prioridad:** Alta

**Como** sistema,  
**Quiero** actualizar automáticamente el inventario cuando se finaliza producción,  
**Para** mantener la integridad sin intervención manual.

**Criterios de Aceptación:**

* Cuando un pedido se marca "fabricado" y aprobado por calidad, el inventario se actualiza automáticamente

* La cantidad ingresada coincide con la aprobada por calidad

* Si la combinación existe, se incrementa la cantidad

* Si no existe, se crea nuevo registro con estado "disponible"

* Se registra automáticamente: fecha, número de pedido y origen "producción interna"

* No se permite duplicidad de ingreso

* Si el pedido ya fue procesado, se evita duplicación

* Todos los eventos quedan en el historial

**HU-017: Registro de Ventas Directas**

**Prioridad:** Alta

**Como** administrador,  
**Quiero** registrar ventas directas de calzado,  
**Para** descontar automáticamente las unidades del inventario y mantenerlo actualizado.

**Criterios de Aceptación:**

* Puedo registrar: referencia, talla, color, cantidad, fecha, destino y motivo de venta

* El sistema valida stock en tiempo real antes de procesar

* Si el stock es insuficiente, la venta se bloquea

* Al confirmar, el inventario se descuenta automáticamente

* El descuento es irreversible y genera registro inmutable

* No se permiten registros duplicados (valida referencia de salida)

* Si todo es válido, recibo mensaje de éxito

* Todas las ventas quedan en el historial con: fecha, hora, cantidad, destino y responsable

**HU-018: Registro de Pérdidas por Producto Defectuoso**

**Prioridad:** Alta

**Como** administrador/control de calidad,  
**Quiero** registrar pérdidas por calzado defectuoso,  
**Para** mantener actualizado el stock real y garantizar trazabilidad de unidades descartadas.

**Criterios de Aceptación:**

* Debo registrar: referencia, talla, color, cantidad, fecha, código de defecto de lista predefinida y observaciones opcionales

* El sistema valida que la combinación exista y la cantidad no exceda el stock

* Al confirmar, se descuenta del inventario de bodega

* El stock defectuoso se mueve a "stock defectuoso" separado

* Si un operario registra pérdida, queda "pendiente de aprobación" sin mover inventario

* No se permiten registros duplicados

* Si los datos están incompletos, se bloquea el registro

* Todas las pérdidas quedan en el historial

**HU-019: Proceso de Restauración de Calzado Defectuoso**

**Prioridad:** Alta

**Como** administrador/jefe de calidad,  
**Quiero** gestionar el proceso de restauración de calzado defectuoso,  
**Para** recuperar unidades reparables y reincorporarlas al inventario disponible.

**Criterios de Aceptación:**

* Puedo seleccionar productos del historial de pérdidas

* Debo especificar: referencia, talla, color, cantidad, tipo de defecto, intervención, fechas y resultado

* La cantidad no puede exceder la previamente descartada

* Durante el proceso, las unidades quedan "en restauración" y bloqueadas

* Solo el jefe de calidad puede autorizar el estado final "restaurado"

* Si se aprueba, las unidades se reincorporan automáticamente al inventario

* Si se rechaza, se mantienen como pérdida definitiva

* Se registra el costo de reparación y se actualiza el costo unitario

* Todos los eventos quedan en el historial de restauración

**HU-020: Creación y Planificación de Tareas** 

**Prioridad:** Alta

**Como** administrador/planificador de producción,  
**Quiero** crear tareas operativas y asignarlas a empleados,  
**Para** organizar el trabajo interno y garantizar trazabilidad de actividades.

**Criterios de Aceptación:**

* Puedo registrar: título, descripción, tipo de tarea, prioridad, fecha límite y orden de producción vinculada

* El tiempo estándar es predefinido y coincide con la ficha del modelo

* No puedo crear tareas duplicadas para la misma orden y proceso

* La tarea aparece en el panel del empleado asignado con estado "pendiente de inicio"

* El empleado recibe notificación inmediata

* No puedo asignar a usuarios inactivos

* Si los datos son incorrectos, recibo mensajes claros

* Todas las acciones quedan en el historial con: fecha, hora, responsable y cambios

**HU-021: Asignación de Tareas a Empleados**

**Prioridad:** Alta

**Como** administrador/planificador,  
**Quiero** asignar tareas a empleados activos,  
**Para** distribuir eficientemente el trabajo y garantizar seguimiento de actividades.

**Criterios de Aceptación:**

* Puedo seleccionar tarea en estado "pendiente" y vincularla a empleado con rol autorizado

* Debo establecer fecha límite obligatoria

* La tarea cambia a "asignada" y se bloquea para edición de otros usuarios

* El empleado recibe notificación in-app 

* Puedo reasignar solo si está "asignada" o "en progreso"

* No puedo reasignar si está "completada" o "cancelada"

* Si la tarea ya está asignada, el sistema lo bloquea

* Todas las asignaciones quedan en el historial

**HU-022: Consulta de Tareas Asignadas**

**Prioridad:** Alta

**Como** empleado,  
**Quiero** consultar las tareas que me han asignado,  
**Para** organizar mi trabajo diario y dar seguimiento a mis responsabilidades.

**Criterios de Aceptación:**

* Debo iniciar sesión para acceder a mis tareas

* Veo todas mis tareas organizadas cronológicamente por estado

* Cada tarea muestra: título, descripción, tipo, prioridad, fechas, estado, observaciones y vínculos

* Puedo ordenar por prioridad o fecha límite

* Veo indicador de tiempo restante hasta la fecha límite

* Las tareas completadas permanecen visibles pero no editables

* Solo veo mis tareas, no de otros empleados

* Si no tengo tareas, veo mensaje apropiado

**HU-023: Reporte de Avances e Incidencias**

**Prioridad:** Alta

**Como** empleado,  
**Quiero** registrar avances, pausas e incidencias durante la ejecución de tareas,  
**Para** mantener informado al administrador sobre mi progreso real.

**Criterios de Aceptación:**

* Puedo registrar check-in (inicio), pausa y fin con marcas de tiempo del servidor

* No puedo iniciar dos tareas simultáneamente

* Puedo registrar: porcentaje de avance, descripción, tipo de incidencia, observaciones y archivos

* Si reporto incidencia crítica, se genera ticket automático en menos de 60 segundos

* La tarea cambia a "bloqueada" y se notifica al administrador

* Si el tiempo de pausa supera 10% del tiempo estándar, debo justificarlo

* Si marco 100% de avance, debo confirmar antes de marcar como completada

* Todos los reportes quedan vinculados a la tarea en el historial

**HU-024: Confirmación de Finalización de Tareas**

**Prioridad:** Alta

**Como** empleado,  
**Quiero** confirmar la finalización de mi tarea registrando la cantidad procesada,  
**Para** cerrar formalmente mi trabajo y notificar al administrador.

**Criterios de Aceptación:**

* Puedo marcar como finalizada solo mis tareas en estado "asignada" o "en progreso"

* Puedo adjuntar evidencia fotográfica o informe final

* Si es la última tarea, se genera alerta automática a control de calidad

* Una vez completada, la tarea se bloquea para edición

* El administrador recibe notificación automática

* Todos los eventos quedan en el historial

**HU-025: Notificación de Tareas Finalizadas**

**Prioridad:** Alta

**Como** administrador/supervisor,  
**Quiero** recibir notificación cuando un empleado finaliza una tarea,  
**Para** validar el cumplimiento y tomar decisiones de aprobación.

**Criterios de Aceptación:**

* Recibo notificación en tiempo real al marcarse una tarea como "completada"

* La notificación incluye: número, título, tipo, fechas, empleado, resumen, eficiencia calculada y observaciones

* Aparece en mi panel con enlace directo a la evidencia si existe

* Recibo correo si está habilitado

* Puedo aprobar o rechazar la tarea desde la notificación

* Si rechazo, debo justificar el motivo y el operario recibe notificación

* La tarea pasa a "reabierta" y se inicia tiempo de retrabajo

* No recibo notificaciones duplicadas

* Todas las notificaciones quedan en el historial

**HU-026: Modificación y Eliminación de Tareas**

**Prioridad:** Alta

**Como** administrador/planificador,  
**Quiero** editar o eliminar tareas no completadas,  
**Para** corregir errores de planificación o retirar tareas innecesarias.

**Criterios de Aceptación:**

* Puedo editar tareas en estado "pendiente" o "asignada" (no completadas ni canceladas)

* Puedo actualizar: título, descripción, tipo, prioridad, fecha límite, empleado y observaciones

* No puedo eliminar tareas con registro de tiempo mayor a cero minutos

* Si tiene tiempo registrado, solo puedo "cancelar" con motivo obligatorio

* Para eliminar tarea sin actividad, debo confirmar explícitamente

* Al eliminar, desaparece del panel del empleado

* Todas las modificaciones quedan en el historial con: valor anterior, nuevo valor y responsable

* Si intento eliminar tarea con actividad, el sistema lo bloquea

**HU-027: Registro de Incidencias de Maquinaria e Insumos**

**Prioridad:** Alta

**Como** empleado de planta,  
**Quiero** reportar rápidamente fallas de maquinaria o falta de insumos,  
**Para** documentar obstáculos y generar acciones correctivas oportunas.

**Criterios de Aceptación:**

* Puedo registrar desde una tarea activa: tipo de incidencia, descripción detallada, equipo/insumo, foto, área y fecha

* Debo adjuntar foto obligatoriamente

* Si reporto "falta de insumo crítico", se genera ticket urgente al jefe de compras

* Si es "falla de maquinaria", se notifica a mantenimiento con prioridad alta

* La tarea cambia a "bloqueada" si el impacto es total

* No puedo registrar incidencias duplicadas en menos de 30 minutos

* El administrador recibe notificación inmediata

* Todas las incidencias quedan en el historial técnico

**HU-028: Centro de Notificaciones Centralizado**

**Prioridad:** Alta

**Como** usuario del sistema,  
**Quiero** recibir notificaciones relevantes a mi rol en un centro consolidado,  
**Para** estar informado sobre eventos importantes sin perder información.

**Criterios de Aceptación:**

* Veo todas mis notificaciones en tiempo real en mi panel principal

* Las notificaciones incluyen: título, descripción, tipo, prioridad, fecha/hora, estado y enlace directo

* Hay contador visible de notificaciones pendientes

* Puedo marcarlas como leídas (reduce el contador)

* Puedo archivarlas para ocultarlas del panel principal

* Puedo filtrar por tipo y prioridad

* Solo recibo notificaciones relevantes a mi rol

* Si accedo a una notificación, se marca automáticamente como leída

* No recibo notificaciones duplicadas

* Puedo personalizar mis preferencias de notificación

**HU-029: Alertas Críticas para Administrador**

**Prioridad:** Alta

**Como** administrador/gerente,  
**Quiero** recibir alertas inmediatas sobre eventos críticos,  
**Para** intervenir rápidamente en situaciones que requieren atención.

**Criterios de Aceptación:**

* Recibo alertas de prioridad alta sobre: bloqueos operativos, agotamiento de stock, incidencias técnicas, tareas finalizadas

* Puedo configurar umbrales de alerta (días para retraso, porcentaje de inventario)

* Las alertas urgentes llegan por correo y banner prominente

* Cada alerta incluye: título, tipo de evento, prioridad, fecha/hora, descripción, módulo afectado y enlace directo

* Puedo responder: validar, rechazar, reabrir o escalar

* Si un insumo baja del umbral configurado, recibo alerta de prioridad media

* No recibo alertas duplicadas

* Tengo panel de control específico para consultar todas las alertas

**MÓDULO 7: REPORTES Y ANÁLISIS**

**HU-030: Generación de Reportes de Pedidos e Inventario**

**Prioridad:** Alta

**Como** administrador/gerente,  
**Quiero** generar reportes consolidados de pedidos e inventario,  
**Para** analizar el desempeño operativo y tomar decisiones informadas.

**Criterios de Aceptación:**

* Puedo generar reportes en tiempo real de pedidos y/o inventario

* Puedo filtrar por: rango de fechas, estado, referencia, cliente, tipo de movimiento

* El reporte de pedidos incluye: número, cliente, fecha, estado, productos, cantidades y ruta

* El reporte de inventario incluye: referencia, marca, estilo, talla, color, cantidades y movimientos

* Veo métricas clave: valor de stock, tasa de rotación, valor histórico de ventas

* El reporte se genera en menos de 60 segundos para un año de datos

* Puedo exportar a PDF y Excel

* Los datos son inmutables y consistentes con auditoría

* Si no hay resultados, veo mensaje apropiado

* Cada reporte incluye fecha de generación, usuario responsable y parámetros aplicados

**HU-031: Reportes de Desempeño de Empleados**

**Prioridad:** Alta

**Como** administrador/recursos humanos,  
**Quiero** generar reportes sobre tareas de empleados,  
**Para** analizar el desem

RJ

Continuar

peño individual y colectivo.

**Criterios de Aceptación:**

* Puedo generar reportes filtrando por: empleado, estado, tipo de tarea, prioridad, fechas

* El reporte incluye: empleado, número de tarea, título, tipo, fechas, estado, avance e incidencias

* Veo métricas: eficiencia por empleado, tiempo de retrabajo, desviación vs tiempo estándar

* Puedo filtrar por rango de fechas, supervisor y tipo de proceso

* Veo tasa de retrabajo (tiempo retrabajo / tiempo total)

* Veo calificación de eficiencia del empleado

* El empleado de planta no puede acceder a estos reportes

* Puedo exportar a PDF y Excel

* Si no hay resultados, veo mensaje apropiado

* Los reportes históricos son consultables, pero no editables

**HU-032: Contabilidad de Producción por Empleado**

**Prioridad:** Alta

**Como** administrador,  
**Quiero** llevar un registro detallado de la producción ejecutada por cada empleado,  
**Para** analizar el rendimiento operativo individual y facilitar procesos de evaluación.

**Criterios de Aceptación:**

* El sistema registra automáticamente cada unidad procesada cuando una tarea se marca como "completada"

* Los datos se calculan a partir de confirmaciones de tareas finalizadas aprobadas

* Cada registro incluye: tarea, empleado, referencia del producto, talla, color, tipo de intervención, cantidad, fecha y resultado

* No se contabilizan tareas sin cerrar o sin unidades procesadas registradas

* No puedo manipular manualmente estos datos de producción

* El reporte incluye cantidad de pares defectuosos reportados por empleado

* Puedo consultar por empleado, fecha, tipo de intervención o referencia

* Si hay 10 tareas finalizadas en el mes, veo cantidad total de pares y tiempo promedio por par

* No se permiten duplicidades de registro

* Si una tarea ya fue contabilizada, no genera nuevo asiento

* Todos los registros quedan trazados en el historial

**HU-033: Contabilidad de Pares Fabricados Semanalmente**

**Prioridad:** Alta

**Como** administrador,  
**Quiero** consolidar semanalmente la cantidad total de pares fabricados,  
**Para** analizar la productividad periódica y apoyar la planificación operativa.

**Criterios de Aceptación:**

* El sistema genera automáticamente el corte semanal cada domingo a las 23:59

* Toma todas las tareas de fabricación marcadas como "completadas" durante los 7 días anteriores

* Puedo definir el inicio de la semana laboral

* El sistema valida que cada tarea esté cerrada y las unidades registradas en inventario

* Si hay discrepancia, excluye la tarea del corte y muestra motivo de exclusión

* El reporte incluye desglose obligatorio por modelo, categoría y estado final

* Asegura conciliación: pares producidos \= pares en inventario \+ pares en cuarentena \+ pares pérdida

* Cada registro incluye: semana calendario, fecha de corte, total de pares, desglose por referencia, talla, color, estilo, marca y empleado

* Si no hay producción en una semana, genera corte con valor cero

* No puedo editar el consolidado manualmente pero puedo consultarlo

* Puedo aplicar filtros por semana, referencia o empleado

* Al finalizar la semana, el reporte se envía automáticamente por correo al administrador

**HU-034: Contabilidad de Pares Totales Pedidos por Cliente Mensualmente**

**Prioridad:** Alta

**Como** administrador/gerente comercial,  
**Quiero** consolidar mensualmente la cantidad total de pares solicitados por cada cliente mayorista,  
**Para** analizar el comportamiento de compra y apoyar estrategias comerciales.

**Criterios de Aceptación:**

* El sistema genera automáticamente el corte mensual el último día de cada mes a las 23:59

* Toma todos los pedidos registrados por clientes mayoristas durante ese período

* Se excluyen pedidos cancelados o en estado "borrador"

* El sistema valida que cada pedido esté correctamente registrado con combinaciones definidas y cantidades válidas

* Si hay inconsistencia (combinaciones incompletas o cantidades nulas), excluye el pedido y registra motivo

* El reporte calcula: porcentaje de cumplimiento (pares entregados / pares solicitados) y porcentaje de entrega a tiempo

* Solo administrador y gerente comercial pueden acceder a este reporte

* Cada registro incluye: mes calendario, fecha de corte, cliente, total de pares solicitados, desglose por referencia, talla, color, estilo, marca y estado

* Si un cliente no registra pedidos en el mes, genera corte con valor cero

* No puedo editar el consolidado manualmente pero puedo consultarlo y exportarlo

* Puedo aplicar filtros por cliente, mes, estado del pedido o referencia

* Al filtrar por cliente y modelo específicos, veo solo esa información

* Si finaliza el mes, el reporte muestra total solicitado, total entregado y porcentaje de cumplimiento por cliente

