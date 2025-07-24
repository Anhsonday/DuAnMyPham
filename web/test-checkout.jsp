<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Checkout Test</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .test-section { margin: 20px 0; padding: 15px; border: 1px solid #ddd; border-radius: 5px; }
        .btn { padding: 10px 20px; margin: 5px; background: #007bff; color: white; text-decoration: none; border-radius: 3px; }
        .btn:hover { background: #0056b3; }
        .error { color: red; }
        .success { color: green; }
        .info { background: #e9ecef; padding: 10px; border-radius: 3px; margin: 10px 0; }
    </style>
</head>
<body>
    <h1>Checkout Flow Test</h1>
    
    <div class="test-section">
        <h3>Debug Steps</h3>
        <div class="info">
            <h4>Để debug lỗi "Đơn hàng không tồn tại cho thanh toán này":</h4>
            <ol>
                <li>Thêm sản phẩm vào giỏ hàng</li>
                <li>Vào trang checkout</li>
                <li>Chọn VNPay payment method</li>
                <li>Click "Place Order"</li>
                <li>Kiểm tra console logs để xem:
                    <ul>
                        <li>Order có được tạo thành công không</li>
                        <li>Order có được lưu vào session không</li>
                        <li>PaymentServlet có nhận được order từ session không</li>
                    </ul>
                </li>
            </ol>
        </div>
    </div>
    
    <div class="test-section">
        <h3>Debug Endpoints</h3>
        <a href="payment?action=debug&type=session" class="btn" target="_blank">Check Session Info</a>
        <a href="payment?action=debug&type=methods" class="btn" target="_blank">Check Payment Methods</a>
        <p>Kiểm tra session và payment methods trước khi test</p>
    </div>
    
    <div class="test-section">
        <h3>Common Issues</h3>
        <ul>
            <li><strong>Order không được lưu vào session:</strong> Kiểm tra OrderService.createOrder()</li>
            <li><strong>Session bị mất:</strong> Kiểm tra session timeout và redirect</li>
            <li><strong>Order bị null:</strong> Kiểm tra quá trình tạo order</li>
            <li><strong>PaymentServlet không nhận được order:</strong> Kiểm tra session attribute</li>
        </ul>
    </div>
    
    <div class="test-section">
        <h3>Expected Log Messages</h3>
        <div class="info">
            <h4>CheckOutServlet logs:</h4>
            <pre>
Order saved to session - Order ID: [order_id], Order Number: [order_number]
Payment method selected: 2 - VNPay
Redirecting to PaymentServlet for VNPay payment. Order ID: [order_id], Amount: [amount]
            </pre>
            
            <h4>PaymentServlet logs:</h4>
            <pre>
PaymentServlet - User: [username], Order: [order_id], Session ID: [session_id]
PaymentServlet doGet called with action: create, order: [order_id]
Processing payment creation. Amount: [amount], Method ID: 2
Payment method found: VNPay (ID: 2)
Handling VNPay payment for order: [order_id]
            </pre>
        </div>
    </div>
    
    <div class="test-section">
        <h3>Manual Test</h3>
        <p>Nếu tự động không hoạt động:</p>
        <ol>
            <li>Thêm sản phẩm vào giỏ hàng</li>
            <li>Vào trang checkout</li>
            <li>Chọn VNPay payment method</li>
            <li>Click "Place Order"</li>
            <li>Kiểm tra console logs</li>
            <li>Nếu có lỗi, kiểm tra session info</li>
        </ol>
    </div>
</body>
</html> 