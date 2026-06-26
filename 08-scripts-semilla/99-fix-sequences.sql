DO $$
DECLARE
    r record;
    seq_val bigint;
    max_id bigint;
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
        -- Execute a query to find the maximum ID value in the table
        EXECUTE format('SELECT MAX(%I) FROM %I.%I', r.column_name, r.table_schema, r.table_name)
        INTO max_id;
        
        -- Default to 1 if the table is empty
        max_id := COALESCE(max_id, 1);
        
        -- Set the sequence value
        EXECUTE format('SELECT setval(pg_get_serial_sequence(%L, %L), %L)',
                       r.table_schema || '.' || r.table_name, r.column_name, max_id);
                       
        RAISE NOTICE 'Secuencia de %.% ajustada a %', r.table_schema, r.table_name, max_id;
    END LOOP;
END;
$$;
