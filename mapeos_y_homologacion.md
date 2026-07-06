# Chuleta de mapeos y homologación

## Objetivo

Unificar variantes del mismo valor para evitar duplicados lógicos.

## Idea clave

Limpieza no es lo mismo que homologación.

- Limpieza: quitar espacios, arreglar fechas, números y vacíos.
- Homologación: decidir que varias variantes significan lo mismo.

## Cuándo homologar

Homologa sobre todo:

- ciudades
- países
- proveedores
- bodegas
- categorías
- subcategorías
- unidades de medida
- tipos de movimiento
- nombres de producto, si el negocio lo permite

## Ejemplos típicos

### Ciudades

```python
mapa_ciudad = {
    'bogot': 'Bogotá',
    'bogota': 'Bogotá',
    'bogota d.c.': 'Bogotá',
    'bquilla': 'Barranquilla',
    'medellin': 'Medellín'
}
```

### Países

```python
mapa_pais = {
    'co': 'Colombia',
    'col': 'Colombia',
    'colombia': 'Colombia'
}
```

### Tipos de movimiento

```python
mapa_movimiento = {
    'entrada': 'Entrada',
    'ingreso': 'Entrada',
    'salida': 'Salida',
    'egreso': 'Salida'
}
```

### Unidades de medida

```python
mapa_unidad = {
    'und': 'UND',
    'unidad': 'UND',
    'uni': 'UND',
    'mts': 'M',
    'metro': 'M',
    'metros': 'M',
    'ml': 'ML'
}
```

## Función reusable en pandas

```python
def homologar(valor, mapa):
    if pd.isna(valor):
        return pd.NA
    clave = str(valor).strip().lower()
    return mapa.get(clave, str(valor).strip())
```

## Uso

```python
df['ciudad_proveedor'] = df['ciudad_proveedor'].apply(lambda x: homologar(x, mapa_ciudad))
df['pais_proveedor'] = df['pais_proveedor'].apply(lambda x: homologar(x, mapa_pais))
df['tipo_movimiento'] = df['tipo_movimiento'].apply(lambda x: homologar(x, mapa_movimiento))
```

## Qué columnas usar para consolidar entidades

- `proveedor`: mejor `nit`
- `producto`: mejor código o combinación estable
- `bodega`: nombre + dirección si hace falta
- `ciudad`: nombre homologado + país
- `empleado`: nombre homologado si no existe documento

## Riesgos comunes

- Homologar cosas distintas como si fueran la misma.
- Homologar demasiado pronto sin revisar el negocio.
- Dejar la homologación solo por nombre si existe una clave mejor.
- Mezclar limpieza estructural con reglas del negocio.

## Método práctico

1. Saca `SELECT DISTINCT` o `value_counts()`.
2. Lista variantes parecidas.
3. Define el valor canónico.
4. Crea un diccionario.
5. Aplica la homologación.
6. Vuelve a revisar `DISTINCT`.

## Consulta útil en SQL

```sql
SELECT DISTINCT nombre_bodega
FROM staging_compra
ORDER BY 1;
```

## Revisión en pandas

```python
df['nombre_bodega'].value_counts(dropna=False)
```

## Checklist rápida

- ¿Definiste un valor canónico?
- ¿Tienes evidencia de que las variantes sí son la misma entidad?
- ¿La maestra quedó sin duplicados lógicos?
- ¿Documentaste el mapa usado?
