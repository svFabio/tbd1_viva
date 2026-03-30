# Restricciones del Modelo Relacional - Nuevatel (VIVA)


## 1. Restricciones Técnicas (Arquitectura de la BD)

### Identificadores de Transacción (PK)
- Queda terminantemente prohibido el uso de tipos de datos SERIAL o AUTO_INCREMENT para tablas transaccionales.
- Cada registro debe generar un ID alfanumérico único compuesto por:
  - Timestamp granular (hora, minuto, segundo, milisegundo)
  - Prefijo de tipo de transacción ~~(ej. `REC` para Recarga, `PRE` para Préstamo)~~
- ~~Esto garantiza la unicidad absoluta al momento de realizar migraciones entre tablas activas e históricas sugerencia que se realizo en conversacion con el docente.~~

### Normalización y Flexibilidad
- ~~El modelo debe permitir la creación de paquetes dinámicos (voz, datos, mixtos) mediante relaciones.~~
- Se debe evitar la creación de tablas estáticas por cada nueva oferta comercial.

### Integridad de Dominio (ATT)
- Se deben implementar que:
  - Impidan el cobro de datos desde el saldo principal por defecto.
  - Permitan el consumo solo si existe:
    - Una entidad Bolsa_Activa vinculada, o
    - Un permiso explícito en el registro de la línea.

### Seguridad de Datos Sensibles
- Se asume cifrado obligatorio (a nivel de aplicación o base de datos) para:
  - Documentos de identidad
  - Credenciales de acceso a autogestión

---

## 2. Supuestos de Operación

### Estrategia de Rotación
- ~~La base de datos implementará rotación de tablas cada 15 días.~~
- ~~Los datos de alto tráfico (consumo, puntos BONUS, logs):
  - Se moverán de tablas activas a tablas históricas.~~
- Objetivo:
  - Mantener alto rendimiento en operaciones INSERT y SELECT.


### Ventana de Auditoría en Tiempo Real
- La tabla activa debe mantener:
  - Datos de consumo de los últimos 5 días.
- Permite:
  - Consulta inmediata desde la aplicación VIVA antes del archivado.

---

## 3. Restricciones de Alcance (Límites del Modelo)


### Interfaz de Usuario
- El proyecto se limita a:
  - Diseño de base de datos
  - Interfaz administrativa básica (CRUD)

---

## 4. Supuestos de Lógica de Datos

### Identidad Técnica (Línea vs SIM)
- Se debe diferenciar:
  - Línea (número telefónico)
  - SIM (IMSI)
- Permite:
  - Reciclaje de números
  - Asociación a nuevos chips en el tiempo


### ~~Granularidad de Lealtad (BONUS Club)~~
- Los puntos:
  - Se calculan por línea individual
  - No se consolidan por cliente
- Vigencia:
  - 3 a 4 meses
- Independientes de:
  - Cambios entre prepago y postpago~~