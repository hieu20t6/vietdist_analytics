import os
from pathlib import Path

from dotenv import load_dotenv
from sqlalchemy import create_engine
from sqlalchemy.engine import URL

from sqlalchemy import text

from datetime import datetime, timezone
import pandas as pd

# Xác định đường dẫn tới .env ở thư mục gốc
BASE_DIR = Path(__file__).resolve().parents[2]
load_dotenv(BASE_DIR / ".env")


def get_engine():
    url = URL.create(
        drivername="postgresql+psycopg2",
        username=os.getenv("DB_USER"),
        password=os.getenv("DB_PASSWORD"),
        host=os.getenv("DB_HOST", "localhost"),
        port=int(os.getenv("DB_PORT", "5432")),
        database=os.getenv("DB_NAME", "vietdist_dw"),
    )

    engine = create_engine(url)

    return engine

def create_ingest_log_table():
    engine = get_engine()

    sql = """
    CREATE TABLE IF NOT EXISTS raw.ingest_log (
        log_id BIGSERIAL PRIMARY KEY,
        batch_id VARCHAR(100) NOT NULL,
        source_file TEXT NOT NULL,
        source_platform VARCHAR(50) NOT NULL,
        row_count INTEGER DEFAULT 0,
        status VARCHAR(20) NOT NULL,
        ingested_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
        error_message TEXT
    );
    """

    with engine.begin() as conn:
        conn.execute(text(sql))

    engine.dispose()

    print("Đã tạo bảng raw.ingest_log!")

def add_metadata(df: pd.DataFrame, source_file: str, source_platform: str, batch_id: str) -> pd.DataFrame:

    df = df.copy()

    df["_source_file"] = source_file
    df["_source_platform"] = source_platform
    df["_ingested_at"] = datetime.now(timezone.utc)
    df["_batch_id"] = batch_id

    return df

def load_to_bronze(df: pd.DataFrame, table_name: str,if_exists: str = "append") -> int:
    # 1. Kiểm tra dữ liệu
    if df.empty:
        raise ValueError("DataFrame không có dữ liệu")

    if not table_name.isidentifier():
        raise ValueError("Tên bảng không hợp lệ")

    if if_exists != "append":
        raise ValueError("Bronze Layer chỉ cho phép append")

    # 2. Kết nối PostgreSQL
    engine = get_engine()

    try:
        # 3. Nạp dữ liệu vào schema raw
        with engine.begin() as conn:
            df.to_sql(
                name=table_name,
                con=conn,
                schema="raw",
                if_exists=if_exists,
                index=False
            )

        # 4. Trả số dòng đã nạp
        return len(df)

    finally:
        engine.dispose()


