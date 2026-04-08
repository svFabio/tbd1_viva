# Requerimientos de Almacenamiento

## RA-01 Clientes
El sistema debe almacenar la información de cada cliente que contrata servicios con VIVA. Esto incluye su identificación legal (CI o NIT), datos de contacto, fecha de registro y tipo (persona natural o empresa). Para personas naturales se requiere además fecha de nacimiento y género. Para empresas se requiere razón social, NIT, nombre del contacto responsable y correo corporativo.

## RA-02 Líneas telefónicas
Cada línea telefónica debe almacenarse con su número (MSISDN), el cliente al que pertenece, el plan asignado, el chip SIM activo, la modalidad de servicio (prepago o postpago), fecha de activación, estado y fecha de reciclaje si aplica. Una línea puede cambiar de estado a lo largo de su ciclo de vida.

## RA-03 Saldo del cliente (Bolsillo)
Para toda línea que maneje saldo propio, el sistema debe registrar el saldo regular (recargado con dinero real), el saldo promocional (bonificaciones de campañas) y el saldo prestado (deuda pendiente por T-Presta). También debe indicar si la línea está habilitada para solicitar préstamos de saldo.

## RA-04 Planes tarifarios
El sistema debe almacenar el catálogo de planes disponibles, incluyendo nombre, modalidad (prepago/postpago), tipo (individual/corporativo), categoría, precio mensual, recursos incluidos (minutos, SMS, datos en MB), vigencia en días y si el plan incluye Número Amigo.

## RA-05 Recargas
Cada recarga realizada debe almacenarse con el monto, la fecha, el medio utilizado (tarjeta física, app, banca digital o punto de venta), el saldo antes y después de la recarga, si la factura es anónima o nominal, el NIT del cliente si aplica, y la promoción asociada si hubiera.

## RA-06 Tarjetas de recarga
Las tarjetas físicas de recarga deben registrarse con su código único, valor facial, estado (disponible, usada o anulada), fecha de canje, la línea en la que fue canjeada, el número de factura anónima del lote y el canal de canje.

## RA-07 Paquetes y bolsas
El catálogo de paquetes debe almacenar nombre, categoría, precio, costo en puntos BONUS para canje, recursos incluidos (MB, segundos de voz, SMS), vigencia en horas, si es ilimitado, la app destino si aplica, y el rango horario si el paquete tiene restricción de horario.

## RA-08 Bolsas activas
Por cada bolsa adquirida por una línea debe almacenarse la referencia al paquete, la línea, las fechas de inicio y fin, la cuota total y restante de MB y minutos, el estado (activa, agotada o expirada) y el tipo de saldo con el que fue cobrada.

## RA-09 Apps incluidas en bolsa
Para las bolsas de aplicaciones específicas, el sistema debe almacenar por cada paquete la lista de aplicaciones exentas de cobro con su nombre, dirección de tráfico (DNS o IP) y si está activa la exención.

## RA-10 Consumo de servicios
Cada evento de consumo debe almacenarse con la línea que consumió, la bolsa activa que lo cubre si aplica, el tipo (datos, llamada, SMS, LDI), la cantidad consumida, las fechas de inicio y fin, el costo, si fue cobrado o exento, la fuente de descuento, el número destino si aplica, y los campos de destino de tráfico (app, DNS, IP) para validar exenciones.

## RA-11 Préstamos de saldo (T-Presta)
El sistema debe registrar cada préstamo de saldo con la línea solicitante, el monto prestado, los intereses si aplican, las fechas de préstamo y vencimiento, y el estado del préstamo (pendiente o cancelado).

## RA-12 Transferencias de saldo (Transfuzion)
Cada transferencia de saldo entre líneas debe almacenarse con la línea origen, la línea destino, el monto transferido y la fecha.

## RA-13 Facturas postpago
Las facturas mensuales de líneas postpago deben almacenarse con su número oficial, la línea asociada, el período cubierto, el monto total, las fechas de emisión y vencimiento, y el estado (pendiente, pagada o vencida).

## RA-14 Promociones y campañas
El sistema debe almacenar el catálogo de promociones con nombre, tipo, valor del beneficio, rango de fechas de vigencia, rango horario si aplica, y la modalidad de línea a la que aplica.

## RA-15 Equipos y SIM cards
Los equipos deben registrarse con IMEI, marca, modelo y estado. Los chips SIM con su IMSI, lote de fabricación, la línea asignada, fechas de fabricación, activación y baja, y estado del chip.

## RA-16 Historial equipo-línea
El sistema debe conservar el historial de qué equipo usó cada línea, con fechas de asignación y baja, para trazabilidad forense.

## RA-17 Fidelización VIVA BONUS
Debe almacenarse el saldo de puntos de cada línea (acumulados, canjeados y disponibles) y el historial detallado de cada evento de acumulación o canje con su tipo, cantidad de puntos y datos adicionales según el tipo de evento.

## RA-18 Número Amigo
Los vínculos de Número Amigo entre líneas deben registrarse con las dos líneas involucradas, fechas de activación y vencimiento, costo y estado.