# 📡 REQUERIMIENTOS DE ALMACENAMIENTO DE TELECOMUNICACIONES VIVA 💾

***

Para definir los **requerimientos de almacenamiento** 💾 de nuestro proyecto, empezamos analizando nuestro modelo **Entidad-Relación** 📊 para calcular cuánto **espacio en disco** 💽 vamos a necesitar. Al hacer esto, nos dimos cuenta de que las tablas que diseñamos van a crecer a ritmos muy diferentes 📈.

Por un lado, identificamos tablas que son prácticamente estáticas 🛑, como los **Planes** 📋 o los **Equipos** 📱. Como la empresa no lanza planes nuevos todos los días, sabemos que estas tablas van a ocupar muy poco espacio en el servidor 📉.

Por otro lado, tenemos las tablas de operación diaria 🔄, como **Facturas** 🧾, **Recargas** 💳 y **Clientes** 👥. Estas tendrán un crecimiento constante y moderado, porque se generan nuevos datos cada vez que un cliente interactúa con el sistema o paga su servicio 💰.

Sin embargo, nuestro mayor hallazgo en este análisis fue la tabla de **Consumo** 📶. Al modelar una empresa de telecomunicaciones 📡, nos dimos cuenta de que esta tabla va a recibir millones de registros al día 📊, ya que tiene que guardar cada mega de internet usado 🌐, cada SMS ✉️ y cada segundo de llamada 📞 de todos los usuarios. Definitivamente, va a ser la tabla más pesada 🏋️‍♂️ de todo nuestro diseño.

Por esta razón, determinamos como un **requerimiento obligatorio** 🚨 que el servidor utilice **discos de estado sólido (SSD)** ⚡ de alta velocidad. Si usáramos discos normales 🐌, la cantidad de datos que entran a la tabla de Consumo haría que el sistema colapse 💥 o se vuelva muy lento 🐢.

Para empezar las operaciones 🚀, calculamos que necesitaremos un **servidor** 🖥️ con entre **500 GB y 1 TB** de espacio. Además, para garantizar que la base de datos no se sature con los años ⏳, definimos una **estrategia de limpieza** 🧹: cualquier registro de consumo que tenga más de un año de antigüedad 🗓️ será archivado 🗄️ en un disco externo más económico 💸 y eliminado del sistema principal 🗑️. Así aseguramos que nuestro modelo se mantenga siempre rápido ⚡ y eficiente a largo plazo 🎯.
