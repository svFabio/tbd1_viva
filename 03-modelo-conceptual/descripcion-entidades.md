# Diccionario de Entidades - Modelo de Base de Datos VIVA

| # | Entidad / Tabla | Descripción |
| :--- | :--- | :--- |
| 1 | **Cliente** | Entidad principal que centraliza la identidad de los usuarios en el sistema. |
| 2 | **Empresa** | Subtipo de Cliente que almacena datos legales corporativos como NIT y Razón Social. |
| 3 | **Persona_Natural** | Subtipo de Cliente para individuos, registrando CI, nombres y apellidos. |
| 4 | **Linea** | Entidad base que representa el servicio de telefonía y su estado general. |
| 5 | **Linea_Prepago** | Especialización de la línea para usuarios que funcionan mediante recargas de crédito. |
| 6 | **Linea_Postpago** | Especialización de la línea vinculada a contratos mensuales y facturación fija. |
| 7 | **SIM_Card** | Información técnica del chip físico (ICCID, IMSI) asociado a una línea activa. |
| 8 | **Plan** | Catálogo de ofertas comerciales, tarifas y beneficios base asignados a las líneas. |
| 9 | **Bolsa_Activa** | Registro de los beneficios vigentes (megas, minutos o SMS) que el usuario tiene disponibles. |
| 10 | **Consumo** | Registro detallado del uso de datos, llamadas o mensajes realizado por la línea. |
| 11 | **Paquete** | Ofertas de servicios adicionales o temporales que el usuario puede adquirir. |
| 12 | **app_incluida_en_bolsa** | Define qué aplicaciones específicas (ej. redes sociales) no consumen megas de la bolsa. |
| 13 | **T_Presta** | Servicio de adelanto de saldo o megas para usuarios que se han quedado sin crédito. |
| 14 | **Equipo** | Inventario de dispositivos físicos (smartphones, routers) disponibles para la venta. |
| 15 | **Detalle_Linea_Equipo** | Relación histórica que vincula una línea con el dispositivo físico que utiliza. |
| 16 | **Numero_Amigo** | Lista de contactos frecuentes registrados para obtener tarifas preferenciales. |
| 17 | **Transfuzion** | Servicio que permite la transferencia de saldo entre diferentes usuarios de la red. |
| 18 | **Transaccion** | Registro maestro de cualquier movimiento financiero o de servicio en la cuenta. |
| 19 | **Puntos_Bonus** | Sistema de fidelización donde el usuario acumula puntaje por sus consumos. |
| 20 | **Evento_Puntos** | Registro de las acciones específicas que generan o descuentan puntos del programa. |
| 21 | **Tarjeta_Recarga** | Gestión de los códigos (pines) y valores de las tarjetas físicas de raspadito. |
| 22 | **Recarga** | Registro del ingreso de saldo a una línea, ya sea por tarjeta o medios digitales. |
| 23 | **Promocion** | Reglas de negocio para beneficios temporales aplicables a recargas o compras. |
| 24 | **Bolsillo** | Segmentación técnica del saldo (ej. saldo real, saldo promocional, saldo de regalo). |
| 25 | **Factura** | Documento mercantil generado para el cobro de servicios postpago o ventas de equipos. |
