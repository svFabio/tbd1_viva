# Reglas de Negocio Telcom VIVA

## 1. Gestión de Clientes e Identidad Técnica

### Propiedad de Línea
Un cliente puede poseer múltiples líneas telefónicas, pero cada línea debe estar vinculada obligatoriamente a un único cliente titular.

### Vínculo Técnico
Cada línea telefónica debe asociarse con:
- Un identificador de chip físico (IMSI)  
- Un registro de equipo (IMEI)  

Esto con fines de seguridad y auditoría.

### Reciclaje de Números
Si una línea entra en desuso y cumple el periodo establecido:
- El sistema debe permitir desvincular el número del IMSI antiguo  
- El número puede ser reactivado con un nuevo chip  

### Restricción de Datos
Por normativa:
- Si una línea no tiene una bolsa activa, el sistema debe bloquear el consumo de internet desde el saldo principal  
- Solo se permite si el usuario lo habilita explícitamente  

---

## 2. Programa de Lealtad (**BONUS CLUB POR DEFINIR**)

### Acumulación Individual
- Los puntos se calculan por cada línea de forma independiente  
- No se permite la transferencia de puntos entre líneas del mismo cliente  

### Lógica de Niveles

- Básico:
  - Multiplicador x1  
  - Vigencia de puntos: 3 meses  

- Élite:
  - Requiere canje de 4,500 puntos  
  - Multiplicador x2  
  - Vigencia de puntos: 4 meses  

### Eventos de Suma
El sistema debe registrar puntos por:

- 1 punto por minuto de navegación en la App  
- Recargas ≥ 10 Bs:
  - Básico: 13 puntos  
  - Élite: 26 puntos  
- Cumplimiento de rachas de visita:
  - 7 días  
  - 30 días  

### Canje Híbrido
El sistema debe soportar transacciones donde el costo de una bolsa se cubra mediante una combinación de dinero y puntos BONUS.

### Caducidad de Premios
Si se canjea un souvenir físico (Market):
- El usuario tiene 3 días hábiles para recogerlo  
- Si no lo hace, el sistema debe anular la orden automáticamente  

---

## 3. Microfinanzas (VIVA T-Presta)

### Elegibilidad
Un usuario califica para un préstamo si:
- Saldo < 5 Bs  
- Antigüedad ≥ 30 días  
- Recarga en los últimos 30 días ≥ 10 Bs  

### Límites Dinámicos
El monto máximo de crédito (entre 10 Bs y 120 Bs) debe calcularse en función de:
- Antigüedad de la línea  
- Historial de recargas de los últimos 30 días  

### Prioridad de Cobro
- Ante cualquier recarga, el sistema debe descontar automáticamente la deuda pendiente (sin intereses)  
- Si el saldo es insuficiente, se aplican cobros parciales en futuras recargas  

---

## 4. Promociones y Transferencias

### sMartes
- Disponible solo los martes entre 06:00 y 23:59  
- Bolsas a 0.99 Bs  

Restricción:
- Usuarios prepago no deben haber usado "Doble Carga" > 10 Bs en los últimos 30 días  

### RompeBolsas
- Ofertas con 50% de descuento  
- Disponibles por 24 horas en fechas festivas  
- Exclusivas para compra en la VIVA App  

### Transfuzión

#### Requisitos (Prepago)
- Antigüedad ≥ 90 días  
- Recarga acumulada ≥ 20 Bs  

#### Monto
- Solo se permiten montos enteros  
- Rango: 1 Bs a 90 Bs  

---

## 5. Restricciones de Escalabilidad (Arquitectura)

### Identificadores (IDs)
Todas las transacciones deben generar un identificador alfanumérico único basado en la hora exacta (incluyendo milisegundos) para evitar duplicidad al mover datos entre tablas.
