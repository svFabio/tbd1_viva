#!/bin/bash
# =====================================================================
# SEMANA 4: BACKUP Y RESTORE — Comandos para la presentación
# Ejecutar desde: azureuser@tbdviva:~$
# =====================================================================


# ── PASO 1: GENERAR EL BACKUP ──────────────────────────────────────
# Genera el backup de bd-viva en formato comprimido custom (-Fc)
# El archivo queda dentro del contenedor en /tmp/
docker exec -u postgres contenedor-postgres-viva pg_dump -Fc bd-viva -f /tmp/backup_bd_viva.backup

# Copia el archivo del contenedor al servidor Azure (al home del usuario)
docker cp contenedor-postgres-viva:/tmp/backup_bd_viva.backup ~/backup_bd_viva.backup

# Verificar que el archivo existe y su tamaño
ls -lh ~/backup_bd_viva.backup


# ── PASO 2: PREPARAR LA BASE DE DATOS DE DESTINO ──────────────────
# ⚠️ Si ya existe bd-viva-restore de una prueba anterior, primero bórrala:
docker exec -u postgres contenedor-postgres-viva dropdb --if-exists bd-viva-restore

# Crear la base de datos vacía de destino
docker exec -u postgres contenedor-postgres-viva createdb bd-viva-restore


# ── PASO 3: RESTAURAR EL BACKUP ────────────────────────────────────
# Copia el backup de vuelta al contenedor para poder restaurar
docker cp ~/backup_bd_viva.backup contenedor-postgres-viva:/tmp/backup_bd_viva.backup

# Restaurar el backup en la base de datos nueva
docker exec -u postgres contenedor-postgres-viva pg_restore -d bd-viva-restore /tmp/backup_bd_viva.backup


# ── PASO 4: VALIDAR LA RESTAURACIÓN ───────────────────────────────
# Verificar que todas las tablas fueron restauradas correctamente
# Deberían aparecer las mismas 29 tablas que en bd-viva
docker exec -u postgres contenedor-postgres-viva psql -d bd-viva-restore -c "
SELECT schemaname, tablename
FROM pg_tables
WHERE schemaname NOT IN ('pg_catalog','information_schema')
ORDER BY schemaname, tablename;"

# Verificar conteo de filas en una tabla clave para confirmar que los datos están
docker exec -u postgres contenedor-postgres-viva psql -d bd-viva-restore -c "
SELECT 
    'clientes.Persona_Natural' AS tabla, COUNT(*) AS filas FROM clientes.\"Persona_Natural\"
UNION ALL SELECT 
    'finanzas.Factura', COUNT(*) FROM finanzas.\"Factura\"
UNION ALL SELECT
    'lineas.Linea', COUNT(*) FROM lineas.\"Linea\";"
