# Chuleta de errores comunes SQL

## FK violada

### Error típico

```text
insert or update on table ... violates foreign key constraint
```

### Causa común

La FK no existe en la tabla maestra.

### Qué revisar

```sql
SELECT *
FROM staging_compra d
LEFT JOIN proveedor p ON p.nit = d.nit_proveedor
WHERE p.id IS NULL;
```

## Duplicado en PK o UNIQUE

### Error típico

```text
duplicate key value violates unique constraint
```

### Qué revisar

```sql
SELECT id_registro, COUNT(*)
FROM compra
GROUP BY id_registro
HAVING COUNT(*) > 1;
```

## Error de cast

### Error típico

```text
invalid input syntax for type integer
invalid input syntax for type numeric
```

### Causa común

Hay comas, letras, espacios o símbolos en columnas numéricas.

### Qué revisar

```sql
SELECT *
FROM staging_compra
WHERE valor_total_compra !~ '^[0-9]+(\.[0-9]+)?$';
```

## Fecha inválida

### Error típico

```text
date/time field value out of range
```

### Causa común

Formato ambiguo o mezcla de `dd-mm-yyyy` con `mm-dd-yyyy`.

### Qué revisar

```sql
SELECT *
FROM staging_compra
WHERE fecha_compra IS NULL;
```

## Columna no existe

### Error típico

```text
column ... does not exist
```

### Causa común

Diferencia entre nombres reales y nombres escritos en la consulta.

### Qué revisar

```sql
SELECT column_name
FROM information_schema.columns
WHERE table_name = 'staging_compra';
```

## Tipo incorrecto en JOIN

### Problema

Un lado es texto y el otro entero.

### Solución

Normaliza tipos antes del `JOIN`.

```sql
SELECT *
FROM staging_compra d
JOIN producto p ON p.id = d.id_producto::integer;
```

## JOIN sin resultados

### Causa común

Los valores parecen iguales, pero tienen mayúsculas, espacios o variantes distintas.

### Solución rápida

```sql
SELECT *
FROM staging_compra d
JOIN bodega b
  ON UPPER(TRIM(b.nombre)) = UPPER(TRIM(d.nombre_bodega));
```

## Más filas de las esperadas

### Causa común

El `JOIN` no es 1 a 1 y multiplica registros.

### Qué revisar

```sql
SELECT nit, COUNT(*)
FROM proveedor
GROUP BY nit
HAVING COUNT(*) > 1;
```

## UPDATE o DELETE masivo accidental

### Regla

Nunca ejecutes `UPDATE` o `DELETE` sin probar primero el `WHERE` con `SELECT`.

```sql
SELECT *
FROM compra
WHERE id_registro = 10;
```

## Secuencia desfasada

### Error típico

Insertas sin ID manual, pero la secuencia intenta reutilizar uno existente.

### Ajuste típico

```sql
SELECT setval('compra_id_registro_seq', (SELECT MAX(id_registro) FROM compra));
```

## Checklist rápida

- ¿La maestra tiene el valor que buscas?
- ¿Los tipos coinciden?
- ¿El texto está homologado?
- ¿Hay duplicados en la clave de cruce?
- ¿Probaste el `SELECT` antes del `INSERT`?
