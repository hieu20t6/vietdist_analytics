import os
import sys
import uuid
import time
from pathlib import Path
from io import BytesIO

import pandas as pd
from sqlalchemy import text

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))

from connectors.gdrive_connector import list_files_in_folder, download_file_as_bytes
from utils.file_parser import parse_file
from utils.db_utils import get_engine, add_metadata, load_to_bronze

FOLDER_ID = os.getenv("GDRIVE_FOLDER_ID")
TABLE_NAME = "sales_target_plan"


def run():
    engine = get_engine()
    total_loaded = 0

    try:
        files = list_files_in_folder(FOLDER_ID)

        for f in files:
            filename = f["name"]

            if not (filename.lower().startswith("src02")
                    and filename.lower().endswith(".xlsx")):
                continue

            raw_bytes = download_file_as_bytes(f["id"])

            with pd.ExcelFile(BytesIO(raw_bytes), engine="openpyxl") as excel:
                sheets = excel.sheet_names

            for sheet in sheets:
                batch_id = str(uuid.uuid4())
                start = time.time()

                try:
                    df = parse_file(raw_bytes, filename, sheet_name=sheet)

                    if df.empty:
                        raise ValueError("Sheet không có dữ liệu")

                    df["_source_sheet"] = sheet
                    df = add_metadata(df, filename, "google_drive", batch_id)

                    rows = load_to_bronze(df, TABLE_NAME, if_exists="append")
                    total_loaded += rows

                    status = "SUCCESS"
                    error_message = None

                    print(f"OK: {filename} / {sheet} — {rows} dòng")

                except Exception as e:
                    rows = 0
                    status = "FAILED"
                    error_message = str(e)
                    print(f"LỖI: {filename} / {sheet} — {e}")

                with engine.begin() as conn:
                    conn.execute(text("""
                        INSERT INTO raw.ingest_log
                        (batch_id, source_name, source_file, source_platform,
                         rows_loaded, status, duration_sec, error_message)
                        VALUES
                        (:bid, :sn, :sf, :sp, :rl, :st, :dur, :err)
                    """), {
                        "bid": batch_id,
                        "sn": TABLE_NAME,
                        "sf": f"{filename} / {sheet}",
                        "sp": "google_drive",
                        "rl": rows,
                        "st": status,
                        "dur": round(time.time() - start, 2),
                        "err": error_message
                    })

        print(f"Tổng cộng: {total_loaded} dòng")

    finally:
        engine.dispose()


if __name__ == "__main__":
    run()
