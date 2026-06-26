-- =============================================================
-- TRIGGER PARA ACTUALIZAR BOLSILLO Y APLICAR DOBLE CARGA
-- =============================================================

CREATE OR REPLACE FUNCTION finanzas.fn_actualizar_bolsillo_recarga()
    RETURNS trigger
    LANGUAGE plpgsql
    SECURITY DEFINER
AS $function$
DECLARE
    v_es_dia_doble_carga BOOLEAN := FALSE;
    v_ya_recibio_bono BOOLEAN := FALSE;
    v_monto_final NUMERIC(10,2);
BEGIN
    -- 1. Verificar si hoy es día de Doble Carga (Día 1 del mes o Promoción Activa)
    IF EXTRACT(DAY FROM CURRENT_TIMESTAMP) = 1 THEN
        v_es_dia_doble_carga := TRUE;
    ELSE
        SELECT EXISTS (
            SELECT 1 FROM comercial."Promocion"
            WHERE nombre_promo ILIKE '%Doble Carga%'
              AND CURRENT_TIMESTAMP BETWEEN fecha_inicio AND fecha_fin
        ) INTO v_es_dia_doble_carga;
    END IF;

    -- 2. Verificar si el cliente YA usó su bono este mes (buscando recargas anteriores con aplicar_bono = true)
    SELECT EXISTS (
        SELECT 1 FROM finanzas."Recarga"
        WHERE id_linea = NEW.id_linea
          AND id_recarga != NEW.id_recarga
          AND aplicar_bono = TRUE
          AND date_trunc('month', fecha_recarga) = date_trunc('month', CURRENT_TIMESTAMP)
    ) INTO v_ya_recibio_bono;

    -- 3. Validar y Calcular el monto final a abonar
    IF NEW.aplicar_bono THEN
        -- Seguridad a nivel de BD: si el cliente manda aplicar_bono=true pero no le toca, BLOQUEAR.
        IF NOT v_es_dia_doble_carga THEN
            RAISE EXCEPTION 'No se puede aplicar Doble Carga porque hoy no es día de promoción ni día 1 del mes.';
        END IF;

        IF v_ya_recibio_bono THEN
            RAISE EXCEPTION 'Fraude bloqueado: El cliente ya utilizó su beneficio de Doble Carga este mes.';
        END IF;

        v_monto_final := NEW.monto * 2;
    ELSE
        v_monto_final := NEW.monto;
    END IF;

    -- 4. Actualizar el saldo de dinero en el bolsillo del cliente
    UPDATE finanzas."Bolsillo"
    SET saldo_dinero = saldo_dinero + v_monto_final
    WHERE id_linea = NEW.id_linea;

    RETURN NEW;
END;
$function$;

DROP TRIGGER IF EXISTS trg_actualizar_bolsillo_recarga ON finanzas."Recarga";

CREATE TRIGGER trg_actualizar_bolsillo_recarga
    AFTER INSERT
    ON finanzas."Recarga"
    FOR EACH ROW
    EXECUTE FUNCTION finanzas.fn_actualizar_bolsillo_recarga();
