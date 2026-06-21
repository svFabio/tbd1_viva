-- SCRIPT: 01-verificar-usuarios.sql
-- OBJETIVO: Mostrar qué usuario tiene qué rol y su tipo (Nominal / No Nominal)

SELECT r.rolname AS nombre_de_usuario,
       r1.rolname AS rol_asignado,
       CASE 
           WHEN r.rolname = 'u_app' THEN 'No Nominal (Sistema/App)'
           ELSE 'Nominal (Persona Física)'
       END AS tipo_de_usuario
FROM pg_roles r
JOIN pg_auth_members m ON r.oid = m.member
JOIN pg_roles r1 ON m.roleid = r1.oid
WHERE r.rolcanlogin = true;
