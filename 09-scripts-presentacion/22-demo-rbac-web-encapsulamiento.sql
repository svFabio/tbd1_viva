-- ==============================================================================
-- SCRIPT: 22-demo-rbac-web-encapsulamiento.sql
-- OBJETIVO: Demostrar en VIVO cómo el sistema VIVA aplica el principio de
--           Mínimo Privilegio (Least Privilege) mediante SET ROLE dinámico
--           para cada usuario que entra al Panel Web (Filament/Laravel).
--
-- CÓMO EJECUTAR:
--   bash run.sh 22-demo-rbac-web-encapsulamiento.sql
--
-- REQUISITOS: Conectarse como superusuario (postgres) o como u_admin_web
-- ==============================================================================


-- ==============================================================================
-- BLOQUE 0 — ESTADO INICIAL
-- Verificamos quién somos antes de simular nada.
-- ==============================================================================
\echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'
\echo ' BLOQUE 0 — Usuario de conexión actual (u_admin_web)'
\echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'

SELECT current_user AS "Conectado como", session_user AS "Usuario de sesión";


-- ==============================================================================
-- BLOQUE 1 — EL REGISTRO EN LA TABLA DE USUARIOS DE LA APP
-- Aquí se ve la fila que crea/usa Laravel para autenticar al usuario web.
-- El campo clave es rol_db: Laravel lo lee y ejecuta SET ROLE con ese valor.
-- ==============================================================================
\echo ''
\echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'
\echo ' BLOQUE 1 — Usuarios en la App Web (seguridad.Usuario_Sistema)'
\echo '            Estos son los que inician sesión en Filament'
\echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'

SELECT
    id_usuario,
    username,
    rol_db,
    CASE
        WHEN id_cliente IS NULL THEN 'Administrativo'
        ELSE 'Cliente (id=' || id_cliente::text || ')'
    END AS tipo_usuario
FROM seguridad."Usuario_Sistema"
ORDER BY rol_db, username;


-- ==============================================================================
-- BLOQUE 2 — SIMULACIÓN: Usuario ROL_COMERCIAL (adan.pereira)
-- Esto es exactamente lo que ejecuta el Middleware de Laravel cuando
-- adan.pereira inicia sesión en la web.
-- ==============================================================================
\echo ''
\echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'
\echo ' BLOQUE 2 — Simulación: adan.pereira (rol_comercial)'
\echo '            Middleware ejecuta: SET ROLE rol_comercial'
\echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'

SET ROLE rol_comercial;
SET app.current_web_user = 'adan.pereira';

\echo '-- ¿Quién soy ahora?'
SELECT current_user AS "Rol activo (SET ROLE aplicado)";

\echo '-- ✅ ACCESO PERMITIDO: Puedo ver Promociones (comercial.Promocion)'
SELECT id_promo, nombre_promo, fecha_inicio, fecha_fin
FROM comercial."Promocion"
LIMIT 5;

\echo '-- ✅ ACCESO PERMITIDO: Puedo ver Paquetes (servicios.Paquete)'
SELECT id_paquete, nombre_paquete, costo
FROM servicios."Paquete"
LIMIT 5;

\echo '-- ❌ ACCESO DENEGADO: No puedo ver Auditoría (seguridad.Auditoria)'
\echo '--    Se espera error: permission denied'
DO $$
BEGIN
    PERFORM * FROM seguridad."Auditoria" LIMIT 1;
    RAISE NOTICE 'ALERTA: Se pudo acceder a Auditoría — revisar permisos';
EXCEPTION WHEN insufficient_privilege THEN
    RAISE NOTICE '✅ CORRECTO: Acceso denegado a seguridad.Auditoria para rol_comercial';
END;
$$;

\echo '-- ❌ ACCESO DENEGADO: No puedo ver Facturas (finanzas.Factura)'
DO $$
BEGIN
    PERFORM * FROM finanzas."Factura" LIMIT 1;
    RAISE NOTICE 'ALERTA: Se pudo acceder a Facturas — revisar permisos';
EXCEPTION WHEN insufficient_privilege THEN
    RAISE NOTICE '✅ CORRECTO: Acceso denegado a finanzas.Factura para rol_comercial';
END;
$$;

RESET ROLE;
RESET app.current_web_user;


-- ==============================================================================
-- BLOQUE 3 — SIMULACIÓN: Usuario ROL_AUDITOR (aurelio.casillas)
-- Esto es lo que ejecuta el Middleware cuando aurelio.casillas inicia sesión.
-- ==============================================================================
\echo ''
\echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'
\echo ' BLOQUE 3 — Simulación: aurelio.casillas (rol_auditor)'
\echo '            Middleware ejecuta: SET ROLE rol_auditor'
\echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'

SET ROLE rol_auditor;
SET app.current_web_user = 'aurelio.casillas';

\echo '-- ¿Quién soy ahora?'
SELECT current_user AS "Rol activo (SET ROLE aplicado)";

\echo '-- ✅ ACCESO PERMITIDO: Puedo ver Auditoría'
SELECT id_auditoria, usuario_db, tabla_afectada, operacion, fecha
FROM seguridad."Auditoria"
ORDER BY fecha DESC
LIMIT 5;

