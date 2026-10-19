-- Tạo dwh.dim_customers

CREATE OR REPLACE VIEW dwh.dim_customers AS
SELECT
    customer_id,
    customer_name,
    customer_type,
    channel,
    province,
    region,
    address,
    phone,
    tax_code,
    join_date,
    credit_limit,
    status
FROM staging.customer_master;

-- Tạo dwh.dim_employees

CREATE OR REPLACE VIEW dwh.dim_employees AS
SELECT
    employee_id,
    full_name,
    gender,
    date_of_birth,
    join_date,
    position,
    region,
    team,
    email,
    phone,
    status,
    version,
    resign_date,
    transfer_note,
    effective_date AS effective_from,
    NULL::DATE AS effective_to,
    TRUE AS is_current
FROM staging.employee_master;

-- Tạo dwh.dim_distributors

CREATE OR REPLACE VIEW dwh.dim_distributors AS
SELECT
    distributor_id,
    distributor_name,
    tier,
    channel,
    province,
    region,
    contact_person,
    phone,
    email,
    tax_code,
    join_date,
    credit_limit,
    status,
    assigned_supervisor_id,

    join_date AS effective_from,
    NULL::DATE AS effective_to,
    TRUE AS is_current

FROM staging.distributor_master;

-- Tạo dwh.dim_products

CREATE OR REPLACE VIEW dwh.dim_products AS
SELECT
    product_id,
    product_name,
    category,
    sub_category,
    unit,
    unit_price,
    cost_price,
    weight_gram,
    status,
    launch_date
FROM staging.product_master;
