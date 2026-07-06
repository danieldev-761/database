# Carga de tablas maestras desde `datasetriwi`

Este documento resume cómo poblar primero las tablas maestras a partir del dataset sucio usando `INSERT INTO ... SELECT ...` en PostgreSQL.

## Orden recomendado

1. `pais`
2. `ciudad`
3. `empleado`
4. `tipomovimiento`
5. `categoriasproductos`
6. `subcategoriasproductos`
7. `unidadesmedidas`
8. `proveedor`
9. `bodega`
10. `producto`

Ese orden ayuda porque varias tablas dependen de llaves foráneas ya creadas en el esquema.

## Patrón base de limpieza

Úsalo en los `SELECT` antes del `INSERT`:

```sql
NULLIF(TRIM(campo), '')

CASE
    WHEN TRIM(UPPER(campo)) IN ('', 'NA', 'N/A', 'NULL') THEN NULL
    ELSE INITCAP(TRIM(campo))
END
```

## Tablas maestras simples

### 1) `pais`

```sql
INSERT INTO pais (nombre)
SELECT DISTINCT
    INITCAP(TRIM(pais_proveedor))
FROM dataset_riwi
WHERE NULLIF(TRIM(pais_proveedor), '') IS NOT NULL;
```

### 2) `empleado`

```sql
INSERT INTO empleado (nombre)
SELECT DISTINCT
    INITCAP(TRIM(responsable_bodega))
FROM dataset_riwi
WHERE NULLIF(TRIM(responsable_bodega), '') IS NOT NULL;
```

### 3) `tipo_movimiento`

```sql
INSERT INTO tipo_movimiento (nombre)
SELECT DISTINCT
    INITCAP(TRIM(tipo_movimiento))
FROM dataset_riwi
WHERE NULLIF(TRIM(tipo_movimiento), '') IS NOT NULL;
```

### 4) `categorias_productos`

```sql
INSERT INTO categorias_productos (nombre)
SELECT DISTINCT
    INITCAP(TRIM(categoria_producto))
FROM dataset_riwi
WHERE NULLIF(TRIM(categoria_producto), '') IS NOT NULL;
```

### 5) `subcategorias_productos`

```sql
INSERT INTO subcategorias_productos (nombre)
SELECT DISTINCT
    INITCAP(TRIM(subcategoria_producto))
FROM dataset_riwi
WHERE NULLIF(TRIM(subcategoria_producto), '') IS NOT NULL;
```

### 6) `unidades_medidas`

```sql
INSERT INTO unidades_medidas (nombre_unidad)
SELECT DISTINCT
    UPPER(TRIM(unidad_medida))
FROM dataset_riwi
WHERE NULLIF(TRIM(unidad_medida), '') IS NOT NULL;
```

## Ciudad y país

`ciudad` depende de `pais`, por eso primero se cargan los países.

```sql
INSERT INTO ciudad (nombre, id_pais)
SELECT DISTINCT
    CASE
        WHEN UPPER(TRIM(ciudad_proveedor)) LIKE '%BOGOT%' THEN 'Bogotá'
        WHEN UPPER(TRIM(ciudad_proveedor)) LIKE '%BARRANQUILL%' OR UPPER(TRIM(ciudad_proveedor)) LIKE '%BQUILLA%' THEN 'Barranquilla'
        WHEN UPPER(TRIM(ciudad_proveedor)) LIKE '%MEDELL%' THEN 'Medellín'
        WHEN UPPER(TRIM(ciudad_proveedor)) LIKE '%CALI%' THEN 'Cali'
        WHEN UPPER(TRIM(ciudad_proveedor)) LIKE '%BUCARAMANGA%' THEN 'Bucaramanga'
        ELSE INITCAP(TRIM(SPLIT_PART(ciudad_proveedor, ',', 1)))
    END AS nombre_ciudad,
    p.id
FROM dataset_riwi d
JOIN pais p
  ON p.nombre = INITCAP(TRIM(d.pais_proveedor))
WHERE NULLIF(TRIM(d.ciudad_proveedor), '') IS NOT NULL
  AND NULLIF(TRIM(d.pais_proveedor), '') IS NOT NULL;
```

## Proveedor

Conviene agrupar por `nit`, porque en tu modelo `proveedor` tiene `UNIQUE(nit)`.

