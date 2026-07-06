# Chuleta de inserts desde staging

## Objetivo

Insertar datos desde un dataset sucio o una tabla staging sin escribir las llaves foráneas a mano.

## Idea clave

Las FK no se inventan.

Las FK se buscan con `JOIN` contra tablas maestras.

## Flujo correcto

1. Cargar CSV en `staging`.
2. Limpiar lo mínimo necesario.
3. Cargar tablas maestras.
4. Insertar tablas transaccionales con `INSERT ... SELECT`.
5. Validar huérfanos y duplicados.

## Patrón base

```sql
INSERT INTO tabla_destino (
    campo_1,
    id_fk_1,
    id_fk_2
)
SELECT
    d.campo_origen,
    t1.id,
    t2.id
FROM staging d
JOIN tabla_maestra_1 t1 ON ...
JOIN tabla_maestra_2 t2 ON ...;
```

## Insertar compra

```sql
INSERT INTO compra (
    id_registro,
    fecha_compra,
    observaciones,
    id_bodega,
    id_proveedor,
    valor_total_compra
)
SELECT DISTINCT
    d.id_registro,
    d.fecha_compra::date,
    NULLIF(TRIM(d.observaciones), ''),
    b.id,
    p.id,
    d.valor_total_compra::numeric
FROM staging_compra d
JOIN proveedor p ON p.nit = d.nit_proveedor
JOIN bodega b ON UPPER(b.nombre) = UPPER(d.nombre_bodega);
```

## Insertar detalle_compra

```sql
INSERT INTO detalle_compra (
    id_producto,
    id_registro,
    cantidad_comprada,
    precio_compra
)
SELECT
    pr.id,
    c.id_registro,
    d.cantidad_comprada,
    d.precio_unitario::numeric
FROM staging_compra d
JOIN compra c ON c.id_registro = d.id_registro
JOIN producto pr ON UPPER(pr.nombre_producto) = UPPER(d.nombre_producto);
```

## Insertar movimiento

```sql
INSERT INTO movimiento (
    fecha_movimiento,
    cantidad_movimiento,
    id_bodega,
    id_producto,
    id_tipo_movimiento
)
SELECT
    d.fecha_compra::date,
    d.cantidad_movimiento,
    b.id,
    pr.id,
    tm.id
FROM staging_compra d
JOIN bodega b ON UPPER(b.nombre) = UPPER(d.nombre_bodega)
JOIN producto pr ON UPPER(pr.nombre_producto) = UPPER(d.nombre_producto)
JOIN tipo_movimiento tm ON UPPER(tm.nombre) = UPPER(d.tipo_movimiento);
```

## Insertar inventario

```sql
INSERT INTO inventario (
    id_bodega,
    id_producto,
    stock_actual
)
SELECT DISTINCT
    b.id,
    pr.id,
    d.stock_actual
FROM staging_compra d
JOIN bodega b ON UPPER(b.nombre) = UPPER(d.nombre_bodega)
JOIN producto pr ON UPPER(pr.nombre_producto) = UPPER(d.nombre_producto);
```

## Primero prueba el SELECT

```sql
SELECT
    d.id_registro,
    p.id AS id_proveedor_real,
    b.id AS id_bodega_real
FROM staging_compra d
JOIN proveedor p ON p.nit = d.nit_proveedor
JOIN bodega b ON UPPER(b.nombre) = UPPER(d.nombre_bodega);
```

## Reglas rápidas

- Usa `JOIN` para FK obligatorias.
- Usa `LEFT JOIN` si quieres detectar faltantes.
- Cruza proveedor por `nit` si existe.
- Cruza producto por ID original o por nombre + categoría.
- Cruza bodega por nombre homologado o nombre + dirección.
- Normaliza `tipo_movimiento` antes de insertar.

## Checklist rápida

- ¿Las maestras ya están cargadas?
- ¿El `SELECT` previo devuelve IDs correctos?
- ¿No hay duplicados en la fuente?
- ¿La tabla destino tiene PK o `UNIQUE` coherentes?
- ¿Probaste primero en una transacción?
