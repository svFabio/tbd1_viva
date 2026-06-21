-- ============================================================
-- VIVA (NUEVATEL PCS DE BOLIVIA) — Datos de prueba 2026
-- ============================================================
-- Deshabilitar triggers para que no colisionen con los INSERTs
-- manuales de Auditoria que hacemos al final del seed.
SET session_replication_role = replica;

-- Limpiar en orden correcto
TRUNCATE TABLE seguridad."Auditoria"             CASCADE;
TRUNCATE TABLE seguridad."Usuario_Sistema"       CASCADE;
TRUNCATE TABLE fidelizacion."Historial_Puntos"   CASCADE;
TRUNCATE TABLE fidelizacion."Puntos_Bonus"       CASCADE;
TRUNCATE TABLE fidelizacion."Condicion_Puntos"   CASCADE;
TRUNCATE TABLE comercial."Numero_Amigo"          CASCADE;
TRUNCATE TABLE comercial."Promocion_Linea"       CASCADE;
TRUNCATE TABLE comercial."Condicion_Promocion"   CASCADE;
TRUNCATE TABLE comercial."Promocion"             CASCADE;
TRUNCATE TABLE finanzas."Transaccion"            CASCADE;
TRUNCATE TABLE finanzas."Transfuzion"            CASCADE;
TRUNCATE TABLE finanzas."T_Presta"               CASCADE;
TRUNCATE TABLE finanzas."Recarga"                CASCADE;
TRUNCATE TABLE finanzas."Factura"                CASCADE;
TRUNCATE TABLE finanzas."Bolsillo"               CASCADE;
TRUNCATE TABLE finanzas."Tarjeta_Recarga"        CASCADE;
TRUNCATE TABLE servicios."Consumo"               CASCADE;
TRUNCATE TABLE servicios."Bolsa_Activa"          CASCADE;
TRUNCATE TABLE servicios."App_Exenta_En_Bolsa"   CASCADE;
TRUNCATE TABLE servicios."Paquete"               CASCADE;
TRUNCATE TABLE lineas."Historial_Linea_Equipo"   CASCADE;
TRUNCATE TABLE lineas."Linea_Postpago"           CASCADE;
TRUNCATE TABLE lineas."Linea"                    CASCADE;
TRUNCATE TABLE lineas."Equipo"                   CASCADE;
TRUNCATE TABLE lineas."SIM_Card"                 CASCADE;
TRUNCATE TABLE lineas."Plan"                     CASCADE;
TRUNCATE TABLE clientes."Empresa"                CASCADE;
TRUNCATE TABLE clientes."Persona_Natural"        CASCADE;
TRUNCATE TABLE clientes."Cliente"                CASCADE;

-- ============================================================
-- ESQUEMA: clientes
-- 30 clientes: 25 personas naturales + 5 empresas bolivianas
-- ============================================================

INSERT INTO clientes."Cliente" (id_cliente, fecha_registro, estado) VALUES
-- personas naturales de Cochabamba, La Paz, Santa Cruz
(1,  '2021-03-15 08:30:00', 'Activo'),
(2,  '2021-07-22 10:15:00', 'Activo'),
(3,  '2022-01-10 09:00:00', 'Activo'),
(4,  '2022-04-05 14:20:00', 'Activo'),
(5,  '2022-08-18 11:45:00', 'Activo'),
(6,  '2022-11-30 16:00:00', 'Activo'),
(7,  '2023-02-14 08:00:00', 'Activo'),
(8,  '2023-05-20 13:30:00', 'Activo'),
(9,  '2023-08-09 10:00:00', 'Activo'),
(10, '2023-10-25 15:45:00', 'Activo'),
(11, '2024-01-08 09:30:00', 'Activo'),
(12, '2024-03-17 11:00:00', 'Activo'),
(13, '2024-06-21 14:00:00', 'Activo'),
(14, '2024-09-03 08:45:00', 'Activo'),
(15, '2024-12-11 10:30:00', 'Activo'),
(16, '2025-02-20 09:00:00', 'Activo'),
(17, '2025-04-15 11:30:00', 'Activo'),
(18, '2025-06-30 14:00:00', 'Activo'),
(19, '2025-09-10 08:00:00', 'Inactivo'),
(20, '2025-11-05 10:45:00', 'Activo'),
(21, '2026-01-12 09:15:00', 'Activo'),
(22, '2026-02-08 13:00:00', 'Activo'),
(23, '2026-03-01 08:30:00', 'Activo'),
(24, '2026-04-10 10:00:00', 'Activo'),
(25, '2026-05-02 09:30:00', 'Activo'),
-- empresas
(26, '2020-06-01 09:00:00', 'Activo'),
(27, '2021-02-15 10:00:00', 'Activo'),
(28, '2022-07-10 11:00:00', 'Activo'),
(29, '2023-01-20 09:30:00', 'Activo'),
(30, '2023-09-05 14:00:00', 'Activo');

INSERT INTO clientes."Persona_Natural" (id_persona, id_cliente, nombre, apellido, ci, correo) VALUES
(1,  1,  'Juan Carlos',    'Mamani Choque',     '7845123 CB',  'jmamani@gmail.com'),
(2,  2,  'Maria Elena',    'Quispe Condori',    '6512398 LP',  'mquispe@hotmail.com'),
(3,  3,  'Pedro Antonio',  'Vargas Torrez',     '7891234 SC',  'pvargas@gmail.com'),
(4,  4,  'Ana Lucia',      'Gutierrez Pardo',   '5678901 CB',  'agutierrez@yahoo.com'),
(5,  5,  'Carlos Alberto', 'Mendoza Rojas',     '9012345 LP',  'cmendoza@gmail.com'),
(6,  6,  'Rosa Elvira',    'Choque Huanca',     '4321098 OR',  'rchoque@hotmail.com'),
(7,  7,  'Luis Fernando',  'Aguilar Soria',     '3456789 BE',  'laguilar@gmail.com'),
(8,  8,  'Patricia',       'Salazar Vaca',      '6789012 SC',  'psalazar@gmail.com'),
(9,  9,  'Roberto',        'Nina Callisaya',    '2345678 LP',  'rnina@hotmail.com'),
(10, 10, 'Carmen Rosa',    'Apaza Mamani',      '7654321 CB',  'capaza@gmail.com'),
(11, 11, 'Jorge Eduardo',  'Espinoza Baldivia', '1234567 SC',  'jespinoza@gmail.com'),
(12, 12, 'Silvia',         'Vedia Camacho',     '8901234 CB',  'svedia@yahoo.com'),
(13, 13, 'Oscar Daniel',   'Terceros Paz',      '5432109 BE',  'oterceros@gmail.com'),
(14, 14, 'Gabriela',       'Montano Roca',      '9876543 SC',  'gmontano@gmail.com'),
(15, 15, 'Rodrigo',        'Panozo Melgar',     '3210987 LP',  'rpanozo@hotmail.com'),
(16, 16, 'Valeria',        'Torrez Flores',     '6541230 CB',  'vtorrez@gmail.com'),
(17, 17, 'Fernando',       'Cossio Reyes',      '7890123 SC',  'fcossio@gmail.com'),
(18, 18, 'Daniela',        'Heredia Vasco',     '4560987 LP',  'dheredia@hotmail.com'),
(19, 19, 'Miguel Angel',   'Suarez Ortiz',      '8123456 OR',  'msuarez@yahoo.com'),
(20, 20, 'Paola',          'Sanjinez Quiroga',  '2109876 CB',  'psanjinez@gmail.com'),
(21, 21, 'Kevin',          'Villanueva Cruz',   '5109876 SC',  'kvillanueva@gmail.com'),
(22, 22, 'Luciana',        'Arce Ballon',       '6098765 LP',  'larce@hotmail.com'),
(23, 23, 'Sebastian',      'Romero Hinojosa',   '7098765 CB',  'sromero@gmail.com'),
(24, 24, 'Nataly',         'Caballero Medina',  '8098765 SC',  'ncaballero@gmail.com'),
(25, 25, 'Diego Alonso',   'Quiroz Delgado',    '9087654 LP',  'dquiroz@hotmail.com');

