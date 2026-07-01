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

1. Revisa si hay un usuario autenticado en Laravel (`auth()->check()`).
2. Si el usuario está autenticado, recupera el rol asignado en la BD (ej. `rol_comercial`, `rol_agencia`, `rol_finanzas`).
3. Ejecuta comandos de sesión en PostgreSQL antes de ejecutar cualquier consulta:
   - `DB::statement("SET ROLE {$rolEnBd}");` → PostgreSQL cambia dinámicamente el usuario de la sesión.
   - `DB::statement("SET app.current_web_user = '{$username}'");` → Inyecta el username real en una variable de sesión de PostgreSQL para que los *Triggers de Auditoría* sepan exactamente quién hizo la modificación.
4. **Resultado**: Las consultas que hace Laravel ya no son hechas por el "super admin", sino por el rol estricto. Si un `rol_agencia` intenta borrar un paquete, PostgreSQL lo bloquea con un error de `permission denied`.

---

## 3. Mapeo de Datos (Modelos y Tablas)

Laravel mapea las tablas de PostgreSQL a clases PHP llamadas **Modelos**. 
Al usar esquemas en PostgreSQL (ej. `seguridad`, `comercial`, `finanzas`), se debe especificar explícitamente en cada modelo.

### Archivos clave (Carpeta `app/Models/`):
- **`UsuarioSistema.php`** → Se mapea a `seguridad."Usuario_Sistema"` (Autenticación).
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
**La aplicación NO hace todo el trabajo.** La lógica de negocio crítica está programada directamente en PostgreSQL mediante **Funciones y Triggers** (`07-scripts-iniciales/03-triggers.sql` y otros):

- **Trigger de Auditoría**: Cuando Laravel hace un `INSERT/UPDATE`, el trigger captura el cambio de forma invisible y lo guarda en `seguridad."Auditoria"`.
- **Trigger de Recarga / Doble Carga**: Cuando Laravel registra una recarga de Bs. 50, es un trigger de BD (`fn_actualizar_bolsillo_recarga`) quien revisa si hoy aplica "Doble Carga" y multiplica el saldo *antes* de insertarlo en el `Bolsillo`.

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

## Resumen del Flujo Completo

1. **Usuario** hace click en "Comprar Paquete" en el panel.
2. **Middleware `SetDatabaseRole`** intercepta y dice: "Este usuario es un cliente de la App, configuro PostgreSQL en `rol_app`".
3. **Laravel `TiendaPaquetes.php`** revisa si hay crédito en `Bolsillo` (Capa Aplicación).
4. **Laravel** resta el costo y suma los megas al `Bolsillo`.
5. **PostgreSQL Triggers** capturan la actualización del `Bolsillo` y la registran en `Auditoria` (Capa BD).
6. La vista `BolsilloWidget.php` de Laravel lee de nuevo los datos y muestra las fechas de caducidad calculadas.

Esta arquitectura garantiza que la aplicación web es solo una **interfaz segura**; la verdadera integridad de la información reside férreamente protegida en el motor relacional de PostgreSQL.
