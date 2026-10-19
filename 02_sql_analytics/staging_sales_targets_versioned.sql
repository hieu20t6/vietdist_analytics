CREATE TABLE staging.sales_targets_versioned AS
SELECT
    plan_version,
    version_date,
    effective_from,
    effective_to,
    employee_id,
    employee_name,
    region,
    team,
    year,
    month,
    target_revenue,
    target_quantity,
    target_new_customers,
    CASE
        WHEN ROW_NUMBER() OVER (
            PARTITION BY employee_id, year, month
            ORDER BY
                version_date DESC,
                plan_version DESC
        ) = 1
        THEN TRUE
        ELSE FALSE
    END AS is_latest
FROM staging.sales_target_plan;
