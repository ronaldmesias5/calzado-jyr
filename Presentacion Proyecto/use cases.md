# CASOS DE USO

**CU001: Crear Cuentas de Acceso**

**Actor(es):** Administrador del Sistema  
**Descripción:** Permite al administrador crear cuentas de acceso para clientes mayoristas y empleados, generando credenciales temporales y notificando a los usuarios.  
**Precondiciones:**

1. El administrador ha iniciado sesión con privilegios de administrador.

2. El módulo de gestión de usuarios está disponible y operativo.

**Flujo Principal:**

1. El administrador navega al módulo "Gestión de Usuarios" y selecciona "Crear Nueva Cuenta".

2. El sistema presenta un formulario con campos organizados en secciones:

   * **Datos Personales:** nombre completo, documento de identidad, teléfono, dirección, ciudad

   * **Datos de Cuenta:** correo electrónico, tipo de usuario (cliente mayorista/empleado/administrador)

3. El administrador completa todos los campos obligatorios marcados con asterisco rojo.

4. El administrador hace clic en "Validar y Crear Cuenta".

5. El sistema ejecuta validaciones en tiempo real:

   * Verifica formato válido de correo electrónico

   * Valida que el documento de identidad tenga el formato correcto

   * Consulta en base de datos por duplicados de correo y documento

6. Si no hay duplicados, el sistema genera una contraseña temporal que cumple: mínimo 10 caracteres, al menos una mayúscula, una minúscula, un número y un símbolo especial.

7. El sistema crea la cuenta con estado "Pendiente de Activación" y registra:

   * Fecha y hora de creación

   * Administrador que realizó la acción

   * Contraseña temporal generada (encriptada)

8. El sistema envía un correo automático al usuario que incluye:

   * Credenciales de acceso (correo y contraseña temporal)

   * Enlace de activación único válido por 24 horas

   * Instrucciones para primer acceso

9. El sistema muestra mensaje de confirmación: "Cuenta creada exitosamente. Se han enviado las credenciales al correo del usuario."

**Flujos Alternos:**

* **Correo Duplicado:** Si el correo electrónico ya existe en el sistema, muestra: "El correo electrónico ya está registrado en el sistema. Utilice otro correo o recupere la cuenta existente."

* **Documento Duplicado:** Si el documento de identidad ya está registrado, muestra: "El documento de identidad ya existe en el sistema. Verifique la información."

* **Formato Inválido:** Si algún campo tiene formato incorrecto, muestra mensaje específico: "Formato de correo electrónico inválido" o "Formato de documento incorrecto".

**Postcondiciones:**

1. La nueva cuenta queda registrada en base de datos con estado "Pendiente de Activación".

2. Las credenciales temporales han sido enviadas al correo del usuario.

3. Se genera registro de auditoría con: timestamp, administrador creador, tipo de usuario creado y datos de la cuenta.

4. El contador de cuentas pendientes de activación se incrementa en el dashboard del administrador.

**CU002: Inicio de Sesión en el Sistema**

**Actor(es):** Usuario Registrado (Cliente Mayorista, Empleado, Administrador)  
**Descripción:** Permite a los usuarios autenticarse en el sistema utilizando sus credenciales de acceso, con mecanismos de seguridad contra accesos no autorizados.  
**Precondiciones:**

1. El usuario tiene una cuenta creada en el sistema.

2. La cuenta no está bloqueada permanentemente.

3. El servicio de autenticación está operativo.

**Flujo Principal:**

1. El usuario accede a la página de inicio de sesión desde cualquier navegador web.

2. El sistema presenta el formulario de login con:

   * Campo para correo electrónico

   * Campo para contraseña

   * Enlace "¿Olvidó su contraseña?"

   * Checkbox "Recordar mis datos" (opcional)

3. El usuario ingresa su correo electrónico registrado y su contraseña actual.

4. El usuario hace clic en "Iniciar Sesión".

5. El sistema realiza validaciones:

   * Verifica que ambos campos no estén vacíos

   * Valida formato de correo electrónico

   * Encripta la contraseña ingresada y compara con el hash almacenado

6. Si las credenciales son correctas, el sistema:

   * Verifica que la cuenta esté activa y no suspendida

   * Registra el acceso exitoso en bitácora de auditoría

   * Genera un token de sesión válido por 20 minutos

   * Redirige al usuario a su dashboard según su rol:

     * **Administrador:** Panel de control completo

     * **Cliente Mayorista:** Catálogo interno y gestión de pedidos

     * **Empleado:** Lista de tareas asignadas

7. El sistema inicia un temporizador de inactividad de 20 minutos.

**Flujos Alternos:**

* **Campos Vacíos:** Si el usuario intenta enviar el formulario con campos vacíos, el sistema muestra: "Todos los campos marcados con \* son obligatorios" y resalta los campos faltantes en rojo.

* **Credenciales Incorrectas:**

  * El sistema muestra: "Correo electrónico o contraseña incorrectos. Verifique sus datos."

  * Incrementa el contador de intentos fallidos para esa cuenta

  * Si es el tercer intento fallido dentro de un período de 5 minutos, bloquea la cuenta por 30 minutos y muestra: "Cuenta bloqueada temporalmente por seguridad. Intente nuevamente en 30 minutos."

* **Cuenta Bloqueada:** Si la cuenta está bloqueada temporalmente, muestra: "Cuenta bloqueada por medidas de seguridad. Espere 30 minutos o contacte al administrador."

* **Cuenta Inactiva:** Si la cuenta está inactiva o suspendida, muestra: "Su cuenta no está activa. Contacte al administrador del sistema."

* **Primer Acceso:** Si es el primer acceso del usuario y tiene contraseña temporal, el sistema fuerza el cambio de contraseña antes de permitir el acceso al dashboard.

**Postcondiciones:**

1. El usuario tiene una sesión activa con token válido.

2. Se registra el acceso en bitácora de auditoría con: timestamp, dirección IP, usuario, tipo de acceso (éxito/fallo).

3. El contador de intentos fallidos se reinicia para accesos exitosos.

4. El usuario puede navegar en las funcionalidades según su rol asignado.

**CU003: Recuperación de Contraseña Olvidada**

**Actor(es):** Usuario Registrado  
**Descripción:** Permite a los usuarios recuperar el acceso a sus cuentas cuando han olvidado su contraseña, mediante un proceso seguro con enlaces temporales.  
**Precondiciones:**

1. El usuario tiene una cuenta activa en el sistema.

2. El servicio de correo electrónico está operativo.

**Flujo Principal:**

1. El usuario hace clic en "¿Olvidó su contraseña?" en la pantalla de login.

2. El sistema redirige al formulario de recuperación que solicita exclusivamente el correo electrónico.

3. El usuario ingresa su correo electrónico registrado y hace clic en "Enviar Enlace de Recuperación".

4. El sistema valida que el correo exista en la base de datos de usuarios activos.

5. El sistema genera:

   * Un token único de recuperación con hash seguro

   * Establece expiración de 60 minutos desde la generación

   * Registra la solicitud en bitácora de seguridad

6. El sistema envía un correo electrónico al usuario que incluye:

   * Enlace único de recuperación con el token embebido

   * Instrucciones claras para restablecer la contraseña

   * Advertencia de que el enlace expira en 60 minutos

   * Información de contacto si no solicitó el restablecimiento

7. El usuario recibe el correo y hace clic en el enlace de recuperación.

8. El sistema valida:

   * Que el token exista y no haya expirado

   * Que no haya sido utilizado previamente

9. El sistema presenta el formulario para nueva contraseña con:

   * Campo para nueva contraseña

   * Campo para confirmar nueva contraseña

   * Indicador visual de fortaleza de contraseña

10. El usuario ingresa y confirma su nueva contraseña.

11. El sistema valida que la contraseña cumpla los requisitos:

    * Mínimo 10 caracteres

    * Al menos una mayúscula, una minúscula, un número y un símbolo

    * No puede ser igual a las últimas 5 contraseñas utilizadas

12. El sistema actualiza la contraseña en la base de datos.

13. El sistema invalida:

    * La contraseña anterior inmediatamente

    * El token de recuperación utilizado

    * Cualquier sesión activa existente para el usuario

14. El sistema muestra: "Su contraseña ha sido actualizada exitosamente. Por favor, inicie sesión con su nueva contraseña."

**Flujos Alternos:**

* **Correo No Registrado:** Si el correo no existe en el sistema, no se muestra mensaje específico por seguridad, pero se registra en auditoría: "Intento de recuperación para correo no registrado: \[correo\]".

* **Enlace Expirado:** Si el usuario accede a un enlace expirado, el sistema muestra: "El enlace de recuperación ha expirado. Por favor, solicite uno nuevo desde la página de inicio de sesión."

* **Token Ya Utilizado:** Si el token ya fue utilizado, muestra: "Este enlace de recuperación ya fue utilizado. Solicite uno nuevo si aún necesita cambiar su contraseña."

* **Contraseña No Cumple Requisitos:** Si la nueva contraseña no cumple los requisitos, muestra mensaje específico: "La contraseña debe tener al menos 10 caracteres incluyendo mayúsculas, minúsculas, números y símbolos."

**Postcondiciones:**

1. La contraseña del usuario ha sido actualizada en el sistema.

2. Todas las sesiones activas previas han sido invalidadas.

3. El token de recuperación ha sido marcado como utilizado.

4. El proceso completo queda registrado en bitácora de seguridad con timestamp y dirección IP.

**CU004: Solicitud de Reactivación de Cuenta Suspendida**

**Actor(es):** Usuario con cuenta suspendida  
**Descripción:** Permite a usuarios con cuentas suspendidas solicitar su reactivación mediante un formulario detallado que genera un ticket de seguimiento para el administrador.  
**Precondiciones:**

1. El usuario tiene una cuenta en estado "Suspendida" en el sistema.

2. El usuario conoce sus credenciales de correo electrónico registrado.

**Flujo Principal:**

1. El usuario intenta iniciar sesión con sus credenciales correctas.

2. El sistema detecta que la cuenta está en estado "Suspendida" y redirige automáticamente al formulario de solicitud de reactivación.

3. El sistema presenta un formulario completo con los siguientes campos:

   * **Información de Identificación:** correo electrónico (pre-llenado y no editable), documento de identidad

   * **Motivo de Suspensión:** descripción del motivo original de suspensión (solo lectura)

   * **Solicitud de Reactivación:** campo de texto extenso para "Motivo detallado de la solicitud" con mínimo 200 caracteres

   * **Información de Contacto:** teléfono de contacto, evidencia opcional (botón para adjuntar archivos PDF, JPG, PNG hasta 10MB)

4. El usuario completa todos los campos obligatorios y adjunta evidencia de apoyo si está disponible.

5. El usuario hace clic en "Enviar Solicitud de Reactivación".

6. El sistema valida:

   * Que la cuenta efectivamente esté suspendida

   * Que el documento de identidad coincida con el registrado

   * Que el campo de motivo tenga al menos 200 caracteres

7. El sistema genera:

   * Un número de ticket único con formato: REACT-YYYYMMDD-XXXXX

   * Un registro completo de la solicitud con timestamp

   * Una notificación prioritaria en el panel de administración

8. El sistema muestra confirmación: "Su solicitud de reactivación ha sido enviada exitosamente. Número de ticket: \[número\]. Será contactado una vez se revise su solicitud."

**Flujos Alternos:**

* **Cuenta No Suspendida:** Si el usuario accede directamente al formulario pero su cuenta no está suspendida, el sistema detecta esta situación y muestra: "Su cuenta no requiere reactivación. Será redirigido al inicio de sesión en 5 segundos."

* **Documento No Coincide:** Si el documento de identidad ingresado no coincide con el registrado, muestra: "El documento de identidad no coincide con nuestros registros. Verifique la información."

* **Motivo Insuficiente:** Si el campo de motivo tiene menos de 200 caracteres, muestra: "Debe proporcionar un motivo detallado de al menos 200 caracteres para que podamos evaluar su solicitud."

**Postcondiciones:**

1. Se ha creado una solicitud de reactivación con estado "Pendiente de Revisión".

2. Se ha generado un ticket único de seguimiento.

3. El administrador principal recibe una notificación de alta prioridad.

4. La solicitud queda registrada en el historial de auditoría con todos los datos proporcionados.

5. El usuario recibe un correo de confirmación con su número de ticket.

**CU005: Registro de Productos en el Catálogo**

**Actor(es):** Administrador  
**Descripción:** Permite al administrador registrar nuevos productos en el catálogo digital con validación de referencia única y gestión de imágenes, asegurando la integridad de la información del producto.  
**Precondiciones:**

1. El administrador ha iniciado sesión con privilegios completos.

2. Existen categorías y marcas previamente configuradas en el sistema.

3. El módulo de catálogo está disponible.

**Flujo Principal:**

1. El administrador navega al módulo "Catálogo" y selecciona "Registrar Nuevo Producto".

2. El sistema presenta un formulario multipaso organizado en secciones:

**Paso 1 \- Información Básica:**

* Nombre del producto (campo texto, obligatorio)

  * Referencia única (campo texto, obligatorio, con botón "Verificar Disponibilidad")

  * Descripción (área de texto extensa con editor rich-text)

  * Categoría (dropdown con categorías activas)

  * Marca (dropdown con marcas activas)

  * Estado (radio buttons: Activo/Inactivo)

**Paso 2 \- Especificaciones Técnicas:**

* Tallas disponibles (checklist múltiple: 35-45)

  * Colores disponibles (checklist múltiple con muestras de color)

  * Material principal (dropdown)

  * Tipo de calzado (dropdown)

**Paso 3 \- Imágenes y Multimedia:**

* Imagen principal (upload con preview, formatos: JPG, PNG, máximo 5MB)

  * Imágenes secundarias (máximo 4 imágenes adicionales)

  * Validación automática de formato y tamaño

3. El administrador completa cada paso y hace clic en "Siguiente".

4. En el campo "Referencia única", el administrador ingresa la referencia y hace clic en "Verificar Disponibilidad".

5. El sistema consulta en tiempo real si la referencia ya existe:

   * Si está disponible: muestra "✓ Referencia disponible" en verde

   * Si está duplicada: muestra "✗ Referencia ya existe" en rojo

6. El administrador completa todos los campos obligatorios y sube las imágenes.

7. El sistema valida:

   * Que la referencia sea única

   * Que las imágenes sean formatos válidos (JPG/PNG)

   * Que no excedan el tamaño máximo

   * Que al menos una talla y un color estén seleccionados

8. El administrador hace clic en "Guardar Producto".

9. El sistema:

   * Almacena el producto en base de datos con estado "Activo" por defecto

   * Procesa y optimiza las imágenes para diferentes resoluciones

   * Genera URLs únicas para las imágenes

   * Crea el registro de auditoría completo

10. El sistema muestra: "✓ Producto registrado exitosamente. Referencia: \[referencia\]. ¿Desea registrar otro producto?"

**Flujos Alternos:**

* **Referencia Duplicada:** Si la referencia ya existe, el sistema bloquea el guardado y muestra: "La referencia \[referencia\] ya está registrada en el sistema. Utilice una referencia única o edite el producto existente."

* **Imagen Inválida:** Si se sube una imagen con formato no soportado, muestra: "Formato de imagen no válido. Solo se aceptan JPG y PNG. Archivo rechazado: \[nombre\_archivo\]."

