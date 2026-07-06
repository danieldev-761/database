import argparse
from pathlib import Path
import pandas as pd


def convert_excel_to_csv(input_file: str, output_file: str | None = None, sheet_name=0, sep: str = ',', encoding: str = 'utf-8-sig'):
    input_path = Path(input_file)

    if output_file is None:
        if sheet_name == 0:
            output_path = input_path.with_suffix('.csv')
        else:
            safe_sheet = str(sheet_name).replace(' ', '_')
            output_path = input_path.with_name(f"{input_path.stem}_{safe_sheet}.csv")
    else:
        output_path = Path(output_file)

    df = pd.read_excel(input_path, sheet_name=sheet_name)
    df.to_csv(output_path, index=False, sep=sep, encoding=encoding)
    return output_path


def main():
    parser = argparse.ArgumentParser(description='Convierte un archivo .xls o .xlsx a .csv')
    parser.add_argument('input_file', help='Ruta del archivo Excel de entrada')
    parser.add_argument('--output', help='Ruta del CSV de salida', default=None)
    parser.add_argument('--sheet', help='Nombre o índice de la hoja', default=0)
    parser.add_argument('--sep', help='Separador del CSV', default=',')
    parser.add_argument('--encoding', help='Encoding del CSV', default='utf-8-sig')
    args = parser.parse_args()

    try:
        sheet = int(args.sheet)
    except ValueError:
        sheet = args.sheet

    output_path = convert_excel_to_csv(
        input_file=args.input_file,
        output_file=args.output,
        sheet_name=sheet,
        sep=args.sep,
        encoding=args.encoding,
    )

    print(f'CSV generado: {output_path}')


if __name__ == '__main__':
    main()
