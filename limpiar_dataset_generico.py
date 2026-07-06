import argparse
import re
import unicodedata
from decimal import Decimal, InvalidOperation
from pathlib import Path

import pandas as pd

NULL_TOKENS = {
    "", "na", "n/a", "null", "none", "nan", "sin dato", "s/d", "no aplica"
}

DATE_HINTS = ["fecha", "date", "fch", "nacimiento", "registro", "compra", "venta", "creado"]
PHONE_HINTS = ["telefono", "tel", "cel", "celular", "movil", "mobile", "whatsapp"]
EMAIL_HINTS = ["email", "correo", "mail", "e_mail"]
ID_HINTS = ["id", "codigo", "cod", "consecutivo", "folio"]
NUMERIC_HINTS = ["precio", "valor", "total", "monto", "saldo", "stock", "cantidad", "peso", "edad", "score", "promedio", "rate"]
TEXT_TITLE_HINTS = ["nombre", "ciudad", "pais", "country", "categoria", "subcategoria", "bodega", "direccion", "responsable", "empresa", "proveedor", "cliente"]
TEXT_UPPER_HINTS = ["departamento", "estado", "region", "tipo", "clase"]


def remove_accents(text: str) -> str:
    return "".join(
        char for char in unicodedata.normalize("NFKD", text)
        if not unicodedata.combining(char)
    )


def normalize_column_name(name: str) -> str:
    name = str(name).strip().lower()
    name = remove_accents(name)
    name = re.sub(r"[^a-z0-9]+", "_", name)
    name = re.sub(r"_+", "_", name).strip("_")
    return name or "columna_sin_nombre"


def simplify_spaces(value):
    if pd.isna(value):
        return pd.NA
    value = re.sub(r"\s+", " ", str(value).strip())
    return value if value else pd.NA


def normalize_null_like(value):
    if pd.isna(value):
        return pd.NA
    cleaned = str(value).strip().lower()
    return pd.NA if cleaned in NULL_TOKENS else value


def parse_generic_date(value):
    if pd.isna(value):
        return pd.NaT

    raw = str(value).strip()
    formats = [
        "%Y-%m-%d", "%d-%m-%Y", "%m-%d-%Y", "%Y/%m/%d", "%d/%m/%Y", "%m/%d/%Y",
        "%d %b %Y", "%d %B %Y", "%Y%m%d", "%d%m%Y", "%m%d%Y"
    ]

    for fmt in formats:
        try:
            return pd.to_datetime(raw, format=fmt)
        except ValueError:
            pass

    if re.match(r"^\d{2}-\d{2}-\d{4}$", raw):
        a, b, c = raw.split("-")
        if int(a) > 12:
            return pd.to_datetime(raw, format="%d-%m-%Y", errors="coerce")
        if int(b) > 12:
            return pd.to_datetime(raw, format="%m-%d-%Y", errors="coerce")

    if re.match(r"^\d{2}/\d{2}/\d{4}$", raw):
        a, b, c = raw.split("/")
        if int(a) > 12:
            return pd.to_datetime(raw, format="%d/%m/%Y", errors="coerce")
        if int(b) > 12:
            return pd.to_datetime(raw, format="%m/%d/%Y", errors="coerce")

    return pd.to_datetime(raw, dayfirst=True, errors="coerce")


def normalize_number_text(value):
    if pd.isna(value):
        return pd.NA

    text = str(value).strip().replace(" ", "")
    lower = text.lower()

    if "e+" in lower or "e-" in lower:
        try:
            text = format(Decimal(text), "f")
        except (InvalidOperation, ValueError):
            return pd.NA

    if "," in text and "." not in text:
        text = text.replace(",", ".")
    elif "," in text and "." in text:
        if text.rfind(",") > text.rfind("."):
            text = text.replace(".", "").replace(",", ".")
        else:
            text = text.replace(",", "")

    text = re.sub(r"[^0-9.\-]", "", text)
    return text if text not in {"", "-", ".", "-."} else pd.NA


def clean_phone(value):
    if pd.isna(value):
        return pd.NA
    digits = re.sub(r"\D", "", str(value))
    return digits if digits else pd.NA


def clean_email(value):
    if pd.isna(value):
        return pd.NA
    text = str(value).strip().lower()
    return text if text else pd.NA


def looks_numeric(series: pd.Series, threshold: float = 0.8) -> bool:
    sample = series.dropna().astype(str).head(100)
    if sample.empty:
        return False
    cleaned = sample.map(normalize_number_text)
    ratio = cleaned.notna().mean()
    return ratio >= threshold


def column_matches(column_name: str, hints: list[str]) -> bool:
    return any(hint in column_name for hint in hints)