INSERT INTO clientes."Empresa" (id_empresa, id_cliente, razon_social, nit, representante_legal) VALUES
(1, 26, 'Jalasoft S.R.L.',           '1028475024',  'Jorge Guzman Lopez'),
(2, 27, 'Farmacorp S.A.',            '1548392025',  'Rosario Paz Antelo'),
(3, 28, 'PIL Andina S.A.',           '1002345678',  'Pablo Vallejos Rios'),
(4, 29, 'Servicios TechBol S.R.L.',  '2034567890',  'Eduardo Salinas Perez'),
(5, 30, 'Clinica Los Angeles S.R.L.','3045678901',  'Dra. Patricia Arce Vaca');

-- ============================================================
-- ESQUEMA: lineas
-- ============================================================

INSERT INTO lineas."Plan" (id_plan, nombre_plan, tarifa_mensual, tipo_plan) VALUES
(1, 'Prepago VIVA Basico',        0.00,   'Prepago'),
(2, 'Prepago VIVA Joven',         0.00,   'Prepago'),
(3, 'Plan VIVA Max 150',          150.00, 'Postpago'),
(4, 'Plan VIVA Max 250',          250.00, 'Postpago'),
(5, 'Plan VIVA Max 500',          500.00, 'Postpago'),
(6, 'Plan Corporativo VIVA 1000', 1000.00,'Postpago'),
(7, 'Plan Corporativo VIVA 2000', 2000.00,'Postpago');

INSERT INTO lineas."SIM_Card" (id_sim, iccid, imsi, estado) VALUES
(1,  '8959040000001000001', '736040000100001', 'Activo'),
(2,  '8959040000001000002', '736040000100002', 'Activo'),
(3,  '8959040000001000003', '736040000100003', 'Activo'),
(4,  '8959040000001000004', '736040000100004', 'Activo'),
(5,  '8959040000001000005', '736040000100005', 'Activo'),
(6,  '8959040000001000006', '736040000100006', 'Activo'),
(7,  '8959040000001000007', '736040000100007', 'Activo'),
(8,  '8959040000001000008', '736040000100008', 'Activo'),
(9,  '8959040000001000009', '736040000100009', 'Inactivo'),
(10, '8959040000001000010', '736040000100010', 'Activo'),
(11, '8959040000001000011', '736040000100011', 'Activo'),
(12, '8959040000001000012', '736040000100012', 'Activo'),
(13, '8959040000001000013', '736040000100013', 'Activo'),
(14, '8959040000001000014', '736040000100014', 'Activo'),
(15, '8959040000001000015', '736040000100015', 'Activo'),
(16, '8959040000001000016', '736040000100016', 'Activo'),
(17, '8959040000001000017', '736040000100017', 'Activo'),
(18, '8959040000001000018', '736040000100018', 'Activo'),
(19, '8959040000001000019', '736040000100019', 'Activo'),
(20, '8959040000001000020', '736040000100020', 'Activo'),
(21, '8959040000001000021', '736040000100021', 'Activo'),
(22, '8959040000001000022', '736040000100022', 'Activo'),
(23, '8959040000001000023', '736040000100023', 'Activo'),
(24, '8959040000001000024', '736040000100024', 'Activo'),
(25, '8959040000001000025', '736040000100025', 'Activo'),
(26, '8959040000001000026', '736040000100026', 'Stock'),
(27, '8959040000001000027', '736040000100027', 'Stock'),
(28, '8959040000001000028', '736040000100028', 'Baja'),
(29, '8959040000001000029', '736040000100029', 'Activo'),
(30, '8959040000001000030', '736040000100030', 'Activo');

INSERT INTO lineas."Equipo" (id_equipo, imei, marca, modelo) VALUES
(1,  '352999001100001', 'Samsung',  'Galaxy A14'),
(2,  '352999001100002', 'Xiaomi',   'Redmi Note 12'),
(3,  '352999001100003', 'Apple',    'iPhone 13'),
(4,  '352999001100004', 'Motorola', 'Moto G32'),
(5,  '352999001100005', 'Samsung',  'Galaxy S23'),
(6,  '352999001100006', 'Xiaomi',   'Poco X5'),
(7,  '352999001100007', 'Huawei',   'Y9s'),
(8,  '352999001100008', 'Samsung',  'Galaxy A54'),
(9,  '352999001100009', 'Apple',    'iPhone 12'),
(10, '352999001100010', 'Motorola', 'Edge 30'),
(11, '352999001100011', 'Xiaomi',   'Redmi 10C'),
(12, '352999001100012', 'Samsung',  'Galaxy M14'),
(13, '352999001100013', 'Huawei',   'Nova 11'),
(14, '352999001100014', 'Apple',    'iPhone 14'),
(15, '352999001100015', 'Motorola', 'Moto G53'),
(16, '352999001100016', 'Samsung',  'Galaxy A34'),
(17, '352999001100017', 'Xiaomi',   '13T'),
(18, '352999001100018', 'Apple',    'iPhone 15'),
(19, '352999001100019', 'Honor',    'X8b'),
(20, '352999001100020', 'Realme',   'C55'),
(21, '352999001100021', 'Samsung',  'Galaxy A05s'),
(22, '352999001100022', 'Xiaomi',   'Redmi 13C'),
(23, '352999001100023', 'Motorola', 'Moto G84'),
(24, '352999001100024', 'Nokia',    'G42'),
(25, '352999001100025', 'Samsung',  'Galaxy S24');

-- Lineas: prefijos reales VIVA Bolivia 607, 703, 707
INSERT INTO lineas."Linea" (id_linea, numero_telefono, id_cliente, id_plan, id_sim_activo, estado) VALUES
(1,  '60712345', 1,  1, 1,  'Activo'),
(2,  '70384756', 2,  3, 2,  'Activo'),
(3,  '60798765', 3,  2, 3,  'Activo'),
(4,  '70722334', 4,  4, 4,  'Activo'),
(5,  '60745678', 5,  1, 5,  'Activo'),
(6,  '70387654', 6,  2, 6,  'Activo'),
(7,  '60767890', 7,  1, 7,  'Activo'),
(8,  '70779012', 8,  3, 8,  'Activo'),
(9,  '60734567', 9,  1, 9,  'Inactivo'),
(10, '70710987', 10, 2, 10, 'Activo'),
(11, '60756789', 11, 4, 11, 'Activo'),
(12, '70761543', 12, 4, 12, 'Activo'),
(13, '60789012', 13, 1, 13, 'Activo'),
(14, '70791234', 14, 3, 14, 'Activo'),
(15, '60723456', 15, 2, 15, 'Activo'),
(16, '70738765', 16, 1, 16, 'Activo'),
(17, '60711234', 17, 3, 17, 'Activo'),
(18, '70765432', 18, 2, 18, 'Activo'),
(19, '60778901', 19, 1, 19,'Inactivo'),
(20, '70724567', 20, 2, 20, 'Activo'),
(21, '60745123', 21, 1, 21, 'Activo'),
(22, '70736789', 22, 3, 22, 'Activo'),
(23, '60758901', 23, 1, 23, 'Activo'),
(24, '70770123', 24, 2, 24, 'Activo'),
(25, '60712987', 25, 1, 25, 'Activo'),
-- empresas: prefijos 703 corporativos
(26, '70344001', 26, 6, 29, 'Activo'),
(27, '70344002', 26, 6, 30, 'Activo'),
(28, '70355001', 27, 7, 26,  'Activo'),
(29, '70355002', 27, 7, 27,  'Activo'),
(30, '70366001', 28, 6, 28,  'Activo');

