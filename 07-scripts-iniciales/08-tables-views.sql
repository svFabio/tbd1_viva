-- ==============================================================================
-- SCRIPT: 12-crear-vista-segura.sql
-- OBJETIVO: Implementar una Vista Segura aplicando el Principio de Mínimo Privilegio.
--           Se oculta PII (Datos Personales).
-- ==============================================================================

-- 1. Creamos la vista en el esquema comercial filtrando solo lo que marketing necesita
CREATE OR REPLACE VIEW comercial.vista_lineas_marketing AS
SELECT 
    numero_telefono, 
    estado
FROM lineas."Linea"
WHERE estado = 'Activo';

-- 2. Le damos permiso EXCLUSIVO de lectura al rol de promociones
GRANT SELECT ON comercial.vista_lineas_marketing TO rol_admin_promo;

-- ==============================================================================
-- SCRIPT: 13-crear-vista-normal.sql
-- OBJETIVO: Crear una vista de utilidad (Reporte) para simplificar consultas complejas.
--           No tiene fines de ocultamiento, sino de eficiencia operativa.
-- ==============================================================================

-- 1. Creamos la vista cruzando Finanzas y Líneas
CREATE OR REPLACE VIEW finanzas.vista_reporte_facturacion AS
SELECT 
    f.id_factura,
    l.numero_telefono,
    f.monto_total,
    f.estado_pago
FROM finanzas."Factura" f
INNER JOIN lineas."Linea" l ON f.id_linea = l.id_linea;

-- 2. Le damos permiso al rol de finanzas (o al que necesites que vea los reportes)
GRANT SELECT ON finanzas.vista_reporte_facturacion TO rol_app; 
-- (Puedes cambiar 'rol_app' por un rol de auditoría si lo tienes)
