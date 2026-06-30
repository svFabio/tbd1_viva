DO $$
DECLARE
    r record;
    max_id bigint;
    full_table text;
    full_col   text;
BEGIN
    FOR r IN
        SELECT
            table_schema,
            table_name,
            column_name
        FROM information_schema.columns
        WHERE table_schema NOT IN ('information_schema', 'pg_catalog')
          AND is_identity = 'YES'
    LOOP
        -- Nombre completo con comillas dobles para tablas con mayúsculas ("Promocion", "Paquete", etc.)
        full_table := format('%I.%I', r.table_schema, r.table_name);
        full_col   := r.column_name;

        -- Máximo ID actual en la tabla
        EXECUTE format('SELECT COALESCE(MAX(%I), 1) FROM %s', full_col, full_table)
        INTO max_id;

        -- Ajustar la secuencia
        PERFORM setval(pg_get_serial_sequence(full_table, full_col), max_id);

        RAISE NOTICE 'Secuencia de %.% ajustada a %', r.table_schema, r.table_name, max_id;
    END LOOP;
END;
$$;
