
-- ── DDL de prueba 1: agregar un comentario a una tabla ──────
COMMENT ON TABLE clientes."Cliente" IS 'Tabla de clientes - prueba de auditoría DDL';


-- ── DDL de prueba 2: crear un índice ─────────────────────────
CREATE INDEX IF NOT EXISTS idx_demo_cliente_estado
    ON clientes."Cliente" (estado);


-- ── DDL de prueba 3: agregar una columna temporal ───────────
ALTER TABLE clientes."Cliente"
    ADD COLUMN IF NOT EXISTS nota_demo VARCHAR(50);


-- ── Limpieza (opcional, deja la BD como estaba) ─────────────
-- DROP INDEX IF EXISTS clientes.idx_demo_cliente_estado;
-- ALTER TABLE clientes."Cliente" DROP COLUMN IF EXISTS nota_demo;