INSERT INTO lineas."Linea_Postpago" (id_postpago, id_linea, limite_credito, dia_corte) VALUES
(1,  2,  300.00,  15),
(2,  4,  500.00,  10),
(3,  8,  300.00,  15),
(4,  11, 800.00,  5),
(5,  12, 800.00,  5),
(6,  14, 300.00,  20),
(7,  17, 300.00,  15),
(8,  22, 300.00,  15),
(9,  24, 300.00,  10),
(10, 26, 2000.00, 1),
(11, 27, 2000.00, 1),
(12, 28, 3000.00, 1),
(13, 29, 3000.00, 1),
(14, 30, 2000.00, 1);

INSERT INTO lineas."Historial_Linea_Equipo" (id_historial, id_linea, id_equipo, fecha_asociacion) VALUES
(1,  1,  1,  '2021-03-15 08:30:00'),
(2,  2,  2,  '2021-07-22 10:15:00'),
(3,  3,  3,  '2022-01-10 09:00:00'),
(4,  4,  4,  '2022-04-05 14:20:00'),
(5,  5,  5,  '2022-08-18 11:45:00'),
(6,  6,  6,  '2022-11-30 16:00:00'),
(7,  7,  7,  '2023-02-14 08:00:00'),
(8,  8,  8,  '2023-05-20 13:30:00'),
(9,  9,  9,  '2023-08-09 10:00:00'),
(10, 10, 10, '2023-10-25 15:45:00'),
(11, 11, 11, '2024-01-08 09:30:00'),
(12, 12, 12, '2024-03-17 11:00:00'),
(13, 13, 13, '2024-06-21 14:00:00'),
(14, 14, 14, '2024-09-03 08:45:00'),
(15, 15, 15, '2024-12-11 10:30:00'),
(16, 16, 16, '2025-02-20 09:00:00'),
(17, 17, 17, '2025-04-15 11:30:00'),
(18, 18, 18, '2025-06-30 14:00:00'),
(19, 20, 20, '2025-11-05 10:45:00'),
(20, 21, 21, '2026-01-12 09:15:00'),
(21, 22, 22, '2026-02-08 13:00:00'),
(22, 23, 23, '2026-03-01 08:30:00'),
(23, 24, 24, '2026-04-10 10:00:00'),
(24, 25, 25, '2026-05-02 09:30:00'),
-- Juan cambio de equipo en 2024
(25, 1,  16, '2024-06-01 10:00:00'),
-- lineas corporativas
(26, 26, 19, '2020-06-01 09:00:00'),
(27, 27, 20, '2020-06-01 09:00:00'),
(28, 28, 21, '2021-02-15 10:00:00'),
(29, 29, 22, '2021-02-15 10:00:00'),
(30, 30, 23, '2022-07-10 11:00:00');

-- ============================================================
-- ESQUEMA: servicios
-- ============================================================

INSERT INTO servicios."Paquete" (id_paquete, nombre_paquete, costo, duracion_dias) VALUES
(1,  'Bolsa WOW 500MB',           5.00,  1),
(2,  'Bolsa WOW 1GB Nocturna',    3.00,  1),
(3,  'Bolsa WOW 2GB',             10.00, 1),
(4,  'Bolsa WOW 5GB Semanal',     30.00, 7),
(5,  'Bolsa WhatsApp 7 dias',     2.00,  7),
(6,  'Bolsa Redes Sociales',      5.00,  1),
(7,  'Bolsa Voz 60 minutos',      4.00,  2),
(8,  'Bolsa SMS 100',             2.00,  7),
(9,  'Bolsa TikTok 3 dias',       3.00,  3),
(10, 'Bolsa LDI 30 minutos',      8.00,  7),
(11, 'Bolsa Streaming Semanal',   12.00, 7),
(12, 'Bolsa WOW Fin de Semana',   7.00,  2),
(13, 'Bolsa Datos 10GB Mensual',  80.00, 30),
(14, 'Bolsa Voz Ilimitada VIVA',  15.00, 1),
(15, 'Bolsa Add-On Corporativo',  25.00, 30);

INSERT INTO servicios."App_Exenta_En_Bolsa" (id_app, id_paquete, nombre_app) VALUES
(1,  5,  'WhatsApp'),
(2,  5,  'WhatsApp Business'),
(3,  6,  'Facebook'),
(4,  6,  'Instagram'),
(5,  6,  'TikTok'),
(6,  9,  'TikTok'),
(7,  2,  'YouTube'),
(8,  11, 'YouTube'),
(9,  11, 'Netflix'),
(10, 11, 'Spotify'),
(11, 11, 'Disney+'),
(12, 4,  'WhatsApp'),
(13, 4,  'Facebook'),
(14, 12, 'WhatsApp'),
(15, 12, 'Instagram');

INSERT INTO servicios."Bolsa_Activa" (id_bolsa_activa, id_linea, id_paquete, fecha_activacion, fecha_expiracion) VALUES
(1,  1,  3,  '2026-05-19 10:00:00', '2026-05-20 10:00:00'),
(2,  1,  5,  '2026-05-15 09:00:00', '2026-05-22 09:00:00'),
(3,  3,  4,  '2026-05-18 08:00:00', '2026-05-25 08:00:00'),
(4,  5,  6,  '2026-05-19 11:00:00', '2026-05-20 11:00:00'),
(5,  6,  7,  '2026-05-18 14:00:00', '2026-05-20 14:00:00'),
(6,  7,  2,  '2026-05-19 21:00:00', '2026-05-20 06:00:00'),
(7,  10, 1,  '2026-05-19 09:00:00', '2026-05-20 09:00:00'),
(8,  11, 13, '2026-05-01 09:00:00', '2026-05-31 09:00:00'),
(9,  13, 9,  '2026-05-17 15:00:00', '2026-05-20 15:00:00'),
(10, 15, 12, '2026-05-17 00:00:00', '2026-05-19 00:00:00'),
(11, 16, 5,  '2026-05-12 10:00:00', '2026-05-19 10:00:00'),
(12, 20, 3,  '2026-05-19 12:00:00', '2026-05-20 12:00:00'),
(13, 21, 6,  '2026-05-18 08:00:00', '2026-05-19 08:00:00'),
(14, 23, 4,  '2026-05-13 09:00:00', '2026-05-20 09:00:00'),
(15, 26, 15, '2026-05-01 00:00:00', '2026-05-31 00:00:00'),
-- bolsas vencidas (historico)
(16, 1,  1,  '2026-05-10 10:00:00', '2026-05-11 10:00:00'),
(17, 5,  3,  '2026-05-12 11:00:00', '2026-05-13 11:00:00'),
(18, 7,  1,  '2026-05-14 21:00:00', '2026-05-15 06:00:00'),
(19, 10, 6,  '2026-05-16 09:00:00', '2026-05-17 09:00:00'),
(20, 15, 7,  '2026-05-15 10:00:00', '2026-05-17 10:00:00');

