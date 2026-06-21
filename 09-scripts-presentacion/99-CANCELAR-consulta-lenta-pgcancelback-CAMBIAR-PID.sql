-- =====================================================================
-- PASO 3 (TERMINAL 2): CANCELAR LA CONSULTA LENTA COMO DBA
-- =====================================================================

-- pg_cancel_backend() envía una señal SUAVE a la consulta.
-- Solo cancela la consulta en ejecución, la sesión del usuario NO muere.
-- El usuario puede seguir conectado y lanzar nuevas consultas.
-- (A diferencia de pg_terminate_backend() que mata la sesión completa)

-- Reemplaza el número por el PID que te devolvió el script 17.
SELECT pg_cancel_backend(1234); -- ⚠️ CAMBIAR POR EL PID REAL
