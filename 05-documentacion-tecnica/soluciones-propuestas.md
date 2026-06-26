# Soluciones Propuestas — Re-defensa

> **Contexto:** Defensa fallida el 2026-06-15. Re-defensa en 3 días.  
> Este documento recoge todos los errores señalados por el evaluador (S1) durante la sesión,
> interpreta qué se quiso demostrar y propone qué hay que corregir / preparar sin tocar los scripts ya existentes.

---

## Resumen ejecutivo de lo que salió mal

| # | Área | Problema detectado | Severidad |
|---|------|--------------------|-----------|
| 1 | Semana 1 — `postgresql.conf` | `listen_addresses = '*'` no tiene justificación válida | 🔴 No conformidad |
| 2 | Semana 1 — `pg_hba.conf` | Líneas redundantes (IPv4 127.0.0.1 + IPv6 ::1 repiten lo que ya cubren las líneas `local`) | 🟡 Observación |
| 3 | Semana 1 — `pg_hba.conf` | Línea de `replication` apunta a sí mismo (debería ser al otro host) | 🟡 Observación |
| 4 | Semana 1 — Roles | Falta el rol de **finanzas/ventas** (solo existen comercial, auditor y reporte) | 🔴 No conformidad |
| 5 | Semana 2 — Seguridad por columna | No se pudo demostrar EN VIVO que un usuario NO puede ver una columna concreta | 🔴 No conformidad |
| 6 | Semana 2 — RLS | La demo con `SET app.current_linea_id` es válida pero "forzada"; el evaluador quería ver dos usuarios reales con `SET ROLE` distintos haciendo el mismo `SELECT` y obteniendo filas diferentes | 🟠 Observación grave |
| 7 | Semana 2 — Vistas seguras | No se demostró que el usuario `rol_comercial` NO puede hacer `SELECT` a la **tabla física**, pero SÍ a la **vista** | 🔴 No conformidad |
| 8 | Semana 3 — pgAudit | El evaluador quería ver el **archivo de log de pgAudit** (`.log`), no solo la extensión instalada | 🟡 Observación |
| 9 | Semana 3 — Trigger DML | Falta demostrar en vivo: ejecutar un `DELETE`/`INSERT`/`UPDATE` y luego mostrar que quedó registrado en la tabla de auditoría | 🟠 Observación grave |
| 10 | Semana 3 — Sesiones lentas / deadlocks | Se tiene el script de sleep pero no se ejecutó el flujo completo: forzar → detectar → matar | 🟡 Observación |
| 11 | Semana 4 — Backup/restore | No se llegó a demostrar en vivo; el evaluador lo pidió explícitamente | 🟠 Observación grave |

---

## Detalle de problemas y soluciones

---

### 🔴 Problema 1 — `listen_addresses = '*'` (postgresql.conf)

**Qué dijo el evaluador:**  
> *"Ese asterisco fácilmente se convierte en una no conformidad. No hay necesidad. Debería decir `127.0.0.1` directamente."*

**Por qué es un problema:**  
La BD vive dentro de un contenedor Docker en una VM de Azure. Nadie se conecta directamente al puerto 5432 desde internet: primero se conectan a la VM (con llave SSH) y desde ahí entran al contenedor. Por lo tanto escuchar en TODAS las interfaces (`*`) viola el principio de mínimo privilegio.

**Solución:**  
En el archivo `postgresql.conf` (o en el Dockerfile/docker-compose que lo genera):
```
# ANTES (incorrecto)
listen_addresses = '*'

# DESPUÉS (correcto para entorno Docker en VM)
listen_addresses = '127.0.0.1'
```

> **Nota para la defensa:** Preparar la explicación verbal: *"Lo cambiamos a 127.0.0.1 porque el único acceso legítimo al motor es desde dentro del mismo contenedor o desde la VM host vía túnel Docker. No existe ningún cliente externo que se conecte directamente al puerto 5432."*

---

### 🟡 Problema 2 — Líneas redundantes en `pg_hba.conf`

**Qué dijo el evaluador:**  
> *"Las líneas 3 y 4 dicen exactamente lo mismo que tu línea 2. Es redundante."*

**Qué pasó:**  
Hay entradas duplicadas: una con `127.0.0.1/32` y otra con `::1/128` (IPv6) que replican el comportamiento de las entradas `local`. PostgreSQL procesa `pg_hba.conf` de arriba hacia abajo; las entradas `local` ya cubren las conexiones locales sin necesidad de especificar la IP.

**Solución:**  
Eliminar las líneas duplicadas de tipo `host` que apuntan a `127.0.0.1/32` y `::1/128` cuando ya existen entradas `local` equivalentes. Dejar solo:
- Entradas `local` para conexiones por socket Unix
- Entradas `host` únicamente para IPs reales de clientes remotos (whitelist)

---

