# Tablas Definitivas — VIVA

Este documento presenta el modelo relacional en su versión final con todas las correcciones aplicadas. Es la referencia definitiva para implementación.

## Convenciones

| Símbolo Textual | Significado |
| :--- | :--- |
| **PK** | Clave primaria |
| **FK** | Clave foránea |
| **NOT NULL** | Obligatorio |
| **—** | Nullable (opcional) |

---

### Cliente

| Campo | Tipo | Descripción |
| :--- | :--- | :--- |
| id_cliente | int | **PK** **NOT NULL** Identificador único autoincremental |
| tipo_cliente | varchar(10) | **NOT NULL** NATURAL o EMPRESA |
| nombre | varchar(150) | **NOT NULL** Nombre completo o razón social |
| correo | varchar(100) | **—** Correo de contacto |
| direccion | varchar(200) | **—** Dirección de domicilio o sede |
| telefono_contacto | varchar(20) | **—** Teléfono de contacto |
| fecha_registro | timestamp | **NOT NULL** Base para calcular antigüedad. Default: now() |

### Persona_Natural

| Campo | Tipo | Descripción |
| :--- | :--- | :--- |
| id_cliente | int | **PK** **FK** Cliente **NOT NULL** Hereda PK de Cliente |
| carnet_identidad | varchar(20) | **NOT NULL** CI boliviano |
| genero | varchar(1) | **—** M, F u O |
| fecha_nacimiento | date | **—** Fecha de nacimiento |

### Empresa

| Campo | Tipo | Descripción |
| :--- | :--- | :--- |
| id_cliente | int | **PK** **FK** Cliente **NOT NULL** Hereda PK de Cliente |
| nit | varchar(20) | **NOT NULL** UNIQUE NIT boliviano |
| razon_social | varchar(150) | **NOT NULL** Nombre legal |
| nombre_contacto | varchar(100) | **—** Persona designada por la empresa |
| correo_empresa | varchar(100) | **—** Correo corporativo |

### Plan

| Campo | Tipo | Descripción |
| :--- | :--- | :--- |
| id_plan | int | **PK** **NOT NULL** Identificador autoincremental |
| nombre | varchar(100) | **NOT NULL** Nombre comercial |
| modalidad | varchar(10) | **NOT NULL** PREPAGO o POSTPAGO |
| tipo | varchar(15) | **NOT NULL** INDIVIDUAL o CORPORATIVO |
| precio_mensual | decimal(10,2) | **—** Solo para postpago |
| minutos_incluidos | int | **NOT NULL** Default 0 |
| sms_incluidos | int | **NOT NULL** Default 0 |
| datos_mb | int | **NOT NULL** Default 0 |
| vigencia_dias | int | **NOT NULL** Duración del plan |
| incluye_numero_amigo| boolean | **NOT NULL** Default false |
| activo | boolean | **NOT NULL** Default true |

### Linea

| Campo | Tipo | Descripción |
| :--- | :--- | :--- |
| id_linea | int | **PK** **NOT NULL** Identificador autoincremental |
| numero | varchar(15) | **NOT NULL** UNIQUE Número de teléfono visible |
| id_cliente | int | **FK** Cliente **NOT NULL** Propietario de la línea |
| id_plan | int | **FK** Plan **NOT NULL** Plan actualmente contratado |
| id_sim_activo | int | **FK** SIM_Card **—** SIM en uso. NULL si está de baja. |
| tipo_linea | varchar(10) | **NOT NULL** PREPAGO o POSTPAGO. Sincronizar con Plan.modalidad. |
| fecha_activacion | date | **NOT NULL** Fecha de alta |
| estado | varchar(15) | **NOT NULL** ACTIVA, SUSPENDIDA, RECICLADA o BAJA |
| fecha_reciclaje | date | **—** Fecha de reciclaje. NULL si nunca ocurrió. |
| uso | varchar(10) | **—** PERSONAL, FAMILIAR o LABORAL |

### Linea_Postpago

| Campo | Tipo | Descripción |
| :--- | :--- | :--- |
| id_linea | int | **PK** **FK** Linea **NOT NULL** Hereda PK de Linea |
| dia_facturacion | int | **NOT NULL** Día del mes para generar factura |
| limite_credito | decimal(10,2) | **NOT NULL** Tope de deuda antes de suspensión |
| deuda_actual | decimal(10,2) | **NOT NULL** Deuda del período. Default 0. |

### SIM_Card

