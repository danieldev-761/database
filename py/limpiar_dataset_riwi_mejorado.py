import pandas as pd
from decimal import Decimal
import re
import unicodedata

INPUT_CSV = "Dataset_Riwi.csv"
OUTPUT_CLEAN_CSV = "Dataset_Riwi_limpio.csv"
OUTPUT_ERRORS_CSV = "Dataset_Riwi_errores.csv"

NULL_LIKE_VALUES = {"N/A", "NA", "NULL", "NONE", "NAN"}

CITY_MAP = {
    "bogot": "Bogotá",
    "bogota": "Bogotá",
    "bogota d.c.": "Bogotá",
    "bogot d.c.": "Bogotá",
    "bogota d.c": "Bogotá",
    "bogot d.c": "Bogotá",
    "bogot, d.c.": "Bogotá",
    "bquilla": "Barranquilla",
    "barranquilla": "Barranquilla",
    "medellin": "Medellín",
    "medellin, ant.": "Medellín",
    "medellin ant.": "Medellín",
    "medellin, ant": "Medellín",
    "cali": "Cali",
    "santiago de cali": "Cali",
    "cali, valle": "Cali",
    "bucaramanga": "Bucaramanga",
    "bucaramanga, sant.": "Bucaramanga",
    "bucaramanga sant.": "Bucaramanga",
}

COUNTRY_MAP = {
    "co": "Colombia",
    "col": "Colombia",
    "colombia": "Colombia",
}

PROVIDER_MAP = {
    "tecnopartes": "Tecno Partes Ltda.",
    "tecnopartes ltda": "Tecno Partes Ltda.",
    "tecno partes ltda": "Tecno Partes Ltda.",
    "tecno partes ltda.": "Tecno Partes Ltda.",
    "sum. industriales norte": "Suministros Industriales del Norte",
    "suministros ind. del norte": "Suministros Industriales del Norte",
    "suministros industriales norte": "Suministros Industriales del Norte",
    "suministros industriales del norte": "Suministros Industriales del Norte",
    "dist electronica mde": "Distribuidora Electrónica Medellín",
    "dist. electronica medellin": "Distribuidora Electrónica Medellín",
    "distribuidora electronica medellin": "Distribuidora Electrónica Medellín",
    "distribuidora electrónica medellín": "Distribuidora Electrónica Medellín",
    "plastiflex cali": "Plastiflex Cali Ltda.",
    "plastiflex cali ltda": "Plastiflex Cali Ltda.",
    "met. aleaciones s.a.": "Metales y Aleaciones S.A.",
    "metales y aleaciones sa": "Metales y Aleaciones S.A.",
    "metales y aleaciones s.a": "Metales y Aleaciones S.A.",
    "ferreteria torres s.a.s": "Ferretería Torres S.A.S.",
    "ferretera torres sas": "Ferretería Torres S.A.S.",
}

WAREHOUSE_MAP = {
    "bdg central": "Bodega Central Bogotá",
    "bodega central bogota": "Bodega Central Bogotá",
    "bodega cntrl bogot": "Bodega Central Bogotá",
    "bodega cntrl bogotá": "Bodega Central Bogotá",
    "bodega central bogotá": "Bodega Central Bogotá",
    "bdg norte bq": "Bodega Norte Barranquilla",
    "bodega norte barranquilla": "Bodega Norte Barranquilla",
    "bodega norte bquilla": "Bodega Norte Barranquilla",
    "bodega sur-cali": "Bodega Sur Cali",
    "bodega sur cali": "Bodega Sur Cali",
    "bdg sur cali": "Bodega Sur Cali",
    "bodega medellin": "Bodega Medellín",
    "bodega medellín": "Bodega Medellín",
    "bdg medellin": "Bodega Medellín",
    "bodega mde": "Bodega Medellín",
}

MOVEMENT_MAP = {
    "entrada": "Entrada",
    "ingreso": "Entrada",
    "salida": "Salida",
    "egreso": "Salida",
}

UNIT_MAP = {
    "m": "M",
    "mt": "M",
    "mts": "M",
    "metro": "M",
    "metros": "M",
    "ml": "ML",
    "und": "UND",
    "uni": "UND",
    "unidad": "UND",
    "bto": "BTO",
    "gl": "GL",
    "gal": "GAL",
    "galon": "GAL",
    "galón": "GAL",
    "bulto": "BTO",
    "saco": "BTO",
}

INTEGER_COLUMNS = [
    "id_registro",
    "id_proveedor",
    "id_producto",
    "cantidad_comprada",
    "id_bodega",
    "cantidad_movimiento",
    "stock_actual",
]

