# Matriz de Privilegios de la Base de Datos VIVA

Esta matriz documenta los permisos de operaciones **CRUD** (Create, Read, Update, Delete) asignados a cada uno de los roles principales de la base de datos PostgreSQL, implementando el **Principio de Mínimo Privilegio**.

---

## 1. `rol_comercial` (Gestión Comercial y Promociones)
*Encargado de la creación de promociones, paquetes y condiciones de fidelización. Solo puede leer datos de clientes y líneas, pero no modificarlos.*

| Esquema | Tabla | Create (INSERT) | Read (SELECT) | Update (UPDATE) | Delete (DELETE) |
|---------|-------|:---:|:---:|:---:|:---:|
| **comercial** | Promocion | ✔ | ✔ | ✔ | ✔ |
| **comercial** | Condicion_Promocion | ✔ | ✔ | ✔ | ✔ |
| **comercial** | Numero_Amigo | ✔ | ✔ | ✔ | ✔ |
| **comercial** | Promocion_Linea | ✔ | ✔ | ✔ | ✔ |
| **fidelizacion** | Condicion_Puntos | ✔ | ✔ | ✔ | ✔ |
| **fidelizacion** | Historial_Puntos | — | ✔ | — | — |
| **fidelizacion** | Puntos_Bonus | — | ✔ | — | — |
| **clientes** | Cliente | — | ✔ | — | — |
| **servicios** | Paquete | ✔ | ✔ | ✔ | ✔ |
| **servicios** | App_Exenta_En_Bolsa | ✔ | ✔ | ✔ | ✔ |
| **lineas** | Linea | — | ✔ | — | — |
| **lineas** | Plan | — | ✔ | — | — |

---

## 2. `rol_app` (Cliente en la Aplicación Web/Móvil)
*Permisos exactos que tiene el usuario cliente final a través del Backend. Sujeto adicionalmente a políticas de Row-Level Security (RLS) para no ver datos de otros.*

| Esquema | Tabla | Create (INSERT) | Read (SELECT) | Update (UPDATE) | Delete (DELETE) |
|---------|-------|:---:|:---:|:---:|:---:|
| **clientes** | Cliente, Empresa, Persona_Natural | ✔ | ✔ | ✔ | — |
| **lineas** | Linea, Plan, SIM_Card | — | ✔ | — | — |
| **finanzas** | Bolsillo | — | ✔ | ✔ | — |
| **finanzas** | Recarga, T_Presta, Transaccion, Transfuzion | ✔ | ✔ | — | — |
| **finanzas** | Factura, Tarjeta_Recarga | — | ✔ | — | — |
| **servicios** | Bolsa_Activa, Consumo | ✔ | ✔ | — | — |
| **servicios** | Paquete, App_Exenta_En_Bolsa | — | ✔ | — | — |
| **comercial** | Numero_Amigo | ✔ | ✔ | — | ✔ |
| **comercial** | Promocion_Linea | — | ✔ | — | — |
| **fidelizacion**| Historial_Puntos, Puntos_Bonus | — | ✔ | — | — |
| **seguridad** | Usuario_Sistema | ✔ | — | ✔ | — |

---

## 3. `rol_auditor` (Auditoría y Seguridad)
*Solo tiene permiso de lectura transversal para examinar registros y permisos de inserción únicamente para registrar logs de auditoría automatizados.*

| Esquema | Tabla | Create (INSERT) | Read (SELECT) | Update (UPDATE) | Delete (DELETE) |
|---------|-------|:---:|:---:|:---:|:---:|
| **seguridad** | Auditoria | ✔ | ✔ | — | — |
| **seguridad** | Usuario_Sistema | — | ✔ | — | — |
| **finanzas** | Factura, Transaccion, Recarga, Bolsillo, etc. | — | ✔ | — | — |
| **lineas** | Linea, Historial_Linea_Equipo | — | ✔ | — | — |
| **clientes** | Cliente | — | ✔ | — | — |
| **servicios** | Consumo | — | ✔ | — | — |
| **fidelizacion**| Todas las tablas de fidelización | — | ✔ | — | — |
| **comercial** | Promocion_Linea | — | ✔ | — | — |

---

## 4. `rol_reporte` (Generación de Reportes y BI)
*Rol de solo lectura (Read-Only) estricto. Tiene acceso amplio a casi todos los esquemas para armar tableros de BI (Business Intelligence) y exportaciones.*

| Esquema | Tabla | Create (INSERT) | Read (SELECT) | Update (UPDATE) | Delete (DELETE) |
|---------|-------|:---:|:---:|:---:|:---:|
| **Todas** | *Casi todas las tablas operativas* | — | ✔ | — | — |

*(Nota: Este rol no tiene permisos de INSERT, UPDATE ni DELETE en ninguna tabla por diseño de seguridad).*

---

## 5. `rol_finanzas` (Gestión Contable)
*Encargado exclusivamente de todo el movimiento de dinero, recargas y facturación.*

| Esquema | Tabla | Create (INSERT) | Read (SELECT) | Update (UPDATE) | Delete (DELETE) |
|---------|-------|:---:|:---:|:---:|:---:|
| **finanzas** | Factura, Bolsillo, Transaccion, Recarga, etc. | ✔ | ✔ | ✔ | ✔ |
| **clientes** | Cliente | — | ✔ | — | — |
| **lineas** | Linea, Plan | — | ✔ | — | — |

---

## 6. `rol_agencia` (Agencias y Puntos de Venta VIVA)
*Rol para la creación de nuevas cuentas de usuario, venta de equipos y activación de nuevas tarjetas SIM y Líneas.*

| Esquema | Tabla | Create (INSERT) | Read (SELECT) | Update (UPDATE) | Delete (DELETE) |
|---------|-------|:---:|:---:|:---:|:---:|
| **clientes** | Cliente, Empresa, Persona_Natural | ✔ | ✔ | ✔ | ✔ |
| **lineas** | Linea, Plan, SIM_Card, Equipo, etc. | ✔ | ✔ | ✔ | ✔ |
