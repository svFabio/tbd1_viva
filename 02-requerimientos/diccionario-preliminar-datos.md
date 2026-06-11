# Diccionario de Datos


## Cliente
| Campo | Tipo | Nulo | Descripción |
|-------|------|------|-------------|
| id_cliente | NUMBER(10) PK | NOT NULL | Identificador único |
| correo | VARCHAR2(100) | NOT NULL | Correo de contacto |
| direccion | VARCHAR2(200) | NULL | Dirección del cliente |
| tel_contacto | VARCHAR2(20) | NOT NULL | Teléfono de contacto |
| fecha_registro | DATE | NOT NULL | Cuándo se registró |
| tipo_cliente | VARCHAR2(20) | NOT NULL | `NATURAL` o `EMPRESA` |
| /antiguedad/ | — | — | Derivado: años desde fecha_registro. No se almacena |

## Persona_Natural
| Campo | Tipo | Nulo | Descripción |
|-------|------|------|-------------|
| id_cliente | NUMBER(10) PK, FK→Cliente | NOT NULL | Mismo ID que Cliente |
| ci | VARCHAR2(20) | NOT NULL | Cédula de identidad |
| nombre | VARCHAR2(50) | NOT NULL | Nombre(s) |
| apellido | VARCHAR2(50) | NOT NULL | Apellido(s) |
| genero | CHAR(1) | NULL | `M` o `F` |
| fecha_nac | DATE | NULL | Fecha de nacimiento |

## Empresa
| Campo | Tipo | Nulo | Descripción |
|-------|------|------|-------------|
| id_cliente | NUMBER(10) PK, FK→Cliente | NOT NULL | Mismo ID que Cliente |
| nit | VARCHAR2(20) | NOT NULL | NIT tributario |
| razon_social | VARCHAR2(150) | NOT NULL | Nombre legal de la empresa |
| nombre_contacto | VARCHAR2(100) | NULL | Persona designada |
| email_corporativo | VARCHAR2(100) | NULL | Correo corporativo |

## Linea
| Campo | Tipo | Nulo | Descripción |
|-------|------|------|-------------|
| id_linea | NUMBER(10) PK | NOT NULL | Identificador único |
| id_cliente | NUMBER(10) FK→Cliente | NOT NULL | Dueño de la línea |
| id_plan | NUMBER(10) FK→Plan | NOT NULL | Plan contratado |
| numero | VARCHAR2(20) | NOT NULL | Número telefónico |
| id_sim_activo | NUMBER(10) FK→SIM_Card | NULL | SIM actualmente instalada |
| tipo_linea | VARCHAR2(20) | NOT NULL | `PREPAGO` o `POSTPAGO` |
| fecha_activacion | DATE | NOT NULL | Cuándo se activó |
| estado | VARCHAR2(20) | NOT NULL | `ACTIVA`, `SUSPENDIDA`, `BAJA`, `EN_RECICLAJE` |
| fecha_reciclaje | DATE | NULL | Cuándo se reciclará el número |
| tipo_plan | VARCHAR2(20) | NULL | Redundante con Plan.modalidad_de_pago. Ver R-07 |

## Linea_Postpago
| Campo | Tipo | Nulo | Descripción |
|-------|------|------|-------------|
| id_linea | NUMBER(10) PK, FK→Linea | NOT NULL | Misma línea |
| dia_facturacion | NUMBER(2) | NOT NULL | Día del mes que se genera la factura |
| limite_credito | NUMBER(10,2) | NOT NULL | Máximo de deuda permitida |
| deuda_actual | NUMBER(10,2) | NOT NULL | Deuda acumulada del período |

## SIM_Card
| Campo | Tipo | Nulo | Descripción |
|-------|------|------|-------------|
| id_sim | NUMBER(10) PK | NOT NULL | Identificador único |
| imsi | VARCHAR2(20) | NOT NULL | Código único del chip |
| fecha_fabricacion | DATE | NULL | Cuándo se fabricó |
| fecha_activacion | DATE | NULL | Cuándo se activó en una línea |
| fecha_baja | DATE | NULL | Cuándo se desactivó |
| estado | VARCHAR2(15) | NOT NULL | `DISPONIBLE`, `ACTIVA`, `INACTIVA`, `DAÑADA` |

## Equipo
| Campo | Tipo | Nulo | Descripción |
|-------|------|------|-------------|
| id_equipo | NUMBER(10) PK | NOT NULL | Identificador único |
| imei | VARCHAR2(20) | NOT NULL | Código único del equipo |
| marca | VARCHAR2(50) | NULL | Marca del celular |
| modelo | VARCHAR2(100) | NULL | Modelo del celular |
| estado | VARCHAR2(20) | NOT NULL | `ACTIVO`, `ROBADO`, `BLOQUEADO` |

