
SELECT
    id_auditoria,
    tabla_afectada,
    operacion,
    fecha,
    detalle_cambio
FROM seguridad."Auditoria"
WHERE operacion IN ('COMMENT', 'CREATE INDEX', 'ALTER TABLE')
ORDER BY id_auditoria DESC
LIMIT 1;


-- ── Opcional: ver TODOS los eventos DDL registrados hasta ahora ──
-- SELECT id_auditoria, tabla_afectada, operacion, fecha
-- FROM seguridad."Auditoria"
-- WHERE operacion NOT IN ('INSERT','UPDATE','DELETE')
-- ORDER BY id_auditoria DESC;