-- Consumos: 60 registros variados
INSERT INTO servicios."Consumo" (id_consumo, id_linea, tipo_consumo, cantidad, fecha_consumo, id_bolsa_activa) VALUES
-- Juan (linea 1) - usa WhatsApp gratis y datos de bolsa
(1,  1,  'Datos',   45.500,  '2026-05-19 10:15:00', 1),
(2,  1,  'Datos',   12.300,  '2026-05-19 11:00:00', 2),
(3,  1,  'Voz', 185.000, '2026-05-19 14:00:00', NULL),
(4,  1,  'SMS',     1.000,   '2026-05-19 15:30:00', NULL),
(5,  1,  'Datos',   8.200,   '2026-05-20 08:00:00', 2),
-- Maria (linea 2) - postpago
(6,  2,  'Datos',   512.000, '2026-05-18 10:00:00', NULL),
(7,  2,  'Voz', 300.000, '2026-05-18 14:00:00', NULL),
(8,  2,  'SMS',     3.000,   '2026-05-18 16:00:00', NULL),
(9,  2,  'Datos',   1024.00, '2026-05-19 09:00:00', NULL),
-- Pedro (linea 3) - usa bolsa semanal
(10, 3,  'Datos',   380.000, '2026-05-18 11:00:00', 3),
(11, 3,  'Datos',   620.000, '2026-05-19 10:30:00', 3),
(12, 3,  'Voz', 120.000, '2026-05-19 15:00:00', NULL),
-- Ana (linea 4) - postpago
(13, 4,  'Datos',   2048.00, '2026-05-17 09:00:00', NULL),
(14, 4,  'Voz', 600.000, '2026-05-17 11:00:00', NULL),
(15, 4,  'SMS',     5.000,   '2026-05-17 14:00:00', NULL),
-- Carlos (linea 5) - usa redes sociales
(16, 5,  'Datos',   95.000,  '2026-05-19 12:00:00', 4),
(17, 5,  'Voz', 90.000,  '2026-05-19 13:00:00', NULL),
(18, 5,  'SMS',     2.000,   '2026-05-19 14:30:00', NULL),
-- Rosa (linea 6) - usa bolsa voz
(19, 6,  'Voz', 1800.00, '2026-05-18 09:00:00', 5),
(20, 6,  'Voz', 1800.00, '2026-05-19 10:00:00', 5),
(21, 6,  'Datos',   50.000,  '2026-05-19 11:30:00', NULL),
-- Luis (linea 7) - nocturno
(22, 7,  'Datos',   1024.00, '2026-05-19 22:30:00', 6),
(23, 7,  'SMS',     1.000,   '2026-05-19 23:00:00', NULL),
-- Patricia (linea 8) - postpago
(24, 8,  'Datos',   3072.00, '2026-05-18 14:00:00', NULL),
(25, 8,  'Voz', 450.000, '2026-05-19 09:00:00', NULL),
-- Roberto (linea 9 - inactivo, no hay consumo reciente)
-- Carmen (linea 10) - bolsa 500MB
(26, 10, 'Datos',   350.000, '2026-05-19 10:00:00', 7),
(27, 10, 'SMS',     4.000,   '2026-05-19 11:00:00', NULL),
-- Jorge (linea 11) - 10GB mensual corporativo
(28, 11, 'Datos',   5120.00, '2026-05-15 09:00:00', 8),
(29, 11, 'Datos',   2048.00, '2026-05-18 10:00:00', 8),
(30, 11, 'Voz', 1200.00, '2026-05-19 11:00:00', NULL),
-- Silvia (linea 12) - postpago
(31, 12, 'Datos',   1536.00, '2026-05-17 10:00:00', NULL),
(32, 12, 'Voz', 360.000, '2026-05-18 14:00:00', NULL),
-- Oscar (linea 13) - TikTok
(33, 13, 'Datos',   200.000, '2026-05-17 20:00:00', 9),
(34, 13, 'Datos',   350.000, '2026-05-18 19:00:00', 9),
(35, 13, 'SMS',     1.000,   '2026-05-19 08:00:00', NULL),
-- Gabriela (linea 14) - postpago
(36, 14, 'Datos',   768.000, '2026-05-18 11:00:00', NULL),
(37, 14, 'Voz', 180.000, '2026-05-19 10:00:00', NULL),
-- Rodrigo (linea 15) - fin de semana
(38, 15, 'Datos',   512.000, '2026-05-17 10:00:00', 10),
(39, 15, 'Datos',   488.000, '2026-05-18 12:00:00', 10),
(40, 15, 'Voz', 60.000,  '2026-05-19 09:00:00', NULL),
-- Valeria (linea 16) - WhatsApp
(41, 16, 'Datos',   25.000,  '2026-05-17 08:00:00', 11),
(42, 16, 'Datos',   18.000,  '2026-05-18 09:00:00', 11),
-- Kevin (linea 21) - redes
(43, 21, 'Datos',   80.000,  '2026-05-18 15:00:00', 13),
(44, 21, 'Voz', 45.000,  '2026-05-19 10:00:00', NULL),
-- Sebastian (linea 23) - semanal
(45, 23, 'Datos',   1500.00, '2026-05-14 09:00:00', 14),
(46, 23, 'Datos',   2000.00, '2026-05-17 10:00:00', 14),
(47, 23, 'SMS',     2.000,   '2026-05-19 11:00:00', NULL),
-- lineas corporativas Jalasoft
(48, 26, 'Datos',   8192.00, '2026-05-15 09:00:00', 15),
(49, 26, 'Voz', 3600.00, '2026-05-16 10:00:00', NULL),
(50, 26, 'Datos',   4096.00, '2026-05-19 09:00:00', 15),
(51, 27, 'Datos',   6144.00, '2026-05-17 11:00:00', NULL),
(52, 27, 'Voz', 1800.00, '2026-05-18 14:00:00', NULL),
(53, 28, 'Datos',   10240.0, '2026-05-13 09:00:00', NULL),
(54, 28, 'Voz', 5400.00, '2026-05-16 10:00:00', NULL),
(55, 29, 'Datos',   7168.00, '2026-05-18 09:00:00', NULL),
-- consumos desde bolsas vencidas (historico)
(56, 1,  'Datos',   498.000, '2026-05-10 11:00:00', 16),
(57, 5,  'Datos',   512.000, '2026-05-12 12:00:00', 17),
(58, 7,  'Datos',   900.000, '2026-05-14 22:00:00', 18),
(59, 10, 'Datos',   95.000,  '2026-05-16 10:00:00', 19),
(60, 15, 'Voz', 3300.00, '2026-05-15 11:00:00', 20);

-- ============================================================
-- ESQUEMA: finanzas
-- ============================================================

-- Tarjetas: valores reales VIVA Bolivia
INSERT INTO finanzas."Tarjeta_Recarga" (id_tarjeta, codigo_pin, monto, estado, id_linea_cargada) VALUES
(1,  'VIVA26AA001122', 20.00,  'Usada',      1),
(2,  'VIVA26AA003344', 50.00,  'Usada',      3),
(3,  'VIVA26AA005566', 10.00,  'Usada',      5),
(4,  'VIVA26AA007788', 100.00, 'Usada',      7),
(5,  'VIVA26AA009900', 20.00,  'Usada',      10),
(6,  'VIVA26AB001122', 50.00,  'Usada',      13),
(7,  'VIVA26AB003344', 10.00,  'Usada',      16),
(8,  'VIVA26AB005566', 20.00,  'Usada',      21),
(9,  'VIVA26AB007788', 50.00,  'Usada',      23),
(10, 'VIVA26AB009900', 100.00, 'Usada',      25),
(11, 'VIVA26AC001122', 10.00,  'Disponible', NULL),
(12, 'VIVA26AC003344', 20.00,  'Disponible', NULL),
(13, 'VIVA26AC005566', 50.00,  'Disponible', NULL),
(14, 'VIVA26AC007788', 100.00, 'Disponible', NULL),
(15, 'VIVA26AC009900', 10.00,  'Disponible', NULL),
(16, 'VIVA26AD001122', 20.00,  'Disponible', NULL),
(17, 'VIVA26AD003344', 50.00,  'Anulada',    NULL),
(18, 'VIVA26AD005566', 10.00,  'Disponible', NULL),
(19, 'VIVA26AD007788', 20.00,  'Disponible', NULL),
(20, 'VIVA26AD009900', 100.00, 'Disponible', NULL);

