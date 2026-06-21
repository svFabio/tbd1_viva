-- ==============================================================================
-- SCRIPT: 07-permisos-tablas-por-rol.sql
-- OBJETIVO: Ver qué tablas puede tocar cada rol (SELECT, INSERT, etc.)
--           y confirmar que NO tienen acceso total.
-- ==============================================================================

SELECT 
    grantee AS rol,
    table_schema AS esquema,
    table_name AS tabla,
    privilege_type AS privilegio
FROM information_schema.role_table_grants
WHERE table_schema IN ('clientes', 'comercial', 'fidelizacion', 'finanzas', 'lineas', 'seguridad', 'servicios')
  AND grantee <> 'postgres'
ORDER BY grantee, table_schema, table_name;
