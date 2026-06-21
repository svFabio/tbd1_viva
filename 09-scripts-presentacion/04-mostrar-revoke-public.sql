SELECT
    nspname AS nombre_esquema,
    'PUBLIC' AS rol_evaluado, -- Esto es solo texto para la tabla
    has_schema_privilege('public', nspname, 'USAGE') AS puede_entrar_usage, -- AQUÍ EN MINÚSCULA
    has_schema_privilege('public', nspname, 'CREATE') AS puede_crear_tablas -- AQUÍ TAMBIÉN
FROM pg_namespace
WHERE nspname = 'public';
