# Dependencias Funcionales

A continuación se presenta un resumen compacto de las dependencias funcionales del modelo lógico basado estrictamente en el esquema actual. La mayoría de las entidades utiliza una clave primaria (PK) simple, por lo que todos sus atributos dependen directamente de ella. 

Las claves alternativas (candidatas pero no escogidas como PK) se denotan como **AK**.

| Entidad | Clave Primaria (PK) | Dependencias Funcionales / Notas |
| :--- | :--- | :--- |
| **Cliente** | `id_cliente` | `id_cliente` → correo, direccion, tel_contacto, fecha_registro, tipo_cliente, /antiguedad/ |
| **Persona_Natural** | `id_cliente` | `id_cliente` → ci, nombre, apellido, genero, fecha_nac<br>*(Hereda de Cliente)* |
| **Empresa** | `id_cliente` | `id_cliente` → nit, razon_social, nombre_contacto, email_corporativo<br>**AK:** `nit` *(Hereda de Cliente)* |
| **Plan** | `id_plan` | `id_plan` → nombre, modalidad_de_pago, precio_mensual, minutos_incluido, sms_incluidos, datos_mb, vigencia_dias, incluye_numero_amigo, activo |
| **Linea** | `id_linea` | `id_linea` → id_cliente, id_plan, numero, id_sim_activo, tipo_linea, fecha_activacion, estado, fecha_reciclaje, tipo_plan<br>**AK:** `numero` |
| **Linea_Postpago** | `id_linea` | `id_linea` → dia_facturacion, limite_credito, deuda_actual<br>*(Hereda de Linea)* |
| **SIM_Card** | `id_sim` | `id_sim` → imsi, fecha_fabricacion, fecha_activacion, fecha_baja, estado<br>**AK:** `imsi` |
| **Equipo** | `id_equipo` | `id_equipo` → imei, marca, modelo, estado<br>**AK:** `imei` |
| **Detalle_Linea_Equipo** | `id_linea_equipo` | `id_linea_equipo` → id_linea, id_equipo, fecha_asignacion_linea, fecha_baja_de_linea |
| **Bolsillo** | `id_bolsillo` | `id_bolsillo` → id_linea, saldo_regular, saldo_promocional, saldo_prestado, prestamo_habilitado |
| **Paquete** | `id_paquete` | `id_paquete` → nombre, categoria, precio_bs, costo_puntos, activo, mb_datos, segundos_voz, cantidad_sms, vigencia_horas, ilimitado, app_destino, horario_inicio, horario_fin, nivel_prioridad |
| **app_incluida_en_bolsa** | `id` | `id` → id_paquete, nombre_app, direccion_app, activo |
| **Bolsa_Activa** | `id_suscripcion` | `id_suscripcion` → id_linea, id_paquete, fecha_inicio, fecha_fin, total_mb_de_bolsa, restante_mb_en_bolsa, minutos_totales, minutos_restantes, tipo_saldo_cobrado, fecha_compra |
| **Recarga** | `id_recarga` | `id_recarga` → id_linea, id_promocion, id_tarjeta, monto_bs, fecha_recarga, medio, saldo_antes, saldo_despues, nit_factura |
| **Tarjeta_Recarga** | `id_tarjeta` | `id_tarjeta` → codigo_tarjeta, monto_bs, estado, nro_factura_anonima, fecha_expiracion<br>**AK:** `codigo_tarjeta` |
| **Consumo** | `id_consumo` | `id_consumo` → id_linea, id_Bolsa_Activa, tipo_consumo, cantidad, fecha_consumo_inicial, fecha_consumo_final, costo_bs, es_cobrado, descuento_saldo, numero_destino, destino_app |
| **T_Presta** | `id_prestamo` | `id_prestamo` → id_linea, monto_bs, fecha_prestamo, estado_deuda |
| **Transfuzion** | `id_transfusion` | `id_transfusion` → id_linea_origen, id_linea_destino, monto_bs, fecha |
| **factura** | `id_factura` | `id_factura` → numero_factura, id_linea, periodo_inicio, periodo_fin, monto_total, fecha_emision, fecha_vencimiento, estado<br>**AK:** `numero_factura` |
| **Promocion** | `id_promocion` | `id_promocion` → nombre, tipo, valor_beneficio, fecha_inicio, fecha_fin, horario_inicio, horario_fin, activa |
| **Doble_Carga** | `id_doble_carga` | `id_doble_carga` → id_linea, dia_habilitado, estado, fecha_activacion |
| **Puntos_Bonus** | `id_puntos` | `id_puntos` → id_linea, puntos_acumulados, puntos_canjeados, puntos_disponibles, ultima_actualizacion |
| **Evento_bonus** | `id_evento` | `id_evento` → id_linea, tipo_evento, puntos_otorgados, id_linea_referido, minutos_navegacion |
| **Numero_Amigo** | `id_numero_amigo` | `id_numero_amigo` → id_linea_origen, id_linea_destino, fecha_activacion, fecha_vencimiento, costo_bs, estado |