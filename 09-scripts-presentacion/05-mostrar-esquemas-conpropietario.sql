SELECT 
    schema_name AS nombre_esquema, 
    schema_owner AS propietario
FROM information_schema.schemata
WHERE schema_name NOT IN ('information_schema', 'pg_catalog', 'pg_toast')
      AND schema_name NOT LIKE 'pg_temp_%'
      AND schema_name NOT LIKE 'pg_toast_temp_%'
ORDER BY schema_name;