| Campo | Tipo | Descripción |
| :--- | :--- | :--- |
| id_sim | int | **PK** **NOT NULL** Identificador autoincremental |
| imsi | varchar(20) | **NOT NULL** UNIQUE ID técnico del chip |
| fecha_fabricacion | date | **—** Fecha de fabricación |
| fecha_activacion | date | **—** Fecha de activación en red |
| fecha_baja | date | **—** Fecha de baja |
| estado | varchar(15) | **NOT NULL** STOCK, ACTIVO, RECICLADO o BAJA |
| lote_fabricacion | varchar(50) | **—** Para rastreo de chips defectuosos |

*Nota: El campo id_linea fue eliminado para romper la referencia circular. Ver manual-correcciones-dbml.md, PASO 1.*

### Equipo

| Campo | Tipo | Descripción |
| :--- | :--- | :--- |
| id_equipo | int | **PK** **NOT NULL** Identificador autoincremental |
| imei | varchar(20) | **NOT NULL** UNIQUE Identificador del teléfono físico |
| marca | varchar(50) | **—** Marca del equipo |
| modelo | varchar(100)| **—** Modelo del equipo |
| estado | varchar(15) | **NOT NULL** ACTIVO, BLOQUEADO o ROBADO |

### Historial_Linea_Equipo

| Campo | Tipo | Descripción |
| :--- | :--- | :--- |
| id_historial | int | **PK** **NOT NULL** Identificador autoincremental |
| id_linea | int | **FK** Linea **NOT NULL** Línea involucrada |
| id_equipo | int | **FK** Equipo **NOT NULL** Equipo físico usado |
| fecha_inicio | timestamp| **NOT NULL** Inicio del uso |
| fecha_fin | timestamp| **—** Fin del uso. NULL si es el activo actual. |

### Bolsillo

| Campo | Tipo | Descripción |
| :--- | :--- | :--- |
| id_linea | int | **PK** **FK** Linea **NOT NULL** Una línea = un bolsillo |
| saldo_regular | decimal(10,2) | **NOT NULL** Dinero recargado. Transferible. Default 0. |
| saldo_promocional | decimal(10,2) | **NOT NULL** Bonificaciones. No transferible. Se consume primero. Default 0. |
| saldo_prestado | decimal(10,2) | **NOT NULL** Deuda por T-Presta. Default 0. |
| prestamo_habilitado| boolean | **NOT NULL** true cuando el cliente tiene 3+ meses. Default false. |

### Paquete

| Campo | Tipo | Descripción |
| :--- | :--- | :--- |
| id_paquete | int | **PK** **NOT NULL** Identificador autoincremental |
| nombre | varchar(100)| **NOT NULL** Nombre comercial |
| categoria | varchar(15) | **NOT NULL** DATOS, VOZ, SMS, APP, STREAMING, MIXTO o LDI |
| precio_bs | decimal(10,2) | **NOT NULL** Precio normal |
| precio_con_puntos | decimal(10,2) | **—** Precio al pagar con puntos BONUS |
| puntos_necesarios | int | **NOT NULL** Puntos requeridos. 0 = no participa en BONUS. |
| mb_datos | int | **NOT NULL** MB incluidos. Default 0. |
| segundos_voz | int | **NOT NULL** Segundos de voz. Default 0. |
| cantidad_sms | int | **NOT NULL** SMS incluidos. Default 0. |
| duracion_horas | int | **NOT NULL** Vigencia desde la compra |
| es_ilimitado | boolean | **NOT NULL** Si true, no combinar con otra bolsa del mismo tipo. Default false. |
| app_destino | varchar(100)| **—** App principal del paquete |
| hora_inicio | time | **—** Para bolsas con horario |
| hora_fin | time | **—** Para bolsas con horario |
| activo | boolean | **NOT NULL** Default true |

### App_Exenta_En_Bolsa

| Campo | Tipo | Descripción |
| :--- | :--- | :--- |
| id_exencion | int | **PK** **NOT NULL** Identificador autoincremental |
| id_paquete | int | **FK** Paquete **NOT NULL** Paquete al que pertenece la exención |
| nombre_app | varchar(100)| **—** Nombre legible (ej: WhatsApp) |
| direccion | varchar(200)| **—** Dominio o IP (ej: *.whatsapp.net) |
| activo | boolean | **NOT NULL** Default true |

### Bolsa_Activa

