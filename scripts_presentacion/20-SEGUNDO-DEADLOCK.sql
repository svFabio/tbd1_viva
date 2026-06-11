-- =====================================================================
-- FILA 6: SIMULACIÓN DE ESCENARIO DE CONCURRENCIA / LOCKS
-- =====================================================================

-- Ejecuta la actualización que se quedará congelada esperando a la Laptop A
UPDATE finanzas."Factura" SET estado_pago = 'Pagado' WHERE id_factura = 21;
