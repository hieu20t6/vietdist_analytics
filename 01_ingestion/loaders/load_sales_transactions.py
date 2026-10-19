import os
import sys
import uuid
import time
from pathlib import Path

from sqlalchemy import text

# Cho phép import từ thư mục 01_ingestion
INGESTION_DIR = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(INGESTION_DIR))

from connectors.gdrive_connector import (
    list_files_in_folder,
    download_file_as_bytes
)
from utils.file_parser import parse_file
from utils.db_utils import (
    add_metadata,
    load_to_bronze,
    get_engine
)


FOLDER_ID = os.getenv("GDRIVE_FOLDER_ID")
TABLE_NAME = "sales_transactions"


def run():
    # 1. Tạo mã batch và bắt đầu tính thời gian
    batch_id = str(uuid.uuid4())
    start = time.time()

    # 2. Kết nối PostgreSQL
    engine = get_engine()

    try:
        # 3. Lấy danh sách file từ Google Drive
        files = list_files_in_folder(FOLDER_ID)
        print(f"Tìm thấy {len(files)} file(s) trong folder")

        total_loaded = 0

        # 4. Duyệt từng file
        for f in files:
            filename = f["name"]

            # Chỉ xử lý CSV thuộc SRC-01
            if not (
                filename.lower().endswith(".csv")
                and "sales_transactions" in filename.lower()
            ):
                continue

            file_start = time.time()

            try:
                # 5. Tải file từ Google Drive
                raw_bytes = download_file_as_bytes(f["id"])

                # 6. Đọc CSV thành DataFrame
                df = parse_file(raw_bytes, filename)

                # 7. Thêm metadata
                df = add_metadata(
                    df,
                    filename,
                    "google_drive",
                    batch_id
                )

                # 8. Nạp vào PostgreSQL Bronze
                rows = load_to_bronze(
                    df,
                    TABLE_NAME,
                    if_exists="append"
                )

                total_loaded += rows

                print(f"OK: {filename} — {rows} dòng")

                # 9. Ghi log thành công
                with engine.begin() as conn:
                    conn.execute(
                        text("""
                            INSERT INTO raw.ingest_log (
                                batch_id,
                                source_name,
                                source_file,
                                source_platform,
                                rows_loaded,
                                status,
                                duration_sec
                            )
                            VALUES (
                                :bid, :sn, :sf, :sp,
                                :rl, :st, :dur
                            )
                        """),
                        {
                            "bid": batch_id,
                            "sn": TABLE_NAME,
                            "sf": filename,
                            "sp": "google_drive",
                            "rl": rows,
                            "st": "SUCCESS",
                            "dur": round(time.time() - file_start, 2)
                        }
                    )

            except Exception as e:
                print(f"LỖI: {filename} — {e}")

                # 10. Ghi log thất bại
                with engine.begin() as conn:
                    conn.execute(
                        text("""
                            INSERT INTO raw.ingest_log (
                                batch_id,
                                source_name,
                                source_file,
                                source_platform,
                                rows_loaded,
                                status,
                                duration_sec,
                                error_message
                            )
                            VALUES (
                                :bid, :sn, :sf, :sp,
                                :rl, :st, :dur, :err
                            )
                        """),
                        {
                            "bid": batch_id,
                            "sn": TABLE_NAME,
                            "sf": filename,
                            "sp": "google_drive",
                            "rl": 0,
                            "st": "FAILED",
                            "dur": round(time.time() - file_start, 2),
                            "err": str(e)
                        }
                    )

        print(f"Tổng cộng: {total_loaded} dòng đã load")

    finally:
        engine.dispose()


if __name__ == "__main__":
    run()
