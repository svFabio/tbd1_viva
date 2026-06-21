#!/bin/bash

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
# Le inyectamos tu archivo binario directo a la nueva base vacía
echo "[*] Ejecutando pg_restore en 'empresa_restore'..."
docker exec -i -e PGPASSWORD=$PASSWORD_BD $CONTENEDOR pg_restore -U $USUARIO -h localhost -d empresa_restore < bd-viva.backup

echo "-------------------------------------------------------"
echo " RECONCILIACIÓN DE DATOS (FILA 4: VALIDACIÓN POST-RESTORE)"
echo "-------------------------------------------------------"

# FILA 4: Validación de integridad mediante conteo de registros
echo "[*] Comparando cantidad de registros en la tabla 'Factura':"
echo -n " -> Base Original (bd-viva): "
docker exec -i -e PGPASSWORD=$PASSWORD_BD $CONTENEDOR psql -U $USUARIO -h localhost -d bd-viva -t -c 'SELECT count(*) FROM finanzas."Factura";' | tr -d ' '

echo -n " -> Base Clon (empresa_restore): "
docker exec -i -e PGPASSWORD=$PASSWORD_BD $CONTENEDOR psql -U $USUARIO -h localhost -d empresa_restore -t -c 'SELECT count(*) FROM finanzas."Factura";' | tr -d ' '

echo "======================================================="
echo " ¡PROCESO DE CLONACIÓN Y VALIDACIÓN COMPLETADO!"
echo "======================================================="
