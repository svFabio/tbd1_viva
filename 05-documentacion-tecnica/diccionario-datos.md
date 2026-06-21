# Diccionario de Datos (Resumen)

El esquema principal soporta la operativa transaccional del proyecto VIVA. A continuación, se describen los grupos de tablas principales:

## Catálogos
Tablas que almacenan información estática o de referencia.
- metodos_pago: Define los tipos de transacciones permitidas.
- roles_sistema: Catálogo de perfiles para la lógica de la aplicación.

## Transaccional
Tablas que registran la operación diaria del negocio.
- usuarios: Entidad central de clientes y personal.
- facturas: Cabecera de las transacciones financieras.
- lineas_factura: Detalle de los montos y conceptos de cada factura.

## Auditoría
Tablas generadas por el sistema para trazabilidad.
- log_cambios_datos: Almacena el estado anterior y nuevo de los registros modificados en formato JSONB.
- log_eventos_ddl: Registra alteraciones en la estructura de las tablas.

Nota: Para ver la estructura exacta, tipos de datos y restricciones, consultar el archivo DDL principal ubicado en `07-scripts-iniciales`.
