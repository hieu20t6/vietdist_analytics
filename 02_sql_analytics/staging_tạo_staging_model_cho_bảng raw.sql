-- Tạo bảng staging.return_transactions

CREATE TABLE IF NOT EXISTS staging.return_transactions AS
SELECT *
FROM raw.return_transactions

-- Tạo bảng staging.customer_master

CREATE TABLE IF NOT EXISTS staging.customer_master AS
SELECT DISTINCT ON (customer_id)
    *
FROM raw.customer_master

-- Tạo bảng staging.distributor_master

CREATE TABLE IF NOT EXISTS staging.distributor_master AS
SELECT *
FROM raw.distributor_master

--Tạo bảng staging.product_master

CREATE TABLE IF NOT EXISTS staging.product_master AS
SELECT *
FROM raw.product_master

-- Tạo bảng staging.employee_master

CREATE TABLE IF NOT EXISTS staging.employee_master AS
SELECT *
FROM raw.employee_master

-- Tạo bảng staging.promotion_program

CREATE TABLE IF NOT EXISTS staging.promotion_program AS
SELECT *
FROM raw.promotion_program

-- Tạo bảng staging.distributor_orders

CREATE TABLE IF NOT EXISTS staging.distributor_orders AS
SELECT *
FROM raw.distributor_orders

-- Tạo bảng staging.sales_transactions

CREATE TABLE IF NOT EXISTS staging.sales_transactions AS
SELECT *
FROM raw.sales_transactions

-- Tạo bảng staging.sales_target_plan

CREATE TABLE IF NOT EXISTS staging.sales_target_plan AS
SELECT *
FROM raw.sales_target_plan

--Tạo bảng staging.territory_mapping

CREATE TABLE IF NOT EXISTS staging.territory_mapping AS
SELECT * 
FROM raw.territory_mapping
