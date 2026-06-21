SELECT 
    operacion, 
    tabla_afectada, 
    usuario_db, 
    fecha, 
    detalle_cambio
FROM seguridad."Auditoria"
WHERE operacion NOT IN ('INSERT', 'UPDATE', 'DELETE')
ORDER BY id_auditoria DESC
LIMIT 5;
