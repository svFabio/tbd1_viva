-- 1. Le quitamos el poder absoluto de actualizar toda la tabla
REVOKE UPDATE ON finanzas."Bolsillo" FROM rol_app;

-- 2. Le damos permiso quirúrgico (solo a las columnas que sí debe cambiar)
GRANT UPDATE (saldo_dinero, saldo_megas, saldo_minutos) ON finanzas."Bolsillo" TO rol_app;
