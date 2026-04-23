# Reglas del Negocio

Estas son las reglas que el sistema DEBE respetar. Si alguna se rompe, los datos pierden sentido.

---

**RN-01 — T-Presta: condiciones de habilitación**
Una línea solo puede pedir préstamo si tiene al menos 3 meses desde su activación Y no tiene ningún T-Presta con estado_deuda = PENDIENTE.

**RN-02 — T-Presta: cobro automático**
Cuando el cliente recarga, si tiene saldo_prestado > 0, el sistema descuenta primero la deuda y solo acredita el restante al saldo regular.

**RN-03 — Orden de consumo de saldo**
El saldo se consume en este orden: primero saldo_promocional, luego saldo_regular. El saldo_prestado se cobra al recargar.

**RN-04 — Doble Carga**
El bono de la doble carga va siempre al saldo_promocional, no al regular. El saldo_regular solo recibe el monto real recargado.

**RN-05 — Bolsas y prioridad**
Si hay varias bolsas activas, se consume primero la de mayor nivel_prioridad en Paquete. El backend decide; la BD solo guarda el estado resultante.

**RN-06 — Número Amigo: verificación**
Al registrar un consumo de llamada, si existe un Numero_Amigo activo con ese destino, costo_bs = 0 y es_cobrado = false.

**RN-07 — Factura postpago**
Se genera una factura por período mensual para cada Linea_Postpago. El monto es el precio_mensual del plan contratado, no la suma de consumos.

**RN-08 — SIM Card: una activa por línea**
Linea.id_sim_activo siempre apunta a una SIM con estado = ACTIVA. El historial de SIMs anteriores no se modela en esta versión.

**RN-09 — Tarjeta Recarga: valores fijos**
Los montos permitidos son Bs 10, 20, 50 y 100. Cualquier otro valor es inválido. La validación es responsabilidad del backend.

**RN-10 — Puntos BONUS: ganancia**
Los puntos se ganan por recargas, navegación y referidos. Cada tipo de evento queda registrado en Evento_bonus con su tipo y puntos otorgados.

**RN-11 — Transfuzión: restricciones**
Solo se puede transferir saldo entre líneas VIVA. El monto debe ser mayor a 0. El límite diario lo controla el backend.

**RN-12 — Estado de línea**
Una línea puede estar en: ACTIVA, SUSPENDIDA, BAJA o EN_RECICLAJE. Solo las líneas ACTIVAS pueden hacer recargas, consumos y préstamos.

**RN-13 — Cliente: discriminador**
Cliente.tipo_cliente puede ser NATURAL o EMPRESA. Determina en qué tabla subtipo buscar los datos específicos del cliente.

**RN-14 — Bolsillo: una sola fila**
Cada línea tiene exactamente una fila en Bolsillo. Se crea al activar la línea y solo se actualiza (UPDATE), nunca se inserta una segunda vez.