#!/bin/bash

# ==============================================================================
# SCRIPT DE BACKUP DIARIO (LÓGICO) - VIVA TELECOM
# Cumple con el RPO de 24 hrs y RTO de 2 hrs.
# ==============================================================================

# Variables de configuración
CONTAINER_NAME="contenedor-postgres-viva"
DB_USER="postgres"
DB_NAME="bd-viva"
BACKUP_DIR="./backups"
DATE=$(date +"%Y-%m-%d_%H-%M-%S")

# Crear carpeta de backups si no existe
mkdir -p "$BACKUP_DIR"

echo "====================================================="
echo "Iniciando proceso de Backup para $DB_NAME..."
echo "Fecha y Hora: $DATE"
echo "====================================================="

# 1. Backup de la Base de Datos (Estructura y Datos) - Formato Custom comprimido (-F c)
echo "[1/3] Extrayendo base de datos principal (Formato Custom)..."
docker exec -t $CONTAINER_NAME pg_dump -U $DB_USER -d $DB_NAME -F c -f /tmp/db_backup_$DATE.dump
docker cp $CONTAINER_NAME:/tmp/db_backup_$DATE.dump "$BACKUP_DIR/db_backup_$DATE.dump"

# 2. Backup de Roles y Permisos Globales (Globals Only)
echo "[2/3] Extrayendo roles y variables globales (Globals-only)..."
docker exec -t $CONTAINER_NAME pg_dumpall -U $DB_USER --globals-only -f /tmp/globals_$DATE.sql
docker cp $CONTAINER_NAME:/tmp/globals_$DATE.sql "$BACKUP_DIR/globals_$DATE.sql"

# Limpieza dentro del contenedor
docker exec -t $CONTAINER_NAME rm /tmp/db_backup_$DATE.dump /tmp/globals_$DATE.sql

# 3. Aplicar Política de Retención (Eliminar backups más antiguos de 7 días)
echo "[3/3] Aplicando política de retención (7 días)..."
find "$BACKUP_DIR" -type f -name "*.dump" -mtime +7 -exec rm {} \;
find "$BACKUP_DIR" -type f -name "*.sql" -mtime +7 -exec rm {} \;

echo "====================================================="
echo "✅ Backup completado exitosamente."
echo "Archivos guardados en: $BACKUP_DIR"
echo "====================================================="