* **Tamaño de Imagen Excedido:** Si la imagen excede 5MB, muestra: "La imagen \[nombre\_archivo\] excede el tamaño máximo de 5MB. Comprima la imagen o seleccione otra."

* **Campos Obligatorios Faltantes:** Si faltan campos obligatorios, el sistema muestra mensajes específicos por campo: "El campo \[nombre\_campo\] es obligatorio."

**Postcondiciones:**

1. El nuevo producto queda registrado en el catálogo con todos sus atributos.

2. Las imágenes han sido procesadas y almacenadas en el servidor.

3. El producto está disponible para visualización (si su estado es "Activo").

4. Se genera registro de auditoría con: timestamp, administrador creador, referencia del producto y todos los datos registrados.

5. El contador de productos activos se actualiza en el dashboard.

**CU006: Clasificación de Productos por Categorías**

**Actor(es):** Administrador  
**Descripción:** Permite al administrador organizar el catálogo mediante un sistema de categorías jerárquicas, con validaciones para mantener la integridad de los datos y relaciones entre productos y categorías.  
**Precondiciones:**

1. El administrador ha iniciado sesión con privilegios completos.

2. El módulo de categorías está disponible.

**Flujo Principal:**

1. El administrador navega a "Catálogo" \> "Gestión de Categorías".

2. El sistema presenta una interfaz con:

   * Árbol jerárquico de categorías existentes

   * Botones "Nueva Categoría", "Editar", "Eliminar"

   * Contador de productos por categoría

   * Estado (Activo/Inactivo) de cada categoría

3. **Crear Nueva Categoría:**

   * Administrador hace clic en "Nueva Categoría"

   * Sistema muestra formulario con:

     * Nombre de categoría (texto, obligatorio)

     * Categoría padre (dropdown con categorías existentes, opcional)

     * Descripción (área de texto)

     * Estado (Activo/Inactivo, activo por defecto)

     * Imagen representativa (opcional)

   * Administrador ingresa nombre único y hace clic en "Validar Nombre"

   * Sistema verifica que no exista categoría con mismo nombre en mismo nivel

   * Administrador completa datos y hace clic en "Guardar Categoría"

4. **Editar Categoría Existente:**

   * Administrador selecciona categoría en árbol y hace clic en "Editar"

   * Sistema muestra formulario pre-llenado con datos actuales

   * Administrador modifica campos necesarios

   * Sistema valida que nuevo nombre no genere duplicados

   * Administrador guarda cambios

5. **Eliminar Categoría:**

   * Administrador selecciona categoría y hace clic en "Eliminar"

   * Sistema verifica:

     * Si la categoría tiene productos activos asociados

     * Si tiene subcategorías dependientes

   * Si no tiene dependencias, elimina la categoría

   * Si tiene dependencias, ofrece opciones de reasignación

6. El sistema actualiza el árbol jerárquico en tiempo real.

**Flujos Alternos:**

* **Nombre Duplicado:** Al crear o editar, si el nombre existe en mismo nivel, muestra: "Ya existe una categoría con el nombre '\[nombre\]' en este nivel. Utilice un nombre único."

* **Eliminar Categoría con Productos:** Si la categoría tiene productos activos, muestra: "No se puede eliminar la categoría '\[nombre\]' porque tiene \[número\] productos activos asociados. Reasigne los productos antes de eliminar."

* **Eliminar Categoría con Subcategorías:** Si la categoría tiene subcategorías, muestra: "No se puede eliminar la categoría '\[nombre\]' porque tiene \[número\] subcategorías. Debe eliminar o reasignar las subcategorías primero."

* **Reasignación de Productos:** Si el administrador elige reasignar productos, el sistema muestra un asistente para seleccionar nueva categoría destino para todos los productos.

**Postcondiciones:**

1. La estructura de categorías ha sido actualizada según los cambios realizados.

2. Los productos mantienen su categorización correcta.

3. El catálogo refleja los cambios inmediatamente en filtros y navegación.

4. Se genera registro de auditoría con: timestamp, administrador, acción realizada y categorías afectadas.

5. El menú de navegación del catálogo se actualiza automáticamente.

**CU007: Gestión de Marcas y Estilos de Productos**

**Actor(es):** Administrador  
**Descripción:** Permite administrar el portafolio de marcas y sus estilos asociados, manteniendo la identidad corporativa y organizando las líneas de diseño del calzado.  
**Precondiciones:**

1. El administrador ha iniciado sesión con privilegios completos.

2. El módulo de marcas y estilos está disponible.

**Flujo Principal:**

1. El administrador navega a "Catálogo" \> "Marcas y Estilos".

2. El sistema presenta pestañas separadas para "Marcas" y "Estilos".

**Gestión de Marcas:**

* Lista de marcas existentes con: nombre, estado, cantidad de productos, fecha creación

  * Botones "Nueva Marca", "Editar", "Eliminar", "Ver Estilos"

  * Filtros por estado (Activo/Inactivo/Todos)

3. **Crear Nueva Marca:**

   * Administrador hace clic en "Nueva Marca"

   * Sistema muestra formulario con:

     * Nombre de marca (texto, obligatorio, único)

     * Descripción (área de texto)

     * Logo (upload opcional, PNG/JPG, máximo 2MB)

     * Estado (Activo/Inactivo)

     * Información de contacto del proveedor (opcional)

   * Administrador ingresa nombre y hace clic en "Validar Nombre"

   * Sistema verifica unicidad del nombre

   * Administrador completa datos y guarda

4. **Gestión de Estilos por Marca:**

   * Administrador selecciona marca y hace clic en "Ver Estilos"

   * Sistema muestra lista de estilos asociados a esa marca

   * Botones "Nuevo Estilo", "Editar Estilo", "Eliminar Estilo"

5. **Crear Nuevo Estilo:**

   * Administrador hace clic en "Nuevo Estilo"

   * Sistema muestra formulario con:

     * Nombre del estilo (texto, obligatorio, único dentro de la marca)

     * Descripción (área de texto)

     * Características técnicas (campo texto)

     * Año de colección (dropdown)

     * Estado (Activo/Inactivo)

     * Imágenes de referencia (opcional)

   * Administrador completa y guarda

6. **Vincular Estilos a Productos:**

   * Al crear/editar producto, el sistema muestra dropdown de estilos filtrado por la marca seleccionada

   * Administrador asigna estilo al producto

**Flujos Alternos:**

* **Marca con Productos Activos:** Al intentar eliminar marca con productos activos, muestra: "No se puede eliminar la marca '\[nombre\]' porque tiene \[número\] productos activos asociados. Desactive los productos primero."

* **Estilo con Productos Activos:** Al intentar eliminar estilo con productos activos, muestra: "No se puede eliminar el estilo '\[nombre\]' porque tiene \[número\] productos activos. Desactive los productos primero."

* **Nombre de Marca Duplicado:** Al crear/editar marca, si el nombre existe, muestra: "Ya existe una marca con el nombre '\[nombre\]'. Utilice un nombre único."

* **Nombre de Estilo Duplicado:** Al crear estilo, si el nombre existe en la misma marca, muestra: "Ya existe un estilo con el nombre '\[nombre\]' en esta marca. Utilice un nombre único."

**Postcondiciones:**

1. El portafolio de marcas y estilos ha sido actualizado.

2. Los productos pueden ser correctamente asociados a marcas y estilos.

3. Los filtros del catálogo se actualizan con las nuevas marcas/estilos.

4. Se genera registro de auditoría con todas las operaciones realizadas.

5. La navegación por marca y estilo en el catálogo refleja los cambios inmediatamente.

**CU008: Visualización Pública del Catálogo**

**Actor(es):** Visitante (sin cuenta)  
**Descripción:** Permite a cualquier usuario sin registro previo explorar el catálogo completo de productos disponibles, con funcionalidades de filtrado y visualización limitada a información pública.  
**Precondiciones:**

1. El visitante accede a la URL pública del sistema.

2. El servicio web está operativo y disponible.

3. Existen productos marcados como "Activos" y "Públicos" en el catálogo.

**Flujo Principal:**

1. El visitante ingresa al sitio web y el sistema carga la página principal con:

   * Header con logo, menú de navegación y botón "Iniciar Sesión"

   * Sección hero con imagen promocional y call-to-action "Ver Catálogo"

   * Preview de productos destacados

2. El visitante hace clic en "Ver Catálogo Completo" o navega a "Productos" en el menú principal.

3. El sistema carga la página de catálogo público con:

   * **Barra lateral izquierda:** Sistema de filtros avanzados

     * Filtro por Categoría (treeview jerárquico)

     * Filtro por Marca (checklist con logos)

     * Filtro por Estilo (checklist)

     * Filtro por Talla (checklist numérico 35-45)

     * Filtro por Color (checklist con muestras visuales)

   * **Área principal:** Grid de productos responsivo

     * Cada producto muestra: imagen principal, referencia, nombre, marca, estilo

     * Badge "Nuevo" para productos agregados en últimos 30 días

     * Iconos de tallas y colores disponibles

4. El visitante aplica múltiples filtros de forma simultánea:

   * Selecciona categoría "Zapatos Deportivos"

   * Marca "RunnerPro"

   * Talla "40"

   * Color "Azul"

5. El sistema procesa los filtros en tiempo real mediante AJAX:

   * Actualiza el contador de resultados: "Mostrando 8 de 245 productos"

   * Renderiza solo los productos que cumplen todos los criterios

   * Mantiene la URL actualizable para compartir búsquedas

6. El visitante hace clic en un producto específico para ver detalles.

7. El sistema muestra modal o página de detalle con:

   * Galería de imágenes del producto (máximo 5 vistas)

   * Información técnica completa (excepto precios y stock)

   * Especificaciones: materiales, cuidados, origen

   * Botón "Ver tallas y colores disponibles" (redirige a registro)

8. El visitante puede:

   * Compartir producto en redes sociales

   * Guardar producto como favorito (redirige a registro)

   * Ver productos relacionados

**Flujos Alternos:**

* **Sin Productos Disponibles:** Si no hay productos que coincidan con los filtros, el sistema muestra estado vacío con: "No encontramos productos con los filtros seleccionados.  Intente con otros criterios o \[limpiar todos los filtros\]."

* **Acceso a Funciones Premium:** Cuando el visitante intenta acceder a funciones restringidas (ver precios, agregar a favoritos, ver disponibilidad), el sistema muestra modal educativa: "Para acceder a precios y disponibilidad debe \[registrarse como cliente mayorista\] o \[iniciar sesión\]."

* **Catálogo Vacío:** Si no hay productos activos en el sistema, muestra: "Nuestro catálogo se está actualizando. Vuelva pronto para descubrir nuestra nueva colección."

* **Error de Carga:** Si hay problemas técnicos al cargar el catálogo, muestra: "Estamos experimentando dificultades técnicas. Por favor, intente nuevamente en unos minutos."

**Postcondiciones:**

1. El visitante ha explorado el catálogo público satisfactoriamente.

2. Los filtros aplicados quedan registrados en analytics para análisis de comportamiento.

3. Las impresiones de productos se registran para métricas de engagement.

4. El sistema mantiene el performance con carga eficiente de imágenes (lazy loading).

5. La experiencia responsive se mantiene en dispositivos móviles y desktop.

**CU009: Consulta de Catálogo como Cliente Mayorista**

**Actor(es):** Cliente Mayorista autenticado  
**Descripción:** Proporciona a clientes mayoristas autenticados acceso al catálogo completo con información de disponibilidad en tiempo real, funcionalidades avanzadas de favoritos y herramientas para preparar pedidos.  
**Precondiciones:**

1. El cliente mayorista ha iniciado sesión con credenciales válidas.

2. La cuenta del cliente tiene estado "Activo" y permisos de compra.

3. El servicio de inventario en tiempo real está operativo.

**Flujo Principal:**

1. Tras iniciar sesión, el sistema redirige al cliente a su dashboard personalizado.

2. El cliente hace clic en "Catálogo Interno" en el menú principal.

3. El sistema carga la interfaz avanzada de catálogo con:

   * **Header especializado:** Buscador avanzado, filtros rápidos, selector de vista (grid/lista)

   * **Panel de control izquierdo:** Filtros avanzados con estados de disponibilidad

     * Filtro por stock: "En stock", "Bajo stock", "Sin stock", "Disponible pronto"

     * Filtro por tiempo de entrega: "Inmediato", "1-2 semanas", "3+ semanas"

     * Filtro por novedades: "Nuevos últimos 7 días", "Próximos lanzamientos"

   * **Área principal:** Grid de productos con información extendida

     * Cada producto muestra: imagen, referencia, nombre, marca, estilo

     * **Etiqueta de disponibilidad:** "Stock: 150 unidades", "Bajo stock: 5 unidades", "Agotado"

     * **Precio mayorista** con descuentos por volumen

     * **Tiempo de entrega estimado**

     * Botones "Agregar a favoritos"  y "Agregar a pedido" (+)

4. El cliente utiliza la función de favoritos:

   * Hace clic en  para agregar producto a favoritos

   * El sistema guarda la preferencia en su perfil inmediatamente

   * Los favoritos persisten entre sesiones

   * Puede acceder a "Mis Favoritos" desde menú rápido

5. El cliente aplica filtro "En stock" y ordena por "Precio menor a mayor".

6. El sistema actualiza la vista en tiempo real mostrando solo productos disponibles.

7. El cliente selecciona productos para pedido:

   * Hace clic en "+" en un producto

   * El sistema muestra modal para especificar: talla, color, cantidad

   * El cliente selecciona talla "39", color "Negro", cantidad "25"

   * El sistema valida stock disponible en tiempo real

   * Si hay stock, agrega al carrito de pedido temporal

8. El cliente puede alternar entre "Vista catálogo" y "Vista pedido en progreso".

**Flujos Alternos:**

* **Stock Insuficiente:** Si el cliente solicita más unidades de las disponibles, el sistema muestra: "Stock insuficiente. Máximo disponible: \[X\] unidades. ¿Desea agregar las \[X\] unidades disponibles?"

* **Producto Descontinuado:** Si intenta acceder a producto marcado como inactivo, muestra: "Este producto ya no está disponible en nuestro catálogo. Consulte productos similares \[enlace\]."

* **Sin Conexión en Tiempo Real:** Si el servicio de inventario no responde, muestra: "Información de disponibilidad temporalmente no disponible. Los pedidos estarán sujetos a confirmación de stock."

* **Límite de Crédito Excedido:** Si el pedido en progreso excede su límite de crédito, muestra advertencia: "Su pedido actual (\[$X\]) excede su límite de crédito disponible (\[$Y\]). Contacte a su ejecutivo para aumentar su límite."

**Postcondiciones:**

1. El cliente ha consultado el catálogo con información actualizada de disponibilidad y precios.

2. Los productos han sido agregados a favoritos según sus preferencias.

3. El pedido en progreso contiene los productos seleccionados con cantidades validadas.

4. Las búsquedas y patrones de navegación quedan registrados para análisis comercial.

5. El sistema ha mantenido actualización en tiempo real del stock durante toda la sesión.

**CU010: Filtrado y Búsqueda Avanzada de Productos**

