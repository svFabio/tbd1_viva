# Descripción de Entidades

Todas las entidades del modelo con su descripción corta.

---

| Entidad | ¿Qué representa? |
|---------|-----------------|
| **Cliente** | Cualquier persona o empresa que tiene contrato con VIVA |
| **Persona_Natural** | Datos específicos de un cliente individual (CI, nombre, edad) |
| **Empresa** | Datos específicos de un cliente empresa (NIT, razón social) |
| **Linea** | Un número telefónico activo en la red VIVA |
| **Linea_Postpago** | Información extra de una línea que paga a fin de mes |
| **SIM_Card** | El chip físico que se inserta en el celular |
| **Equipo** | El celular registrado en el sistema |
| **Detalle_Linea_Equipo** | Historial de qué equipo usó qué línea y en qué fechas |
| **Plan** | El catálogo de planes que VIVA ofrece (prepago y postpago) |
| **Paquete** | Los paquetes adicionales de datos, voz o SMS que se pueden comprar |
| **app_incluida_en_bolsa** | Las apps cuyo tráfico no consume la bolsa (zero-rating) |
| **Bolsa_Activa** | Un paquete que una línea activó y está usando actualmente |
| **Bolsillo** | El saldo de una línea: regular, promocional y prestado |
| **Recarga** | Cada vez que un cliente agrega saldo a su línea |
| **Tarjeta_Recarga** | El código raspable con valor fijo para recargar saldo |
| **Transfuzion** | Una transferencia de saldo de una línea a otra |
| **Doble_Carga** | Los días en que una línea tiene habilitada la promoción de doble carga |
| **Consumo** | Cada evento de uso: una llamada, MB descargados, un SMS |
| **T_Presta** | Un préstamo de saldo que VIVA da a una línea sin crédito |
| **Numero_Amigo** | Un par de líneas con llamadas gratuitas entre sí |
| **Promocion** | Una campaña activa de VIVA (ej. doble carga, % extra al recargar) |
| **factura** | El estado de cuenta mensual de una línea postpago |
| **Puntos_Bonus** | El saldo de puntos acumulados por una línea |
| **Evento_bonus** | Cada vez que una línea gana puntos (recarga, navegación, referido) |