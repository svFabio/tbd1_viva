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
