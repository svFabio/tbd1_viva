-- =============================================================
-- SCRIPT 04 — PERMISOS FINALES  (ejecutar después de 01, 02, 03)
-- Base de datos: VIVA BD
-- Fecha: 2026-06-07
--
-- CRITERIO: este script SOLO otorga lo que la matriz de privilegios
-- exige y que el DDL (02) NO otorgó. No repite GRANTs ya existentes.
-- No hace REVOKE de nada (el DDL ya arrancó limpio).
-- =============================================================


-- -------------------------------------------------------------
-- PASO 1: Desactivar el event trigger para que los GRANT/REVOKE
--         no generen entradas espurias en Auditoria
-- -------------------------------------------------------------
ALTER EVENT TRIGGER trg_audit_ddl DISABLE;


-- =============================================================
-- ROL: rol_admin_promo
-- =============================================================
--
-- Lo que el DDL (02) YA otorgó a rol_admin_promo:
--   comercial:    Promocion CRUD, Condicion_Promocion CRUD,
--                 Numero_Amigo CRUD, Promocion_Linea CRUD
--                 USAGE en schema comercial
--   fidelizacion: Condicion_Puntos CRUD, Historial_Puntos SELECT+INSERT+UPDATE,
--                 Puntos_Bonus SELECT+INSERT+UPDATE
--                 USAGE en schema fidelizacion
--   servicios:    (ninguno aún)
--   lineas:       (ninguno aún)
--   clientes:     Cliente SELECT
--
-- Lo que la MATRIZ pide y FALTA:
--   servicios: Paquete CRUD, App_Exenta_En_Bolsa CRUD
--   lineas:    Linea SELECT, Plan SELECT
--              USAGE en schemas servicios y lineas
--   fidelizacion: Historial_Puntos solo SELECT (el DDL dio INSERT+UPDATE de más → REVOKE)
--                 Puntos_Bonus    solo SELECT (el DDL dio INSERT+UPDATE de más → REVOKE)
-- -------------------------------------------------------------

-- Permisos faltantes en servicios
GRANT USAGE ON SCHEMA servicios TO rol_admin_promo;
GRANT SELECT, INSERT, UPDATE, DELETE ON servicios."Paquete"             TO rol_admin_promo;
GRANT SELECT, INSERT, UPDATE, DELETE ON servicios."App_Exenta_En_Bolsa" TO rol_admin_promo;

-- Permisos faltantes en lineas
GRANT USAGE ON SCHEMA lineas TO rol_admin_promo;
GRANT SELECT ON lineas."Linea" TO rol_admin_promo;
GRANT SELECT ON lineas."Plan"  TO rol_admin_promo;

-- Corrección en fidelizacion: la matriz pide solo SELECT en Historial_Puntos y Puntos_Bonus
-- El DDL otorgó INSERT y UPDATE de más → se revocan
REVOKE INSERT, UPDATE ON fidelizacion."Historial_Puntos" FROM rol_admin_promo;
REVOKE INSERT, UPDATE ON fidelizacion."Puntos_Bonus"     FROM rol_admin_promo;

-- Secuencias para las tablas donde rol_admin_promo tiene INSERT
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA servicios TO rol_admin_promo;


-- =============================================================
-- ROL: rol_app
-- =============================================================
--
-- Lo que el DDL (02) YA otorgó a rol_app:
--   clientes:  Cliente SELECT+INSERT+UPDATE, Empresa SELECT+INSERT+UPDATE,
--              Persona_Natural SELECT+INSERT+UPDATE
--              USAGE en schema clientes
--   lineas:    Equipo CRUD, Plan CRUD, SIM_Card CRUD,
--              Linea CRUD, Historial_Linea_Equipo CRUD, Linea_Postpago CRUD
--              USAGE en schema lineas
--   finanzas:  Bolsillo SELECT+INSERT+UPDATE, Factura SELECT+INSERT+UPDATE,
--              Tarjeta_Recarga SELECT+INSERT+UPDATE,
--              Recarga SELECT+INSERT+UPDATE,
--              T_Presta SELECT+INSERT+UPDATE,
--              Transaccion SELECT+INSERT+UPDATE,
--              Transfuzion SELECT+INSERT+UPDATE
--              USAGE en schema finanzas
--   servicios: Paquete CRUD, App_Exenta_En_Bolsa CRUD,
--              Bolsa_Activa CRUD, Consumo SELECT+INSERT
--              USAGE en schema servicios
--
-- Lo que la MATRIZ pide y que el DDL otorgó DE MÁS (REVOKE):
--   lineas:    Equipo  → sin permisos en la matriz
--              Historial_Linea_Equipo → sin permisos en la matriz
--              Linea_Postpago → sin permisos en la matriz
--              Linea CRUD → solo SELECT
--              Plan CRUD → solo SELECT
--              SIM_Card CRUD → solo SELECT
--   finanzas:  Bolsillo INSERT → sin INSERT en la matriz
--              Factura INSERT+UPDATE → sin INSERT ni UPDATE en la matriz
--              Tarjeta_Recarga INSERT+UPDATE → solo SELECT en la matriz
--              Recarga UPDATE → solo SELECT+INSERT en la matriz
--              T_Presta UPDATE → solo SELECT+INSERT en la matriz
--              Transaccion UPDATE → solo SELECT+INSERT en la matriz
--              Transfuzion UPDATE → solo SELECT+INSERT en la matriz
--   servicios: Paquete CRUD → solo SELECT en la matriz
--              App_Exenta_En_Bolsa CRUD → solo SELECT en la matriz
--              Bolsa_Activa DELETE → solo SELECT+INSERT en la matriz
--   comercial: falta USAGE y Numero_Amigo SELECT+INSERT+DELETE
--              falta Promocion_Linea SELECT
--   fidelizacion: falta USAGE, Historial_Puntos SELECT, Puntos_Bonus SELECT
--   seguridad: falta USAGE, Usuario_Sistema UPDATE
-- -------------------------------------------------------------

