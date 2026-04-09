# Alcance del Sistema — VIVA

## ¿Qué cubre este sistema?

Este documento define con precisión qué funcionalidades y datos entran dentro del sistema de base de datos, y cuáles quedan fuera de esta fase.

---

## Dentro del alcance

| Área | Qué se gestiona |
|------|----------------|
| **Clientes** | Personas naturales y empresas. Herencia 1:1 desde tabla base Cliente. |
| **Líneas telefónicas** | Alta, baja, suspensión, reciclaje. Historial de estados. |
| **SIM Cards** | Stock, activación, reemplazo, baja. Historial de chip por línea. |
| **Equipos (IMEI)** | Registro de teléfonos físicos. Historial de qué equipo usó cada línea. |
| **Planes** | Catálogo de planes prepago, postpago, individuales y corporativos. |
| **Saldo y bolsillos** | Regular, promocional y prestado. Aplica a cualquier tipo de línea. |
| **Recargas** | Tarjeta física, app, banca digital, punto de venta. |
| **Paquetes y bolsas** | Catálogo, compra, consumo en tiempo real, apps exentas. |
| **Consumos** | Llamadas, SMS, datos, LDI. Registro detallado por evento. |
| **T-Presta** | Préstamos de saldo y su ciclo de vida. |
| **Transfuzión** | Transferencias de saldo entre líneas VIVA. |
| **Facturas postpago** | Generación mensual y control de deuda. |
| **Promociones** | Campañas de doble carga, bonos, descuentos con horario. |
| **Puntos BONUS** | Acumulación por distintos eventos, canje por paquetes. |
| **Número Amigo** | Registro y verificación en tiempo real al registrar llamadas. |

---

## Límites

| Área | Razón |
|------|-------|
| Roaming  | Se registra como tipo de consumo pero no se modela la red de roaming. |
| Roles en el sistema| No se contemplaran roles de ningun tipo como por ejemplo administrador|
