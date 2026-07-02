-- =============================================================
-- SCRIPT 04 — PERMISOS FINALES (EXPLÍCITOS)
-- =============================================================

ALTER EVENT TRIGGER trg_audit_ddl DISABLE;

-- =============================================================
-- 1. ROL: rol_comercial
-- =============================================================
GRANT USAGE ON SCHEMA comercial, fidelizacion, clientes, servicios, lineas TO rol_comercial;

-- comercial (CRUD completo)
GRANT SELECT, INSERT, UPDATE, DELETE ON comercial."Promocion" TO rol_comercial;
GRANT SELECT, INSERT, UPDATE, DELETE ON comercial."Condicion_Promocion" TO rol_comercial;
GRANT SELECT, INSERT, UPDATE, DELETE ON comercial."Numero_Amigo" TO rol_comercial;
GRANT SELECT, INSERT, UPDATE, DELETE ON comercial."Promocion_Linea" TO rol_comercial;

-- fidelizacion
GRANT SELECT, INSERT, UPDATE, DELETE ON fidelizacion."Condicion_Puntos" TO rol_comercial;
GRANT SELECT ON fidelizacion."Historial_Puntos" TO rol_comercial;
GRANT SELECT ON fidelizacion."Puntos_Bonus" TO rol_comercial;

-- clientes
GRANT SELECT ON clientes."Cliente" TO rol_comercial;

-- servicios
GRANT SELECT, INSERT, UPDATE, DELETE ON servicios."Paquete" TO rol_comercial;
GRANT SELECT, INSERT, UPDATE, DELETE ON servicios."App_Exenta_En_Bolsa" TO rol_comercial;

-- lineas
GRANT SELECT ON lineas."Linea" TO rol_comercial;
GRANT SELECT ON lineas."Plan" TO rol_comercial;

GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA comercial, fidelizacion, servicios TO rol_comercial;

-- =============================================================
-- 2. ROL: rol_app
-- =============================================================
GRANT USAGE ON SCHEMA clientes, lineas, finanzas, servicios, comercial, fidelizacion, seguridad TO rol_app;

-- clientes
GRANT SELECT, INSERT, UPDATE ON clientes."Cliente" TO rol_app;
GRANT SELECT, INSERT, UPDATE ON clientes."Empresa" TO rol_app;
GRANT SELECT, INSERT, UPDATE ON clientes."Persona_Natural" TO rol_app;

-- lineas
GRANT SELECT ON lineas."Linea" TO rol_app;
GRANT SELECT ON lineas."Plan" TO rol_app;
GRANT SELECT ON lineas."SIM_Card" TO rol_app;

-- finanzas
GRANT SELECT, UPDATE ON finanzas."Bolsillo" TO rol_app;
GRANT SELECT ON finanzas."Factura" TO rol_app;
GRANT SELECT ON finanzas."Tarjeta_Recarga" TO rol_app;
GRANT SELECT, INSERT ON finanzas."Recarga" TO rol_app;
GRANT SELECT, INSERT ON finanzas."T_Presta" TO rol_app;
GRANT SELECT, INSERT ON finanzas."Transaccion" TO rol_app;
GRANT SELECT, INSERT ON finanzas."Transfuzion" TO rol_app;

-- servicios
GRANT SELECT ON servicios."Paquete" TO rol_app;
GRANT SELECT ON servicios."App_Exenta_En_Bolsa" TO rol_app;
GRANT SELECT, INSERT ON servicios."Bolsa_Activa" TO rol_app;
GRANT SELECT, INSERT ON servicios."Consumo" TO rol_app;

-- comercial
GRANT SELECT, INSERT, DELETE ON comercial."Numero_Amigo" TO rol_app;
GRANT SELECT ON comercial."Promocion_Linea" TO rol_app;
GRANT SELECT ON comercial."Promocion" TO rol_app;

-- fidelizacion
GRANT SELECT ON fidelizacion."Historial_Puntos" TO rol_app;
GRANT SELECT ON fidelizacion."Puntos_Bonus" TO rol_app;

-- seguridad
GRANT INSERT, UPDATE ON seguridad."Usuario_Sistema" TO rol_app;

GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA clientes, finanzas, servicios, comercial, seguridad TO rol_app;