**Actor(es):** Usuario del catálogo (Visitante o Cliente Mayorista)  
**Descripción:** Ofrece capacidades avanzadas de filtrado y búsqueda semántica para localizar productos específicos en el catálogo mediante múltiples criterios combinables y búsqueda por texto libre con coincidencias parciales.  
**Precondiciones:**

1. El usuario tiene acceso al catálogo (público o interno según su rol).

2. El servicio de búsqueda y indexación está operativo.

**Flujo Principal:**

1. El usuario accede al catálogo y el sistema presenta la interfaz de búsqueda:

   * **Barra de búsqueda principal:** Campo de texto con placeholder "Buscar productos por nombre, referencia, marca, descripción..."

   * **Botón de búsqueda avanzada:** Que expande panel de filtros múltiples

   * **Filtros rápidos:** "Novedades", "Más vendidos", "Ofertas" (según rol)

2. **Búsqueda por Texto Libre:**

   * Usuario ingresa "zapato casual cuero" en la barra de búsqueda

   * El sistema activa autocompletado con sugerencias en tiempo real

   * Al presionar Enter o hacer clic en buscar, el sistema ejecuta búsqueda semántica:

     * Busca en campos: nombre, referencia, descripción, marca, estilo, características

     * Aplica algoritmo de coincidencias parciales y stemming

     * Ordena resultados por relevancia calculada

   * Muestra resultados: "Encontramos 45 productos para 'zapato casual cuero'"

3. **Filtrado Avanzado Multi-criterio:**

   * Usuario expande panel de búsqueda avanzada

   * Aplica múltiples filtros simultáneamente:

     * Rango de precios: $50,000 \- $150,000 (con slider visual)

     * Categorías: "Zapatos Formales" \+ "Zapatos Casuales" (selección múltiple)

     * Marcas: "UrbanStep", "ClassicWalk" (checklist con search dentro del dropdown)

     * Tallas: 38, 39, 40 (checklist con agrupación por tipo de calzado)

     * Colores: Negro, Café, Azul Marino (checklist con muestras de color)

     * Disponibilidad: "Solo con stock" (toggle switch)

   * El sistema aplica todos los filtros con operador AND

   * Actualiza contador: "8 productos coinciden con todos los filtros"

4. **Combinación Búsqueda \+ Filtros:**

   * Usuario combina búsqueda textual "runner" con filtros de marca "SportMax" y talla "42"

   * El sistema intersecta resultados de búsqueda con filtros aplicados

   * Muestra productos que cumplen todas las condiciones

5. **Gestión de Resultados:**

   * Sistema proporciona botón "Limpiar todos los filtros" prominentemente

   * Muestra "breadcrumb" de filtros aplicados con opción de eliminar individualmente

   * Ofrece opciones de ordenamiento: "Relevancia", "Precio", "Novedad", "Nombre"

**Flujos Alternos:**

* **Sin Coincidencias:** Cuando no hay resultados, muestra estado vacío con: "No encontramos productos que coincidan con su búsqueda. Sugerencias: • Verifique la ortografía • Use términos más generales • \[Limpiar filtros y ver todo el catálogo\]"

* **Búsqueda con Resultados Amplios:** Si la búsqueda retorna más de 100 productos, muestra: "Encontramos 250+ productos. Recomendamos usar filtros adicionales para refinar su búsqueda."

* **Error de Búsqueda:** Si el servicio de búsqueda falla, muestra: "Nuestra búsqueda no está disponible temporalmente. Mostrando productos destacados. \[Reintentar\]"

* **Filtros en Conflicto:** Si los filtros aplicados son mutuamente excluyentes, muestra: "Los filtros seleccionados no generan resultados. Intente relajar algunos criterios."

**Postcondiciones:**

1. El usuario ha localizado productos específicos mediante el sistema de búsqueda avanzada.

2. Los criterios de búsqueda y filtrado quedan registrados en analytics.

3. El sistema ha mantenido alto performance incluso con combinaciones complejas de filtros.

4. La experiencia de usuario ha sido responsive y fluida durante todo el proceso.

5. Los resultados mostrados son consistentes con los permisos y visibilidad del rol del usuario.

**CU011: Creación de Pedidos de Fabricación**

**Actor(es):** Cliente Mayorista  
**Descripción:** Permite a clientes mayoristas crear pedidos de fabricación seleccionando productos del catálogo, especificando tallas, colores y cantidades, con validaciones de cantidades mínimas y disponibilidad.  
**Precondiciones:**

1. El cliente mayorista ha iniciado sesión con cuenta activa.

2. Existen productos activos en el catálogo con disponibilidad.

3. El cliente tiene límite de crédito vigente.

**Flujo Principal:**

1. El cliente navega a "Nuevo Pedido" desde su dashboard.

2. El sistema presenta interfaz de creación de pedido con:

   * **Panel izquierdo:** Catálogo filtrado con funcionalidad de agregar al pedido

   * **Panel derecho:** Resumen del pedido en tiempo real con acumuladores

   * **Barra de estado:** Indicador de cantidad mínima requerida

3. **Selección de Productos:**

   * Cliente navega por el catálogo o usa búsqueda para encontrar productos

   * Para cada producto, hace clic en "Agregar al Pedido"

   * Sistema muestra modal de especificación:

     * Selector de talla (dropdown con solo tallas disponibles)

     * Selector de color (dropdown con solo colores disponibles)

     * Campo de cantidad (numérico con incrementadores)

     * Visualización de stock actual: "Disponible: 150 unidades"

   * Cliente selecciona talla "40", color "Negro", cantidad "30"

   * Sistema valida stock en tiempo real

   * Cliente confirma y producto se agrega al pedido

4. **Gestión del Pedido:**

   * El sistema actualiza en tiempo real:

     * Contador de items: "3 productos en el pedido"

     * Cantidad total: "85 unidades"

     * Progreso hacia cantidad mínima: "12/100 unidades (85%)"

   * Cliente puede editar items existentes:

     * Cambiar cantidades

     * Eliminar items

     * Modificar tallas/colores

5. **Validación y Envío:**

   * Cliente hace clic en "Revisar y Enviar Pedido"

   * Sistema ejecuta validaciones finales:

     * Cantidad total ≥ cantidad mínima configurada (100 unidades)

     * Todos los items tienen talla, color y cantidad válidos

     * No hay conflictos de disponibilidad

   * Si todo es válido, sistema muestra resumen final para confirmación

   * Cliente hace clic en "Confirmar Pedido"

6. **Procesamiento del Pedido:**

   * Sistema genera número único de pedido: "PED-20240527-0015"

   * Determina automáticamente el estado:

     * "Aprobado para entrega" (si todo el stock está disponible)

     * "Pendiente de fabricación" (si requiere producción)

     * "Parcialmente disponible" (si mixed availability)

   * Asigna estado inicial "Pendiente de revisión"

   * Registra pedido en base de datos con todos los detalles

   * Ejecuta notificaciones automáticas a administradores

**Flujos Alternos:**

* **Cantidad Mínima No Alcanzada:** Si la cantidad total es menor al mínimo, muestra: "No puede enviar el pedido. Cantidad mínima requerida: 100 unidades. Su pedido actual: 85 unidades. Agregue 15 unidades más."

* **Stock Insuficiente Durante Validación:** Si el stock cambió durante el proceso, muestra: "El stock para \[Producto X\] ha cambiado. Máximo disponible ahora: \[Y\] unidades. Ajuste su pedido."

* **Límite de Crédito Excedido:** Si excede límite de crédito, muestra: "Pedido excede su límite de crédito por \[$X\]. Máximo permitido: \[$Y\]. Elimine algunos items o contacte a su ejecutivo."

* **Pedido Vacío:** Si intenta enviar pedido sin productos, muestra: "Su pedido está vacío. Agregue al menos un producto antes de enviar."

**Postcondiciones:**

1. Se ha creado un nuevo pedido con estado "Pendiente de revisión".

2. El número único de pedido ha sido asignado y notificado al cliente.

3. El stock reservado ha sido actualizado (para items con disponibilidad inmediata).

4. Las notificaciones automáticas han sido enviadas al equipo comercial.

5. El pedido queda registrado en auditoría con todos los detalles y timestamp.

6. El cliente puede acceder al pedido desde "Mis Pedidos" para seguimiento.

**CU012: Notificación Automática de Nuevos Pedidos**

**Actor(es):** Sistema  
**Descripción:** Genera y distribuye notificaciones automáticas e inmediatas cuando un cliente registra un nuevo pedido, asegurando que el equipo interno pueda procesarlo rápidamente.  
**Precondiciones:**

1. Un cliente mayorista ha creado y confirmado un nuevo pedido en el sistema.

2. Existen administradores, gerentes comerciales o planificadores con notificaciones activas.

3. Los servicios de notificación y correo electrónico están operativos.

**Flujo Principal:**

1. El sistema detecta que un pedido ha cambiado a estado "Confirmado" tras la creación exitosa.

2. El sistema recopila toda la información relevante del pedido:

   * ID único del pedido y fecha/hora de creación

   * Información del cliente: nombre, código de cliente, categoría

   * Resumen del pedido: cantidad total de unidades, cantidad de referencias distintas

   * Detalle de combinaciones: productos, tallas, colores, cantidades por item

   * Estado automáticamente asignado: "Aprobado para entrega" o "Pendiente de fabricación"

   * Tiempo de procesamiento estimado basado en complejidad

3. El sistema identifica a los destinatarios de la notificación según reglas predefinidas:

   * **Administradores del sistema** (siempre)

   * **Gerente comercial** asignado al cliente

   * **Planificador de producción** (si el pedido requiere fabricación)

   * **Jefe de bodega** (si el pedido tiene items para entrega inmediata)

4. El sistema genera notificaciones en múltiples canales simultáneamente:

**Notificación In-App (Tiempo Real):**

* Crea alerta en el panel principal de cada destinatario

  * Muestra badge rojo con número en el icono de notificaciones

  * Incluye botón "Ver Detalles" que redirige directamente al pedido

**Correo Electrónico (Si está habilitado):**

* Envía email con asunto: "NUEVO PEDIDO \- \[ID Pedido\] \- \[Cliente\] \- \[Total Unidades\]"

  * Cuerpo del email con tabla resumen del pedido

  * Destaca si el pedido es para entrega directa o requiere producción

  * Incluye enlace seguro para acceder directamente al sistema

5. El sistema actualiza el tablero de pedidos pendientes en tiempo real.

6. Los destinatarios reciben las notificaciones y pueden actuar inmediatamente.

**Flujos Alternos:**

* **Pedido No Confirmado:** Si el pedido no se registra completamente o falla la validación, el sistema no genera notificaciones y registra el error: "Pedido \[ID\] no cumplió validaciones \- Notificación omitida".

* **Destinatarios No Disponibles:** Si algún destinatario está de vacaciones o ausente, el sistema escala la notificación al reemplazo designado o al supervisor directo.

* **Servicio de Email Caído:** Si el servicio de correo no responde, el sistema registra el fallo pero mantiene las notificaciones in-app, e intenta reenviar el email cada 5 minutos hasta por 30 minutos.

* **Pedido de Prueba:** Si el pedido es identificado como de prueba (cliente demo), el sistema omite las notificaciones o las marca como "\[TEST\]".

**Postcondiciones:**

1. Las notificaciones han sido entregadas exitosamente a todos los destinatarios designados.

2. El pedido aparece destacado en el panel de "Pedidos Recientes" del equipo interno.

3. Se ha registrado en auditoría el envío de cada notificación con timestamp y destinatarios.

4. El equipo interno tiene visibilidad inmediata para comenzar el procesamiento del pedido.

5. No se han generado notificaciones duplicadas para el mismo evento.

**CU013: Consulta de Estado de Mis Pedidos**

**Actor(es):** Cliente Mayorista  
**Descripción:** Proporciona a los clientes mayoristas una vista completa del historial y estado actual de todos sus pedidos, con líneas de tiempo detalladas y alertas proactivas sobre retrasos.  
**Precondiciones:**

1. El cliente mayorista ha iniciado sesión con credenciales válidas.

2. El cliente tiene al menos un pedido registrado en el sistema.

**Flujo Principal:**

1. El cliente accede a la sección "Mis Pedidos" desde su menú principal.

2. El sistema carga una vista maestra con:

   * **Filtros superiores:** Por estado (Todos, Pendiente, Aprobado, En Producción, Completado, Entregado, Cancelado), por fecha (Este mes, Últimos 3 meses, Personalizado)

   * **Barra de búsqueda:** Para buscar por número de pedido o referencia de producto

   * **Vista de resumen:** Tarjetas con contadores por estado

3. **Lista de Pedidos:**

   * Sistema muestra grid con columnas: Número Pedido, Fecha, Estado Actual, Total Unidades, Progreso

   * Cada fila es expandible para ver detalles completos

   * Estados con codificación de colores:

     *  Pendiente,  Aprobado , En Producción , Completado , Entregado,  Cancelado

4. **Detalle de Pedido Específico:**

   * Cliente hace clic en "Ver Detalles" en cualquier pedido

   * Sistema muestra vista detallada con pestañas:

     * **Resumen General:** Información básica del pedido

     * **Items del Pedido:** Tabla con productos, tallas, colores, cantidades, estado por item

     * **Línea de Tiempo:** Historial visual de cambios de estado con fechas y responsables

     * **Documentos:** Facturas, packing lists disponibles para descarga

5. **Seguimiento en Tiempo Real:**

   * Cliente monitorea pedidos en producción viendo actualizaciones automáticas

   * Sistema muestra porcentaje de avance en items que están en fabricación

   * Para pedidos "En Producción", muestra etapa actual: "Corte", "Ensamblaje", "Acabado"

6. **Alertas Automáticas:**

   * Sistema detecta posibles retrasos comparando fecha prometida vs fecha actual

   * Muestra indicadores: " En riesgo de retraso", "Retrasado X días"

   * Proporciona explicación del retraso si está disponible

**Flujos Alternos:**

* **Sin Pedidos:** Si el cliente no tiene pedidos registrados, muestra estado vacío con: "Aún no tiene pedidos registrados. \[Crear primer pedido\] para comenzar."

* **Pedido con Discrepancias:** Si hay diferencias entre cantidades pedidas y entregadas, muestra alerta: "Nota: Este pedido fue entregado parcialmente. Ver detalles en \[historial de entregas\]."

* **Acceso a Pedido de Otro Cliente:** El sistema valida rigurosamente que el cliente solo pueda ver sus propios pedidos. Si intenta acceder a pedido ajeno, muestra: "No tiene permisos para ver este pedido."

* **Información de Producción Confidencial:** El sistema oculta información interna de producción, mostrando solo estados generales al cliente.

**Postcondiciones:**

1. El cliente tiene visibilidad completa del estado actual de todos sus pedidos.

2. Las líneas de tiempo proporcionan transparencia en el proceso de fulfillment.

3. Las alertas proactivas permiten al cliente anticiparse a posibles problemas.

4. El sistema ha mantenido la segregación de datos entre diferentes clientes.

5. La experiencia de consulta ha sido rápida y responsive incluso con historial extenso.

**CU014: Actualización de Estado de Pedidos**

**Actor(es):** Administrador, Gerente Comercial  
**Descripción:** Permite al equipo interno modificar el estado de los pedidos según su disponibilidad o avance en el proceso de fabricación, manteniendo transiciones lógicas y registro completo de cambios.  
**Precondiciones:**

