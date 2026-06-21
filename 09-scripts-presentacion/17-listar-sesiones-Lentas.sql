-- =====================================================================
-- PASO 2 (TERMINAL 2): DETECTAR LA SESIÓN LENTA COMO DBA
-- =====================================================================

-- Esta consulta consulta pg_stat_activity para encontrar sesiones
-- que llevan más de 2 segundos ejecutándose activamente.
-- La columna 'duracion_query' mostrará cuánto tiempo lleva corriendo.
-- La columna 'consulta_ejecutada' mostrará qué está haciendo.

SELECT 
    pid,
    usename AS usuario,
    client_addr AS ip_cliente,
    backend_start AS inicio_conexion,
    state AS estado,
    now() - query_start AS duracion_query,
    query AS consulta_ejecutada
FROM pg_stat_activity
WHERE state = 'active' 
  AND (now() - query_start) > INTERVAL '2 seconds'
  AND pid <> pg_backend_pid();

-- Una vez obtengas el PID de la sesión lenta, ve al script 99 para cancelarla.

--AND (now() - query_start) > INTERVAL '2 seconds' esto muestra las consultas mayores a 2 segundos
--AND pid <> pg_backend_pid(); esto muestra todas menos la actual (la que está ejecutando esta consulta)