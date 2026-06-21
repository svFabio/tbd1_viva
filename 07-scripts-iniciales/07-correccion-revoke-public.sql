SELECT setval(pg_get_serial_sequence('seguridad."Auditoria"', 'id_auditoria'), coalesce(max(id_auditoria), 0) + 1, false) FROM seguridad."Auditoria";
ALTER TABLE seguridad."Auditoria" ALTER COLUMN tabla_afectada DROP NOT NULL;
REVOKE ALL ON SCHEMA public FROM PUBLIC;

