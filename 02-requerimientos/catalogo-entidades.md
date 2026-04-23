# Catálogo de Entidades

Una línea por entidad: qué es, para qué existe y qué tiene.

---

## Clientes

**Cliente** — Base común de todos los clientes. Tiene correo, teléfono, dirección y tipo (NATURAL o EMPRESA).

**Persona_Natural** — Subtipo de Cliente. Agrega CI, nombre, apellido, género y fecha de nacimiento.

**Empresa** — Subtipo de Cliente. Agrega NIT, razón social, contacto designado y correo corporativo.

---

## Líneas y SIM

**Linea** — El número telefónico. Pertenece a un cliente, tiene un plan, una SIM activa y un estado (ACTIVA, SUSPENDIDA, BAJA, EN_RECICLAJE).

**Linea_Postpago** — Extensión de Linea solo para postpago. Agrega límite de crédito, deuda actual y día de facturación.

**SIM_Card** — El chip físico. Tiene IMSI, estado y fechas de activación/baja. Una línea puede haber tenido varias SIMs a lo largo del tiempo.

**Equipo** — El celular. Tiene IMEI, marca y modelo. Se asocia a líneas a través de Detalle_Linea_Equipo.

**Detalle_Linea_Equipo** — Historial de qué equipo usó qué línea y en qué fechas.

---

## Planes y Paquetes

**Plan** — Catálogo de planes disponibles. Define si es prepago o postpago, el precio mensual (NULL en prepago), minutos, SMS y MB incluidos.

**Paquete** — Catálogo de bolsas adicionales que se pueden comprar. Define datos, minutos, SMS, vigencia, si es ilimitado y su prioridad de consumo.

**app_incluida_en_bolsa** — Lista de aplicaciones cuyo tráfico está exento de consumir la bolsa (ej. WhatsApp, YouTube).

**Bolsa_Activa** — Una instancia activa de un paquete comprado por una línea. Tiene los MB y minutos restantes y sus fechas de inicio y fin.

---

## Saldo y Transacciones

**Bolsillo** — El saldo de una línea. Tiene tres partes: regular, promocional y prestado. Es una sola fila por línea, siempre se actualiza.

**Recarga** — Registro de cada recarga de saldo. Sabe el canal (app, tarjeta, banco), el monto, el saldo antes y después, y si el cliente pidió factura.

**Tarjeta_Recarga** — El código raspable. Tiene su valor, estado (DISPONIBLE/USADA/ANULADA) y la factura anónima del lote.

**Transfuzion** — Registro de transferencias de saldo entre dos líneas VIVA.

**Doble_Carga** — Registro de los días habilitados para la promoción de doble carga por línea.

---

## Consumo

**Consumo** — Cada vez que una línea hace una llamada, usa datos o envía un SMS. Registra el tipo, cantidad, costo y si se cobró del saldo o de una bolsa.

---

## Préstamos

**T_Presta** — Cada préstamo de saldo. Tiene el monto, la fecha y el estado (PENDIENTE o CANCELADO).

---

## Número Amigo

**Numero_Amigo** — Un par de líneas que tienen llamadas gratuitas entre sí. Tiene fecha de activación, vencimiento y costo de activación.

---

## Promociones

**Promocion** — Campañas activas de VIVA (ej. doble carga, % extra). Se vincula a las recargas que las aprovechan.

---

## Facturación

**factura** — Estado de cuenta mensual de una línea postpago. Tiene el período, el monto total (precio del plan), la fecha de vencimiento y el estado de pago.

---

## Fidelización

**Puntos_Bonus** — El saldo de puntos de una línea. Tiene puntos acumulados, canjeados y disponibles (campo derivado).

**Evento_bonus** — Cada vez que una línea gana puntos: por recarga, por navegar o por referir a otro cliente.