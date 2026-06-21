-- 1. HACEMOS UN CAMBIO REAL EN LOS DATOS (DML)
-- Cambiamos la factura 21 de 'Pendiente' a 'Pagado'
UPDATE finanzas."Factura" SET estado_pago = 'Pagado' WHERE id_factura = 21;

-- 2. MOSTRAMOS LA AUDITORÍA DML
-- Consultamos el último registro de UPDATE que se guardó
SELECT 
    operacion, 
    tabla_afectada, 
    usuario_db, 
    detalle_cambio
FROM seguridad."Auditoria"
WHERE operacion IN ('INSERT', 'UPDATE', 'DELETE')
ORDER BY id_auditoria DESC
LIMIT 1;

-- 3. REVERTIMOS EL CAMBIO (Para ser profesionales y dejar todo limpio)
UPDATE finanzas."Factura" SET estado_pago = 'Pendiente' WHERE id_factura = 21;
