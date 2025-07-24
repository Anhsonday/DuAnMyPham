<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>VNPay Integration Test</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .test-section { margin: 20px 0; padding: 15px; border: 1px solid #ddd; border-radius: 5px; }
        .btn { padding: 10px 20px; margin: 5px; background: #007bff; color: white; text-decoration: none; border-radius: 3px; }
        .btn:hover { background: #0056b3; }
        .error { color: red; }
        .success { color: green; }
        pre { background: #f8f9fa; padding: 10px; border-radius: 3px; overflow-x: auto; }
        .debug-info { background: #e9ecef; padding: 10px; border-radius: 3px; margin: 10px 0; }
        .fix-list { background: #d4edda; padding: 10px; border-radius: 3px; margin: 10px 0; }
        .latest-fixes { background: #fff3cd; padding: 10px; border-radius: 3px; margin: 10px 0; }
    </style>
</head>
<body>
    <h1>VNPay Integration Test</h1>
    
    <div class="test-section">
        <h3>1. Test Payment Methods</h3>
        <a href="payment?action=debug&type=methods" class="btn" target="_blank">Check Payment Methods</a>
        <p>Kiểm tra xem VNPay payment method có tồn tại không</p>
    </div>
    
    <div class="test-section">
        <h3>1.5. Test Session Debug</h3>
        <a href="payment?action=debug&type=session" class="btn" target="_blank">Check Session Info</a>
        <p>Kiểm tra thông tin session và order</p>
    </div>
    
    <div class="test-section">
        <h3>2. Test VNPay URL Creation</h3>
        <a href="payment?action=test" class="btn" target="_blank">Test VNPay URL</a>
        <p>Tạo test URL để kiểm tra VNPay integration</p>
    </div>
    
    <div class="test-section">
        <h3>3. Test Checkout Flow</h3>
        <p>Để test checkout flow:</p>
        <ol>
            <li>Thêm sản phẩm vào giỏ hàng</li>
            <li>Vào trang checkout</li>
            <li>Chọn VNPay payment method</li>
            <li>Click "Place Order"</li>
            <li>Kiểm tra console logs</li>
        </ol>
    </div>
    
    <div class="test-section">
        <h3>4. Debug Information</h3>
        <div class="debug-info">
            <h4>VNPay Configuration:</h4>
            <pre>
VNP_PAY_URL: https://sandbox.vnpayment.vn/paymentv2/vpcpay.html
VNP_RETURN_URL: http://localhost:8080/DU_AN_MY_PHAM/vnpay-return
VNP_TMN_CODE: 9DH0FCDL
VNP_VERSION: 2.1.0
VNP_COMMAND: pay
            </pre>
            
            <h4>Expected Flow:</h4>
            <ol>
                <li>User submits checkout form → CheckOutServlet</li>
                <li>CheckOutServlet creates order → redirects to PaymentServlet</li>
                <li>PaymentServlet creates VNPay URL → redirects to VNPay</li>
                <li>User pays on VNPay → returns to VNPayReturnServlet</li>
                <li>VNPayReturnServlet updates payment → redirects to success page</li>
            </ol>
        </div>
    </div>
    
    <div class="test-section">
        <h3>5. Common Issues & Solutions</h3>
        <ul>
            <li><strong>VNPay payment method not found:</strong> Check if VNPay method exists in database</li>
            <li><strong>URL not redirecting:</strong> Check PaymentServlet logs</li>
            <li><strong>VNPay URL invalid:</strong> Check VNPayConfig settings</li>
            <li><strong>Return URL not working:</strong> Check VNPayReturnServlet mapping</li>
            <li><strong>String.length() null error:</strong> Fixed null checks in multiple files</li>
        </ul>
    </div>
    
    <div class="test-section">
        <h3>6. Manual Test</h3>
        <p>Nếu tự động không hoạt động, thử test thủ công:</p>
        <a href="payment?action=test" class="btn" target="_blank">Create Test VNPay URL</a>
        <p>Sau đó click vào link được tạo để test VNPay payment</p>
    </div>
    
    <div class="test-section">
        <h3>7. Recent Fixes</h3>
        <div class="fix-list">
            <h4>✅ Fixed Null Pointer Issues:</h4>
            <ul>
                <li>Fixed VNPayConfig return URL (was DuAnBanHang, now DU_AN_MY_PHAM)</li>
                <li>Fixed null checks in PaymentDAO.getMaxTransactionNumberByDate()</li>
                <li>Fixed null checks in CheckOutServlet.sendOrderConfirmationEmail()</li>
                <li>Fixed null checks in OrderItemService.reserveProduct()</li>
                <li>Fixed null checks in CartItemService.reserveProduct()</li>
                <li>Fixed null checks in OrderService.confirmOrder() and cancelOrder()</li>
                <li>Removed duplicate logic in PaymentService.createPayment()</li>
                <li>Added proper import for OrderService in PaymentService</li>
            </ul>
            
            <h4>🔧 Specific Changes:</h4>
            <ul>
                <li><strong>PaymentDAO:</strong> Added null checks for transaction ID parsing</li>
                <li><strong>CheckOutServlet:</strong> Added null checks for product names in email</li>
                <li><strong>OrderItemService:</strong> Fixed null pointer when product not found</li>
                <li><strong>CartItemService:</strong> Fixed null pointer when product not found</li>
                <li><strong>OrderService:</strong> Fixed null pointer in confirm/cancel order</li>
            </ul>
        </div>
    </div>
    
    <div class="test-section">
        <h3>8. Latest Fixes (Latest Session)</h3>
        <div class="latest-fixes">
            <h4>🆕 Just Fixed:</h4>
            <ul>
                <li><strong>CheckOutServlet.sendOrderConfirmationEmail():</strong> Added null check for user.getUserName()</li>
                <li><strong>CheckOutServlet.sendOrderConfirmationEmail():</strong> Added null check for user.getEmail()</li>
                <li><strong>All Services:</strong> Fixed null pointer exceptions when calling getProductName() on null objects</li>
            </ul>
            
            <h4>🎯 Root Cause:</h4>
            <p>The "Cannot invoke String.length() because s is null" error was caused by:</p>
            <ul>
                <li>Calling getProductName() on null Product objects</li>
                <li>Calling getUserName() on User objects that might have null userName</li>
                <li>Calling getEmail() on User objects that might have null email</li>
                <li>Calling trim() on null String parameters</li>
            </ul>
        </div>
    </div>
    
    <div class="test-section">
        <h3>9. Test Steps</h3>
        <ol>
            <li>Click "Check Payment Methods" to verify VNPay method exists</li>
            <li>Click "Test VNPay URL" to test URL generation</li>
            <li>Try actual checkout with VNPay payment method</li>
            <li>Check server logs for any remaining errors</li>
        </ol>
    </div>
</body>
</html> 