1. El usuario ha iniciado sesión con permisos de administrador o gerente comercial.

2. Existe al menos un pedido en el sistema con estado modificable.

3. El usuario tiene permisos sobre el módulo de pedidos específico.

**Flujo Principal:**

1. El usuario accede al módulo "Gestión de Pedidos" desde el panel de administración.

2. El sistema muestra lista de pedidos con filtros avanzados por estado, cliente, fecha y prioridad.

3. El usuario selecciona un pedido específico y hace clic en "Gestionar Estado".

4. El sistema presenta interfaz de gestión de estado con:

   * **Estado Actual:** Muestra claramente el estado presente del pedido

   * **Transiciones Disponibles:** Botones para estados posibles según lógica de negocio

   * **Historial de Cambios:** Lista cronológica de cambios previos

5. **Proceso de Cambio de Estado:**

   * Usuario selecciona nuevo estado de las opciones disponibles

   * Sistema valida que la transición sea lógica:

     * De "Pendiente" → "Aprobado" o "Cancelado"

     * De "Aprobado" → "En Producción" o "Cancelado"

     * De "En Producción" → "Completado"

     * De "Completado" → "Entregado"

   * Sistema solicita **motivo obligatorio** para el cambio

   * Usuario ingresa descripción detallada: "Pedido aprobado por gerencia tras verificación de stock"

   * Usuario confirma el cambio

6. **Acciones Automáticas por Estado:**

   * **Al cambiar a "Aprobado":** Sistema genera automáticamente orden de producción

   * **Al cambiar a "Aprobado para entrega":** Sistema verifica disponibilidad en bodega

   * **Al cambiar a "En Producción":** Sistema notifica a planta de producción

   * **Al cambiar a "Fabricado":** Sistema valida que pasó por control de calidad

   * **Al cambiar a "Entregado":** Sistema valida transición desde "Aprobado para entrega"

7. **Notificaciones Automáticas:**

   * Sistema notifica al cliente sobre el cambio de estado

   * Actualiza dashboards y reportes en tiempo real

   * Registra el cambio en historial de auditoría

**Flujos Alternos:**

* **Transición Inválida:** Si el usuario intenta una transición no permitida, el sistema bloquea la acción y muestra: "Transición no permitida: No puede cambiar de '\[Estado Actual\]' a '\[Estado Destino\]'. Transiciones válidas: \[Lista de estados válidos\]."

* **Motivo Insuficiente:** Si el motivo ingresado es muy breve o genérico, el sistema solicita: "Por favor, proporcione un motivo más detallado para este cambio de estado (mínimo 20 caracteres)."

* **Validación de Precondiciones Fallida:** Si no se cumplen precondiciones para el estado destino (ej: stock insuficiente para "Aprobado para entrega"), muestra: "No puede cambiar a este estado porque \[razón específica\]. Resuelva el problema antes de intentar nuevamente."

* **Cambio Masivo de Estados:** El sistema permite cambiar estado a múltiples pedidos simultáneamente si cumplen criterios comunes.

**Postcondiciones:**

1. El estado del pedido ha sido actualizado correctamente.

2. El motivo del cambio ha sido registrado en el historial del pedido.

3. Las acciones automáticas asociadas al nuevo estado se han ejecutado.

4. El cliente ha sido notificado sobre el cambio de estado.

5. El registro de auditoría incluye: usuario, timestamp, estado anterior, estado nuevo, motivo y IP.

6. Los dashboards y reportes reflejan el nuevo estado inmediatamente.

**CU015: Control de Inventario de Calzado Fabricado**

**Actor(es):** Administrador, Jefe de Bodega  
**Descripción:** Permite registrar y controlar meticulosamente el inventario de calzado terminado, gestionando ingresos, salidas y ajustes con validaciones en tiempo real.  
**Precondiciones:**

1. El usuario ha iniciado sesión con permisos de inventario.

2. Las referencias de producto existen en el catálogo.

3. El módulo de inventario está operativo.

**Flujo Principal:**

1. El usuario accede a "Inventario" \> "Gestión de Stock" desde el menú principal.

2. El sistema presenta dashboard de inventario con:

   * **Métricas clave:** Total unidades, Valor total stock, Productos bajos en stock

   * **Alertas destacadas:** Productos bajo stock mínimo, Stock vencido

   * **Acciones rápidas:** "Registrar Ingreso", "Registrar Salida", "Ajuste Manual"

3. **Registro de Ingresos:**

   * Usuario hace clic en "Registrar Ingreso"

   * Sistema muestra formulario con campos:

     * Referencia (con autocompletado desde catálogo)

     * Talla (dropdown filtrado por referencia seleccionada)

     * Color (dropdown filtrado por referencia y talla)

     * Cantidad (numérico positivo)

     * Origen (dropdown: Producción Interna, Devolución, Compra, Ajuste)

     * Fecha de ingreso (default: fecha actual)

     * Lote/Serie (opcional)

     * Observaciones

   * Usuario completa datos y hace clic en "Validar Ingreso"

   * Sistema verifica que la combinación referencia-talla-color exista en catálogo

   * Usuario confirma y sistema registra el ingreso

4. **Movimientos Automáticos:**

   * Cuando un pedido se aprueba para entrega, el sistema descuenta automáticamente del inventario

   * Los descuentos se registran con motivo "Despacho Pedido \[ID Pedido\]"

   * El sistema valida stock antes de permitir el descuento automático

5. **Alertas de Stock Bajo:**

   * Sistema monitorea continuamente niveles de stock

   * Cuando cantidad ≤ umbral mínimo configurado, genera alerta

   * Alertas aparecen en dashboard y notifican a usuarios designados

6. **Consultas y Reportes:**

   * Usuario puede filtrar inventario por múltiples criterios

   * Sistema genera reportes de movimientos por período

   * Historial completo de cada ítem disponible para consulta

**Flujos Alternos:**

* **Referencia No Existente:** Si la referencia ingresada no existe en catálogo, muestra: "La referencia '\[referencia\]' no existe en el catálogo. Verifique o \[agregue nueva referencia\]."

* **Salida Mayor al Stock:** Si intenta registrar salida con cantidad mayor al disponible, muestra: "Stock insuficiente. Máximo disponible: \[X\] unidades. Ajuste la cantidad o verifique disponibilidad."

* **Combinación Inválida:** Si la combinación referencia-talla-color no existe, muestra: "Esta combinación no está definida en el catálogo. Debe \[crear la combinación\] antes de registrar inventario."

* **Movimiento Duplicado:** Si detecta posible duplicidad, muestra advertencia: "Ya existe un movimiento similar registrado hoy. ¿Está seguro de que este es un movimiento diferente?"

**Postcondiciones:**

1. El inventario ha sido actualizado reflejando el movimiento registrado.

2. Los niveles de stock se han recalculado automáticamente.

3. Las alertas de stock bajo se han generado si corresponde.

4. El movimiento queda registrado en historial con: timestamp, usuario, tipo de movimiento, cantidades, referencia.

5. Los reportes de inventario reflejan los cambios inmediatamente.

6. La trazabilidad del producto se mantiene completa desde ingreso hasta salida.

**CU016: Actualización Automática de Inventario desde Producción**

**Actor(es):** Sistema  
**Descripción:** Actualiza automáticamente el inventario de calzado terminado cuando un pedido completado es aprobado por control de calidad, manteniendo la integridad de los datos sin intervención manual.  
**Precondiciones:**

1. Un pedido ha sido marcado con estado "Fabricado" en el sistema.

2. El pedido ha sido aprobado por control de calidad.

3. Las cantidades fabricadas han sido validadas y registradas.

4. El servicio de inventario está operativo.

**Flujo Principal:**

1. El sistema detecta el cambio de estado a "Fabricado" con aprobación de calidad en un pedido.

2. El sistema verifica que el pedido no haya sido procesado previamente para actualización de inventario.

3. El sistema recupera todas las combinaciones de productos del pedido:

   * Referencia del producto

   * Talla específica

   * Color específico

   * Cantidad aprobada por calidad

   * Número de pedido asociado

4. Para cada combinación en el pedido, el sistema ejecuta el proceso de actualización:

   * Consulta si la combinación referencia-talla-color existe en el inventario actual

   * **Si existe:** Incrementa la cantidad disponible sumando la cantidad fabricada

   * **Si no existe:** Crea un nuevo registro de inventario con estado "Disponible"

5. El sistema registra automáticamente cada movimiento con:

   * Fecha y hora del ingreso

   * Número de pedido origen

   * Origen "Producción Interna"

   * Cantidad ingresada

   * Usuario sistema como responsable

6. El sistema valida la integridad de la transacción:

   * Verifica que la suma de cantidades ingresadas coincida con el total del pedido

   * Confirma que no haya duplicidad en el procesamiento

   * Valida que los registros se hayan creado/actualizado correctamente

7. El sistema marca el pedido como "Procesado en Inventario" para evitar duplicación.

8. El sistema genera evento de auditoría con todos los detalles del proceso.

**Flujos Alternos:**

* **Pedido Ya Procesado:** Si el pedido ya fue procesado en inventario, el sistema detecta la condición y omite el procesamiento, registrando: "Pedido \[ID\] ya fue procesado en inventario en \[fecha anterior\]".

* **Discrepancia en Cantidades:** Si hay diferencia entre cantidades fabricadas y cantidades aprobadas, el sistema utiliza las cantidades aprobadas por calidad y registra advertencia: "Diferencia detectada entre fabricado \[X\] y aprobado \[Y\]. Usando cantidad aprobada."

* **Error en Combinación:** Si alguna combinación referencia-talla-color no existe en catálogo, el sistema suspende el procesamiento para esa combinación, notifica al administrador y continúa con las combinaciones válidas.

* **Fallo en Actualización:** Si ocurre error durante la actualización de base de datos, el sistema realiza rollback de toda la transacción y programa reintento automático en 5 minutos.

**Postcondiciones:**

1. El inventario ha sido actualizado reflejando las nuevas unidades fabricadas.

2. Todas las combinaciones del pedido están disponibles en stock.

3. El pedido ha sido marcado como procesado en inventario.

4. Se ha generado registro de auditoría completo del proceso automático.

5. Los reportes de inventario reflejan los nuevos niveles de stock.

6. El sistema está listo para procesar el siguiente pedido fabricado.

**CU017: Registro de Ventas Directas**

**Actor(es):** Administrador  
**Descripción:** Permite registrar ventas directas de calzado descontando automáticamente las unidades del inventario, con validaciones de stock en tiempo real y registro inmutable de transacciones.  
**Precondiciones:**

1. El administrador ha iniciado sesión con permisos de ventas.

2. Existe stock disponible de los productos a vender.

3. El módulo de ventas está operativo.

**Flujo Principal:**

1. El administrador accede a "Ventas" \> "Registro de Venta Directa".

2. El sistema presenta formulario de venta con campos organizados:

   * **Información de la Venta:** Fecha, hora, tipo de venta (dropdown)

   * **Destino:** Cliente eventual, punto de venta, destino específico

   * **Motivo de venta:** Venta normal, muestra, donación, otros

3. **Agregar Productos a la Venta:**

   * Administrador hace clic en "Agregar Producto"

   * Sistema muestra búsqueda de productos con autocompletado

   * Al seleccionar producto, muestra selectores de talla y color filtrados

   * Administrador ingresa cantidad a vender

   * Sistema valida stock disponible en tiempo real

   * Producto se agrega a la lista de venta temporal

4. **Validación de Stock:**

   * Por cada producto agregado, sistema verifica cantidad disponible

   * Muestra indicadores visuales: "Stock suficiente", "Stock bajo", "Stock insuficiente"

   * Calcula total de unidades en la venta

5. **Confirmación de Venta:**

   * Administrador revisa resumen completo de la venta

   * Hace clic en "Procesar Venta"

   * Sistema ejecuta validaciones finales:

     * Stock suficiente para todos los productos

     * Todos los campos obligatorios completos

     * Combinaciones referencia-talla-color válidas

6. **Procesamiento de la Venta:**

   * Sistema descuenta automáticamente cada producto del inventario

   * Genera número único de transacción de venta

   * Crea registro inmutable de la venta

   * Actualiza contadores de ventas por producto

7. **Confirmación al Usuario:**

   * Sistema muestra "Venta registrada exitosamente. Transacción: \[número\]"

   * Ofrece opciones: "Imprimir comprobante", "Nueva venta", "Volver al menú"

**Flujos Alternos:**

* **Stock Insuficiente:** Si no hay stock suficiente para algún producto, el sistema bloquea el procesamiento y muestra: "Stock insuficiente para \[Producto\]. Disponible: \[X\] unidades. Solicitado: \[Y\] unidades. Ajuste la cantidad o elimine el producto."

* **Producto No Encontrado:** Si el producto no existe en catálogo, muestra: "Producto no encontrado en catálogo. Verifique la referencia o agregue el producto al catálogo primero."

* **Validación de Datos Fallida:** Si hay campos obligatorios vacíos o con formato incorrecto, muestra mensajes específicos por campo: "El campo \[campo\] es obligatorio" o "Formato inválido en \[campo\]".

* **Error en Descuento de Inventario:** Si falla el descuento de inventario, el sistema revierte toda la transacción y muestra: "Error al actualizar inventario. La venta no fue procesada. Intente nuevamente."

**Postcondiciones:**

1. Las unidades vendidas han sido descontadas del inventario.

2. Se ha creado un registro inmutable de la venta con todos los detalles.

3. El número de transacción único ha sido generado y asignado.

4. Los contadores de ventas por producto han sido actualizados.

5. El registro de auditoría incluye: usuario, timestamp, productos vendidos, cantidades, destino.

6. El stock disponible refleja la reducción por la venta procesada.

**CU018: Registro de Pérdidas por Producto Defectuoso**

**Actor(es):** Administrador, Control de Calidad  
**Descripción:** Permite registrar pérdidas de calzado identificado como defectuoso, moviendo unidades desde el inventario principal al stock defectuoso con trazabilidad completa.  
**Precondiciones:**

1. El usuario ha iniciado sesión con permisos de control de calidad o administrador.

2. Los productos a registrar existen en el inventario principal.

3. Existen códigos de defecto predefinidos en el sistema.

**Flujo Principal:**

1. El usuario accede a "Calidad" \> "Registro de Pérdidas".

2. El sistema presenta formulario especializado con secciones:

   * **Producto Defectuoso:** Referencia, talla, color (con validación de existencia)

   * **Información de la Pérdida:** Cantidad, fecha de detección, lote afectado

   * **Clasificación del Defecto:** Código de defecto (dropdown categorizado), gravedad (Crítico, Mayor, Menor)

   * **Evidencia y Análisis:** Observaciones detalladas, fotos adjuntas, causa raíz identificada

3. **Validación de Existencia:**

   * Usuario ingresa referencia y sistema autocompleta tallas y colores disponibles

   * Sistema valida que la combinación exista en inventario principal

   * Verifica que la cantidad no exceda el stock disponible

4. **Procesamiento de la Pérdida:**

   * Usuario completa todos los campos obligatorios

   * Hace clic en "Registrar Pérdida"

   * Sistema ejecuta validaciones:

     * Combinación existe en inventario

     * Cantidad ≤ stock disponible

     * Código de defecto válido

     * Observaciones con mínimo detalle requerido

