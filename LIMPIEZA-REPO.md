# Plan de Limpieza y Reorganización del Repositorio

> **Estado:** Pendiente de ejecución  
> **Fuente de verdad:** `0001-proyecto-viva-ULTIMATE/`  
> **Objetivo:** Que al clonar el repo y hacer `docker compose up`, se levante exactamente la BD aprobada.

---

## 🔍 Diagnóstico

### Contenido de ULTIMATE (aprobado)

`0001-proyecto-viva-ULTIMATE/proyecto-bd-viva/` contiene:

| Carpeta/Archivo | Contenido | ¿Va al repo? |
|-----------------|-----------|:---:|
| `Dockerfile` | Imagen con pgAudit | ✅ → raíz |
| `docker-compose.yml` | Compose con pgAudit + pg_stat_statements | ✅ → raíz |
| `scripts_iniciales/` | 9 scripts SQL (DDL, roles, triggers, permisos) | ✅ → `13-scripts-iniciales/` |
| `scripts_semilla/` | 2 scripts de datos (seed) | ✅ → `14-scripts-semilla/` |
| `scripts_presentacion/` | 26 scripts de demo + subcarpeta `444-trigger/` | ✅ → `15-scripts-presentacion/` |
| `backup/` | 3 scripts .sh + `roles_globales.sql` + `bd-viva.backup` | ✅ scripts, ❌ .backup |
| `datos_postgres_viva/` | Volumen Docker (binarios) | ❌ .gitignore |
| `datos_postgres_clon/` | Volumen Docker (binarios) | ❌ .gitignore |
| `datos_postgres_prueba/` | Volumen Docker (binarios) | ❌ .gitignore |
| `pgaudit.log` | Log temporal | ❌ .gitignore |
| `.10-seguridad-por-columna.sql.swp` | Archivo temporal de vim | ❌ eliminar |

Fuera de `proyecto-bd-viva/` pero dentro de ULTIMATE:

| Archivo | Contenido | ¿Va al repo? |
|---------|-----------|:---:|
| `roles_NUEVO.sql` | Dump de pg_dumpall (estado real del servidor) | ✅ → `16-backup/` |
| `backup_bd_viva_NUEVO.backup` | Backup binario | ❌ .gitignore |

### Problemas detectados en ULTIMATE

1. **`01-roles.sql` no tiene `BYPASSRLS`** para `rol_auditor` ni `u_aurelio_casillas`. El servidor aprobado sí lo tiene (confirmado en `roles_NUEVO.sql` línea 23 y 33). Si alguien levanta el compose, el auditor NO tendrá BYPASSRLS.

2. **Falta `10-finanzas-rol-permisos.sql`** — los permisos de `rol_finanzas` se crearon durante la re-defensa pero no se integraron al ULTIMATE.

3. **Archivos basura:** `.swp`, `pgaudit.log`, volúmenes Docker.

### Duplicados fuera de ULTIMATE (eliminar)

| Carpeta | Por qué es duplicada |
|---------|---------------------|
| `50-docker/` | Versión incompleta (solo 4 scripts vs 9 en ULTIMATE) |
| `13-scripts-iniciales/` (raíz actual) | Copia antigua del root, ya reemplazada por ULTIMATE |
| `14-scripts-semilla/` (raíz actual) | Copia antigua del root |
| `15-scripts-presentacion/` (raíz actual) | Copia del root (sin `444-trigger/`) |
| `16-backup/` (raíz actual) | Copia del root |
| `datos_postgres_viva/` (raíz) | Volumen Docker binario |

---

## ✅ Estructura Final

```
tbd1_viva/
├── .gitignore
├── README.md
├── LICENSE
├── Dockerfile                          ← desde ULTIMATE
├── docker-compose.yml                  ← desde ULTIMATE (actualizar ruta)
│
├── 00-administrativo/
├── 01-planteamiento/
├── 02-requerimientos/
├── 03-modelo-conceptual/
├── 04-modelo-logico/
├── 05-modelo-fisico/
├── 06-sql/
├── 07-seguridad/
├── 08-datos/
├── 09-consultas-y-reportes/
├── 10-documentacion-tecnica/
│   └── soluciones-propuestas.md
├── 11-presentacion/
├── 12-entregables/
│
├── 13-scripts-iniciales/               ← desde ULTIMATE/proyecto-bd-viva/scripts_iniciales/
│   ├── 01-roles.sql                    ← CORREGIR: agregar BYPASSRLS
│   ├── 02-ddl-24-05-2026.sql
│   ├── 03-triggers.sql
│   ├── 04-permisos.sql
│   ├── 05-correccion-roles-inherit.sql
│   ├── 06-correccion-columnas.sql
│   ├── 07-correccion-revoke-public.sql
│   ├── 08-tables-views.sql
│   ├── 09-add-factura-paraauditoria.sql
│   └── 10-finanzas-rol-permisos.sql    ← AGREGAR (creado en re-defensa)
│
├── 14-scripts-semilla/                 ← desde ULTIMATE
│   ├── 01-seed-new.sql
│   └── 02-seed-fix.sql
│
├── 15-scripts-presentacion/            ← desde ULTIMATE (incluye 444-trigger/)
│   ├── run.sh
│   ├── 00-version-psql.sql ... 21-*.sql
│   ├── 77-*, 88-*, 99-*
│   └── 444-trigger/
│       ├── 00_demo_dml.sql
│       ├── 01_verificacion.sql
│       ├── 02_demo_ddl.sql
│       ├── 04_verificacion_ddl.sql
│       └── run.sh
│
├── 16-backup/                          ← desde ULTIMATE
│   ├── 01-generar-backups.sh
│   ├── 02-restaurar-y-validar.sh
│   ├── 03-restaurar-mas-tablas.sh
│   ├── roles_globales.sql
│   └── roles_NUEVO.sql                 ← desde ULTIMATE raíz
│
├── 99-anexos/                          ← mantener (borradores, imágenes, material docente)
├── 9998-actividades-images/
└── 9999-retrospective/
```

