-- Chuẩn hóa kiểu dữ liệu staging.customer_master

ALTER TABLE staging.customer_master
ALTER COLUMN join_date TYPE DATE
USING NULLIF(TRIM(join_date), '')::DATE
ALTER COLUMN credit_limit TYPE NUMERIC(18,2)
USING NULLIF(TRIM(credit_limit), '')::NUMERIC(18,2)

-- Chuẩn hóa kiểu dữ liệu staging.product_master

ALTER TABLE staging.product_master
ALTER COLUMN unit_price TYPE NUMERIC(18,2)
USING NULLIF(TRIM(unit_price), '')::NUMERIC(18,2),
ALTER COLUMN cost_price TYPE NUMERIC(18,2)
USING NULLIF(TRIM(cost_price), '')::NUMERIC(18,2),
ALTER COLUMN weight_gram TYPE NUMERIC(18,2)
USING NULLIF(TRIM(weight_gram), '')::NUMERIC(18,2),
ALTER COLUMN launch_date TYPE DATE
USING NULLIF(TRIM(launch_date), '')::DATE

-- Chuẩn hóa kiểu dữ liệu staging.distributor_master

ALTER TABLE staging.distributor_master
ALTER COLUMN join_date TYPE DATE
USING NULLIF(TRIM(join_date), '')::DATE
ALTER COLUMN credit_limit TYPE NUMERIC(18,2)
USING NULLIF(TRIM(credit_limit), '')::NUMERIC(18,2)

-- Chuẩn hóa kiểu dữ liệu staging.employee_master

ALTER TABLE staging.employee_master
ALTER COLUMN date_of_birth TYPE DATE
USING NULLIF(TRIM(date_of_birth), '')::DATE,
ALTER COLUMN join_date TYPE DATE
USING NULLIF(TRIM(join_date), '')::DATE,
ALTER COLUMN effective_date TYPE DATE
USING NULLIF(TRIM(effective_date), '')::DATE,
ALTER COLUMN resign_date TYPE DATE
USING NULLIF(TRIM(resign_date), '')::DATE;

-- Chuẩn hóa kiểu dữ liệu staging.promotion_program

ALTER TABLE staging.promotion_program
ALTER COLUMN start_date TYPE DATE
USING NULLIF(TRIM(start_date), '')::DATE,
ALTER COLUMN end_date TYPE DATE
USING NULLIF(TRIM(end_date), '')::DATE,
ALTER COLUMN discount_pct TYPE NUMERIC(10,2)
USING NULLIF(TRIM(discount_pct), '')::NUMERIC(10,2),
ALTER COLUMN min_order_quantity TYPE INTEGER
USING NULLIF(TRIM(min_order_quantity), '')::INTEGER,
ALTER COLUMN budget_vnd TYPE NUMERIC(18,2)
USING NULLIF(TRIM(budget_vnd), '')::NUMERIC(18,2),
ALTER COLUMN actual_cost_vnd TYPE NUMERIC(18,2)
USING NULLIF(TRIM(actual_cost_vnd), '')::NUMERIC(18,2)

-- Chuẩn hóa kiểu dữ liệu staging.return_transactions

ALTER TABLE staging.return_transactions
ALTER COLUMN return_date TYPE DATE
USING NULLIF(TRIM(return_date), '')::DATE,
ALTER COLUMN return_quantity TYPE INTEGER
USING NULLIF(TRIM(return_quantity), '')::INTEGER,
ALTER COLUMN unit_price TYPE NUMERIC(18,2)
USING NULLIF(TRIM(unit_price), '')::NUMERIC(18,2),
ALTER COLUMN return_amount TYPE NUMERIC(18,2)
USING NULLIF(TRIM(return_amount), '')::NUMERIC(18,2)

-- Chuẩn hóa kiểu dữ liệu staging.distributor_orders

