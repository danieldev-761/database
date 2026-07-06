# Chuleta de limpieza con pandas

## Objetivo

Limpiar lo principal de un dataset sucio antes de insertarlo en PostgreSQL.

## Orden recomendado

1. Leer todo como texto.
2. Normalizar nombres de columnas.
3. Limpiar espacios y vacíos.
4. Convertir nulos lógicos.
5. Limpiar fechas.
6. Limpiar números.
7. Limpiar teléfonos y correos.
8. Homologar texto importante.
9. Validar errores.
10. Exportar.

## Lectura segura

```python
import pandas as pd

df = pd.read_csv(
    'archivo.csv',
    sep=';',
    dtype=str,
    encoding='utf-8-sig',
    keep_default_na=False
)
```

## Normalizar columnas

```python
df.columns = (
    df.columns
      .str.strip()
      .str.lower()
      .str.replace(' ', '_', regex=False)
)
```

## Quitar espacios

```python
df = df.apply(lambda col: col.str.strip() if col.dtype == 'object' else col)
```

## Convertir vacíos a nulos

```python
df = df.replace(r'^\s*$', pd.NA, regex=True)
df = df.replace({
    'N/A': pd.NA,
    'NA': pd.NA,
    'null': pd.NA,
    'NULL': pd.NA,
    'None': pd.NA
})
```

## Limpiar fechas

```python
def parse_fecha(x):
    if pd.isna(x):
        return pd.NaT
    x = str(x).strip()
    formatos = [
        '%Y-%m-%d', '%d-%m-%Y', '%m-%d-%Y',
        '%d %b %Y', '%d %B %Y', '%d%m%Y', '%m%d%Y'
    ]
    for fmt in formatos:
        try:
            return pd.to_datetime(x, format=fmt)
        except ValueError:
            pass
    return pd.to_datetime(x, dayfirst=True, errors='coerce')
```

Uso:

```python
df['fecha_compra_raw'] = df['fecha_compra']
df['fecha_compra'] = df['fecha_compra'].apply(parse_fecha)
df['fecha_compra'] = df['fecha_compra'].dt.strftime('%Y-%m-%d')
```

## Limpiar números

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

Uso:

```python
for col in ['precio_unitario', 'valor_total_compra', 'cantidad_comprada']:
    df[col] = df[col].apply(normalizar_numero)
```

## Limpiar teléfonos

```python
import re

def limpiar_telefono(x):
    if pd.isna(x):
        return pd.NA
    s = re.sub(r'\D', '', str(x))
    return s if s else pd.NA
```

## Limpiar correos

```python
df['email'] = df['email'].str.strip().str.lower()
```

## Homologar valores

```python
mapa_ciudad = {
    'bogota': 'Bogotá',
    'bogot': 'Bogotá',
    'bquilla': 'Barranquilla'
}

def homologar(x, mapa):
    if pd.isna(x):
        return pd.NA
    clave = str(x).strip().lower()
    return mapa.get(clave, str(x).strip())
```

## Validar errores

```python
errores = df[
    df['id_registro'].isna() |
    df['id_producto'].isna() |
    df['fecha_compra'].isna()
].copy()
```

## Exportar

```python
df.to_csv('archivo_limpio.csv', sep=';', index=False, na_rep='\N', encoding='utf-8-sig')
errores.to_csv('archivo_errores.csv', sep=';', index=False, na_rep='\N', encoding='utf-8-sig')
```

## Checklist rápida

- ¿Las columnas están en `snake_case`?
- ¿Los vacíos ya son `pd.NA`?
- ¿Las fechas quedaron como `YYYY-MM-DD`?
- ¿Los teléfonos tienen solo dígitos?
- ¿Los números ya no tienen comas raras?
- ¿Guardaste un archivo de errores?
