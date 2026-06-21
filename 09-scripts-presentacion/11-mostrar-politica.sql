-- ==============================================================================
-- SCRIPT: 15-ver-explicar-politica.sql
-- OBJETIVO: Mostrar la política RLS existente y explicar su funcionamiento.
-- La política factura_propia_policy permite que cada usuario 
--vea únicamente las facturas cuya id_linea coincide con el
-- identificador de línea almacenado en su sesión.
--==============================================================================

-- Ejecuta esto para aislar y ver solo TU política en la consola:
SELECT policyname, tablename, roles, cmd, qual 
FROM pg_policies 
WHERE policyname = 'factura_propia_policy';

-- ==============================================================================
-- EXPLICACIÓN DETALLADA DE TU POLÍTICA (Para la defensa):
-- ==============================================================================
-- Tu política ejecuta en secreto la siguiente regla de filtrado:
-- WHERE id_linea = (NULLIF(current_setting('app.current_linea_id'::text, true), ''::text))::integer
--
-- Desglose paso a paso de izquierda a derecha:
--
-- 1. id_linea = 
--    Es la columna de tabla "Factura". El motor va a comparar cada fila usando este ID.
--
-- 2. current_setting('app.current_linea_id'::text, true)
--    Busca en la memoria de la sesión el ID del cliente conectado (ej. '2' o '4').
--    El 'true' final evita que el sistema lance un error si la variable no ha sido seteada.
--
-- 3. NULLIF( ... , ''::text)
--    Si la variable de la app está vacía o es un texto en blanco (''), 
--    NULLIF la transforma automáticamente en un valor NULL. 
--    Esto evita errores de ejecución y hace que la consulta devuelva 0 filas de forma segura.
--
-- 4. ::integer
--    Como las variables de sesión se guardan siempre como texto (string), este operador 
--    lo convierte a un número entero (integer) para que sea compatible con el "id_linea" de la tabla.
-- ==============================================================================
