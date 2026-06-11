-- Top 5 de las consultas más pesadas del sistema
SELECT 
    substring(query, 1, 60) AS consulta,
    calls AS veces_ejecutada,
    round(total_exec_time::numeric, 2) AS tiempo_total_ms,
    round((total_exec_time / calls)::numeric, 2) AS tiempo_promedio_ms
FROM pg_stat_statements
ORDER BY total_exec_time DESC
LIMIT 5;
