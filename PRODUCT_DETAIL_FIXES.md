# ProductDetailServlet - Các thay đổi và sửa lỗi

## Vấn đề ban đầu
- Customer và admin đều bị redirect về trang home khi truy cập ProductDetailServlet
- Không có kiểm tra phân quyền truy cập sản phẩm
- Không kiểm tra trạng thái `isDeleted` của sản phẩm

## Các thay đổi đã thực hiện

### 1. ProductService Interface
- Thêm method `getProductByIdWithAccessControl(Integer productId, boolean isAdmin)`
- Method này kiểm tra quyền truy cập dựa trên role của user

### 2. ProductServiceImpl
- Implement method `getProductByIdWithAccessControl()`
- Logic:
  - Admin có thể xem tất cả sản phẩm (kể cả đã xóa)
  - Customer chỉ có thể xem sản phẩm chưa bị xóa (`isDeleted = false`) và có status = "active"

### 3. ProductDetailServlet
- Sử dụng `getProductByIdWithAccessControl()` thay vì `getProductById()`
- Thêm kiểm tra trạng thái sản phẩm (`isDeleted`, `isActive`)
- Thêm thông báo cho admin khi xem sản phẩm đã bị xóa
- Cập nhật logic cho related products (chỉ hiển thị cho customer khi sản phẩm hiện tại chưa bị xóa)
- Cập nhật logic cho review (chỉ cho phép customer review sản phẩm chưa bị xóa và có status = "active")

### 4. product-detail.jsp
- Thêm thông báo cảnh báo khi admin xem sản phẩm đã bị xóa
- Cập nhật logic cho add to cart button (disable khi sản phẩm đã bị xóa)
- Cập nhật logic cho wishlist button (disable khi sản phẩm đã bị xóa)
- Cập nhật logic cho quantity input (disable khi sản phẩm đã bị xóa)

## Logic phân quyền

### Customer (user thường)
- Chỉ có thể xem sản phẩm có `isDeleted = false` và `status = "active"`
- Không thể thêm vào giỏ hàng sản phẩm đã bị xóa
- Không thể thêm vào wishlist sản phẩm đã bị xóa
- Chỉ có thể review sản phẩm chưa bị xóa và có status = "active"
- Chỉ hiển thị related products khi sản phẩm hiện tại chưa bị xóa

### Admin
- Có thể xem tất cả sản phẩm (kể cả đã xóa)
- Hiển thị thông báo cảnh báo khi xem sản phẩm đã bị xóa
- Có thể thêm vào giỏ hàng và wishlist sản phẩm đã bị xóa (để test)
- Không thể review sản phẩm (vì admin không mua hàng)

## Các trường hợp redirect về home
1. Không có tham số `id` hoặc `id` rỗng
2. `id` không phải số hợp lệ
3. Sản phẩm không tồn tại trong database
4. Customer truy cập sản phẩm đã bị xóa hoặc có status khác "active"
5. Có exception xảy ra trong quá trình xử lý

## Debug logs
- Thêm nhiều debug logs để theo dõi quá trình xử lý
- Log thông tin user, role, trạng thái sản phẩm
- Log số lượng related products tìm được

## Testing
Để test các thay đổi:
1. Tạo sản phẩm test với `isDeleted = true`
2. Truy cập với tài khoản customer → phải redirect về home
3. Truy cập với tài khoản admin → phải hiển thị trang chi tiết với thông báo cảnh báo
4. Tạo sản phẩm test với `status = "inactive"`
5. Truy cập với tài khoản customer → phải redirect về home
6. Truy cập với tài khoản admin → phải hiển thị trang chi tiết 