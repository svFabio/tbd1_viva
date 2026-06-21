SHOW log_connections;
SHOW log_statement;

--ddl Solo registra cuando creas, alteras o borras cosas (CREATE, ALTER, DROP). No ve datos.
--NO usamos all ni mod qeu registra ddl+ modificaciones de datos(insert,update,delete)


--para habilitarlo usamos igual en el compose esta
--ALTER SYSTEM SET log_connections = 'on';
--ALTER SYSTEM SET log_statement = 'ddl';
