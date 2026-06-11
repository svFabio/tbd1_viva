#!/bin/bash

# ==========================================
# CONF
# ==========================================
CONTENEDOR="contenedor-postgres-viva"
USUARIO="postgres"
PASSWORD_BD="tbdviva"

echo "======================================================="
echo " INICIANDO POLÍTICA DE RESPALDOS (FILAS 1 Y 2)"
echo "======================================================="

# FILA 1: Backup lógico (Estructura + Datos usando tu clave real)
echo "[*] Ejecutando pg_dump para la base de datos 'bd-viva'..."
docker exec -i -e PGPASSWORD=$PASSWORD_BD $CONTENEDOR pg_dump -U $USUARIO -h localhost -d bd-viva -F c > bd-viva.backup

# FILA 2: Backup de roles globales
echo "[*] Ejecutando pg_dumpall para roles globales..."
docker exec -i -e PGPASSWORD=$PASSWORD_BD $CONTENEDOR pg_dumpall -U $USUARIO -h localhost --globals-only > roles_globales.sql

echo "======================================================="
echo " BACKUPS COMPLETADOS. ARCHIVOS GENERADOS CON ÉXITO:"
echo "======================================================="
ls -lh bd-viva.backup roles_globales.sql
