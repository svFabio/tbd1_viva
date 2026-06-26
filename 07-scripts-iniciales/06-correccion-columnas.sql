ALTER EVENT TRIGGER trg_audit_ddl DISABLE;

-- 1. Le quitamos el poder absoluto de actualizar toda la tabla
REVOKE UPDATE ON finanzas."Bolsillo" FROM rol_app;

-- 2. Le damos permiso quirúrgico (solo a las columnas que sí debe cambiar)
GRANT UPDATE (saldo_dinero, saldo_megas, saldo_minutos, saldo_sms) ON finanzas."Bolsillo" TO rol_app;

ALTER EVENT TRIGGER trg_audit_ddl ENABLE;
