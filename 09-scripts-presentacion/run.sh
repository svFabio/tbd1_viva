#!/bin/bash
echo "Ejecutando script: $1"
docker exec -u postgres -i contenedor-postgres-viva psql -d bd-viva < "$1"
