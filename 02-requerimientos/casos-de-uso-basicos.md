# Casos de Uso Básicos

¿Qué puede hacer cada actor con el sistema?

---

## Actor: Cliente

| CU | Acción | Tablas involucradas |
|----|--------|---------------------|
| CU-01 | Recargar saldo con tarjeta física | Recarga, Tarjeta_Recarga, Bolsillo |
| CU-02 | Recargar saldo por app | Recarga, Bolsillo, Promocion |
| CU-03 | Pedir T-Presta | T_Presta, Bolsillo |
| CU-04 | Comprar un paquete de datos | Bolsa_Activa, Paquete, Bolsillo |
| CU-05 | Transferir saldo a otra línea | Transfuzion, Bolsillo |
| CU-06 | Activar Número Amigo | Numero_Amigo, Bolsillo |
| CU-07 | Ver su saldo | Bolsillo |
| CU-08 | Ver su historial de recargas | Recarga |
| CU-09 | Canjear puntos por un paquete | Puntos_Bonus, Bolsa_Activa |
| CU-10 | Ver su factura mensual (postpago) | factura |

---

## Actor: Sistema (backend automático)

| CU | Acción | Tablas involucradas |
|----|--------|---------------------|
| CU-11 | Registrar un consumo de datos | Consumo, Bolsa_Activa, Bolsillo |
| CU-12 | Registrar una llamada | Consumo, Numero_Amigo, Bolsillo |
| CU-13 | Generar factura mensual postpago | factura, Linea_Postpago, Plan |
| CU-14 | Descontar deuda al recargar | T_Presta, Recarga, Bolsillo |
| CU-15 | Otorgar puntos por recarga | Evento_bonus, Puntos_Bonus |
| CU-16 | Vencer bolsa activa expirada | Bolsa_Activa |

---

## Actor: Agente VIVA

| CU | Acción | Tablas involucradas |
|----|--------|---------------------|
| CU-17 | Registrar un cliente nuevo | Cliente, Persona_Natural / Empresa |
| CU-18 | Activar una línea | Linea, Bolsillo, SIM_Card |
| CU-19 | Cambiar SIM Card | SIM_Card, Linea |
| CU-20 | Registrar un equipo | Equipo, Detalle_Linea_Equipo |
| CU-21 | Dar de baja una línea | Linea (update estado) |