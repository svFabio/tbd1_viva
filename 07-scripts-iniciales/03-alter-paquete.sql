ALTER TABLE servicios."Paquete" ADD COLUMN megas INT DEFAULT 0;
ALTER TABLE servicios."Paquete" ADD COLUMN minutos INT DEFAULT 0;
ALTER TABLE servicios."Paquete" ADD COLUMN sms INT DEFAULT 0;

-- Eliminar las columnas booleanas temporales que pusimos (si existen)
ALTER TABLE servicios."Paquete" DROP COLUMN IF EXISTS whatsapp_ilimitado;
ALTER TABLE servicios."Paquete" DROP COLUMN IF EXISTS redes_sociales;

-- Actualizar los paquetes existentes
UPDATE servicios."Paquete" SET megas = 500 WHERE id_paquete = 1;
UPDATE servicios."Paquete" SET megas = 1024 WHERE id_paquete = 2;
UPDATE servicios."Paquete" SET megas = 2048 WHERE id_paquete = 3;
UPDATE servicios."Paquete" SET megas = 5120 WHERE id_paquete = 4;
UPDATE servicios."Paquete" SET minutos = 60 WHERE id_paquete = 7;
UPDATE servicios."Paquete" SET sms = 100 WHERE id_paquete = 8;
UPDATE servicios."Paquete" SET minutos = 30 WHERE id_paquete = 10;
UPDATE servicios."Paquete" SET megas = 10240 WHERE id_paquete = 13;

-- Insertar las aplicaciones exentas directamente en tu tabla relacional
INSERT INTO servicios."App_Exenta_En_Bolsa" (id_paquete, nombre_app) VALUES (5, 'WhatsApp');
INSERT INTO servicios."App_Exenta_En_Bolsa" (id_paquete, nombre_app) VALUES (6, 'WhatsApp');
INSERT INTO servicios."App_Exenta_En_Bolsa" (id_paquete, nombre_app) VALUES (6, 'Facebook');
INSERT INTO servicios."App_Exenta_En_Bolsa" (id_paquete, nombre_app) VALUES (6, 'Instagram');
INSERT INTO servicios."App_Exenta_En_Bolsa" (id_paquete, nombre_app) VALUES (9, 'TikTok');
INSERT INTO servicios."App_Exenta_En_Bolsa" (id_paquete, nombre_app) VALUES (11, 'Netflix');
INSERT INTO servicios."App_Exenta_En_Bolsa" (id_paquete, nombre_app) VALUES (11, 'YouTube');
