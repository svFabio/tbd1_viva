
-- ── 1. INSERT ────────────────────────────────────────────────
INSERT INTO clientes."Cliente" (fecha_registro, estado)
VALUES (CURRENT_DATE, 'Activo');


-- ── 2. UPDATE ────────────────────────────────────────────────
-- Toma automáticamente el último cliente insertado
UPDATE clientes."Cliente"
SET    estado = 'Suspendido'
WHERE  id_cliente = (SELECT MAX(id_cliente) FROM clientes."Cliente");


-- ── 3. DELETE ────────────────────────────────────────────────
DELETE FROM clientes."Cliente"
WHERE  id_cliente = (SELECT MAX(id_cliente) FROM clientes."Cliente");


