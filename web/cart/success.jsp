<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="utils.ProductImageUtil" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html class="no-js" lang="vi">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Đặt hàng thành công - Beauty Store</title>
    <link href="https://fonts.googleapis.com/css?family=Cairo:400,600,700&amp;display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css?family=Poppins:600&amp;display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css?family=Playfair+Display:400i,700i" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css?family=Ubuntu&amp;display=swap" rel="stylesheet">
    <link rel="shortcut icon" type="image/x-icon" href="../assets/images/favicon.png" />
    <link rel="stylesheet" href="../assets/css/bootstrap.min.css">
    <link rel="stylesheet" href="../assets/css/animate.min.css">
    <link rel="stylesheet" href="../assets/css/font-awesome.min.css">
    <link rel="stylesheet" href="../assets/css/nice-select.css">
    <link rel="stylesheet" href="../assets/css/slick.min.css">
    <link rel="stylesheet" href="../assets/css/style.css">
    <link rel="stylesheet" href="../assets/css/main-color.css">
    <style>
        .success-container {
            min-height: 60vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 40px 0;
        }
        
        .success-card {
            background: #fff;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.1);
            padding: 60px 40px;
            text-align: center;
            max-width: 800px;
            width: 100%;
            position: relative;
            overflow: hidden;
        }
        
        .success-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(45deg, #28a745, #20c997);
        }
        
        .success-icon {
            width: 120px;
            height: 120px;
            background: linear-gradient(45deg, #28a745, #20c997);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 30px;
            animation: successPulse 2s ease-in-out infinite;
        }
        
        .success-icon i {
            font-size: 60px;
            color: white;
        }
        
        @keyframes successPulse {
            0%, 100% { transform: scale(1); }
            50% { transform: scale(1.05); }
        }
        
        .success-title {
            font-size: 2.5em;
            font-weight: bold;
            color: #28a745;
            margin-bottom: 15px;
        }
        
        .success-subtitle {
            font-size: 1.2em;
            color: #666;
            margin-bottom: 30px;
            line-height: 1.6;
        }
        
        .order-info {
            background: #f8f9fa;
            border-radius: 15px;
            padding: 25px;
            margin: 30px 0;
            text-align: left;
        }
        
        .order-info h4 {
            color: #333;
            font-weight: 600;
            margin-bottom: 20px;
            font-size: 1.3em;
        }
        
        .info-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 10px 0;
            border-bottom: 1px solid #eee;
        }
        
        .info-row:last-child {
            border-bottom: none;
            font-weight: bold;
            font-size: 1.1em;
            color: #28a745;
        }
        
        .info-label {
            color: #666;
            font-weight: 500;
        }
        
        .info-value {
            color: #333;
            font-weight: 600;
        }
        
        .order-items {
            background: #fff;
            border-radius: 15px;
            padding: 25px;
            margin: 20px 0;
            border: 1px solid #eee;
        }
        
        .order-item {
            display: flex;
            align-items: center;
            padding: 15px 0;
            border-bottom: 1px solid #f0f0f0;
        }
        
        .order-item:last-child {
            border-bottom: none;
        }
        
        .item-image {
            width: 100px;
            height: 100px;
            border-radius: 8px;
            margin-right: 15px;
        }
        
        .item-details {
            flex: 1;
        }
        
        .item-name {
            font-weight: 600;
            color: #333;
            margin-bottom: 5px;
        }
        
        .item-price {
            color: #ff6b6b;
            font-weight: 600;
        }
        
        .item-quantity {
            color: #666;
            font-size: 0.9em;
        }
        
        .action-buttons {
            margin-top: 40px;
            display: flex;
            gap: 15px;
            justify-content: center;
            flex-wrap: wrap;
        }
        
        .btn-primary-custom {
            background: linear-gradient(45deg, #ff6b6b, #ff5252);
            color: white;
            border: none;
            padding: 15px 30px;
            border-radius: 25px;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }
        
        .btn-primary-custom:hover {
            background: linear-gradient(45deg, #ff5252, #ff4444);
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(255,107,107,0.3);
            color: white;
            text-decoration: none;
        }
        
        .btn-secondary-custom {
            background: linear-gradient(45deg, #6c757d, #5a6268);
            color: white;
            border: none;
            padding: 15px 30px;
            border-radius: 25px;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }
        
        .btn-secondary-custom:hover {
            background: linear-gradient(45deg, #5a6268, #495057);
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(108,117,125,0.3);
            color: white;
            text-decoration: none;
        }
        
        .email-notice {
            background: linear-gradient(45deg, #fff3cd, #ffeaa7);
            border: 1px solid #ffeaa7;
            border-radius: 10px;
            padding: 15px 20px;
            margin: 20px 0;
            color: #856404;
            font-size: 0.95em;
        }
        
        .email-notice i {
            margin-right: 8px;
            color: #f39c12;
        }
        
        .payment-status {
            background: linear-gradient(45deg, #d4edda, #c3e6cb);
            border: 1px solid #c3e6cb;
            border-radius: 10px;
            padding: 15px 20px;
            margin: 20px 0;
            color: #155724;
            font-size: 0.95em;
        }
        
        .payment-status i {
            margin-right: 8px;
            color: #28a745;
        }
        
        @media (max-width: 768px) {
            .success-card {
                padding: 40px 20px;
                margin: 20px;
            }
            
            .success-title {
                font-size: 2em;
            }
            
            .action-buttons {
                flex-direction: column;
                align-items: center;
            }
            
            .btn-primary-custom,
            .btn-secondary-custom {
                width: 100%;
                max-width: 300px;
                justify-content: center;
            }
        }
    </style>
</head>
<body class="biolife-body">

    
    <!-- MAIN CONTENT -->
    <div class="main-content">
        <div class="container">
            <div class="success-container">
                <div class="success-card">
                    <div class="success-icon">
                        <i class="fa fa-check"></i>
                    </div>
                    
                    <h1 class="success-title">Đặt hàng thành công!</h1>
                    <p class="success-subtitle">
                        Cảm ơn bạn đã mua sắm tại Beauty Store. Đơn hàng của bạn đã được xác nhận và sẽ được xử lý sớm nhất.
                    </p>
                    
                    <!-- Payment Status -->
                    <c:if test="${sessionScope.paymentMethod != null && sessionScope.paymentMethod.contains('VNPay')}">
                        <div class="payment-status">
                            <i class="fa fa-credit-card"></i>
                            <strong>Thanh toán thành công qua VNPay!</strong> Giao dịch đã được xác nhận và đơn hàng của bạn đang được xử lý.
                        </div>
                    </c:if>
                    
                    <!-- Order Information -->
                    <div class="order-info">
                        <h4><i class="fa fa-info-circle"></i> Thông tin đơn hàng</h4>
                        
                        <c:if test="${sessionScope.orderNumber != null}">
                            <div class="info-row">
                                <span class="info-label">Mã đơn hàng:</span>
                                <span class="info-value">#${sessionScope.orderNumber}</span>
                            </div>
                        </c:if>
                        
                        <c:if test="${sessionScope.paymentMethod != null}">
                            <div class="info-row">
                                <span class="info-label">Phương thức thanh toán:</span>
                                <span class="info-value">${sessionScope.paymentMethod}</span>
                            </div>
                        </c:if>
                        
                        <c:if test="${sessionScope.order.shippingAddress != null}">
                            <div class="info-row">
                                <span class="info-label">Địa chỉ giao hàng:</span>
                                <span class="info-value">${sessionScope.order.shippingAddress.fullAddress}</span>
                            </div>
                        </c:if>
                        
                        <c:if test="${sessionScope.order.billingAddress != null}">
                            <div class="info-row">
                                <span class="info-label">Địa chỉ thanh toán:</span>
                                <span class="info-value">${sessionScope.order.billingAddress.fullAddress}</span>
                            </div>
                        </c:if>
                        
                        <c:if test="${sessionScope.order.notes != null && not empty sessionScope.order.notes}">
                            <div class="info-row">
                                <span class="info-label">Ghi chú:</span>
                                <span class="info-value">${sessionScope.order.notes}</span>
                            </div>
                        </c:if>
                    </div>
                    
                    <!-- Order Items -->
                    <c:if test="${sessionScope.orderItems != null}">
                        <div class="order-items">
                            <h4><i class="fa fa-shopping-bag"></i> Sản phẩm đã đặt</h4>
                            <c:forEach var="item" items="${sessionScope.orderItems}">
                                <c:set var="mainImageUrl" value="${not empty item.product.productImagesCollection ? item.product.productImagesCollection[0].imageUrl : null}" />
                                <div class="order-item">
                                    <img src="${pageContext.request.contextPath}${not empty mainImageUrl ? mainImageUrl : '/assets/images/products/default.jpg'}" alt="${item.product.productName}" class="item-image">
                                    <div class="item-details">
                                        <div class="item-name">${item.product.productName}</div>
                                        <div class="item-price">₫<fmt:formatNumber value="${item.product.price}" type="number" groupingUsed="true"/></div>
                                        <div class="item-quantity">Số lượng: ${item.quantity}</div>
                                    </div>
                                    <div class="item-total">
                                        <strong>₫<fmt:formatNumber value="${item.product.price * item.quantity}" type="number" groupingUsed="true"/></strong>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:if>
                    
                    <!-- Order Summary -->
                    <div class="order-info">
                        <h4><i class="fa fa-calculator"></i> Tóm tắt đơn hàng</h4>
                        
                        <c:if test="${sessionScope.order.totalAmount != null}">
                            <div class="info-row">
                                <span class="info-label">Tạm tính:</span>
                                <span class="info-value">₫<fmt:formatNumber value="${sessionScope.order.totalAmount}" type="number" groupingUsed="true"/></span>
                            </div>
                        </c:if>
                        
                        <c:if test="${sessionScope.order.discountAmount != null && sessionScope.order.discountAmount > 0}">
                            <div class="info-row">
                                <span class="info-label">Giảm giá:</span>
                                <span class="info-value">-₫<fmt:formatNumber value="${sessionScope.order.discountAmount}" type="number" groupingUsed="true"/></span>
                            </div>
                        </c:if>
                        
                        <c:if test="${sessionScope.order.shippingFee != null}">
                            <div class="info-row">
                                <span class="info-label">Phí vận chuyển:</span>
                                <span class="info-value">₫<fmt:formatNumber value="${sessionScope.order.shippingFee}" type="number" groupingUsed="true"/></span>
                            </div>
                        </c:if>
                        
                        <c:if test="${sessionScope.order.tax != null}">
                            <div class="info-row">
                                <span class="info-label">Thuế (VAT):</span>
                                <span class="info-value">₫<fmt:formatNumber value="${sessionScope.order.tax}" type="number" groupingUsed="true"/></span>
                            </div>
                        </c:if>
                        
                        <c:if test="${sessionScope.order.finalAmount != null}">
                            <div class="info-row">
                                <span class="info-label">Tổng tiền:</span>
                                <span class="info-value">₫<fmt:formatNumber value="${sessionScope.order.finalAmount}" type="number" groupingUsed="true"/></span>
                            </div>
                        </c:if>
                    </div>
                    
                    <!-- Email Notice -->
                    <div class="email-notice">
                        <i class="fa fa-envelope"></i>
                        <strong>Email xác nhận đã được gửi!</strong> Vui lòng kiểm tra hộp thư của bạn để xem chi tiết đơn hàng.
                    </div>
                    
                    <!-- Action Buttons -->
                    <div class="action-buttons">
                        <a href="../home" class="btn-primary-custom">
                            <i class="fa fa-home"></i>
                            Về trang chủ
                        </a>
                        <a href="orders" class="btn-secondary-custom">
                            <i class="fa fa-list"></i>
                            Xem đơn hàng
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    

    

    <!-- Scroll Top Button -->
    <a class="btn-scroll-top"><i class="biolife-icon icon-left-arrow"></i></a>

    <!-- Scripts -->
    <script src="../assets/js/jquery-3.4.1.min.js"></script>
    <script src="../assets/js/bootstrap.min.js"></script>
    <script src="../assets/js/jquery.countdown.min.js"></script>
    <script src="../assets/js/jquery.nice-select.min.js"></script>
    <script src="../assets/js/jquery.nicescroll.min.js"></script>
    <script src="../assets/js/slick.min.js"></script>
    <script src="../assets/js/biolife.framework.js"></script>
    <script src="../assets/js/functions.js"></script>
    <script>
        $(document).ready(function() {
            // Hide preloader
            $('#biof-loading').fadeOut();
            
            // Clear session data after displaying
            // This prevents showing old data if user refreshes the page
            setTimeout(function() {
                // Clear sensitive order data from session
                // Note: This should be done server-side, but for demo purposes
                console.log('Order completed successfully');
            }, 5000);
        });
    </script>
</body>
</html> 