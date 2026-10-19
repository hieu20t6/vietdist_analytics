import io
import pandas as pd



from io import BytesIO
import pandas as pd


def parse_csv(file_bytes: bytes) -> pd.DataFrame:
    encodings = ["utf-8-sig", "utf-8", "cp1258", "cp1252"]

    for encoding in encodings:
        try:
            df = pd.read_csv(
                BytesIO(file_bytes),
                encoding=encoding
            )
            return df

        except UnicodeDecodeError:
            continue

    raise ValueError("Không đọc được encoding của file CSV")


def parse_xlsx(file_bytes: bytes, sheet_name=0) -> pd.DataFrame:
    df = pd.read_excel(
        BytesIO(file_bytes),
        sheet_name=sheet_name,
        engine="openpyxl"
    )

    return df


def parse_xlsm(file_bytes: bytes, sheet_name=0) -> pd.DataFrame:
    df = pd.read_excel(
        BytesIO(file_bytes),
        sheet_name=sheet_name,
        engine="openpyxl"
    )

    return df


def parse_xlsb(file_bytes: bytes, sheet_name=0) -> pd.DataFrame:
    df = pd.read_excel(
        BytesIO(file_bytes),
        sheet_name=sheet_name,
        engine="pyxlsb"
    )

    return df


def parse_file(file_bytes: bytes, filename: str, sheet_name=0) -> pd.DataFrame:
    extension = filename.lower().split(".")[-1]

    if extension == "csv":
        return parse_csv(file_bytes)

    elif extension == "xlsx":
        return parse_xlsx(file_bytes, sheet_name)

    elif extension == "xlsm":
        return parse_xlsm(file_bytes, sheet_name)

    elif extension == "xlsb":
        return parse_xlsb(file_bytes, sheet_name)

    else:
        raise ValueError(f"Định dạng file không hỗ trợ: {extension}")



