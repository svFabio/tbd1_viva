ALTER TABLE servicios."Paquete" ADD COLUMN megas INT DEFAULT 0;
ALTER TABLE servicios."Paquete" ADD COLUMN minutos INT DEFAULT 0;
ALTER TABLE servicios."Paquete" ADD COLUMN sms INT DEFAULT 0;
ALTER TABLE servicios."Paquete" ADD COLUMN whatsapp_ilimitado BOOLEAN DEFAULT FALSE;
ALTER TABLE servicios."Paquete" ADD COLUMN redes_sociales BOOLEAN DEFAULT FALSE;

-- Actualizar los paquetes existentes
UPDATE servicios."Paquete" SET megas = 500 WHERE id_paquete = 1;
UPDATE servicios."Paquete" SET megas = 1024 WHERE id_paquete = 2;
UPDATE servicios."Paquete" SET megas = 2048 WHERE id_paquete = 3;
UPDATE servicios."Paquete" SET megas = 5120 WHERE id_paquete = 4;
UPDATE servicios."Paquete" SET whatsapp_ilimitado = true WHERE id_paquete = 5;
UPDATE servicios."Paquete" SET redes_sociales = true WHERE id_paquete = 6;
UPDATE servicios."Paquete" SET minutos = 60 WHERE id_paquete = 7;
UPDATE servicios."Paquete" SET sms = 100 WHERE id_paquete = 8;
UPDATE servicios."Paquete" SET redes_sociales = true WHERE id_paquete = 9; -- TikTok
UPDATE servicios."Paquete" SET minutos = 30 WHERE id_paquete = 10;
UPDATE servicios."Paquete" SET megas = 10240 WHERE id_paquete = 13;
