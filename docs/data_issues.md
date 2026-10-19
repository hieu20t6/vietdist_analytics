raw.customer_master:
    Tổng số dòng: 4.000
    Số khách hàng duy nhất: 2.000
    NULL customer_id: 0%
    Duplicate: 2.000
    Kết luận: Toàn bộ 2.000 khách hàng đều xuất hiện hai lần với nội dung nghiệp vụ giống nhau.
    Hướng xử lý tại Silver: Giữ nguyên Bronze, loại bản ghi trùng và giữ lại 2.000 khách hàng duy nhất.

raw.distributor_master:
    Tổng số dòng: 138
    NULL distributor_id: 0%
    Duplicate: 0

raw.distributor_orders:
    Tổng số dòng: 35.945
    NULL key: 0%
    Duplicate: 0
    Nhận xét: Không phát hiện vấn đề theo khóa order_id + product_id.
    Hướng xử lý Silver: Chuẩn hóa kiểu dữ liệu ngày, số lượng, doanh thu và kiểm tra quan hệ với bảng distributor_master

raw.employee_master:
    Tổng số dòng: 114
    NULL key: 0%
    Duplicate: 0
    Hướng xử lý Silver: Giữ lịch sử nhân viên theo employee_id + version, chuẩn hóa ngày hiệu lực và kiểu dữ liệu.

raw.product_master:
    Tổng số dòng: 100
    NULL product_id: 0%
    Duplicate: 0
    Hướng xử lý Silver: Chuẩn hóa giá bán, giá vốn, trọng lượng sang kiểu số và launch_date sang DATE.

raw.promotion_program:
    Tổng số dòng: 40
    NULL promotion_id: 0%
    Duplicate: 0
    Hướng xử lý Silver: Chuẩn hóa ngày bắt đầu/kết thúc, tỷ lệ giảm giá và chi phí sang kiểu dữ liệu phù hợp.

raw.return_transactions:
    Tổng số dòng: 3.665
    NULL return_id: 0%
    Duplicate: 0
    Hướng xử lý Silver: Chuẩn hóa ngày trả hàng, số lượng, số tiền và kiểm tra liên kết với đơn hàng gốc.

raw.sales_target_plan:
    Tổng số dòng: 1.950
    NULL key: 0%
    Duplicate: 0
    Hướng xử lý Silver: Giữ nguyên lịch sử v1, v2; chuẩn hóa ngày hiệu lực và xác định phiên bản kế hoạch áp dụng theo từng tháng.

raw.sales_transactions:
    Tổng số dòng: 119.101
    NULL key: 0%
    Duplicate: 0
    Hướng xử lý Silver: Chuẩn hóa ngày, số lượng, doanh thu và kiểm tra liên kết với bảng khách hàng, nhân viên, sản phẩm.

raw.territory_mapping:
    Tổng số dòng: 1.843
    NULL key: 0%
    Duplicate: 0
    Hướng xử lý Silver: Giữ lịch sử phân công theo phiên bản, chuẩn hóa ngày hiệu lực và kiểm tra quan hệ với nhân viên, khách hàng