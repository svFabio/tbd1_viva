-- ==============================================================================
-- SCRIPT: 12-permisos-app-exenta-para-comercial.sql
-- OBJETIVO: Dar permisos a rol_comercial sobre App_Exenta_En_Bolsa
--           para que pueda gestionar las apps exentas desde el PaqueteResource
--           de Filament sin que la BD lance "permission denied".
--
-- PROBLEMA: El 04-permisos.sql otorgó CRUD a rol_comercial sobre servicios.Paquete
--           pero omitió la tabla relacionada App_Exenta_En_Bolsa, que es la que
--           guarda qué apps son ilimitadas dentro de cada paquete.
--
-- EJECUTAR: bash run.sh 12-permisos-app-exenta-para-comercial.sql
-- ==============================================================================

ALTER EVENT TRIGGER trg_audit_ddl DISABLE;

-- Dar acceso al esquema (ya lo tenía, pero por seguridad)
GRANT USAGE ON SCHEMA servicios TO rol_comercial;

-- CRUD completo sobre App_Exenta_En_Bolsa para que el Repeater de Filament funcione
-- (el Repeater necesita INSERT al agregar, DELETE al quitar, SELECT para mostrar)
GRANT SELECT, INSERT, UPDATE, DELETE ON servicios."App_Exenta_En_Bolsa" TO rol_comercial;

-- Secuencia del id_app (IDENTITY), necesaria para los INSERTs
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA servicios TO rol_comercial;

ALTER EVENT TRIGGER trg_audit_ddl ENABLE;

-- Verificación: confirmar que el permiso quedó aplicado
SELECT
    grantee        AS "Rol",
    table_schema   AS "Esquema",
    table_name     AS "Tabla",
    privilege_type AS "Permiso"
FROM information_schema.role_table_grants
WHERE grantee = 'rol_comercial'
  AND table_name = 'App_Exenta_En_Bolsa'
ORDER BY privilege_type;
