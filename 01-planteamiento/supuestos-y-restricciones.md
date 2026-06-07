# Supuestos y Restricciones

## Supuestos
Son cosas que asumimos como verdaderas para que el modelo funcione.

| # | Supuesto |
|---|----------|
| S-01 | Cada línea tiene exactamente un bolsillo activo |
| S-02 | Cada línea usa exactamente una SIM Card activa a la vez |
| S-03 | Un cliente puede tener varias líneas, pero una línea pertenece a un solo cliente |
| S-04 | El precio de un plan no cambia retroactivamente |
| S-05 | Los paquetes tienen vigencia en horas desde que se activan |
| S-06 | El saldo promocional siempre se consume antes que el saldo regular |
| S-07 | Una línea puede tener varias bolsas activas simultáneamente; el campo nivel_prioridad en Paquete decide cuál se consume primero |
| S-08 | La doble carga solo aplica los días habilitados por VIVA |
| S-09 | Los valores permitidos para recargas con tarjeta son: Bs 10, 20, 50 y 100 |
| S-10 | Todas las líneas operan dentro del territorio boliviano |

---

## Restricciones
Son limitaciones conocidas del modelo actual.

| # | Restricción |
|---|-------------|
| R-01 | El T-Presta solo se habilita si la línea tiene 3+ meses de antigüedad y no tiene deuda pendiente |
| R-02 | Una línea no puede tener dos T-Presta pendientes al mismo tiempo |
| R-03 | La Transfuzión tiene un límite diario de transferencias (definido en el backend) |
| R-04 | El roaming internacional no está modelado en esta versión |
| R-05 | La gestión de pools compartidos para planes corporativos queda fuera del alcance actual |
| R-06 | El campo puntos_disponibles en Puntos_Bonus es derivado (puntos_acumulados - puntos_canjeados); su consistencia depende del backend |
| R-07 | tipo_linea en Linea es redundante con modalidad_de_pago en Plan; su sincronización es responsabilidad del sistema |