ALTER TABLE staging.distributor_orders
ALTER COLUMN order_date TYPE DATE
USING NULLIF(TRIM(order_date), '')::DATE,
ALTER COLUMN expected_delivery_date TYPE DATE
USING NULLIF(TRIM(expected_delivery_date), '')::DATE,
ALTER COLUMN actual_delivery_date TYPE DATE
USING NULLIF(TRIM(actual_delivery_date), '')::DATE,
ALTER COLUMN qty_ordered TYPE INTEGER
USING NULLIF(TRIM(qty_ordered), '')::INTEGER,
ALTER COLUMN qty_delivered TYPE INTEGER
USING NULLIF(TRIM(qty_delivered), '')::INTEGER,
ALTER COLUMN fill_rate_pct TYPE NUMERIC(10,2)
USING NULLIF(TRIM(fill_rate_pct), '')::NUMERIC(10,2),
ALTER COLUMN unit_price_list TYPE NUMERIC(18,2)
USING NULLIF(TRIM(unit_price_list), '')::NUMERIC(18,2),
ALTER COLUMN distributor_price TYPE NUMERIC(18,2)
USING NULLIF(TRIM(distributor_price), '')::NUMERIC(18,2),
ALTER COLUMN gross_amount TYPE NUMERIC(18,2)
USING NULLIF(TRIM(gross_amount), '')::NUMERIC(18,2),
ALTER COLUMN delivered_amount TYPE NUMERIC(18,2)
USING NULLIF(TRIM(delivered_amount), '')::NUMERIC(18,2);
-- Chuẩn hóa kiểu dữ liệu staging.sales_transactions

ALTER TABLE staging.sales_transactions
ALTER COLUMN order_date TYPE DATE
USING NULLIF(TRIM(order_date), '')::DATE,
ALTER COLUMN order_month TYPE INTEGER
USING NULLIF(TRIM(order_month), '')::INTEGER,
ALTER COLUMN order_quarter TYPE INTEGER
USING NULLIF(TRIM(order_quarter), '')::INTEGER,
ALTER COLUMN order_year TYPE INTEGER
USING NULLIF(TRIM(order_year), '')::INTEGER,
ALTER COLUMN quantity TYPE INTEGER
USING NULLIF(TRIM(quantity), '')::INTEGER,
ALTER COLUMN unit_price TYPE NUMERIC(18,2)
USING NULLIF(TRIM(unit_price), '')::NUMERIC(18,2),
ALTER COLUMN discount_pct TYPE NUMERIC(10,2)
USING NULLIF(TRIM(discount_pct), '')::NUMERIC(10,2),
ALTER COLUMN discount_amount TYPE NUMERIC(18,2)
USING NULLIF(TRIM(discount_amount), '')::NUMERIC(18,2),
ALTER COLUMN gross_amount TYPE NUMERIC(18,2)
USING NULLIF(TRIM(gross_amount), '')::NUMERIC(18,2),
ALTER COLUMN net_amount TYPE NUMERIC(18,2)
USING NULLIF(TRIM(net_amount), '')::NUMERIC(18,2)

-- Chuẩn hóa kiểu dữ liệu staging.sales_target_plan

ALTER TABLE staging.sales_target_plan
ALTER COLUMN version_date TYPE DATE
USING NULLIF(TRIM(version_date), '')::DATE,
ALTER COLUMN effective_from TYPE DATE
USING NULLIF(TRIM(effective_from), '')::DATE,
ALTER COLUMN effective_to TYPE DATE
USING NULLIF(TRIM(effective_to), '')::DATE,
ALTER COLUMN year TYPE INTEGER
USING year::INTEGER,
ALTER COLUMN month TYPE INTEGER
USING month::INTEGER,
ALTER COLUMN target_revenue TYPE NUMERIC(18,2)
USING target_revenue::NUMERIC(18,2)

-- Chuẩn hóa kiểu dữ liệu staging.territory_mapping

ALTER TABLE staging.territory_mapping
ALTER COLUMN effective_date TYPE DATE
USING NULLIF(TRIM(effective_date), '')::DATE,
ALTER COLUMN expiry_date TYPE DATE
USING NULLIF(TRIM(expiry_date), '')::DATE
