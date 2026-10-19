-- Kiểm tra bảng raw.sales_transactions tồn tại trong PostgreSQL với đúng số dòng

select count(*) as total_raw
from raw.sales_transactions

-- Kiểm tra bảng raw.ingest_log có ít nhất 1 dòng SUCCESS sau khi chạy và 
-- Cột _source_file hiển thị đúng tên file gốc  

select * 
from raw.ingest_log
where source_file = 'SRC01_sales_transactions.csv'

-- Kết quả sau khi chạy loader 2 lần liên tiếp với cùng file 'SRC03_customer_master.csv'

select 
	_ingested_at,
	count(*) as total_raw 
from raw.customer_master
group by _ingested_at 
order by _ingested_at

-- Kiểm tra tất cả 10 bảng raw.* tồn tại và có data 

select
    source_name,
    status,
    count(*) AS total_batches,
    sum(rows_loaded) AS total_rows_loaded
from raw.ingest_log
where status = 'SUCCESS'
GROUP BY source_name, status
ORDER BY source_name, status;

