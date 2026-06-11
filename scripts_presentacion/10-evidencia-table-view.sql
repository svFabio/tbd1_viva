-- ==============================================================================
-- DEMOSTRACIÓN EN VIVO: Consumo de la Vista Segura
-- ==============================================================================

-- Entramos a la base de datos como el usuario de marketing
SET ROLE rol_admin_promo;

-- Extraemos la lista de números listos para la campaña masiva
SELECT * FROM comercial.vista_lineas_marketing LIMIT 10;

-- Regresamos a los permisos de administrador
RESET ROLE;
