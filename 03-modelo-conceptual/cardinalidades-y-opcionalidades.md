

| Tipo | Relaciones |
|---|---|
| 1:1 obligatoria (herencia) | Cliente-Persona_Natural, Cliente-Empresa, Linea-Linea_Postpago |
| 1:1 opcional | Linea-Bolsillo, Linea-SIM_Card, Linea-Puntos_Bonus |
| 1:N obligatoria | Cliente-Linea, Linea-Consumo, Linea-Detalle_Linea_Equipo, Paquete-Bolsa_Activa |
| 1:N opcional | Linea-Recarga, Linea-T_Presta, Linea-Transfuzion, Linea-Transaccion, Linea-Numero_Amigo |
| N:M resuelta | Linea-Equipo → Detalle_Linea_Equipo |