-- ==============================================================================
-- SCRIPT: 23-crear-nuevo-usuario.sql
-- OBJETIVO: Crear un nuevo usuario para un empleado nuevo.
--           Cubre AMBOS mundos: app web (Filament) Y acceso directo a Postgres.
--
-- INSTRUCCIONES:
--   1. Editar las 4 variables de la sección "CAMBIAR AQUÍ"
--   2. Ejecutar: bash run.sh 23-crear-nuevo-usuario.sql
--   3. Entregar al empleado: username_web y password_web
-- ==============================================================================

-- ==============================================================================
-- ⚠️  CAMBIAR AQUÍ — Solo tocar estas 4 líneas
-- ==============================================================================

-- Nombre de usuario para el login web (lo que escribe en la pantalla de login)
\set username_web     'nuevo.empleado'

-- Contraseña para el login web
\set password_web     'CambiarEsto123!'

-- Rol del empleado. Opciones válidas:
--   rol_comercial  → Gestión de paquetes y promociones
--   rol_auditor    → Auditorías y seguridad
--   rol_finanzas   → Facturas y recargas
--   rol_agencia    → Alta de clientes y líneas
--   rol_reporte    → Dashboard de Business Intelligence
\set rol_empleado     'rol_auditor'

-- Usuario para acceso directo a Postgres con pgAdmin/DBeaver
-- Convención: u_nombre_apellido  (guiones bajos, sin tildes)
\set username_pg      'u_nuevo_empleado'

-- ==============================================================================
-- ✋  NO CAMBIAR NADA DE AQUÍ PARA ABAJO
-- ==============================================================================

\echo ''
\echo '══════════════════════════════════════════════════════'
\echo ' Creando nuevo usuario del sistema VIVA...'
\echo '══════════════════════════════════════════════════════'

-- ─────────────────────────────────────────────────────────
-- PASO 1: Registro en la App Web (Filament / Laravel)
--         Dentro de una transacción para que si falla, no quede a medias
-- ─────────────────────────────────────────────────────────
BEGIN;

INSERT INTO seguridad."Usuario_Sistema" (username, password_hash, rol_db)
VALUES (
    :'username_web',
    crypt(:'password_web', gen_salt('bf', 12)),
    :'rol_empleado'
);

COMMIT;

\echo '✅ PASO 1: Usuario creado en seguridad.Usuario_Sistema (acceso web Filament)'

-- ─────────────────────────────────────────────────────────
-- PASO 2: Usuario en PostgreSQL (para pgAdmin/DBeaver)
--         Usamos \gexec para poder usar variables \set en DDL
--         Si el usuario ya existe, muestra un WARNING pero NO aborta.
-- ─────────────────────────────────────────────────────────
\set ON_ERROR_STOP off

SELECT FORMAT(
    'CREATE USER %I WITH PASSWORD %L VALID UNTIL ''2027-12-31'' INHERIT IN ROLE %I',
    :'username_pg',
    :'password_web',
    :'rol_empleado'
) \gexec

\set ON_ERROR_STOP on

\echo '✅ PASO 2: Usuario de Postgres creado (para acceso directo con pgAdmin)'

-- ─────────────────────────────────────────────────────────
-- VERIFICACIÓN FINAL
-- ─────────────────────────────────────────────────────────
\echo ''
\echo '──────────────────────────────────────────────────────'
\echo ' Verificación: usuario en la app web'
\echo '──────────────────────────────────────────────────────'

SELECT
    id_usuario,
    username,
    rol_db,
    '(contraseña hasheada con bcrypt ✅)' AS password_hash
FROM seguridad."Usuario_Sistema"
WHERE username = :'username_web';

\echo ''
\echo '──────────────────────────────────────────────────────'
\echo ' Verificación: usuario de Postgres'
\echo '──────────────────────────────────────────────────────'

SELECT
    r.rolname       AS "Usuario Postgres",
    r1.rolname      AS "Rol heredado",
    r.rolvaliduntil AS "Válido hasta"
FROM pg_roles r
JOIN pg_auth_members m ON r.oid = m.member
JOIN pg_roles r1       ON m.roleid = r1.oid
WHERE r.rolname = :'username_pg';

\echo ''
\echo '══════════════════════════════════════════════════════'
\echo ' ✅ LISTO. Credenciales para entregar al empleado:'
\echo ''
\echo '    URL:         http://<IP-AZURE>:8000/mi-viva'
\echo '    Usuario:    ' :'username_web'
\echo '    Contraseña: ' :'password_web'
\echo '    Rol:        ' :'rol_empleado'
\echo '══════════════════════════════════════════════════════'
