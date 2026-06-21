# Problemas y Soluciones

1. Problema: El rol de auditoría no podía evadir las políticas RLS para revisar todos los registros.
Solución: Se aplicó el privilegio BYPASSRLS de manera explícita al rol_auditor y al usuario asignado, garantizando su capacidad de lectura global.

2. Problema: Archivo pg_hba.conf con reglas permisivas por defecto en Docker.
Solución: Se creó una carpeta dedicada de configuración de seguridad y se inyectó un pg_hba.conf restrictivo que exige encriptación scram-sha-256 para cualquier conexión IPv4 e IPv6.

3. Problema: Duplicidad de scripts estructurales en el repositorio.
Solución: Se consolidó todo el DDL y configuración inicial en la carpeta `07-scripts-iniciales`, la cual es leída automáticamente por el docker-entrypoint, garantizando una única fuente de verdad.

4. Problema: El archivo postgresql.conf original del servidor no era compatible directamente con la inicialización de Docker.
Solución: Los parámetros críticos de seguridad y auditoría (como shared_preload_libraries y configuraciones de pgAudit) se pasaron directamente mediante el flag -c en el docker-compose.yml.
