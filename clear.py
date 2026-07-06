import pandas as pd
from decimal import Decimal
import re

df = pd.read_csv(
    "Dataset_Riwi.csv",
    sep=";",
    dtype=str,
    encoding="utf-8-sig",
    keep_default_na=False
)

# 1) Normalizar nombres de columnas
df.columns = df.columns.str.strip().str.lower()

# 2) Quitar espacios laterales
df = df.apply(lambda col: col.str.strip() if col.dtype == "object" else col)

# 3) Convertir vacíos, espacios y textos tipo null a NA
df = df.replace(r"^\s*$", pd.NA, regex=True)
df = df.replace({
    "N/A": pd.NA,
    "NA": pd.NA,
    "null": pd.NA,
    "NULL": pd.NA,
    "None": pd.NA
})

# Guardar fecha original para auditoría
df["fecha_compra_raw"] = df["fecha_compra"]

def parse_fecha(x):
    if pd.isna(x):
        return pd.NaT
    x = str(x).strip()

    formatos = [
        "%Y-%m-%d",   # 2023-07-12
        "%d-%m-%Y",   # 25-08-2023
        "%m-%d-%Y",   # 07-18-2023
        "%d %b %Y",   # 27 Apr 2024
        "%d %B %Y",   # 27 April 2024
        "%d%m%Y",     # 18052023
        "%m%d%Y"      # 04112024
    ]

    for fmt in formatos:
        try:
            return pd.to_datetime(x, format=fmt)
        except ValueError:
            pass

    return pd.to_datetime(x, dayfirst=True, errors="coerce")

df["fecha_compra"] = df["fecha_compra"].apply(parse_fecha)

# Marcar fechas ambiguas tipo 07-06-2024
df["fecha_ambigua"] = df["fecha_compra_raw"].str.match(r"^\d{2}-\d{2}-\d{4}$", na=False)

def normalizar_numero(x):
    if pd.isna(x):
        return pd.NA

    s = str(x).strip().replace(" ", "")

    # notación científica
    if "e+" in s.lower():
        try:
            s = format(Decimal(s), "f")
        except:
            return pd.NA

    # coma decimal -> punto decimal
    if "," in s and "." not in s:
        s = s.replace(",", ".")

    # dejar solo números, punto y signo
    s = re.sub(r"[^0-9.\-]", "", s)

    return s if s != "" else pd.NA

cols_numericas = [
    "id_registro",
    "id_proveedor",
    "id_producto",
    "precio_unitario",
    "cantidad_comprada",
    "valor_total_compra",
    "id_bodega",
    "cantidad_movimiento",
    "stock_actual"
]

for col in cols_numericas:
    df[col] = df[col].apply(normalizar_numero)

# teléfono: conservar dígitos y evitar .0
df["telefono_proveedor"] = (
    df["telefono_proveedor"]
    .apply(normalizar_numero)
    .str.replace(r"\.0+$", "", regex=True)
)

# Convertir tipos
cols_enteras = [
    "id_registro",
    "id_proveedor",
    "id_producto",
    "cantidad_comprada",
    "id_bodega",
    "cantidad_movimiento",
    "stock_actual"
]

for col in cols_enteras:
    df[col] = pd.to_numeric(df[col], errors="coerce").astype("Int64")

for col in ["precio_unitario", "valor_total_compra"]:
    df[col] = pd.to_numeric(df[col], errors="coerce")

# Exportar fecha limpia
df["fecha_compra"] = df["fecha_compra"].dt.strftime("%Y-%m-%d")

# Filas con error para revisar antes de insertar
errores = df[
    df["fecha_compra"].isna() |
    df["id_registro"].isna() |
    df["id_proveedor"].isna() |
    df["id_producto"].isna()
].copy()

# Archivos de salida
df.to_csv("Dataset_Riwi_limpio.csv", sep=";", index=False, na_rep="\\N", encoding="utf-8-sig")
errores.to_csv("Dataset_Riwi_errores.csv", sep=";", index=False, na_rep="\\N", encoding="utf-8-sig")