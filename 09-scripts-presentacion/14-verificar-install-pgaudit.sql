
-- 1. Instalar la extensión en la base de datos(ya esta)
--CREATE EXTENSION IF NOT EXISTS pgaudit;


SELECT extname, extversion 
FROM pg_extension 
WHERE extname = 'pgaudit';
