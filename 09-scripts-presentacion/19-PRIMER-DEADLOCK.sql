-- =====================================================================
-- PASO 1 (TERMINAL 1): GENERAR EL BLOQUEO (LOCK WAIT)
-- Nota: El archivo se llama DEADLOCK por legado, pero esto demuestra un BLOQUEO.
-- =====================================================================

-- Iniciamos la transacción explícitamente pero NO hacemos COMMIT.
-- Esto simula un programa que se quedó colgado o un usuario que fue a tomar un café
-- dejando la fila de la factura 21 bloqueada indefinidamente.
BEGIN;

UPDATE finanzas."Factura" 
SET estado_pago = 'Pendiente' 
WHERE id_factura = 21;

-- Usamos un SLEEP de 5 MINUTOS para obligar a run.sh a mantener la conexión abierta
-- Si no ponemos esto, run.sh se cierra rápido y Postgres libera el bloqueo.
SELECT pg_sleep(300);

-- ¡NO EJECUTAR COMMIT! Dejar esta terminal abierta.
