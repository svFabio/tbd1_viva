-- ==============================================================================
-- SCRIPT: 04-correcion-1.sql
-- OBJETIVO: Corregir el problema de herencia ("No inheritance") en los roles.
-- ==============================================================================
-- JUSTIFICACIÓN PARA EL DOCENTE:
-- Por defecto o por una mala creación previa, los roles de grupo estaban 
-- marcados con "No inheritance". Esto significa que si el usuario 'u_adan_pereira'
-- iniciaba sesión, sus permisos estaban en blanco y tenía que ejecutar manualmente
-- el comando "SET ROLE rol_admin_promo;" para poder trabajar.
-- 
-- Al aplicar "INHERIT", logramos que en el momento en que el usuario inicie sesión, 
-- herede y cargue AUTOMÁTICAMENTE todos los privilegios del rol al que pertenece,
-- permitiendo un acceso transparente y directo a sus vistas o tablas permitidas.
-- ==============================================================================

-- 1. Devolverle la capacidad de herencia a los Roles (Grupos)
ALTER ROLE rol_admin_promo INHERIT;
ALTER ROLE rol_app INHERIT;
ALTER ROLE rol_auditor INHERIT;
ALTER ROLE rol_reporte INHERIT;

-- 2. Asegurar preventivamente que los Usuarios (Logins) también la tengan activa
ALTER ROLE u_adan_pereira INHERIT;
ALTER ROLE u_app INHERIT;
ALTER ROLE u_aurelio_casillas INHERIT;
ALTER ROLE u_rebeca_jones INHERIT;

