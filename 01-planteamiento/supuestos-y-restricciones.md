# Restricciones del Modelo Relacional - Nuevatel (VIVA)


## 1. Restricciones 

### Identificadores de Transacción (PK)
- Queda terminantemente prohibido el uso de tipos de datos SERIAL o AUTO_INCREMENT para tablas transaccionales.
- Cada registro debe generar un ID alfanumérico único compuesto por:
  - Timestamp granular (hora, minuto, segundo)
### Normalización y Flexibilidad
- Se debe evitar la creación de tablas estáticas por cada nueva oferta comercial. Con tablas estaticas se hace referencia a tablas que se crean por cada oferta comercial. como por ejemplo la tabla de bonus club. que se crea por cada oferta comercial. Una oferta comercial es por ejemplo el sMartes. 

### Integridad de Dominio (ATT)
- Se deben implementar que:
  - Impidan el cobro de datos desde el saldo principal por defecto.
  - Permitan el consumo solo si existe:
    - Una entidad Bolsa_Activa vinculada, o
    - Un permiso explícito en el registro de la línea.


## 3. Supuestos de Lógica de Datos

### Identidad Técnica (Línea vs SIM)
- Se debe diferenciar:
  - Línea (número telefónico)
  - SIM (IMSI)
- Permite:
  - Reciclaje de números
  - Asociación a nuevos chips en el tiempo


### Granularidad de Lealtad (BONUS Club)
- Los puntos:
  - Se calculan por línea individual
  - No se consolidan por cliente, esto quiere decir que si un cliente tiene 2 lineas, los puntos se calculan por linea individual.
- Vigencia:(se refiere a la cantidad de tiempo que tiene un cliente para usar sus puntos)
  - 3 a 4 meses
- Independientes de: (se refiere a que los puntos no se ven afectados por cambios en el plan o en el tipo de servicio)
  - Cambios entre prepago y postpago