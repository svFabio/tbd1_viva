BEGIN;
UPDATE finanzas."Factura" SET estado_pago = 'Pendiente' WHERE id_factura = 21;
SELECT pg_sleep(30);
COMMIT;
