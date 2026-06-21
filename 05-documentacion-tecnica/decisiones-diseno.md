# Decisiones de Diseño

1. Arquitectura en Contenedores
Se eligió Docker para garantizar que el entorno de desarrollo y evaluación sea 100% reproducible. Esto elimina problemas de compatibilidad y dependencias en diferentes sistemas operativos.

2. Seguridad y Acceso
Se implementó un control de acceso estricto mediante el archivo pg_hba.conf, forzando la autenticación scram-sha-256 para todas las conexiones externas e internas. 

3. Control de Acceso Basado en Roles (RBAC) y RLS
En lugar de dar permisos globales, se crearon roles específicos (rol_app, rol_finanzas, rol_reporte, rol_auditor). Además, se activó Row Level Security (RLS) en tablas críticas para asegurar que los usuarios solo accedan a los registros que les corresponden. Se habilitó BYPASSRLS únicamente para el auditor.

4. Auditoría Integral
Se combinaron dos mecanismos de auditoría:
- pgAudit: Configurado a nivel de servidor (vía docker-compose) para registrar sentencias DDL y operaciones críticas en los logs del contenedor.
- Triggers: Se implementaron disparadores a nivel de tabla para guardar un historial exacto de los cambios de datos en formato JSONB.
