# Insertar datos desde un dataset sucio usando llaves foráneas

Esta guía explica cómo insertar datos en tablas transaccionales **sin escribir los IDs foráneos a mano**.

La idea correcta es:

1. Cargar el dataset en una tabla staging.
2. Tener ya listas las tablas maestras.
3. Hacer `INSERT INTO ... SELECT ... JOIN ...` para buscar las llaves foráneas reales.

> Nota: en esta guía los nombres están escritos en `snake_case` para que sea más claro estudiar, por ejemplo `id_bodega` en vez de `idbodega`.

## Idea principal

No debes insertar así:

```sql
INSERT INTO compra (id_proveedor)
VALUES (5);
```

salvo que estés totalmente seguro de que ese `5` corresponde exactamente al proveedor correcto.

Lo normal es hacer esto:

```sql
INSERT INTO compra (fecha_compra, id_bodega, id_proveedor, valor_total_compra)
SELECT
    ...,
    b.id,
    p.id,
    ...
FROM dataset_riwi d
JOIN proveedor p ON ...
JOIN bodega b ON ...;
```

Aquí las llaves foráneas salen de los `JOIN`, no de memoria.

## Regla general

La plantilla base es esta:

```sql
INSERT INTO tabla_destino (
    campo_1,
    id_fk_1,
    id_fk_2
)
SELECT
    valor_transformado,
    t1.id,
    t2.id
FROM dataset_riwi d
JOIN tabla_maestra_1 t1 ON ...
JOIN tabla_maestra_2 t2 ON ...;
```

## Orden sugerido

Después de cargar las tablas maestras, normalmente insertarías en este orden:

1. `compra`
2. `detalle_compra`
3. `movimiento`
4. `inventario`

Ese orden tiene sentido porque `detalle_compra` depende de `compra` y `producto`, mientras `movimiento` e `inventario` dependen de varias maestras ya resueltas.

## Tablas maestras que ya deberían existir

Antes de esta parte ya deberían estar pobladas tablas como:

- `proveedor`
- `producto`
- `bodega`
- `tipo_movimiento`
- `ciudad`
- `pais`
- `empleado`
- `categoria_producto`
- `subcategoria_producto`
- `unidad_medida`

## 1) Insertar en `compra`

La tabla `compra` guarda la cabecera de la compra.

Normalmente necesitas:

- `id_registro`
- `fecha_compra`
- `observaciones`
- `id_bodega`
- `id_proveedor`
- `valor_total_compra`

Ejemplo:

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
    CAST(REPLACE(d.valor_total_compra, ',', '.') AS numeric)
FROM dataset_riwi d
JOIN proveedor p
    ON TRIM(UPPER(p.nit)) = TRIM(UPPER(d.nit_proveedor))
JOIN bodega b
    ON TRIM(UPPER(b.nombre)) = TRIM(UPPER(d.nombre_bodega));
```

### Por qué funciona

- `id_proveedor` sale de la tabla `proveedor`.
- `id_bodega` sale de la tabla `bodega`.
- No escribes las FK manualmente.

### Recomendación

Si el nombre de bodega en el dataset viene muy sucio, es mejor homologarlo antes o cruzarlo por más de un campo, por ejemplo nombre + dirección.

## 2) Insertar en `detalle_compra`

La tabla `detalle_compra` guarda los productos de cada compra.

Normalmente necesita:

- `id_producto`
- `id_registro`
- `cantidad_comprada`
- `precio_compra`

Ejemplo:

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
    CAST(d.precio_unitario AS numeric)
FROM dataset_riwi d
JOIN compra c
    ON c.id_registro = d.id_registro
JOIN producto pr
    ON TRIM(UPPER(pr.nombre_producto)) = TRIM(UPPER(d.nombre_producto));
```

### Qué hace

- Busca la compra real ya insertada.
- Busca el producto real en la maestra.
- Inserta el detalle con las FK correctas.

### Mejor cruce posible

Si el producto quedó con el mismo ID del dataset, puedes unir por `id_producto`.

