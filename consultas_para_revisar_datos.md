# Chuleta de consultas para revisar datos

## Objetivo

Detectar problemas antes y después de cargar datos.

## Contar filas

```sql
SELECT COUNT(*) FROM staging_compra;
SELECT COUNT(*) FROM compra;
SELECT COUNT(*) FROM detalle_compra;
```

## Ver nulos por columna

```sql
SELECT
    COUNT(*) FILTER (WHERE id_registro IS NULL) AS nulos_id_registro,
    COUNT(*) FILTER (WHERE fecha_compra IS NULL) AS nulos_fecha_compra,
    COUNT(*) FILTER (WHERE id_proveedor IS NULL) AS nulos_id_proveedor
FROM staging_compra;
```

## Buscar duplicados por clave

```sql
SELECT id_registro, COUNT(*)
FROM compra
GROUP BY id_registro
HAVING COUNT(*) > 1;
```

## Buscar duplicados lógicos

```sql
SELECT UPPER(TRIM(nombre_bodega)) AS nombre_normalizado, COUNT(*)
FROM staging_compra
GROUP BY UPPER(TRIM(nombre_bodega))
HAVING COUNT(*) > 1;
```

## Revisar valores distintos

```sql
SELECT DISTINCT tipo_movimiento
FROM staging_compra
ORDER BY 1;
```

```sql
SELECT DISTINCT ciudad_proveedor
FROM staging_compra
ORDER BY 1;
```

## Detectar registros sin match en maestras

```sql
SELECT d.*
FROM staging_compra d
LEFT JOIN proveedor p ON p.nit = d.nit_proveedor
WHERE p.id IS NULL;
```

```sql
SELECT d.*
FROM staging_compra d
LEFT JOIN producto pr ON UPPER(pr.nombre_producto) = UPPER(d.nombre_producto)
WHERE pr.id IS NULL;
```

## Detectar huérfanos después del insert

```sql
SELECT dc.*
FROM detalle_compra dc
LEFT JOIN compra c ON c.id_registro = dc.id_registro
WHERE c.id_registro IS NULL;
```

## Comparar conteos entre staging y destino

```sql
SELECT
    (SELECT COUNT(*) FROM staging_compra) AS filas_staging,
    (SELECT COUNT(*) FROM compra) AS filas_compra,
    (SELECT COUNT(*) FROM detalle_compra) AS filas_detalle;
```

## Revisar fechas raras

```sql
SELECT *
FROM staging_compra
WHERE fecha_compra IS NULL
   OR fecha_compra < DATE '2020-01-01'
   OR fecha_compra > CURRENT_DATE;
```

## Revisar números negativos o absurdos

```sql
SELECT *
FROM staging_compra
WHERE precio_unitario < 0
   OR cantidad_comprada < 0
   OR valor_total_compra < 0;
```

## Validar consistencia aritmética

```sql
SELECT *
FROM staging_compra
WHERE ABS((precio_unitario * cantidad_comprada) - valor_total_compra) > 1;
```

## Revisar stock repetido por bodega y producto

```sql
SELECT id_bodega, id_producto, COUNT(*)
FROM inventario
GROUP BY id_bodega, id_producto
HAVING COUNT(*) > 1;
```

## Muestreo rápido

```sql
SELECT *
FROM staging_compra
LIMIT 20;
```

## Checklist rápida

- ¿Ya viste `DISTINCT` de columnas sensibles?
- ¿Ya revisaste nulos?
- ¿Ya revisaste duplicados?
- ¿Ya buscaste faltantes contra maestras?
- ¿Ya validaste fórmulas básicas?
