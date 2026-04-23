# Esquema Relacional v1 — VIVA

## Convenciones

| Símbolo | Significado |
| :--- | :--- |
| **PK** | Clave primaria (PK) |
| **FK** | Clave foránea (FK) |
| **Req** | Obligatorio (NOT NULL) |
| **Opc** | Opcional (puede estar vacío) |

---

## GRUPO 1 — Clientes

**Cliente**
| Atributo | PK | FK | Req | Opc | Apunta a |
| :--- | :---: | :---: | :---: | :---: | :--- |
| id_cliente | PK | | Req | | |
| tipo_cliente | | | Req | | |
| nombre | | | Req | | |
| correo | | | | Opc | |
| direccion | | | | Opc | |
| telefono_contacto | | | | Opc | |
| fecha_registro | | | Req | | |

**Persona_Natural**
| Atributo | PK | FK | Req | Opc | Apunta a |
| :--- | :---: | :---: | :---: | :---: | :--- |
| id_cliente | PK | FK | Req | | Cliente |
| carnet_identidad | | | Req | | |
| genero | | | | Opc | |
| fecha_nacimiento | | | | Opc | |

**Empresa**
| Atributo | PK | FK | Req | Opc | Apunta a |
| :--- | :---: | :---: | :---: | :---: | :--- |
| id_cliente | PK | FK | Req | | Cliente |
| nit | | | Req | | |
| razon_social | | | Req | | |
| nombre_contacto | | | | Opc | |
| correo_empresa | | | | Opc | |

---

## GRUPO 2 — Planes

**Plan**
| Atributo | PK | FK | Req | Opc | Apunta a |
| :--- | :---: | :---: | :---: | :---: | :--- |
| id_plan | PK | | Req | | |
| nombre | | | Req | | |
| modalidad | | | Req | | |
| tipo | | | Req | | |
| precio_mensual | | | | Opc | |
| minutos_incluidos | | | Req | | |
| sms_incluidos | | | Req | | |
| datos_mb | | | Req | | |
| vigencia_dias | | | Req | | |
| incluye_numero_amigo | | | Req | | |
| activo | | | Req | | |

---

## GRUPO 3 — Líneas Telefónicas

**Linea**
| Atributo | PK | FK | Req | Opc | Apunta a |
| :--- | :---: | :---: | :---: | :---: | :--- |
| id_linea | PK | | Req | | |
| numero | | | Req | | |
| id_cliente | | FK | Req | | Cliente |
| id_plan | | FK | Req | | Plan |
| id_sim_activo | | FK | | Opc | SIM_Card |
| tipo_linea | | | Req | | |
| fecha_activacion | | | Req | | |
| estado | | | Req | | |
| fecha_reciclaje | | | | Opc | |
| uso | | | | Opc | |

**Linea_Postpago**
| Atributo | PK | FK | Req | Opc | Apunta a |
| :--- | :---: | :---: | :---: | :---: | :--- |
| id_linea | PK | FK | Req | | Linea |
| dia_facturacion | | | Req | | |
| limite_credito | | | Req | | |
| deuda_actual | | | Req | | |

---

## GRUPO 4 — SIM Cards y Equipos

**SIM_Card**
| Atributo | PK | FK | Req | Opc | Apunta a |
| :--- | :---: | :---: | :---: | :---: | :--- |
| id_sim | PK | | Req | | |
| imsi | | | Req | | |
| fecha_fabricacion | | | | Opc | |
| fecha_activacion | | | | Opc | |
| fecha_baja | | | | Opc | |
| estado | | | Req | | |
| lote_fabricacion | | | | Opc | |

**Equipo**
| Atributo | PK | FK | Req | Opc | Apunta a |
| :--- | :---: | :---: | :---: | :---: | :--- |
| id_equipo | PK | | Req | | |
| imei | | | Req | | |
| marca | | | | Opc | |
| modelo | | | | Opc | |
| estado | | | Req | | |

**Historial_Linea_Equipo**
| Atributo | PK | FK | Req | Opc | Apunta a |
| :--- | :---: | :---: | :---: | :---: | :--- |
| id_historial | PK | | Req | | |
| id_linea | | FK | Req | | Linea |
| id_equipo | | FK | Req | | Equipo |
| fecha_inicio | | | Req | | |
| fecha_fin | | | | Opc | |