-- Bolsillo: un registro por linea activa
INSERT INTO finanzas."Bolsillo" (id_bolsillo, id_linea, saldo_dinero, saldo_megas, saldo_minutos) VALUES
(1,  1,  35.50,   0,     0),
(2,  2,  15.00,   0,     0),
(3,  3,  48.00,   0,     0),
(4,  4,  30.00,   0,     0),
(5,  5,  12.00,   0,     0),
(6,  6,  0.00,    0,     0),
(7,  7,  5.50,    0,     0),
(8,  8,  50.00,   0,     0),
(9,  9,  3.00,    0,     0),
(10, 10, 22.00,   0,     0),
(11, 11, 100.00,  0,     0),
(12, 12, 25.00,   0,     0),
(13, 13, 8.00,    0,     0),
(14, 14, 75.00,   0,     0),
(15, 15, 18.00,   0,     0),
(16, 16, 10.00,   0,     0),
(17, 17, 60.00,   0,     0),
(18, 18, 30.00,   0,     0),
(19, 19, 0.00,    0,     0),
(20, 20, 45.00,   0,     0),
(21, 21, 5.00,    0,     0),
(22, 22, 80.00,   0,     0),
(23, 23, 20.00,   0,     0),
(24, 24, 55.00,   0,     0),
(25, 25, 12.00,   0,     0),
(26, 26, 0.00,    0,     0),
(27, 27, 0.00,    0,     0),
(28, 28, 0.00,    0,     0),
(29, 29, 0.00,    0,     0),
(30, 30, 0.00,    0,     0);

-- Recargas
INSERT INTO finanzas."Recarga" (id_recarga, id_linea, monto, fecha_recarga, id_tarjeta) VALUES
(1,  1,  20.00,  '2026-03-01 09:10:00', 1),
(2,  1,  50.00,  '2026-04-15 14:22:00', NULL),
(3,  3,  50.00,  '2026-03-05 10:00:00', 2),
(4,  5,  10.00,  '2026-03-08 11:30:00', 3),
(5,  5,  20.00,  '2026-04-20 16:45:00', NULL),
(6,  7,  10.00,  '2026-03-10 08:00:00', 4),
(7,  7,  20.00,  '2026-04-25 09:00:00', NULL),
(8,  9,  10.00,  '2026-03-12 12:00:00', NULL),
(9,  10, 20.00,  '2026-03-18 17:30:00', 5),
(10, 10, 50.00,  '2026-04-18 09:00:00', NULL),
(11, 13, 50.00,  '2026-03-20 10:15:00', 6),
(12, 13, 100.00, '2026-04-20 14:00:00', NULL),
(13, 15, 20.00,  '2026-03-25 11:00:00', NULL),
(14, 16, 10.00,  '2026-03-28 14:00:00', 7),
(15, 16, 20.00,  '2026-04-28 08:30:00', NULL),
(16, 20, 50.00,  '2026-04-01 09:00:00', NULL),
(17, 21, 20.00,  '2026-04-05 10:00:00', 8),
(18, 21, 10.00,  '2026-05-05 11:00:00', NULL),
(19, 23, 50.00,  '2026-04-08 14:00:00', 9),
(20, 23, 50.00,  '2026-05-08 09:00:00', NULL),
(21, 25, 100.00, '2026-04-10 11:00:00', 10),
(22, 3,  20.00,  '2026-04-12 09:45:00', NULL),
(23, 5,  50.00,  '2026-05-15 13:00:00', NULL),
(24, 7,  10.00,  '2026-05-01 08:00:00', NULL),
(25, 12, 20.00,  '2026-05-10 10:00:00', NULL),
(26, 14, 50.00,  '2026-05-12 11:00:00', NULL),
(27, 17, 100.00, '2026-05-14 14:00:00', NULL),
(28, 18, 50.00,  '2026-05-16 09:00:00', NULL),
(29, 22, 100.00, '2026-05-17 10:00:00', NULL),
(30, 24, 50.00,  '2026-05-18 11:00:00', NULL);

-- T_Presta
INSERT INTO finanzas."T_Presta" (id_prestamo, id_linea, monto_prestado, monto_comision, estado_cobro) VALUES
(1,  1,  5.00,  0.00, 'Cobrado'),
(2,  5,  2.00,  0.00, 'Cobrado'),
(3,  7,  5.00,  0.00, 'Cobrado'),
(4,  9,  5.00,  0.00, 'Cobrado'),
(5,  10, 2.00,  0.00, 'Cobrado'),
(6,  13, 10.00, 0.00, 'Cobrado'),
(7,  15, 5.00,  0.00, 'Cobrado'),
(8,  16, 2.00,  0.00, 'Pendiente'),
(9,  21, 5.00,  0.00, 'Cobrado'),
(10, 23, 10.00, 0.00, 'Cobrado'),
(11, 25, 5.00,  0.00, 'Pendiente'),
(12, 6,  2.00,  0.00, 'Cobrado'),
(13, 3,  5.00,  0.00, 'Cobrado'),
(14, 20, 2.00,  0.00, 'Cobrado'),
(15, 7,  10.00, 0.00, 'Pendiente');

