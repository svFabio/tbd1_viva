#!/bin/bash

# ==========================================
# CONFIGURACIÓN 
# ==========================================
CONTENEDOR="contenedor-postgres-viva"
USUARIO="postgres"
PASSWORD_BD="tbdviva"

echo "======================================================="
echo " INICIANDO RESTAURACIÓN Y VALIDACIÓN (FILAS 3 Y 4)"
echo "======================================================="

# 1. Preparar el terreno: Borrar si ya existe y crear la nueva BD vacía para restaurar
echo "[*] Creando base de datos limpia 'empresa_restore'..."
docker exec -i -e PGPASSWORD=$PASSWORD_BD $CONTENEDOR dropdb -U $USUARIO -h localhost --if-exists empresa_restore
docker exec -i -e PGPASSWORD=$PASSWORD_BD $CONTENEDOR createdb -U $USUARIO -h localhost empresa_restore

# FILA 3: Restauración en nueva base de datos usando pg_restore
echo "[*] Ejecutando pg_restore en 'empresa_restore'..."
docker exec -i -e PGPASSWORD=$PASSWORD_BD $CONTENEDOR pg_restore -U $USUARIO -h localhost -d empresa_restore < bd-viva.backup

echo "-------------------------------------------------------"
echo " RECONCILIACIÓN DE DATOS (FILA 4: VALIDACIÓN POST-RESTORE)"
echo "-------------------------------------------------------"

# 1. CONTEO TOTAL DE TABLAS EN EL ESQUEMA 'finanzas'
echo "[*] Comparando CANTIDAD TOTAL DE TABLAS en el esquema 'finanzas':"
echo -n " -> Base Original (bd-viva): "
docker exec -i -e PGPASSWORD=$PASSWORD_BD $CONTENEDOR psql -U $USUARIO -h localhost -d bd-viva -t -c "SELECT count(*) FROM information_schema.tables WHERE table_schema = 'finanzas';" | tr -d ' '

echo -n " -> Base Clon (empresa_restore): "
docker exec -i -e PGPASSWORD=$PASSWORD_BD $CONTENEDOR psql -U $USUARIO -h localhost -d empresa_restore -t -c "SELECT count(*) FROM information_schema.tables WHERE table_schema = 'finanzas';" | tr -d ' '

echo ""
# 2. CONTEO DE REGISTROS (Múltiples tablas para cubrir la rúbrica al 100%)
echo "[*] Comparando REGISTROS de la tabla 'Factura':"
echo -n " -> Base Original: "
docker exec -i -e PGPASSWORD=$PASSWORD_BD $CONTENEDOR psql -U $USUARIO -h localhost -d bd-viva -t -c 'SELECT count(*) FROM finanzas."Factura";' | tr -d ' '
echo -n " -> Base Clon: "
docker exec -i -e PGPASSWORD=$PASSWORD_BD $CONTENEDOR psql -U $USUARIO -h localhost -d empresa_restore -t -c 'SELECT count(*) FROM finanzas."Factura";' | tr -d ' '

echo ""
echo "[*] Comparando REGISTROS de la tabla 'Cliente':"
echo -n " -> Base Original: "
docker exec -i -e PGPASSWORD=$PASSWORD_BD $CONTENEDOR psql -U $USUARIO -h localhost -d bd-viva -t -c 'SELECT count(*) FROM finanzas."Cliente";' | tr -d ' '
echo -n " -> Base Clon: "
docker exec -i -e PGPASSWORD=$PASSWORD_BD $CONTENEDOR psql -U $USUARIO -h localhost -d empresa_restore -t -c 'SELECT count(*) FROM finanzas."Cliente";' | tr -d ' '

echo ""
echo "======================================================="
echo " ¡PROCESO DE CLONACIÓN Y VALIDACIÓN COMPLETADO!"
echo "======================================================="