---

## GRUPO 5 — Saldo

**Bolsillo**
| Atributo | PK | FK | Req | Opc | Apunta a |
| :--- | :---: | :---: | :---: | :---: | :--- |
| id_linea | PK | FK | Req | | Linea |
| saldo_regular | | | Req | | |
| saldo_promocional | | | Req | | |
| saldo_prestado | | | Req | | |
| prestamo_habilitado | | | Req | | |

---

## GRUPO 6 — Paquetes y Bolsas

**Paquete**
| Atributo | PK | FK | Req | Opc | Apunta a |
| :--- | :---: | :---: | :---: | :---: | :--- |
| id_paquete | PK | | Req | | |
| nombre | | | Req | | |
| categoria | | | Req | | |
| precio_bs | | | Req | | |
| precio_con_puntos | | | | Opc | |
| puntos_necesarios | | | Req | | |
| mb_datos | | | Req | | |
| segundos_voz | | | Req | | |
| cantidad_sms | | | Req | | |
| duracion_horas | | | Req | | |
| es_ilimitado | | | Req | | |
| app_destino | | | | Opc | |
| hora_inicio | | | | Opc | |
| hora_fin | | | | Opc | |
| activo | | | Req | | |

**App_Exenta_En_Bolsa**
| Atributo | PK | FK | Req | Opc | Apunta a |
| :--- | :---: | :---: | :---: | :---: | :--- |
| id_exencion | PK | | Req | | |
| id_paquete | | FK | Req | | Paquete |
| nombre_app | | | | Opc | |
| direccion | | | | Opc | |
| activo | | | Req | | |

**Bolsa_Activa**
| Atributo | PK | FK | Req | Opc | Apunta a |
| :--- | :---: | :---: | :---: | :---: | :--- |
| id_bolsa_activa | PK | | Req | | |
| id_linea | | FK | Req | | Linea |
| id_paquete | | FK | Req | | Paquete |
| fecha_compra | | | Req | | |
| fecha_vencimiento | | | Req | | |
| mb_total | | | Req | | |
| mb_restantes | | | Req | | |
| minutos_total | | | Req | | |
| minutos_restantes | | | Req | | |
| estado | | | Req | | |
| forma_de_pago | | | Req | | |
| id_promocion | | FK | | Opc | Promocion |

---

## GRUPO 7 — Transacciones

**Recarga**
| Atributo | PK | FK | Req | Opc | Apunta a |
| :--- | :---: | :---: | :---: | :---: | :--- |
| id_recarga | PK | | Req | | |
| id_linea | | FK | Req | | Linea |
| id_tarjeta | | FK | | Opc | Tarjeta_Recarga |
| monto_bs | | | Req | | |
| fecha_recarga | | | Req | | |
| canal | | | Req | | |
| saldo_antes | | | Req | | |
| saldo_despues | | | Req | | |
| factura_anonima | | | Req | | |
| nit_para_factura | | | | Opc | |
| id_promocion | | FK | | Opc | Promocion |

**Tarjeta_Recarga**
| Atributo | PK | FK | Req | Opc | Apunta a |
| :--- | :---: | :---: | :---: | :---: | :--- |
| id_tarjeta | PK | | Req | | |
| codigo | | | Req | | |
| valor_bs | | | Req | | |
| estado | | | Req | | |
| fecha_uso | | | | Opc | |
| nro_factura_lote | | | | Opc | |

**Consumo**
| Atributo | PK | FK | Req | Opc | Apunta a |
| :--- | :---: | :---: | :---: | :---: | :--- |
| id_consumo | PK | | Req | | |
| id_linea | | FK | Req | | Linea |
| id_bolsa_activa | | FK | | Opc | Bolsa_Activa |
| tipo | | | Req | | |
| cantidad | | | Req | | |
| fecha_inicio | | | Req | | |
| fecha_fin | | | | Opc | |
| costo_bs | | | Req | | |
| cobrado | | | Req | | |
| origen_del_cobro | | | | Opc | |
| numero_destino | | | | Opc | |
| app_identificada | | | | Opc | |
| dominio_trafico | | | | Opc | |
| ip_destino | | | | Opc | |

