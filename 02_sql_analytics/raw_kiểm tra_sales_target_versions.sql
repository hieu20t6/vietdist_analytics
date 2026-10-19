-- Kiểm tra sales_target_versions thấy v1, v2

SELECT DISTINCT version_label 
FROM raw.sales_target_versions stv 

-- Kiểm tra cột month từ T1-T12 và khôgn có cột Tổng

SELECT DISTINCT 
	plan_version,
	month
FROM raw.sales_target_plan stp 
order by plan_version, month

