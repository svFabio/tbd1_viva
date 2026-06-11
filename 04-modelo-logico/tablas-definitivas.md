### T_Presta
* id_prestamo PK (int)
* id_linea (int)
* monto_bs (decimal(10,2))
* fecha_prestamo (datetime)
* estado_deuda (varchar(20))

### Detalle_Linea_Equipo
* id_linea_equipo PK (int)
* id_linea FK (int)
* id_equipo FK (int)
* fecha_asignacion_linea (date)
* fecha_baja_de_linea (date)

### Linea
* id_linea PK (int)
* id_cliente FK (int)
* id_plan FK (int)
* numero (varchar(20))
* id_sim_activo FK (int)
* tipo_linea (varchar(20))
* fecha_activacion (date)
* estado (varchar(20))
* fecha_reciclaje (date)
* tipo_plan (varchar(20))

### Equipo
* id_equipo PK (int)
* imei (varchar(20))
* marca (varchar(50))
* modelo (varchar(100))
* estado (varchar(20))

### Bolsa_Activa
* id_suscripcion PK (int)
* id_linea FK (int)
* id_paquete FK (int)
* fecha_inicio (datetime)
* fecha_fin (datetime)
* total_mb_de_bolsa (int)
* restante_mb_en_bolsa (int)
* minutos_totales (int)
* minutos_restantes (int)
* tipo_saldo_cobrado (varchar(20))
* fecha_compra (datetime)

### Bolsillo
* id_bolsillo PK, FK (int)
* id_linea (int)
* saldo_regular (decimal(10,2))
* saldo_promocional (decimal(10,2))
* saldo_prestado (decimal(10,2))
* prestamo_habilitado (boolean)

### Doble_Carga
* id_doble_carga PK (int)
* id_linea FK (int)
* dia_habilitado (date)
* estado (varchar(10))
* fecha_activacion (datetime)

### Puntos_Bonus
* id_puntos PK (int)
* id_linea FK (int)
* puntos_acumulados (int)
* puntos_canjeados (int)
* puntos_disponibles (int)
* ultima_actualizacion (datetime)

### Cliente
* id_cliente PK (int)
* correo (varchar(100))
* direccion (varchar(200))
* tel_contacto (varchar(20))
* fecha_registro (date)
* tipo_cliente (varchar(20))
* /antiguedad/ (int)

### Plan
* id_plan PK (int)
* nombre (varchar(100))
* modalidad_de_pago (varchar(20))
* precio_mensual (decimal(10,2))
* minutos_incluido (int)
* sms_incluidos (int)
* datos_mb (decimal(10,2))
* vigencia_dias (int)
* incluye_numero_amigo (boolean)
* activo (boolean)

### Empresa
* id_cliente PK, FK (int)
* nit (varchar(20))
* razon_social (varchar(150))
* nombre_contacto (varchar(100))
* email_corporativo (varchar(100))

### Paquete
* id_paquete PK (int)
* nombre (varchar(100))
* categoria (varchar(20))
* precio_bs (decimal(10,2))
* costo_puntos (int)
* activo (boolean)
* mb_datos (int)
* segundos_voz (int)
* cantidad_sms (int)
* vigencia_horas (int)
* ilimitado (boolean)
* app_destino (varchar(100))
* horario_inicio (time)
* horario_fin (time)
* nivel_prioridad (int)

### Transfuzion
* id_transfusion PK (int)
* id_linea_origen FK (int)
* id_linea_destino FK (int)
* monto_bs (decimal(10,2))
* fecha (datetime)

### Linea_Postpago
* id_linea PK, FK (int)
* dia_facturacion (int)
* limite_credito (decimal(10,2))
* deuda_actual (decimal(10,2))

### Consumo
* id_consumo PK (int)
* id_linea FK (int)
* id_Bolsa_Activa FK (int)
* tipo_consumo (varchar(20))
* cantidad (decimal(10,2))
* fecha_consumo_inicial (datetime)
* fecha_consumo_final (datetime)
* costo_bs (decimal(10,2))
* es_cobrado (boolean)
* descuento_saldo (decimal(10,2))
* numero_destino (varchar(20))
* destino_app (varchar(100))

### Promocion
* id_promocion PK (int)
* nombre (varchar(100))
* tipo (varchar(200))
* valor_beneficio (decimal(10,2))
* fecha_inicio (date)
* fecha_fin (date)
* horario_inicio (time)
* horario_fin (time)
* activa (boolean)

### Recarga
* id_recarga PK (int)
* id_linea FK (int)
* id_promocion FK (int)
* id_tarjeta FK (int)
* monto_bs (decimal(10,2))
* fecha_recarga (datetime)
* medio (varchar(20))
* saldo_antes (decimal(10,2))
* saldo_despues (decimal(10,2))
* nit_factura (varchar(20))

### Evento_bonus
* id_evento PK (int)
* id_linea FK (int)
* tipo_evento (varchar(20))
* puntos_otorgados (int)
* id_linea_referido FK (int)
* minutos_navegacion (int)

### SIM_Card
* id_sim PK (int(11))
* imsi (varchar(20))
* fecha_fabricacion (date)
* fecha_activacion (date)
* fecha_baja (date)
* estado (varchar(15))

### factura
* id_factura PK (int)
* numero_factura (varchar(20))
* id_linea (int)
* periodo_inicio (date)
* periodo_fin (date)
* monto_total (decimal(10,2))
* fecha_emision (date)
* fecha_vencimiento (date)
* estado (varchar(20))

### Numero_Amigo
* id_numero_amigo PK (int)
* id_linea_origen FK (int)
* id_linea_destino FK (int)
* fecha_activacion (date)
* fecha_vencimiento (date)
* costo_bs (decimal(10,2))
* estado (varchar(20))

### Persona_Natural
* id_cliente PK, FK (int)
* ci (varchar(20))
* nombre (varchar(50))
* apellido (varchar(50))
* genero (char(1))
* fecha_nac (date)

### app_incluida_en_bolsa
* id PK (int)
* id_paquete FK (int)
* nombre_app (varchar(100))
* direccion_app (varchar(100))
* activo (boolean)

### Tarjeta_Recarga
* id_tarjeta PK (int)
* codigo_tarjeta (varchar(20))
* monto_bs (decimal(10,2))
* estado (varchar(20))
* nro_factura_anonima (varchar(30))
* fecha_expiracion (date)