**T_Presta**
| Atributo | PK | FK | Req | Opc | Apunta a |
| :--- | :---: | :---: | :---: | :---: | :--- |
| id_prestamo | PK | | Req | | |
| id_linea | | FK | Req | | Linea |
| monto_bs | | | Req | | |
| intereses_bs | | | | Opc | |
| fecha_prestamo | | | Req | | |
| fecha_limite_pago | | | Req | | |
| estado | | | Req | | |

**Transfuzion**
| Atributo | PK | FK | Req | Opc | Apunta a |
| :--- | :---: | :---: | :---: | :---: | :--- |
| id_transferencia | PK | | Req | | |
| id_linea_origen | | FK | Req | | Linea |
| id_linea_destino | | FK | Req | | Linea |
| monto_bs | | | Req | | |
| fecha | | | Req | | |

**Factura**
| Atributo | PK | FK | Req | Opc | Apunta a |
| :--- | :---: | :---: | :---: | :---: | :--- |
| id_factura | PK | | Req | | |
| numero_factura | | | Req | | |
| id_linea | | FK | Req | | Linea_Postpago |
| periodo_inicio | | | Req | | |
| periodo_fin | | | Req | | |
| monto_total | | | Req | | |
| fecha_emision | | | Req | | |
| fecha_limite_pago | | | Req | | |
| estado | | | Req | | |

**Transaccion**
| Atributo | PK | FK | Req | Opc | Apunta a |
| :--- | :---: | :---: | :---: | :---: | :--- |
| id_transaccion | PK | | Req | | |
| id_linea | | FK | Req | | Linea |
| tipo_movimiento | | | Req | | |
| monto_bs | | | | Opc | |
| fecha_hora | | | Req | | |
| detalle | | | | Opc | |
| id_evento_puntos | | FK | | Opc | Historial_Puntos |

**Promocion**
| Atributo | PK | FK | Req | Opc | Apunta a |
| :--- | :---: | :---: | :---: | :---: | :--- |
| id_promocion | PK | | Req | | |
| nombre | | | Req | | |
| tipo | | | Req | | |
| beneficio | | | | Opc | |
| fecha_inicio | | | Req | | |
| fecha_fin | | | Req | | |
| hora_inicio | | | | Opc | |
| hora_fin | | | | Opc | |
| aplica_a | | | Req | | |
| activa | | | Req | | |

---

## GRUPO 8 — Fidelización

**Puntos_Bonus**
| Atributo | PK | FK | Req | Opc | Apunta a |
| :--- | :---: | :---: | :---: | :---: | :--- |
| id_linea | PK | FK | Req | | Linea |
| puntos_ganados | | | Req | | |
| puntos_usados | | | Req | | |
| ultima_actualizacion | | | | Opc | |

**Historial_Puntos**
| Atributo | PK | FK | Req | Opc | Apunta a |
| :--- | :---: | :---: | :---: | :---: | :--- |
| id_evento | PK | | Req | | |
| id_linea | | FK | Req | | Linea |
| tipo_evento | | | Req | | |
| puntos | | | Req | | |
| id_linea_invitada | | FK | | Opc | Linea |
| minutos_navegacion | | | | Opc | |
| fecha_hora | | | Req | | |

**Numero_Amigo**
| Atributo | PK | FK | Req | Opc | Apunta a |
| :--- | :---: | :---: | :---: | :---: | :--- |
| id_numero_amigo | PK | | Req | | |
| id_linea_origen | | FK | Req | | Linea |
| id_linea_destino | | FK | Req | | Linea |
| fecha_activacion | | | Req | | |
| fecha_vencimiento | | | Req | | |
| costo_bs | | | Req | | |
| estado | | | Req | | |

---

## Resumen general

| Métrica | Valor |
| :--- | :--- |
| Total de tablas | 22 |
| Tablas con herencia 1:1 | 5 |
| Tablas de relación N:M | 3 |
| Tablas de log y auditoría | 2 |
| Total de claves foráneas | 31 |