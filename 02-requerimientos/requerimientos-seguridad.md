# Requerimientos de Seguridad

Para definir la seguridad de nuestro proyecto, analizamos nuestro diagrama para ver qué tan delicada es la información. Nos dimos cuenta de que no todas las tablas necesitan el mismo nivel de protección.

## 1. ¿Qué datos son privados?
Por un lado, tenemos tablas como **Planes** o **Equipos**, que son datos públicos de la empresa. Si alguien los ve, no hay problema. Pero en tablas como **Cliente**, **Empresa** y **Persona_Natural**, guardamos información privada (como el carnet, correos o el NIT). Por eso, definimos como regla principal que el sistema debe proteger estos datos personales para cuidar la privacidad de los usuarios.

## 2. ¿Qué es lo más delicado del sistema?
Nuestro mayor foco de atención fueron las tablas financieras y de uso, como **Facturas**, **Recargas**, **Transferencias** y **Consumo**. Al ser un sistema de telefonía, aquí se maneja la plata y el registro de todo lo que hacen los clientes. Nos dimos cuenta de que esta es la parte más crítica de todo nuestro diseño y la que más debemos cuidar.

## 3. ¿Quién puede modificar las cosas?
Por esta razón, decidimos que es obligatorio configurar **permisos estrictos**. Esto significa que un empleado normal de atención al cliente podrá *ver* una factura en el sistema, pero no tendrá el permiso para *borrarla* o para *cambiar el saldo* de una recarga. Esas acciones delicadas solo podrán hacerlas los administradores.

## 4. ¿Cómo evitamos fraudes?
Finalmente, para asegurar que nadie haga trampa, definimos que la base de datos debe guardar un **historial de cambios**. Si algún empleado modifica el monto de una recarga o anula una factura, el sistema debe registrar automáticamente qué usuario lo hizo, a qué hora y qué cambió. Así nos aseguramos de que nuestro modelo sea seguro y transparente.