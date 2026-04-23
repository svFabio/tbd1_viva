# Paso del Modelo ER al Modelo Relacional — VIVA


## Entidades fuertes 

Cada entidad fuerte del modelo ER se convierte en una tabla. Su identificador pasa a ser la clave primaria.

| Entidad ER | Tabla resultante | PK |
|------------|------------------|----|
| Cliente | `Cliente` | `id_cliente` |
| Plan | `Plan` | `id_plan` |
| Linea | `Linea` | `id_linea` |
| SIM Card | `SIM_Card` | `id_sim` |
| Equipo | `Equipo` | `id_equipo` |
| Paquete | `Paquete` | `id_paquete` |
| Promocion | `Promocion` | `id_promocion` |

---

## Herencia (generalización/especialización) → Tabla por subtipo

El modelo tiene dos jerarquías de herencia. Se aplicó la estrategia **tabla por subtipo** (también llamada herencia 1:1): la tabla padre tiene los atributos comunes y cada subtipo tiene su propia tabla con los atributos específicos, compartiendo la misma PK.

### Jerarquía 1: Cliente

```
Cliente (id_cliente, tipo_cliente, nombre, correo, direccion, telefono_contacto, fecha_registro)
    ├── Persona_Natural (id_cliente FK, carnet_identidad, genero, fecha_nacimiento)
    └── Empresa (id_cliente FK, nit, razon_social, nombre_contacto, correo_empresa)
```


### Jerarquía 2: Linea

```
Linea (id_linea, numero, id_cliente, id_plan, id_sim_activo, tipo_linea, ...)
    └── Linea_Postpago (id_linea FK, dia_facturacion, limite_credito, deuda_actual)
```

Solo hay un subtipo porque las líneas prepago no necesitan campos adicionales. Las postpago agregan control de deuda y facturación.

---



## Relaciones N:M → Tabla intermedia

Las relaciones muchos a muchos se resuelven con una tabla intermedia que contiene las FKs de ambas entidades. Si la relación tiene atributos propios, estos también van en la tabla intermedia.

| Relación N:M | Tabla intermedia | Atributos propios |
|--------------|------------------|-------------------|
| Linea ↔ Equipo | `Historial_Linea_Equipo` | `fecha_inicio`, `fecha_fin` |
| Linea ↔ Linea (Transfuzion) | `Transfuzion` | `monto_bs`, `fecha` |
| Linea ↔ Linea (Numero_Amigo) | `Numero_Amigo` | `fecha_activacion`, `fecha_vencimiento`, `costo_bs`, `estado` |

---


## Entidades débiles → Tabla con FK obligatoria

Las entidades que no pueden existir sin su entidad fuerte se modelan con FK NOT NULL.

| Entidad débil | Depende de | FK NOT NULL |
|---------------|------------|-------------|
| `Bolsillo` | `Linea` | `id_linea` |
| `Puntos_Bonus` | `Linea` | `id_linea` |
| `Linea_Postpago` | `Linea` | `id_linea` |
| `Bolsa_Activa` | `Linea` y `Paquete` | `id_linea`, `id_paquete` |
| `Consumo` | `Linea` | `id_linea` |
| `T_Presta` | `Linea` | `id_linea` |

---
