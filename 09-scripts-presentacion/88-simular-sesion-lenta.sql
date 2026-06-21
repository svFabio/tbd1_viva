-- =====================================================================
-- PASO 1 (TERMINAL 1): SIMULAR UNA SESIÓN LENTA
-- =====================================================================

-- Esta consulta simula un reporte o proceso pesado que tarda 2 minutos.
-- A diferencia de un bloqueo, esta sesión SÍ está activa/ejecutándose,
-- simplemente tarda mucho. No está esperando a nadie.
-- Ejecutar desde CUALQUIER usuario (ej: postgres, u_app, etc.)
SELECT pg_sleep(120); -- simula 2 minutos de ejecución

-- Mientras esta terminal corra, ir a la Terminal 2 y ejecutar el script 17.