-- =============================================================
-- 3. ROL: rol_auditor
-- =============================================================
GRANT USAGE ON SCHEMA seguridad, fidelizacion, finanzas, lineas, clientes, comercial, servicios TO rol_auditor;

-- seguridad
GRANT SELECT, INSERT ON seguridad."Auditoria" TO rol_auditor;
GRANT SELECT ON seguridad."Usuario_Sistema" TO rol_auditor;

-- fidelizacion
GRANT SELECT ON fidelizacion."Condicion_Puntos" TO rol_auditor;
GRANT SELECT ON fidelizacion."Historial_Puntos" TO rol_auditor;
GRANT SELECT ON fidelizacion."Puntos_Bonus" TO rol_auditor;

-- finanzas
GRANT SELECT ON finanzas."Bolsillo" TO rol_auditor;
GRANT SELECT ON finanzas."Factura" TO rol_auditor;
GRANT SELECT ON finanzas."Recarga" TO rol_auditor;
GRANT SELECT ON finanzas."T_Presta" TO rol_auditor;
GRANT SELECT ON finanzas."Transaccion" TO rol_auditor;
GRANT SELECT ON finanzas."Transfuzion" TO rol_auditor;

-- lineas
GRANT SELECT ON lineas."Linea" TO rol_auditor;
GRANT SELECT ON lineas."Historial_Linea_Equipo" TO rol_auditor;

-- clientes
GRANT SELECT ON clientes."Cliente" TO rol_auditor;

-- comercial
GRANT SELECT ON comercial."Promocion_Linea" TO rol_auditor;

-- servicios
GRANT SELECT ON servicios."Consumo" TO rol_auditor;

GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA seguridad TO rol_auditor;

-- =============================================================
-- 4. ROL: rol_reporte
-- =============================================================
GRANT USAGE ON SCHEMA clientes, comercial, fidelizacion, finanzas, lineas, servicios TO rol_reporte;

-- clientes
GRANT SELECT ON clientes."Cliente" TO rol_reporte;
GRANT SELECT ON clientes."Empresa" TO rol_reporte;
GRANT SELECT ON clientes."Persona_Natural" TO rol_reporte;

-- comercial
GRANT SELECT ON comercial."Promocion" TO rol_reporte;
GRANT SELECT ON comercial."Condicion_Promocion" TO rol_reporte;
GRANT SELECT ON comercial."Promocion_Linea" TO rol_reporte;

-- fidelizacion
GRANT SELECT ON fidelizacion."Condicion_Puntos" TO rol_reporte;
GRANT SELECT ON fidelizacion."Historial_Puntos" TO rol_reporte;
GRANT SELECT ON fidelizacion."Puntos_Bonus" TO rol_reporte;

-- finanzas
GRANT SELECT ON finanzas."Bolsillo" TO rol_reporte;
GRANT SELECT ON finanzas."Factura" TO rol_reporte;
GRANT SELECT ON finanzas."Recarga" TO rol_reporte;
GRANT SELECT ON finanzas."T_Presta" TO rol_reporte;
GRANT SELECT ON finanzas."Transaccion" TO rol_reporte;
GRANT SELECT ON finanzas."Transfuzion" TO rol_reporte;

-- lineas
GRANT SELECT ON lineas."Equipo" TO rol_reporte;
GRANT SELECT ON lineas."Plan" TO rol_reporte;
GRANT SELECT ON lineas."SIM_Card" TO rol_reporte;
GRANT SELECT ON lineas."Linea" TO rol_reporte;
GRANT SELECT ON lineas."Historial_Linea_Equipo" TO rol_reporte;
GRANT SELECT ON lineas."Linea_Postpago" TO rol_reporte;

-- servicios
GRANT SELECT ON servicios."Paquete" TO rol_reporte;
GRANT SELECT ON servicios."App_Exenta_En_Bolsa" TO rol_reporte;
GRANT SELECT ON servicios."Bolsa_Activa" TO rol_reporte;
GRANT SELECT ON servicios."Consumo" TO rol_reporte;

-- =============================================================
-- 5. ROL: rol_finanzas
-- =============================================================
GRANT USAGE ON SCHEMA finanzas, clientes, lineas TO rol_finanzas;