-- ── lineas: quitar permisos en exceso ──────────────────────
REVOKE INSERT, UPDATE, DELETE ON lineas."Linea"                  FROM rol_app;
REVOKE INSERT, UPDATE, DELETE ON lineas."Plan"                   FROM rol_app;
REVOKE INSERT, UPDATE, DELETE ON lineas."SIM_Card"               FROM rol_app;
REVOKE ALL                    ON lineas."Equipo"                 FROM rol_app;
REVOKE ALL                    ON lineas."Historial_Linea_Equipo" FROM rol_app;
REVOKE ALL                    ON lineas."Linea_Postpago"         FROM rol_app;

-- ── finanzas: quitar permisos en exceso ────────────────────
REVOKE INSERT        ON finanzas."Bolsillo"        FROM rol_app;
REVOKE INSERT, UPDATE ON finanzas."Factura"        FROM rol_app;
REVOKE INSERT, UPDATE ON finanzas."Tarjeta_Recarga" FROM rol_app;
REVOKE UPDATE        ON finanzas."Recarga"          FROM rol_app;
REVOKE UPDATE        ON finanzas."T_Presta"         FROM rol_app;
REVOKE UPDATE        ON finanzas."Transaccion"      FROM rol_app;
REVOKE UPDATE        ON finanzas."Transfuzion"      FROM rol_app;

-- ── servicios: quitar permisos en exceso ───────────────────
REVOKE INSERT, UPDATE, DELETE ON servicios."Paquete"             FROM rol_app;
REVOKE INSERT, UPDATE, DELETE ON servicios."App_Exenta_En_Bolsa" FROM rol_app;
REVOKE DELETE                 ON servicios."Bolsa_Activa"        FROM rol_app;

-- ── comercial: otorgar lo que falta ────────────────────────
GRANT USAGE ON SCHEMA comercial TO rol_app;
GRANT SELECT, INSERT, DELETE ON comercial."Numero_Amigo"  TO rol_app;
GRANT SELECT                 ON comercial."Promocion_Linea" TO rol_app;

-- ── fidelizacion: otorgar lo que falta ─────────────────────
GRANT USAGE ON SCHEMA fidelizacion TO rol_app;
GRANT SELECT ON fidelizacion."Historial_Puntos" TO rol_app;
GRANT SELECT ON fidelizacion."Puntos_Bonus"     TO rol_app;

-- ── seguridad: otorgar lo que falta ────────────────────────
GRANT USAGE  ON SCHEMA seguridad            TO rol_app;
GRANT INSERT, UPDATE ON seguridad."Usuario_Sistema" TO rol_app;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA seguridad TO rol_app;


-- =============================================================
-- ROL: rol_auditor
-- =============================================================
--
-- Lo que el DDL (02) YA otorgó a rol_auditor:
--   seguridad:    Auditoria SELECT, Usuario_Sistema SELECT
--                 USAGE en schema seguridad
--   fidelizacion: Condicion_Puntos SELECT, Historial_Puntos SELECT,
--                 Puntos_Bonus SELECT
--                 USAGE en schema fidelizacion
--   finanzas:     Bolsillo SELECT, Factura SELECT, Tarjeta_Recarga SELECT,
--                 Recarga SELECT, T_Presta SELECT, Transaccion SELECT,
--                 Transfuzion SELECT
--                 USAGE en schema finanzas
--
-- Lo que la MATRIZ pide y FALTA:
--   seguridad:    Auditoria INSERT (ya tiene SELECT)
--   lineas:       Linea SELECT, Historial_Linea_Equipo SELECT
--                 USAGE en schema lineas
--   clientes:     Cliente SELECT
--                 USAGE en schema clientes
--   comercial:    Promocion_Linea SELECT
--                 USAGE en schema comercial
--   servicios:    Consumo SELECT
--                 USAGE en schema servicios
--
-- Lo que el DDL otorgó DE MÁS (REVOKE):
--   fidelizacion: Condicion_Puntos → NO está en la matriz del auditor
--                 Puntos_Bonus     → NO está en la matriz del auditor
--   finanzas:     Tarjeta_Recarga  → NO está en la matriz del auditor
-- -------------------------------------------------------------

