--1.Kiểm tra tổng số dòng, % null của các cột key, số duplicate của bảng raw.customer_master

SELECT
    COUNT(*) AS total_rows,
    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE customer_id IS NULL
               OR TRIM(customer_id) = ''
        ) / NULLIF(COUNT(*), 0),
        2
    ) AS null_key_pct,

    COUNT(*) - COUNT(DISTINCT NULLIF(TRIM(customer_id), ''))
        - COUNT(*) FILTER (
            WHERE customer_id IS NULL
               OR TRIM(customer_id) = ''
        ) AS duplicate_count
FROM raw.customer_master;

--2.Kiểm tra tổng số dòng, % null của các cột key, số duplicate của bảng raw.distributor_master
SELECT
    COUNT(*) AS total_rows,
    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE distributor_id IS NULL
               OR TRIM(distributor_id) = ''
        ) / NULLIF(COUNT(*), 0),
        2
    ) AS null_key_pct,

    COUNT(*) - COUNT(DISTINCT NULLIF(TRIM(distributor_id), ''))
        - COUNT(*) FILTER (
            WHERE distributor_id IS NULL
               OR TRIM(distributor_id) = ''
        ) AS duplicate_count
FROM raw.distributor_master;

--3.Kiểm tra tổng số dòng, % null của các cột key, số duplicate của bảng raw.employee_master
SELECT
    COUNT(*) AS total_rows,
    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE employee_id IS NULL
               OR TRIM(employee_id) = ''
        ) / NULLIF(COUNT(*), 0),
        2
    ) AS null_key_pct,

    COUNT(*) - COUNT(DISTINCT NULLIF(TRIM(employee_id), ''))
        - COUNT(*) FILTER (
            WHERE employee_id IS NULL
               OR TRIM(employee_id) = ''
        ) AS duplicate_count
FROM raw.employee_master;

--4.Kiểm tra tổng số dòng, % null của các cột key, số duplicate của bảng raw.product_master
SELECT
    COUNT(*) AS total_rows,
    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE product_id IS NULL
               OR TRIM(product_id) = ''
        ) / NULLIF(COUNT(*), 0),
        2
    ) AS null_key_pct,

    COUNT(*) - COUNT(DISTINCT NULLIF(TRIM(product_id), ''))
        - COUNT(*) FILTER (
            WHERE product_id IS NULL
               OR TRIM(product_id) = ''
        ) AS duplicate_count
FROM raw.product_master

--5.Kiểm tra tổng số dòng, % null của các cột key, số duplicate của bảng raw.promotion_program
SELECT
    COUNT(*) AS total_rows,
    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE promotion_id IS NULL
               OR TRIM(promotion_id) = ''
        ) / NULLIF(COUNT(*), 0),
        2
    ) AS null_key_pct,

    COUNT(*) - COUNT(DISTINCT NULLIF(TRIM(promotion_id), ''))
        - COUNT(*) FILTER (
            WHERE promotion_id IS NULL
               OR TRIM(promotion_id) = ''
        ) AS duplicate_count
FROM raw.promotion_program;

--6.Kiểm tra tổng số dòng, % null của các cột key, số duplicate của bảng raw.return_transactions
SELECT
    COUNT(*) AS total_rows,
    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE return_id IS NULL
               OR TRIM(return_id) = ''
        ) / NULLIF(COUNT(*), 0),
        2
    ) AS null_key_pct,

    COUNT(*) - COUNT(DISTINCT NULLIF(TRIM(return_id), ''))
        - COUNT(*) FILTER (
            WHERE return_id IS NULL
               OR TRIM(return_id) = ''
        ) AS duplicate_count
FROM raw.return_transactions;

