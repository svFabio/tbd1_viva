-- =============================================================
-- FUNCIONES DE AUDITORÍA (requeridas por los triggers)
-- =============================================================

CREATE OR REPLACE FUNCTION seguridad.fn_auditoria_dml()
    RETURNS trigger
    LANGUAGE plpgsql
    SECURITY DEFINER
AS $function$
DECLARE
    v_usuario varchar(50);
BEGIN
    -- Capturamos el usuario real (inyectado por Laravel o por DBeaver)
    v_usuario := COALESCE(current_setting('app.current_web_user', true), CURRENT_USER::text);

    IF (TG_OP = 'DELETE') THEN
        INSERT INTO seguridad."Auditoria" (tabla_afectada, operacion, usuario_db, detalle_cambio)
        VALUES (TG_TABLE_NAME, 'DELETE', v_usuario, to_jsonb(OLD)::text);
        RETURN OLD;
    ELSIF (TG_OP = 'UPDATE') THEN
        INSERT INTO seguridad."Auditoria" (tabla_afectada, operacion, usuario_db, detalle_cambio)
        VALUES (TG_TABLE_NAME, 'UPDATE', v_usuario, to_jsonb(NEW)::text);
        RETURN NEW;
    ELSIF (TG_OP = 'INSERT') THEN
        INSERT INTO seguridad."Auditoria" (tabla_afectada, operacion, usuario_db, detalle_cambio)
        VALUES (TG_TABLE_NAME, 'INSERT', v_usuario, to_jsonb(NEW)::text);
        RETURN NEW;
    END IF;
    RETURN NULL;
END;
$function$;

CREATE OR REPLACE FUNCTION seguridad.fn_auditoria_ddl()
    RETURNS event_trigger
    LANGUAGE plpgsql
    SECURITY DEFINER
AS $function$
DECLARE
    obj record;
    v_usuario varchar(50);
BEGIN
    v_usuario := COALESCE(current_setting('app.current_web_user', true), CURRENT_USER::text);

    FOR obj IN SELECT * FROM pg_event_trigger_ddl_commands()
    LOOP
        INSERT INTO seguridad."Auditoria" (tabla_afectada, operacion, usuario_db, detalle_cambio)
        VALUES (obj.object_identity, tg_tag, v_usuario, current_query());
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