5. **Actualización de Inventarios:**

   * Sistema descuenta cantidad del inventario principal

   * Transfiere unidades al inventario de "Stock Defectuoso"

   * Registra motivo específico del descarte

   * Actualiza métricas de calidad por producto y por defecto

6. **Registro de Operarios:**

   * Si un operario registra la pérdida, el sistema la marca como "Pendiente de Aprobación"

   * Las unidades permanecen en inventario principal hasta aprobación

   * Notifica al supervisor de calidad para revisión

**Flujos Alternos:**

* **Cantidad Excede Stock:** Si la cantidad ingresada excede el stock disponible, muestra: "Cantidad excede stock disponible. Máximo que puede registrar: \[X\] unidades. Stock actual: \[Y\] unidades."

* **Combinación No Existente:** Si la combinación referencia-talla-color no existe, muestra: "Esta combinación no existe en inventario. Verifique la referencia, talla y color."

* **Datos Incompletos:** Si faltan campos obligatorios, muestra: "Complete todos los campos obligatorios. Faltan: \[lista de campos faltantes\]."

* **Aprobación Requerida:** Para registros de operarios, muestra: "Su registro ha sido enviado para aprobación. Estado: Pendiente de revisión por supervisor."

**Postcondiciones:**

1. Las unidades defectuosas han sido movidas del inventario principal al stock defectuoso.

2. El registro de pérdida incluye clasificación completa del defecto.

3. Las métricas de calidad han sido actualizadas.

4. El historial de defectos por producto y por código se ha enriquecido.

5. Si aplica, la pérdida queda en estado pendiente de aprobación.

6. El registro de auditoría captura toda la información del proceso.

**CU019: Proceso de Restauración de Calzado Defectuoso**

**Actor(es):** Administrador, Jefe de Calidad  
**Descripción:** Gestiona el proceso completo de restauración de calzado defectuoso, desde la selección de unidades recuperables hasta la reincorporación al inventario disponible tras reparación exitosa.  
**Precondiciones:**

1. Existen productos en el inventario de defectuosos.

2. El usuario tiene permisos de jefe de calidad o administrador.

3. Los tipos de defecto y intervenciones están predefinidos.

**Flujo Principal:**

1. El usuario accede a "Calidad" \> "Restauración de Productos".

2. El sistema muestra lista de productos en inventario defectuoso con filtros por:

   * Tipo de defecto

   * Gravedad

   * Fecha de ingreso a defectuosos

   * Potencial de restauración

3. **Selección para Restauración:**

   * Usuario selecciona productos del historial de pérdidas

   * Sistema valida que las unidades estén disponibles para restauración

   * Usuario especifica para cada producto:

     * Referencia, talla, color

     * Cantidad a restaurar (no puede exceder cantidad defectuosa)

     * Tipo de defecto original

     * Intervención requerida (dropdown con opciones predefinidas)

     * Tiempo estimado de reparación

     * Costo estimado de materiales

4. **Inicio del Proceso:**

   * Usuario hace clic en "Iniciar Restauración"

   * Sistema cambia estado de las unidades a "En Restauración"

   * Las unidades quedan bloqueadas en inventario especial

   * Se genera orden de trabajo para el equipo de restauración

5. **Seguimiento del Proceso:**

   * Durante la restauración, se registran avances

   * Se capturan costos reales de materiales utilizados

   * Se documentan observaciones del proceso

   * Se adjuntan fotos del antes y después

6. **Autorización Final:**

   * Solo el jefe de calidad puede autorizar el estado final

   * Opciones: "Restaurado" o "Pérdida Definitiva"

   * Si se aprueba como "Restaurado":

     * Unidades se reincorporan automáticamente al inventario disponible

     * Se actualiza costo unitario considerando costo de reparación

     * Se genera registro de producto restaurado

   * Si se rechaza como "Pérdida Definitiva":

     * Unidades permanecen en inventario defectuoso

     * Se registra como pérdida definitiva

**Flujos Alternos:**

* **Cantidad Excedida:** Si la cantidad a restaurar excede la disponible en defectuosos, muestra: "Cantidad excede unidades disponibles en defectuosos. Máximo: \[X\] unidades."

* **Restauración No Viable:** Si el jefe de calidad determina que la restauración no es viable, puede cancelar el proceso y mostrar: "Proceso de restauración cancelado. Producto declarado como pérdida definitiva por \[motivo\]."

* **Cambio en Estado de Defectuosos:** Si las unidades seleccionadas ya no están disponibles (ej: fueron descartadas), muestra: "Las unidades seleccionadas ya no están disponibles para restauración. Estado actual: \[nuevo estado\]."

**Postcondiciones:**

1. Las unidades restauradas han sido reincorporadas al inventario disponible.

2. Los costos de reparación han sido registrados y actualizados en el costo del producto.

3. El historial de restauración documenta todo el proceso.

4. Las métricas de efectividad de restauración han sido actualizadas.

5. El inventario defectuoso refleja la reducción por unidades restauradas.

6. El registro de auditoría captura todas las decisiones y autorizaciones.

**CU020: Creación y Planificación de Tareas**

**Actor(es):** Administrador  
**Descripción:** Permite crear tareas operativas detalladas asignándolas a empleados específicos, con tiempos estándar predefinidos y vinculación a órdenes de producción, organizando el trabajo interno con trazabilidad completa.  
**Precondiciones:**

1. El usuario ha iniciado sesión con permisos de planificación.

2. Existen empleados activos en el sistema con roles definidos.

3. Existen órdenes de producción creadas en el sistema.

**Flujo Principal:**

1. El usuario accede a "Producción" \> "Gestión de Tareas" \> "Crear Nueva Tarea".

2. El sistema presenta formulario de creación de tarea con secciones:

   * **Información Básica:** Título (texto obligatorio), descripción detallada (área de texto)

   * **Clasificación:** Tipo de tarea (dropdown: Corte, Ensamblaje, Acabado, Control Calidad, Empaque)

   * **Prioridad y Programación:** Prioridad (Alta, Media, Baja), fecha límite (selector de fecha/hora)

   * **Vinculaciones:** Orden de producción asociada (dropdown con órdenes activas)

   * **Asignación:** Empleado responsable (dropdown con empleados activos filtrados por rol)

3. **Configuración de Tiempos:**

   * El sistema asigna automáticamente tiempo estándar basado en:

     * Tipo de tarea seleccionado

     * Modelo de calzado de la orden de producción vinculada

     * Complejidad histórica del proceso

   * Muestra tiempo estimado: "Tiempo estándar: 4.5 horas"

   * Permite ajuste manual si es necesario con justificación

4. **Validación de Datos:**

   * Usuario completa todos los campos obligatorios

   * Sistema valida que no existan tareas duplicadas para misma orden y proceso

   * Verifica que el empleado asignado esté activo y tenga rol compatible

5. **Creación de la Tarea:**

   * Usuario hace clic en "Crear Tarea"

   * Sistema genera la tarea con estado "Pendiente de Inicio"

   * Asigna número único de identificación

   * La tarea aparece inmediatamente en el panel del empleado asignado

6. **Notificación Automática:**

   * Sistema envía notificación in-app al empleado asignado

   * Si la prioridad es Alta, envía notificación push inmediata

   * Registra la creación en el historial de la orden de producción

**Flujos Alternos:**

* **Tarea Duplicada:** Si se intenta crear tarea duplicada para misma orden y proceso, muestra: "Ya existe una tarea activa para este proceso en la orden \[número\]. ¿Desea editar la tarea existente?"

* **Empleado Inactivo:** Si se selecciona empleado inactivo, muestra: "El empleado seleccionado no está activo en el sistema. Seleccione otro empleado o active el empleado primero."

* **Fecha Límite Inválida:** Si la fecha límite es anterior a la fecha actual, muestra: "La fecha límite no puede ser anterior a la fecha actual. Ajuste la fecha."

* **Sin Órdenes Disponibles:** Si no hay órdenes de producción activas, muestra: "No hay órdenes de producción disponibles para vincular. Debe crear una orden de producción primero."

**Postcondiciones:**

1. La nueva tarea ha sido creada con estado "Pendiente de Inicio".

2. El empleado asignado ha recibido notificación de la nueva tarea.

3. La tarea aparece en los paneles de seguimiento del planificador y del empleado.

4. El tiempo estándar ha sido registrado para métricas de desempeño.

5. El registro de auditoría incluye: usuario creador, timestamp, empleado asignado, orden vinculada.

6. Los contadores de tareas pendientes se han actualizado.

**CU021: Asignación de Tareas a Empleados**

**Actor(es):** Administrador   
**Descripción:** Permite asignar tareas pendientes a empleados activos, estableciendo fechas límite obligatorias y gestionando reasignaciones con validaciones de estado y disponibilidad.  
**Precondiciones:**

1. El usuario ha iniciado sesión con permisos de asignación.

2. Existen tareas en estado "Pendiente" sin asignar.

3. Existen empleados activos con roles autorizados para el tipo de tarea.

**Flujo Principal:**

1. El usuario accede a "Producción" \> "Tareas Pendientes de Asignación".

2. El sistema muestra lista de tareas no asignadas con información:

   * ID tarea, título, tipo, prioridad, fecha creación

   * Orden de producción vinculada

   * Tiempo estándar estimado

3. **Proceso de Asignación:**

   * Usuario selecciona una tarea en estado "Pendiente"

   * Hace clic en "Asignar a Empleado"

   * Sistema muestra lista de empleados disponibles filtrados por:

     * Rol compatible con el tipo de tarea

     * Estado activo

     * Carga de trabajo actual

   * Usuario selecciona empleado y establece fecha límite obligatoria

4. **Validación de Asignación:**

   * Sistema verifica que el empleado tenga capacidad para la tarea

   * Valida que la fecha límite sea realista considerando:

     * Tiempo estándar de la tarea

     * Otras tareas asignadas al empleado

     * Días hábiles disponibles

   * Confirma que la tarea siga en estado asignable

5. **Confirmación de Asignación:**

   * Usuario hace clic en "Confirmar Asignación"

   * Sistema cambia estado de la tarea a "Asignada"

   * Bloquea la tarea para edición por otros usuarios

   * Registra la asignación en el historial de la tarea

6. **Notificación al Empleado:**

   * Sistema envía notificación in-app al empleado asignado

   * La tarea aparece en el panel "Mis Tareas Asignadas" del empleado

   * Si la prioridad es Alta, envía recordatorio adicional al supervisor

**Flujos Alternos:**

* **Tarea Ya Asignada:** Si la tarea ya fue asignada a otro empleado, muestra: "Esta tarea ya está asignada a \[nombre empleado\]. Solo puede reasignar si la tarea está en estado Asignada o En Progreso."

* **Empleado No Disponible:** Si el empleado seleccionado tiene carga excesiva, muestra: "El empleado seleccionado tiene \[X\] tareas pendientes. ¿Está seguro de asignar esta tarea adicional?"

* **Fecha Límite No Realista:** Si la fecha límite no permite completar la tarea a tiempo, muestra: "La fecha límite seleccionada no permite el tiempo estándar de \[X\] horas. Fecha recomendada: \[fecha sugerida\]."

* **Reasignación de Tarea:**

  * Usuario selecciona tarea en estado "Asignada" o "En Progreso"

  * Sistema solicita motivo obligatorio para la reasignación

  * Notifica al empleado anterior sobre el cambio

  * Asigna al nuevo empleado y actualiza fechas si es necesario

**Postcondiciones:**

1. La tarea ha sido asignada al empleado seleccionado.

2. El estado de la tarea ha cambiado a "Asignada".

3. El empleado ha recibido notificación de la nueva asignación.

4. La tarea está bloqueada para edición por otros usuarios.

5. El registro de asignación incluye: asignador, empleado, fecha límite, timestamp.

6. Los paneles de seguimiento reflejan el nuevo estado de la tarea.

**CU022: Consulta de Tareas Asignadas**

**Actor(es):** Empleado  
**Descripción:** Proporciona a los empleados una vista completa de todas las tareas que les han sido asignadas, con herramientas de organización y seguimiento para gestionar su trabajo diario eficientemente.  
**Precondiciones:**

1. El empleado ha iniciado sesión con credenciales válidas.

2. El empleado tiene al menos una tarea asignada en el sistema.

**Flujo Principal:**

1. El empleado inicia sesión y es redirigido a su dashboard personal.

2. El sistema carga la sección "Mis Tareas Asignadas" con:

   * **Resumen visual:** Tarjetas con contadores por estado (Asignadas, En Progreso, Completadas)

   * **Lista principal:** Tareas organizadas cronológicamente por fecha de vencimiento

   * **Filtros rápidos:** Por prioridad, tipo de tarea, estado, fecha límite

3. **Visualización de Tareas:**

   * Cada tarea muestra información esencial:

     * Título y descripción completa

     * Tipo de tarea e icono representativo

     * Prioridad con codificación de colores

     * Fechas: creación, límite, última actualización

     * Estado actual y porcentaje de avance

     * Orden de producción vinculada

     * Observaciones del planificador

4. **Organización Personal:**

   * Empleado puede ordenar tareas por:

     * Prioridad (Alta a Baja)

     * Fecha límite (próximas a vencer primero)

     * Tipo de tarea (agrupadas por proceso)

     * Tiempo estimado (corta a larga duración)

5. **Indicadores de Tiempo:**

   * Sistema muestra indicador visual de tiempo restante:

     * "Vence en 2 días" (verde para \>3 días)

     * "Vence mañana" (amarillo para 1-3 días)

     * "Vence hoy" (rojo para vencimiento inminente)

     * "Vencida" (rojo intenso para tareas atrasadas)

6. **Tareas Completadas:**

   * Las tareas completadas permanecen visibles pero en sección separada

   * No son editables pero permiten consulta de historial

   * Incluyen fecha y hora de finalización confirmada

**Flujos Alternos:**

* **Sin Tareas Asignadas:** Si el empleado no tiene tareas asignadas, muestra estado vacío con: "No tiene tareas asignadas actualmente. Cuando le asignen nuevas tareas, aparecerán aquí."

* **Filtro Sin Resultados:** Si los filtros aplicados no retornan tareas, muestra: "No hay tareas que coincidan con los filtros seleccionados. \[Limpiar filtros\] para ver todas sus tareas."

* **Tarea con Información Incompleta:** Si alguna tarea tiene datos faltantes, muestra indicador: "Información incompleta \- Contacte a su supervisor"

* **Acceso a Tareas de Otros Empleados:** El sistema valida rigurosamente que cada empleado solo vea sus propias tareas. Si detecta intento de acceso a tarea ajena, registra incidente de seguridad.

**Postcondiciones:**

1. El empleado tiene visibilidad completa de su carga de trabajo asignada.

2. Las tareas están organizadas según sus preferencias de visualización.

3. Los indicadores de tiempo ayudan en la priorización del trabajo.

4. El sistema ha mantenido la segregación de datos entre empleados.

5. La consulta ha sido rápida y responsive incluso con muchas tareas asignadas.

6. El empleado puede comenzar a trabajar en cualquier tarea directamente desde esta vista.

**CU023: Reporte de Avances e Incidencias**

