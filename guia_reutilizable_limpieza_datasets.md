# Guía reutilizable para limpiar cualquier dataset parecido

## Objetivo

Esta guía sirve para cuando el dataset cambie y los campos no sean exactamente los mismos.

La idea no es memorizar columnas específicas, sino aprender un método repetible.

## Enfoque general

Cuando cambie el archivo, haz siempre este orden:

1. Revisar encabezados.
2. Clasificar columnas por tipo.
3. Definir reglas de limpieza por tipo.
4. Aplicar conversiones.
5. Validar filas problemáticas.
6. Exportar limpio.

## Paso 1: Revisar encabezados

Primero mira los nombres reales de columnas:

```python
import pandas as pd

df = pd.read_csv('archivo.csv', sep=';', dtype=str, encoding='utf-8-sig', keep_default_na=False)
print(df.columns.tolist())
```

Luego normalízalos:

```python
df.columns = df.columns.str.strip().str.lower()
```

Si vienen con espacios, puedes convertirlos a guion bajo:

```python
df.columns = (
    df.columns
      .str.strip()
      .str.lower()
      .str.replace(' ', '_')
)
```

## Paso 2: Clasificar columnas por tipo lógico

No pienses en nombres exactos; piensa en categorías.

### A. Identificadores

Ejemplos:

- `id_registro`
- `id_producto`
- `id_cliente`

Regla:

- Deben quedar numéricos o nulos.

### B. Fechas

Ejemplos:

- `fecha_compra`
- `fecha_movimiento`
- `fecha_nacimiento`

Regla:

- Guardar la fecha original.
- Convertir a `datetime`.
- Exportar como `YYYY-MM-DD`.

### C. Números

Ejemplos:

- precios
- cantidades
- totales
- stock

Regla:

- Quitar espacios.
- Resolver coma decimal.
- Resolver notación científica.
- Convertir a `int` o `float`.

### D. Texto libre

Ejemplos:

- nombres
- ciudades
- observaciones
- categorías

Regla:

- `strip()`.
- Vacíos a nulo.
- Normalizar mayúsculas/minúsculas.
- Homologar variantes si hace falta.

### E. Teléfonos, documentos, códigos

No siempre deben convertirse a número.

A veces conviene tratarlos como texto y dejar solo caracteres válidos.

## Paso 3: Aplicar limpieza base reusable

```python
df = df.apply(lambda col: col.str.strip() if col.dtype == 'object' else col)

df = df.replace(r'^\s*$', pd.NA, regex=True)
df = df.replace({
    'N/A': pd.NA,
    'NA': pd.NA,
    'null': pd.NA,
    'NULL': pd.NA,
    'None': pd.NA
})
```

## Paso 4: Crear funciones reutilizables

### Fechas

```python
def parse_fecha(x):
    if pd.isna(x):
        return pd.NaT
    x = str(x).strip()

    formatos = [
        '%Y-%m-%d',
        '%d-%m-%Y',
        '%m-%d-%Y',
        '%d %b %Y',
        '%d %B %Y',
        '%d%m%Y',
        '%m%d%Y'
    ]

    for fmt in formatos:
        try:
            return pd.to_datetime(x, format=fmt)
        except ValueError:
            pass

    return pd.to_datetime(x, dayfirst=True, errors='coerce')
```

### Números

```python
from decimal import Decimal
import re

def normalizar_numero(x):
    if pd.isna(x):
        return pd.NA

    s = str(x).strip().replace(' ', '')

    if 'e+' in s.lower():
        try:
            s = format(Decimal(s), 'f')
        except:
            return pd.NA

    if ',' in s and '.' not in s:
        s = s.replace(',', '.')

    s = re.sub(r'[^0-9.\-]', '', s)
    return s if s != '' else pd.NA
```

### Teléfonos

```python
def limpiar_telefono(x):
    if pd.isna(x):
        return pd.NA
    s = str(x).strip()
    s = re.sub(r'\D', '', s)
    return s if s else pd.NA
```

### Homologación de texto

```python
def homologar(valor, mapa):
    if pd.isna(valor):
        return pd.NA
    clave = str(valor).strip().lower()
    return mapa.get(clave, str(valor).strip())
```

## Paso 5: Detectar columnas por nombre aproximado

Cuando no sepas si mañana se llamará `fecha_compra` o `fecha_movimiento`, busca por patrón.

```python
cols_fecha = [c for c in df.columns if 'fecha' in c]
cols_id = [c for c in df.columns if c.startswith('id_')]
cols_telefono = [c for c in df.columns if 'telefono' in c or 'celular' in c]
cols_total = [c for c in df.columns if 'total' in c or 'precio' in c or 'cantidad' in c]
```

Eso hace tu script más flexible.

## Paso 6: Trabajar por listas

```python
for col in cols_fecha:
    df[f'{col}_raw'] = df[col]
    df[col] = df[col].apply(parse_fecha)

for col in cols_telefono:
    df[col] = df[col].apply(limpiar_telefono)

for col in cols_total + cols_id:
    df[col] = df[col].apply(normalizar_numero)
```

## Paso 7: Validar antes de exportar

Haz revisiones rápidas:

```python
print(df.isna().sum())
print(df.dtypes)
print(df.head())
```

Y guarda errores:

```python
errores = df[df[cols_id].isna().any(axis=1)].copy()
```

## Paso 8: Exportar

```python
for col in cols_fecha:
    df[col] = pd.to_datetime(df[col], errors='coerce').dt.strftime('%Y-%m-%d')

df.to_csv('archivo_limpio.csv', sep=';', index=False, na_rep='\N', encoding='utf-8-sig')
```

## Regla mental para mañana

Si cambia el dataset, no empieces escribiendo todo el script.

Haz esto:

1. Mira columnas.
2. Decide cuáles son fecha, texto, número e identificador.
3. Reutiliza funciones.
4. Prueba con `head()`.
5. Exporta limpio.

## Chuleta breve

Memoriza estas ideas:

- Leer todo como `str` al principio.
- Limpiar vacíos antes de convertir tipos.
- Guardar la columna original si vas a convertir fechas.
- No tratar teléfonos como enteros normales.
- Homologar nombres y ciudades con diccionarios.
- Exportar con `na_rep='\N'` si luego cargarás a SQL.




## Usar script.py generico

- python limpiar_dataset_generico.py "Dataset_Riwi.csv" --sep ";"