--7.Kiểm tra tổng số dòng, % null của các cột key, số duplicate của bảng raw.sales_target_plan
WITH profile AS (
    SELECT
        plan_version,
        employee_id,
        year,
        month,
        COUNT(*) AS occurrences,
        COUNT(DISTINCT ROW(
            target_revenue,
            target_quantity,
            target_new_customers,
            effective_from,
            effective_to
        )) AS distinct_records
    FROM raw.sales_target_plan
    WHERE NULLIF(TRIM(plan_version), '') IS NOT NULL
      AND NULLIF(TRIM(employee_id), '') IS NOT NULL
      AND year IS NOT NULL
      AND month IS NOT NULL
    GROUP BY plan_version, employee_id, year, month
)
SELECT
    (SELECT COUNT(*)
     FROM raw.sales_target_plan) AS total_rows,

    (SELECT ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE NULLIF(TRIM(plan_version), '') IS NULL
               OR NULLIF(TRIM(employee_id), '') IS NULL
               OR year IS NULL
               OR month IS NULL
        ) / NULLIF(COUNT(*), 0), 2)
     FROM raw.sales_target_plan) AS null_key_pct,

    COALESCE(SUM(occurrences - 1), 0) AS duplicate_rows,

    COUNT(*) FILTER (
        WHERE distinct_records > 1
    ) AS conflicting_targets
FROM profile;


--8.Kiểm tra tổng số dòng, % null của các cột key, số duplicate của bảng raw.distributor_orders
WITH profile AS (
    SELECT
        order_id,
        product_id,
        COUNT(*) AS occurrences,
        COUNT(DISTINCT (
            qty_ordered,
            qty_delivered,
            gross_amount,
            delivered_amount,
            delivery_status
        )) AS distinct_records
    FROM raw.distributor_orders
    WHERE NULLIF(TRIM(order_id), '') IS NOT NULL
      AND NULLIF(TRIM(product_id), '') IS NOT NULL
    GROUP BY order_id, product_id
)
SELECT
    (SELECT COUNT(*)
     FROM raw.distributor_orders) AS total_rows,
    (SELECT ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE NULLIF(TRIM(order_id), '') IS NULL
               OR NULLIF(TRIM(product_id), '') IS NULL
        ) / NULLIF(COUNT(*), 0), 2
     )
     FROM raw.distributor_orders) AS null_key_pct,
    COALESCE(SUM(occurrences - 1), 0) AS duplicate_rows,
    COUNT(*) FILTER (
        WHERE distinct_records > 1
    ) AS conflicting_orders
FROM profile;

--9.Kiểm tra tổng số dòng, % null của các cột key, số duplicate của bảng raw.sales_transactions
WITH profile AS (
    SELECT
        order_id,
        product_id,
        COUNT(*) AS occurrences,
        COUNT(DISTINCT ROW(
            order_date,
            customer_id,
            employee_id,
            quantity,
            unit_price,
            discount_pct,
            net_amount,
            payment_status
        )) AS distinct_records
    FROM raw.sales_transactions
    WHERE NULLIF(TRIM(order_id), '') IS NOT NULL
      AND NULLIF(TRIM(product_id), '') IS NOT NULL
    GROUP BY order_id, product_id
)
SELECT
    (SELECT COUNT(*)
     FROM raw.sales_transactions) AS total_rows,

    (SELECT ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE NULLIF(TRIM(order_id), '') IS NULL
               OR NULLIF(TRIM(product_id), '') IS NULL
        ) / NULLIF(COUNT(*), 0), 2)
     FROM raw.sales_transactions) AS null_key_pct,

    COALESCE(SUM(occurrences - 1), 0) AS duplicate_rows,

    COUNT(*) FILTER (
        WHERE distinct_records > 1
    ) AS conflicting_transactions
FROM profile;

--10.Kiểm tra tổng số dòng, % null của các cột key, số duplicate của bảng raw.territory_mapping
WITH profile AS (
    SELECT
        territory_id,
        version,
        COUNT(*) AS occurrences,
        COUNT(DISTINCT ROW(
            employee_id,
            customer_id,
            region,
            team,
            effective_date,
            expiry_date
        )) AS distinct_records
    FROM raw.territory_mapping
    WHERE NULLIF(TRIM(territory_id), '') IS NOT NULL
      AND NULLIF(TRIM(version), '') IS NOT NULL
    GROUP BY territory_id, version
)
SELECT
    (SELECT COUNT(*)
     FROM raw.territory_mapping) AS total_rows,

    (SELECT ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE NULLIF(TRIM(territory_id), '') IS NULL
               OR NULLIF(TRIM(version), '') IS NULL
        ) / NULLIF(COUNT(*), 0), 2)
     FROM raw.territory_mapping) AS null_key_pct,

    COALESCE(SUM(occurrences - 1), 0) AS duplicate_rows,

    COUNT(*) FILTER (
        WHERE distinct_records > 1
    ) AS conflicting_territories
FROM profile;