**Actor(es):** Empleado  
**Descripción:** Permite a los empleados registrar detalladamente sus avances, pausas e incidencias durante la ejecución de tareas, proporcionando transparencia real sobre el progreso al administrador.  
**Precondiciones:**

1. El empleado ha iniciado sesión con credenciales válidas.

2. El empleado tiene al menos una tarea en estado "Asignada" o "En Progreso".

3. La tarea específica está disponible para trabajar.

**Flujo Principal:**

1. El empleado accede a "Mis Tareas Asignadas" y selecciona una tarea para trabajar.

2. **Registro de Inicio (Check-in):**

   * Empleado hace clic en "Iniciar Tarea"

   * Sistema registra marca de tiempo del servidor como inicio

   * Cambia estado de la tarea a "En Progreso"

   * Bloquea la tarea para otros empleados

   * Valida que no tenga otra tarea en progreso simultáneamente

3. **Registro de Avances Durante Ejecución:**

   * Empleado puede registrar avances parciales:

     * Porcentaje de avance (slider o entrada numérica)

     * Descripción del trabajo realizado (área de texto)

     * Tipo de avance: Normal, Con dificultades, Bloqueado

   * Sistema actualiza el progreso en tiempo real

   * Supervisor puede ver avances inmediatamente

4. **Registro de Pausas:**

   * Empleado puede pausar la tarea cuando sea necesario

   * Sistema registra motivo de pausa: Descanso, Espera de material, Problema técnico

   * Si la pausa supera 10% del tiempo estándar, solicita justificación detallada

   * Reactivación requiere nueva marca de tiempo

5. **Reporte de Incidencias:**

   * Empleado puede reportar problemas durante la ejecución:

     * Tipo de incidencia: Falta material, Fallo equipo, Problema calidad, Otro

     * Descripción detallada del problema

     * Severidad: Baja, Media, Alta, Crítica

     * Archivos adjuntos (fotos, documentos)

   * Para incidencias críticas, sistema genera ticket automático en menos de 60 segundos

   * Tarea cambia a "Bloqueada" y notifica inmediatamente al administrador

6. **Finalización del Reporte:**

   * Cuando el avance alcanza 100%, empleado debe confirmar finalización

   * Sistema solicita validación antes de marcar como completada

   * Registra todas las incidencias y avances en el historial de la tarea

**Flujos Alternos:**

* **Dos Tareas Simultáneas:** Si el empleado intenta iniciar una segunda tarea teniendo una en progreso, muestra: "Ya tiene una tarea en progreso (\[nombre tarea\]). Debe finalizar o pausar esa tarea antes de iniciar una nueva."

* **Incidencia Duplicada:** Si se reporta una incidencia idéntica a una reciente, muestra: "Ya existe un reporte similar registrado hace \[X tiempo\]. ¿Está seguro de que es una incidencia diferente?"

* **Pausa Prolongada sin Justificación:** Si una pausa excede el límite sin justificación, el sistema notifica al supervisor: "Tarea \[ID\] en pausa prolongada sin justificación del empleado \[nombre\]."

* **Avance Inconsistente:** Si el empleado reporta avances inconsistentes (ej: retroceso en porcentaje), el sistema solicita explicación: "El avance reportado es menor al anterior. Por favor, explique la razón."

**Postcondiciones:**

1. Los avances de la tarea han sido registrados con timestamps precisos.

2. Las incidencias reportadas han sido notificadas a los responsables correspondientes.

3. El estado de la tarea refleja accurately el progreso real.

4. El historial de la tarea contiene registro completo de todas las interacciones.

5. Los supervisores tienen visibilidad en tiempo real del progreso y problemas.

6. Las métricas de productividad y eficiencia se han actualizado con los datos reportados.

**CU024: Confirmación de Finalización de Tareas**

**Actor(es):** Empleado  
**Descripción:** Permite al empleado confirmar formalmente la finalización de una tarea asignada, registrando la cantidad procesada y adjuntando evidencia para notificar al administrador del cierre del trabajo.  
**Precondiciones:**

1. El empleado ha iniciado sesión con credenciales válidas.

2. El empleado tiene al menos una tarea en estado "Asignada" o "En Progreso".

3. La tarea ha alcanzado el 100% de avance registrado.

4. El empleado ha completado todo el trabajo requerido para la tarea.

**Flujo Principal:**

1. El empleado accede a "Mis Tareas Asignadas" y selecciona una tarea con 100% de avance.

2. El sistema verifica que la tarea esté en estado válido para finalización ("Asignada" o "En Progreso").

3. El empleado hace clic en "Marcar como Finalizada".

4. El sistema presenta pantalla de confirmación con:

   * Resumen completo de la tarea: título, descripción, tipo, fechas

   * Cantidad procesada durante la tarea (campo numérico obligatorio)

   * Lista de verificación de completitud con items específicos por tipo de tarea

5. **Registro de Evidencia:**

   * El empleado puede adjuntar evidencia de la finalización:

     * Fotografías del producto terminado (máximo 5 fotos, formatos JPG/PNG)

     * Informe final de producción (formato PDF o DOC)

     * Documentos de control de calidad completados

   * El sistema valida formatos y tamaños de archivos

   * Muestra preview de las evidencias adjuntadas

6. **Confirmación Final:**

   * El empleado revisa toda la información y hace clic en "Confirmar Finalización"

   * El sistema ejecuta validaciones finales:

     * Cantidad procesada es numérica y positiva

     * Evidencias adjuntadas si son requeridas para el tipo de tarea

     * No hay campos obligatorios vacíos

7. **Procesamiento de la Finalización:**

   * El sistema cambia el estado de la tarea a "Completada"

   * Bloquea la tarea para evitar ediciones futuras

   * Registra la fecha y hora exacta de finalización

   * Calcula el tiempo total real vs tiempo estándar

8. **Notificación Automática:**

   * El sistema notifica inmediatamente al administrador/supervisor

   * Si es la última tarea de una orden de producción, genera alerta a control de calidad

   * Actualiza los contadores de tareas completadas

**Flujos Alternos:**

* **Avance Insuficiente:** Si el empleado intenta finalizar una tarea con menos del 100% de avance, el sistema muestra: "No puede finalizar la tarea. Avance actual: \[X\]%. Debe completar el 100% del avance antes de finalizar."

* **Evidencia Obligatoria No Adjuntada:** Si el tipo de tarea requiere evidencia y no se adjuntó, muestra: "Esta tarea requiere evidencia de finalización. Adjunte al menos \[tipo de evidencia\] antes de confirmar."

* **Cantidad Procesada Inválida:** Si la cantidad procesada es cero o negativa, muestra: "La cantidad procesada debe ser mayor a cero. Ingrese la cantidad real de unidades procesadas."

* **Tarea Ya Finalizada:** Si la tarea ya estaba en estado "Completada", muestra: "Esta tarea ya fue finalizada el \[fecha\] por \[usuario\]. No puede modificarse."

**Postcondiciones:**

1. La tarea ha sido marcada como "Completada" y bloqueada para ediciones.

2. La cantidad procesada ha sido registrada para contabilidad de producción.

3. Las evidencias adjuntadas están disponibles para revisión del supervisor.

4. El administrador ha recibido notificación de la finalización.

5. El historial de la tarea incluye timestamp de finalización y empleado que la completó.

6. Las métricas de eficiencia se han actualizado con el tiempo real empleado.

**CU025: Notificación de Tareas Finalizadas**

**Actor(es):** Sistema  
**Descripción:** Genera y distribuye notificaciones automáticas cuando un empleado finaliza una tarea, proporcionando a administradores y supervisores información completa para validar el cumplimiento y tomar decisiones de aprobación.  
**Precondiciones:**

1. Un empleado ha marcado una tarea como "Completada" en el sistema.

2. Existen administradores o supervisores activos con notificaciones habilitadas.

3. Los servicios de notificación están operativos.

**Flujo Principal:**

1. El sistema detecta que una tarea cambia a estado "Completada".

2. El sistema recopila toda la información relevante de la tarea finalizada:

   * Número y título de la tarea

   * Tipo de tarea y prioridad original

   * Fechas: asignación, límite, finalización real

   * Empleado que completó la tarea

   * Cantidad procesada registrada

   * Tiempo estándar vs tiempo real empleado

   * Porcentaje de eficiencia calculado automáticamente

   * Observaciones y evidencias adjuntadas

   * Orden de producción vinculada

3. El sistema identifica a los destinatarios de la notificación:

   * Administrador del sistema (siempre)

   * Supervisor directo del empleado

   * Planificador de producción (si la tarea está vinculada a una orden)

   * Jefe de calidad (si la tarea involucra procesos de calidad)

4. El sistema genera notificaciones en múltiples canales:

**Notificación In-App (Tiempo Real):**

* Crea alerta en el panel de notificaciones de cada destinatario

  * Muestra resumen conciso de la tarea completada

  * Incluye botón "Revisar Tarea" que redirige al detalle completo

  * Proporciona acceso directo a las evidencias adjuntadas

**Correo Electrónico (Si está habilitado):**

* Envía email con asunto: "TAREA COMPLETADA \- \[ID Tarea\] \- \[Empleado\] \- \[Eficiencia\]"

  * Cuerpo del email con tabla resumen de la tarea

  * Incluye métricas clave de desempeño

  * Enlaces directos para aprobar o rechazar la tarea

5. **Acciones Inmediatas desde la Notificación:**

   * Los destinatarios pueden tomar acción directamente desde la notificación:

     * "Aprobar Tarea" \- marca como aprobada y cierra el proceso

     * "Rechazar Tarea" \- solicita motivo obligatorio y reabre la tarea

     * "Ver Evidencias" \- accede a fotos y documentos adjuntos

     * "Consultar Detalles" \- navega a la página completa de la tarea

6. El sistema actualiza los dashboards de supervisión en tiempo real.

**Flujos Alternos:**

* **Notificación Duplicada:** El sistema verifica que no se envíen notificaciones duplicadas para la misma tarea, registrando: "Notificación para tarea \[ID\] ya fue enviada en \[timestamp\]".

* **Destinatario No Disponible:** Si algún destinatario está ausente, el sistema escala la notificación a su reemplazo designado o al siguiente nivel jerárquico.

* **Tarea de Baja Prioridad:** Para tareas de prioridad baja, el sistema puede agrupar notificaciones y enviarlas en lote cada hora para reducir interrupciones.

* **Error en Envío de Email:** Si falla el envío por correo, el sistema mantiene la notificación in-app y reintenta el email cada 10 minutos hasta por 1 hora.

**Postcondiciones:**

1. Las notificaciones han sido entregadas exitosamente a todos los destinatarios designados.

2. Los supervisores tienen visibilidad inmediata del trabajo completado.

3. Las métricas de eficiencia han sido calculadas y están disponibles para análisis.

4. El sistema está listo para procesar las decisiones de aprobación o rechazo.

5. El registro de auditoría incluye el envío de cada notificación con timestamp y destinatarios.

6. No se han generado notificaciones duplicadas para el mismo evento.

**CU026: Modificación y Eliminación de Tareas**

**Actor(es):** Administrador

**Descripción:** Permite editar o eliminar tareas que no han sido completadas, facilitando la corrección de errores de planificación o la eliminación de tareas innecesarias con controles de integridad.  
**Precondiciones:**

1. El usuario ha iniciado sesión con permisos de administrador o planificador.

2. Existen tareas en estados editables ("Pendiente" o "Asignada").

3. El usuario tiene permisos sobre el módulo de tareas específico.

**Flujo Principal:**

1. El usuario accede a "Producción" \> "Gestión de Tareas".

2. El sistema muestra lista de tareas con filtros por estado, tipo, prioridad y fecha.

3. **Edición de Tareas:**

   * Usuario selecciona una tarea en estado "Pendiente" o "Asignada"

   * Hace clic en "Editar Tarea"

   * Sistema presenta formulario pre-llenado con todos los datos actuales

   * Usuario puede modificar campos editables:

     * Título y descripción

     * Tipo de tarea y prioridad

     * Fecha límite

     * Empleado asignado (solo si está en estado "Asignada")

     * Observaciones y comentarios

   * Sistema valida los cambios y muestra vista previa de modificaciones

   * Usuario confirma los cambios

4. **Eliminación de Tareas:**

   * Para tareas sin actividad registrada (tiempo cero minutos):

     * Usuario selecciona tarea y hace clic en "Eliminar"

     * Sistema solicita confirmación explícita

     * Tras confirmar, elimina permanentemente la tarea

     * La tarea desaparece del panel del empleado asignado

   * Para tareas con actividad registrada (tiempo mayor a cero):

     * Sistema no permite eliminación directa

     * Ofrece opción "Cancelar Tarea" con motivo obligatorio

5. **Cancelación de Tareas con Actividad:**

   * Usuario selecciona "Cancelar Tarea" para tareas con tiempo registrado

   * Sistema solicita motivo detallado de la cancelación

   * Cambia estado de la tarea a "Cancelada"

   * Preserva el historial de tiempo y actividad registrada

   * Notifica al empleado asignado sobre la cancelación

6. **Registro de Cambios:**

   * Todas las modificaciones quedan registradas en el historial

   * Incluye: valor anterior, nuevo valor, usuario modificador, timestamp

   * Los cambios son visibles para auditores y supervisores

**Flujos Alternos:**

* **Intento de Edición de Tarea Completada:** Si el usuario intenta editar una tarea en estado "Completada", muestra: "No puede editar tareas completadas. Esta tarea fue finalizada el \[fecha\]. Solo puede consultar el historial."

* **Eliminación de Tarea con Actividad:** Si intenta eliminar tarea con tiempo registrado, muestra: "No puede eliminar tareas con actividad registrada. Esta tarea tiene \[X\] minutos de trabajo. Use la opción 'Cancelar Tarea' en su lugar."

* **Reasignación a Empleado No Disponible:** Si intenta reasignar a empleado no disponible, muestra: "El empleado seleccionado no está disponible para esta tarea. Razón: \[carga excesiva, vacaciones, incompatible\]."

* **Cambios Masivos:** El sistema permite modificar múltiples tareas simultáneamente si comparten características editables comunes.

**Postcondiciones:**

1. Las tareas han sido modificadas o eliminadas según la acción realizada.

2. Los empleados afectados han sido notificados de los cambios relevantes.

3. El historial de modificaciones contiene registro completo de todos los cambios.

4. Los paneles de seguimiento reflejan los nuevos estados inmediatamente.

5. La integridad de los datos se ha mantenido (no se pierde información histórica).

6. Los contadores de tareas se han actualizado correctamente.

**CU027: Registro de Incidencias de Maquinaria e Insumos**

**Actor(es):** Empleado de Planta  
**Descripción:** Permite a los empleados reportar rápidamente fallas en maquinaria o falta de insumos críticos desde una tarea activa, generando tickets automáticos para acciones correctivas oportunas.  
**Precondiciones:**

1. El empleado ha iniciado sesión con credenciales válidas.

2. El empleado tiene una tarea activa en estado "En Progreso".

3. Se ha detectado una falla operativa o falta de insumo que afecta el trabajo.

**Flujo Principal:**

1. Desde la tarea activa en progreso, el empleado hace clic en "Reportar Incidencia".