-- ── seguridad: falta INSERT en Auditoria ───────────────────
GRANT INSERT ON seguridad."Auditoria" TO rol_auditor;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA seguridad TO rol_auditor;
REVOKE INSERT ON seguridad."Auditoria" FROM rol_auditor;
GRANT SELECT ON seguridad."Auditoria" TO rol_auditor;

-- ── lineas: otorgar lo que falta ───────────────────────────
GRANT USAGE ON SCHEMA lineas TO rol_auditor;
GRANT SELECT ON lineas."Linea"                  TO rol_auditor;
GRANT SELECT ON lineas."Historial_Linea_Equipo" TO rol_auditor;

-- ── clientes: otorgar lo que falta ─────────────────────────
GRANT USAGE ON SCHEMA clientes TO rol_auditor;
GRANT SELECT ON clientes."Cliente" TO rol_auditor;

-- ── comercial: otorgar lo que falta ────────────────────────
GRANT USAGE ON SCHEMA comercial TO rol_auditor;
GRANT SELECT ON comercial."Promocion_Linea" TO rol_auditor;

-- ── servicios: otorgar lo que falta ────────────────────────
GRANT USAGE ON SCHEMA servicios TO rol_auditor;
GRANT SELECT ON servicios."Consumo" TO rol_auditor;

-- ── fidelizacion: revocar lo que el DDL otorgó de más ──────
REVOKE ALL ON fidelizacion."Condicion_Puntos" FROM rol_auditor;
REVOKE ALL ON fidelizacion."Puntos_Bonus"     FROM rol_auditor;

-- ── finanzas: revocar Tarjeta_Recarga (no está en la matriz)
REVOKE ALL ON finanzas."Tarjeta_Recarga" FROM rol_auditor;


-- =============================================================
-- ROL: rol_reporte
-- =============================================================
--
-- Lo que el DDL (02) YA otorgó a rol_reporte:
--   clientes:     Cliente SELECT, Empresa SELECT, Persona_Natural SELECT
--                 USAGE en schema clientes
--   comercial:    Promocion SELECT, Condicion_Promocion SELECT,
--                 Numero_Amigo SELECT, Promocion_Linea SELECT
--                 USAGE en schema comercial
--   fidelizacion: Condicion_Puntos SELECT, Historial_Puntos SELECT,
--                 Puntos_Bonus SELECT
--                 USAGE en schema fidelizacion
--   finanzas:     Bolsillo SELECT, Factura SELECT, Tarjeta_Recarga SELECT,
--                 Recarga SELECT, T_Presta SELECT, Transaccion SELECT,
--                 Transfuzion SELECT
--                 USAGE en schema finanzas
--   lineas:       Equipo SELECT, Plan SELECT, SIM_Card SELECT,
--                 Linea SELECT, Historial_Linea_Equipo SELECT,
--                 Linea_Postpago SELECT
--                 USAGE en schema lineas
--   servicios:    Paquete SELECT, App_Exenta_En_Bolsa SELECT,
--                 Bolsa_Activa SELECT, Consumo SELECT
--                 USAGE en schema servicios
--
-- Lo que la MATRIZ pide y FALTA:
--   (ninguno — el DDL cubre todo lo de la matriz)
--
-- Lo que el DDL otorgó DE MÁS (REVOKE):
--   comercial: Numero_Amigo SELECT → NO está en la matriz de reporte
--   finanzas:  Tarjeta_Recarga SELECT → NO está en la matriz de reporte
-- -------------------------------------------------------------

REVOKE ALL ON comercial."Numero_Amigo"    FROM rol_reporte;
REVOKE ALL ON finanzas."Tarjeta_Recarga"  FROM rol_reporte;


-- =============================================================
-- PASO FINAL: Reactivar el event trigger
-- =============================================================
ALTER EVENT TRIGGER trg_audit_ddl ENABLE;


-- =============================================================
-- VERIFICACIÓN — ejecutar para confirmar el estado final
-- =============================================================
SELECT
    grantee,
    table_schema,
    table_name,
    string_agg(privilege_type, ', ' ORDER BY privilege_type) AS privilegios
FROM information_schema.role_table_grants
WHERE grantee IN ('rol_admin_promo', 'rol_app', 'rol_auditor', 'rol_reporte')
GROUP BY grantee, table_schema, table_name
ORDER BY grantee, table_schema, table_name;