NUMERIC_COLUMNS = [
    "id_registro",
    "id_proveedor",
    "id_producto",
    "precio_unitario",
    "cantidad_comprada",
    "valor_total_compra",
    "id_bodega",
    "cantidad_movimiento",
    "stock_actual",
]

DECIMAL_COLUMNS = ["precio_unitario", "valor_total_compra"]


def normalize_column_names(dataframe: pd.DataFrame) -> pd.DataFrame:
    dataframe.columns = (
        dataframe.columns
        .str.strip()
        .str.lower()
        .str.replace(" ", "_", regex=False)
    )
    return dataframe


def strip_text_columns(dataframe: pd.DataFrame) -> pd.DataFrame:
    return dataframe.apply(lambda column: column.str.strip() if column.dtype == "object" else column)


def replace_null_like_values(dataframe: pd.DataFrame) -> pd.DataFrame:
    dataframe = dataframe.replace(r"^\s*$", pd.NA, regex=True)

    def normalize_null_token(value):
        if pd.isna(value):
            return pd.NA
        if isinstance(value, str) and value.strip().upper() in NULL_LIKE_VALUES:
            return pd.NA
        return value

    return dataframe.map(normalize_null_token)


def remove_accents(text: str) -> str:
    return "".join(
        char for char in unicodedata.normalize("NFKD", text)
        if not unicodedata.combining(char)
    )


def simplify_text(value):
    if pd.isna(value):
        return pd.NA
    cleaned = re.sub(r"\s+", " ", str(value).strip())
    return cleaned if cleaned else pd.NA


def fold_key(value):
    if pd.isna(value):
        return None
    key = simplify_text(value)
    if pd.isna(key):
        return None
    key = remove_accents(str(key)).lower()
    return key


def standardize_with_map(value, value_map, default_mode="title"):
    if pd.isna(value):
        return pd.NA

    cleaned = simplify_text(value)
    if pd.isna(cleaned):
        return pd.NA

    folded = fold_key(cleaned)
    if folded in value_map:
        return value_map[folded]

    if default_mode == "upper":
        return str(cleaned).upper()
    if default_mode == "lower":
        return str(cleaned).lower()
    return str(cleaned).title()


def parse_mixed_date(value):
    if pd.isna(value):
        return pd.NaT

    raw_value = str(value).strip()
    date_formats = [
        "%Y-%m-%d",
        "%d-%m-%Y",
        "%m-%d-%Y",
        "%d %b %Y",
        "%d %B %Y",
        "%d%m%Y",
        "%m%d%Y",
    ]

    for date_format in date_formats:
        try:
            return pd.to_datetime(raw_value, format=date_format)
        except ValueError:
            pass

    if re.match(r"^\d{2}-\d{2}-\d{4}$", raw_value):
        first_part, second_part, year_part = raw_value.split("-")
        first_number = int(first_part)
        second_number = int(second_part)

        if first_number > 12:
            return pd.to_datetime(raw_value, format="%d-%m-%Y", errors="coerce")
        if second_number > 12:
            return pd.to_datetime(raw_value, format="%m-%d-%Y", errors="coerce")

    return pd.to_datetime(raw_value, dayfirst=True, errors="coerce")


def normalize_number_text(value):
    if pd.isna(value):
        return pd.NA

    cleaned = str(value).strip().replace(" ", "")

    if "e+" in cleaned.lower():
        try:
            cleaned = format(Decimal(cleaned), "f")
        except Exception:
            return pd.NA

    if "," in cleaned and "." not in cleaned:
        cleaned = cleaned.replace(",", ".")

    cleaned = re.sub(r"[^0-9.\-]", "", cleaned)
    return cleaned if cleaned else pd.NA


def clean_phone_number(value):
    if pd.isna(value):
        return pd.NA

    cleaned = str(value).strip()

    if "e+" in cleaned.lower():
        try:
            cleaned = format(Decimal(cleaned), "f")
        except Exception:
            return pd.NA

    digits_only = re.sub(r"\D", "", cleaned)
    return digits_only if digits_only else pd.NA


def standardize_email(value):
    if pd.isna(value):
        return pd.NA
    cleaned = simplify_text(value)
    if pd.isna(cleaned):
        return pd.NA
    return str(cleaned).lower()


def add_raw_backup_column(dataframe, column_name):
    if column_name in dataframe.columns:
        dataframe[f"{column_name}_raw"] = dataframe[column_name]


