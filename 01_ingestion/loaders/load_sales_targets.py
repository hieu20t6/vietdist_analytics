
import sys
from pathlib import Path
from sqlalchemy import text

sys.path.insert(
    0,
    str(Path(__file__).resolve().parents[1])
)

from utils.db_utils import get_engine


def save_target_versions():
    engine = get_engine()

    try:
        with engine.begin() as conn:
            conn.execute(text("""
                INSERT INTO raw.sales_target_versions (
                    version_label,
                    source_file,
                    source_sheet,
                    version_date,
                    effective_from,
                    effective_to
                )
                SELECT DISTINCT
                    plan_version,
                    _source_file,
                    _source_sheet,
                    NULLIF(version_date, '')::DATE,
                    NULLIF(effective_from, '')::DATE,
                    NULLIF(effective_to, '')::DATE
                FROM raw.sales_target_plan
                WHERE plan_version IN ('v1', 'v2')
                  AND NOT EXISTS (
                      SELECT 1
                      FROM raw.sales_target_versions v
                      WHERE v.version_label =
                            raw.sales_target_plan.plan_version
                        AND v.source_file =
                            raw.sales_target_plan._source_file
                        AND v.source_sheet =
                            raw.sales_target_plan._source_sheet
                  )
            """))

        print("PASS: Đã lưu thông tin phiên bản!")

    finally:
        engine.dispose()


if __name__ == "__main__":
    save_target_versions()
