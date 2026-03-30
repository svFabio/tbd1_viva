# Casos de Uso Básicos - Ecosistema VIVA

Este documento describe de forma clara los casos de uso principales para el ecosistema digital de VIVA (Nuevatel PCS de Bolivia S.A.). Para facilitar su lectura, las funcionalidades del sistema están agrupadas según los módulos definidos en los objetivos del proyecto.

## 1. Módulo de Gestión de Clientes
**Actores:** Atención al Cliente, Administrador

| N° | Caso de Uso | Descripción |
|:---|:---|:---|
| **1.** | **Registrar Nuevo Cliente** | Permite ingresar al sistema los datos de un nuevo cliente, clasificándolo según su segmento (individual prepago, individual postpago o corporativo). |
| **2.** | **Actualizar Datos de Cliente** | Permite modificar la información personal, de contacto o tributaria de un cliente existente. |
| **3.** | **Consultar Historial de Cliente** | Permite a los agentes de atención al cliente visualizar el perfil detallado, servicios activos y el historial de consumo del cliente. |

## 2. Módulo de Gestión de Planes y Servicios
**Actores:** Atención al Cliente, Administrador, Sistema

| N° | Caso de Uso | Descripción |
|:---|:---|:---|
| **4.** | **Configurar Nuevo Plan o Servicio** | Permite al administrador crear y definir las características (minutos, megas, costo) de un nuevo plan de telefonía o internet. |
| **5.** | **Activar Plan a Cliente** | Permite asociar un plan específico (prepago o postpago) a la línea de un cliente. |
| **6.** | **Cambiar Plan de Cliente** | Permite realizar un upgrade o downgrade del plan de telefonía o internet del cliente. |
| **7.** | **Suspender o Dar de Baja un Servicio** | Permite inactivar un servicio por falta de pago, robo o solicitud expresa del cliente. |

## 3. Módulo de Facturación y Pagos
**Actores:** Facturación, Sistema, Cliente

| N° | Caso de Uso | Descripción |
|:---|:---|:---|
| **8.** | **Generar Factura Mensual** | El sistema genera automáticamente las facturas para los clientes del segmento postpago y corporativo al corte del ciclo de facturación. |
| **9.** | **Registrar Recarga de Saldo** | Permite registrar las recargas de crédito realizadas por clientes del segmento prepago y actualizar su saldo disponible. |
| **10.** | **Registrar Pago de Factura** | Permite registrar el abono de un cliente por los servicios postpago/corporativos facturados. |

## 4. Módulo de Infraestructura y Consumo
**Actores:** Sistema, Administrador

| N° | Caso de Uso | Descripción |
|:---|:---|:---|
| **11.** | **Registrar Consumo de Datos/Voz** | El sistema registra de manera automatizada el consumo de recursos (MBs, minutos, SMS) de cada cliente para descontar saldos o acumular para facturación. |
| **12.** | **Monitorear Rendimiento del Servicio** | El administrador puede revisar el estado y disponibilidad de los recursos de infraestructura operativa. |

## 5. Módulo de Fidelidad
**Actores:** Sistema, Cliente, Atención al Cliente

| N° | Caso de Uso | Descripción |
|:---|:---|:---|
| **13.** | **Acumular Puntos de Fidelidad** | El sistema otorga puntos al cliente en base a sus recargas, pago puntual de facturas o antigüedad. |
| **14.** | **Canjear Puntos por Beneficios** | Permite al cliente (a través de atención al cliente o plataforma digital) canjear sus puntos acumulados por megas, minutos o beneficios físicos. |

## 6. Módulo de Reportes Estratégicos
**Actores:** Administrador

| N° | Caso de Uso | Descripción |
|:---|:---|:---|
| **15.** | **Generar Reporte de Consumos** | Permite extraer estadísticas sobre el uso de datos y voz por segmentos. |
| **16.** | **Generar Reporte de Ingresos** | Permite visualizar los ingresos percibidos por recargas y pagos de facturas en un periodo determinado. |
