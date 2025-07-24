# Test Plan cho ProductDetailServlet

## Mục tiêu
Kiểm tra xem các thay đổi trong ProductDetailServlet có hoạt động đúng không, đặc biệt là:
1. Phân quyền truy cập giữa customer và admin
2. Kiểm tra trạng thái sản phẩm (isDeleted, status)
3. Hiển thị thông báo phù hợp

## Test Cases

### Test Case 1: Customer truy cập sản phẩm bình thường
**Mô tả:** Customer truy cập sản phẩm có `isDeleted = false` và `status = "active"`
**URL:** `/product-detail?id=1`
**Kết quả mong đợi:**
- Hiển thị trang chi tiết sản phẩm bình thường
- Có thể thêm vào giỏ hàng
- Có thể thêm vào wishlist
- Có thể review (nếu đã mua hàng)
- Hiển thị related products

### Test Case 2: Customer truy cập sản phẩm đã bị xóa
**Mô tả:** Customer truy cập sản phẩm có `isDeleted = true`
**URL:** `/product-detail?id=2` (với product có isDeleted = true)
**Kết quả mong đợi:**
- Redirect về trang home
- Không hiển thị trang chi tiết sản phẩm

### Test Case 3: Customer truy cập sản phẩm có status khác "active"
**Mô tả:** Customer truy cập sản phẩm có `status = "inactive"`
**URL:** `/product-detail?id=3` (với product có status = "inactive")
**Kết quả mong đợi:**
- Redirect về trang home
- Không hiển thị trang chi tiết sản phẩm

### Test Case 4: Admin truy cập sản phẩm bình thường
**Mô tả:** Admin truy cập sản phẩm có `isDeleted = false` và `status = "active"`
**URL:** `/product-detail?id=1`
**Kết quả mong đợi:**
- Hiển thị trang chi tiết sản phẩm bình thường
- Không có thông báo cảnh báo
- Có thể thêm vào giỏ hàng và wishlist
- Không thể review (vì là admin)

### Test Case 5: Admin truy cập sản phẩm đã bị xóa
**Mô tả:** Admin truy cập sản phẩm có `isDeleted = true`
**URL:** `/product-detail?id=2` (với product có isDeleted = true)
**Kết quả mong đợi:**
- Hiển thị trang chi tiết sản phẩm
- Có thông báo cảnh báo: "Sản phẩm này đã bị xóa và chỉ admin mới có thể xem."
- Có thể thêm vào giỏ hàng và wishlist (để test)
- Không thể review (vì là admin)

### Test Case 6: Admin truy cập sản phẩm có status khác "active"
**Mô tả:** Admin truy cập sản phẩm có `status = "inactive"`
**URL:** `/product-detail?id=3` (với product có status = "inactive")
**Kết quả mong đợi:**
- Hiển thị trang chi tiết sản phẩm
- Không có thông báo cảnh báo
- Có thể thêm vào giỏ hàng và wishlist (để test)
- Không thể review (vì là admin)

### Test Case 7: Truy cập không có tham số id
**Mô tả:** Truy cập URL không có tham số id
**URL:** `/product-detail`
**Kết quả mong đợi:**
- Redirect về trang home

### Test Case 8: Truy cập với id không hợp lệ
**Mô tả:** Truy cập URL với id không phải số
**URL:** `/product-detail?id=abc`
**Kết quả mong đợi:**
- Redirect về trang home

### Test Case 9: Truy cập sản phẩm không tồn tại
**Mô tả:** Truy cập URL với id không tồn tại trong database
**URL:** `/product-detail?id=99999`
**Kết quả mong đợi:**
- Redirect về trang home

### Test Case 10: Kiểm tra related products
**Mô tả:** Kiểm tra hiển thị sản phẩm liên quan
**URL:** `/product-detail?id=1`
**Kết quả mong đợi:**
- Customer: chỉ hiển thị related products khi sản phẩm hiện tại chưa bị xóa và có status = "active"
- Admin: luôn hiển thị related products (nếu có)

## Cách thực hiện test

### 1. Chuẩn bị dữ liệu test
```sql
-- Tạo sản phẩm test bình thường
INSERT INTO Products (ProductName, BrandName, Price, SKU, Status, IsDeleted, Stock) 
VALUES ('Test Product 1', 'Test Brand', 100000, 'TEST001', 'active', false, 10);

-- Tạo sản phẩm test đã bị xóa
INSERT INTO Products (ProductName, BrandName, Price, SKU, Status, IsDeleted, Stock) 
VALUES ('Test Product 2', 'Test Brand', 200000, 'TEST002', 'active', true, 5);

-- Tạo sản phẩm test có status khác active
INSERT INTO Products (ProductName, BrandName, Price, SKU, Status, IsDeleted, Stock) 
VALUES ('Test Product 3', 'Test Brand', 300000, 'TEST003', 'inactive', false, 0);
```

### 2. Thực hiện test
1. Đăng nhập với tài khoản customer
2. Thực hiện các test case 1-3, 7-9
3. Đăng nhập với tài khoản admin
4. Thực hiện các test case 4-6, 7-9
5. Kiểm tra test case 10

### 3. Kiểm tra log
- Xem console log để kiểm tra debug messages
- Kiểm tra các thông báo redirect
- Kiểm tra thông báo cảnh báo cho admin

## Kết quả mong đợi
- Customer chỉ có thể xem sản phẩm chưa bị xóa và có status = "active"
- Admin có thể xem tất cả sản phẩm với thông báo cảnh báo phù hợp
- Các trường hợp lỗi đều được xử lý và redirect về home
- UI hiển thị đúng trạng thái sản phẩm 