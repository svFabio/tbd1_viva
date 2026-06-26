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
        VALUES (TG_TABLE_NAME, 'DELETE', v_usuario, row_to_json(OLD)::text);
        RETURN OLD;
    ELSIF (TG_OP = 'UPDATE') THEN
        INSERT INTO seguridad."Auditoria" (tabla_afectada, operacion, usuario_db, detalle_cambio)
        VALUES (TG_TABLE_NAME, 'UPDATE', v_usuario, json_build_object('anterior', row_to_json(OLD), 'nuevo', row_to_json(NEW))::text);
        RETURN NEW;
    ELSIF (TG_OP = 'INSERT') THEN
        INSERT INTO seguridad."Auditoria" (tabla_afectada, operacion, usuario_db, detalle_cambio)
        VALUES (TG_TABLE_NAME, 'INSERT', v_usuario, row_to_json(NEW)::text);
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
        VALUES (COALESCE(obj.object_identity, 'Operación de DB'), tg_tag, v_usuario, current_query());
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

-- =============================================================
-- TRIGGER ANTI-FRAUDE EN FACTURAS
-- =============================================================
CREATE OR REPLACE FUNCTION finanzas.fn_prevent_fraud_factura()
    RETURNS trigger
    LANGUAGE plpgsql
AS $function$
BEGIN
    IF NEW.monto_total IS DISTINCT FROM OLD.monto_total OR 
       NEW.id_linea IS DISTINCT FROM OLD.id_linea OR
       NEW.fecha_emision IS DISTINCT FROM OLD.fecha_emision THEN
        RAISE EXCEPTION 'FRAUDE DETECTADO: No está permitido modificar el monto, la línea o la fecha de una factura emitida.';
    END IF;
    RETURN NEW;
END;
$function$;

DROP TRIGGER IF EXISTS trg_prevent_fraud_factura ON finanzas."Factura";

CREATE TRIGGER trg_prevent_fraud_factura
    BEFORE UPDATE
    ON finanzas."Factura"
    FOR EACH ROW
    EXECUTE FUNCTION finanzas.fn_prevent_fraud_factura();


CREATE EVENT TRIGGER trg_audit_ddl
    ON ddl_command_end
    EXECUTE FUNCTION seguridad.fn_auditoria_ddl();
