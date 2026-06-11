# TG4 -- Seguridad en Base de Datos PostgreSQL

**Universidad Mayor de San Simon**
**Materia:** Taller de Base de Datos
**Proyecto:** Sistema de Telecomunicaciones VIVA -- Seguridad en BBDD PgSQL
**Motor:** PostgreSQL 16 sobre Docker
**Base de datos:** bd-viva

---

## Tabla de Contenidos

- [Estructura del Proyecto](#estructura-del-proyecto)
- [Requisitos Previos](#requisitos-previos)
- [Levantar el Entorno](#levantar-el-entorno)
- [Semana 1 -- Fundamentos y Hardening Inicial](#semana-1----fundamentos-y-hardening-inicial)
- [Semana 2 -- Control de Acceso y Seguridad por Objeto](#semana-2----control-de-acceso-y-seguridad-por-objeto)
- [Semana 3 -- Auditoria y Monitoreo](#semana-3----auditoria-y-monitoreo)
- [Semana 4 -- Backup, Recuperacion y Entrega Final](#semana-4----backup-recuperacion-y-entrega-final)

---

## Estructura del Proyecto

```
proyecto-bd-viva/
|-- Dockerfile                        # Imagen PostgreSQL 16 + pgAudit
|-- docker-compose.yml                # Orquestacion del contenedor
|-- datos_postgres_viva/              # Volumen persistente de PostgreSQL
|   |-- pg_hba.conf                   # Configuracion de autenticacion de red
|   |-- postgresql.conf               # Configuracion general del motor
|-- scripts_iniciales/                # Scripts que construyen la BD desde cero
|   |-- 01-roles.sql                  # Creacion de roles y usuarios
|   |-- 02-ddl-24-05-2026.sql         # Estructura completa (tablas, esquemas, FK, RLS)
|   |-- 03-triggers.sql               # Triggers de auditoria DML y DDL
|   |-- 04-permisos.sql               # Ajuste granular de privilegios (GRANT/REVOKE)
|   |-- 05-correccion-roles-inherit.sql  # Correccion de herencia en roles
|   |-- 06-correccion-columnas.sql    # Seguridad por columna en Bolsillo
|   |-- 07-correccion-revoke-public.sql  # REVOKE ALL ON SCHEMA public
|   |-- 08-tables-views.sql           # Vistas seguras (marketing y facturacion)
|   |-- 09-add-factura-paraauditoria.sql # Trigger de auditoria en Factura
|-- scripts_presentacion/             # Scripts para demostrar en vivo cada criterio
|-- scripts_semilla/                  # Datos de prueba (seed)
|   |-- 01-seed-new.sql
|-- backup/                           # Respaldos y scripts de restauracion
|   |-- 01-generar-backups.sh
|   |-- 02-restaurar-y-validar.sh
|   |-- 03-restaurar-mas-tablas.sh
|   |-- bd-viva.backup
|   |-- roles_globales.sql
```

---

## Requisitos Previos

- Docker y Docker Compose instalados
- Git (para versionado)
- Un cliente SQL (DBeaver, pgAdmin o psql desde terminal)

---

## Levantar el Entorno

```bash
# Clonar el repositorio
git clone <url-del-repo>
cd proyecto-bd-viva

# Levantar el contenedor
docker compose up -d --build

# Verificar que esta corriendo
docker ps
```

El contenedor se llama `contenedor-postgres-viva` y expone PostgreSQL en el puerto `5433`.
Los scripts de `scripts_iniciales/` se ejecutan automaticamente al crear la base de datos por primera vez gracias al volumen montado en `/docker-entrypoint-initdb.d`.

Para ejecutar cualquier script de presentacion desde fuera del contenedor:

```bash
docker exec -u postgres -i contenedor-postgres-viva psql -d bd-viva < scripts_presentacion/01-mostrar-usuario-y-rol-asignado.sql
```

---

## Semana 1 -- Fundamentos y Hardening Inicial

### 1.1 Instalacion y Configuracion de Red

**Que se hizo:** Se instalo PostgreSQL 16 dentro de un contenedor Docker. La imagen base se extiende con pgAudit.

**Dockerfile:**
```dockerfile
FROM postgres:16
RUN apt-get update && apt-get install -y postgresql-16-pgaudit
```

**docker-compose.yml** (fragmento relevante):
```yaml
services:
  postgres_viva:
    build: .
    container_name: contenedor-postgres-viva
    ports:
      - "5433:5432"
    volumes:
      - ./datos_postgres_viva:/var/lib/postgresql/data
      - ./scripts_iniciales:/docker-entrypoint-initdb.d
```

**Restriccion de red en `postgresql.conf`:**
```
listen_addresses = '*'
```

Se configuro `listen_addresses = '*'` para que el motor escuche en todas las interfaces, pero la restriccion real de quien puede conectarse se define en el archivo `pg_hba.conf` (ver siguiente punto). El puerto se mapea del `5432` interno al `5433` externo para no chocar con instalaciones locales.

**Script de verificacion:**
- `scripts_presentacion/00-version-psql.sql` -- Muestra la version instalada de PostgreSQL.

---

### 1.2 Hardening de pg_hba.conf

**Que se hizo:** Se reemplazo la configuracion por defecto (que usaba `trust` para todo) por una configuracion segura dividida en 5 zonas claras.

**Archivo:** `datos_postgres_viva/pg_hba.conf`

La configuracion por defecto venia asi (todo con `trust`, es decir, sin pedir contrasena):
```
local   all   all                   trust
host    all   all   127.0.0.1/32    trust
host    all   all   ::1/128         trust
```

Se comento todo eso y se reemplazo con la siguiente configuracion:

**Zona 1 -- Conexiones locales (sockets Unix):**
```
local   all   postgres                          peer
local   all   all                               scram-sha-256
```
- `postgres` entra por `peer`: el kernel del sistema operativo valida la identidad, no necesita contrasena.
- Todos los demas usuarios usan `scram-sha-256`: contrasena cifrada obligatoria.

**Zona 2 -- Conexiones por red local (loopback):**
```
host    all   all   127.0.0.1/32   scram-sha-256
host    all   all   ::1/128        scram-sha-256
```
- Cualquier conexion desde localhost requiere contrasena cifrada.

**Zona 3 -- Lista blanca de IPs autorizadas:**
```
host    all   all   200.87.92.250/32   scram-sha-256
host    all   all   172.18.0.1/32      scram-sha-256
```
- Solo las IPs especificas de la red del proyecto pueden conectarse.

**Zona 4 -- Candado (bloqueo de todo lo demas):**
```
host    all   all   0.0.0.0/0    reject
host    all   all   ::/0         reject
```
- Cualquier IP que no coincida con las zonas anteriores es rechazada.

**Zona 5 -- Replicacion segura:**
```
local   replication   all                     scram-sha-256
host    replication   all   127.0.0.1/32      scram-sha-256
host    replication   all   ::1/128           scram-sha-256
```

**Metodos de autenticacion usados y por que:**

| Metodo | Donde se usa | Justificacion |
|--------|-------------|---------------|
| `peer` | Conexion local del usuario `postgres` | El kernel del SO garantiza la identidad, es el mas seguro para el superusuario local |
| `scram-sha-256` | Todos los demas usuarios y conexiones de red | Cifra la contrasena en transito, es el estandar recomendado por PostgreSQL 16 |
| `reject` | Todo lo que no este en la lista blanca | Bloqueo explicito para cualquier IP no autorizada |

---

### 1.3 Creacion de Roles Separados por Funcion

**Que se hizo:** Se crearon 4 roles de grupo (plantillas sin login) y 4 usuarios (personas/aplicaciones con login), cada uno con un proposito claro.

**Script:** `scripts_iniciales/01-roles.sql`

**Roles de grupo (sin login, solo agrupan permisos):**

| Rol | Proposito |
|-----|----------|
| `rol_app` | Permisos de la aplicacion backend (operaciones transaccionales) |
| `rol_admin_promo` | Gestion de promociones y fidelizacion |
| `rol_auditor` | Solo lectura + auditoria (monitoreo) |
| `rol_reporte` | Solo lectura en todas las tablas (reportes gerenciales) |

**Usuarios con login (personas reales y sistemas):**

| Usuario | Rol asignado | Tipo | Vencimiento |
|---------|-------------|------|-------------|
| `u_app` | `rol_app` | No Nominal (Sistema) | Sin vencimiento |
| `u_adan_pereira` | `rol_admin_promo` | Nominal (Persona) | 2026-12-31 |
| `u_aurelio_casillas` | `rol_auditor` | Nominal (Persona) | 2026-12-31 |
| `u_rebeca_jones` | `rol_reporte` | Nominal (Persona) | 2026-12-31 |

Ningun usuario es superusuario. Solo `postgres` tiene privilegios de administrador.

**Script de verificacion:**
- `scripts_presentacion/01-mostrar-usuario-y-rol-asignado.sql` -- Lista cada usuario con su rol y tipo (Nominal / No Nominal).

---

### 1.4 Revocacion de Permisos Publicos

**Que se hizo:** Se revoco el acceso al esquema `public` para que ningun usuario sin permisos explicitos pueda crear tablas o ejecutar consultas ahi.

**Script:** `scripts_iniciales/07-correccion-revoke-public.sql`

```sql
REVOKE ALL ON SCHEMA public FROM PUBLIC;
```

Esto cierra una vulnerabilidad comun en PostgreSQL: por defecto, cualquier usuario puede crear objetos en el esquema `public`.

**Script de verificacion:**
- `scripts_presentacion/04-mostrar-revoke-public.sql` -- Comprueba que el rol `PUBLIC` ya no tiene permisos USAGE ni CREATE en el esquema `public`.

---

### 1.5 Reporte Tecnico + Checklist

**Evidencias de la Semana 1:**

| Criterio | Script de verificacion | Que muestra |
|----------|----------------------|-------------|
| Version de PostgreSQL | `00-version-psql.sql` | PostgreSQL 16 corriendo en Docker |
| pg_hba.conf hardened | Archivo en `datos_postgres_viva/pg_hba.conf` | 5 zonas de autenticacion |
| Roles y usuarios | `01-mostrar-usuario-y-rol-asignado.sql` | 4 usuarios con roles asignados |
| Revoke public | `04-mostrar-revoke-public.sql` | PUBLIC sin USAGE ni CREATE |

---

## Semana 2 -- Control de Acceso y Seguridad por Objeto

### 2.1 Esquemas y Privilegios por Tabla

**Que se hizo:** La base de datos esta organizada en 7 esquemas separados por area de negocio. Cada rol tiene permisos GRANT granulares solo sobre las tablas que necesita.

**Script:** `scripts_iniciales/02-ddl-24-05-2026.sql` (esquemas) + `scripts_iniciales/04-permisos.sql` (ajuste fino)

**Esquemas creados:**

| Esquema | Area de negocio |
|---------|----------------|
| `clientes` | Datos de clientes, empresas, personas naturales |
| `comercial` | Promociones, condiciones, numeros amigos |
| `fidelizacion` | Puntos, historial de puntos, bonificaciones |
| `finanzas` | Facturas, recargas, prestamos, bolsillos |
| `lineas` | Lineas telefonicas, planes, SIM cards, equipos |
| `seguridad` | Auditoria y usuarios del sistema |
| `servicios` | Paquetes, bolsas activas, consumo |

Cada esquema tiene su propietario (`postgres`) y solo los roles que lo necesitan tienen `GRANT USAGE ON SCHEMA`.

**Ejemplo de permisos granulares:**

En el script `04-permisos.sql` se hicieron ajustes como:
- `rol_app` tenia permisos CRUD en tablas donde solo necesitaba SELECT. Se revocaron con:
  ```sql
  REVOKE INSERT, UPDATE, DELETE ON lineas."Linea" FROM rol_app;
  REVOKE INSERT, UPDATE, DELETE ON lineas."Plan"  FROM rol_app;
  ```
- `rol_reporte` tenia acceso a tablas que no le corresponden. Se revocaron con:
  ```sql
  REVOKE ALL ON comercial."Numero_Amigo"   FROM rol_reporte;
  REVOKE ALL ON finanzas."Tarjeta_Recarga" FROM rol_reporte;
  ```

**Scripts de verificacion:**
- `scripts_presentacion/05-mostrar-esquemas-conpropietario.sql` -- Lista los 7 esquemas con su propietario.
- `scripts_presentacion/02-mostrar-permisos-en-tablas-segun-rol.sql` -- Muestra los permisos exactos de un rol especifico (cambiar la variable `grantee`).
- `scripts_presentacion/06-mostrar-permisos-alastabla-por-rol.sql` -- Muestra TODOS los permisos de tabla de todos los roles agrupados.

---

### 2.2 Seguridad por Columna

**Que se hizo:** Se aplico `GRANT SELECT(col)` a nivel de columna en la tabla `finanzas."Bolsillo"`. El rol `rol_app` solo puede actualizar las columnas `saldo_dinero`, `saldo_megas` y `saldo_minutos`, pero no puede tocar `id_bolsillo` ni `id_linea`.

**Script:** `scripts_iniciales/06-correccion-columnas.sql`

```sql
-- 1. Quitar el poder de actualizar toda la tabla
REVOKE UPDATE ON finanzas."Bolsillo" FROM rol_app;

-- 2. Dar permiso solo a las columnas que necesita
GRANT UPDATE (saldo_dinero, saldo_megas, saldo_minutos) ON finanzas."Bolsillo" TO rol_app;
```

Esto impide que la aplicacion modifique el `id_linea` del bolsillo (lo que seria un error grave de seguridad).

**Script de verificacion:**
- `scripts_presentacion/07-mostrar-permisos-porColumna.sql` -- Lista los privilegios a nivel de columna por rol.

---

### 2.3 Row Level Security -- RLS

**Que se hizo:** Se habilito RLS en dos tablas: `finanzas."Factura"` y `servicios."Consumo"`. Se creo una politica que filtra las filas segun el identificador de linea almacenado en la variable de sesion `app.current_linea_id`.

**Script:** `scripts_iniciales/02-ddl-24-05-2026.sql` (lineas 260-266 y 578-584)

```sql
-- Activar RLS en la tabla Factura
ALTER TABLE finanzas."Factura" ENABLE ROW LEVEL SECURITY;

-- Crear la politica de filtrado
CREATE POLICY factura_propia_policy ON finanzas."Factura"
    AS PERMISSIVE
    FOR SELECT
    TO rol_app
    USING (
      id_linea = (NULLIF(
        current_setting('app.current_linea_id'::text, true), 
        ''::text
      ))::integer
    );
```

**Como funciona paso a paso:**

1. `current_setting('app.current_linea_id', true)` -- Busca en la sesion el ID de la linea conectada.
2. `NULLIF(..., '')` -- Si la variable esta vacia, la convierte en NULL (devuelve 0 filas de forma segura).
3. `::integer` -- Convierte el texto a numero para compararlo con `id_linea`.
4. El motor aplica esta regla en cada SELECT automaticamente.

**Demostracion en vivo:**

```sql
-- Simulacion: cambiar al rol de la app
SET ROLE rol_app;

-- PRUEBA 1: Sin identificarse (simula un ataque o error del backend)
SELECT * FROM finanzas."Factura";
-- RESULTADO: 0 filas (el NULLIF bloquea la consulta)

-- PRUEBA 2: Identificarse como la linea 2
SET app.current_linea_id = '2';
SELECT * FROM finanzas."Factura";
-- RESULTADO: Solo las facturas de la linea 2

-- PRUEBA 3: Cambiar a la linea 4
SET app.current_linea_id = '4';
SELECT * FROM finanzas."Factura";
-- RESULTADO: Solo las facturas de la linea 4
```

**Scripts de verificacion:**
- `scripts_presentacion/08-verificar-rls.sql` -- Lista las tablas con RLS y sus politicas.
- `scripts_presentacion/09-evidencia-rsl-con-lineas-facturas.sql` -- Demostracion practica con cambio de contexto.
- `scripts_presentacion/11-mostrar-politica.sql` -- Muestra la politica y su explicacion detallada.
- `scripts_presentacion/12-demo-politicas-rls.sql` -- Demo de ataque bloqueado vs acceso legitimo.

---

### 2.4 Vistas Seguras

**Que se hizo:** Se crearon dos vistas para aplicar el principio de minimo privilegio. El usuario de marketing puede ver numeros de telefono activos pero NO tiene acceso directo a la tabla base.

**Script:** `scripts_iniciales/08-tables-views.sql`

**Vista 1 -- Marketing (oculta datos personales):**
```sql
CREATE OR REPLACE VIEW comercial.vista_lineas_marketing AS
SELECT numero_telefono, estado
FROM lineas."Linea"
WHERE estado = 'Activo';

GRANT SELECT ON comercial.vista_lineas_marketing TO rol_admin_promo;
```
- El rol `rol_admin_promo` puede leer la vista pero NO puede hacer `SELECT * FROM lineas."Linea"` directamente.
- Se ocultan columnas sensibles como `id_cliente`, `id_sim_activo`, etc.

**Vista 2 -- Facturacion (utilidad operativa):**
```sql
CREATE OR REPLACE VIEW finanzas.vista_reporte_facturacion AS
SELECT f.id_factura, l.numero_telefono, f.monto_total, f.estado_pago
FROM finanzas."Factura" f
INNER JOIN lineas."Linea" l ON f.id_linea = l.id_linea;

GRANT SELECT ON finanzas.vista_reporte_facturacion TO rol_app;
```

**Script de verificacion:**
- `scripts_presentacion/10-evidencia-table-view.sql` -- Consume la vista de marketing como `rol_admin_promo`.

---

### 2.5 Script SQL + Matriz de Privilegios

El script maestro que contiene todos los GRANT y REVOKE esta en:

**Script:** `scripts_iniciales/04-permisos.sql`

Este script documenta para cada rol:
1. Que permisos YA tenia desde el DDL.
2. Que permisos FALTABAN segun la matriz.
3. Que permisos SOBRABAN y se revocaron.

Al final del script hay una consulta de verificacion que genera la matriz completa:

```sql
SELECT grantee, table_schema, table_name,
       string_agg(privilege_type, ', ' ORDER BY privilege_type) AS privilegios
FROM information_schema.role_table_grants
WHERE grantee IN ('rol_admin_promo', 'rol_app', 'rol_auditor', 'rol_reporte')
GROUP BY grantee, table_schema, table_name
ORDER BY grantee, table_schema, table_name;
```

---

## Semana 3 -- Auditoria y Monitoreo

### 3.1 Logs Nativos + pgAudit

**Que se hizo:** Se activaron los logs nativos de PostgreSQL y se instalo la extension pgAudit para tener una capa adicional de auditoria.

**Logs nativos (configurados en el docker-compose.yml):**
```yaml
command: ["postgres",
  "-c", "shared_preload_libraries=pg_stat_statements,pgaudit",
  "-c", "log_connections=on",
  "-c", "log_statement=ddl",
  "-c", "pgaudit.log=write,ddl",
  "-c", "pgaudit.log_relation=on",
  "-c", "pgaudit.log_parameter=on"
]
```

| Parametro | Valor | Que hace |
|-----------|-------|----------|
| `log_connections` | `on` | Registra cada vez que alguien se conecta al servidor |
| `log_statement` | `ddl` | Registra los CREATE, ALTER y DROP (cambios estructurales) |
| `pgaudit.log` | `write,ddl` | pgAudit registra escrituras (INSERT, UPDATE, DELETE) y cambios DDL |
| `pgaudit.log_relation` | `on` | Incluye el nombre de la tabla afectada en el log |
| `pgaudit.log_parameter` | `on` | Incluye los valores de los parametros en el log |

**pgAudit** se instala en el Dockerfile con `apt-get install -y postgresql-16-pgaudit` y se precarga como libreria compartida.

**Scripts de verificacion:**
- `scripts_presentacion/13-verificar-logs-nativos-on-ddl.sql` -- Confirma que `log_connections = on` y `log_statement = ddl`.
- `scripts_presentacion/14-verificar-install-pgaudit.sql` -- Confirma que la extension pgAudit esta instalada y su version.

---

### 3.2 Tabla de Auditoria DML

**Que se hizo:** Se creo una tabla `seguridad."Auditoria"` y un trigger que captura automaticamente cada INSERT, UPDATE y DELETE usando `to_jsonb()`.

**Script:** `scripts_iniciales/03-triggers.sql`

**Funcion del trigger DML:**
```sql
CREATE OR REPLACE FUNCTION seguridad.fn_auditoria_dml()
    RETURNS trigger
    LANGUAGE plpgsql
AS $function$
BEGIN
    IF (TG_OP = 'DELETE') THEN
        INSERT INTO seguridad."Auditoria" (tabla_afectada, operacion, detalle_cambio)
        VALUES (TG_TABLE_NAME, 'DELETE', to_jsonb(OLD)::text);
        RETURN OLD;
    ELSIF (TG_OP = 'UPDATE') THEN
        INSERT INTO seguridad."Auditoria" (tabla_afectada, operacion, detalle_cambio)
        VALUES (TG_TABLE_NAME, 'UPDATE', to_jsonb(NEW)::text);
        RETURN NEW;
    ELSIF (TG_OP = 'INSERT') THEN
        INSERT INTO seguridad."Auditoria" (tabla_afectada, operacion, detalle_cambio)
        VALUES (TG_TABLE_NAME, 'INSERT', to_jsonb(NEW)::text);
        RETURN NEW;
    END IF;
    RETURN NULL;
END;
$function$;
```

El trigger esta aplicado sobre `lineas."Plan"` y `finanzas."Factura"`:
```sql
CREATE TRIGGER trg_audit_dml
    AFTER INSERT OR DELETE OR UPDATE
    ON lineas."Plan"
    FOR EACH ROW EXECUTE FUNCTION seguridad.fn_auditoria_dml();

CREATE TRIGGER trg_audit_factura_dml
    AFTER INSERT OR UPDATE OR DELETE
    ON finanzas."Factura"
    FOR EACH ROW EXECUTE FUNCTION seguridad.fn_auditoria_dml();
```

La tabla `seguridad."Auditoria"` guarda: tabla afectada, operacion, usuario de BD, fecha y el detalle del cambio en formato JSON.

**Demostracion en vivo:**
```sql
-- Hacer un cambio real
UPDATE finanzas."Factura" SET estado_pago = 'Pagado' WHERE id_factura = 21;

-- Ver el registro de auditoria
SELECT operacion, tabla_afectada, usuario_db, detalle_cambio
FROM seguridad."Auditoria"
WHERE operacion IN ('INSERT', 'UPDATE', 'DELETE')
ORDER BY id_auditoria DESC LIMIT 1;

-- Revertir el cambio
UPDATE finanzas."Factura" SET estado_pago = 'Pendiente' WHERE id_factura = 21;
```

**Script de verificacion:**
- `scripts_presentacion/15-mostrar-cambiosregistrados-tojsonb.sql` -- Hace un UPDATE, muestra la auditoria y revierte el cambio.

---

### 3.3 Event Trigger para DDL

**Que se hizo:** Se creo un event trigger que captura cambios estructurales (CREATE TABLE, ALTER TABLE, DROP, etc.) y los guarda en la tabla de Auditoria.

**Script:** `scripts_iniciales/03-triggers.sql`

```sql
CREATE OR REPLACE FUNCTION seguridad.fn_auditoria_ddl()
    RETURNS event_trigger
    LANGUAGE plpgsql
AS $function$
DECLARE
    obj record;
BEGIN
    FOR obj IN SELECT * FROM pg_event_trigger_ddl_commands()
    LOOP
        INSERT INTO seguridad."Auditoria" (tabla_afectada, operacion, detalle_cambio)
        VALUES (obj.object_identity, tg_tag, current_query());
    END LOOP;
END;
$function$;

CREATE EVENT TRIGGER trg_audit_ddl
    ON ddl_command_end
    EXECUTE FUNCTION seguridad.fn_auditoria_ddl();
```

Cada vez que se ejecuta un CREATE, ALTER o DROP, se guarda automaticamente el nombre del objeto, la operacion y la consulta completa.

**Script de verificacion:**
- `scripts_presentacion/16-mostrar-cambios-structurales-DEL-EVENT-TRIGGER.sql` -- Muestra los ultimos 5 cambios DDL registrados.

---

### 3.4 Sesiones Lentas y Bloqueos

**Que se hizo:** Se crearon consultas para detectar sesiones que llevan mas de 2 segundos activas (potencialmente problematicas) y para identificar deadlocks (bloqueos mutuos).

**Detectar sesiones lentas:**

**Script:** `scripts_presentacion/17-listar-sesiones-Lentas.sql`
```sql
SELECT pid, usename AS usuario, client_addr AS ip_cliente,
       state AS estado, now() - query_start AS duracion_query,
       query AS consulta_ejecutada
FROM pg_stat_activity
WHERE state = 'active' 
  AND (now() - query_start) > INTERVAL '2 seconds'
  AND pid <> pg_backend_pid();
```

**Simular una sesion lenta:**
- `scripts_presentacion/88-simular-sesion-lenta.sql` -- Ejecuta `SELECT pg_sleep(30)` para simular una consulta que tarda 30 segundos.

**Cancelar una sesion lenta:**
- `scripts_presentacion/99-CANCELAR-consulta-lenta-pgcancelback-CAMBIAR-PID.sql` -- Usa `pg_cancel_backend(PID)` para cancelar la consulta sin desconectar al usuario.

**Matar una sesion bloqueada (ultimo recurso):**
- `scripts_presentacion/77-matarTodo-desconectar-backTERMINATE-CAMBIAR-PID-OJO.sql` -- Usa `pg_terminate_backend(PID)` para desconectar al usuario por completo.

**Identificar deadlocks:**

**Script:** `scripts_presentacion/18-identificar-DEADLOCKS.sql`
```sql
SELECT pid AS victima_pid, usename AS victima_usuario,
       pg_blocking_pids(pid) AS bloqueado_por_pid,
       query AS consulta_atascada
FROM pg_stat_activity
WHERE cardinality(pg_blocking_pids(pid)) > 0;
```

**Simulacion de deadlock en vivo (requiere dos terminales):**

Terminal A -- `scripts_presentacion/19-PRIMER-DEADLOCK.sql`:
```sql
BEGIN;
UPDATE finanzas."Factura" SET estado_pago = 'Pendiente' WHERE id_factura = 21;
SELECT pg_sleep(30);
COMMIT;
```

Terminal B -- `scripts_presentacion/20-SEGUNDO-DEADLOCK.sql`:
```sql
UPDATE finanzas."Factura" SET estado_pago = 'Pagado' WHERE id_factura = 21;
-- Esta consulta se queda congelada esperando a que la Terminal A libere el bloqueo
```

Luego en una tercera terminal se ejecuta `18-identificar-DEADLOCKS.sql` para ver la victima y el PID que la bloquea. Se resuelve con `pg_cancel_backend()` o `pg_terminate_backend()`.

---

### 3.5 Top 5 Consultas Costosas

**Que se hizo:** Se habilito la extension `pg_stat_statements` (precargada en el docker-compose con `shared_preload_libraries`) para trackear el rendimiento de todas las consultas ejecutadas.

**Script:** `scripts_presentacion/21-consultas-Costosas-TOP5.sql`
```sql
SELECT substring(query, 1, 60) AS consulta,
       calls AS veces_ejecutada,
       round(total_exec_time::numeric, 2) AS tiempo_total_ms,
       round((total_exec_time / calls)::numeric, 2) AS tiempo_promedio_ms
FROM pg_stat_statements
ORDER BY total_exec_time DESC
LIMIT 5;
```

Esta consulta muestra las 5 consultas que mas tiempo total han consumido en el motor, con el numero de veces que se ejecutaron y el tiempo promedio por ejecucion. Sirve para identificar cuellos de botella y decidir si se necesitan indices o refactorizar queries.

---

## Semana 4 -- Backup, Recuperacion y Entrega Final

### 4.1 Backup Logico + Roles Globales

**Que se hizo:** Se creo un script que genera dos respaldos:
1. Backup logico de la base de datos completa con `pg_dump`.
2. Backup de roles globales con `pg_dumpall --globals-only`.

**Script:** `backup/01-generar-backups.sh`

```bash
# Backup logico (estructura + datos en formato custom)
docker exec -i -e PGPASSWORD=$PASSWORD_BD $CONTENEDOR \
  pg_dump -U postgres -h localhost -d bd-viva -F c > bd-viva.backup

# Backup de roles globales (usuarios, contrasenas cifradas, membresías)
docker exec -i -e PGPASSWORD=$PASSWORD_BD $CONTENEDOR \
  pg_dumpall -U postgres -h localhost --globals-only > roles_globales.sql
```

**Archivos generados:**
- `backup/bd-viva.backup` -- Backup binario de la base de datos (104 KB aprox.)
- `backup/roles_globales.sql` -- Script SQL con los roles, contrasenas cifradas (SCRAM-SHA-256) y membresías (`GRANT rol TO usuario`).

---

### 4.2 Restauracion y Validacion Post-Restore

**Que se hizo:** Se creo un script que restaura el backup en una base de datos nueva (`empresa_restore`) y valida la integridad comparando el conteo de tablas y registros entre la original y la clon.

**Script:** `backup/02-restaurar-y-validar.sh` y `backup/03-restaurar-mas-tablas.sh`

```bash
# Crear base limpia
docker exec -i -e PGPASSWORD=$PASSWORD_BD $CONTENEDOR \
  dropdb -U postgres -h localhost --if-exists empresa_restore
docker exec -i -e PGPASSWORD=$PASSWORD_BD $CONTENEDOR \
  createdb -U postgres -h localhost empresa_restore

# Restaurar el backup
docker exec -i -e PGPASSWORD=$PASSWORD_BD $CONTENEDOR \
  pg_restore -U postgres -h localhost -d empresa_restore < bd-viva.backup
```

**Validacion:**
```bash
# Comparar cantidad de tablas en el esquema finanzas
echo "Base Original:"
psql -d bd-viva -c "SELECT count(*) FROM information_schema.tables WHERE table_schema = 'finanzas';"
echo "Base Clon:"
psql -d empresa_restore -c "SELECT count(*) FROM information_schema.tables WHERE table_schema = 'finanzas';"

# Comparar registros en Factura
echo "Facturas Original:"
psql -d bd-viva -c 'SELECT count(*) FROM finanzas."Factura";'
echo "Facturas Clon:"
psql -d empresa_restore -c 'SELECT count(*) FROM finanzas."Factura";'
```

Si ambos conteos coinciden, la restauracion fue exitosa.

---

### 4.3 Script Maestro setup_seguridad.sql

Todos los scripts en `scripts_iniciales/` se ejecutan automaticamente al levantar el contenedor por primera vez, gracias al volumen:

```yaml
volumes:
  - ./scripts_iniciales:/docker-entrypoint-initdb.d
```

Docker ejecuta los scripts en orden alfabetico:
1. `01-roles.sql` -- Roles y usuarios
2. `02-ddl-24-05-2026.sql` -- Esquemas, tablas, FK, RLS
3. `03-triggers.sql` -- Triggers de auditoria
4. `04-permisos.sql` -- Ajuste granular de privilegios
5. `05-correccion-roles-inherit.sql` -- Correccion de herencia
6. `06-correccion-columnas.sql` -- Seguridad por columna
7. `07-correccion-revoke-public.sql` -- Revoke public
8. `08-tables-views.sql` -- Vistas seguras
9. `09-add-factura-paraauditoria.sql` -- Trigger en Factura

Para reproducir todo desde cero en un entorno Docker limpio:
```bash
docker compose down -v       # Borrar todo (datos incluidos)
docker compose up -d --build # Reconstruir desde cero
```

---

### 4.4 Documento Tecnico Final

**Arquitectura de seguridad:**
- 7 esquemas separados por area de negocio.
- 4 roles de grupo + 4 usuarios con el principio de minimo privilegio.
- RLS en tablas sensibles (Factura, Consumo).
- Vistas seguras para ocultar columnas de PII.
- Seguridad por columna en datos financieros.

**Matriz de roles:**

| Rol | Acceso principal | Nivel |
|-----|-----------------|-------|
| `rol_app` | Operaciones CRUD del backend | Lectura + escritura limitada |
| `rol_admin_promo` | Promociones y fidelizacion | CRUD en comercial, lectura en fidelizacion |
| `rol_auditor` | Monitoreo y auditoria | Solo lectura |
| `rol_reporte` | Reportes gerenciales | Solo lectura |

**Politica de auditoria:**
- Trigger DML en tablas criticas (Plan, Factura) con `to_jsonb()`.
- Event Trigger DDL para cambios estructurales.
- pgAudit para registros a nivel del motor.
- Logs nativos con `log_connections` y `log_statement`.

**RPO/RTO:**
- RPO (Recovery Point Objective): Se puede perder como maximo los datos desde el ultimo `pg_dump` ejecutado.
- RTO (Recovery Time Objective): Restauracion completa con `pg_restore` en minutos.

---

### 4.5 Uso de Docker

La solucion esta completamente containerizada con Docker Compose.

**Dockerfile:**
```dockerfile
FROM postgres:16
RUN apt-get update && apt-get install -y postgresql-16-pgaudit
```

**docker-compose.yml:**
```yaml
version: '3.8'
services:
  postgres_viva:
    build: .
    container_name: contenedor-postgres-viva
    restart: always
    command: ["postgres",
      "-c", "shared_preload_libraries=pg_stat_statements,pgaudit",
      "-c", "log_connections=on",
      "-c", "log_statement=ddl",
      "-c", "pgaudit.log=write,ddl",
      "-c", "pgaudit.log_relation=on",
      "-c", "pgaudit.log_parameter=on"
    ]
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: tbdviva
      POSTGRES_DB: bd-viva
    ports:
      - "5433:5432"
    volumes:
      - ./datos_postgres_viva:/var/lib/postgresql/data
      - ./scripts_iniciales:/docker-entrypoint-initdb.d
```

**Reproducir el entorno completo:**
```bash
docker compose up -d --build
```

---

## Relacion con el Primer Parcial

Este proyecto extiende la base de datos disenada en el primer parcial (sistema de telecomunicaciones VIVA). Se mantiene la misma estructura de esquemas y tablas, y sobre ella se aplican las capas de seguridad requeridas:
- Hardening de la configuracion del motor.
- Control de acceso granular a nivel de tabla, columna y fila.
- Auditoria y monitoreo en tiempo real.
- Politica de respaldos y restauracion.

---

## Guia Rapida para la Demostracion en Vivo

| Paso | Script | Que se demuestra |
|------|--------|-----------------|
| 1 | `00-version-psql.sql` | Version de PostgreSQL |
| 2 | Mostrar `pg_hba.conf` | Hardening de red |
| 3 | `01-mostrar-usuario-y-rol-asignado.sql` | Roles y usuarios creados |
| 4 | `04-mostrar-revoke-public.sql` | Public revocado |
| 5 | `05-mostrar-esquemas-conpropietario.sql` | Esquemas separados |
| 6 | `06-mostrar-permisos-alastabla-por-rol.sql` | GRANT granulares |
| 7 | `07-mostrar-permisos-porColumna.sql` | Seguridad por columna |
| 8 | `08-verificar-rls.sql` | Politicas RLS activas |
| 9 | `12-demo-politicas-rls.sql` | Demo RLS en vivo |
| 10 | `10-evidencia-table-view.sql` | Vista segura de marketing |
| 11 | `13-verificar-logs-nativos-on-ddl.sql` | Logs nativos activos |
| 12 | `14-verificar-install-pgaudit.sql` | pgAudit instalado |
| 13 | `15-mostrar-cambiosregistrados-tojsonb.sql` | Auditoria DML |
| 14 | `16-mostrar-cambios-structurales-DEL-EVENT-TRIGGER.sql` | Auditoria DDL |
| 15 | `88-simular-sesion-lenta.sql` + `17-listar-sesiones-Lentas.sql` | Sesion lenta detectada |
| 16 | `99-CANCELAR-consulta-lenta-pgcancelback-CAMBIAR-PID.sql` | Cancelar sesion lenta |
| 17 | `19-PRIMER-DEADLOCK.sql` + `20-SEGUNDO-DEADLOCK.sql` | Simular deadlock |
| 18 | `18-identificar-DEADLOCKS.sql` | Detectar deadlock |
| 19 | `21-consultas-Costosas-TOP5.sql` | Top 5 queries costosas |
| 20 | `backup/01-generar-backups.sh` | Generar backups |
| 21 | `backup/02-restaurar-y-validar.sh` | Restaurar y validar |