## Detalle_Linea_Equipo
| Campo | Tipo | Nulo | Descripción |
|-------|------|------|-------------|
| id_linea_equipo | NUMBER(10) PK | NOT NULL | Identificador |
| id_linea | NUMBER(10) FK→Linea | NOT NULL | Línea involucrada |
| id_equipo | NUMBER(10) FK→Equipo | NOT NULL | Equipo involucrado |
| fecha_asignacion_linea | DATE | NOT NULL | Cuándo se asociaron |
| fecha_baja_de_linea | DATE | NULL | Cuándo se separaron |

## Plan
| Campo | Tipo | Nulo | Descripción |
|-------|------|------|-------------|
| id_plan | NUMBER(10) PK | NOT NULL | Identificador |
| nombre | VARCHAR2(100) | NOT NULL | Nombre del plan |
| modalidad_de_pago | VARCHAR2(20) | NOT NULL | `PREPAGO` o `POSTPAGO` |
| precio_mensual | NUMBER(10,2) | NULL | NULL en prepago |
| minutos_incluido | NUMBER(6) | NOT NULL | Minutos del plan |
| sms_incluidos | NUMBER(6) | NOT NULL | SMS del plan |
| datos_mb | NUMBER(10,2) | NOT NULL | MB del plan |
| vigencia_dias | NUMBER(3) | NOT NULL | Días de validez |
| incluye_numero_amigo | NUMBER(1) | NOT NULL | 1=sí, 0=no |
| activo | NUMBER(1) | NOT NULL | 1=disponible, 0=descontinuado |

## Paquete
| Campo | Tipo | Nulo | Descripción |
|-------|------|------|-------------|
| id_paquete | NUMBER(10) PK | NOT NULL | Identificador |
| nombre | VARCHAR2(100) | NOT NULL | Nombre del paquete |
| categoria | VARCHAR2(20) | NOT NULL | `DATOS`, `VOZ`, `SMS`, `MIXTO` |
| precio_bs | NUMBER(10,2) | NOT NULL | Precio en bolivianos |
| costo_puntos | NUMBER(6) | NULL | Puntos necesarios para canjear |
| activo | NUMBER(1) | NOT NULL | 1=activo |
| mb_datos | NUMBER(10) | NULL | MB incluidos |
| segundos_voz | NUMBER(10) | NULL | Segundos de voz incluidos |
| cantidad_sms | NUMBER(6) | NULL | SMS incluidos |
| vigencia_horas | NUMBER(5) | NOT NULL | Duración en horas desde activación |
| ilimitado | NUMBER(1) | NOT NULL | 1=sin límite de MB/minutos |
| app_destino | VARCHAR2(100) | NULL | App específica si es zero-rating |
| horario_inicio | VARCHAR2(5) | NULL | Hora desde la que aplica (HH:MM) |
| horario_fin | VARCHAR2(5) | NULL | Hora hasta la que aplica (HH:MM) |
| nivel_prioridad | NUMBER(3) | NOT NULL | Mayor número = se consume primero |

## app_incluida_en_bolsa
| Campo | Tipo | Nulo | Descripción |
|-------|------|------|-------------|
| id | NUMBER(10) PK | NOT NULL | Identificador |
| id_paquete | NUMBER(10) FK→Paquete | NOT NULL | Paquete al que pertenece |
| nombre_app | VARCHAR2(100) | NOT NULL | Nombre de la app |
| direccion_app | VARCHAR2(100) | NOT NULL | Dominio de tráfico (ej. whatsapp.com) |
| activo | NUMBER(1) | NOT NULL | 1=exención activa |

## Bolsa_Activa
| Campo | Tipo | Nulo | Descripción |
|-------|------|------|-------------|
| id_suscripcion | NUMBER(10) PK | NOT NULL | Identificador |
| id_linea | NUMBER(10) FK→Linea | NOT NULL | Línea que la compró |
| id_paquete | NUMBER(10) FK→Paquete | NOT NULL | Paquete base |
| fecha_inicio | TIMESTAMP | NOT NULL | Cuándo empezó a correr |
| fecha_fin | TIMESTAMP | NOT NULL | Cuándo vence |
| total_mb_de_bolsa | NUMBER(10) | NULL | MB totales al activar |
| restante_mb_en_bolsa | NUMBER(10) | NULL | MB que quedan |
| minutos_totales | NUMBER(8) | NULL | Minutos totales |
| minutos_restantes | NUMBER(8) | NULL | Minutos que quedan |
| tipo_saldo_cobrado | VARCHAR2(20) | NOT NULL | Cómo se pagó: `SALDO`, `PUNTOS`, `MIXTO` |
| fecha_compra | TIMESTAMP | NOT NULL | Cuándo se compró |

