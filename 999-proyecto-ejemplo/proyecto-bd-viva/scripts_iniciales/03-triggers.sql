-- =============================================================
-- FUNCIONES DE AUDITORÍA (requeridas por los triggers)
-- =============================================================

CREATE OR REPLACE FUNCTION seguridad.fn_auditoria_dml()
    RETURNS trigger
    LANGUAGE plpgsql
AS $function$
BEGIN
    IF (TG_OP = 'DELETE') THEN
        INSERT INTO seguridad."Auditoria" (tabla_afectada, operacion, detalle_cambio)
        VALUES (TG_TABLE_NAME, 'DELETE', to_jsonb(OLD)::text);
        RETURN OLD;
    ELSIF (TG_OP = 'UPDATE') THEN
        INSERT INTO seguridad."Auditoria" (tabla_afectada, operacion, detalle_cambio)
        VALUES (TG_TABLE_NAME, 'UPDATE', to_jsonb(NEW)::text);
        RETURN NEW;
    ELSIF (TG_OP = 'INSERT') THEN
        INSERT INTO seguridad."Auditoria" (tabla_afectada, operacion, detalle_cambio)
        VALUES (TG_TABLE_NAME, 'INSERT', to_jsonb(NEW)::text);
        RETURN NEW;
    END IF;
    RETURN NULL;
END;
$function$;

CREATE OR REPLACE FUNCTION seguridad.fn_auditoria_ddl()
    RETURNS event_trigger
    LANGUAGE plpgsql
AS $function$
DECLARE
    obj record;
BEGIN
    FOR obj IN SELECT * FROM pg_event_trigger_ddl_commands()
    LOOP
        INSERT INTO seguridad."Auditoria" (tabla_afectada, operacion, detalle_cambio)
        VALUES (obj.object_identity, tg_tag, current_query());
    END LOOP;
END;
$function$;

-- =============================================================
-- TRIGGERS DML
-- =============================================================

-- Auditoría sobre lineas."Plan" (INSERT, UPDATE, DELETE)
DROP TRIGGER IF EXISTS trg_audit_dml ON lineas."Plan";

CREATE TRIGGER trg_audit_dml
    AFTER INSERT OR DELETE OR UPDATE
    ON lineas."Plan"
    FOR EACH ROW
    EXECUTE FUNCTION seguridad.fn_auditoria_dml();

CREATE EVENT TRIGGER trg_audit_ddl
    ON ddl_command_end
    EXECUTE FUNCTION seguridad.fn_auditoria_ddl();