### 🟡 Problema 3 — Línea de `replication` mal configurada

**Qué dijo el evaluador:**  
> *"Dice a sí mismo. En realidad debería ser de la otra computadora."*

**Qué pasó:**  
Hay una línea de `replication` en `pg_hba.conf` que acepta conexión desde el mismo host (`127.0.0.1`). La replicación en PostgreSQL es de host A → host B; no tiene sentido replicar a sí mismo.

**Solución:**  
- Si **no hay replicación implementada**: eliminar esa línea y en la defensa explicar que es una configuración de ejemplo que se había dejado por error.
- Si **sí hay replicación**: cambiar la IP al host del servidor esclavo real.

---

### 🔴 Problema 4 — Falta el rol de finanzas/ventas

**Qué dijo el evaluador:**  
> *"Faltaría el de finanzas. El de finanzas debería ver las tablas donde se está moviendo dinero."*

**Mapa real de permisos sobre `finanzas.*` (según [`04-permisos.sql`](file:///e:/9.%20tbd/tbd1_viva/scripts_iniciales/04-permisos.sql)):**

| Rol | Tablas de `finanzas` accesibles | Permisos |
|-----|--------------------------------|----------|
| `rol_comercial` | Ninguna | — |
| `rol_auditor` | Bolsillo, Factura, Recarga, T_Presta, Transaccion, Transfuzion | SELECT |
| `rol_reporte` | Bolsillo, Factura, Recarga, T_Presta, Transaccion, Transfuzion | SELECT |
| `rol_app` *(no nominal)* | Bolsillo, Factura, Recarga, T_Presta, Transaccion, Transfuzion | SELECT + INSERT |

**Lo que realmente falta:**  
Las tablas de `finanzas` **si tienen permisos asignados** — `rol_auditor` y `rol_reporte` las leen, y `rol_app` (la aplicacion) inserta transacciones. Lo que no existe es un rol para un **operador humano del area financiera** que pueda gestionar esas tablas directamente, no solo leerlas ni hacerlo via app.

**Dos opciones para responder al evaluador:**

> **Opcion A — Defender el diseno actual (sin tocar scripts, recomendada):**  
> *"El area de finanzas opera a traves de la aplicacion (`rol_app`). Ningun operador humano inserta facturas directamente en la BD — lo hace el sistema. Los roles de auditor y reporte tienen lectura completa de `finanzas` para control y supervision."*  
> Esto es valido si la arquitectura lo justifica.

> **Opcion B — Reconocer el gap y proponer diseno:**  
> *"Reconocemos que falta un `rol_finanzas` para operadores humanos. Su alcance seria SELECT + INSERT + UPDATE sobre `finanzas.Factura`, `finanzas.Recarga`, `finanzas.T_Presta`, `finanzas.Bolsillo`. Se asignaria a usuarios como Casillas y Jean que ya existen en el sistema sin rol operativo claro."*

---

### 🟠 Problema 4b — `rol_comercial` tiene DELETE en tablas comerciales

**Qué dijo el evaluador** (timestamp 00:48:45 — 00:50:04):
> Discutiendo si `rol_comercial` podría borrar una promoción mal configurada, el evaluador dijo:  
> *"Hay que evaluar si esta posibilidad es recurrente y va a generar espacio... pero si no hay que manejar estados y el estado de ese [registro] Inactivo o equivocado. Puede que alguien cree una promoción que no debería haber existido jamás. Entonces puede ser inactivado."*

**Lo que el grupo respondió:**  
> Fabio (S5): *"Yo creo que lo mejor es deshabilitar. Deshabilitar..."*  
> El evaluador confirmó: *"Sí, exactamente."* — refiriéndose a manejar un estado en lugar de eliminar.

**Qué hay actualmente en el código** ([`02-ddl-24-05-2026.sql`](file:///e:/9.%20tbd/tbd1_viva/scripts_iniciales/02-ddl-24-05-2026.sql)):

```sql
-- rol_comercial tiene DELETE en todas las tablas del esquema comercial:
GRANT INSERT, DELETE, SELECT, UPDATE ON TABLE comercial."Promocion"           TO rol_comercial;
GRANT INSERT, DELETE, SELECT, UPDATE ON TABLE comercial."Condicion_Promocion"  TO rol_comercial;
GRANT INSERT, DELETE, SELECT, UPDATE ON TABLE comercial."Numero_Amigo"         TO rol_comercial;
GRANT INSERT, DELETE, SELECT, UPDATE ON TABLE comercial."Promocion_Linea"      TO rol_comercial;
GRANT INSERT, DELETE, SELECT, UPDATE ON TABLE fidelizacion."Condicion_Puntos"  TO rol_comercial;

-- Además el script 04-permisos.sql agregó DELETE en servicios:
GRANT SELECT, INSERT, UPDATE, DELETE ON servicios."Paquete"             TO rol_comercial;
GRANT SELECT, INSERT, UPDATE, DELETE ON servicios."App_Exenta_En_Bolsa" TO rol_comercial;
```

**Por qué es un problema:**  
En un sistema de telecomunicaciones real, eliminar una promoción que ya fue asignada a clientes rompe la integridad referencial y borra el historial. La práctica correcta es manejar un campo de **estado** (`activo`/`inactivo`) y solo hacer UPDATE sobre ese campo. DELETE debería estar reservado para el DBA.

**Solución — Argumento verbal para la defensa:**

> *"Reconocemos que otorgar DELETE a `rol_comercial` fue una decisión incorrecta. En un entorno de producción, una promoción no se elimina — se desactiva. La tabla `comercial.Promocion` debería tener una columna `estado` (activo/inactivo/error_usuario) y el gestor de promociones solo tendría UPDATE sobre ese campo. Esto además permite que auditoría pueda ver el historial completo de lo que existió."*

**Lo que habría que corregir (mencionar en la defensa, no ejecutar en vivo):**

```sql
-- Revocar DELETE de las tablas comerciales y de servicios para rol_comercial
REVOKE DELETE ON comercial."Promocion"           FROM rol_comercial;
REVOKE DELETE ON comercial."Condicion_Promocion"  FROM rol_comercial;
REVOKE DELETE ON comercial."Numero_Amigo"         FROM rol_comercial;
REVOKE DELETE ON comercial."Promocion_Linea"      FROM rol_comercial;
REVOKE DELETE ON fidelizacion."Condicion_Puntos"  FROM rol_comercial;
REVOKE DELETE ON servicios."Paquete"              FROM rol_comercial;
REVOKE DELETE ON servicios."App_Exenta_En_Bolsa"  FROM rol_comercial;
-- El rol quedaría con SELECT, INSERT, UPDATE únicamente.
-- El "borrado lógico" se hace con UPDATE estado = 'inactivo'.
```

---

### 🔴 Problema 5 — Seguridad por columna: no se demostró en vivo (y no está implementado)

**Qué dijo el evaluador (Transcript 01:28:48):**  
> *"Con el rol de reportes puede ver la tabla, pero no puede ver todas sus columnas. ¿Por qué? Porque está restringido solo para que vea la columna Nombre, Apellido. No puede ver carné de identidad. Ah, entonces estás aplicando seguridad por columnas."*

**Qué pasó:**  
Ustedes mostraron un script con metadatos, pero el evaluador quería ver la denegación real (`ERROR: permission denied for column...`). 
Peor aún: **actualmente su base de datos NO tiene seguridad por columnas**. Todos los GRANT para `rol_reporte` o `rol_auditor` son a nivel de tabla completa.

**Solución — Implementarlo y demostrarlo en la re-defensa:**

He analizado toda la base de datos y hay **DOS casos de uso perfectos** con alto valor de negocio. Puedes elegir cualquiera de los dos (o mostrar ambos) en la defensa.

---

#### Opción A: Privacidad de Datos (PII) con `rol_reporte` (El ejemplo del evaluador)
Un analista que hace reportes estadísticos necesita saber nombres, pero **nunca** debería tener acceso al Carnet de Identidad (CI), ya que es un dato protegido por leyes de Privacidad (PII).

```sql
-- PREPARACIÓN (Ejecutar como postgres):
REVOKE SELECT ON clientes."Persona_Natural" FROM rol_reporte;
GRANT SELECT(id_persona, id_cliente, nombre, apellido, correo) ON clientes."Persona_Natural" TO rol_reporte;
```

**Guión de demostración en vivo (El escenario que sugirió el evaluador):**

```bash
# Terminal 1 - Conectarse como el superusuario (postgres)
psql -U postgres -d bd-viva

# El DBA tiene acceso a toda la tabla
bd-viva=# SELECT nombre, apellido, ci FROM clientes."Persona_Natural" LIMIT 3;
# (Muestra los datos correctamente, incluyendo el CI)
```

```bash
# Terminal 2 - Conectarse como la analista (u_rebeca_jones)
psql -U u_rebeca_jones -d bd-viva

# 1. SÍ puede extraer datos para su reporte (ÉXITO)
bd-viva=> SELECT nombre, apellido, correo FROM clientes."Persona_Natural" LIMIT 3;
# (Muestra los datos correctamente)

# 2. NO puede ver el CI por privacidad de datos (BLOQUEADO)
bd-viva=> SELECT nombre, apellido, ci FROM clientes."Persona_Natural";
# ERROR: permission denied for table Persona_Natural
```
> **Argumento verbal:** *"Ingeniero, tomando la sugerencia que nos dio en la defensa anterior: aquí mostramos el contraste directo. Por un lado, el usuario `postgres` puede ver todas las columnas. Pero por otro lado, nuestra analista de reportes solo tiene acceso a `nombre` y `correo`. Si intenta acceder al Carnet de Identidad, el motor la bloquea a nivel de columna, protegiendo este dato sensible."*

---

#### Opción B: Ciberseguridad con `rol_auditor` (El argumento "Mic Drop")
El `rol_auditor` tiene acceso a TODA la tabla `seguridad."Usuario_Sistema"`, incluyendo la columna `password_hash`. Un auditor malintencionado podría descargar los hashes y descifrarlos offline. **Nadie** debería poder leer esa columna directamente.

```sql
-- PREPARACIÓN (Ejecutar como postgres):
REVOKE SELECT ON seguridad."Usuario_Sistema" FROM rol_auditor;
GRANT SELECT(id_usuario, username, id_cliente) ON seguridad."Usuario_Sistema" TO rol_auditor;
```

**Guión de demostración en vivo:**

```bash
# Conectarse como el auditor (u_aurelio_casillas)
psql -U u_aurelio_casillas -d bd-viva

# 1. El auditor verifica qué usuarios existen en el sistema (ÉXITO)
bd-viva=> SELECT id_usuario, username, id_cliente FROM seguridad."Usuario_Sistema" LIMIT 3;
# (Muestra los datos correctamente)

# 2. El auditor intenta robar los hashes de contraseña (BLOQUEADO)
bd-viva=> SELECT username, password_hash FROM seguridad."Usuario_Sistema";
# ERROR: permission denied for table Usuario_Sistema
```
> **Argumento verbal:** *"Aquí demostramos que incluso con usuarios de alto privilegio aplicamos seguridad por columnas. El auditor interno, Aurelio, puede listar los usuarios del sistema para sus controles, pero tiene bloqueado el acceso físico a la columna `password_hash`. Esto evita riesgos de ataques de fuerza bruta internos."*

---

### 🔴 Problema 6 — RLS: lo que hicieron los otros grupos vs lo que tienen ustedes

**Transcript 01:16:01 — Fabio pregunta directamente:**
> *"Oye, por si acaso... otros grupos como no lo han aplicado eso?"*

**Evaluador responde (01:16:07):**
> *"Una columna, y ya han colocado el usuario correcto. Tu politica, lo unico que cambiaria seria que en vez de que diga `id_linea`, diria `el usuario`. Para que con el usuario que esta ejecutando la consulta coincida, y ahi salta solamente las filas que le corresponden."*

**Y luego (01:16:36):**
> *"Depende quien se ha conectado a la sesion. Si se conecta Pepsi solo va a haber las filas de Pepsi. Si se conecta Coca Cola solo va a haber las filas de Coca Cola."*

**Y en el resumen final (01:29:48):**
> *"Podrias colocar una columna donde diferencia que filas puede ver y que filas no pueden ver los usuarios."*

---

**Lo que hicieron los otros grupos — exactamente esto:**

Aggregaron una columna en la tabla con el nombre del usuario de BD, y la politica RLS compara con `current_user`:

```sql
-- La tabla tenia una columna extra:
ALTER TABLE alguna_tabla ADD COLUMN usuario_bd VARCHAR(50);
-- Datos de ejemplo:
-- fila 1: usuario_bd = 'u_adan_pereira'
-- fila 2: usuario_bd = 'u_rebeca_jones'

-- La politica:
CREATE POLICY ver_solo_lo_mio ON alguna_tabla
  USING (usuario_bd = current_user);
```

Con eso funciona exactamente como el evaluador queria:
```bash
# Terminal 1 - solo ve sus filas automaticamente
psql -U u_adan_pereira -d bd-viva
SELECT * FROM alguna_tabla;   -- solo filas donde usuario_bd = 'u_adan_pereira'

# Terminal 2 - diferente, sin tocar nada
psql -U u_rebeca_jones -d bd-viva
SELECT * FROM alguna_tabla;   -- solo filas donde usuario_bd = 'u_rebeca_jones'
```

---

**La mejor solucion — usar `seguridad."Auditoria"` que YA tiene la columna `usuario_db`:**

La tabla `seguridad."Auditoria"` tiene desde el DDL original:
```sql
usuario_db varchar(50) DEFAULT CURRENT_USER NULL
```

**Hay DOS tipos de registro en Auditoria (analisis exhaustivo del `03-triggers.sql`):**

| Trigger | Tipo | Quien lo genera | Ejemplos en seed |
|---------|------|-----------------|-----------------|
| `fn_auditoria_dml` | DML (INSERT/UPDATE/DELETE en tablas de negocio) | `u_app`, `u_adan_pereira` | 20 filas del seed |
| `trg_audit_ddl` (Event Trigger) | DDL (CREATE, ALTER, DROP, GRANT...) | Solo `postgres` o superusuarios | No hay en seed — son cambios estructurales |

**Insight clave:** `u_app` **JAMAS** generara registros DDL porque `rol_app` no tiene permisos de estructura. Los registros de `u_app` en `Auditoria` son DML de negocio (pagos de facturas, recargas, etc.). Los de `u_adan_pereira` son tambien DML (crear/editar promociones, registrar lineas).

**PREPARACIÓN (Ejecutar como postgres):**

```sql
-- 1. Dar acceso al esquema y a la tabla al rol_comercial
GRANT USAGE ON SCHEMA seguridad TO rol_comercial;
GRANT SELECT ON seguridad."Auditoria" TO rol_comercial;

-- 2. ACTIVAR RLS y crear la política:
ALTER TABLE seguridad."Auditoria" ENABLE ROW LEVEL SECURITY;

CREATE POLICY auditoria_propia ON seguridad."Auditoria"
  FOR SELECT
  USING (usuario_db = current_user);

-- 3. Excluir al auditor del RLS (BYPASSRLS no se hereda, debe darse al usuario final)
ALTER ROLE u_aurelio_casillas BYPASSRLS;
```

**Demostración en vivo paso a paso (Abre 2 terminales):**

```bash
# ==========================================
# TERMINAL 1: El usuario restringido (Adán)
# ==========================================
psql -U u_adan_pereira -d bd-viva
```

```sql
-- Adán intenta ver la auditoría. ¡Gracias a RLS solo ve SUS propios registros!
SELECT tabla_afectada, operacion, fecha, detalle_cambio 
FROM seguridad."Auditoria";
-- [RESULTADO ESPERADO]: Solo devuelve las filas donde él es el autor.
```

```bash
# ==========================================
# TERMINAL 2: El auditor sin restricciones (Aurelio)
# ==========================================
psql -U u_aurelio_casillas -d bd-viva
```

```sql
-- Aurelio consulta la MISMA tabla, pero él tiene el superpoder BYPASSRLS
SELECT usuario_db, tabla_afectada, operacion, fecha 
FROM seguridad."Auditoria";
-- [RESULTADO ESPERADO]: Devuelve TODAS las filas de la tabla (Adán, u_app, postgres, etc).
```

> **Argumento verbal infalible:** *"Ingeniero, la columna `usuario_db` asegura que cada empleado solo pueda consultar sus propias acciones gracias a la política RLS. Sin embargo, al usuario auditor se le otorgó el atributo especial `BYPASSRLS`, lo que le permite saltarse estas reglas y auditar la base de datos completa sin restricciones."*


---


### 🔴 Problema 7 — Vistas seguras: no se demostró acceso negado a tabla física

**Qué dijo el evaluador:**  
> *"Demuéstrame que ese usuario NO tiene acceso a la tabla física, pero SÍ tiene acceso a la vista."*

**Qué pasó:**  
Se demostró que `rol_comercial` puede ver `comercial.vista_lineas_marketing` (script `10-evidencia-table-view.sql`), pero no se demostró que NO puede hacer SELECT a la tabla base que alimenta esa vista.

**Solución — Guión de demostración en vivo (Abre 2 terminales):**

```bash
# ==========================================
# TERMINAL 1: El administrador (postgres)
# ==========================================
```

```sql
-- PASO 1: Asegurar el principio de mínimo privilegio.
-- Le quitamos el acceso a la tabla física y se lo damos a la vista
REVOKE SELECT ON lineas."Linea" FROM rol_comercial;
GRANT SELECT ON comercial.vista_lineas_marketing TO rol_comercial;
```

```bash
# ==========================================
# TERMINAL 2: El usuario final (Adán)
# ==========================================
psql -U u_adan_pereira -d bd-viva
```

```sql
-- PASO 2: Adán intenta fisgonear la tabla completa con datos sensibles
SELECT * FROM lineas."Linea";
-- [RESULTADO ESPERADO]: ERROR: permission denied for table "Linea"

-- PASO 3: Adán consulta la vista diseñada específicamente para él
SELECT * FROM comercial.vista_lineas_marketing LIMIT 10;
-- [RESULTADO ESPERADO]: Éxito. Muestra solo 'numero_telefono' y 'estado' de las líneas activas.
```

> ⚠️ **Verificar antes de la defensa:** Ejecutar este flujo en el entorno de desarrollo para confirmar que el REVOKE sobre la tabla base está aplicado y que el GRANT sobre la vista existe.

---

### 🟡 Problema 8 — pgAudit: mostrar el archivo de log

**Qué dijo el evaluador:**  
> *"pgAudit tiene un archivo de log, así como el error.log del Apache. Tiene un archivo que va escribiendo ciertas características de log. Eso te voy a pedir."*

**Qué hay actualmente:**  
Script `14-verificar-install-pgaudit.sql` que muestra que la extensión está instalada.

**Solución — Preparar el acceso al archivo de log (Docker Logs):**

Al usar Docker, PostgreSQL (por defecto) no escribe un archivo físico dentro de la carpeta `data/log/` (porque `logging_collector` está apagado). En su lugar, envía todo el log a la salida estándar del contenedor, que es **la mejor práctica en Docker**.

Para mostrarle el "archivo" de log de pgAudit al evaluador, debes ejecutar este comando en tu terminal de Windows/Mac (fuera del contenedor):

```bash
# Mostrar las últimas 50 líneas de auditoría del log de Docker
docker logs contenedor-postgres-viva 2>&1 | grep AUDIT | tail -n 50
```

> **Argumento verbal:** *"Como estamos usando buenas prácticas de contenedores (Docker), PostgreSQL no escribe un archivo de texto muerto en el disco, sino que emite los logs al stream estándar (stdout/stderr). Aquí podemos ver las trazas capturadas por pgAudit filtrando los logs del contenedor."*

---

### 🟠 Problema 9 — Trigger DML: demostración en vivo

**Qué dijo el evaluador:**  
> *"Voy a hacer un DELETE. Haces un DELETE y te tiene que registrar en tu tabla de auditoría."*

**Qué preparar (Guión Exacto para la Demo):**

> ⚠️ **IMPORTANTE:** Tu trigger DML solo está configurado actualmente en la tabla `lineas."Plan"`. ¡Tienes que hacer el DELETE en esa tabla, no en cualquier otra! Para no arruinar los datos reales, primero insertaremos un dato falso y luego lo borraremos.

```sql
-- 1. Entrar como postgres (superusuario) para evitar problemas de permisos
-- O puedes entrar con 'u_app' que tiene permisos de INSERT/DELETE en esta tabla

-- 2. Insertamos un plan falso (Esto dispara el trigger de INSERT)
INSERT INTO lineas."Plan" (nombre_plan, tarifa_mensual, tipo_plan) 
VALUES ('Plan Demo Trigger', 50.00, 'Prepago');

-- 3. Hacemos el DELETE que pidió el ingeniero
DELETE FROM lineas."Plan" WHERE nombre_plan = 'Plan Demo Trigger';

-- 4. Mostramos triunfalmente la tabla de auditoría (ordenada por el último evento)
SELECT operacion, tabla_afectada, detalle_cambio, fecha 
FROM seguridad."Auditoria" 
ORDER BY id_auditoria DESC LIMIT 2;

-- [RESULTADO ESPERADO]: 
-- Fila 1: operacion='DELETE', tabla='lineas."Plan"', detalle_cambio={...el json del plan...}
-- Fila 2: operacion='INSERT', tabla='lineas."Plan"', detalle_cambio={...el json del plan...}
```

> **Argumento verbal:** *"Como pidió, ingeniero. Acabo de insertar y luego hacer un DELETE sobre un registro en `lineas."Plan"`. Como puede ver en nuestra tabla principal de Auditoría, el Trigger atrapó ambos eventos, guardando dinámicamente el JSON exacto de los datos eliminados en la columna `detalle_cambio`."*

---

### 🟢 Problema 9.5 — Explicar la estructura del Trigger DML (¡Requisito del Docente!)

**Qué dijo el evaluador:**  
> *"Ah, entonces me tienes que mostrar tu trigger, la estructura del trigger."*

**Argumento técnico infalible para la defensa:**
> *"Ingeniero, nuestro trigger DML es **completamente genérico y dinámico**. En lugar de programar una función aburrida para cada tabla de la base de datos, desarrollamos `seguridad.fn_auditoria_dml()`. Esta función utiliza las variables especiales de PostgreSQL `TG_TABLE_NAME` (para detectar qué tabla disparó el evento) y `to_jsonb(NEW) / to_jsonb(OLD)` (para convertir dinámicamente toda la fila afectada en un objeto JSON puro).*
>
> *Gracias a este diseño escalable, si mañana decidimos auditar la tabla de Promociones porque Adán Pereira está insertando datos ahí, **no necesitamos programar funciones nuevas**. Solo ejecutamos 3 líneas de SQL para conectar esta función maestra a esa tabla."*

**Demostración en vivo (Opcional, para callar dudas):**

```sql
-- EN LA TERMINAL 1 (Como postgres / administrador):
-- 1. Conectar nuestra función genérica a la tabla Promocion
CREATE TRIGGER trg_audit_promocion_dml
AFTER INSERT OR UPDATE OR DELETE ON comercial."Promocion"
FOR EACH ROW EXECUTE FUNCTION seguridad.fn_auditoria_dml();

-- 2. Dar permiso de escritura y crear política RLS para INSERTS
GRANT INSERT ON seguridad."Auditoria" TO rol_comercial;

CREATE POLICY auditoria_insert ON seguridad."Auditoria"
  FOR INSERT
  WITH CHECK (usuario_db = current_user);
```

```bash
# EN LA TERMINAL 2 (Entrando como el usuario real):
psql -U u_adan_pereira -d bd-viva
```

```sql
-- 3. Hacer un UPDATE real
UPDATE comercial."Promocion" 
SET nombre_promo = 'Super Promo Defensa TBD' 
WHERE id_promocion = 1;

-- 4. Revisar la tabla de auditoría
SELECT tabla_afectada, operacion, usuario_db, detalle_cambio 
FROM seguridad."Auditoria" 
WHERE tabla_afectada = 'comercial.Promocion'
ORDER BY fecha DESC LIMIT 1;
-- ¡Aparecerá el registro capturado automáticamente en formato JSON!
```

---

### 🟠 Problema 10 — Sesiones lentas y deadlocks: flujo completo

**Qué dijo el evaluador:**  
> *"Fíjate, con esto voy a hacerlo lento. Ok, ahora fíjate, voy a agarrar y te voy a mostrar que esa consulta está lenta. Después de eso para el tema de bloqueos, me haces un script que genere un lock y me muestras en la tabla que corresponde."*

**Scripts disponibles:**
- `88-simular-sesion-lenta.sql` — genera una consulta lenta (sleep)
- `17-listar-sesiones-Lentas.sql` — detecta sesiones activas > 2 seg
- `18-identificar-DEADLOCKS.sql` — detecta bloqueos
- `19-PRIMER-DEADLOCK.sql` + `20-SEGUNDO-DEADLOCK.sql` — generan un deadlock
- `77-matarTodo-desconectar-backTERMINATE-CAMBIAR-PID.sql` — mata sesión
- `99-CANCELAR-consulta-lenta-pgcancelback-CAMBIAR-PID.sql` — cancela consulta

**Guión de presentación (usar 2 terminales):**

```
TERMINAL 1 (dentro del contenedor):
  → Ejecutar 88-simular-sesion-lenta.sql (deja la sesión dormida)

TERMINAL 2 (segunda ventana):
  → Ejecutar 17-listar-sesiones-Lentas.sql → mostrar la sesión atascada con su PID
  → Copiar el PID
  → Ejecutar 99-CANCELAR-consulta-lenta (con el PID copiado)
  → Mostrar que TERMINAL 1 terminó con error "query cancelled"
```

> ⚠️ **OJO con los scripts 77 y 99:** Tienen `-- CAMBIAR-PID` en el nombre porque requieren poner el PID real. Practicar el flujo para hacerlo fluido.

---

### 🟠 Problema 11 — Backup/restore: demostración en vivo

**Qué dijo el evaluador:**  
> *"El script maestro y el setup de seguridad: una cosa es parametrizar que levante todo tu container y otra cosa es cargar ese container toda la data. Son dos cosas diferentes."*

**Qué preparar:**

**Solución — Guión de demostración en vivo:**

```bash
# PASO 1: Generar el backup en formato comprimido (binario custom)
# Esto cumple el requisito: "pg_dump -F c -f empresa.backup"
docker exec contenedor-postgres-viva pg_dump -U postgres -F c -f /tmp/empresa.backup bd-viva

# PASO 2: Generar backup de roles globales
# Esto cumple el requisito: "pg_dumpall --globals-only"
docker exec contenedor-postgres-viva pg_dumpall -U postgres --globals-only -f /tmp/roles.sql

# PASO 3: Crear base de datos vacía para restaurar
docker exec contenedor-postgres-viva createdb -U postgres bd_restore

# PASO 4: Restaurar la base de datos desde el binario
# Esto cumple el requisito: "restauración selectiva o completa desde binario"
docker exec contenedor-postgres-viva pg_restore -U postgres -d bd_restore -1 /tmp/empresa.backup

# PASO 5: Validar integridad post-restore (Conteo de tablas comparativo)
# Ejecutar en la base original y en la restaurada para demostrar que miden lo mismo:
docker exec -u postgres contenedor-postgres-viva psql -d bd_restore -c "
  SELECT count(*) AS cantidad_tablas FROM pg_tables WHERE schemaname NOT IN ('pg_catalog','information_schema');
"
```

> 📌 El evaluador quiere ver: (1) que el archivo `.backup` existe y fue generado por `pg_dump -Fc`, (2) que se puede restaurar a un contenedor/BD diferente, (3) que el conteo de tablas/filas coincide con la original.

---

## Checklist de preparación para la re-defensa

### Antes de la defensa (técnico)
- [ ] Cambiar `listen_addresses = '*'` a `listen_addresses = '127.0.0.1'` en la config
- [ ] Limpiar líneas redundantes en `pg_hba.conf`
- [ ] Verificar (o corregir) la línea de `replication` en `pg_hba.conf`
- [ ] Verificar que el `GRANT SELECT(columna)` por columna está aplicado correctamente
- [ ] Ejecutar el flujo completo de vistas seguras (tabla física deniega → vista acepta)
- [ ] Ejecutar el trigger DML en vivo y confirmar que registra en la tabla de auditoría
- [ ] Localizar el archivo de log de pgAudit en el contenedor
- [ ] Practicar el flujo de sesión lenta con 2 terminales
- [ ] Practicar el flujo de deadlock con 2 terminales
- [ ] Confirmar que `pg_dump` genera el archivo y `pg_restore` a una BD nueva funciona

### Argumentos verbales a preparar
- [ ] **Por qué `listen_addresses = '127.0.0.1'`:** arquitectura Docker en VM (sin acceso directo externo)
- [ ] **Por qué la vista y no la tabla:** confidencialidad, principio de mínimo privilegio, filtrado de columnas sensibles
- [ ] **Por qué `SET app.current_linea_id`:** patrón multi-tenant estándar en PostgreSQL; en producción lo setea la API
- [ ] **Rol de finanzas faltante:** reconocer el gap y proponer el diseño correcto (`rol_finanzas` sobre esquema `finanzas` y `servicios`)

### Orden sugerido de presentación
1. **Semana 1:** `listen_addresses` corregido → `pg_hba.conf` limpio → roles (incluyendo explicar rol_finanzas faltante)
2. **Semana 2:** esquemas → permisos tabla → **demo columna** → **demo RLS con 2 sesiones** → **demo vista segura (deniega tabla + acepta vista)**
3. **Semana 3:** pgAudit log → trigger DML en vivo → sesión lenta + deadlock + matar
4. **Semana 4:** backup existe → restore en BD nueva → validación conteo

---

## Verificación contra las actividades oficiales

| Semana | Actividad (según imagen) | ¿Script disponible? | ¿Demo preparada? |
|--------|--------------------------|---------------------|------------------|
| 1 | Instalación segura | `00-version-psql.sql` | ✅ |
| 1 | Configurar red (`listen_addresses`) | *Corregir en config* | ⚠️ Pendiente corrección |
| 1 | Hardening `pg_hba.conf` | `04-mostrar-revoke-public.sql` | ⚠️ Pendiente limpieza |
| 1 | Crear usuarios base | `01-mostrar-usuario-y-rol-asignado.sql` | ✅ |
| 1 | Revocar permisos públicos | `04-mostrar-revoke-public.sql` | ✅ |
| 2 | Crear esquemas por área | `05-mostrar-esquemas-conpropietario.sql` | ✅ |
| 2 | Asignar privilegios por tabla | `02-mostrar-permisos-en-tablas-segun-rol.sql` / `06-mostrar-permisos-alastabla-por-rol.sql` | ✅ |
| 2 | Seguridad por columna | `07-mostrar-permisos-porColumna.sql` | ⚠️ Falta demo en vivo de ERROR |
| 2 | Implementar RLS | `08-verificar-rls.sql` | ✅ |
| 2 | Crear políticas RLS | `11-mostrar-politica.sql` / `12-demo-politicas-rls.sql` | ⚠️ Mejorar argumento verbal |
| 2 | Crear vistas seguras | `10-evidencia-table-view.sql` | ⚠️ Falta demo de tabla denegada |
| 3 | Configurar logs nativos | `13-verificar-logs-nativos-on-ddl.sql` | ✅ |
| 3 | Instalar pgAudit | `14-verificar-install-pgaudit.sql` | ⚠️ Falta mostrar archivo .log |
| 3 | Tabla de auditoría DML | `15-mostrar-cambiosregistrados-tojsonb.sql` | ⚠️ Falta demo trigger en vivo |
| 3 | Event trigger DDL | `16-mostrar-cambios-structurales-DEL-EVENT-TRIGGER.sql` | ⚠️ Falta demo en vivo |
| 3 | Consultar pg_stat_activity | `17-listar-sesiones-Lentas.sql` | ⚠️ Falta flujo 2 terminales |
| 3 | Identificar bloqueos | `18-identificar-DEADLOCKS.sql` | ⚠️ Falta flujo 2 terminales |
| 3 | Cancelar/terminar sesiones | `77-matarTodo` / `99-CANCELAR` | ⚠️ Recordar cambiar PID |
| 3 | Activar pg_stat_statements | `21-consultas-Costosas-TOP5.sql` | ✅ |
| 4 | Backup lógico | `pg_dump -Fc` | ⚠️ Confirmar archivo existe |
| 4 | Backup roles globales | `pg_dumpall --globals-only` | ⚠️ Confirmar |
| 4 | Restauración en nueva base | `pg_restore` | ⚠️ Practicar |
| 4 | Validación post-restore | Conteo tablas/filas | ⚠️ Preparar query |
| 4 | Documentar política de backup | RPO/RTO | ⚠️ Preparar argumento verbal |