def main():
    dataset = pd.read_csv(
        INPUT_CSV,
        sep=";",
        dtype=str,
        encoding="utf-8-sig",
        keep_default_na=False,
    )

    dataset = normalize_column_names(dataset)
    dataset = strip_text_columns(dataset)
    dataset = replace_null_like_values(dataset)

    add_raw_backup_column(dataset, "fecha_compra")
    add_raw_backup_column(dataset, "nombre_proveedor")
    add_raw_backup_column(dataset, "ciudad_proveedor")
    add_raw_backup_column(dataset, "pais_proveedor")
    add_raw_backup_column(dataset, "nombre_bodega")
    add_raw_backup_column(dataset, "ciudad_bodega")
    add_raw_backup_column(dataset, "tipo_movimiento")
    add_raw_backup_column(dataset, "unidad_medida")
    add_raw_backup_column(dataset, "telefono_proveedor")

    if "fecha_compra" in dataset.columns:
        dataset["fecha_compra"] = dataset["fecha_compra"].apply(parse_mixed_date)

    if "fecha_compra_raw" in dataset.columns:
        dataset["fecha_ambigua"] = dataset["fecha_compra_raw"].str.match(r"^\d{2}-\d{2}-\d{4}$", na=False)

    for numeric_column in [column for column in NUMERIC_COLUMNS if column in dataset.columns]:
        dataset[numeric_column] = dataset[numeric_column].apply(normalize_number_text)

    if "telefono_proveedor" in dataset.columns:
        dataset["telefono_proveedor"] = dataset["telefono_proveedor"].apply(clean_phone_number)

    if "email_proveedor" in dataset.columns:
        dataset["email_proveedor"] = dataset["email_proveedor"].apply(standardize_email)

    if "nombre_proveedor" in dataset.columns:
        dataset["nombre_proveedor"] = dataset["nombre_proveedor"].apply(
            lambda value: standardize_with_map(value, PROVIDER_MAP, default_mode="title")
        )

    if "ciudad_proveedor" in dataset.columns:
        dataset["ciudad_proveedor"] = dataset["ciudad_proveedor"].apply(
            lambda value: standardize_with_map(value, CITY_MAP, default_mode="title")
        )

    if "ciudad_bodega" in dataset.columns:
        dataset["ciudad_bodega"] = dataset["ciudad_bodega"].apply(
            lambda value: standardize_with_map(value, CITY_MAP, default_mode="title")
        )

    if "pais_proveedor" in dataset.columns:
        dataset["pais_proveedor"] = dataset["pais_proveedor"].apply(
            lambda value: standardize_with_map(value, COUNTRY_MAP, default_mode="title")
        )

    if "nombre_bodega" in dataset.columns:
        dataset["nombre_bodega"] = dataset["nombre_bodega"].apply(
            lambda value: standardize_with_map(value, WAREHOUSE_MAP, default_mode="title")
        )

    if "tipo_movimiento" in dataset.columns:
        dataset["tipo_movimiento"] = dataset["tipo_movimiento"].apply(
            lambda value: standardize_with_map(value, MOVEMENT_MAP, default_mode="title")
        )

    if "unidad_medida" in dataset.columns:
        dataset["unidad_medida"] = dataset["unidad_medida"].apply(
            lambda value: standardize_with_map(value, UNIT_MAP, default_mode="upper")
        )

    text_columns_to_title = [
        "nombre_producto",
        "descripcion_producto",
        "categoria_producto",
        "subcategoria_producto",
        "responsable_bodega",
        "observaciones",
        "direccion_bodega",
    ]

    for text_column in text_columns_to_title:
        if text_column in dataset.columns:
            dataset[text_column] = dataset[text_column].apply(
                lambda value: simplify_text(value) if pd.isna(value) else simplify_text(value)
            )

    for integer_column in [column for column in INTEGER_COLUMNS if column in dataset.columns]:
        dataset[integer_column] = pd.to_numeric(dataset[integer_column], errors="coerce").astype("Int64")

    for decimal_column in [column for column in DECIMAL_COLUMNS if column in dataset.columns]:
        dataset[decimal_column] = pd.to_numeric(dataset[decimal_column], errors="coerce")

    if "fecha_compra" in dataset.columns:
        dataset["fecha_compra"] = pd.to_datetime(dataset["fecha_compra"], errors="coerce").dt.strftime("%Y-%m-%d")

    required_columns = [column for column in ["fecha_compra", "id_registro", "id_proveedor", "id_producto"] if column in dataset.columns]
    rows_with_errors = dataset[dataset[required_columns].isna().any(axis=1)].copy() if required_columns else dataset.iloc[0:0].copy()

    dataset.to_csv(OUTPUT_CLEAN_CSV, sep=";", index=False, na_rep="\\N", encoding="utf-8-sig")
    rows_with_errors.to_csv(OUTPUT_ERRORS_CSV, sep=";", index=False, na_rep="\\N", encoding="utf-8-sig")


if __name__ == "__main__":
    main()
