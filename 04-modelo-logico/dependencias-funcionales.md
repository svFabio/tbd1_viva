# Dependencias Funcionales

A continuación se presenta un resumen compacto de las dependencias funcionales del modelo lógico. Para mayor simplicidad del diseño, la mayoría de las entidades utiliza una clave primaria (PK) simple, por lo que todos sus atributos dependen directamente de ella. 

Las claves alternativas (candidatas pero no escogidas como PK) se denotan como **AK**.

| Entidad | Clave Primaria (PK) | Dependencias Funcionales / Notas |
|---|---|---|
| **Cliente** | `id_cliente` | `id_cliente → tipo_cliente, nombre, correo, direccion, telefono_contacto, fecha_registro` |
| **Persona_Natural** | `id_cliente` | `id_cliente → carnet_identidad, genero, fecha_nacimiento`<br>_Hereda de Cliente._ |
| **Empresa** | `id_cliente` | `id_cliente → nit, razon_social, nombre_contacto, correo_empresa`<br>**AK:** `nit` |
| **Plan** | `id_plan` | `id_plan → nombre, modalidad, tipo, precio_mensual, minutos_incluidos, sms_incluidos, datos_mb, vigencia_dias, incluye_numero_amigo, activo` |
| **Linea** | `id_linea` | `id_linea → numero, id_cliente, id_plan, id_sim_activo, tipo_linea, fecha_activacion, estado, fecha_reciclaje, uso`<br>**AK:** `numero`<br>⚠️ _Redundancia por rendimiento: `id_linea → id_plan → modalidad/tipo_linea`_ |
| **Linea_Postpago** | `id_linea` | `id_linea → dia_facturacion, limite_credito, deuda_actual`<br>_Hereda de Linea._ |
| **SIM_Card** | `id_sim` | `id_sim → imsi, fecha_fabricacion, fecha_activacion, fecha_baja, estado, lote_fabricacion`<br>**AK:** `imsi` |
| **Equipo** | `id_equipo` | `id_equipo → imei, marca, modelo, estado`<br>**AK:** `imei` |
| **Historial_Linea_Equipo**| `id_historial` | `id_historial → id_linea, id_equipo, fecha_inicio, fecha_fin` |
| **Bolsillo** | `id_linea` | `id_linea → saldo_regular, saldo_promocional, saldo_prestado, prestamo_habilitado` |
| **Paquete** | `id_paquete` | `id_paquete → nombre, categoria, precio_bs, precio_con_puntos, puntos_necesarios, mb_datos, segundos_voz, cantidad_sms, duracion_horas, es_ilimitado, app_destino, hora_inicio, hora_fin, activo` |
| **App_Exenta_En_Bolsa**| `id_exencion` | `id_exencion → id_paquete, nombre_app, direccion, activo` |
| **Bolsa_Activa** | `id_bolsa_activa`| `id_bolsa_activa → id_linea, id_paquete, fecha_compra, fecha_vencimiento, mb_total, mb_restantes, minutos_total, minutos_restantes, estado, forma_de_pago, id_promocion` |
| **Recarga** | `id_recarga` | `id_recarga → id_linea, id_tarjeta, monto_bs, fecha_recarga, canal, saldo_antes, saldo_despues, factura_anonima, nit_para_factura, id_promocion` |
| **Tarjeta_Recarga** | `id_tarjeta` | `id_tarjeta → codigo, valor_bs, estado, fecha_uso, id_linea_cargada, nro_factura_lote, canal_canje, nit_cliente`<br>**AK:** `codigo` |
| **Consumo** | `id_consumo` | `id_consumo → id_linea, id_bolsa_activa, id_factura, tipo, cantidad, fecha_inicio, fecha_fin, costo_bs, cobrado, origen_del_cobro, numero_destino, app_identificada, dominio_trafico, ip_destino` |
| **T_Presta** | `id_prestamo` | `id_prestamo → id_linea, monto_bs, intereses_bs, fecha_prestamo, fecha_limite_pago, estado` |
| **Transfuzion** | `id_transferencia`| `id_transferencia → id_linea_origen, id_linea_destino, monto_bs, fecha` |
| **Factura** | `id_factura` | `id_factura → numero_factura, id_linea, periodo_inicio, periodo_fin, monto_total, fecha_emision, fecha_limite_pago, estado`<br>**AK:** `numero_factura` |
| **Transaccion** | `id_transaccion` | `id_transaccion → id_linea, tipo_movimiento, monto_bs, fecha_hora, detalle, id_evento_puntos` |
| **Promocion** | `id_promocion` | `id_promocion → nombre, tipo, beneficio, fecha_inicio, fecha_fin, hora_inicio, hora_fin, aplica_a, activa` |
| **Puntos_Bonus** | `id_linea` | `id_linea → puntos_ganados, puntos_usados, ultima_actualizacion`<br>✓ _`puntos_disponibles` fue eliminado para evitar dependencias transitivas._ |
| **Historial_Puntos** | `id_evento` | `id_evento → id_linea, tipo_evento, puntos, id_linea_invitada, minutos_navegacion, fecha_hora` |
| **Numero_Amigo** | `id_numero_amigo`| `id_numero_amigo → id_linea_origen, id_linea_destino, fecha_activacion, fecha_vencimiento, costo_bs, estado` |