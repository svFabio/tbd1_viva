ALTER TABLE servicios."Paquete" ADD COLUMN megas INT DEFAULT 0;
ALTER TABLE servicios."Paquete" ADD COLUMN minutos INT DEFAULT 0;
ALTER TABLE servicios."Paquete" ADD COLUMN sms INT DEFAULT 0;

-- Eliminar las columnas booleanas temporales que pusimos (si existen)
ALTER TABLE servicios."Paquete" DROP COLUMN IF EXISTS whatsapp_ilimitado;
ALTER TABLE servicios."Paquete" DROP COLUMN IF EXISTS redes_sociales;


