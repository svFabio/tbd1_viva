
SELECT
    id_auditoria,
    tabla_afectada,
    operacion,
    usuario_db,
    fecha,
    detalle_cambio -> 'old' AS valor_anterior,
    detalle_cambio -> 'new' AS valor_nuevo
FROM seguridad."Auditoria"
WHERE tabla_afectada = 'Cliente'
ORDER BY id_auditoria DESC
LIMIT 1;



-- ── Opcional: filtrar por un cambio específico de estado ────
-- SELECT * FROM seguridad."Auditoria"
-- WHERE detalle_cambio -> 'old' ->> 'estado' = 'Activo';
