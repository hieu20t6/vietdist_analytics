-- Tạo bảng raw.sales_target_versions

CREATE TABLE IF NOT EXISTS raw.sales_target_versions (
    version_id SERIAL PRIMARY KEY,
    version_label TEXT NOT NULL,
    source_file TEXT NOT NULL,
    source_sheet TEXT NOT NULL,
    version_date DATE,
    effective_from DATE,
    effective_to DATE,
    ingested_at TIMESTAMPTZ DEFAULT NOW()
);