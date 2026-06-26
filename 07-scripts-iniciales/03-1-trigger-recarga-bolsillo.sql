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

    -- 2. Si hoy es día de doble carga, verificamos si el cliente YA recibió un bono este mes
    IF v_es_dia_doble_carga THEN
        SELECT EXISTS (
            SELECT 1 FROM finanzas."Recarga"
            WHERE id_linea = NEW.id_linea
              AND id_recarga != NEW.id_recarga -- Excluir la recarga actual
              AND date_trunc('month', fecha_recarga) = date_trunc('month', CURRENT_TIMESTAMP)
              AND (
                  EXTRACT(DAY FROM fecha_recarga) = 1
                  OR EXISTS (
                      SELECT 1 FROM comercial."Promocion"
                      WHERE nombre_promo ILIKE '%Doble Carga%'
                        AND fecha_recarga BETWEEN fecha_inicio AND fecha_fin
                  )
              )
        ) INTO v_ya_recibio_bono;
    END IF;

    -- 3. Calcular el monto final a abonar (solo 1 bono por mes)
    IF v_es_dia_doble_carga AND NOT v_ya_recibio_bono THEN
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