| Campo | Tipo | Descripción |
| :--- | :--- | :--- |
| id_bolsa_activa | int | **PK** **NOT NULL** Identificador autoincremental |
| id_linea | int | **FK** Linea **NOT NULL** Línea que compró la bolsa |
| id_paquete | int | **FK** Paquete **NOT NULL** Paquete comprado |
| fecha_compra | timestamp| **NOT NULL** Momento de la compra |
| fecha_vencimiento | timestamp| **NOT NULL** Momento de expiración |
| mb_total | int | **NOT NULL** MB originales al comprar. No cambia. Default 0. |
| mb_restantes | int | **NOT NULL** MB disponibles ahora. Default 0. |
| minutos_total | int | **NOT NULL** Minutos originales. No cambia. Default 0. |
| minutos_restantes | int | **NOT NULL** Minutos disponibles ahora. Default 0. |
| estado | varchar(10) | **NOT NULL** ACTIVA, AGOTADA o EXPIRADA |
| forma_de_pago | varchar(15) | **NOT NULL** SALDO_PROMO, SALDO_REGULAR, PUNTOS o MIXTO |
| id_promocion | int | **FK** Promocion **—** Promoción activa al comprar. NULL si ninguna. |

### Recarga

| Campo | Tipo | Descripción |
| :--- | :--- | :--- |
| id_recarga | int | **PK** **NOT NULL** Identificador autoincremental |
| id_linea | int | **FK** Linea **NOT NULL** Línea recargada |
| id_tarjeta | int | **FK** Tarjeta_Recarga **—** NULL si fue recarga digital |
| monto_bs | decimal(10,2) | **NOT NULL** Monto recargado |
| fecha_recarga | timestamp| **NOT NULL** Momento de la recarga |
| canal | varchar(20) | **NOT NULL** TARJETA_FISICA, APP, BANCA_DIGITAL o PUNTO_VENTA |
| saldo_antes | decimal(10,2) | **NOT NULL** Saldo del bolsillo antes de recargar |
| saldo_despues | decimal(10,2) | **NOT NULL** Saldo del bolsillo después de recargar |
| factura_anonima | boolean | **NOT NULL** true = impuestos pagados por VIVA al emitir lote |
| nit_para_factura| varchar(20) | **—** Solo si el cliente pide factura a su nombre |
| id_promocion | int | **FK** Promocion **—** Promoción activa al recargar. NULL si ninguna. |

### Tarjeta_Recarga

| Campo | Tipo | Descripción |
| :--- | :--- | :--- |
| id_tarjeta | int | **PK** **NOT NULL** Identificador autoincremental |
| codigo | varchar(30) | **NOT NULL** UNIQUE Código raspable |
| valor_bs | decimal(10,2) | **NOT NULL** Saldo que otorga |
| estado | varchar(15) | **NOT NULL** DISPONIBLE, USADA o ANULADA |
| fecha_uso | timestamp| **—** NULL si aún no fue canjeada |
| id_linea_cargada| int | **FK** Linea **—** NULL hasta que se canjee |
| nro_factura_lote| varchar(30) | **—** Factura anónima del lote |
| canal_canje | varchar(20) | **—** Cómo fue canjeada |
| nit_cliente | varchar(20) | **—** Solo si se identificó al canjear |

### Consumo

| Campo | Tipo | Descripción |
| :--- | :--- | :--- |
| id_consumo | int | **PK** **NOT NULL** Identificador autoincremental |
| id_linea | int | **FK** Linea **NOT NULL** Línea que consumió |
| id_bolsa_activa | int | **FK** Bolsa_Activa **—** Bolsa cubierta. NULL si fue al saldo. |
| id_factura | int | **FK** Factura **—** NULL para prepago. Se asigna al cerrar período postpago. |
| tipo | varchar(10) | **NOT NULL** DATOS, LLAMADA, SMS o LDI |
| cantidad | decimal(12,3) | **NOT NULL** MB / segundos / unidades según tipo |
| fecha_inicio | timestamp| **NOT NULL** Inicio del evento |
| fecha_fin | timestamp| **—** NULL para SMS instantáneos |
| costo_bs | decimal(10,2) | **NOT NULL** 0 si cubierto por bolsa o app exenta. Default 0. |
| cobrado | boolean | **NOT NULL** false si coincide con App_Exenta_En_Bolsa. Default true. |
| origen_del_cobro| varchar(15) | **—** SALDO_PROMO, SALDO_REGULAR, BOLSA o GRATIS |
| numero_destino | varchar(20) | **—** Número destino de llamada o SMS |
| app_identificada| varchar(100)| **—** Nombre de la app (ej: WhatsApp) |
| dominio_trafico | varchar(200)| **—** Dominio DNS del tráfico |
| ip_destino | varchar(45) | **—** IP de destino |

### T_Presta

| Campo | Tipo | Descripción |
| :--- | :--- | :--- |
| id_prestamo | int | **PK** **NOT NULL** Identificador autoincremental |
| id_linea | int | **FK** Linea **NOT NULL** Línea que solicitó el préstamo |
| monto_bs | decimal(10,2) | **NOT NULL** Solo Bs 2, 5 o 10 |
| intereses_bs | decimal(10,2) | **—** NULL si no aplican |
| fecha_prestamo | timestamp| **NOT NULL** Momento del préstamo |
| fecha_limite_pago| timestamp| **NOT NULL** Fecha máxima de pago |
| estado | varchar(12) | **NOT NULL** PENDIENTE o CANCELADO |

