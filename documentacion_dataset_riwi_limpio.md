# Documentación de limpieza de `Dataset_Riwi_limpio.csv`

## Objetivo

Este documento explica qué hace el script de limpieza en Python/Pandas y qué tan bien quedó el archivo `Dataset_Riwi_limpio.csv`.

## Resumen del proceso

El script hace estas etapas:

1. Lee el CSV original con `sep=';'`, `dtype=str` y `encoding='utf-8-sig'`.
2. Normaliza los nombres de columnas a minúsculas.
3. Elimina espacios laterales en columnas tipo texto.
4. Convierte vacíos y textos como `NA`, `N/A`, `NULL` y `None` a valores nulos de Pandas.
5. Guarda la fecha original en `fecha_compra_raw`.
6. Convierte `fecha_compra` soportando varios formatos.
7. Marca fechas ambiguas en `fecha_ambigua`.
8. Limpia columnas numéricas, incluyendo notación científica y coma decimal.
9. Limpia `telefono_proveedor` para dejarlo como texto numérico.
10. Convierte tipos y exporta `Dataset_Riwi_limpio.csv` y `Dataset_Riwi_errores.csv`.

## Cosas que sí quedaron bien

### 1) Fechas

El archivo limpio ya tiene `fecha_compra` en formato estándar `YYYY-MM-DD` en muchas filas.

También conserva dos columnas útiles para auditoría:

- `fecha_compra_raw`: guarda la fecha original.
- `fecha_ambigua`: marca fechas del tipo `dd-mm-yyyy` o `mm-dd-yyyy` para revisión.

### 2) Nulos

Los campos vacíos o equivalentes a nulo fueron tratados antes de exportar.

Esto ayuda mucho para insertar después con menos errores de tipos.

### 3) Números

El script logró varias cosas importantes:

- Pasar teléfonos en notación científica a formato legible.
- Cambiar coma decimal por punto en valores como `1047899,749`.
- Convertir IDs y cantidades a enteros cuando fue posible.
- Convertir precios y valores totales a tipo numérico.

## Cosas que todavía quedaron sucias

### 1) Nombres

Todavía hay variaciones de un mismo valor, por ejemplo:

- `Tecno Partes Ltda.`
- `TECNOPARTES LTDA`
- `TecnoPartes`

Eso significa que el script limpió formato, pero no homologó entidades.

### 2) Ciudades

Todavía hay variantes como:

- `Bogot`
- `Bogota`
- `BOGOTA D.C.`
- `Bquilla`
- `Barranquilla`
- `Medellin`
- `Medellín, Ant.`

Eso afecta mucho los `INSERT DISTINCT` en tablas maestras como `ciudad`, `proveedor` y `bodega`.

### 3) Teléfonos

Aunque muchos quedaron bien, todavía hay teléfonos con separadores como `-` o formatos heterogéneos.

Si quieres una limpieza más fuerte, conviene dejar solo dígitos.

Ejemplo recomendado:

```python
import re

def limpiar_telefono(x):
    if pd.isna(x):
        return pd.NA
    s = str(x).strip()
    s = re.sub(r'\D', '', s)
    return s if s else pd.NA


df['telefono_proveedor'] = df['telefono_proveedor'].apply(limpiar_telefono)
```

### 4) Texto homogéneo

Para nombres, ciudades, bodegas, categorías y unidades, faltó una etapa de homologación.

Eso no es lo mismo que quitar espacios: aquí ya se trata de mapear variantes a un solo nombre canónico.

## Mejora recomendada al script

### Normalizar nombres y ciudades con diccionarios

```python
normalizar_ciudad = {
    'bogot': 'Bogotá',
    'bogota': 'Bogotá',
    'bogota d.c.': 'Bogotá',
    'bogot d.c.': 'Bogotá',
    'bquilla': 'Barranquilla',
    'barranquilla': 'Barranquilla',
    'medellin': 'Medellín',
    'medellín, ant.': 'Medellín',
    'cali': 'Cali'
}


def homologar(valor, mapa):
    if pd.isna(valor):
        return pd.NA
    clave = str(valor).strip().lower()
    return mapa.get(clave, str(valor).strip())


df['ciudad_proveedor'] = df['ciudad_proveedor'].apply(lambda x: homologar(x, normalizar_ciudad))
df['ciudad_bodega'] = df['ciudad_bodega'].apply(lambda x: homologar(x, normalizar_ciudad))
```

### Normalizar nombres de proveedor

```python
normalizar_proveedor = {
    'tecnopartes ltda': 'Tecno Partes Ltda.',
    'tecno partes ltda.': 'Tecno Partes Ltda.',
    'tecnopartes': 'Tecno Partes Ltda.',
    'sum. industriales norte': 'Suministros Industriales del Norte',
    'suministros ind. del norte': 'Suministros Industriales del Norte'
}
```

## Recomendación práctica

Para inserts de mañana, este archivo ya sirve muy bien como base intermedia.

Lo ideal es:

1. Importar el CSV limpio a una tabla staging.
2. Hacer una segunda limpieza corta en SQL.
3. Poblar tablas maestras con `SELECT DISTINCT`.
4. Después llenar tablas transaccionales.

## Idea clave

El script sí resolvió lo más difícil del dataset: fechas mixtas, nulos, números y parte del problema de teléfonos.

Lo que faltó no es “limpieza básica”, sino homologación semántica para evitar duplicados lógicos.
