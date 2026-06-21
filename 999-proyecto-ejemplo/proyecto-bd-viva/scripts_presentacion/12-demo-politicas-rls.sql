-- ==============================================================================
-- DEMOSTRACIÓN EN VIVO DE LA POLÍTICA RLS
-- ==============================================================================

-- 1. Nos ponemos la máscara de la aplicación
SET ROLE rol_app;

-- ==========================================
-- PRUEBA 1: ATAQUE / ERROR DEL BACKEND
-- ==========================================
-- Hacemos un SELECT a la tabla sin identificarnos.
-- (Aquí el NULLIF hace su magia y el guardia te bloquea).
-- RESULTADO: 0 rows
SELECT * FROM finanzas."Factura";

-- ==========================================
-- PRUEBA 2: ACCESO LEGÍTIMO
-- ==========================================
-- Le decimos a la base de datos que somos el cliente con la línea 2.
-- SET app.current_linea_id = '2';
SET ROLE rol_auditor;
-- Volvemos a hacer exactamente el mismo SELECT.
-- (El guardia revisa la llave y te deja pasar).
-- RESULTADO: Solo las facturas de la línea 2.
SELECT * FROM finanzas."Factura";

-- 3. Limpiamos las credenciales para volver a ser administrador
RESET ALL;
RESET ROLE;
