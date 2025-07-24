# AI Beauty Advisor - Hướng dẫn sử dụng

## 🎯 Tính năng mới

AI Agent đã được cập nhật với các tính năng mới:

### 1. **Check Giỏ Hàng**
- **Cách sử dụng:** Hỏi "Giỏ hàng của tôi có bao nhiêu sản phẩm?" hoặc "Xem giỏ hàng"
- **Kết quả:** Hiển thị chi tiết từng sản phẩm (tên, số lượng, giá) và tổng tiền
- **Yêu cầu:** Phải đăng nhập để xem giỏ hàng

### 2. **Thanh Toán Khi Nhận Hàng (COD)**
- **Cách sử dụng:** Hỏi "Tôi muốn thanh toán khi nhận hàng" hoặc "COD"
- **Quy trình:**
  1. AI hỏi thông tin nhận hàng (tên, địa chỉ, SĐT)
  2. User nhập thông tin
  3. AI xác nhận đơn hàng và thông báo thành công
- **Kết quả:** Hiển thị chi tiết đơn hàng và hướng dẫn thanh toán khi nhận

### 3. **Chuyển Khoản VietQR**
- **Cách sử dụng:** Hỏi "Tôi muốn chuyển khoản VietQR" hoặc "Chuyển khoản"
- **Kết quả:** 
  - Hiển thị chi tiết đơn hàng
  - Tổng tiền cần thanh toán
  - Thông tin chuyển khoản (STK, chủ TK)
  - QR code để quét
  - Hướng dẫn gửi biên lai

## 🚀 Cách truy cập

### 1. **Từ Menu chính**
- Vào menu "AI Chat" trên header
- Hoặc truy cập trực tiếp: `/client/chat-agent-new.jsp`

### 2. **Nút Quick Actions**
Trang chat có 3 nút nhanh:
- 🛒 **Xem giỏ hàng**
- 💰 **Thanh toán COD** 
- 📱 **Chuyển khoản QR**

## 💬 Ví dụ hội thoại

### Check giỏ hàng:
```
User: "Giỏ hàng của tôi có bao nhiêu sản phẩm?"
AI: "🛒 Giỏ hàng của bạn:
1. Kem dưỡng ẩm
   Số lượng: 2
   Giá: 150,000 VNĐ
   Thành tiền: 300,000 VNĐ

2. Sữa rửa mặt
   Số lượng: 1  
   Giá: 80,000 VNĐ
   Thành tiền: 80,000 VNĐ

📊 Tổng cộng: 3 sản phẩm
💰 Tổng tiền: 380,000 VNĐ

Bạn có muốn thanh toán không? (Chọn 'thanh toán khi nhận hàng' hoặc 'chuyển khoản VietQR')"
```

### Thanh toán COD:
```
User: "Tôi muốn thanh toán khi nhận hàng"
AI: "Vui lòng cung cấp thông tin nhận hàng theo format:
Tên: [Tên người nhận]
Địa chỉ: [Địa chỉ giao hàng]  
SĐT: [Số điện thoại]"

User: "Tên: Nguyễn Văn A
Địa chỉ: 123 Đường ABC, Quận 1, TP.HCM
SĐT: 0901234567"

AI: "✅ Đơn hàng COD đã được xác nhận!

📋 Thông tin nhận hàng:
Tên: Nguyễn Văn A
Địa chỉ: 123 Đường ABC, Quận 1, TP.HCM
SĐT: 0901234567

🛒 Chi tiết đơn hàng:
1. Kem dưỡng ẩm x2 - 300,000 VNĐ
2. Sữa rửa mặt x1 - 80,000 VNĐ

💰 Tổng tiền cần thanh toán: 380,000 VNĐ

🚚 Đơn hàng sẽ được giao tận nơi trong 2-3 ngày làm việc.
💵 Vui lòng chuẩn bị tiền mặt để thanh toán khi nhận hàng.
📞 Nhân viên sẽ liên hệ trước khi giao hàng.

Cảm ơn bạn đã mua hàng! 🎉"
```

### Chuyển khoản VietQR:
```
User: "Tôi muốn chuyển khoản VietQR"
AI: "💳 Thanh toán VietQR cho giỏ hàng:

🛒 Chi tiết đơn hàng:
1. Kem dưỡng ẩm x2 - 300,000 VNĐ
2. Sữa rửa mặt x1 - 80,000 VNĐ

💰 Tổng tiền cần thanh toán: 380,000 VNĐ

🏦 Thông tin chuyển khoản:
Ngân hàng: Vietcombank
💳 STK: 1031253640
👤 Chủ TK: HUYNH NGOC SON
💵 Số tiền: 380,000 VNĐ
📝 Nội dung: DH123456789_1

[QR Code hiển thị ở đây]

📧 Gửi biên lai sau khi chuyển khoản để xác nhận đơn hàng."
```

## 🔧 Cấu hình kỹ thuật

### Files đã cập nhật:
1. `src/java/com/juleswhite/module1/CosmeticAIAgent.java` - Logic AI chính
2. `src/java/controller/client/ChatAgentController.java` - Controller mới
3. `web/client/chat-agent-new.jsp` - Giao diện chat mới
4. `web/header.jsp` - Thêm link AI Chat

### Endpoints:
- `POST /chat-agent/chat` - Gửi tin nhắn
- `POST /chat-agent/greeting` - Lấy lời chào
- `POST /chat-agent/summary` - Lấy tóm tắt

### Dependencies:
- Gson (đã có sẵn)
- QRBankUtil (đã có sẵn)
- CartService, CartItemService (đã có sẵn)

## 🎨 Giao diện

- **Design hiện đại** với gradient và animation
- **Responsive** cho mobile và desktop
- **Quick Actions** để truy cập nhanh
- **Markdown support** cho formatting
- **Typing indicator** khi AI đang xử lý

## 🔒 Bảo mật

- **Session-based** authentication
- **User validation** cho các thao tác giỏ hàng
- **Error handling** đầy đủ
- **CORS** được cấu hình đúng

## 🚀 Deploy

1. Build project
2. Deploy lên server
3. Truy cập `/client/chat-agent-new.jsp`
4. Test các tính năng mới

---

**Lưu ý:** AI Agent cần user đăng nhập để sử dụng các tính năng giỏ hàng và thanh toán. 