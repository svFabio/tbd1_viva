CREATE OR REPLACE TRIGGER trg_audit_factura_dml
AFTER INSERT OR UPDATE OR DELETE ON finanzas."Factura"
FOR EACH ROW EXECUTE FUNCTION seguridad.fn_auditoria_dml();

CREATE OR REPLACE TRIGGER trg_auditoria_servicios_paquete
AFTER INSERT OR UPDATE OR DELETE ON servicios."Paquete"
FOR EACH ROW EXECUTE FUNCTION seguridad.fn_auditoria_dml();
