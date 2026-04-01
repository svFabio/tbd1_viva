# Diccionario de Relaciones - Modelo de Base de Datos VIVA

| Entidad Origen | Relación | Entidad Destino | Descripción |
| :--- | :--- | :--- | :--- |
| **Cliente** | es un(a) | **Persona_Natural** / **Empresa** | Relación de herencia (especialización) para diferenciar tipos de clientes. |
| **Cliente** | posee | **Linea** | Un cliente puede tener una o varias líneas registradas a su nombre. |
| **Linea** | es un(a) | **Linea_Prepago** / **Linea_Postpago** | Relación de herencia que define la modalidad de cobro de la línea. |
| **Linea** | tiene asignada | **SIM_Card** | Vínculo técnico entre el número telefónico y el chip físico (ICCID). |
| **Linea** | registra | **Numero_Amigo** | Una línea puede tener una lista de números frecuentes para tarifas reducidas. |
| **Linea** | compra | **Paquete** | Adquisición de beneficios adicionales (bolsas de megas, minutos, etc.). |
| **Paquete** | activa | **Bolsa_Activa** | Al comprar un paquete, se crea una bolsa con fecha de expiración. |
| **Bolsa_Activa** | permite uso de | **app_incluida_en_bolsa** | Define qué aplicaciones tienen tráfico ilimitado dentro de esa bolsa. |
| **Linea** | acumula | **Puntos_Bonus** | El uso de la línea genera puntaje en el programa de fidelización. |
| **Puntos_Bonus** | registra | **Evento_Puntos** | Historial de acciones que sumaron o restaron puntos al cliente. |
| **Linea** | utiliza | **Detalle_Linea_Equipo** | Vincula la línea con el dispositivo físico (IMEI) que está usando. |
| **Equipo** | pertenece a | **Detalle_Linea_Equipo** | Registro del hardware (celular/router) asociado a un contrato o venta. |
| **Recarga / Compra** | aplica | **Promocion** | Si se cumple una condición (ej. Doble Carga), se activa un beneficio extra. |
