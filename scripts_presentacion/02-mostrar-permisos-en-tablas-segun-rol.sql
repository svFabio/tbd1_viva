-- ==============================================================================
-- SCRIPT: 02-permisos-de-roles.sql
-- OBJETIVO: Mostrar qué permisos exactos (INSERT, SELECT, UPDATE, DELETE) 
--           tiene un rol específico sobre las tablas de la base de datos.
-- ==============================================================================

SELECT grantee AS rol_evaluado,
       table_schema AS esquema,
       table_name AS tabla,
       privilege_type AS permiso_concedido
FROM information_schema.role_table_grants
WHERE grantee = 'rol_admin_promo'  -- <--- CAMBIAR ESTO SEGUN ROL
ORDER BY esquema, tabla, permiso_concedido;
