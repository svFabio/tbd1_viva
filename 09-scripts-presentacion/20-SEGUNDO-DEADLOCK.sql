-- =====================================================================
-- PASO 2 (TERMINAL 2): SUFRIR EL BLOQUEO (LOCK WAIT)
-- Nota: Ejecutar esto en una SEGUNDA terminal. 
-- =====================================================================

-- Esta consulta intentará actualizar la MISMA factura (21) que la Terminal 1 
-- tiene bloqueada. Como la Terminal 1 no ha hecho COMMIT, esta consulta 
-- se quedará colgada (congelada) indefinidamente esperando su turno.

UPDATE finanzas."Factura" 
SET estado_pago = 'Pagado' 
WHERE id_factura = 21;

-- (La pantalla no avanzará, evidenciando el bloqueo en vivo)
