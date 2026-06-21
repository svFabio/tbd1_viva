-- 1. PLANTILLAS BASE (Roles genéricos que agrupan los permisos)
CREATE ROLE rol_app          NOLOGIN NOINHERIT;
CREATE ROLE rol_admin_promo  NOLOGIN NOINHERIT;
CREATE ROLE rol_auditor      NOLOGIN NOINHERIT BYPASSRLS;
CREATE ROLE rol_reporte      NOLOGIN NOINHERIT;
CREATE ROLE rol_finanzas     NOLOGIN NOINHERIT;

-- 2. USUARIOS (Personas reales y aplicaciones)
-- La app se queda genérica porque es un sistema automatizado, no un humano
CREATE USER u_app              WITH PASSWORD 'app123'      INHERIT IN ROLE rol_app;

-- Usuarios humanos con nombres reales usando guiones bajos
CREATE USER u_rebeca_jones     WITH PASSWORD 'reporte123'  VALID UNTIL '2026-12-31' INHERIT IN ROLE rol_reporte;
CREATE USER u_adan_pereira     WITH PASSWORD 'promo123'    VALID UNTIL '2026-12-31' INHERIT IN ROLE rol_admin_promo;
CREATE USER u_aurelio_casillas WITH PASSWORD 'auditor123'  VALID UNTIL '2026-12-31' BYPASSRLS INHERIT IN ROLE rol_auditor;
CREATE USER u_finn_almanza     WITH PASSWORD 'finanzas123' VALID UNTIL '2026-09-15' INHERIT IN ROLE rol_finanzas;

-- =============================================================
-- 3. USUARIO DE SERVICIO PARA EL MICROSERVICIO DE ADMIN (Seguridad)
-- =============================================================
-- Este usuario NO hereda permisos automáticos y no es superusuario.
-- Su único poder es poder hacer "SET ROLE" hacia los roles administrativos.
CREATE USER u_admin_web WITH PASSWORD 'AdminWeb!2026' NOINHERIT;

GRANT rol_admin_promo TO u_admin_web;
GRANT rol_auditor TO u_admin_web;
GRANT rol_reporte TO u_admin_web;
GRANT rol_finanzas TO u_admin_web;

-- Permiso indispensable para que Laravel pueda hacer el Login (Auth::attempt)
GRANT USAGE ON SCHEMA seguridad TO u_admin_web;
GRANT SELECT ON seguridad."Usuario_Sistema" TO u_admin_web;