\echo '-- ✅ ACCESO PERMITIDO: Puedo ver Usuarios del Sistema (solo lectura)'
SELECT id_usuario, username, rol_db
FROM seguridad."Usuario_Sistema"
WHERE id_cliente IS NULL
ORDER BY rol_db;

\echo '-- ❌ ACCESO DENEGADO: No puedo INSERTAR en Auditoría (solo SELECT+INSERT propio)'
\echo '-- ❌ ACCESO DENEGADO: No puedo ver Promociones comerciales'
DO $$
BEGIN
    PERFORM * FROM comercial."Promocion" LIMIT 1;
    RAISE NOTICE 'ALERTA: Se pudo acceder a Promociones — revisar permisos';
EXCEPTION WHEN insufficient_privilege THEN
    RAISE NOTICE '✅ CORRECTO: Acceso denegado a comercial.Promocion para rol_auditor';
END;
$$;

RESET ROLE;
RESET app.current_web_user;


-- ==============================================================================
-- BLOQUE 4 — SIMULACIÓN: Usuario ROL_FINANZAS (finn.almanza)
-- ==============================================================================
\echo ''
\echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'
\echo ' BLOQUE 4 — Simulación: finn.almanza (rol_finanzas)'
\echo '            Middleware ejecuta: SET ROLE rol_finanzas'
\echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'

SET ROLE rol_finanzas;
SET app.current_web_user = 'finn.almanza';

\echo '-- ✅ ACCESO PERMITIDO: Puede ver y gestionar Facturas'
SELECT id_factura, id_linea, monto_total, estado_pago, fecha_emision
FROM finanzas."Factura"
ORDER BY fecha_emision DESC
LIMIT 5;

\echo '-- ✅ ACCESO PERMITIDO: Puede ver Recargas'
SELECT id_recarga, id_linea, monto, metodo_pago, fecha_recarga
FROM finanzas."Recarga"
ORDER BY fecha_recarga DESC
LIMIT 5;

\echo '-- ❌ ACCESO DENEGADO: No puede ver Auditoría de Seguridad'
DO $$
BEGIN
    PERFORM * FROM seguridad."Auditoria" LIMIT 1;
    RAISE NOTICE 'ALERTA: Se pudo acceder a Auditoría — revisar permisos';
EXCEPTION WHEN insufficient_privilege THEN
    RAISE NOTICE '✅ CORRECTO: Acceso denegado a seguridad.Auditoria para rol_finanzas';
END;
$$;

RESET ROLE;
RESET app.current_web_user;


-- ==============================================================================
-- BLOQUE 5 — TABLA RESUMEN: Qué puede hacer cada rol
-- Muestra en una sola tabla todos los permisos concedidos por rol y esquema.
-- ==============================================================================
\echo ''
\echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'
\echo ' BLOQUE 5 — Mapa completo de permisos por ROL'
\echo '            (leído en tiempo real desde information_schema)'
\echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'

SELECT
    grantee                                                     AS "Rol",
    table_schema                                                AS "Esquema",
    table_name                                                  AS "Tabla",
    STRING_AGG(DISTINCT privilege_type, ', ' ORDER BY privilege_type) AS "Permisos"
FROM information_schema.role_table_grants
WHERE grantee IN ('rol_comercial', 'rol_auditor', 'rol_finanzas', 'rol_agencia', 'rol_reporte', 'rol_app')
  AND table_schema NOT IN ('pg_catalog', 'information_schema')
GROUP BY grantee, table_schema, table_name
ORDER BY grantee, table_schema, table_name;


-- ==============================================================================
-- BLOQUE 6 — EL TRIGGER DE AUDITORÍA REGISTRA QUIÉN FUE
-- Demostramos que aunque Filament usa SET ROLE (y Postgres ve a rol_finanzas),
-- el trigger captura el username real humano vía app.current_web_user
-- ==============================================================================
\echo ''
\echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'
\echo ' BLOQUE 6 — Trazabilidad: el Trigger sabe quién fue'
\echo '            Ultimos registros de auditoría DML'
\echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'

SELECT
    id_auditoria,
    fecha,
    usuario_db          AS "Rol PG (SET ROLE)",
    tabla_afectada,
    operacion,
    -- Si quieres ver el usuario web real, revisa el campo detalle_cambio
    LEFT(detalle_cambio::text, 80) AS "Detalle (truncado)"
FROM seguridad."Auditoria"
ORDER BY fecha DESC
LIMIT 10;


-- ==============================================================================
-- BLOQUE 7 — CONCLUSIÓN: Qué ve cada rol en el Sidebar de Filament
-- No es SQL puro, es un resumen textual de lo que hace canAccess()
-- ==============================================================================
\echo ''
\echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'
\echo ' BLOQUE 7 — Resumen: Menú visible en Panel Web según rol_db'
\echo ''
\echo '  rol_comercial → Escritorio | Panel Admin | Gestión de Paquetes'
\echo '  rol_auditor   → Escritorio | Panel Admin | Auditorías'
\echo '  rol_finanzas  → Escritorio | Panel Admin | Gestión Facturas | Historial Recargas'
\echo '  rol_agencia   → Escritorio | Panel Admin | Registro de Clientes | Agencia Alta'
\echo '  rol_reporte   → Escritorio | Panel Admin | Dashboard Reportes BI'
\echo '  rol_app       → Escritorio | Recargar Saldo | Tienda | Simulador'
\echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'
