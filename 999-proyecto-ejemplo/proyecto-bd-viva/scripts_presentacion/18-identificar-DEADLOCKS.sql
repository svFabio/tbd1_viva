SELECT 
    pid AS victima_pid, 
    usename AS victima_usuario, 
    pg_blocking_pids(pid) AS bloqueado_por_pid, 
    query AS consulta_atascada
FROM pg_stat_activity
WHERE cardinality(pg_blocking_pids(pid)) > 0;