Si no, conviene unir por nombre más otros atributos como categoría o unidad de medida.

## 3) Insertar en `movimiento`

La tabla `movimiento` registra entradas y salidas.

Normalmente necesita:

- `fecha_movimiento`
- `cantidad_movimiento`
- `id_bodega`
- `id_producto`
- `id_tipo_movimiento`

Ejemplo:

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
FROM dataset_riwi d
JOIN bodega b
    ON TRIM(UPPER(b.nombre)) = TRIM(UPPER(d.nombre_bodega))
JOIN producto pr
    ON TRIM(UPPER(pr.nombre_producto)) = TRIM(UPPER(d.nombre_producto))
JOIN tipo_movimiento tm
    ON TRIM(UPPER(tm.nombre)) = TRIM(UPPER(d.tipo_movimiento));
```

### Ojo importante

Aquí `tipo_movimiento` debe estar ya normalizado.

Por ejemplo, si en el dataset aparecen `entrada`, `ingreso`, `egreso` y `salida`, lo ideal es que en la maestra solo existan valores homogéneos como:

- `Entrada`
- `Salida`

## 4) Insertar en `inventario`

La tabla `inventario` relaciona bodega con producto y su stock actual.

Normalmente necesita:

- `id_bodega`
- `id_producto`
- `stock_actual`

Ejemplo:

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
FROM dataset_riwi d
JOIN bodega b
    ON TRIM(UPPER(b.nombre)) = TRIM(UPPER(d.nombre_bodega))
JOIN producto pr
    ON TRIM(UPPER(pr.nombre_producto)) = TRIM(UPPER(d.nombre_producto));
```

### Cuidado con duplicados

Si el dataset repite varias veces la misma combinación `id_bodega` + `id_producto`, debes revisar si:

- quieres el último stock,
- quieres el stock máximo,
- o quieres agrupar antes de insertar.

## Cómo elegir el campo para hacer match

Prioriza el cruce así:

- `proveedor`: por `nit`
- `producto`: por `id_producto` si lo conservaste; si no, por nombre + categoría + unidad_medida
- `bodega`: por nombre homologado; si hace falta, nombre + dirección
- `tipo_movimiento`: por nombre normalizado

## Antes de insertar, prueba el SELECT

Esa es una de las mejores prácticas.

Primero haces el `SELECT` solo:

```sql
SELECT
    d.id_registro,
    p.id AS id_proveedor_real,
    b.id AS id_bodega_real
FROM dataset_riwi d
JOIN proveedor p
    ON TRIM(UPPER(p.nit)) = TRIM(UPPER(d.nit_proveedor))
JOIN bodega b
    ON TRIM(UPPER(b.nombre)) = TRIM(UPPER(d.nombre_bodega));
```

Si eso devuelve bien los IDs, entonces conviertes el `SELECT` en `INSERT`.

## Recomendación para dataset muy sucio

Si el dataset está muy inconsistente, crea primero una tabla staging limpia.

Por ejemplo:

```sql
CREATE TABLE dataset_riwi_limpio AS
SELECT
    id_registro,
    fecha_compra,
    nit_proveedor,
    nombre_bodega,
    nombre_producto,
    tipo_movimiento,
    cantidad_movimiento,
    stock_actual,
    valor_total_compra
FROM dataset_riwi;
```

Luego haces los `JOIN` desde esa staging limpia.

## Patrón mental para recordar

Quédate con esta idea:

- Las tablas maestras se cargan primero.
- Las tablas transaccionales se cargan después.
- Las FK no se inventan.
- Las FK se buscan con `JOIN`.
- Primero pruebas con `SELECT`, luego haces `INSERT`.

## Nota final sobre nombres

En tu esquema original pueden existir nombres pegados como `idbodega`, `idproveedor`, `tipomovimiento` o `detallecompra`.

En esta guía fueron reescritos como `id_bodega`, `id_proveedor`, `tipo_movimiento` y `detalle_compra` para que sean más legibles al estudiar.