-- Facturas postpago
INSERT INTO finanzas."Factura" (id_factura, id_linea, monto_total, fecha_emision, fecha_vencimiento, estado_pago) VALUES
(1,  2,  150.00,  '2026-03-15 00:00:00', '2026-03-30 00:00:00', 'Pagado'),
(2,  4,  250.00,  '2026-03-10 00:00:00', '2026-03-25 00:00:00', 'Pagado'),
(3,  8,  150.00,  '2026-03-15 00:00:00', '2026-03-30 00:00:00', 'Pagado'),
(4,  11, 500.00,  '2026-03-05 00:00:00', '2026-03-20 00:00:00', 'Pagado'),
(5,  12, 250.00,  '2026-03-05 00:00:00', '2026-03-20 00:00:00', 'Pagado'),
(6,  14, 150.00,  '2026-03-20 00:00:00', '2026-04-05 00:00:00', 'Pagado'),
(7,  17, 150.00,  '2026-03-15 00:00:00', '2026-03-30 00:00:00', 'Pagado'),
(8,  22, 150.00,  '2026-03-08 00:00:00', '2026-03-23 00:00:00', 'Pagado'),
(9,  24, 150.00,  '2026-03-10 00:00:00', '2026-03-25 00:00:00', 'Pagado'),
(10, 26, 1000.00, '2026-03-01 00:00:00', '2026-03-15 00:00:00', 'Pagado'),
(11, 27, 1000.00, '2026-03-01 00:00:00', '2026-03-15 00:00:00', 'Pagado'),
(12, 28, 2000.00, '2026-03-01 00:00:00', '2026-03-15 00:00:00', 'Pagado'),
(13, 29, 2000.00, '2026-03-01 00:00:00', '2026-03-15 00:00:00', 'Pagado'),
(14, 30, 1000.00, '2026-03-01 00:00:00', '2026-03-15 00:00:00', 'Pagado'),
-- abril
(15, 2,  150.00,  '2026-04-15 00:00:00', '2026-04-30 00:00:00', 'Pagado'),
(16, 4,  250.00,  '2026-04-10 00:00:00', '2026-04-25 00:00:00', 'Pagado'),
(17, 8,  150.00,  '2026-04-15 00:00:00', '2026-04-30 00:00:00', 'Vencido'),
(18, 11, 500.00,  '2026-04-05 00:00:00', '2026-04-20 00:00:00', 'Pagado'),
(19, 26, 1000.00, '2026-04-01 00:00:00', '2026-04-15 00:00:00', 'Pagado'),
(20, 28, 2000.00, '2026-04-01 00:00:00', '2026-04-15 00:00:00', 'Pagado'),
-- mayo (actuales)
(21, 2,  150.00,  '2026-05-15 00:00:00', '2026-05-30 00:00:00', 'Pendiente'),
(22, 4,  250.00,  '2026-05-10 00:00:00', '2026-05-25 00:00:00', 'Pendiente'),
(23, 8,  150.00,  '2026-05-15 00:00:00', '2026-05-30 00:00:00', 'Pendiente'),
(24, 11, 500.00,  '2026-05-05 00:00:00', '2026-05-20 00:00:00', 'Pendiente'),
(25, 26, 1000.00, '2026-05-01 00:00:00', '2026-05-15 00:00:00', 'Pagado'),
(26, 28, 2000.00, '2026-05-01 00:00:00', '2026-05-15 00:00:00', 'Pagado'),
(27, 12, 250.00,  '2026-05-05 00:00:00', '2026-05-20 00:00:00', 'Pendiente'),
(28, 14, 150.00,  '2026-05-20 00:00:00', '2026-06-05 00:00:00', 'Pendiente'),
(29, 22, 150.00,  '2026-05-08 00:00:00', '2026-05-23 00:00:00', 'Pendiente'),
(30, 24, 150.00,  '2026-05-10 00:00:00', '2026-05-25 00:00:00', 'Pendiente');

-- Transfuzion
INSERT INTO finanzas."Transfuzion" (id_transfuzion, id_linea_origen, id_linea_destino, monto_transferido, fecha) VALUES
(1,  1,  5,  10.00, '2026-03-20 12:00:00'),
(2,  3,  1,  5.00,  '2026-04-01 14:00:00'),
(3,  7,  6,  5.00,  '2026-04-05 18:00:00'),
(4,  10, 9,  8.00,  '2026-04-10 11:00:00'),
(5,  13, 16, 15.00, '2026-04-15 09:00:00'),
(6,  20, 21, 10.00, '2026-04-20 14:00:00'),
(7,  23, 25, 20.00, '2026-04-25 10:00:00'),
(8,  22, 18, 5.00,  '2026-05-01 09:00:00'),
(9,  24, 15, 10.00, '2026-05-05 11:00:00'),
(10, 17, 3,  15.00, '2026-05-10 14:00:00');

-- Transacciones
INSERT INTO finanzas."Transaccion" (id_transaccion, id_linea, tipo_transaccion, monto, fecha) VALUES
(1,  1,  'Recarga',         20.00,   '2026-03-01 09:10:00'),
(2,  1,  'Recarga',         50.00,   '2026-04-15 14:22:00'),
(3,  1,  'Compra Bolsa',    10.00,   '2026-05-19 10:00:00'),
(4,  1,  'Compra Bolsa',    2.00,    '2026-05-15 09:00:00'),
(5,  1,  'Transferencia',   10.00,   '2026-03-20 12:00:00'),
(6,  2,  'Pago Factura',    150.00,  '2026-03-28 10:00:00'),
(7,  2,  'Pago Factura',    150.00,  '2026-04-28 10:00:00'),
(8,  3,  'Recarga',         50.00,   '2026-03-05 10:00:00'),
(9,  4,  'Pago Factura',    250.00,  '2026-03-24 11:00:00'),
(10, 5,  'Recarga',         10.00,   '2026-03-08 11:30:00'),
(11, 5,  'Compra Bolsa',    5.00,    '2026-05-19 11:00:00'),
(12, 6,  'Compra Bolsa',    4.00,    '2026-05-18 14:00:00'),
(13, 7,  'Recarga',         10.00,   '2026-03-10 08:00:00'),
(14, 7,  'Compra Bolsa',    3.00,    '2026-05-19 21:00:00'),
(15, 8,  'Pago Factura',    150.00,  '2026-03-28 10:00:00'),
(16, 10, 'Recarga',         20.00,   '2026-03-18 17:30:00'),
(17, 10, 'Compra Bolsa',    5.00,    '2026-05-19 09:00:00'),
(18, 11, 'Pago Factura',    500.00,  '2026-03-19 09:00:00'),
(19, 11, 'Compra Bolsa',    80.00,   '2026-05-01 09:00:00'),
(20, 13, 'Recarga',         50.00,   '2026-03-20 10:15:00'),
(21, 13, 'Compra Bolsa',    3.00,    '2026-05-17 15:00:00'),
(22, 15, 'Recarga',         20.00,   '2026-03-25 11:00:00'),
(23, 15, 'Compra Bolsa',    7.00,    '2026-05-17 00:00:00'),
(24, 16, 'Recarga',         10.00,   '2026-03-28 14:00:00'),
(25, 16, 'Compra Bolsa',    2.00,    '2026-05-12 10:00:00'),
(26, 20, 'Recarga',         50.00,   '2026-04-01 09:00:00'),
(27, 20, 'Compra Bolsa',    10.00,   '2026-05-19 12:00:00'),
(28, 21, 'Recarga',         20.00,   '2026-04-05 10:00:00'),
(29, 23, 'Recarga',         50.00,   '2026-04-08 14:00:00'),
(30, 23, 'Compra Bolsa',    30.00,   '2026-05-13 09:00:00'),
(31, 25, 'Recarga',         100.00,  '2026-04-10 11:00:00'),
(32, 26, 'Pago Factura',    1000.00, '2026-03-14 09:00:00'),
(33, 28, 'Pago Factura',    2000.00, '2026-03-14 09:00:00'),
(34, 26, 'Compra Bolsa',    25.00,   '2026-05-01 00:00:00'),
(35, 1,  'Presta Luka',     5.00,    '2026-03-09 20:00:00');

-- ============================================================
-- ESQUEMA: comercial
-- ============================================================

INSERT INTO comercial."Promocion" (id_promocion, nombre_promo, descripcion, fecha_inicio, fecha_fin) VALUES
(1, 'Doble Carga Enero 2026',       'Recarga y recibe el doble en saldo adicional',                  '2026-01-01 00:00:00', '2026-01-31 23:59:59'),
(2, 'Recarga Digital 25% Extra',    '25% adicional en recargas por APP o banca digital',             '2025-08-26 00:00:00', '2026-02-24 23:59:59'),
(3, 'Bono Bienvenida Postpago',     'Bs 50 de saldo gratis al activar plan postpago por primera vez','2024-01-01 00:00:00', '2026-12-31 23:59:59'),
(4, 'Doble Carga Abril 2026',       'Recarga y recibe el doble en saldo adicional',                  '2026-04-01 00:00:00', '2026-04-30 23:59:59'),
(5, 'Pack WOW Finde Gratis',        'Bolsa WOW Fin de Semana gratis para clientes VIVA antiguos',    '2026-04-01 00:00:00', '2026-06-30 23:59:59'),
(6, 'Numero Amigo 30 dias',         'Llama ilimitado a tu numero amigo VIVA por 30 dias',            '2026-01-01 00:00:00', '2026-12-31 23:59:59'),
(7, 'Doble Carga Mayo 2026',        'Recarga y recibe el doble en saldo adicional',                  '2026-05-01 00:00:00', '2026-05-31 23:59:59');

