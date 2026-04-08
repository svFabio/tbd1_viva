# Normalización del Modelo — VIVA

Este documento analiza si el modelo cumple las formas normales y documenta los casos donde se tomaron decisiones conscientes de desnormalización por razones de rendimiento.

1. Eliminar redundancia de datos.
2. Evitar inconsistencias al insertar, actualizar o eliminar.
3. Que cada dato tenga un único lugar donde vive.


## Primera Forma Normal (1FN)

**Regla:** Cada celda contiene un único valor atómico. No hay grupos repetidos.

El modelo cumple 1FN en todos sus campos. No hay columnas que guarden listas ni valores separados por comas.

**Caso que merece atención:** `App_Exenta_En_Bolsa.direccion` puede contener un patrón como `*.whatsapp.net`. Técnicamente es un valor atómico (un string), aunque su interpretación sea un patrón. Esto es aceptable.


## Segunda Forma Normal (2FN)

**Regla:** Todos los atributos no clave dependen de la **clave completa**, no de una parte de ella.

Aplica solo a tablas con claves primarias compuestas. En este modelo, las tablas de relación N:M (`Historial_Linea_Equipo`, `Numero_Amigo`, `Transfuzion`) tienen su propia PK autoincremental, por lo que 2FN se cumple.


## Tercera Forma Normal (3FN)

**Regla:** No debe haber dependencias transitivas (un atributo no clave que depende de otro atributo no clave).

### Casos que cumplen 3FN

La mayoría de tablas cumplen 3FN. Por ejemplo, en `Linea`, todos los campos dependen directamente de `id_linea`.


###  Casos de desnormalización en modelos anteriores.

#### 1. `Linea.tipo_linea` — Redundancia controlada

`Linea.tipo_linea` repite información que ya está en `Plan.modalidad`. Es una desnormalización intencional para evitar JOINs en consultas de alto volumen (millones de líneas).

**Riesgo:** si se cambia el plan de una línea y no se actualiza `tipo_linea`, los datos quedan inconsistentes.  
**Mitigación:** la capa de aplicación o un trigger debe mantenerlos sincronizados.

#### 2. `Puntos_Bonus.puntos_disponibles` — Campo calculado almacenado

`puntos_disponibles = puntos_ganados - puntos_usados` es una dependencia funcional entre atributos no clave. Viola 3FN.

**Por qué se incluyó:** para evitar calcular la resta en cada consulta.  
**Riesgo real:** si se actualiza `puntos_ganados` sin actualizar `puntos_disponibles` (o viceversa), el saldo mostrado al cliente es incorrecto.  
**Recomendación:** convertirlo en una vista calculada o eliminarlo del modelo físico.

#### 3. `Bolsa_Activa` — Duplicación de mb_total y minutos_total

`mb_total` y `minutos_total` duplican información del `Paquete` al momento de la compra. Es intencional: si VIVA cambia el paquete en el catálogo, las bolsas ya compradas no deben cambiar.

**Esto es correcto** y no es una violación: captura el valor histórico al momento de la transacción. Es un patrón estándar en bases de datos de negocio.
