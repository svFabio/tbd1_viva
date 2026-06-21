# Manual de Instalación

## 1. Prerrequisitos
- Git instalado en el sistema local.
- Docker y Docker Compose instalados y en ejecución.
- Puertos 5432 y 5433 libres en la máquina host.

## 2. Pasos de Instalación

1. Clonar el repositorio localmente.
2. Abrir una terminal en el directorio raíz del proyecto.
3. Ejecutar el siguiente comando para levantar el entorno:
   docker compose up -d --build

## 3. ¿Qué hace este comando?
- Descarga la imagen base de PostgreSQL.
- Instala y configura la extensión pgAudit.
- Monta la carpeta `07-scripts-iniciales` para que la base de datos ejecute automáticamente el DDL, creación de roles y triggers al inicializarse.
- Aplica las reglas de seguridad strictas desde `11-configuracion-de-seguridad/pg_hba.conf`.
- Expone el servicio en el puerto 5433 local.
