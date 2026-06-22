#!/bin/bash
echo "========================================="
echo "Ejecutando scripts semilla y corrigiendo secuencias..."
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" -f /seeds/01-seed-new.sql
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" -f /seeds/02-seed-paquetes.sql
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" -f /seeds/02-seed-fix1.sql
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" -f /seeds/99-fix-sequences.sql
echo "Base de datos viva totalmente inicializada."
echo "========================================="
