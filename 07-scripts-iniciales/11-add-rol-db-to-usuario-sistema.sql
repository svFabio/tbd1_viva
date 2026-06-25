-- ==============================================================================
-- SCRIPT: 11-add-rol-db-to-usuario-sistema.sql
-- OBJETIVO: Añadir columna rol_db a Usuario_Sistema para que el Middleware
--           de Laravel asigne permisos dinámicamente sin hardcodear usernames.
--           Esto permite que el docente cree cualquier usuario nuevo en Postgres
--           y solo tenga que agregar un registro aquí para que funcione.
-- ==============================================================================

ALTER EVENT TRIGGER trg_audit_ddl DISABLE;

-- 1. Añadir la columna con valor por defecto 'rol_app' (para no romper datos existentes)
ALTER TABLE seguridad."Usuario_Sistema"
    ADD COLUMN IF NOT EXISTS rol_db varchar(30) NOT NULL DEFAULT 'rol_app';

-- 2. Actualizar los usuarios administradores existentes con su rol correcto
UPDATE seguridad."Usuario_Sistema" SET rol_db = 'rol_comercial' WHERE username = 'u.comercial';
UPDATE seguridad."Usuario_Sistema" SET rol_db = 'rol_auditor'   WHERE username = 'u.auditor';
UPDATE seguridad."Usuario_Sistema" SET rol_db = 'rol_agencia'   WHERE username = 'u.agencia';
UPDATE seguridad."Usuario_Sistema" SET rol_db = 'rol_finanzas'  WHERE username = 'u.finanzas';
UPDATE seguridad."Usuario_Sistema" SET rol_db = 'rol_reporte'   WHERE username = 'u.reporte';
-- Los clientes (todos los que tienen id_cliente) quedan con 'rol_app' por defecto. ✔

-- 3. Dar permiso al u_admin_web para que pueda leer la columna nueva
GRANT SELECT ON seguridad."Usuario_Sistema" TO u_admin_web;

ALTER EVENT TRIGGER trg_audit_ddl ENABLE;
