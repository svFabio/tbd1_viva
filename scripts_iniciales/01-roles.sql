-- 1. PLANTILLAS BASE (Roles genéricos que agrupan los permisos)
CREATE ROLE rol_app          NOLOGIN NOINHERIT;
CREATE ROLE rol_admin_promo  NOLOGIN NOINHERIT;
CREATE ROLE rol_auditor      NOLOGIN NOINHERIT;
CREATE ROLE rol_reporte      NOLOGIN NOINHERIT;

-- 2. USUARIOS (Personas reales y aplicaciones)
-- La app se queda genérica porque es un sistema automatizado, no un humano
CREATE USER u_app              WITH PASSWORD 'app123'      INHERIT IN ROLE rol_app;

-- Usuarios humanos con nombres reales usando guiones bajos
CREATE USER u_rebeca_jones     WITH PASSWORD 'reporte123'  VALID UNTIL '2026-12-31' INHERIT IN ROLE rol_reporte;
CREATE USER u_adan_pereira     WITH PASSWORD 'promo123'    VALID UNTIL '2026-12-31' INHERIT IN ROLE rol_admin_promo;
CREATE USER u_aurelio_casillas WITH PASSWORD 'auditor123'  VALID UNTIL '2026-12-31' INHERIT IN ROLE rol_auditor;