def infer_column_role(column_name: str, series: pd.Series) -> str:
    if column_matches(column_name, DATE_HINTS):
        return "date"
    if column_matches(column_name, PHONE_HINTS):
        return "phone"
    if column_matches(column_name, EMAIL_HINTS):
        return "email"
    if column_matches(column_name, ID_HINTS):
        return "id"
    if column_matches(column_name, NUMERIC_HINTS):
        return "numeric"
    if looks_numeric(series):
        return "numeric"
    return "text"


def standardize_text_case(column_name: str, value):
    if pd.isna(value):
        return pd.NA
    text = simplify_spaces(value)
    if pd.isna(text):
        return pd.NA
    if column_matches(column_name, TEXT_UPPER_HINTS):
        return str(text).upper()
    if column_matches(column_name, TEXT_TITLE_HINTS):
        return str(text).title()
    return text


def clean_dataframe(df: pd.DataFrame):
    report_rows = []
    original_columns = list(df.columns)
    normalized_columns = []
    used_names = {}

    for col in original_columns:
        new_name = normalize_column_name(col)
        if new_name in used_names:
            used_names[new_name] += 1
            new_name = f"{new_name}_{used_names[new_name]}"
        else:
            used_names[new_name] = 0
        normalized_columns.append(new_name)

    df.columns = normalized_columns

    df = df.apply(lambda col: col.map(simplify_spaces) if col.dtype == "object" else col)
    df = df.apply(lambda col: col.map(normalize_null_like) if col.dtype == "object" else col)

    error_mask = pd.Series(False, index=df.index)

    for col in df.columns:
        role = infer_column_role(col, df[col])
        non_null_before = df[col].notna().sum()
        raw_backup_created = False

        if role == "date":
            backup_col = f"{col}_raw"
            if backup_col not in df.columns:
                df[backup_col] = df[col]
                raw_backup_created = True
            parsed = df[col].map(parse_generic_date)
            invalid = df[col].notna() & parsed.isna()
            error_mask = error_mask | invalid
            df[col] = parsed.dt.strftime("%Y-%m-%d")

        elif role == "phone":
            cleaned = df[col].map(clean_phone)
            invalid = df[col].notna() & cleaned.isna()
            error_mask = error_mask | invalid
            df[col] = cleaned

        elif role == "email":
            df[col] = df[col].map(clean_email)

        elif role in {"numeric", "id"}:
            cleaned = df[col].map(normalize_number_text)
            invalid = df[col].notna() & cleaned.isna()
            error_mask = error_mask | invalid
            numeric = pd.to_numeric(cleaned, errors="coerce")
            if role == "id":
                if numeric.dropna().apply(float.is_integer).all() if not numeric.dropna().empty else True:
                    df[col] = numeric.astype("Int64")
                else:
                    df[col] = numeric
            else:
                is_integer_like = numeric.dropna().apply(float.is_integer).mean() >= 0.95 if not numeric.dropna().empty else False
                df[col] = numeric.astype("Int64") if is_integer_like else numeric

        else:
            df[col] = df[col].map(lambda x: standardize_text_case(col, x))

        report_rows.append({
            "columna": col,
            "rol_inferido": role,
            "no_nulos_antes": int(non_null_before),
            "no_nulos_despues": int(df[col].notna().sum()),
            "respaldo_raw": raw_backup_created,
            "tipo_resultante": str(df[col].dtype),
        })

    errors_df = df[error_mask].copy()
    report_df = pd.DataFrame(report_rows)
    return df, errors_df, report_df


def main():
    parser = argparse.ArgumentParser(description="Limpieza genérica de datasets sin depender de columnas fijas")
    parser.add_argument("input_file", help="Ruta del archivo CSV de entrada")
    parser.add_argument("--output-dir", default="output_clean", help="Carpeta de salida")
    parser.add_argument("--sep", default=",", help="Separador del CSV")
    parser.add_argument("--encoding", default="utf-8-sig", help="Encoding del archivo")
    args = parser.parse_args()

    output_dir = Path(args.output_dir)
    output_dir.mkdir(parents=True, exist_ok=True)

    df = pd.read_csv(
        args.input_file,
        sep=args.sep,
        dtype=str,
        encoding=args.encoding,
        keep_default_na=False,
    )

    clean_df, errors_df, report_df = clean_dataframe(df)

    input_stem = Path(args.input_file).stem
    clean_path = output_dir / f"{input_stem}_limpio.csv"
    errors_path = output_dir / f"{input_stem}_errores.csv"
    report_path = output_dir / f"{input_stem}_reporte_limpieza.csv"

    clean_df.to_csv(clean_path, index=False, encoding="utf-8-sig", na_rep="\\N")
    errors_df.to_csv(errors_path, index=False, encoding="utf-8-sig", na_rep="\\N")
    report_df.to_csv(report_path, index=False, encoding="utf-8-sig")

    print(f"Archivo limpio: {clean_path}")
    print(f"Filas con posibles errores: {errors_path}")
    print(f"Reporte de limpieza: {report_path}")


if __name__ == "__main__":
    main()