---

## 📝 .gitignore

```gitignore
# Volúmenes Docker (binarios, no versionables)
datos_postgres_*/

# Backups binarios
*.backup
*.dump

# Logs
*.log

# Archivos temporales
*.swp
*~

# Carpetas de trabajo (ya integradas)
0001-proyecto-viva-ULTIMATE/
50-docker/
```

---

## 📋 Pasos de Ejecución

```bash
# ── PASO 1: Eliminar las copias antiguas del root ──────────────────
rm -rf 13-scripts-iniciales/
rm -rf 14-scripts-semilla/
rm -rf 15-scripts-presentacion/
rm -rf 16-backup/

# ── PASO 2: Copiar contenido de ULTIMATE a las carpetas numeradas ──
cp -r "0001-proyecto-viva-ULTIMATE/proyecto-bd-viva/scripts_iniciales"    13-scripts-iniciales
cp -r "0001-proyecto-viva-ULTIMATE/proyecto-bd-viva/scripts_semilla"      14-scripts-semilla
cp -r "0001-proyecto-viva-ULTIMATE/proyecto-bd-viva/scripts_presentacion" 15-scripts-presentacion
cp -r "0001-proyecto-viva-ULTIMATE/proyecto-bd-viva/backup"               16-backup

# ── PASO 3: Copiar Dockerfile y docker-compose desde ULTIMATE ──────
cp "0001-proyecto-viva-ULTIMATE/proyecto-bd-viva/Dockerfile"       Dockerfile
cp "0001-proyecto-viva-ULTIMATE/proyecto-bd-viva/docker-compose.yml" docker-compose.yml

# ── PASO 4: Mover roles_NUEVO.sql al backup ────────────────────────
cp "0001-proyecto-viva-ULTIMATE/roles_NUEVO.sql" 16-backup/

# ── PASO 5: Limpiar basura copiada de ULTIMATE ─────────────────────
rm -f "13-scripts-iniciales/.10-seguridad-por-columna.sql.swp"
rm -f "15-scripts-presentacion/pgaudit.log"
rm -f "16-backup/bd-viva.backup"

# ── PASO 6: Actualizar docker-compose.yml para nuevas rutas ────────
# (cambiar ./scripts_iniciales por ./13-scripts-iniciales en la línea de volumes)
# HACER MANUALMENTE o con el editor

# ── PASO 7: Eliminar duplicados ────────────────────────────────────
rm -rf 50-docker/
rm -rf datos_postgres_viva/

# ── PASO 8: Actualizar .gitignore ──────────────────────────────────
# (agregar entradas del bloque de arriba)

# ── PASO 9: Commit ─────────────────────────────────────────────────
git add -A
git commit -m "chore: reorganización desde ULTIMATE — estructura numerada y limpieza de duplicados"
```

### Correcciones pendientes después de la reorganización:

1. **Agregar BYPASSRLS en `13-scripts-iniciales/01-roles.sql`:**
   - Cambiar: `CREATE ROLE rol_auditor NOLOGIN NOINHERIT;`
   - Por: `CREATE ROLE rol_auditor NOLOGIN NOINHERIT BYPASSRLS;`

2. **Agregar `10-finanzas-rol-permisos.sql` a `13-scripts-iniciales/`:**
   - Este archivo fue creado durante la re-defensa y contiene los permisos de `rol_finanzas`.
   - No existe en ULTIMATE, hay que crearlo.

---

> **Nota:** Una vez ejecutados todos los pasos, `0001-proyecto-viva-ULTIMATE/` queda en el `.gitignore` como referencia histórica pero no se sube al repo. Si prefieres conservarla en el repo como archivo histórico, quítala del `.gitignore`.