```sql
INSERT INTO proveedor (nombre, nit, telefono, email, id_ciudad)
SELECT DISTINCT ON (TRIM(d.nit_proveedor))
    INITCAP(TRIM(d.nombre_proveedor)) AS nombre,
    TRIM(d.nit_proveedor) AS nit,
    NULLIF(TRIM(d.telefono_proveedor), '') AS telefono,
    CASE
        WHEN TRIM(UPPER(d.email_proveedor)) IN ('', 'NA', 'N/A', 'NULL') THEN NULL
        ELSE LOWER(TRIM(d.email_proveedor))
    END AS email,
    c.id
FROM dataset_riwi d
JOIN pais p
  ON p.nombre = INITCAP(TRIM(d.pais_proveedor))
JOIN ciudad c
  ON c.id_pais = p.id
 AND c.nombre = CASE
        WHEN UPPER(TRIM(d.ciudad_proveedor)) LIKE '%BOGOT%' THEN 'Bogotá'
        WHEN UPPER(TRIM(d.ciudad_proveedor)) LIKE '%BARRANQUILL%' OR UPPER(TRIM(d.ciudad_proveedor)) LIKE '%BQUILLA%' THEN 'Barranquilla'
        WHEN UPPER(TRIM(d.ciudad_proveedor)) LIKE '%MEDELL%' THEN 'Medellín'
        WHEN UPPER(TRIM(d.ciudad_proveedor)) LIKE '%CALI%' THEN 'Cali'
        WHEN UPPER(TRIM(d.ciudad_proveedor)) LIKE '%BUCARAMANGA%' THEN 'Bucaramanga'
        ELSE INITCAP(TRIM(SPLIT_PART(d.ciudad_proveedor, ',', 1)))
    END
WHERE NULLIF(TRIM(d.nombre_proveedor), '') IS NOT NULL
  AND NULLIF(TRIM(d.nit_proveedor), '') IS NOT NULL
ORDER BY TRIM(d.nit_proveedor), LENGTH(TRIM(COALESCE(d.nombre_proveedor, ''))) DESC;
```

## Bodega

`bodega` depende de `empleado` y `ciudad`.

```sql
INSERT INTO bodega (nombre, direccion, id_responsable, id_ciudad)
SELECT DISTINCT
    CASE
        WHEN UPPER(TRIM(d.nombre_bodega)) LIKE '%CENTRAL%' OR UPPER(TRIM(d.nombre_bodega)) LIKE '%CNTRL%' THEN 'Bodega Central Bogotá'
        WHEN UPPER(TRIM(d.nombre_bodega)) LIKE '%NORTE%' THEN 'Bodega Norte Barranquilla'
        WHEN UPPER(TRIM(d.nombre_bodega)) LIKE '%SUR%' THEN 'Bodega Sur Cali'
        WHEN UPPER(TRIM(d.nombre_bodega)) LIKE '%MEDELLIN%' OR UPPER(TRIM(d.nombre_bodega)) LIKE '%MDE%' THEN 'Bodega Medellín'
        ELSE INITCAP(TRIM(d.nombre_bodega))
    END AS nombre,
    INITCAP(TRIM(d.direccion_bodega)) AS direccion,
    e.id,
    c.id
FROM dataset_riwi d
JOIN empleado e
  ON e.nombre = INITCAP(TRIM(d.responsable_bodega))
JOIN ciudad c
  ON c.nombre = CASE
        WHEN UPPER(TRIM(d.ciudad_bodega)) LIKE '%BOGOT%' THEN 'Bogotá'
        WHEN UPPER(TRIM(d.ciudad_bodega)) LIKE '%BARRANQUILL%' OR UPPER(TRIM(d.ciudad_bodega)) LIKE '%BQUILLA%' THEN 'Barranquilla'
        WHEN UPPER(TRIM(d.ciudad_bodega)) LIKE '%MEDELL%' THEN 'Medellín'
        WHEN UPPER(TRIM(d.ciudad_bodega)) LIKE '%CALI%' THEN 'Cali'
        ELSE INITCAP(TRIM(SPLIT_PART(d.ciudad_bodega, ',', 1)))
    END
WHERE NULLIF(TRIM(d.nombre_bodega), '') IS NOT NULL
  AND NULLIF(TRIM(d.direccion_bodega), '') IS NOT NULL
  AND NULLIF(TRIM(d.responsable_bodega), '') IS NOT NULL;
```

## Producto

`producto` depende de `unidades_medidas`, `categorias_productos` y `subcategorias_productos`.

```sql
INSERT INTO producto (
    nombre_producto,
    precio_unitario,
    descripcion,
    id_unidad_medida,
    id_categoria,
    id_subcategoria
)
SELECT DISTINCT ON (d.id_producto)
    INITCAP(TRIM(d.nombre_producto)) AS nombre_producto,
    CAST(REPLACE(NULLIF(TRIM(d.precio_unitario::text), ''), ',', '.') AS numeric) AS precio_unitario,
    NULLIF(INITCAP(TRIM(d.descripcion_producto)), '') AS descripcion,
    um.id,
    cp.id,
    sp.id
FROM dataset_riwi d
JOIN unidades_medidas um
  ON um.nombre_unidad = UPPER(TRIM(d.unidad_medida))
JOIN categorias_productos cp
  ON cp.nombre = INITCAP(TRIM(d.categoria_producto))
JOIN subcategorias_productos sp
  ON sp.nombre = INITCAP(TRIM(d.subcategoria_producto))
WHERE d.id_producto IS NOT NULL
  AND NULLIF(TRIM(d.nombre_producto), '') IS NOT NULL
ORDER BY d.id_producto, LENGTH(TRIM(COALESCE(d.descripcion_producto, ''))) DESC;
```

## Recomendaciones

- Ejecuta primero cada bloque como `SELECT` para revisar cómo queda la limpieza.
- Usa la misma regla de normalización en todos los inserts para no crear duplicados semánticos.
- Si la tabla ya tiene datos, considera usar `ON CONFLICT` o revisar duplicados antes de insertar.
- Si después vas a llenar tablas transaccionales, mantener consistentes `proveedor`, `bodega` y `producto` te simplifica mucho los `JOIN`.
