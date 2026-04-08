# Requerimientos de Seguridad

## Confidencialidad

**RS-C01** Los datos personales de clientes (CI, NIT, correo, dirección, teléfono, fecha de nacimiento) deben estar protegidos y no ser accesibles a usuarios que no tengan autorización explícita para consultarlos.

**RS-C02** El historial de recargas, consumos, préstamos y transferencias de un cliente es información privada. Solo el propio cliente (a través de la app) y el personal autorizado de VIVA pueden consultarlo.

**RS-C03** Los NIT de clientes corporativos y la información de contratos empresariales son datos sensibles de carácter comercial y deben tratarse con mayor restricción.

**RS-C04** Los campos nit_factura y nit_cliente en recargas deben almacenarse de forma que no sean visibles en consultas generales del sistema.

---

## Integridad

**RS-I01** No debe poder registrarse una línea sin un cliente asociado. La FK `id_cliente` en `Linea` debe ser obligatoria y con restricción referencial.

**RS-I02** No debe poder eliminarse un cliente que tenga líneas activas asociadas. La eliminación debe estar restringida o implementarse como baja lógica (cambio de estado).

**RS-I03** El saldo en `Bolsillo` nunca puede ser negativo. Cualquier operación que intente llevar el saldo por debajo de cero debe ser rechazada por el sistema.

**RS-I04** Una tarjeta de recarga con estado `USADA` no puede canjearse nuevamente. El sistema debe validar el estado antes de procesar cualquier canje.

**RS-I05** El campo `cuota_restante_mb` en `Bolsa_Activa` no puede superar `cuota_total_mb`. Las actualizaciones deben validar este límite.

**RS-I06** Los montos de préstamo en `T_Presta` solo pueden ser Bs 2, Bs 5 o Bs 10. Cualquier otro valor debe ser rechazado.

**RS-I07** No puede existir un registro en `Bolsillo` sin un registro correspondiente en `Linea`. La relación es obligatoria.

**RS-I08** El `numero` (MSISDN) en `Linea` es único. No pueden existir dos líneas con el mismo número en el sistema.

---

## Roles de acceso

**RS-R01 — Administrador de BD**
Acceso total a todas las tablas. Solo para el equipo técnico responsable del mantenimiento del sistema.

**RS-R02 — Atención al cliente**
Acceso de lectura a datos de clientes, líneas, consumos, recargas y préstamos. Sin acceso a datos financieros agregados ni información corporativa sensible. Sin permisos de escritura directa.

**RS-R03 — Sistema de facturación**
Acceso de escritura a `Factura` y lectura a `Linea_Postpago` y `Consumo`. Sin acceso a datos personales de clientes.

**RS-R04 — App del cliente (usuario final)**
Acceso de lectura solo a sus propios datos: su línea, su bolsillo, sus bolsas activas, su historial de recargas y consumos. Sin acceso a datos de otros clientes.

**RS-R05 — Sistema transaccional (backend)**
Acceso de escritura a tablas de alta volumetría: `Consumo`, `Transaccion`, `Recarga`, `Bolsa_Activa`. Acceso de lectura a catálogos: `Plan`, `Paquete`, `Promocion`.

**RS-R06 — Business Intelligence / Reportes**
Acceso de lectura a tablas históricas y agregadas. Sin acceso a datos personales identificables de clientes.