# Alcance del Sistema

## ¿Qué SÍ modela este sistema?

| # | Funcionalidad |
|---|---------------|
| 1 | Registro de clientes (personas naturales y empresas) |
| 2 | Gestión de líneas prepago y postpago |
| 3 | Registro de SIM Cards y equipos asignados |
| 4 | Recargas de saldo (tarjeta física, app, banca digital) |
| 5 | Préstamo de saldo T-Presta |
| 6 | Transferencia de saldo entre líneas (Transfuzión) |
| 7 | Compra y consumo de paquetes adicionales (Bolsas) |
| 8 | Registro de consumos (llamadas, datos, SMS) |
| 9 | Número Amigo (llamadas gratuitas entre líneas) |
| 10 | Promociones y Doble Carga |
| 11 | Facturación mensual para líneas postpago |
| 12 | Acumulación y canje de puntos VIVA BONUS |

---

## ¿Qué NO incluye el modelo?

| Fuera del alcance | Razón |
|---|---|
| Roaming internacional | Depende de acuerdos con operadoras extranjeras y regulaciones internacionales fuera del control del sistema interno |
| Pagos en línea / pasarela de cobro | Es un sistema externo al modelo de datos |
| Grupos corporativos con pool compartido | Pendiente para una versión futura |
| Facturación tributaria centralizada | Las recargas registran el NIT en `Recarga.nit_factura`; la factura postpago es estado de cuenta mensual |