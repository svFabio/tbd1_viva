-- =====================================================================
-- PASO 3 (TERMINAL 3): IDENTIFICAR Y MATAR EL BLOQUEO COMO DBA
-- =====================================================================

-- 1. Primero ejecutamos esta consulta para descubrir QUIÉN está bloqueando a quién.
-- Esto revelará el PID de la Terminal 1 (la culpable).
SELECT 
    pid AS victima_pid, 
    usename AS victima_usuario, 
    pg_blocking_pids(pid) AS culpable_pids, 
    query AS consulta_atascada
FROM pg_stat_activity
WHERE cardinality(pg_blocking_pids(pid)) > 0;

-- 2. UNA VEZ OBTENIDO EL PID CULPABLE, EJECUTA LO SIGUIENTE:
-- Reemplaza 'PID_CULPABLE' con el número que te devolvió la consulta anterior en la columna 'culpable_pids'.
-- SELECT pg_terminate_backend(PID_CULPABLE);

-- Resultado: La Terminal 1 morirá, y la Terminal 2 se destrabará instantáneamente.