### Transfuzion

| Campo | Tipo | Descripción |
| :--- | :--- | :--- |
| id_transferencia| int | **PK** **NOT NULL** Identificador autoincremental |
| id_linea_origen | int | **FK** Linea **NOT NULL** Línea que transfiere |
| id_linea_destino| int | **FK** Linea **NOT NULL** Línea que recibe |
| monto_bs | decimal(10,2) | **NOT NULL** Mínimo Bs 1.00 |
| fecha | timestamp| **NOT NULL** Momento de la transferencia |

### Factura

| Campo | Tipo | Descripción |
| :--- | :--- | :--- |
| id_factura | int | **PK** **NOT NULL** Identificador autoincremental |
| numero_factura | varchar(30) | **NOT NULL** UNIQUE Número oficial del SIN Bolivia |
| id_linea | int | **FK** Linea_Postpago **NOT NULL** Línea postpago facturada |
| periodo_inicio | date | **NOT NULL** Inicio del período |
| periodo_fin | date | **NOT NULL** Fin del período |
| monto_total | decimal(10,2) | **NOT NULL** Total a pagar |
| fecha_emision | date | **NOT NULL** Fecha de emisión |
| fecha_limite_pago| date | **NOT NULL** Fecha máxima de pago |
| estado | varchar(12) | **NOT NULL** PENDIENTE, PAGADA o VENCIDA |


### Promocion

| Campo | Tipo | Descripción |
| :--- | :--- | :--- |
| id_promocion | int | **PK** **NOT NULL** Identificador autoincremental |
| nombre | varchar(100)| **NOT NULL** Nombre de la campaña |
| tipo | varchar(20) | **NOT NULL** DOBLE_CARGA, BONO_REGALO, DESCUENTO o WOW |
| beneficio | decimal(10,2) | **—** Monto o porcentaje del beneficio |
| fecha_inicio | date | **NOT NULL** Inicio de la campaña |
| fecha_fin | date | **NOT NULL** Fin de la campaña |
| hora_inicio | time | **—** NULL si aplica todo el día |
| hora_fin | time | **—** NULL si aplica todo el día |
| aplica_a | varchar(10) | **NOT NULL** PREPAGO, POSTPAGO o TODOS |
| activa | boolean | **NOT NULL** Default true |

### Puntos_Bonus

| Campo | Tipo | Descripción |
| :--- | :--- | :--- |
| id_linea | int | **PK** **FK** Linea **NOT NULL** Una línea = un saldo de puntos |
| puntos_ganados | int | **NOT NULL** Total histórico. Nunca baja. Default 0. |
| puntos_usados | int | **NOT NULL** Total canjeado. Default 0. |
| ultima_actualizacion | timestamp| **—** Última vez que se modificó |

*Nota: Puntos disponibles = puntos_ganados - puntos_usados. No se almacena.*

### Historial_Puntos

| Campo | Tipo | Descripción |
| :--- | :--- | :--- |
| id_evento | int | **PK** **NOT NULL** Identificador autoincremental |
| id_linea | int | **FK** Linea **NOT NULL** Línea que ganó o canjeó puntos |
| tipo_evento | varchar(20) | **NOT NULL** RECARGA, INVITACION, NAVEGACION_VIVA, PAGO_FACTURA, ANTIGUEDAD o CANJE |
| puntos | int | **NOT NULL** Positivo si ganó, negativo si canjeó |
| id_linea_invitada| int | **FK** Linea **—** Solo si tipo_evento = INVITACION |
| minutos_navegacion| int | **—** Solo si tipo_evento = NAVEGACION_VIVA |
| fecha_hora | timestamp| **NOT NULL** Momento del evento |

### Numero_Amigo

| Campo | Tipo | Descripción |
| :--- | :--- | :--- |
| id_numero_amigo | int | **PK** **NOT NULL** Identificador autoincremental |
| id_linea_origen | int | **FK** Linea **NOT NULL** Línea que activó el servicio |
| id_linea_destino| int | **FK** Linea **NOT NULL** Línea amiga |
| fecha_activacion| timestamp| **NOT NULL** Momento de activación |
| fecha_vencimiento| timestamp| **NOT NULL** 30 días desde la activación |
| costo_bs | decimal(10,2) | **NOT NULL** Precio pagado al activar. Default 5.00. |
| estado | varchar(12) | **NOT NULL** ACTIVO, VENCIDO o CANCELADO |