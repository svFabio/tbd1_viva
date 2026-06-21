-- ==============================================================================
-- SCRIPT: 10-evidencia-en-vivo-rls.sql
-- OBJETIVO: Demostración práctica de Row Level Security (RLS) en finanzas."Factura"
--           basado en contexto de sesión para mitigar ataques IDOR.
-- ==============================================================================

-- 1. Cambio de contexto al rol restringido de producción
SET ROLE rol_app;

-- 2. Simulas que inició sesión un cliente de la línea 2.
SET app.current_linea_id = '2';

--PostgreSQL aplica automáticamente la política RLS:
--id_linea = current_setting('app.current_linea_id')::integer

SELECT id_factura, id_linea, monto_total FROM finanzas."Factura";
-- [EVIDENCIA]: El motor retorna únicamente 3 registros pertenecientes a la id_linea = 2

-- 3. Simulación de cambio de contexto a Línea 4
SET app.current_linea_id = '4';
SELECT id_factura, id_linea, monto_total FROM finanzas."Factura";
-- [EVIDENCIA]: El motor destruye la visibilidad anterior y expone solo registros de id_linea = 4

-- 4. Restauración segura de privilegios administrativos
RESET ALL;
RESET ROLE;
