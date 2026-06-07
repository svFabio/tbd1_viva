# Descripción de Relaciones

Todas las relaciones del modelo con su nombre y explicación.

---

| Relación | Descripción |
|----------|-------------|
| Cliente **tiene** Linea | Un cliente puede tener varias líneas. Cada línea pertenece a un solo cliente. |
| Cliente **es_de_tipo** Persona_Natural | Un cliente natural extiende sus datos en Persona_Natural. Comparten el mismo ID. |
| Cliente **es_de_tipo** Empresa | Un cliente empresa extiende sus datos en Empresa. Comparten el mismo ID. |
| Linea **es_de_tipo** Linea_Postpago | Una línea postpago tiene datos adicionales en Linea_Postpago. Comparten el mismo ID. |
| Linea **aplica_a** Plan | Cada línea tiene un plan asignado. Un plan puede estar en muchas líneas. |
| Linea **contiene** SIM_Card | Una línea tiene una SIM activa. El campo `id_sim_activo` en Linea guarda cuál es. |
| Linea **registra** Detalle_Linea_Equipo | Historial de equipos que usó la línea. |
| Equipo **registra** Detalle_Linea_Equipo | Historial de líneas que usó el equipo. |
| Linea **tiene** Bolsillo | Cada línea tiene exactamente un bolsillo. Relación 1 a 1. |
| Linea **adquiere** Puntos_Bonus | Cada línea tiene su contador de puntos. Relación 1 a 1. |
| Linea **puede** Recarga | Una línea puede tener muchas recargas a lo largo del tiempo. |
| Promocion **aplica** Recarga | Una promoción puede estar en muchas recargas. Una recarga tuvo a lo sumo una promo. |
| Recarga **aplica en** Tarjeta_Recarga | Si se usó tarjeta física, la recarga la referencia. Opcional. |
| Linea **solicita** T_Presta | Una línea puede haber pedido varios préstamos. Cada T-Presta es de una línea. |
| Linea **genera** Consumo | Cada consumo pertenece a una línea. Una línea tiene muchos consumos. |
| Bolsa_Activa **tiene** Consumo | Si el consumo usó una bolsa, apunta a cuál. Opcional. |
| Linea **posee** Bolsa_Activa | Una línea puede tener varias bolsas activas. |
| Paquete **define** Bolsa_Activa | Una bolsa activa se basa en un paquete del catálogo. |
| Paquete **incluye** app_incluida_en_bolsa | Un paquete puede tener varias apps exentas. |
| Linea **realiza** Transfuzion | Como origen: la línea que envía saldo. |
| Linea **recibe** Transfuzion | Como destino: la línea que recibe saldo. |
| Linea **participa** Evento_bonus | Cada ganancia de puntos está asociada a una línea. |
| Linea_Postpago **genera** factura | Una línea postpago genera una factura por período. |
| Numero_Amigo **usa** Linea (origen) | La línea que activó el Número Amigo. |
| Numero_Amigo **usa** Linea (destino) | La línea amiga registrada. |
| Linea **tiene** Doble_Carga | Días en que la línea tiene habilitada la doble carga. |