INSERT INTO comercial."Condicion_Promocion" (id_condicion, id_promocion, descripcion_condicion) VALUES
(1,  1, 'Antiguedad minima de 4 meses como cliente VIVA'),
(2,  1, 'Monto de recarga maximo Bs 200 para recibir el doble'),
(3,  2, 'Recarga realizada por APP VIVA o banca digital'),
(4,  2, 'Monto minimo de recarga Bs 10'),
(5,  3, 'Solo aplica al activar un plan postpago por primera vez'),
(6,  4, 'Antiguedad minima de 4 meses como cliente VIVA'),
(7,  4, 'Monto de recarga maximo Bs 200'),
(8,  5, 'Antiguedad minima de 12 meses como cliente VIVA'),
(9,  6, 'Ambas lineas deben ser de la red VIVA Bolivia'),
(10, 6, 'Linea origen debe tener saldo suficiente para activar el servicio'),
(11, 7, 'Antiguedad minima de 4 meses como cliente VIVA'),
(12, 7, 'Monto de recarga maximo Bs 200');

INSERT INTO comercial."Promocion_Linea" (id_promo_linea, id_promocion, id_linea, fecha_aplicacion) VALUES
(1, 1, 1, '2026-01-15 09:10:00'), 
(2, 6, 13, '2026-02-20 10:00:00'), 
(3, 6, 16, '2026-03-25 14:00:00'),
(4, 3, 2, '2026-04-15 14:22:00'), 
(5, 7, 10, '2026-05-18 09:00:00'),
(6,  3, 2,  '2021-07-22 10:15:00'),
(7,  3, 4,  '2022-04-05 14:20:00'),
(8,  3, 8,  '2023-05-20 13:30:00'),
(9,  4, 1,  '2026-04-15 09:00:00'),
(10, 4, 13, '2026-04-20 14:00:00'),
(11, 4, 20, '2026-04-01 09:00:00'),
(12, 5, 10, '2026-05-17 00:00:00'),
(13, 5, 15, '2026-05-17 00:00:00'),
(14, 6, 1,  '2026-02-01 10:00:00'),
(15, 6, 7,  '2026-03-01 10:00:00'),
(16, 7, 1,  '2026-05-01 09:10:00'),
(17, 7, 5,  '2026-05-15 13:00:00'),
(18, 7, 23, '2026-05-08 09:00:00');
-- Ahora sí, los números amigos amarrados a la promoción ID 2 y 3
INSERT INTO comercial."Numero_Amigo" (id_numero_amigo, id_linea_origen, id_linea_destino, id_promo_linea) VALUES
(1, 1,  5,  14), -- Línea 1 vinculada a la promo-línea 14
(2, 1,  3,  14), -- Línea 1 vinculada a la promo-línea 14
(3, 7,  10, 15), -- Línea 7 vinculada a la promo-línea 15
(4, 13, 16, 10), -- Línea 13 vinculada a la promo-línea 10 (Cambiado de NULL a 10)
(5, 20, 21, 11), -- Línea 20 vinculada a la promo-línea 11 (Cambiado de NULL a 11)
(6, 23, 25, 18), -- Línea 23 vinculada a la promo-línea 18 (Cambiado de NULL a 18)
(7, 3,  7,  2),  -- Línea 3 vinculada a la promo-línea 2 (Cambiado de NULL a 2)
(8, 11, 12, 1),  -- Vinculado a la promo-línea 1 (Cambiado de NULL a 1)
(9, 22, 24, 4),  -- Vinculado a la promo-línea 4 (Cambiado de NULL a 4)
(10, 17, 18, 6); -- Vinculado a la promo-línea 6 (Cambiado de NULL a 6)

-- ============================================================
-- ESQUEMA: fidelizacion
-- ============================================================

INSERT INTO fidelizacion."Condicion_Puntos" (id_condicion, descripcion, puntos_otorgados) VALUES
(1, 'Recarga de Bs 10 o mas: 25 puntos',                          25),
(2, 'Recarga de Bs 50 o mas: 75 puntos adicionales',              75),
(3, 'Recarga de Bs 100 o mas: 150 puntos adicionales',           150),
(4, 'Pago de factura postpago a tiempo: 50 puntos',               50),
(5, 'Primer ano como cliente VIVA: bono de 100 puntos',          100),
(6, 'Invitacion a nuevo cliente: 200 puntos',                    200),
(7, 'Navegar 30 minutos en app VIVA: 10 puntos',                  10),
(8, 'Compra de bolsa WOW: 15 puntos',                             15),
(9, 'Recarga de Bs 20 o mas: 40 puntos',                          40),
(10,'Cliente activo 3 anos o mas: bono anual de 200 puntos',     200);

INSERT INTO fidelizacion."Puntos_Bonus" (id_puntos, id_linea, cantidad_acumulada) VALUES
(1,  1,  625),
(2,  2,  400),
(3,  3,  350),
(4,  4,  600),
(5,  5,  175),
(6,  6,  90),
(7,  7,  215),
(8,  8,  300),
(9,  9,  50),
(10, 10, 280),
(11, 11, 1450),
(12, 12, 500),
(13, 13, 190),
(14, 14, 725),
(15, 15, 155),
(16, 16, 110),
(17, 17, 450),
(18, 18, 200),
(19, 20, 320),
(20, 21, 75),
(21, 22, 800),
(22, 23, 415),
(23, 24, 550),
(24, 25, 180),
(25, 26, 1200);

INSERT INTO fidelizacion."Historial_Puntos" (id_historial, id_linea, id_condicion, id_linea_invitada, puntos_afectados, fecha_movimiento) VALUES
(1,  1,  1,  NULL, 25,   '2026-03-01 09:10:00'),
(2,  1,  2,  NULL, 75,   '2026-04-15 14:22:00'),
(3,  1,  8,  NULL, 15,   '2026-05-19 10:00:00'),
(4,  1,  7,  NULL, 10,   '2026-05-19 11:05:00'),
(5,  2,  4,  NULL, 50,   '2026-03-28 10:00:00'),
(6,  2,  4,  NULL, 50,   '2026-04-28 10:00:00'),
(7,  3,  2,  NULL, 75,   '2026-03-05 10:00:00'),
(8,  4,  4,  NULL, 50,   '2026-03-24 11:00:00'),
(9,  5,  1,  NULL, 25,   '2026-03-08 11:30:00'),
(10, 5,  9,  NULL, 40,   '2026-04-20 16:45:00'),
(11, 7,  1,  NULL, 25,   '2026-03-10 08:00:00'),
(12, 7,  8,  NULL, 15,   '2026-05-19 21:00:00'),
(13, 8,  4,  NULL, 50,   '2026-03-28 10:00:00'),
(14, 10, 1,  NULL, 25,   '2026-03-18 17:30:00'),
(15, 10, 9,  NULL, 40,   '2026-04-18 09:00:00'),
(16, 11, 4,  NULL, 50,   '2026-03-19 09:00:00'),
(17, 11, 3,  NULL, 150,  '2026-04-18 09:00:00'),
(18, 11, 8,  NULL, 15,   '2026-05-01 09:00:00'),
(19, 13, 2,  NULL, 75,   '2026-03-20 10:15:00'),
(20, 13, 8,  NULL, 15,   '2026-05-17 15:00:00'),
(21, 15, 1,  NULL, 25,   '2026-03-25 11:00:00'),
(22, 17, 4,  NULL, 50,   '2026-03-28 10:00:00'),
(23, 17, 3,  NULL, 150,  '2026-05-14 14:00:00'),
(24, 22, 4,  NULL, 50,   '2026-03-22 10:00:00'),
(25, 23, 2,  NULL, 75,   '2026-04-08 14:00:00'),
-- bonos por antiguedad
(26, 1,  5,  NULL, 100,  '2022-03-15 00:00:00'),
(27, 2,  5,  NULL, 100,  '2022-07-22 00:00:00'),
(28, 11, 10, NULL, 200,  '2024-01-08 00:00:00'),
-- invitaciones
(29, 1,  6,  11,   200,  '2024-01-08 09:30:00'),
(30, 13, 6,  15,   200,  '2024-12-11 10:30:00');

