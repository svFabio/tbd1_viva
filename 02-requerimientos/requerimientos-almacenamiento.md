# Requerimientos de Seguridad

## 1. Seguridad de datos

Los datos del sistema son sensibles. Hay tres niveles de acceso:

| Rol | Puede ver | No puede ver |
|-----|-----------|--------------|
| **Administrador VIVA** | Todo | — |
| **Agente de atención** | Datos del cliente, líneas, saldo, recargas, consumos | NIT de terceros, datos de otras cuentas |
| **Sistema backend** | Todo lo necesario para operar (recargas, consumos, préstamos) | No aplica, acceso controlado por API |
| **Cliente (autogestión)** | Sus propios datos: saldo, facturas, consumos, puntos | Datos de otros clientes |

**Datos que requieren protección especial:**
- `Persona_Natural.ci` — dato de identidad
- `Empresa.nit` — dato tributario
- `Recarga.nit_factura` — dato fiscal del cliente
- `Bolsillo.*` — datos financieros
- `factura.*` — información de deuda y pago

---

## 2. Integridad — ¿Cómo se evitan datos incoherentes?

El modelo usa varios mecanismos para mantener la integridad:

| Mecanismo | Dónde aplica | Para qué sirve |
|-----------|-------------|----------------|
| **Claves primarias (PK)** | Todas las tablas | Evitan filas duplicadas |
| **Claves foráneas (FK)** | Todas las relaciones | Evitan referencias a registros que no existen |
| **NOT NULL** | Campos obligatorios | Evitan registros incompletos |
| **UNIQUE** | `Linea.numero`, `SIM_Card.imsi`, `Equipo.imei`, `Tarjeta_Recarga.codigo_tarjeta` | Evitan duplicados en identificadores únicos |
| **CHECK (backend)** | `Tarjeta_Recarga.monto_bs` = 10/20/50/100 | Valores fuera de rango son rechazados |



---

## 3. Roles sugeridos en la base de datos

| Rol Oracle | Permisos |
|-----------|---------|
| `viva_admin` | SELECT, INSERT, UPDATE, DELETE en todas las tablas |
| `viva_agente` | SELECT en Cliente, Linea, Bolsillo, Recarga, Consumo, factura. INSERT en Recarga, T_Presta |
| `viva_backend` | SELECT, INSERT, UPDATE en tablas transaccionales (Consumo, Recarga, Bolsillo, Bolsa_Activa, T_Presta, Transfuzion, Evento_bonus, Puntos_Bonus) |
| `viva_readonly` | SELECT en tablas no sensibles (Plan, Paquete, Promocion) |

---

## 4. Auditoría

Las siguientes tablas ya funcionan como registros de auditoría por su naturaleza:

| Tabla | Qué audita |
|-------|-----------|
| Recarga | Historial completo de recargas con saldo antes/después |
| Consumo | Cada evento de uso de la línea |
| T_Presta | Historial de préstamos y su estado |
| Transfuzion | Historial de transferencias entre líneas |
| Evento_bonus | Cómo y cuándo se ganaron puntos |
| Detalle_Linea_Equipo | Historial de equipos asociados a cada línea |
| factura | Historial de cobros mensuales |

No existe una tabla de log de cambios en datos maestros (ej. cambio de plan, cambio de estado de línea). Eso es una limitación de la versión actual.