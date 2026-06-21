-- Actualizar TODAS las contraseñas con un hash bcrypt válido para Laravel
-- Este hash corresponde a la contraseña: password123
-- Generado con PHP: password_hash('password123', PASSWORD_BCRYPT)
UPDATE seguridad."Usuario_Sistema"
SET password_hash = '$2y$12$sZhyoKPYR0yadWhGPmbIqeOdlOJMGiEbf0Nv4wLrDJYzmrGIqUDCG';
