


| Entidad |  |
| :--- | :--- |
| **Cliente** | central de la identidad legal; permite la especialización en **Persona Natural** y **Empresa**. |
| **Linea_Movil** | Vincula al cliente con el servicio y define la modalidad (**Prepago/Postpago**) que rige toda la lógica comercial. |
| **Equipo** | Registra el hardware asociado a la línea; es vital para la seguridad y el control técnico de los dispositivos en la red. |
| **Plan** | Define el contrato base para líneas Postpago y Corporativas, estableciendo límites de megas, minutos y cargos mensuales. |
| **Saldo** | Crucial para separar el **Saldo Regular** (dinero real) del **Saldo Promocional** (bonos), permitiendo aplicar la jerarquía de descuento correcta en cada cobro. |
| **Recarga** | Registra el flujo de ingresos. Su importancia radica en que es el disparador de eventos de **BONUS Club** y promociones como **Doble Carga**. |
| **Bolsa_Paquete** | Soporta la oferta dinámica. Gestiona combos (MB+WA+App) y bolsas ilimitadas con sus respectivas reglas de vigencia y acumulación. |
| **Factura** | Documento legal de cobro mensual obligatorio para el segmento Postpago y Hogar. |
| **Pago** | Registra la liquidación de deudas, ya sea para cerrar facturas o amortizar préstamos de saldo. |
| **Cuenta_Bonus** | Balance maestro de lealtad por línea; determina si el usuario es nivel **Básico o Élite**, lo cual altera los multiplicadores de puntos y su vigencia. |
| **Movimiento_Bonus** | La entidad de **mayor volumen transaccional**. Registra cada acción: minutos navegando, juegos (**Tap Tap**), lectura de noticias y rachas. |
| **Canje_Premio** | Gestiona el gasto de puntos. Soporta el **"Precio Dual"**, donde una bolsa se paga con una combinación híbrida de dinero y puntos BONUS. |
| **Prestamo (T-Presta)** | Gestiona microcréditos sin intereses. Su clave es la lógica de **calificación crediticia automática** basada en antigüedad y recargas previas. |
| **Transfuzion** | Entidad de relación P2P que registra el traspaso de saldo entre líneas, validando montos enteros y antigüedad del emisor. |
| **Promocion** | Permite activar ofertas como **sMartes** o **RompeBolsas** en ventanas de tiempo específicas (ej. martes 06:00-23:59) sin duplicar tablas de productos. |
| **Consumo_Detalle** | Almacena el tráfico granular (MB, Minutos, SMS) de los últimos **5 días**. Es vital para que la App muestre al usuario en qué aplicaciones gastó sus recursos. |
| **Historico_Transaccion (Archive)** | Indispensable para la **"Rotación de Tablas" cada 15 días**. Aquí se mueven los datos de consumo y puntos para mantener la base de datos operativa ligera y rápida. |
| **Cuenta_Corporativa** | Permite agrupar múltiples líneas bajo un solo NIT, habilitando beneficios de ** Empresarial** (llamadas gratis en el grupo) y bolsas compartidas. |
| **Chip (IMSI)** | Permite el **"reciclaje de líneas"**. Al separar el número de teléfono del identificador físico del chip, se pueden reasignar números a nuevos clientes sin perder historial técnico. |