## Bolsillo
| Campo | Tipo | Nulo | Descripción |
|-------|------|------|-------------|
| id_bolsillo | NUMBER(10) PK, FK→Linea | NOT NULL | Mismo ID que la línea |
| id_linea | NUMBER(10) | NOT NULL | FK hacia Linea |
| saldo_regular | NUMBER(10,2) | NOT NULL | Saldo recargado real |
| saldo_promocional | NUMBER(10,2) | NOT NULL | Saldo de bonos y promos |
| saldo_prestado | NUMBER(10,2) | NOT NULL | Deuda del T-Presta activo |
| prestamo_habilitado | NUMBER(1) | NOT NULL | 1=puede pedir T-Presta |

## Recarga
| Campo | Tipo | Nulo | Descripción |
|-------|------|------|-------------|
| id_recarga | NUMBER(10) PK | NOT NULL | Identificador |
| id_linea | NUMBER(10) FK→Linea | NOT NULL | Línea que recargó |
| id_promocion | NUMBER(10) FK→Promocion | NULL | Promo activa al momento (si aplica) |
| id_tarjeta | NUMBER(10) FK→Tarjeta_Recarga | NULL | NULL si fue digital |
| monto_bs | NUMBER(10,2) | NOT NULL | Monto recargado |
| fecha_recarga | TIMESTAMP | NOT NULL | Fecha y hora |
| medio | VARCHAR2(20) | NOT NULL | `TARJETA_FISICA`, `APP`, `BANCA_DIGITAL`, `PUNTO_VENTA` |
| saldo_antes | NUMBER(10,2) | NOT NULL | Saldo justo antes |
| saldo_despues | NUMBER(10,2) | NOT NULL | Saldo justo después |
| nit_factura | VARCHAR2(20) | NULL | NIT si el cliente pidió factura a su nombre |

## Tarjeta_Recarga
| Campo | Tipo | Nulo | Descripción |
|-------|------|------|-------------|
| id_tarjeta | NUMBER(10) PK | NOT NULL | Identificador |
| codigo_tarjeta | VARCHAR2(20) | NOT NULL | Código raspable, único |
| monto_bs | NUMBER(10,2) | NOT NULL | Valor: 10, 20, 50 o 100 |
| estado | VARCHAR2(20) | NOT NULL | `DISPONIBLE`, `USADA`, `ANULADA` |
| nro_factura_anonima | VARCHAR2(30) | NOT NULL | Factura del lote emitida por VIVA |
| fecha_expiracion | DATE | NOT NULL | Fecha hasta la que es válida |

## Transfuzion
| Campo | Tipo | Nulo | Descripción |
|-------|------|------|-------------|
| id_transfusion | NUMBER(10) PK | NOT NULL | Identificador |
| id_linea_origen | NUMBER(10) FK→Linea | NOT NULL | Línea que envía |
| id_linea_destino | NUMBER(10) FK→Linea | NOT NULL | Línea que recibe |
| monto_bs | NUMBER(10,2) | NOT NULL | Monto transferido |
| fecha | TIMESTAMP | NOT NULL | Fecha y hora |

## Doble_Carga
| Campo | Tipo | Nulo | Descripción |
|-------|------|------|-------------|
| id_doble_carga | NUMBER(10) PK | NOT NULL | Identificador |
| id_linea | NUMBER(10) FK→Linea | NOT NULL | Línea habilitada |
| dia_habilitado | DATE | NOT NULL | El día exacto |
| estado | VARCHAR2(10) | NOT NULL | `ACTIVO` o `VENCIDO` |
| fecha_activacion | TIMESTAMP | NOT NULL | Cuándo se habilitó |

## Consumo
| Campo | Tipo | Nulo | Descripción |
|-------|------|------|-------------|
| id_consumo | NUMBER(10) PK | NOT NULL | Identificador |
| id_linea | NUMBER(10) FK→Linea | NOT NULL | Línea que consumió |
| id_Bolsa_Activa | NUMBER(10) FK→Bolsa_Activa | NULL | NULL si se cobró del saldo |
| tipo_consumo | VARCHAR2(20) | NOT NULL | `LLAMADA`, `DATOS`, `SMS` |
| cantidad | NUMBER(10,2) | NOT NULL | Segundos / MB / cantidad de SMS |
| fecha_consumo_inicial | TIMESTAMP | NOT NULL | Inicio del evento |
| fecha_consumo_final | TIMESTAMP | NULL | Fin del evento |
| costo_bs | NUMBER(10,2) | NOT NULL | Costo cobrado. 0 si fue con bolsa o Número Amigo |
| es_cobrado | NUMBER(1) | NOT NULL | 1=se descontó del saldo |
| descuento_saldo | NUMBER(10,2) | NULL | Monto descontado del saldo si aplica |
| numero_destino | VARCHAR2(20) | NULL | Número llamado (solo en LLAMADA) |
| destino_app | VARCHAR2(100) | NULL | App o dominio (solo en DATOS) |

