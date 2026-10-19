-- Tạo dwh.fact_sales

CREATE OR REPLACE VIEW dwh.fact_sales AS
SELECT
 -- Khóa giao dịch
    s.order_id,
    s.product_id,
 -- Khóa liên kết Dimension
    d.date_key,
    s.customer_id,
    e.employee_key,
 -- Thông tin giao dịch
    s.order_date,
    s.region,
    s.province,
    s.channel,
    s.product_category,
 -- Chỉ số bán hàng
    s.quantity,
    s.unit_price,
    s.discount_pct,
    s.discount_amount,
    s.gross_amount,
    s.net_amount,
-- Trạng thái
    s.delivery_status,
    s.payment_method,
    s.payment_status
FROM staging.sales_transactions s
LEFT JOIN dwh.dim_date d
    ON s.order_date = d.full_date
LEFT JOIN dwh.dim_employees e
    ON s.employee_id = e.employee_id
    AND s.order_date BETWEEN e.effective_from
                         AND COALESCE(
                             e.effective_to,
                             '9999-12-31'::DATE
                         )

-- Tạo dwh.fact_targets

CREATE OR REPLACE VIEW dwh.fact_targets AS
SELECT
 -- Khóa liên kết Dimension
    d.date_key,
    e.employee_key,
    -- Khóa nghiệp vụ
    t.employee_id,
 -- Kỳ kế hoạch
    t.year,
    t.month,
 -- Thông tin phiên bản
    t.plan_version,
    t.version_date,
 -- Các chỉ tiêu kế hoạch
    t.target_revenue,
    t.target_quantity,
    t.target_new_customers
FROM staging.sales_targets_versioned t
LEFT JOIN dwh.dim_date d
    ON d.full_date = MAKE_DATE(t.year, t.month, 1)
LEFT JOIN dwh.dim_employees e
    ON t.employee_id = e.employee_id
    AND MAKE_DATE(t.year, t.month, 1)
        BETWEEN e.effective_from
        AND COALESCE(
            e.effective_to,
            '9999-12-31'::DATE
        )
WHERE t.is_latest = TRUE;

-- Tạo dwh.fact_returns
CREATE OR REPLACE VIEW dwh.fact_returns AS 
SELECT
-- Khóa giao dịch hoàn trả
    r.return_id,
    r.original_order_id,
-- Khóa liên kết Dimension
    d.date_key,
    r.customer_id,
    r.product_id,
    e.employee_key,
-- Thông tin giao dịch
    r.return_date,
    r.region,
    r.province,
-- Chỉ số hoàn trả
    r.return_quantity,
    r.unit_price,
    r.return_amount,
-- Phân loại hoàn trả
    r.return_reason,
    r.status AS return_status
FROM staging.return_transactions r
LEFT JOIN dwh.dim_date d
    ON r.return_date = d.full_date
LEFT JOIN dwh.dim_employees e
    ON r.employee_id = e.employee_id
    AND r.return_date BETWEEN e.effective_from
                          AND COALESCE(
                              e.effective_to,
                              '9999-12-31'::DATE
                          )
