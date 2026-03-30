# SISTEMA DE GESTION DE TELECOMUNICACIONES (VIVA)

El presente proyecto se enfoca en el diseño e implementación del modelo relacional de la Base de Datos para Nuevatel (VIVA).

## 1. Objetivos y Entregables
La meta principal es diseñar una estructura de base de datos entregando:
*   **Modelo de Datos:** Diagrama Entidad-Relación (MER) y Modelo Lógico.
*   **Implementación (DDL):** Scripts SQL para la creación de esquemas, tablas cruzadas, tipos de datos e índices.
*   **Datos de Prueba (DML):** Poblamiento inicial con datos sintéticos (Data Seeding) representativos.
*   **Lógica de Negocio (PL/SQL):** Almacenamiento de procesos críticos (Ej: Facturación, Validación de Recargas) en Procedimientos Almacenados y Funciones.
*   **Reglas Automáticas y Auditoría:** Triggers para gestionar la integridad y control como ser: saldos, prestamos, etc.
*   **Explotación de Datos:** Scripts con consultas para reportes, análisis de comportamiento de los clientes y de la empresa.

## 2. Dominio a Modelar (Módulos Base)
La base de datos cubrirá exclusivamente las operaciones comerciales de los clientes:
*   Gestión de Clientes (B2C/B2B) y Cuentas de cobro.
*   Inventario de Líneas Celulares (SIMs) y Planes/Paquetes ("Bolsitas").
*   Suscripciones y Ciclo de vida del contrato de la línea (Estado de Mora).
*   Procesos de Facturación, Recargas y Registro de Consumos a nivel consolidado.

## 3. Límites Estrictos (Fuera del Alcance)
Para evitar desviaciones, en esta etapa **NO SE INCLUYE**:
1.  **Desarrollo de Software:** Ningún tipo de interfaz web (Frontend), app móvil o backend transaccional en otros lenguajes (Java, Node, etc.). Las pruebas se hacen directamente vía SQL.
2.  **Infraestructura de Red (Core Telco):** No se modelarán tablas de antenas, conmutación de llamadas en vivo, ni tasación en tiempo real (milisegundos) del consumo de datos.
3.  **Sistemas Internos de VIVA:** Queda excluida la contabilidad tributaria, logística de importaciones, nóminas y sistemas de Recursos Humanos.
