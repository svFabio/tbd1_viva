# Manual de Despliegue en Azure

Este manual describe los pasos necesarios para llevar el proyecto VIVA (Base de datos PostgreSQL + Aplicación Laravel/Filament) desde un entorno local (Windows) a la nube de Microsoft Azure, manteniendo exactamente la misma arquitectura basada en contenedores.

## Enfoque Recomendado: Azure Virtual Machine (IaaS)
Dado que hemos configurado todo de manera experta con Docker y `docker-compose.yml`, la forma más fácil, económica y directa de desplegar es utilizando una Máquina Virtual (VM) de Linux en Azure. Esto te permite tener tanto la Base de Datos como la Aplicación corriendo juntas.

---

## Pasos para el Despliegue

### 1. Crear la Máquina Virtual en Azure
1. Ingresa al **Portal de Azure**.
2. Crea un nuevo recurso: **Virtual Machine**.
3. Selecciona la imagen de sistema operativo: **Ubuntu Server 22.04 LTS** (recomendado por su estabilidad con Docker).
4. Elige un tamaño adecuado (Mínimo recomendado: 2 vCPUs y 4GB de RAM).
5. En la configuración de red (Inbound Port Rules), asegúrate de abrir los puertos:
   - `22` (Para conectarte por SSH).
   - `80` (Para el acceso HTTP a tu panel de Laravel).
   - `5433` (Solo si necesitas conectarte a PostgreSQL desde un DBeaver externo; de lo contrario, mantenlo cerrado por seguridad).

### 2. Preparar el Servidor (Instalar Docker)
Conéctate por SSH a tu nueva máquina virtual y ejecuta los comandos para instalar Docker:
```bash
sudo apt update
sudo apt install docker.io docker-compose-v2 git -y
sudo systemctl enable docker
sudo usermod -aG docker $USER
```
*(Luego, cierra sesión y vuelve a entrar por SSH para que los permisos surtan efecto).*

### 3. Clonar el Repositorio
Clona este mismo repositorio en tu servidor:
```bash
git clone <URL_DE_TU_REPOSITORIO>
cd tbd1_viva
```

### 4. Replicar la Arquitectura Local
Ejecuta exactamente los mismos pasos que hiciste en tu máquina local:

1. **Crear la red de comunicación:**
   ```bash
   docker network create red_viva
   ```
2. **Levantar la Base de Datos (PostgreSQL):**
   ```bash
   docker compose up -d --build
   ```
3. **Levantar la Aplicación (Laravel + Filament):**
   ```bash
   cd 06-app-viva
   # Aquí usarías sail para levantar el contenedor de Laravel
   ./vendor/bin/sail up -d
   ```

### 5. Configuraciones Finales de Producción
1. **Archivo `.env` de Laravel:** En el servidor de Azure, asegúrate de que el `.env` de Laravel tenga tu IP pública o dominio real en el parámetro `APP_URL`.
2. **Persistencia:** Al igual que en local, Docker guardará los datos de la base de datos en la carpeta `datos_postgres_viva` de la máquina virtual, por lo que tus datos estarán a salvo aunque se reinicie el contenedor.

## Alternativas (Servicios Administrados)
Si en el futuro el proyecto crece y necesitas separar la aplicación de la base de datos:
- Puedes migrar el contenedor de PostgreSQL a **Azure Database for PostgreSQL (Flexible Server)**.
- Puedes subir el contenedor de Laravel a **Azure App Service (Web App for Containers)**.
