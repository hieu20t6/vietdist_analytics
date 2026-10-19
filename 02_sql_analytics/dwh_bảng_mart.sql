-- Tạo dwh.mart_sales_vs_target

CREATE OR REPLACE VIEW dwh.mart_sales_vs_target AS
WITH monthly_sales AS (
    SELECT
        employee_key,
        EXTRACT(YEAR FROM order_date)::INT AS year,
        EXTRACT(MONTH FROM order_date)::INT AS month,
        SUM(net_amount) AS actual_sales,
        SUM(quantity) AS actual_quantity,
        COUNT(DISTINCT order_id) AS total_orders
    FROM dwh.fact_sales
    GROUP BY
        employee_key,
        EXTRACT(YEAR FROM order_date),
        EXTRACT(MONTH FROM order_date)
)
SELECT
-- Khóa Dimension
    t.employee_key,
    t.employee_id,
    t.date_key,
-- Kỳ báo cáo
    t.year,
    t.month,
-- Doanh thu
    COALESCE(s.actual_sales, 0) AS actual_sales,
    t.target_revenue AS target_sales,
-- Chênh lệch doanh thu
    COALESCE(s.actual_sales, 0)
        - t.target_revenue AS variance,
-- Tỷ lệ hoàn thành mục tiêu (%)
    ROUND(
        COALESCE(s.actual_sales, 0)
        / NULLIF(t.target_revenue, 0) * 100,
        2
    ) AS achievement_pct,
-- Số lượng
    COALESCE(s.actual_quantity, 0) AS actual_quantity,
    t.target_quantity,
-- Số đơn hàng
    COALESCE(s.total_orders, 0) AS total_orders,
-- Mục tiêu khách hàng mới
    t.target_new_customers
FROM dwh.fact_targets t
LEFT JOIN monthly_sales s
    ON t.employee_key = s.employee_key
    AND t.year = s.year
    AND t.month = s.month;



-- Tạo dwh.mart_distributor_performance

CREATE OR REPLACE VIEW dwh.mart_distributor_performance AS
SELECT
 -- Nhà phân phối
    o.distributor_id,
 -- Thời gian
    EXTRACT(YEAR FROM o.order_date)::INT AS year,
    EXTRACT(MONTH FROM o.order_date)::INT AS month,
 -- Đơn hàng
    COUNT(DISTINCT o.order_id) AS total_orders,
 -- Giá trị đặt hàng
    SUM(o.gross_amount) AS ordered_amount,
 -- Giá trị đã giao theo nguồn
    SUM(o.delivered_amount) AS delivered_amount,
 -- Giá trị đã giao của dòng bị hủy
    SUM(o.delivered_amount) FILTER (
        WHERE o.delivery_status = 'Cancelled'
    ) AS cancelled_delivered_amount,
 -- Số lượng
    SUM(o.qty_ordered) AS total_qty_ordered,
    SUM(o.qty_delivered) AS total_qty_delivered,
 -- Tỷ lệ giao theo số lượng
    ROUND(
        SUM(o.qty_delivered)::NUMERIC
        / NULLIF(SUM(o.qty_ordered), 0) * 100,
        2
    ) AS quantity_fill_rate_pct,
 -- Tỷ lệ dòng giao đúng hạn
    ROUND(
        COUNT(*) FILTER (
            WHERE o.ontime_delivery = 'Yes'
              AND o.delivery_status IN ('Delivered', 'Partial')
        )::NUMERIC
        / NULLIF(
            COUNT(*) FILTER (
                WHERE o.delivery_status IN ('Delivered', 'Partial')
            ), 0
        ) * 100,
        2
    ) AS ontime_line_rate_pct,
 -- Số dòng theo trạng thái
    COUNT(*) FILTER (
        WHERE o.delivery_status = 'Delivered'
    ) AS delivered_lines,
    COUNT(*) FILTER (
        WHERE o.delivery_status = 'Partial'
    ) AS partial_lines,
    COUNT(*) FILTER (
        WHERE o.delivery_status = 'Cancelled'
    ) AS cancelled_lines
FROM staging.distributor_orders o
GROUP BY
    o.distributor_id,
    EXTRACT(YEAR FROM o.order_date),
    EXTRACT(MONTH FROM o.order_date)
    