## T_Presta
| Campo | Tipo | Nulo | Descripción |
|-------|------|------|-------------|
| id_prestamo | NUMBER(10) PK | NOT NULL | Identificador |
| id_linea | NUMBER(10) FK→Linea | NOT NULL | Línea que pidió el préstamo |
| monto_bs | NUMBER(10,2) | NOT NULL | Monto prestado |
| fecha_prestamo | TIMESTAMP | NOT NULL | Fecha del préstamo |
| estado_deuda | VARCHAR2(20) | NOT NULL | `PENDIENTE` o `CANCELADO` |

## Numero_Amigo
| Campo | Tipo | Nulo | Descripción |
|-------|------|------|-------------|
| id_numero_amigo | NUMBER(10) PK | NOT NULL | Identificador |
| id_linea_origen | NUMBER(10) FK→Linea | NOT NULL | Línea que activó el servicio |
| id_linea_destino | NUMBER(10) FK→Linea | NOT NULL | Línea amiga |
| fecha_activacion | DATE | NOT NULL | Cuándo se activó |
| fecha_vencimiento | DATE | NULL | Cuándo expira |
| costo_bs | NUMBER(10,2) | NOT NULL | Costo de activación (Bs 5) |
| estado | VARCHAR2(20) | NOT NULL | `ACTIVO` o `VENCIDO` |

## Promocion
| Campo | Tipo | Nulo | Descripción |
|-------|------|------|-------------|
| id_promocion | NUMBER(10) PK | NOT NULL | Identificador |
| nombre | VARCHAR2(100) | NOT NULL | Nombre de la promo |
| tipo | VARCHAR2(200) | NOT NULL | `DOBLE_CARGA`, `PORCENTAJE_EXTRA`, etc. |
| valor_beneficio | NUMBER(10,2) | NOT NULL | Ej: 100 = 100% extra |
| fecha_inicio | DATE | NOT NULL | Inicio de la campaña |
| fecha_fin | DATE | NOT NULL | Fin de la campaña |
| horario_inicio | VARCHAR2(5) | NULL | Hora de inicio (HH:MM) |
| horario_fin | VARCHAR2(5) | NULL | Hora de fin (HH:MM) |
| activa | NUMBER(1) | NOT NULL | 1=activa ahora |

## factura
| Campo | Tipo | Nulo | Descripción |
|-------|------|------|-------------|
| id_factura | NUMBER(10) PK | NOT NULL | Identificador |
| numero_factura | VARCHAR2(20) | NOT NULL | Número de referencia |
| id_linea | NUMBER(10) FK→Linea_Postpago | NOT NULL | Línea postpago |
| periodo_inicio | DATE | NOT NULL | Inicio del período facturado |
| periodo_fin | DATE | NOT NULL | Fin del período |
| monto_total | NUMBER(10,2) | NOT NULL | Precio del plan en ese período |
| fecha_emision | DATE | NOT NULL | Cuándo se generó |
| fecha_vencimiento | DATE | NOT NULL | Fecha límite de pago |
| estado | VARCHAR2(20) | NOT NULL | `PENDIENTE`, `PAGADA`, `VENCIDA` |

## Puntos_Bonus
| Campo | Tipo | Nulo | Descripción |
|-------|------|------|-------------|
| id_puntos | NUMBER(10) PK | NOT NULL | Identificador |
| id_linea | NUMBER(10) FK→Linea | NOT NULL | Línea a la que pertenecen |
| puntos_acumulados | NUMBER(10) | NOT NULL | Total ganado históricamente |
| puntos_canjeados | NUMBER(10) | NOT NULL | Total usado |
| puntos_disponibles | NUMBER(10) | NOT NULL | Derivado: acumulados − canjeados |
| ultima_actualizacion | TIMESTAMP | NOT NULL | Última vez que se actualizó |

## Evento_bonus
| Campo | Tipo | Nulo | Descripción |
|-------|------|------|-------------|
| id_evento | NUMBER(10) PK | NOT NULL | Identificador |
| id_linea | NUMBER(10) FK→Linea | NOT NULL | Línea que ganó puntos |
| tipo_evento | VARCHAR2(20) | NOT NULL | `RECARGA`, `NAVEGACION`, `REFERIDO` |
| puntos_otorgados | NUMBER(6) | NOT NULL | Cuántos puntos se dieron |
| id_linea_referido | NUMBER(10) FK→Linea | NULL | Línea referida (solo en REFERIDO) |
| minutos_navegacion | NUMBER(8) | NULL | Minutos navegados (solo en NAVEGACION) |