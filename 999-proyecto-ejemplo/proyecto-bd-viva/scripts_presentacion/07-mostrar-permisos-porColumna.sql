-- ==============================================================================
-- SCRIPT: 08-permisos-columnas.sql
-- OBJETIVO: Ver qué columnas específicas puede mirar cada rol
--           para confirmar que los datos sensibles están ocultos.
-- ==============================================================================

SELECT 
    grantee AS rol,
    table_schema AS esquema,
    table_name AS tabla,
    column_name AS columna,
    privilege_type AS privilegio
FROM information_schema.column_privileges
WHERE table_schema IN ('clientes', 'comercial', 'fidelizacion', 'finanzas', 'lineas', 'seguridad', 'servicios')
  AND grantee <> 'postgres'
ORDER BY grantee, table_schema, table_name, column_name;
