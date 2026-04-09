# Casos de Uso Básicos

## CU-01 Registrar cliente

**Actor:** Ejecutivo de ventas / Sistema de registro  
**Precondición:** El cliente no existe en el sistema.  
**Flujo:**
1. Se ingresa el tipo de cliente (NATURAL o EMPRESA).
2. Se registran los datos base en `Cliente`.
3. Si es NATURAL: se crea el registro en `Persona_Natural`.
4. Si es EMPRESA: se crea el registro en `Empresa`.

**Postcondición:** El cliente queda registrado y puede contratar líneas.

---

## CU-02 Activar línea telefónica

**Actor:** Ejecutivo de ventas  
**Precondición:** El cliente existe. El plan seleccionado está activo. Hay un SIM_Card disponible en stock.  
**Flujo:**
1. Se crea el registro en `Linea` con tipo_linea, fecha_activacion y estado ACTIVA.
2. Se actualiza el SIM_Card asignado: estado → ACTIVO, id_linea → nueva línea.
3. Se actualiza `Linea.id_sim_activo` con el id_sim.
4. Se crea el registro en `Bolsillo` con saldos en cero.
5. Si la línea es postpago: se crea el registro en `Linea_Postpago`.

**Postcondición:** La línea está activa y lista para recibir servicios.

---

## CU-03 Recargar saldo

**Actor:** Cliente (por app, tarjeta física, banca digital o punto de venta)  
**Precondición:** La línea existe y está activa.  
**Flujo:**
1. Se identifica el canal de recarga.
2. Si es tarjeta física: se verifica que `Tarjeta_Recarga.estado = DISPONIBLE`. Se actualiza a USADA.
3. Se registra la `Recarga` con saldo_antes, monto y saldo_despues.
4. Se actualiza `Bolsillo.saldo_regular` sumando el monto.
5. Si aplica una `Promocion` (doble carga): se acredita el beneficio al `saldo_promocional`.
6. Si hay `saldo_prestado` pendiente: se descuenta primero de la recarga.

**Postcondición:** El saldo del cliente aumenta y queda registrado en `Recarga`.

---

## CU-04 Comprar bolsa de datos o servicios

**Actor:** Cliente  
**Precondición:** La línea está activa. El paquete está activo en el catálogo. El cliente tiene saldo suficiente o puntos.  
**Flujo:**
1. Se verifica el saldo en `Bolsillo` según la jerarquía: saldo_promocional → saldo_regular.
2. Si usa puntos BONUS: se verifica `Puntos_Bonus.puntos_disponibles` suficientes.
3. Se descuenta el monto del saldo correspondiente.
4. Se crea el registro en `Bolsa_Activa` con cuota total y fecha de vencimiento calculada.
5. Se registra el movimiento en `Transaccion`.

**Postcondición:** La bolsa queda activa para la línea.

---

## CU-05 Registrar consumo de datos

**Actor:** Sistema de red (automático)  
**Precondición:** La línea está activa. Hay una sesión de datos en curso.  
**Flujo:**
1. Se identifica el destino del tráfico (destino_dns, destino_ip, destino_app).
2. Se verifica si el destino está en `app_incluida_en_bolsa` para el paquete activo.
3. Si está exento: se registra `Consumo` con `es_cobrado = false` y `costo_bs = 0`.
4. Si no está exento: se descuenta de `Bolsa_Activa.cuota_restante_mb` o del saldo en `Bolsillo`.
5. Se registra el evento en `Consumo`.

**Postcondición:** El consumo queda registrado y el saldo o cuota se actualiza.

---

## CU-06 Solicitar préstamo de saldo (T-Presta)

**Actor:** Cliente  
**Precondición:** La línea está activa. `Bolsillo.prestamo_habilitado = true`. No tiene préstamos PENDIENTES.  
**Flujo:**
1. Se verifica `Bolsillo.prestamo_habilitado`.
2. El cliente selecciona el monto (Bs 2, 5 o 10).
3. Se crea el registro en `T_Presta` con estado PENDIENTE.
4. Se acredita el monto al `Bolsillo.saldo_regular`.
5. Se actualiza `Bolsillo.saldo_prestado` sumando el monto.

**Postcondición:** El cliente tiene saldo disponible y una deuda registrada.

---

## CU-07 Generar factura postpago

**Actor:** Sistema (automático al llegar la fecha de facturación)  
**Precondición:** La línea tiene `tipo_linea = POSTPAGO`. Es el `dia_facturacion` del mes.  
**Flujo:**
1. El sistema identifica todas las líneas con `dia_facturacion` igual al día actual.
2. Para cada línea, suma los consumos del período en `Consumo`.
3. Suma la cuota del plan más los consumos extras.
4. Crea el registro en `Factura` con estado PENDIENTE y genera el `numero_factura`.

**Postcondición:** La factura queda emitida y el cliente recibe notificación.

---

## CU-08 Transferir saldo entre líneas (Transfuzion)

**Actor:** Cliente  
**Precondición:** Ambas líneas están activas en VIVA. `Bolsillo.saldo_regular` de origen ≥ monto (mínimo Bs 1).  
**Flujo:**
1. Se descuenta el monto del `saldo_regular` de la línea origen.
2. Se acredita el monto al `saldo_regular` de la línea destino.
3. Se registra en `Transfuzion` y en `Transaccion`.

**Postcondición:** El saldo se movió entre las dos líneas.

---

## CU-09 Consultar historial de consumo

**Actor:** Cliente / Atención al cliente  
**Precondición:** La línea existe.  
**Flujo:**
1. Se consulta `Consumo` filtrando por `id_linea` y rango de fechas.
2. Se muestra el tipo de consumo, cantidad, costo y si fue cobrado o exento.

**Postcondición:** El cliente puede ver el detalle de uso de sus servicios.

---

## CU-10 Activar Número Amigo

**Actor:** Cliente  
**Precondición:** Ambas líneas son de VIVA y están activas. Saldo suficiente (Bs 5).  
**Flujo:**
1. Se descuenta Bs 5 del `Bolsillo.saldo_regular` de la línea origen.
2. Se crea el registro en `Numero_Amigo` con estado ACTIVO y fecha_vencimiento = hoy + 30 días.
3. Se registra en `Transaccion`.

**Postcondición:** Las llamadas entre las dos líneas no se cobran por 30 días.