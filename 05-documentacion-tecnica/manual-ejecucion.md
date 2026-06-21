# Manual de Ejecución

## 1. Conexión a la Base de Datos

Una vez que el contenedor está en ejecución, puedes conectarte utilizando cualquier cliente SQL (pgAdmin, DBeaver) o la terminal psql con las siguientes credenciales:

- Host: localhost
- Puerto: 5433
- Usuario: postgres
- Contraseña: tbdviva
- Base de datos: bd-viva

Comando por terminal:
psql -h localhost -p 5433 -U postgres -d bd-viva

## 2. Ejecución de Scripts Semilla

Los datos iniciales de prueba y catálogos se encuentran en la carpeta `08-scripts-semilla`. 
Para poblar la base de datos, ejecuta el archivo SQL contenido en esa carpeta desde tu cliente SQL conectado como el usuario `postgres`.

## 3. Pruebas de Presentación

La carpeta `09-scripts-presentacion` contiene scripts diseñados para validar el funcionamiento del sistema:
- Verificación de permisos y roles (RLS).
- Pruebas de auditoría nativa y pgAudit.
- Simulación de bloqueos (Deadlocks) y consultas lentas.

Se deben ejecutar paso a paso según el escenario de evaluación requerido.
