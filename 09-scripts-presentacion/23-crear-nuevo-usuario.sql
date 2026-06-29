-- ==============================================================================
-- SCRIPT: 23-crear-nuevo-usuario.sql
-- OBJETIVO: Crear un nuevo usuario del sistema para un empleado nuevo.
--           Cubre AMBOS mundos: app web (Filament) Y acceso directo a Postgres.
--
-- INSTRUCCIONES:
--   1. Editar las 4 variables de la sección "CAMBIAR AQUÍ"
--   2. Ejecutar: bash run.sh 23-crear-nuevo-usuario.sql
--   3. Entregar al empleado: username y password_web
-- ==============================================================================

-- ==============================================================================
-- ⚠️  CAMBIAR AQUÍ — Solo tocar estas 4 líneas
-- ==============================================================================

-- Nombre de usuario para el login web (lo que escribe en la pantalla de login)
\set username_web     'nuevo.empleado'

-- Contraseña para el login web (la que escribe en la pantalla de login)
\set password_web     'CambiarEsto123!'

-- Rol del empleado. Opciones válidas:
--   rol_comercial  → Gestión de paquetes y promociones
--   rol_auditor    → Auditorías y seguridad
--   rol_finanzas   → Facturas y recargas
--   rol_agencia    → Alta de clientes y líneas
--   rol_reporte    → Dashboard de Business Intelligence
\set rol_empleado     'rol_auditor'

-- Nombre del usuario en Postgres (para acceso directo con pgAdmin/DBeaver)
-- Convención: u_nombre_apellido  (usar guiones bajos, sin tildes)
\set username_pg      'u_nuevo_empleado'

-- ==============================================================================
-- ✋  NO CAMBIAR NADA DE AQUÍ PARA ABAJO
-- ==============================================================================

\echo ''
\echo '══════════════════════════════════════════════════════'
\echo ' Creando nuevo usuario del sistema VIVA...'
\echo '══════════════════════════════════════════════════════'

BEGIN;

-- ─────────────────────────────────────────────────────────
-- PASO 1: Registro en la App Web (Filament / Laravel)
--         El middleware de Laravel usará rol_db para el SET ROLE
-- ─────────────────────────────────────────────────────────
INSERT INTO seguridad."Usuario_Sistema" (username, password_hash, rol_db)
VALUES (
    :'username_web',
    crypt(:'password_web', gen_salt('bf', 12)),  -- bcrypt igual al que usa Laravel
    :'rol_empleado'
);

\echo '✅ PASO 1: Usuario creado en seguridad.Usuario_Sistema (acceso web Filament)'

-- ─────────────────────────────────────────────────────────
-- PASO 2: Usuario en PostgreSQL (acceso directo con pgAdmin)
--         Solo sirve si el empleado necesita conectarse a la BD directamente.
--         Si solo usará la app web, este paso es opcional pero no hace daño.
-- ─────────────────────────────────────────────────────────
-- NOTA: La contraseña de Postgres es independiente de la del login web.
--       Aquí se usa la misma por conveniencia, pero pueden ser distintas.
SELECT FORMAT(
    'CREATE USER %I WITH PASSWORD %L VALID UNTIL ''2027-12-31'' INHERIT IN ROLE %I',
    :'username_pg', :'password_web', :'rol_empleado'
) AS sql_a_ejecutar;

-- Ejecutamos dinámicamente:
DO $$
DECLARE
    v_username_pg  text := current_setting('psql.username_pg',  true);
    v_password_web text := current_setting('psql.password_web', true);
    v_rol          text := current_setting('psql.rol_empleado',  true);
BEGIN
    -- Verificar que el usuario de Postgres no exista ya
    IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = v_username_pg) THEN
        RAISE NOTICE '⚠️  El usuario de Postgres "%" ya existe. Se omite la creación.', v_username_pg;
    ELSE
        EXECUTE FORMAT(
            'CREATE USER %I WITH PASSWORD %L VALID UNTIL ''2027-12-31'' INHERIT IN ROLE %I',
            v_username_pg, v_password_web, v_rol
        );
        RAISE NOTICE '✅ PASO 2: Usuario de Postgres "%" creado con rol "%"', v_username_pg, v_rol;
    END IF;
END;
$$;

COMMIT;

-- ─────────────────────────────────────────────────────────
-- VERIFICACIÓN FINAL — Confirmar que todo quedó bien
-- ─────────────────────────────────────────────────────────
\echo ''
\echo '──────────────────────────────────────────────────────'
\echo ' Verificación: usuario en la tabla de la app web'
\echo '──────────────────────────────────────────────────────'

SELECT
    id_usuario,
    username,
    rol_db,
    '(contraseña hasheada con bcrypt)' AS password_hash
FROM seguridad."Usuario_Sistema"
WHERE username = :'username_web';

\echo ''
\echo '──────────────────────────────────────────────────────'
\echo ' Verificación: usuario de Postgres'
\echo '──────────────────────────────────────────────────────'

SELECT
    r.rolname          AS "Usuario Postgres",
    r1.rolname         AS "Rol heredado",
    r.rolvaliduntil    AS "Válido hasta"
FROM pg_roles r
JOIN pg_auth_members m  ON r.oid = m.member
JOIN pg_roles r1        ON m.roleid = r1.oid
WHERE r.rolname = :'username_pg';

\echo ''
\echo '══════════════════════════════════════════════════════'
\echo ' ✅ USUARIO CREADO. Credenciales para entregar:'
\echo '    URL web:     http://<IP-AZURE>:8000/mi-viva'
\echo '    Usuario:    ' :'username_web'
\echo '    Contraseña: ' :'password_web'
\echo '    Rol:        ' :'rol_empleado'
\echo '══════════════════════════════════════════════════════'
