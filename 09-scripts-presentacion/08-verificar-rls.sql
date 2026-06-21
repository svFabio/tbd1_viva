-- ==============================================================================
-- SCRIPT: 09-verificar-rls.sql
-- OBJETIVO: Listar qué tablas tienen la seguridad RLS activada
--           y cuáles son las políticas/reglas de filtrado aplicadas.

-- rls es una característica de PostgreSQL que permite controlar qué filas específicas de una tabla 
-- puede ver o modificar cada usuario

-- ==============================================================================

SELECT 
    schemaname AS esquema,
    tablename AS tabla,
    policyname AS nombre_politica,
    roles AS roles_afectados,
    cmd AS operacion,
    qual AS regla_filtrado -- Esto muestra el "USING" de la política
FROM pg_policies
WHERE schemaname IN ('clientes', 'comercial', 'fidelizacion', 'finanzas', 'lineas', 'seguridad', 'servicios')
ORDER BY schemaname, tablename;
