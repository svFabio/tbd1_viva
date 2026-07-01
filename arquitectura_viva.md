# Arquitectura e Integración App-Base de Datos VIVA

Este documento es un informe completo sobre cómo la aplicación web (Laravel + Filament) se conecta, mapea y sincroniza con la base de datos PostgreSQL, respetando los principios de diseño de bases de datos y seguridad.

---

## 1. Conexión Principal (App ↔ BD)

La aplicación web está desarrollada en **Laravel 11**, el cual utiliza **Eloquent ORM** para interactuar con la base de datos.

### Archivos clave de conexión:
1. **`.env`**: Es el archivo de variables de entorno donde se definen las credenciales del "súper usuario" o usuario de conexión principal (ej. `DB_USERNAME=postgres`, `DB_PASSWORD=...`). 
2. **`config/database.php`**: Laravel toma las variables del `.env` y configura el driver `pgsql` (PostgreSQL) para establecer los hilos de conexión hacia el contenedor Docker de la base de datos.

---

## 2. El Middleware de Seguridad (RBAC de PostgreSQL)

Uno de los pilares de este proyecto es que **la seguridad y los roles se manejan a nivel de Base de Datos**, no solo en la aplicación.

### Archivo clave:
- **`app/Http/Middleware/SetDatabaseRole.php`**

### ¿Cómo funciona el Middleware?
En aplicaciones normales, todas las peticiones a la BD se hacen con el usuario `postgres` (o el usuario genérico del `.env`). **Esto es inseguro y rompe el modelo RBAC**.
Nuestro Middleware intercepta *cada petición web* antes de que interactúe con la base de datos y hace lo siguiente:

1. Revisa si hay un usuario autenticado en Laravel mediante la sesión web (`auth()->check()`).
2. Si el usuario está autenticado, recupera el rol que tiene asociado directamente en su registro de la base de datos haciendo uso del modelo: `$rolEnBd = Auth::user()->rol_db;` (que puede ser `rol_comercial`, `rol_agencia`, `rol_finanzas`, o `rol_app`).
3. Ejecuta comandos de sesión nativos de PostgreSQL antes de permitir que Laravel haga cualquier otra consulta:
   - `DB::statement("SET ROLE {$rolEnBd}");` → PostgreSQL cambia dinámicamente el usuario de la sesión.
   - `DB::statement("SET app.current_web_user = '{$username}'");` → Inyecta el username real en una variable de sesión de PostgreSQL para que los *Triggers de Auditoría* sepan exactamente quién hizo la modificación.
4. **Resultado**: Las consultas que hace Laravel ya no son hechas por el "super admin", sino por el rol estricto. Si un `rol_agencia` intenta borrar un paquete, PostgreSQL lo bloquea con un error de `permission denied`.

---

## 3. Mapeo de Datos (Modelos y Tablas)

Laravel mapea las tablas de PostgreSQL a clases PHP llamadas **Modelos**. 
Al usar esquemas en PostgreSQL (ej. `seguridad`, `comercial`, `finanzas`), se debe especificar explícitamente en cada modelo.

### ¿Cómo se mapea?
En cada archivo dentro de `app/Models/`, se define explícitamente el esquema y la tabla usando la propiedad `$table`, y su llave primaria con `$primaryKey`. Por ejemplo, en `Bolsillo.php` se define `protected $table = 'finanzas.Bolsillo';` y `protected $primaryKey = 'id_bolsillo';`.

### Archivos clave (Carpeta `app/Models/`):
- **`UsuarioSistema.php`** → Se mapea a `seguridad."Usuario_Sistema"` (Autenticación). Propiedades: `$table = 'seguridad.Usuario_Sistema'`.
- **`Cliente.php`** → Se mapea a `ventas."Cliente"`.
- **`Linea.php`** → Se mapea a `lineas."Linea"`.
- **`Paquete.php`** → Se mapea a `servicios."Paquete"`.
- **`Bolsillo.php`** → Se mapea a `finanzas."Bolsillo"`.

### Relaciones:
Los modelos de Laravel definen cómo se conectan las tablas (Llaves Foráneas). Por ejemplo, un `Cliente` tiene muchas `Lineas` (`hasMany`), y una `Línea` pertenece a un `Cliente` (`belongsTo`). Esto permite que la aplicación extraiga jerarquías complejas fácilmente.

---

## 4. ¿Cómo se crean los registros en BD? (Sincronización)

El flujo de creación de datos involucra tanto a la **Capa de Aplicación (PHP)** como a la **Capa de Base de Datos (SQL Triggers)**. 

### A) Desde la Aplicación (Filament)
El panel administrativo (Filament) tiene **Recursos** (`app/Filament/Resources/`) y **Páginas** (`app/Filament/Pages/`).
Cuando el usuario llena un formulario y presiona "Guardar":
1. **Validación en Laravel**: PHP verifica que los correos sean válidos, que no haya campos vacíos, etc.
2. **Transacciones (`DB::beginTransaction()`)**: Si se inserta en varias tablas (ej. Alta de Línea), Laravel asegura que se guarden *todas o ninguna*.
3. **Ejemplo en Alta de Línea (`app/Filament/Pages/AltaLinea.php`)**:
   - Crea el `Cliente`.
   - Crea la `Línea`.
   - Crea el `Bolsillo` en inicializando los saldos en 0.
   - Crea el `Usuario_Sistema` y le asigna el rol `rol_app` (para la app móvil).
   - *Todo esto respetando los permisos del `rol_agencia` inyectados por el Middleware.*

