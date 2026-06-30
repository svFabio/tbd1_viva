-- =============================================================
-- SCRIPT 13 — PATRÓN ACTIVO/INACTIVO EN PAQUETE
--             + REVOCACIÓN DE DELETE POR ROL
-- =============================================================
-- Principio: en sistemas reales no se eliminan registros,
-- se desactivan. Esto preserva:
--   - Integridad referencial (Bolsa_Activa apunta a Paquete)
--   - Historial (el cliente que compró el paquete sigue teniéndolo)
--   - Auditoría (se puede ver qué paquetes existieron)
-- =============================================================

ALTER EVENT TRIGGER trg_audit_ddl DISABLE;

-- ─────────────────────────────────────────────────────────────
-- 1. Agregar columna activo a servicios."Paquete"
-- ─────────────────────────────────────────────────────────────
ALTER TABLE servicios."Paquete"
    ADD COLUMN IF NOT EXISTS activo boolean NOT NULL DEFAULT true;

COMMENT ON COLUMN servicios."Paquete".activo IS
    'false = paquete dado de baja lógicamente. No se elimina para preservar historial.';

-- ─────────────────────────────────────────────────────────────
-- 2. REVOCAR DELETE a roles que no deben borrar registros
-- ─────────────────────────────────────────────────────────────

-- rol_comercial: gestiona paquetes pero NO puede borrarlos físicamente
-- (usa UPDATE activo=false en su lugar)
REVOKE DELETE ON servicios."Paquete" FROM rol_comercial;
REVOKE DELETE ON servicios."App_Exenta_En_Bolsa" FROM rol_comercial;

-- Aclaración: App_Exenta_En_Bolsa sí se puede "eliminar" cuando se
-- edita un paquete (quitar una app del repeater). Eso es una edición
-- del paquete, no una baja lógica de una entidad principal.
-- Se mantiene el DELETE sobre App_Exenta_En_Bolsa para el repeater.
GRANT DELETE ON servicios."App_Exenta_En_Bolsa" TO rol_comercial;

-- rol_finanzas: nunca debe borrar registros financieros
-- (facturas, recargas, transacciones son inmutables por ley)
REVOKE DELETE ON finanzas."Factura"      FROM rol_finanzas;
REVOKE DELETE ON finanzas."Recarga"      FROM rol_finanzas;
REVOKE DELETE ON finanzas."Transaccion"  FROM rol_finanzas;
REVOKE DELETE ON finanzas."Transfuzion"  FROM rol_finanzas;
REVOKE DELETE ON finanzas."T_Presta"     FROM rol_finanzas;

-- ─────────────────────────────────────────────────────────────
-- 3. Vista opcional: solo paquetes activos (para uso futuro)
-- ─────────────────────────────────────────────────────────────
CREATE OR REPLACE VIEW servicios."Paquete_Activo" AS
    SELECT * FROM servicios."Paquete" WHERE activo = true;

GRANT SELECT ON servicios."Paquete_Activo" TO rol_comercial, rol_app, rol_reporte;

ALTER EVENT TRIGGER trg_audit_ddl ENABLE;