2. El sistema presenta formulario de reporte con secciones:

   * **Tipo de Incidencia:** Radio buttons: "Falla de Maquinaria", "Falta de Insumo Crítico", "Problema de Calidad", "Otro"

   * **Descripción Detallada:** Área de texto para descripción completa del problema

   * **Equipo/Afectado:** Selector del equipo o máquina específica (dropdown con equipos del área)

   * **Insumo Faltante:** Selector de insumo específico (dropdown con insumos críticos)

   * **Área y Ubicación:** Selector del área de producción y ubicación específica

   * **Fecha y Hora de Ocurrencia:** Pre-llenado con fecha/hora actual, editable si es diferente

3. **Evidencia Fotográfica Obligatoria:**

   * Sistema requiere adjuntar al menos una foto del problema

   * Permite hasta 3 fotos desde cámara o galería

   * Valida que las fotos sean claras y muestren el problema

   * Muestra preview de las fotos adjuntadas

4. **Clasificación de Urgencia:**

   * Empleado selecciona nivel de impacto:

     * "Impacto Total" \- detiene completamente la producción

     * "Impacto Parcial" \- reduce capacidad de producción

     * "Impacto Mínimo" \- no afecta producción actual

   * Según el impacto, el sistema asigna prioridad automáticamente

5. **Envío del Reporte:**

   * Empleado revisa y hace clic en "Enviar Reporte"

   * Sistema valida que no exista reporte duplicado en los últimos 30 minutos

   * Registra el reporte con timestamp exacto

6. **Procesamiento Automático:**

   * **Para "Falla de Maquinaria":**

     * Notifica inmediatamente al departamento de mantenimiento

     * Asigna prioridad Alta automáticamente

     * Genera ticket de mantenimiento urgente

   * **Para "Falta de Insumo Crítico":**

     * Notifica inmediatamente al jefe de compras y almacén

     * Genera alerta de reposición urgente

     * Calcula impacto en producción programada

   * **Para cualquier incidencia con "Impacto Total":**

     * Cambia estado de la tarea a "Bloqueada"

     * Notifica al administrador y supervisor inmediatamente

**Flujos Alternos:**

* **Incidencia Duplicada:** Si se intenta reportar una incidencia idéntica a una reciente, muestra: "Ya existe un reporte similar para este equipo/insumo registrado hace \[X\] minutos. ¿Está seguro de que es una incidencia diferente?"

* **Foto No Adjuntada:** Si no se adjunta foto obligatoria, muestra: "Debe adjuntar al menos una foto que muestre el problema. La evidencia fotográfica es obligatoria para todos los reportes."

* **Equipo No Identificado:** Si el equipo afectado no está en el listado, muestra: "El equipo no está en la lista. \[Reportar equipo nuevo\] o seleccione 'Otro' y describa en detalle."

* **Insumo No Crítico:** Si reporta falta de insumo no crítico, el sistema lo registra pero no genera alerta urgente, mostrando: "Reporte registrado para insumo no crítico. Será procesado en el próximo ciclo de reposición."

**Postcondiciones:**

1. El reporte de incidencia ha sido registrado con toda la información requerida.

2. Los departamentos responsables han recibido notificación inmediata según el tipo de incidencia.

3. Se ha generado ticket de seguimiento para la incidencia reportada.

4. Si aplica, la tarea ha cambiado a estado "Bloqueada" hasta resolver la incidencia.

5. Las evidencias fotográficas están disponibles para el equipo de soporte.

6. El registro de auditoría incluye todos los detalles del reporte y acciones automáticas generadas.

**CU028: Centro de Notificaciones Centralizado**

**Actor(es):** Todos los usuarios registrados  
**Descripción:** Proporciona un centro unificado donde los usuarios reciben, gestionan y organizan todas las notificaciones relevantes a su rol, manteniéndolos informados sobre eventos importantes sin pérdida de información.  
**Precondiciones:**

1. El usuario ha iniciado sesión en el sistema con credenciales válidas.

2. El servicio de notificaciones está operativo y activo.

3. Existen notificaciones pendientes o históricas para el usuario.

**Flujo Principal:**

1. El usuario accede al sistema y observa el icono de notificaciones en la barra superior.

2. El icono muestra un contador badge con el número de notificaciones no leídas.

3. El usuario hace clic en el icono de notificaciones.

4. El sistema despliega el panel del centro de notificaciones con:

   * **Pestañas organizadas:** "No Leídas", "Todas", "Archivadas"

   * **Filtros rápidos:** Por tipo (Tareas, Pedidos, Alertas, Sistema), por prioridad (Alta, Media, Baja)

   * **Búsqueda:** Campo de texto para buscar dentro de las notificaciones

5. **Visualización de Notificaciones:**

   * Cada notificación muestra:

     * Icono representativo del tipo de notificación

     * Título en negrita

     * Descripción breve del contenido

     * Tipo y prioridad con codificación visual

     * Fecha y hora exacta de generación

     * Estado (No leída, Leída, Archivada)

     * Enlace directo a la acción o pantalla relacionada

   * Las notificaciones se ordenan cronológicamente (más recientes primero)

6. **Gestión de Notificaciones:**

   * El usuario puede marcar notificaciones individuales como leídas

   * Puede archivar notificaciones para ocultarlas del panel principal

   * Puede realizar acciones masivas: "Marcar todas como leídas", "Archivar todas leídas"

7. **Navegación desde Notificaciones:**

   * El usuario hace clic en cualquier notificación

   * El sistema redirige inmediatamente a la pantalla relacionada

   * La notificación se marca automáticamente como leída

   * El contador de notificaciones pendientes se actualiza

8. **Preferencias Personalizables:**

   * El usuario puede acceder a "Configurar Notificaciones"

   * El sistema muestra opciones para personalizar:

     * Tipos de notificaciones que desea recibir

     * Canales preferidos (solo in-app, in-app \+ email)

     * Horarios silenciosos para notificaciones no críticas

**Flujos Alternos:**

* **Sin Notificaciones:** Si no hay notificaciones para el usuario, el panel muestra estado vacío: "No tiene notificaciones pendientes. Las notificaciones importantes aparecerán aquí cuando estén disponibles."

* **Notificación Caducada:** Si el usuario intenta acceder a una notificación cuya acción ya no está disponible, muestra: "Esta notificación ya no está disponible. La acción relacionada ha expirado o fue procesada."

* **Error en Carga de Notificaciones:** Si hay problemas técnicos al cargar las notificaciones, muestra: "No pudimos cargar sus notificaciones en este momento. \[Reintentar\]"

* **Notificación Duplicada:** El sistema detecta y elimina notificaciones duplicadas automáticamente, mostrando solo una instancia de cada evento.

**Postcondiciones:**

1. El usuario ha revisado y gestionado sus notificaciones pendientes.

2. El contador de notificaciones no leídas refleja accurate el estado actual.

3. Las notificaciones han sido organizadas según las preferencias del usuario.

4. El usuario ha accedido a las funcionalidades relevantes mediante los enlaces directos.

5. Las preferencias de notificación han sido guardadas para futuras comunicaciones.

6. El sistema ha mantenido el registro histórico de todas las notificaciones recibidas.

**CU029: Alertas Críticas para Administrador**

**Actor(es):** Administrador   
**Descripción:** Proporciona un sistema de alertas inmediatas sobre eventos críticos que requieren intervención rápida, con configuración de umbrales y capacidades de respuesta integradas.  
**Precondiciones:**

1. El usuario ha iniciado sesión con permisos de administrador o gerente.

2. Existen eventos críticos o condiciones de alerta activas en el sistema.

3. El módulo de alertas está configurado y operativo.

**Flujo Principal:**

1. El administrador accede al sistema y observa indicadores visuales de alerta:

   * Banner rojo prominente en la parte superior del dashboard

   * Contador de alertas críticas en el menú principal

   * Notificaciones push si está habilitado en dispositivo móvil

2. **Tipos de Alertas Generadas:**

   * **Bloqueos Operativos:** Tareas bloqueadas por más de 2 horas, líneas de producción detenidas

   * **Agotamiento de Stock:** Productos con stock por debajo del umbral mínimo configurado

   * **Incidencias Técnicas Críticas:** Fallas de maquinaria con impacto total en producción

   * **Retrasos en Pedidos:** Pedidos críticos atrasados beyond la fecha prometida

   * **Alertas de Seguridad:** Intentos de acceso no autorizado, múltiples fallos de autenticación

3. **Configuración de Umbrales:**

   * Administrador accede a "Configuración" \> "Umbrales de Alerta"

   * Sistema muestra parámetros configurables:

     * Días permitidos de retraso antes de alerta

     * Porcentaje de inventario mínimo para alertas de stock

     * Tiempo máximo de bloqueo operativo antes de escalar

     * Tipos de eventos que generan alertas críticas

   * Administrador ajusta los valores según necesidades operativas

4. **Recepción y Gestión de Alertas:**

   * Cada alerta muestra información completa:

     * Título descriptivo del evento

     * Tipo de evento y prioridad asignada

     * Fecha y hora exacta de generación

     * Descripción detallada del problema

     * Módulo o área afectada

     * Enlace directo para tomar acción inmediata

   * Administrador puede responder directamente desde la alerta:

     * "Validar" \- reconoce la alerta y asume responsabilidad

     * "Rechazar" \- considera la alerta como falsa positiva con motivo

     * "Reabrir" \- para alertas que requieren seguimiento adicional

     * "Escalar" \- deriva la alerta a otro responsable o nivel superior

5. **Panel de Control de Alertas:**

   * Vista consolidada de todas las alertas activas e históricas

   * Filtros por tipo, prioridad, estado y fecha

   * Métricas de tendencias: alertas por día, tipo más frecuente

   * Reportes de efectividad de respuesta a alertas

**Flujos Alternos:**

* **Alerta por Umbral Configurado:** Cuando un insumo baja del umbral configurado, genera alerta de prioridad media: "Insumo \[nombre\] por debajo del nivel mínimo. Stock actual: \[X\], Mínimo: \[Y\]."

* **Alertas Duplicadas:** El sistema consolida alertas relacionadas para evitar duplicación, mostrando: "Múltiples eventos similares detectados. \[Ver consolidado\]"

* **Respuesta Tardía:** Si una alerta crítica no recibe respuesta en el tiempo esperado, el sistema escala automáticamente al siguiente nivel jerárquico.

* **Configuración de Horarios:** El administrador puede configurar horarios comerciales para ajustar la urgencia de las alertas fuera de horario laboral.

**Postcondiciones:**

1. Las alertas críticas han sido recibidas y gestionadas por el administrador.

2. Los umbrales de alerta han sido configurados según los requerimientos operativos.

3. Las acciones de respuesta han sido registradas para seguimiento y auditoría.

4. Los eventos críticos han sido atendidos oportunamente minimizando impactos operativos.

5. El historial de alertas proporciona datos para análisis de tendencias y mejora continua.

6. La configuración de alertas refleja las condiciones actuales del negocio.

**CU030: Generación de Reportes de Pedidos e Inventario**

**Actor(es):** Administrador   
**Descripción:** Permite generar reportes consolidados en tiempo real de pedidos e inventario, proporcionando análisis detallado del desempeño operativo para la toma de decisiones informadas.  
**Precondiciones:**

1. El usuario ha iniciado sesión con permisos de administrador o gerente.

2. Existen datos históricos de pedidos y movimientos de inventario.

3. El servicio de reportes y base de datos está operativo.

**Flujo Principal:**

1. El usuario accede a "Reportes" \> "Pedidos e Inventario".

2. El sistema presenta interfaz de generación de reportes con:

   * **Selector de Tipo de Reporte:** Radio buttons "Reporte de Pedidos", "Reporte de Inventario", "Reporte Combinado"

   * **Panel de Filtros Avanzados:**

     * Rango de fechas (desde/hasta con selector de calendario)

     * Estado de pedidos (dropdown múltiple)

     * Referencia de producto (con autocompletado)

     * Cliente específico (dropdown con clientes activos)

     * Tipo de movimiento de inventario (entrada, salida, ajuste)

   * **Opciones de Visualización:** Formato de salida (pantalla, PDF, Excel)

3. **Configuración del Reporte:**

   * Usuario selecciona "Reporte de Pedidos" y establece filtros:

     * Rango: Últimos 30 días

     * Estado: Aprobado, En Producción, Completado

     * Cliente: Todos los clientes

   * Usuario hace clic en "Generar Reporte"

4. **Procesamiento del Reporte:**

   * El sistema ejecuta consultas optimizadas sobre la base de datos

   * Procesa y consolida la información en menos de 60 segundos para un año de datos

   * Genera las métricas clave calculadas:

     * Cantidad total de pedidos en el período

     * Tasa de cumplimiento de tiempos de entrega

     * Distribución de pedidos por estado

     * Clientes con mayor volumen de pedidos

5. **Visualización de Resultados:**

   * **Para Reporte de Pedidos:**

     * Tabla con columnas: Número pedido, Cliente, Fecha, Estado, Productos, Cantidades, Ruta de procesamiento

     * Gráficos de tendencia: Pedidos por día, Distribución por estado

     * Métricas resumen: Tiempo promedio de procesamiento, Tasa de entrega a tiempo

   * **Para Reporte de Inventario:**

     * Tabla con columnas: Referencia, Marca, Estilo, Talla, Color, Cantidades, Movimientos recientes

     * Métricas: Valor de stock actual, Tasa de rotación, Productos con menor movimiento

6. **Exportación y Distribución:**

   * Usuario puede exportar a PDF con formato profesional para presentaciones

   * Exportación a Excel para análisis adicional con todos los datos detallados

   * Cada reporte incluye automáticamente: fecha de generación, usuario responsable, parámetros aplicados

   * Opción de programar envío automático periódico del reporte

**Flujos Alternos:**

* **Sin Resultados:** Si no hay datos que coincidan con los filtros aplicados, muestra: "No se encontraron resultados para los criterios seleccionados. Ajuste los filtros e intente nuevamente."

* **Período Muy Amplio:** Si el rango de fechas excede la capacidad de procesamiento rápido, muestra: "El período seleccionado es muy extenso. El reporte puede tardar más de lo normal. ¿Desea continuar o ajustar el rango?"

* **Error en Generación:** Si falla la generación del reporte, muestra: "No pudimos generar el reporte en este momento. Error: \[descripción técnica\]. \[Reintentar\] o contactar al administrador del sistema."

* **Datos Inconsistentes:** Si detecta inconsistencias en los datos, muestra advertencia: "Se detectaron posibles inconsistencias en \[área específica\]. Los resultados pueden requerir verificación adicional."

**Postcondiciones:**

1. El reporte ha sido generado exitosamente con todos los datos solicitados.

2. Las métricas calculadas reflejan accurate el estado operativo del período.

3. Los formatos de exportación están disponibles para su uso inmediato.

4. El registro de auditoría incluye la generación del reporte con parámetros aplicados.

5. Los datos presentados son consistentes con la información de auditoría del sistema.

6. El usuario tiene información confiable para la toma de decisiones operativas.

**CU031: Reportes de Desempeño de Empleados**

**Actor(es):** Administrador

**Descripción:** Permite generar reportes detallados sobre el desempeño individual y colectivo de los empleados, proporcionando métricas de eficiencia y productividad para procesos de evaluación.  
**Precondiciones:**

1. El usuario ha iniciado sesión con permisos de administrador o recursos humanos.

2. Existen tareas completadas y datos de desempeño en el sistema.

