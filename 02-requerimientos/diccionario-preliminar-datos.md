#  Diccionario de Datos: Sistema de Gestión de Telecomunicaciones VIVA

### 1.  Entidades de Identidad (El "Quién")
*   **Cliente**: Tabla maestra que centraliza a los **usuarios**. Diferencia mediante un atributo de "**tipo**" si es una **persona** o **empresa**.
*   **Empresa / Persona_Natural**: Son extensiones de la tabla **Cliente** Permiten guardar datos específicos como el **NIT** para empresas o el **género** para personas.

### 2. Entidades Core - Conectividad (El "Qué")
*   **Línea**: Es la entidad pivote del modelo. Vincula el **número telefónico** con un **cliente** y un **plan**. Aquí se controla el estado operativo (**Activo/Inactivo**).
*   **SIM_Card**: Representa el inventario físico de los **chips**. Se relaciona con la **Línea** para saber qué **IMSI** tiene asignado cada número.
*   **Equipo**: Registra el hardware (**celulares**). A través de la tabla **Detalle_Linea_Equipo**, mantenemos un historial de qué teléfonos ha usado esa línea.

### 3.  Entidades de Negocio y Cobro (El "Cómo")
*   **Plan**: Define la oferta comercial. Contiene los parámetros de **costo mensual**, **minutos incluidos** y **vigencia**.
*   **Factura**: Registra la obligación de pago generada periódicamente para las líneas de tipo **postpago**.
*   **Recarga**: Gestiona el ingreso de saldo de forma transaccional, afectando el **saldo_actual** de la línea.

### 4.  Entidades de Tráfico y Uso (El "Gasto")
*   **Consumo**: Registra el detalle granular de cada evento (**llamada**, **SMS** o **datos**). Es vital para la tasación y el cobro.
*   **Paquete / Bolsa**: Son servicios de corta duración (ej. **Megas por 24 horas**) que el usuario compra de forma independiente a su plan base.
*   **Transferencia**: Permite el movimiento de **saldo** entre cuentas, registrando **línea origen** y **línea destino**.

### 5. Entidades de Fidelización (El "Extra")
*   **Puntos_Bonus**: Sistema de lealtad donde el **consumo** se convierte en **puntos canjeables**.
*   **Promociones**: Reglas de negocio temporales que modifican el comportamiento de las recargas o consumos (ej. **2x1**).
