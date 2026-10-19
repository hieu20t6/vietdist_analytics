-- Tạo bảng raw.ingest_log

CREATE TABLE IF NOT EXISTS raw.ingest_log (
    log_id BIGSERIAL PRIMARY KEY,
    batch_id UUID NOT NULL,
    source_name TEXT NOT NULL,
    source_file TEXT NOT NULL,
    source_platform TEXT NOT NULL,
    rows_loaded INTEGER DEFAULT 0,
    status TEXT NOT NULL,
    duration_sec NUMERIC(12, 2),
    error_message TEXT,
    ingested_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_ingest_status
    CHECK (status IN ('SUCCESS', 'FAILED'))
);