### B) Desde la Base de Datos (Triggers)
**La aplicación NO hace todo el trabajo.** La lógica de negocio crítica está programada directamente en PostgreSQL mediante **Funciones y Triggers**. Los triggers actúan como "interceptores automáticos" en la base de datos cada vez que la aplicación intenta insertar, actualizar o borrar un dato.

#### Archivos y Triggers Específicos:
1. **`03-triggers.sql` (Auditoría DML y DDL):**
   - Contiene el trigger `trg_audit_dml` que se dispara `AFTER INSERT OR DELETE OR UPDATE` en tablas clave. Este trigger llama a la función `seguridad.fn_auditoria_dml()` para guardar automáticamente en `seguridad."Auditoria"` el registro de qué tabla cambió, quién lo hizo (recuperado de la sesión `app.current_web_user`), y el JSON con el dato viejo y nuevo.
2. **`03-1-trigger-recarga-bolsillo.sql` (Doble Carga Automática):**
   - Contiene el trigger `trg_actualizar_bolsillo_recarga` asociado a la tabla `finanzas."Recarga"`. Cuando la aplicación (PHP) inserta una nueva recarga de Bs. 50, este trigger intercepta el insert y llama a la función `finanzas.fn_actualizar_bolsillo_recarga()`. Esta función busca en `comercial."Promocion"` si hay una promoción vigente. Si la hay, multiplica el saldo x2 y luego actualiza `finanzas."Bolsillo"` automáticamente sin que Laravel se entere.

---

## 5. Tablas Principales Conectadas a la App

Para que la aplicación VIVA funcione, se interconecta con los siguientes módulos de la base de datos:

1. **Módulo de Seguridad (`seguridad`)**
   - `Usuario_Sistema`: Login de la aplicación, roles y contraseñas (encriptadas).
   - `Auditoria`: Mantiene el historial de "quién hizo qué".

2. **Módulo de Ventas y Líneas (`ventas`, `lineas`)**
   - `Cliente`, `Persona_Natural`, `Empresa`: Manejan la identidad de los titulares.
   - `Linea`: Número telefónico asociado al cliente, PIN de PUK, estado de la línea.

3. **Módulo de Servicios y Comercial (`servicios`, `comercial`)**
   - `Paquete`, `App_Exenta`: Catálogo de planes y bolsas (WOW) creadas por el `rol_comercial`.
   - `Bolsa_Activa`: Registra las compras de paquetes que hace el usuario y su vencimiento.
   - `Promocion`: Fechas vigentes para Doble Carga y otros beneficios.

4. **Módulo de Finanzas (`finanzas`)**
   - `Bolsillo`: Un acumulador de saldos (Dinero, Megas, Minutos, SMS). 
   - *Nota Arquitectural:* La aplicación calcula las fechas de vencimiento de los beneficios de los paquetes uniéndolos con `Bolsa_Activa` de forma independiente (Megas por un lado, Minutos por otro), asegurando un modelo de negocio de datos acumulables (Roll-Over).

---

## Resumen del Flujo Completo y Detallado (Ejemplo: Compra de Paquete)

1. **Interacción del Usuario:** El usuario (ej. un cliente autenticado) hace click en "Comprar Paquete" en el dashboard de Filament (interfaz web).
2. **Intercepción del Middleware (`app/Http/Middleware/SetDatabaseRole.php`):**
   - Antes de que el código llegue al controlador, el Middleware detecta que el cliente tiene el rol `rol_app` (`Auth::user()->rol_db`).
   - El Middleware ejecuta `DB::statement("SET ROLE rol_app")` y `DB::statement("SET app.current_web_user = 'juan.carlos'")` en la sesión activa de PostgreSQL.
3. **Lógica de la Aplicación (`app/Filament/Pages/TiendaPaquetes.php`):**
   - Se inicia una transacción (`DB::beginTransaction()`) para evitar datos corruptos si algo falla.
   - Laravel consulta el modelo `Bolsillo` y verifica si `saldo_dinero` es mayor o igual al costo del paquete. Si no hay saldo, Laravel aborta la transacción y muestra un error al usuario.
   - Si hay saldo, Laravel actualiza el modelo `Bolsillo` (restando dinero y sumando los megas del paquete) y crea un nuevo registro en el modelo `BolsaActiva` insertando la fecha de vencimiento (`Carbon::now()->addDays(...)`).
   - Finalmente, Laravel hace el `DB::commit()` y manda los comandos `UPDATE` e `INSERT` a la base de datos, *pero ejecutados bajo los permisos del usuario `rol_app`*.
4. **Respuesta de la Base de Datos (Triggers):**
   - Cuando llega el comando `UPDATE` a `finanzas."Bolsillo"`, el trigger `trg_audit_dml` de PostgreSQL "salta" automáticamente y llama a `seguridad.fn_auditoria_dml()`. Este escribe en la tabla `Auditoria` el registro exacto del cambio de saldos para fines legales, asociándolo al usuario `juan.carlos`.
5. **Lectura y Renderizado de UI (`app/Filament/Widgets/BolsilloWidget.php`):**
   - Al recargar la página, el widget del dashboard ejecuta queries para leer los nuevos saldos. Para mostrar la fecha de vencimiento correcta, Laravel hace un `JOIN` entre `Bolsa_Activa` y `Paquete` para separar el vencimiento de los Megas y de los Minutos, mostrando visualmente la información actualizada.

Esta arquitectura garantiza que la aplicación web es solo una **interfaz segura**; la verdadera integridad de la información reside férreamente protegida en el motor relacional de PostgreSQL.
