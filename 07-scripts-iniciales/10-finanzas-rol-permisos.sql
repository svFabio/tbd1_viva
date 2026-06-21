-- =============================================================
-- ROL: rol_finanzas
-- Propósito: Personal del área financiera de Viva.
--            Puede consultar y gestionar todos los datos financieros
--            pero NO tiene acceso a datos de clientes ni de líneas.
-- Usuario: u_finn_almanza
-- =============================================================

-- Crear rol y usuario solo si no existen (idempotente, seguro de relanzar)
DO $$
BEGIN
    IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'rol_finanzas') THEN
        CREATE ROLE rol_finanzas NOLOGIN NOINHERIT;
    END IF;

    IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'u_finn_almanza') THEN
        CREATE USER u_finn_almanza
            WITH PASSWORD 'finanzas123'
            VALID UNTIL '2026-09-15'
            INHERIT IN ROLE rol_finanzas;
    END IF;
END
$$;

-- ── finanzas: acceso completo de lectura y escritura operativa ──
GRANT USAGE ON SCHEMA finanzas TO rol_finanzas;

-- Facturas: puede ver y actualizar estado de pago
GRANT SELECT, UPDATE ON finanzas."Factura"        TO rol_finanzas;

-- Recargas y bolsillos: puede ver y registrar movimientos
GRANT SELECT, INSERT ON finanzas."Recarga"         TO rol_finanzas;
GRANT SELECT         ON finanzas."Bolsillo"        TO rol_finanzas;
GRANT SELECT         ON finanzas."Tarjeta_Recarga" TO rol_finanzas;

-- Transacciones y transferencias: solo lectura (registro histórico)
GRANT SELECT ON finanzas."Transaccion"  TO rol_finanzas;
GRANT SELECT ON finanzas."Transfuzion"  TO rol_finanzas;
GRANT SELECT ON finanzas."T_Presta"     TO rol_finanzas;

-- Secuencias necesarias para INSERT
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA finanzas TO rol_finanzas;

-- ── servicios: solo lectura (para contexto de facturación) ─────
GRANT USAGE  ON SCHEMA servicios              TO rol_finanzas;
GRANT SELECT ON servicios."Paquete"           TO rol_finanzas;
GRANT SELECT ON servicios."Bolsa_Activa"      TO rol_finanzas;
GRANT SELECT ON servicios."Consumo"           TO rol_finanzas;
GRANT SELECT ON servicios."App_Exenta_En_Bolsa" TO rol_finanzas;