3. El módulo de reportes de personal está activo y accesible.

**Flujo Principal:**

1. El usuario accede a "Reportes" \> "Desempeño de Empleados".

2. El sistema presenta interfaz especializada con filtros específicos:

   * **Empleado o Equipo:** Selector individual o múltiple de empleados

   * **Estado de Tareas:** Completadas, Aprobadas, Rechazadas, En retrabajo

   * **Tipo de Tarea:** Filtro por proceso específico (Corte, Ensamblaje, Acabado, etc.)

   * **Rango de Fechas:** Período de evaluación específico

   * **Prioridad de Tareas:** Alta, Media, Baja o todas

   * **Supervisor:** Filtro por supervisor responsable

3. **Configuración del Análisis:**

   * Usuario selecciona empleados específicos y período del último mes

   * Establece comparativa entre empleados o contra estándares históricos

   * Selecciona métricas a incluir en el reporte

   * Hace clic en "Generar Reporte de Desempeño"

4. **Procesamiento de Métricas:**

   * Sistema calcula indicadores clave de desempeño:

     * **Eficiencia por Empleado:** (Tiempo estándar / Tiempo real) × 100

     * **Tiempo de Retrabajo:** Horas dedicadas a corregir tareas rechazadas

     * **Desviación vs Tiempo Estándar:** Diferencia promedio entre planificado y real

     * **Tasa de Retrabajo:** (Tiempo retrabajo / Tiempo total) × 100

     * **Calificación de Eficiencia:** Puntuación basada en múltiples factores

   * Sistema procesa datos de todas las tareas completadas en el período

5. **Visualización de Resultados:**

   * **Reporte Individual por Empleado:**

     * Tabla resumen con todas las métricas calculadas

     * Gráfico de tendencia de eficiencia en el tiempo

     * Distribución de tiempo por tipo de tarea

     * Comparativa con el promedio del equipo

   * **Reporte Colectivo del Equipo:**

     * Ranking de eficiencia entre empleados

     * Identificación de mejores prácticas

     * Detección de oportunidades de mejora

     * Análisis de consistencia en el desempeño

6. **Exportación y Aplicación:**

   * Exportación a PDF para revisiones formales y evaluaciones

   * Exportación a Excel para análisis estadístico avanzado

   * Integración con sistema de evaluación de desempeño si está disponible

   * Histórico de reportes disponibles para comparativa temporal

**Flujos Alternos:**

* **Empleado Sin Tareas en Período:** Si un empleado seleccionado no tiene tareas en el período, muestra: "El empleado \[nombre\] no tiene tareas registradas en el período seleccionado. No se pueden calcular métricas de desempeño."

* **Acceso No Autorizado:** Si un empleado de planta intenta acceder a estos reportes, muestra: "No tiene permisos para acceder a reportes de desempeño. Contacte al departamento de Recursos Humanos si requiere esta información."

* **Datos Insuficientes para Métricas:** Si no hay suficientes datos para cálculos estadísticos, muestra: "Datos insuficientes para el período seleccionado. Se requieren al menos \[X\] tareas completadas para métricas confiables."

* **Personalización de Fórmulas:** Usuarios avanzados pueden ajustar fórmulas de cálculo para métricas específicas según políticas de la empresa.

**Postcondiciones:**

1. El reporte de desempeño ha sido generado con métricas confiables y actualizadas.

2. Las comparativas entre empleados y contra estándares están disponibles.

3. Los formatos exportables facilitan la revisión y evaluación formal.

4. El registro de auditoría documenta la generación del reporte.

5. La información está disponible para procesos de evaluación de desempeño.

6. Los reportes históricos permanecen consultables, pero no editables.

**CU032: Contabilidad de Producción por Empleado**

**Actor(es):** Sistema, Administrador  
**Descripción:** Mantiene automáticamente un registro detallado de la producción ejecutada por cada empleado, proporcionando datos precisos para análisis de rendimiento operativo individual y facilitando procesos de evaluación.  
**Precondiciones:**

1. Existen tareas de producción marcadas como "Completadas" y "Aprobadas" en el sistema.

2. Los empleados tienen cuentas activas y perfiles completos en el sistema.

3. El módulo de contabilidad de producción está operativo.

**Flujo Principal:**

1. **Detección Automática de Tareas Completadas:**

   * El sistema monitorea continuamente el cambio de estado de las tareas

   * Cuando una tarea cambia a "Completada" y luego a "Aprobada" por el supervisor

   * El sistema inicia el proceso de contabilización automática

2. **Recopilación de Datos de Producción:**

   * Para cada tarea aprobada, el sistema extrae:

     * Información de la tarea: ID, título, tipo, fecha de finalización

     * Empleado responsable asignado a la tarea

     * Referencia del producto procesado

     * Especificaciones: talla, color, tipo de intervención realizada

     * Cantidad de unidades procesadas registradas en la finalización

     * Resultado de calidad: Aprobado, Aprobado con observaciones

     * Tiempo total empleado vs tiempo estándar

3. **Procesamiento de Contabilización:**

   * El sistema crea un registro de producción por cada tarea aprobada

   * Cada registro incluye:

     * Identificador único de contabilización

     * Tarea origen y empleado responsable

     * Referencia completa del producto

     * Especificaciones detalladas de talla y color

     * Tipo de intervención o proceso ejecutado

     * Cantidad de unidades procesadas

     * Fecha y hora exacta de contabilización

     * Resultado y observaciones de calidad

   * El sistema valida que no existan duplicados de contabilización

4. **Cálculo de Métricas de Rendimiento:**

   * **Cantidad total de pares procesados** por empleado en el período

   * **Tiempo promedio por par** para cada tipo de intervención

   * **Tasa de defectos** reportados por empleado

   * **Eficiencia comparativa** contra estándares establecidos

   * **Consistencia en el tiempo** de rendimiento del empleado

5. **Registros No Contabilizables:**

   * El sistema excluye automáticamente:

     * Tareas completadas pero no aprobadas por supervisión

     * Tareas sin unidades procesadas registradas

     * Tareas de capacitación o mantenimiento sin producción

     * Tareas canceladas o rechazadas

6. **Consulta y Reportes:**

   * Los administradores pueden consultar la contabilidad por:

     * Empleado específico y rango de fechas

     * Tipo de intervención o proceso

     * Referencia de producto específica

   * El sistema proporciona vistas resumidas y detalladas

   * Reportes históricos disponibles para análisis de tendencias

**Flujos Alternos:**

* **Tarea Ya Contabilizada:** Si se detecta que una tarea ya fue contabilizada previamente, el sistema omite el procesamiento y registra: "Tarea \[ID\] ya contabilizada en \[fecha anterior\]. No se genera nuevo registro."

* **Datos Incompletos en Tarea:** Si la tarea aprobada no tiene todos los datos requeridos para contabilización, el sistema la marca como "Pendiente de datos" y notifica al supervisor para completar la información.

* **Empleado Sin Producción en Período:** Si un empleado no tiene tareas aprobadas en el período consultado, el sistema muestra: "El empleado no tiene producción contabilizada en el período seleccionado."

* **Ajuste Manual Requerido:** En casos excepcionales, el sistema permite ajustes manuales pero requiere doble aprobación y registro detallado de justificación.

**Postcondiciones:**

1. La producción de cada empleado ha sido contabilizada accurate en el sistema.

2. Los registros de producción son inmutables y trazables hasta la tarea origen.

3. Las métricas de rendimiento individual están actualizadas y disponibles.

4. No se permiten manipulaciones manuales de los datos de producción base.

5. Los reportes de productividad reflejan la realidad operativa exacta.

6. El historial de contabilidad sirve como base para evaluaciones y análisis.

**CU033: Contabilidad de Pares Fabricados Semanalmente**

**Actor(es):** Sistema, administrador  
**Descripción:** Consolida automáticamente cada semana la cantidad total de pares fabricados, validando la integridad de los datos y generando reportes detallados para análisis de productividad periódica.  
**Precondiciones:**

1. Existen tareas de fabricación completadas y aprobadas en el sistema.

2. El servicio de inventario está sincronizado y operativo.

3. La configuración de semana laboral está definida en el sistema.

**Flujo Principal:**

1. **Programación de Corte Semanal:**

   * El sistema programa ejecución automática cada domingo a las 23:59

   * Configuración flexible permite definir inicio de semana laboral (lunes o domingo)

   * El proceso se ejecuta automáticamente sin intervención manual

2. **Recolección de Datos Semanales:**

   * Sistema toma todas las tareas de fabricación con:

     * Estado "Completada" y "Aprobada"

     * Fecha de finalización dentro de los 7 días anteriores al corte

     * Unidades registradas en el inventario correctamente

   * Período de recolección: desde lunes 00:00 hasta domingo 23:59

3. **Validación de Integridad de Datos:**

   * Para cada tarea incluida en el corte, el sistema verifica:

     * Que esté correctamente cerrada en el sistema de producción

     * Que las unidades estén registradas en el inventario

     * Que no haya discrepancias entre producción reportada e inventariada

   * Si detecta discrepancia, excluye la tarea del corte y registra motivo

4. **Generación del Consolidado Semanal:**

   * Sistema calcula total de pares fabricados en la semana

   * Genera desglose obligatorio por:

     * Modelo o referencia de producto

     * Categoría de calzado

     * Estado final (Aprobado, En cuarentena, Pérdida)

   * Asegura conciliación: Pares producidos \= Pares en inventario \+ Pares en cuarentena \+ Pares pérdida

5. **Estructura del Reporte Semanal:**

   * **Encabezado:** Semana calendario, fecha de corte, total de pares

   * **Desglose Detallado:**

     * Por referencia, talla, color, estilo, marca

     * Por empleado o equipo de producción

     * Por turno o línea de producción

     * Por estado de calidad final

   * **Métricas Adicionales:**

     * Comparativa con semana anterior

     * Porcentaje de cumplimiento de meta semanal

     * Eficiencia general de producción

6. **Distribución Automática:**

   * Al finalizar el procesamiento, el sistema envía el reporte por correo al administrador

   * Almacena el reporte en el historial de reportes semanales

   * Actualiza dashboards y indicadores de productividad

**Flujos Alternos:**

* **Discrepancia en Datos:** Si hay diferencia entre producción e inventario, excluye la tarea y muestra: "Tarea \[ID\] excluida por discrepancia. Producción: \[X\], Inventario: \[Y\]. Motivo: \[razón específica\]."

* **Sin Producción en la Semana:** Si no hay producción en una semana, genera corte con valor cero y reporte: "Semana sin actividad de producción registrada."

* **Error en Procesamiento:** Si falla el procesamiento automático, el sistema reintenta cada hora hasta por 6 horas, luego notifica al administrador para procesamiento manual.

* **Configuración de Festivos:** El sistema ajusta automáticamente los cálculos para semanas con días festivos o paradas programadas.

**Postcondiciones:**

1. El consolidado semanal de producción ha sido generado y almacenado.

2. La conciliación entre producción e inventario ha sido validada.

3. El reporte ha sido distribuido a los destinatarios designados.

4. Los datos del consolidado son inmutables pero consultables.

5. Las métricas de productividad semanal están actualizadas.

6. El sistema está preparado para el siguiente ciclo semanal.

**CU034: Contabilidad de Pares Totales Pedidos por Cliente Mensualmente**

**Actor(es):** Sistema, Administrador   
**Descripción:** Consolida mensualmente la cantidad total de pares solicitados por cada cliente mayorista, proporcionando análisis detallado del comportamiento de compra para apoyar estrategias comerciales.  
**Precondiciones:**

1. Existen pedidos de clientes mayoristas registrados en el sistema.

2. Los clientes tienen perfiles completos y categorías asignadas.

3. El servicio de reportes mensuales está configurado y operativo.

**Flujo Principal:**

1. **Ejecución Automática Mensual:**

   * Sistema programa ejecución el último día de cada mes a las 23:59

   * Proceso se activa automáticamente sin intervención manual

   * Período de análisis: desde día 1 hasta último día del mes

2. **Recolección y Filtrado de Pedidos:**

   * Sistema toma todos los pedidos registrados por clientes mayoristas en el mes

   * **Pedidos Incluidos:**

     * Pedidos con estado: Aprobado, En producción, Completado, Entregado

     * Pedidos con combinaciones completas y cantidades válidas

     * Pedidos de clientes con categoría "Mayorista" activa

   * **Pedidos Excluidos:**

     * Pedidos cancelados o en estado "Borrador"

     * Pedidos con combinaciones incompletas o cantidades nulas

     * Pedidos de clientes inactivos o en mora

3. **Validación de Consistencia de Datos:**

   * Para cada pedido incluido, el sistema verifica:

     * Que esté correctamente registrado con combinaciones definidas

     * Que las cantidades sean numéricas y positivas

     * Que el cliente tenga estado activo y vigente

   * Si detecta inconsistencia, excluye el pedido y registra motivo detallado

4. **Cálculo de Métricas Clave:**

   * **Total de pares solicitados** por cada cliente

   * **Porcentaje de cumplimiento:** (Pares entregados / Pares solicitados) × 100

   * **Porcentaje de entrega a tiempo:** Pedidos entregados en fecha prometida

   * **Distribución por categoría de producto** por cliente

   * **Tendencia mensual** vs meses anteriores

5. **Generación del Reporte Mensual:**

   * **Estructura del Reporte:**

     * Mes calendario y fecha de corte

     * Cliente específico o consolidado general

     * Total de pares solicitados y entregados

     * Desglose por referencia, talla, color, estilo, marca

     * Estado actual de los pedidos del mes

   * **Métricas Comerciales:**

     * Clientes con mayor volumen de compra

     * Productos más solicitados por cliente

     * Estacionalidad en los pedidos

     * Potencial de crecimiento por cliente

6. **Acceso y Exportación:**

   * Solo administrador y gerente comercial pueden acceder a estos reportes

   * Filtros disponibles por: cliente específico, mes, estado del pedido, referencia

   * Exportación a Excel para análisis avanzado

   * Consulta histórica de reportes mensuales anteriores

**Flujos Alternos:**

* **Cliente Sin Pedidos en el Mes:** Si un cliente no registra pedidos en el mes, genera corte con valor cero: "Cliente \[nombre\] sin actividad de pedidos en \[mes\]."

* **Pedido con Inconsistencias:** Si un pedido tiene combinaciones incompletas, lo excluye y registra: "Pedido \[ID\] excluido por \[razón específica\]. Contactar al área comercial para corrección."

* **Filtro por Cliente y Modelo Específicos:** Al aplicar filtros específicos, el reporte muestra solo la información solicitada: "Visualizando pedidos de \[cliente\] para \[modelo\] en \[mes\]."

* **Cálculo de Porcentajes con Cero:** Si un cliente no tuvo entregas en el mes, muestra: "Porcentaje de cumplimiento: 0% \- Sin entregas registradas en el período."

**Postcondiciones:**

1. El consolidado mensual de pedidos por cliente ha sido generado.

2. Los porcentajes de cumplimiento y entrega a tiempo han sido calculados.

3. El reporte está disponible para consulta y exportación por usuarios autorizados.

4. Los datos del consolidado son inmutables pero consultables históricamente.

5. La información está disponible para estrategias comerciales y seguimiento de clientes.

6. El sistema ha mantenido la confidencialidad de la información comercial.

