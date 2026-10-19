--Kiểm tra logic staging.sales_targets_versioned

SELECT
    plan_version,
    is_latest,
    COUNT(*) AS total_rows
FROM staging.sales_targets_versioned
GROUP BY plan_version, is_latest
ORDER BY plan_version, is_latest;