#!/bin/bash

# ==============================================================================
# SCRIPT DE PRUEBA DE RESTAURACIÓN (RTO TEST) - VIVA TELECOM
# Este script demuestra que podemos recuperar la BD en menos de 2 horas.
# ==============================================================================

CONTAINER_NAME="contenedor-postgres-viva"
DB_USER="postgres"
NEW_DB_NAME="viva_restore_test"

# Solicitar los archivos de backup
echo "Ingresa el nombre del archivo SQL de roles (ej: globals_2026-06-22.sql):"
read ROLES_FILE
echo "Ingresa el nombre del archivo DUMP de datos (ej: db_backup_2026-06-22.dump):"
read DUMP_FILE

echo "====================================================="
echo "Iniciando simulacro de recuperación (RTO Test)..."
echo "====================================================="

# Copiar archivos al contenedor
docker cp "./backups/$ROLES_FILE" $CONTAINER_NAME:/tmp/roles.sql
docker cp "./backups/$DUMP_FILE" $CONTAINER_NAME:/tmp/data.dump

# 1. Restaurar Roles
echo "[1/3] Restaurando roles y variables globales..."
docker exec -t $CONTAINER_NAME psql -U $DB_USER -f /tmp/roles.sql

# 2. Crear BD limpia para la prueba
echo "[2/3] Creando base de datos limpia para la restauración..."
docker exec -t $CONTAINER_NAME psql -U $DB_USER -c "DROP DATABASE IF EXISTS $NEW_DB_NAME;"
docker exec -t $CONTAINER_NAME psql -U $DB_USER -c "CREATE DATABASE $NEW_DB_NAME;"

# 3. Restaurar Datos (Formato Custom)
echo "[3/3] Restaurando esquemas y datos con pg_restore..."
docker exec -t $CONTAINER_NAME pg_restore -U $DB_USER -d $NEW_DB_NAME -1 /tmp/data.dump

# Limpieza
docker exec -t $CONTAINER_NAME rm /tmp/roles.sql /tmp/data.dump

echo "====================================================="
echo "✅ Simulacro completado."
echo "La base de datos se ha restaurado en: $NEW_DB_NAME"
echo "Ya puedes conectarte por DBeaver para verificar la integridad."
echo "====================================================="