-- ============================================================
-- ESQUEMA: seguridad
-- ============================================================

INSERT INTO seguridad."Auditoria" (id_auditoria, tabla_afectada, operacion, usuario_db, fecha, detalle_cambio) VALUES
(1,  'finanzas.Bolsillo',    'UPDATE', 'u_app',         '2026-03-01 09:10:00', 'saldo_dinero: 15.50 -> 35.50 | id_linea: 1'),
(2,  'finanzas.Recarga',     'INSERT', 'u_app',         '2026-03-01 09:10:00', 'nueva recarga id:1 monto:20.00 linea:1'),
(3,  'finanzas.Bolsillo',    'UPDATE', 'u_app',         '2026-04-15 14:22:00', 'saldo_dinero: 35.50 -> 85.50 | id_linea: 1'),
(4,  'finanzas.Recarga',     'INSERT', 'u_app',         '2026-04-15 14:22:00', 'nueva recarga id:2 monto:50.00 linea:1'),
(5,  'finanzas.Factura',     'UPDATE', 'u_app',         '2026-03-28 10:00:00', 'estado_pago: Pendiente -> Pagado | id_factura: 1'),
(6,  'finanzas.T_Presta',    'INSERT', 'u_app',         '2026-03-09 20:00:00', 'nuevo prestamo id:1 monto:5.00 linea:1'),
(7,  'finanzas.Bolsillo',    'UPDATE', 'u_app',         '2026-03-09 20:00:05', 'saldo_dinero: 0 -> 5.00 | id_linea: 1 (presta luka)'),
(8,  'comercial.Promocion',  'INSERT', 'u_adan_pereira', '2026-03-31 16:00:00', 'nueva promocion: Doble Carga Abril 2026 id:4'),
(9,  'comercial.Promocion',  'INSERT', 'u_adan_pereira', '2026-04-28 16:00:00', 'nueva promocion: Doble Carga Mayo 2026 id:7'),
(10, 'finanzas.Factura',     'UPDATE', 'u_app',         '2026-03-14 09:00:00', 'estado_pago: Pendiente -> Pagado | id_factura: 10'),
(11, 'finanzas.Factura',     'UPDATE', 'u_app',         '2026-04-28 10:00:00', 'estado_pago: Pendiente -> Pagado | id_factura: 15'),
(12, 'lineas.Linea',         'UPDATE', 'u_app',         '2026-04-05 11:00:00', 'estado: Activo -> Inactivo | id_linea: 19'),
(13, 'finanzas.T_Presta',    'UPDATE', 'u_app',         '2026-04-15 14:23:00', 'estado_cobro: Pendiente -> Cobrado | id_prestamo: 1'),
(14, 'servicios.Consumo',    'INSERT', 'u_app',         '2026-05-19 10:15:00', 'nuevo consumo id:1 tipo:Datos linea:1 cantidad:45.5MB'),
(15, 'servicios.Bolsa_Activa','INSERT','u_app',         '2026-05-19 10:00:00', 'nueva bolsa id:1 paquete:3 linea:1'),
(16, 'comercial.Promocion',  'UPDATE', 'u_adan_pereira', '2026-02-23 16:00:00', 'fecha_fin actualizada en promocion id:2'),
(17, 'finanzas.Factura',     'UPDATE', 'u_app',         '2026-05-14 09:00:00', 'estado_pago: Pendiente -> Pagado | id_factura: 25'),
(18, 'lineas.Linea',         'INSERT', 'u_adan_pereira', '2021-03-15 08:30:00', 'nueva linea id:1 numero:60712345 cliente:1'),
(19, 'comercial.Numero_Amigo','INSERT','u_app',         '2026-02-01 10:00:00', 'nuevo numero amigo id:1 origen:1 destino:5'),
(20, 'finanzas.Transfuzion', 'INSERT', 'u_app',         '2026-03-20 12:00:00', 'transfuzion id:1 origen:1 destino:5 monto:10.00');

INSERT INTO seguridad."Usuario_Sistema" (id_usuario, username, password_hash, id_cliente) VALUES
(1,  'jmamani',     crypt('Viva@2026!Juan',    gen_salt('bf')), 1),
(2,  'mquispe',     crypt('Viva@2026!Maria',   gen_salt('bf')), 2),
(3,  'pvargas',     crypt('Viva@2026!Pedro',   gen_salt('bf')), 3),
(4,  'agutierrez',  crypt('Viva@2026!Ana',     gen_salt('bf')), 4),
(5,  'cmendoza',    crypt('Viva@2026!Carlos',  gen_salt('bf')), 5),
(6,  'rchoque',     crypt('Viva@2026!Rosa',    gen_salt('bf')), 6),
(7,  'laguilar',    crypt('Viva@2026!Luis',    gen_salt('bf')), 7),
(8,  'psalazar',    crypt('Viva@2026!Patri',   gen_salt('bf')), 8),
(9,  'rnina',       crypt('Viva@2026!Rober',   gen_salt('bf')), 9),
(10, 'capaza',      crypt('Viva@2026!Carmen',  gen_salt('bf')), 10),
(11, 'jespinoza',   crypt('Viva@2026!Jorge',   gen_salt('bf')), 11),
(12, 'svedia',      crypt('Viva@2026!Silvia',  gen_salt('bf')), 12),
(13, 'oterceros',   crypt('Viva@2026!Oscar',   gen_salt('bf')), 13),
(14, 'gmontano',    crypt('Viva@2026!Gabi',    gen_salt('bf')), 14),
(15, 'rpanozo',     crypt('Viva@2026!Rodri',   gen_salt('bf')), 15),
(16, 'vtorrez',     crypt('Viva@2026!Vale',    gen_salt('bf')), 16),
(17, 'fcossio',     crypt('Viva@2026!Fer',     gen_salt('bf')), 17),
(18, 'dheredia',    crypt('Viva@2026!Dani',    gen_salt('bf')), 18),
(19, 'psanjinez',   crypt('Viva@2026!Paola',   gen_salt('bf')), 20),
(20, 'kvillanueva', crypt('Viva@2026!Kevin',   gen_salt('bf')), 21),
-- usuarios admin sin id_cliente
(21, 'admin.promo', crypt('AdminPromo!Viva26', gen_salt('bf')), NULL),
(22, 'u.auditor',   crypt('Audit!Viva2026',    gen_salt('bf')), NULL);

-- Re-habilitar triggers (volver al comportamiento normal)
SET session_replication_role = DEFAULT;
