# Guía rápida de limpieza de datos

Esta guía está pensada para limpiar un dataset sucio antes de hacer `INSERT` en PostgreSQL.

## Idea principal

No limpies directo sobre las tablas finales.

Haz esto:

1. Carga el CSV en una tabla staging, por ejemplo `datasetriwi`.
2. Limpia los datos con `SELECT`.
3. Inserta el resultado limpio en las tablas maestras o transaccionales.

## Reglas básicas

### 1) Convertir vacíos a `NULL`

Muchos campos vienen como cadena vacía o con espacios.

```sql
NULLIF(TRIM(campo), '')
```

Ejemplo:

```sql
SELECT NULLIF(TRIM(emailproveedor), '') AS email_limpio
FROM datasetriwi;
```

---

### 2) Convertir textos como `NA`, `N/A` o `NULL` a nulo real

```sql
CASE
    WHEN TRIM(UPPER(campo)) IN ('', 'NA', 'N/A', 'NULL') THEN NULL
    ELSE TRIM(campo)
END
```

Ejemplo:

```sql
SELECT
    CASE
        WHEN TRIM(UPPER(observaciones)) IN ('', 'NA', 'N/A', 'NULL') THEN NULL
        ELSE TRIM(observaciones)
    END AS observaciones_limpias
FROM datasetriwi;
```

---

### 3) Limpiar nombres y textos

Para quitar espacios y estandarizar mayúsculas/minúsculas:

```sql
INITCAP(TRIM(campo))
```

Ejemplo:

```sql
SELECT distinct INITCAP((TRIM(nombre_proveedor))) AS proveedor_limpio
FROM dataset_riwi;
```

Si quieres todo en mayúsculas:

```sql
UPPER(TRIM(campo))
```

Si quieres todo en minúsculas:

```sql
LOWER(TRIM(campo))
```

---

### 4) Fechas sucias

Si el dataset mezcla formatos, usa `CASE` con `TO_DATE()`.

```sql
CASE
    WHEN fechacompra ~ '^\d{4}-\d{2}-\d{2}$' THEN TO_DATE(fechacompra, 'YYYY-MM-DD')
    WHEN fechacompra ~ '^\d{2}-\d{2}-\d{4}$' THEN TO_DATE(fechacompra, 'DD-MM-YYYY')
    WHEN fechacompra ~ '^\d{8}$' THEN TO_DATE(fechacompra, 'DDMMYYYY')
    WHEN fechacompra ~ '^\d{2} [A-Za-z]{3} \d{4}$' THEN TO_DATE(fechacompra, 'DD Mon YYYY')
    ELSE NULL
END
```

Ejemplo:

```sql
SELECT
    CASE
        WHEN fechacompra ~ '^\d{4}-\d{2}-\d{2}$' THEN TO_DATE(fechacompra, 'YYYY-MM-DD')
        WHEN fechacompra ~ '^\d{2}-\d{2}-\d{4}$' THEN TO_DATE(fechacompra, 'DD-MM-YYYY')
        WHEN fechacompra ~ '^\d{8}$' THEN TO_DATE(fechacompra, 'DDMMYYYY')
        WHEN fechacompra ~ '^\d{2} [A-Za-z]{3} \d{4}$' THEN TO_DATE(fechacompra, 'DD Mon YYYY')
        ELSE NULL
    END AS fecha_limpia
FROM datasetriwi;
```

---

### 5) Números como texto

Si un número viene como texto, primero límpialo y luego conviértelo.

```sql
CAST(NULLIF(TRIM(campo), '') AS integer)
```

Para decimales con coma:

```sql
CAST(REPLACE(NULLIF(TRIM(campo), ''), ',', '.') AS numeric)
```

Ejemplo:

```sql
SELECT
    CAST(NULLIF(TRIM(cantidadcomprada::text), '') AS integer) AS cantidad_limpia,
    CAST(REPLACE(NULLIF(TRIM(valortotalcompra), ''), ',', '.') AS numeric) AS total_limpio
FROM datasetriwi;
```

## Plantilla general de limpieza

Úsala como base para casi cualquier `INSERT`.

```sql
INSERT INTO tabla_destino (columna1, columna2)
SELECT DISTINCT
    expresion_limpia_1,
    expresion_limpia_2
FROM datasetriwi
WHERE NULLIF(TRIM(campo_base), '') IS NOT NULL;
```

## Ejemplos fáciles para tablas maestras

### País

```sql
INSERT INTO pais (nombre)
SELECT DISTINCT
    INITCAP(TRIM(paisproveedor))
FROM datasetriwi
WHERE NULLIF(TRIM(paisproveedor), '') IS NOT NULL;
```

### Empleado

```sql
INSERT INTO empleado (nombre)
SELECT DISTINCT
    INITCAP(TRIM(responsablebodega))
FROM datasetriwi
WHERE NULLIF(TRIM(responsablebodega), '') IS NOT NULL;
```

### Categoría

```sql
INSERT INTO categoriasproductos (nombre)
SELECT DISTINCT
    INITCAP(TRIM(categoriaproducto))
FROM datasetriwi
WHERE NULLIF(TRIM(categoriaproducto), '') IS NOT NULL;
```

### Unidad de medida

```sql
INSERT INTO unidadesmedidas (nombreunidad)
SELECT DISTINCT
    UPPER(TRIM(unidadmedida))
FROM datasetriwi
WHERE NULLIF(TRIM(unidadmedida), '') IS NOT NULL;
```

## Truco para mañana

Si una consulta se pone muy larga:

1. Primero haz solo el `SELECT`.
2. Revisa que los datos se vean bien.
3. Después le agregas el `INSERT INTO`.

Ejemplo:

```sql
SELECT DISTINCT INITCAP(TRIM(paisproveedor))
FROM datasetriwi
WHERE NULLIF(TRIM(paisproveedor), '') IS NOT NULL;
```

Luego:

```sql
INSERT INTO pais (nombre)
SELECT DISTINCT INITCAP(TRIM(paisproveedor))
FROM datasetriwi
WHERE NULLIF(TRIM(paisproveedor), '') IS NOT NULL;
```

## Chuleta mínima para memorizar

Memoriza estas funciones:

- `TRIM()`
- `NULLIF()`
- `CASE`
- `INITCAP()`
- `UPPER()`
- `TO_DATE()`
- `CAST()`
- `REPLACE()`
- `SELECT DISTINCT`

Con eso puedes resolver la mayor parte de una limpieza básica en SQL.
