-- =============================================================
-- TRIGGER PARA ACTUALIZAR BOLSILLO Y APLICAR DOBLE CARGA
-- =============================================================

CREATE OR REPLACE FUNCTION finanzas.fn_actualizar_bolsillo_recarga()
    RETURNS trigger
    LANGUAGE plpgsql
AS $function$
DECLARE
    v_es_doble_carga BOOLEAN := FALSE;
    v_monto_final NUMERIC(10,2);
BEGIN
    -- 1. Verificar si hay una promoción de "Doble Carga" vigente hoy
    -- Buscamos en el esquema comercial si existe alguna promoción activa
    SELECT EXISTS (
        SELECT 1 FROM comercial."Promocion"
        WHERE nombre ILIKE '%Doble Carga%'
          AND CURRENT_TIMESTAMP BETWEEN fecha_inicio AND fecha_fin
    ) INTO v_es_doble_carga;

    -- 2. Calcular el monto final a abonar
    IF v_es_doble_carga THEN
        v_monto_final := NEW.monto * 2;
    ELSE
        v_monto_final := NEW.monto;
    END IF;

    -- 3. Actualizar el saldo de dinero en el bolsillo del cliente
    UPDATE finanzas."Bolsillo"
    SET saldo_dinero = saldo_dinero + v_monto_final
    WHERE id_linea = NEW.id_linea;

    -- 4. Opcional: Podríamos dejar un rastro en auditoría sobre si aplicó doble carga o no, 
    -- pero el UPDATE al bolsillo ya será auditado gracias al trg_audit_dml.

    RETURN NEW;
END;
$function$;

DROP TRIGGER IF EXISTS trg_actualizar_bolsillo_recarga ON finanzas."Recarga";

CREATE TRIGGER trg_actualizar_bolsillo_recarga
    AFTER INSERT
    ON finanzas."Recarga"
    FOR EACH ROW
    EXECUTE FUNCTION finanzas.fn_actualizar_bolsillo_recarga();