-- finanzas (CRUD completo)
GRANT SELECT, INSERT, UPDATE, DELETE ON finanzas."Bolsillo" TO rol_finanzas;
GRANT SELECT, INSERT, UPDATE, DELETE ON finanzas."Factura" TO rol_finanzas;
GRANT SELECT, INSERT, UPDATE, DELETE ON finanzas."Tarjeta_Recarga" TO rol_finanzas;
GRANT SELECT, INSERT, UPDATE, DELETE ON finanzas."Recarga" TO rol_finanzas;
GRANT SELECT, INSERT, UPDATE, DELETE ON finanzas."T_Presta" TO rol_finanzas;
GRANT SELECT, INSERT, UPDATE, DELETE ON finanzas."Transaccion" TO rol_finanzas;
GRANT SELECT, INSERT, UPDATE, DELETE ON finanzas."Transfuzion" TO rol_finanzas;

-- clientes y lineas
GRANT SELECT ON clientes."Cliente" TO rol_finanzas;
GRANT SELECT ON lineas."Linea" TO rol_finanzas;
GRANT SELECT ON lineas."Plan" TO rol_finanzas;

GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA finanzas TO rol_finanzas;

-- =============================================================
-- 6. ROL: rol_agencia
-- =============================================================
GRANT USAGE ON SCHEMA clientes, lineas TO rol_agencia;

-- clientes (CRUD completo para crear cuentas)
GRANT SELECT, INSERT, UPDATE, DELETE ON clientes."Cliente" TO rol_agencia;
GRANT SELECT, INSERT, UPDATE, DELETE ON clientes."Empresa" TO rol_agencia;
GRANT SELECT, INSERT, UPDATE, DELETE ON clientes."Persona_Natural" TO rol_agencia;

-- lineas (CRUD completo para vender y asignar números/planes)
GRANT SELECT, INSERT, UPDATE, DELETE ON lineas."Linea" TO rol_agencia;
GRANT SELECT, INSERT, UPDATE, DELETE ON lineas."Plan" TO rol_agencia;
GRANT SELECT, INSERT, UPDATE, DELETE ON lineas."SIM_Card" TO rol_agencia;
GRANT SELECT, INSERT, UPDATE, DELETE ON lineas."Equipo" TO rol_agencia;
GRANT SELECT, INSERT, UPDATE, DELETE ON lineas."Linea_Postpago" TO rol_agencia;
GRANT SELECT, INSERT, UPDATE, DELETE ON lineas."Historial_Linea_Equipo" TO rol_agencia;

GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA clientes, lineas TO rol_agencia;

-- seguridad (acceso mínimo para crear el usuario web del nuevo cliente)
-- rol_agencia solo puede: verificar si un username ya existe (SELECT),
-- crear el usuario del cliente recién dado de alta (INSERT),
-- y actualizarlo si el cliente ya tenía cuenta (UPDATE username/password).
-- NO puede ver usuarios de otros roles ni administradores.
GRANT USAGE ON SCHEMA seguridad TO rol_agencia;
GRANT SELECT, INSERT, UPDATE ON seguridad."Usuario_Sistema" TO rol_agencia;
GRANT USAGE, SELECT ON SEQUENCE seguridad."Usuario_Sistema_id_usuario_seq" TO rol_agencia;

-- finanzas (para crear el Bolsillo al dar de alta la línea)
GRANT USAGE ON SCHEMA finanzas TO rol_agencia;
GRANT INSERT ON finanzas."Bolsillo" TO rol_agencia;
GRANT USAGE, SELECT ON SEQUENCE finanzas."Bolsillo_id_bolsillo_seq" TO rol_agencia;

-- =============================================================
-- ROL: u_admin_web
-- =============================================================
GRANT USAGE ON SCHEMA seguridad TO u_admin_web;
GRANT SELECT ON seguridad."Usuario_Sistema" TO u_admin_web;
GRANT UPDATE (password_hash) ON seguridad."Usuario_Sistema" TO u_admin_web;

-- Permisos necesarios para el login por celular:
GRANT USAGE ON SCHEMA lineas TO u_admin_web;
GRANT SELECT ON lineas."Linea" TO u_admin_web;

-- Permisos necesarios para el login por correo:
GRANT USAGE ON SCHEMA clientes TO u_admin_web;
GRANT SELECT ON clientes."Persona_Natural" TO u_admin_web;

ALTER EVENT TRIGGER trg_audit_ddl ENABLE;
