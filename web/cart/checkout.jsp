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
    <title>Thanh toán - Beauty Store</title>
    <link href="https://fonts.googleapis.com/css?family=Cairo:400,600,700&amp;display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css?family=Poppins:600&amp;display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css?family=Playfair+Display:400i,700i" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css?family=Ubuntu&amp;display=swap" rel="stylesheet">
    <link rel="shortcut icon" type="image/x-icon" href="assets/images/favicon.png" />
    <link rel="stylesheet" href="assets/css/bootstrap.min.css">
    <link rel="stylesheet" href="assets/css/animate.min.css">
    <link rel="stylesheet" href="assets/css/font-awesome.min.css">
    <link rel="stylesheet" href="assets/css/nice-select.css">
    <link rel="stylesheet" href="assets/css/slick.min.css">
    <link rel="stylesheet" href="assets/css/style.css">
    <link rel="stylesheet" href="assets/css/main-color.css">
    <style>
        /* Override template CSS để đảm bảo dropdown hiển thị đúng */
        select.form-control {
            display: inline-block !important;
            color: #333 !important;
            background: #fff !important;
            border: 2px solid #e1e5e9 !important;
            border-radius: 8px !important;
            padding: 10px 15px !important;
            min-height: 45px !important;
            width: auto !important;
            opacity: 1 !important;
            visibility: visible !important;
            font-size: 14px !important;
            font-weight: 500 !important;
            transition: all 0.3s ease !important;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05) !important;
        }
        
        select.form-control:hover {
            border-color: #ff6b6b !important;
            box-shadow: 0 4px 8px rgba(255,107,107,0.15) !important;
        }
        
        select.form-control:focus {
            outline: none !important;
            border-color: #ff6b6b !important;
            box-shadow: 0 0 0 3px rgba(255,107,107,0.1) !important;
        }
        
        select.form-control option {
            color: #333 !important;
            background: white !important;
            padding: 8px 12px !important;
            font-size: 14px !important;
        }
        
        select.form-control option:hover {
            background: #f8f9fa !important;
        }
        
        /* Đảm bảo dropdown luôn có style ngay cả khi không có option selected */
        select.form-control:not([size]) {
            height: 45px !important;
        }
        
        /* Ẩn dropdown ẩn từ template */
        .nice-select {
            display: none !important;
        }
        
        /* Ẩn tất cả dropdown ẩn khác */
        .select-wrapper {
            display: none !important;
        }
        
        /* Đảm bảo chỉ hiển thị dropdown thật */
        select[name="shippingAddressID"],
        select[name="billingAddressID"], 
        select[name="paymentMethodID"] {
            display: inline-block !important;
            visibility: visible !important;
            opacity: 1 !important;
            position: relative !important;
            z-index: 1 !important;
        }
        
        /* Ẩn các element ẩn khác có thể gây conflict */
        .hidden-select,
        .fake-select {
            display: none !important;
        }
        
        /* Cải thiện giao diện form group */
        .form-group {
            margin-bottom: 20px !important;
        }
        
        .checkout-label {
            font-weight: 600 !important;
            color: #333 !important;
            margin-bottom: 8px !important;
            display: block !important;
            font-size: 14px !important;
        }
        
        /* Style cho container của dropdown */
        .dropdown-container {
            display: flex !important;
            align-items: center !important;
            gap: 10px !important;
        }
        
        /* Style cho nút thêm địa chỉ */
        .btn-add-address {
            background: #ff6b6b !important;
            color: white !important;
            border: none !important;
            padding: 8px 16px !important;
            border-radius: 6px !important;
            font-size: 12px !important;
            font-weight: 500 !important;
            text-decoration: none !important;
            transition: all 0.3s ease !important;
        }
        
        .btn-add-address:hover {
            background: #ff5252 !important;
            transform: translateY(-1px) !important;
            box-shadow: 0 4px 8px rgba(255,107,107,0.2) !important;
        }
        .checkout-section {
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 8px 32px rgba(0,0,0,0.08);
            padding: 32px 24px;
            margin-bottom: 32px;
        }
        .checkout-title {
            font-size: 1.5em;
            font-weight: bold;
            color: #ff6b6b;
            margin-bottom: 18px;
        }
        .checkout-label {
            font-weight: 600;
            color: #333;
        }
        .checkout-radio-list label {
            margin-right: 24px;
            font-weight: 500;
            cursor: pointer;
        }
        .checkout-radio-list input[type="radio"] {
            margin-right: 6px;
            accent-color: #ff6b6b;
        }
        .order-summary-box {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 24px 18px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.04);
        }
        .order-summary-title {
            font-size: 1.2em;
            font-weight: bold;
            color: #28a745;
            margin-bottom: 12px;
        }
        .order-summary-list {
            margin-bottom: 18px;
        }
        .order-summary-list li {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 8px 0;
            border-bottom: 1px solid #eee;
        }
        .order-summary-list img {
            border-radius: 8px;
            margin-right: 10px;
        }
        .order-summary-total {
            font-size: 1.2em;
            font-weight: bold;
            color: #ff6b6b;
            text-align: right;
        }
        .btn-checkout {
            background: linear-gradient(45deg, #28a745, #20c997);
            color: #fff;
            border: none;
            padding: 14px 36px;
            border-radius: 25px;
            font-weight: bold;
            font-size: 1.1em;
            text-transform: uppercase;
            letter-spacing: 1px;
            transition: all 0.3s;
            box-shadow: 0 4px 16px rgba(40,167,69,0.12);
        }
        .btn-checkout:hover {
            background: linear-gradient(45deg, #20c997, #28a745);
            transform: translateY(-2px) scale(1.03);
            box-shadow: 0 8px 32px rgba(40,167,69,0.18);
        }
        .checkout-user-info {
            background: #f1f3f6;
            border-radius: 8px;
            padding: 16px 18px;
            margin-bottom: 18px;
            display: flex;
            align-items: center;
        }
        .checkout-user-info i {
            color: #ff6b6b;
            font-size: 1.5em;
            margin-right: 12px;
        }
        .checkout-error {
            background: linear-gradient(45deg, #dc3545, #c82333);
            color: #fff;
            border-radius: 8px;
            padding: 12px 18px;
            margin-bottom: 18px;
            font-weight: 500;
            box-shadow: 0 2px 8px rgba(220,53,69,0.08);
        }
        .checkout-success {
            background: linear-gradient(45deg, #28a745, #20c997);
            color: #fff;
            border-radius: 8px;
            padding: 12px 18px;
            margin-bottom: 18px;
            font-weight: 500;
            box-shadow: 0 2px 8px rgba(40,167,69,0.08);
        }
        
        /* Voucher styles */
        .voucher-container {
            margin-bottom: 15px;
        }
        
        .input-group {
            display: flex;
            align-items: stretch;
        }
        
        .input-group .form-control {
            flex: 1;
            border-radius: 8px 0 0 8px;
            border-right: none;
        }
        
        .input-group-append .btn {
            border-radius: 8px;
            border-left: none;
            background: linear-gradient(45deg, #ff6b6b, #ff5252);
            color: white;
            border-color: #ff6b6b;
            margin-left: 10px;
            padding: 12px 18px;
            font-weight: 600;
            font-size: 10px;
            transition: all 0.3s ease;
            box-shadow: 0 2px 8px rgba(255,107,107,0.2);
            text-transform: uppercase;
            letter-spacing: 0.2px;
            min-width: 40px;
        }
        
        .input-group-append .btn:hover {
            background: linear-gradient(45deg, #ff5252, #ff6b6b);
            border-color: #ff5252;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(255,107,107,0.3);
        }
        
        .input-group-append .btn:active {
            transform: translateY(0);
            box-shadow: 0 2px 4px rgba(255,107,107,0.2);
        }
        
        .input-group-append .btn:disabled {
            background: #ccc;
            border-color: #ccc;
            transform: none;
            box-shadow: none;
            cursor: not-allowed;
        }
        
        /* Pulse animation for loading */
        @keyframes pulse {
            0% {
                box-shadow: 0 2px 8px rgba(255,107,107,0.2);
            }
            50% {
                box-shadow: 0 2px 8px rgba(255,107,107,0.4);
            }
            100% {
                box-shadow: 0 2px 8px rgba(255,107,107,0.2);
            }
        }
        
        .pulse {
            animation: pulse 1s infinite;
        }
        
        /* Nút xóa voucher */
        .btn-remove-voucher {
            transition: all 0.3s ease;
        }
        
        .btn-remove-voucher:hover {
            background: #c82333 !important;
            transform: translateY(-1px);
            box-shadow: 0 2px 4px rgba(220,53,69,0.3);
        }
        
        .btn-remove-voucher:active {
            transform: translateY(0);
        }
        
        #voucherMessage {
            padding: 8px 12px;
            border-radius: 6px;
            font-size: 14px;
            margin-top: 8px;
        }
        
        #voucherMessage.success {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        
        #voucherMessage.error {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        
        .voucher-applied {
            background: #f8f9fa;
            border: 1px solid #e9ecef;
            border-radius: 8px;
            padding: 12px;
            margin: 10px 0;
        }
        
        .voucher-info {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .voucher-code {
            font-weight: 600;
            color: #28a745;
        }
        
        .voucher-discount {
            font-weight: 600;
        }
        
        .discount-row {
            padding: 8px 0;
            border-bottom: 1px solid #eee;
        }
        
        .discount-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 8px 0;
            border-bottom: 1px solid #eee;
        }
        
        .discount-label {
            font-weight: 500;
            color: #333;
        }
        
        .discount-amount {
            font-weight: 600;
            color: #28a745;
        }
        
        .discount-amount.negative {
            color: #dc3545;
        }
        
        .discount-amount.positive {
            color: #28a745;
        }
        
        /* Notes textarea styles */
        textarea.form-control {
            border: 2px solid #e1e5e9;
            border-radius: 8px;
            padding: 12px 14px;
            font-size: 14px;
            transition: all 0.3s ease;
            width: 100%;
            background: #fff;
            resize: vertical;
            min-height: 80px;
            font-family: inherit;
        }
        
        textarea.form-control:focus {
            outline: none;
            border-color: #ff6b6b;
            box-shadow: 0 0 0 3px rgba(255,107,107,0.1);
        }
        
        textarea.form-control::placeholder {
            color: #999;
            font-style: italic;
        }
    </style>
</head>
<body class="biolife-body">

    <!-- Preloader -->
    <div id="biof-loading">
        <div class="biof-loading-center">
            <div class="biof-loading-center-absolute">
                <div class="dot dot-one"></div>
                <div class="dot dot-two"></div>
                <div class="dot dot-three"></div>
            </div>
        </div>
    </div>

    <!-- HEADER -->
    <jsp:include page="/header.jsp"></jsp:include>

    <!--Hero Section-->
    <div class="hero-section hero-background">
        <h1 class="page-title">Thanh toán đơn hàng</h1>
    </div>
    <div class="container">
        <nav class="biolife-nav">
            <ul>
                <li class="nav-item"><a href="home" class="permal-link">Trang chủ</a></li>
                <li class="nav-item"><a href="cart" class="permal-link">Giỏ hàng</a></li>
                <li class="nav-item"><span class="current-page">Thanh toán</span></li>
            </ul>
        </nav>
    </div>
    <div class="page-contain checkout">
        <div id="main-content" class="main-content">
            <div class="container sm-margin-top-37px">
                <div class="row">
                    <div class="col-lg-7 col-md-7 col-sm-12 col-xs-12">
                        <div class="checkout-section">
                            <div style="margin-bottom:18px;">
                                <a href="home" class="btn btn-secondary"><i class="fa fa-arrow-left"></i> Quay lại giỏ hàng</a>
                            </div>
                            <div class="checkout-title">Thông tin khách hàng</div>
                            <c:if test="${not empty errorMsg}">
                                <div class="checkout-error">
                                    <i class="fa fa-exclamation-circle"></i> ${errorMsg}
                                </div>
                            </c:if>
                            <c:if test="${param.success == 'address_created'}">
                                <div class="checkout-success">
                                    <i class="fa fa-check-circle"></i> Địa chỉ đã được tạo thành công!
                                </div>
                            </c:if>
                            <c:if test="${param.success == 'address_updated'}">
                                <div class="checkout-success">
                                    <i class="fa fa-check-circle"></i> Địa chỉ đã được cập nhật thành công!
                                </div>
                            </c:if>
                            <c:if test="${param.success == 'address_deleted'}">
                                <div class="checkout-success">
                                    <i class="fa fa-check-circle"></i> Địa chỉ đã được xóa thành công!
                                </div>
                            </c:if>
                            <div class="checkout-user-info">
                                <i class="fa fa-user-circle"></i>
                                <div>
                                    <div><b>${user.username}</b></div>
                                    <div><i class="fa fa-envelope"></i> ${user.email}</div>
                                    <div><i class="fa fa-phone"></i> ${user.phone}</div>
                                </div>
                            </div>
                            
                            <form action="checkout" method="post" id="checkoutForm">
                                <!-- Địa chỉ giao hàng -->
                                <div class="form-group">
                                    <label class="checkout-label">Địa chỉ giao hàng:</label>
                                    <div class="dropdown-container">
                                        <c:choose>
                                            <c:when test="${not empty shippingAddresses}">
                                                <select name="shippingAddressID" id="shippingSelect" class="form-control">
                                                    <c:forEach var="addr" items="${shippingAddresses}" varStatus="loop">
                                                        <option value="${addr.addressID}" 
                                                                data-is-default="${addr.isDefault}"
                                                                <c:choose>
                                                                    <c:when test="${addr.isDefault}">selected</c:when>
                                                                    <c:when test="${loop.index == 0}">selected</c:when>
                                                                    <c:otherwise></c:otherwise>
                                                                </c:choose>>
                                                            <c:out value="${addr.fullAddress}" />
                                                        </option>
                                                    </c:forEach>
                                                </select>
                                                <a href="addresses?action=create&addressType=shipping" class="btn-add-address">+ Thêm địa chỉ</a>
                                            </c:when>
                                            <c:otherwise>
                                                <span style="color: #666; font-style: italic;">Bạn chưa có địa chỉ giao hàng.</span>
                                                <a href="addresses?action=create&addressType=shipping" class="btn-add-address">+ Thêm địa chỉ</a>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                                <!-- Địa chỉ thanh toán -->
                                <div class="form-group">
                                    <label class="checkout-label">Địa chỉ thanh toán:</label>
                                    <div class="dropdown-container">
                                        <c:choose>
                                            <c:when test="${not empty billingAddresses}">
                                                <select name="billingAddressID" id="billingSelect" class="form-control">
                                                    <c:forEach var="addr" items="${billingAddresses}" varStatus="loop">
                                                        <option value="${addr.addressID}" 
                                                                data-is-default="${addr.isDefault}"
                                                                <c:choose>
                                                                    <c:when test="${addr.isDefault}">selected</c:when>
                                                                    <c:when test="${loop.index == 0}">selected</c:when>
                                                                    <c:otherwise></c:otherwise>
                                                                </c:choose>>
                                                            <c:out value="${addr.fullAddress}" />
                                                        </option>
                                                    </c:forEach>
                                                </select>
                                                <a href="addresses?action=create&addressType=billing" class="btn-add-address">+ Thêm địa chỉ</a>
                                            </c:when>
                                            <c:otherwise>
                                                <span style="color: #666; font-style: italic;">Bạn chưa có địa chỉ thanh toán.</span>
                                                <a href="addresses?action=create&addressType=billing" class="btn-add-address">+ Thêm địa chỉ</a>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                                <!-- Voucher và khuyến mãi -->
                                <div class="form-group">
                                    <label class="checkout-label">Mã giảm giá:</label>
                                    <div class="voucher-container">
                                        <div class="input-group">
                                            <input type="text" id="voucherCode" name="voucherCode" class="form-control" placeholder="Nhập mã giảm giá (nếu có)">
                                            <div class="input-group-append">
                                                <button type="button" id="applyVoucher" class="btn btn-outline-primary">OK</button>
                                            </div>
                                        </div>
                                        <div id="voucherMessage" class="mt-2" style="display: none;"></div>
                                    </div>
                                </div>
                                
                                <!-- Phương thức thanh toán -->
                                <div class="form-group">
                                    <label class="checkout-label">Phương thức thanh toán:</label>
                                    <div class="dropdown-container">
                                        <select name="paymentMethodID" id="paymentSelect" class="form-control">
                                            <c:forEach var="pm" items="${paymentMethods}" varStatus="loop">
                                                <option value="${pm.paymentMethodID}" <c:if test='${loop.index == 0}'>selected</c:if>>
                                                    <c:out value="${pm.methodName}" />
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <!-- Thông tin về phương thức thanh toán -->
                                    <div id="paymentMethodInfo" class="mt-2" style="font-size: 12px; color: #666; padding: 8px; background: #f8f9fa; border-radius: 4px; display: none;">
                                        <div id="vnpayInfo" style="display: none;">
                                            <i class="fa fa-shield"></i> <strong>Thanh toán an toàn qua VNPay</strong><br>
                                            • Bảo mật thông tin thanh toán<br>
                                            • Hỗ trợ thẻ ATM, Visa, Mastercard<br>
                                            • Xác nhận thanh toán ngay lập tức
                                        </div>
                                        <div id="codInfo" style="display: none;">
                                            <i class="fa fa-money"></i> <strong>Thanh toán khi nhận hàng (COD)</strong><br>
                                            • Thanh toán bằng tiền mặt khi nhận hàng<br>
                                            • Không cần thẻ ngân hàng<br>
                                            • Kiểm tra hàng trước khi thanh toán
                                        </div>
                                    </div>
                                </div>
                                
                                                                 <!-- Ghi chú đơn hàng -->
                                 <div class="form-group">
                                     <label class="checkout-label">Ghi chú đơn hàng:</label>
                                     <textarea name="notes" id="orderNotes" class="form-control" rows="4" 
                                               placeholder="Nhập ghi chú cho đơn hàng (tùy chọn)...">${notes}</textarea>
                                 </div>
                                <div class="form-group" style="margin-top: 24px;">
                                    <button type="submit" class="btn btn-checkout"><i class="fa fa-credit-card"></i> Đặt hàng</button>
                                </div>
                            </form>
                        </div>
                    </div>
                    <div class="col-lg-5 col-md-5 col-sm-12 col-xs-12">
                        <div class="order-summary-box">
                            <div class="order-summary-title">Tóm tắt đơn hàng</div>
                            <table class="table table-bordered table-hover" style="background:#fff;">
                                <thead style="background:#f8f9fa;">
                                    <tr>
                                        <th>Ảnh</th>
                                        <th>Tên sản phẩm</th>
                                        <th>Số lượng</th>
                                        <th>Đơn giá</th>
                                        <th>Thành tiền</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="item" items="${selectedItems}">
                                        <c:set var="mainImageUrl" value="${not empty item.product.productImagesCollection ? item.product.productImagesCollection[0].imageUrl : null}" />
                                        <tr>
                                            <td><img src="${pageContext.request.contextPath}${not empty mainImageUrl ? mainImageUrl : '/assets/images/products/default.jpg'}" alt="${item.product.productName}" class="item-image"></td>
                                            <td>${item.product.productName}</td>
                                            <td>${item.quantity}</td>
                                            <td>₫<fmt:formatNumber value="${item.product.price}" type="number" groupingUsed="true"/></td>
                                            <td style="color:#ff6b6b;font-weight:600;">₫<fmt:formatNumber value="${item.product.price * item.quantity}" type="number" groupingUsed="true"/></td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                            <div style="border-top:1px solid #eee;margin:12px 0;"></div>
                            <div class="order-summary-total">Tạm tính: <span style="float:right;">₫<fmt:formatNumber value="${total}" type="number" groupingUsed="true"/></span></div>
                            
                            <!-- Voucher applied -->
                            <div id="voucherApplied" class="voucher-applied" style="display: none;">
                                <div class="voucher-info">
                                    <span class="voucher-code"></span>
                                    <span class="voucher-discount" style="float:right;color:#28a745;"></span>
                                    <button type="button" id="removeVoucher" class="btn-remove-voucher" style="margin-left: 10px; background: #dc3545; color: white; border: none; padding: 4px 8px; border-radius: 4px; font-size: 11px; cursor: pointer;">
                                        <i class="fa fa-times"></i> Xóa
                                    </button>
                                </div>
                            </div>
                            
                            <!-- Discount items -->
                            <div id="discountItems" style="display: none;">
                                <!-- Voucher discount -->
                                <div id="voucherDiscountRow" class="discount-item" style="display: none;">
                                    <span class="discount-label">Giảm giá voucher:</span>
                                    <span class="discount-amount positive">-₫<span id="voucherDiscountAmount">0</span></span>
                                </div>
                                
                                <!-- Store discount -->
                                <div id="storeDiscountRow" class="discount-item" style="display: none;">
                                    <span class="discount-label">Giảm giá cửa hàng:</span>
                                    <span class="discount-amount positive">-₫<span id="storeDiscountAmount">0</span></span>
                                </div>
                                
                                <!-- Total discount -->
                                <div id="totalDiscountRow" class="discount-item" style="display: none;">
                                    <span class="discount-label"><strong>Tổng giảm giá:</strong></span>
                                    <span class="discount-amount positive"><strong>-₫<span id="totalDiscountAmount">0</span></strong></span>
                                </div>
                            </div>
                            
                            <div>Phí vận chuyển: <span class="shipping-fee" style="float:right;">₫<fmt:formatNumber value="${shippingFee}" type="number" groupingUsed="true"/></span></div>
                            <div>Thuế (VAT): <span class="tax-amount" style="float:right;">₫<fmt:formatNumber value="${tax}" type="number" groupingUsed="true"/></span></div>
                            <div style="border-top:1px solid #eee;margin:12px 0;"></div>
                            <div class="order-summary-total" style="font-size:1.3em;">Tổng tiền cuối cùng: <span class="final-total" style="float:right;color:#ff6b6b;">₫<fmt:formatNumber value="${finalTotal}" type="number" groupingUsed="true"/></span></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- FOOTER -->
    <footer id="footer" class="footer layout-03">
        <div class="footer-content background-footer-03">
            <div class="container">
                <div class="row">
                    <div class="col-lg-4 col-md-4 col-sm-9">
                        <section class="footer-item">
                            <a href="#" class="logo footer-logo"><img src="assets/images/organic-3.png" alt="biolife logo" width="135" height="34"></a>
                            <div class="footer-phone-info">
                                <i class="biolife-icon icon-head-phone"></i>
                                <p class="r-info">
                                    <span>Got Questions ?</span>
                                    <span>(700)� 9001-1909  (900) 689 -66</span>
                                </p>
                            </div>
                            <div class="newsletter-block layout-01">
                                <h4 class="title">Newsletter Signup</h4>
                                <div class="form-content">
                                    <form action="#" name="new-letter-foter">
                                        <input type="email" class="input-text email" value="" placeholder="Your email here...">
                                        <button type="submit" class="bnt-submit" name="ok">Sign up</button>
                                    </form>
                                </div>
                            </div>
                        </section>
                    </div>
                    <div class="col-lg-4 col-md-4 col-sm-6 md-margin-top-5px sm-margin-top-50px xs-margin-top-40px">
                        <section class="footer-item">
                            <h3 class="section-title">Useful Links</h3>
                            <div class="row">
                                <div class="col-lg-6 col-sm-6 col-xs-6">
                                    <div class="wrap-custom-menu vertical-menu-2">
                                        <ul class="menu">
                                            <li><a href="#">About Us</a></li>
                                            <li><a href="#">About Our Shop</a></li>
                                            <li><a href="#">Secure Shopping</a></li>
                                            <li><a href="#">Delivery infomation</a></li>
                                            <li><a href="#">Privacy Policy</a></li>
                                            <li><a href="#">Our Sitemap</a></li>
                                        </ul>
                                    </div>
                                </div>
                                <div class="col-lg-6 col-sm-6 col-xs-6">
                                    <div class="wrap-custom-menu vertical-menu-2">
                                        <ul class="menu">
                                            <li><a href="#">Who We Are</a></li>
                                            <li><a href="#">Our Services</a></li>
                                            <li><a href="#">Projects</a></li>
                                            <li><a href="#">Contacts Us</a></li>
                                            <li><a href="#">Innovation</a></li>
                                            <li><a href="#">Testimonials</a></li>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                        </section>
                    </div>
                    <div class="col-lg-4 col-md-4 col-sm-6 md-margin-top-5px sm-margin-top-50px xs-margin-top-40px">
                        <section class="footer-item">
                            <h3 class="section-title">Transport Offices</h3>
                            <div class="contact-info-block footer-layout xs-padding-top-10px">
                                <ul class="contact-lines">
                                    <li>
                                        <p class="info-item">
                                            <i class="biolife-icon icon-location"></i>
                                            <b class="desc">7563 St. Vicent Place, Glasgow, Greater Newyork NH7689, UK </b>
                                        </p>
                                    </li>
                                    <li>
                                        <p class="info-item">
                                            <i class="biolife-icon icon-phone"></i>
                                            <b class="desc">Phone: (+067) 234 789  (+068) 222 888</b>
                                        </p>
                                    </li>
                                    <li>
                                        <p class="info-item">
                                            <i class="biolife-icon icon-letter"></i>
                                            <b class="desc">Email:  contact@company.com</b>
                                        </p>
                                    </li>
                                    <li>
                                        <p class="info-item">
                                            <i class="biolife-icon icon-clock"></i>
                                            <b class="desc">Hours: 7 Days a week from 10:00 am</b>
                                        </p>
                                    </li>
                                </ul>
                            </div>
                            <div class="biolife-social inline">
                                <ul class="socials">
                                    <li><a href="#" title="twitter" class="socail-btn"><i class="fa fa-twitter" aria-hidden="true"></i></a></li>
                                    <li><a href="#" title="facebook" class="socail-btn"><i class="fa fa-facebook" aria-hidden="true"></i></a></li>
                                    <li><a href="#" title="pinterest" class="socail-btn"><i class="fa fa-pinterest" aria-hidden="true"></i></a></li>
                                    <li><a href="#" title="youtube" class="socail-btn"><i class="fa fa-youtube" aria-hidden="true"></i></a></li>
                                    <li><a href="#" title="instagram" class="socail-btn"><i class="fa fa-instagram" aria-hidden="true"></i></a></li>
                                </ul>
                            </div>
                        </section>
                    </div>
                </div>
                <div class="row">
                    <div class="col-xs-12">
                        <div class="separator sm-margin-top-70px xs-margin-top-40px"></div>
                    </div>
                    <div class="col-lg-6 col-sm-6 col-xs-12">
                       <div class="copy-right-text"><p><a href="templateshub.net">Templates Hub</a></p></div>
                    </div>
                    <div class="col-lg-6 col-sm-6 col-xs-12">
                        <div class="payment-methods">
                            <ul>
                                <li><a href="#" class="payment-link"><img src="assets/images/card1.jpg" width="51" height="36" alt=""></a></li>
                                <li><a href="#" class="payment-link"><img src="assets/images/card2.jpg" width="51" height="36" alt=""></a></li>
                                <li><a href="#" class="payment-link"><img src="assets/images/card3.jpg" width="51" height="36" alt=""></a></li>
                                <li><a href="#" class="payment-link"><img src="assets/images/card4.jpg" width="51" height="36" alt=""></a></li>
                                <li><a href="#" class="payment-link"><img src="assets/images/card5.jpg" width="51" height="36" alt=""></a></li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </footer>

    <!--Footer For Mobile-->
    <div class="mobile-footer">
        <div class="mobile-footer-inner">
            <div class="mobile-block block-menu-main">
                <a class="menu-bar menu-toggle btn-toggle" data-object="open-mobile-menu" href="javascript:void(0)">
                    <span class="fa fa-bars"></span>
                    <span class="text">Menu</span>
                </a>
            </div>
            <div class="mobile-block block-sidebar">
                <a class="menu-bar filter-toggle btn-toggle" data-object="open-mobile-filter" href="javascript:void(0)">
                    <i class="fa fa-sliders" aria-hidden="true"></i>
                    <span class="text">Sidebar</span>
                </a>
            </div>
            <div class="mobile-block block-minicart">
                <a class="link-to-cart" href="#">
                    <span class="fa fa-shopping-bag" aria-hidden="true"></span>
                    <span class="text">Cart</span>
                </a>
            </div>
            <div class="mobile-block block-global">
                <a class="menu-bar myaccount-toggle btn-toggle" data-object="global-panel-opened" href="javascript:void(0)">
                    <span class="fa fa-globe"></span>
                    <span class="text">Global</span>
                </a>
            </div>
        </div>
    </div>

    <div class="mobile-block-global">
        <div class="biolife-mobile-panels">
            <span class="biolife-current-panel-title">Global</span>
            <a class="biolife-close-btn" data-object="global-panel-opened" href="#">&times;</a>
        </div>
        <div class="block-global-contain">
            <div class="glb-item my-account">
                <b class="title">My Account</b>
                <ul class="list">
                    <li class="list-item"><a href="#">Login/register</a></li>
                    <li class="list-item"><a href="#">Wishlist <span class="index">(8)</span></a></li>
                    <li class="list-item"><a href="#">Checkout</a></li>
                </ul>
            </div>
            <div class="glb-item currency">
                <b class="title">Currency</b>
                <ul class="list">
                    <li class="list-item"><a href="#">? EUR (Euro)</a></li>
                    <li class="list-item"><a href="#">$ USD (Dollar)</a></li>
                    <li class="list-item"><a href="#">� GBP (Pound)</a></li>
                    <li class="list-item"><a href="#">� JPY (Yen)</a></li>
                </ul>
            </div>
            <div class="glb-item languages">
                <b class="title">Language</b>
                <ul class="list inline">
                    <li class="list-item"><a href="#"><img src="assets/images/languages/us.jpg" alt="flag" width="24" height="18"></a></li>
                    <li class="list-item"><a href="#"><img src="assets/images/languages/fr.jpg" alt="flag" width="24" height="18"></a></li>
                    <li class="list-item"><a href="#"><img src="assets/images/languages/ger.jpg" alt="flag" width="24" height="18"></a></li>
                    <li class="list-item"><a href="#"><img src="assets/images/languages/jap.jpg" alt="flag" width="24" height="18"></a></li>
                </ul>
            </div>
        </div>
    </div>

    <!-- Scroll Top Button -->
    <a class="btn-scroll-top"><i class="biolife-icon icon-left-arrow"></i></a>

    <script src="assets/js/jquery-3.4.1.min.js"></script>
    <script src="assets/js/bootstrap.min.js"></script>
    <script src="assets/js/jquery.countdown.min.js"></script>
    <script src="assets/js/jquery.nice-select.min.js"></script>
    <script src="assets/js/jquery.nicescroll.min.js"></script>
    <script src="assets/js/slick.min.js"></script>
    <script src="assets/js/biolife.framework.js"></script>
    <script src="assets/js/functions.js"></script>
    <script>
    $(function(){
        // Ngăn template can thiệp vào dropdown
        $('select[name="shippingAddressID"], select[name="billingAddressID"], select[name="paymentMethodID"]').each(function() {
            $(this).off(); // Tắt tất cả event handlers từ template
            $(this).show(); // Đảm bảo hiển thị
        });
        
        // Ẩn tất cả dropdown ẩn từ template
        $('.nice-select, .select-wrapper, .hidden-select, .fake-select').hide();
        
        // Đảm bảo dropdown thật luôn hiển thị
        setTimeout(function() {
            $('select[name="shippingAddressID"], select[name="billingAddressID"], select[name="paymentMethodID"]').each(function() {
                $(this).css({
                    'display': 'inline-block',
                    'visibility': 'visible',
                    'opacity': '1',
                    'position': 'relative',
                    'z-index': '999'
                });
            });
        }, 100);
        
        // Hiện form thêm địa chỉ shipping
        $('#showAddShipping').on('click', function(){
            $('#addShippingForm').slideDown();
        });
        $('#cancelShipping').on('click', function(){
            $('#addShippingForm').slideUp();
        });
        // Hiện form thêm địa chỉ billing
        $('#showAddBilling').on('click', function(){
            $('#addBillingForm').slideDown();
        });
        $('#cancelBilling').on('click', function(){
            $('#addBillingForm').slideUp();
        });
        // Xử lý submit form thêm địa chỉ mới (demo, thực tế cần ajax hoặc submit về servlet)
        $('#saveShipping').on('click', function(){
            var val = $('input[name="shipping_fullAddress"]').val();
            if(val.trim() !== ''){
                var radio = $('<label><input type="radio" name="shippingAddressID" checked /> '+val+'</label>');
                $('.checkout-radio-list').first().append(radio);
                $('#addShippingForm').slideUp();
                $('input[name="shipping_fullAddress"]').val('');
            }
        });
        $('#saveBilling').on('click', function(){
            var val = $('input[name="billing_fullAddress"]').val();
            if(val.trim() !== ''){
                var radio = $('<label><input type="radio" name="billingAddressID" checked /> '+val+'</label>');
                $('.checkout-radio-list').eq(1).append(radio);
                $('#addBillingForm').slideUp();
                $('input[name="billing_fullAddress"]').val('');
            }
        });
        // Loading khi submit
        $('#checkoutForm').on('submit', function(){
            var btn = $(this).find('.btn-checkout');
            var original = btn.html();
            btn.html('<i class="fa fa-spinner fa-spin"></i> Đang xử lý...');
            btn.prop('disabled', true);
            setTimeout(function(){
                btn.html(original);
                btn.prop('disabled', false);
            }, 2000);
        });
        // Đảm bảo dropdown hiển thị đúng địa chỉ mặc định
        $('#shippingSelect').on('change', function() {
            // Handle shipping address change
        });
        $('#billingSelect').on('change', function() {
            // Handle billing address change
        });
        $('#paymentSelect').on('change', function() {
            // Handle payment method change
        });
        
        // Force chọn địa chỉ mặc định dựa trên isDefault
        setTimeout(function() {
            // Chọn địa chỉ shipping mặc định
            var shippingDefault = $('#shippingSelect option[data-is-default="true"]');
            if (shippingDefault.length > 0) {
                shippingDefault.prop('selected', true);
            } else {
                $('#shippingSelect option:first').prop('selected', true);
            }
            
            // Chọn địa chỉ billing mặc định
            var billingDefault = $('#billingSelect option[data-is-default="true"]');
            if (billingDefault.length > 0) {
                billingDefault.prop('selected', true);
            } else {
                $('#billingSelect option:first').prop('selected', true);
            }
            
            // Chọn payment method đầu tiên
            $('#paymentSelect option:first').prop('selected', true);
        }, 200);
        
        // Force hiển thị địa chỉ mặc định
        setTimeout(function() {
            $('#shippingSelect option:first').prop('selected', true);
            $('#billingSelect option:first').prop('selected', true);
            $('#paymentSelect option:first').prop('selected', true);
        }, 100);
        
        // Voucher functionality
        $('#applyVoucher').on('click', function() {
            var voucherCode = $('#voucherCode').val().trim();
            if (!voucherCode) {
                showVoucherMessage('Vui lòng nhập mã giảm giá', 'error');
                return;
            }
            
            // Hiển thị loading
            var btn = $(this);
            var originalText = btn.text();
            btn.html('<i class="fa fa-spinner fa-spin"></i> Đang kiểm tra...').prop('disabled', true);
            
            // Thêm hiệu ứng pulse cho button
            btn.addClass('pulse');
            
            // Simulate voucher validation (sẽ được thay thế bằng AJAX call thực tế)
            setTimeout(function() {
                validateVoucher(voucherCode);
                btn.html(originalText).prop('disabled', false);
                btn.removeClass('pulse');
            }, 1000);
        });
        
        // Enter key để apply voucher
        $('#voucherCode').on('keypress', function(e) {
            if (e.which === 13) {
                $('#applyVoucher').click();
            }
        });
        
        // Xử lý nút xóa voucher
        $(document).on('click', '#removeVoucher', function() {
            removeVoucher();
        });
        
        // Hàm validate voucher (demo - sẽ được thay thế bằng AJAX call thực tế)
        function validateVoucher(code) {
            // Demo voucher codes
            var validVouchers = {
                'SAVE5': { discount: 5, type: 'percent', minOrder: 300000 },
                'SAVE10': { discount: 10, type: 'percent', minOrder: 600000 },
                'FREESHIP': { discount: 0, type: 'freeship', minOrder: 500000 },
                'DISCOUNT50K': { discount: 50000, type: 'fixed', minOrder: 100000 }
            };
            
            var voucher = validVouchers[code.toUpperCase()];
            if (voucher) {
                var subtotal = parseInt('${total}'); // Lấy từ server
                if (subtotal >= voucher.minOrder) {
                    // Kiểm tra xem có voucher đã áp dụng chưa
                    var appliedVoucher = $('#voucherCode').data('applied-voucher');
                    if (appliedVoucher && appliedVoucher !== code.toUpperCase()) {
                        // Nếu có voucher khác đã áp dụng, xóa voucher cũ trước
                        removeVoucher();
                        setTimeout(function() {
                            applyVoucher(code, voucher);
                            showVoucherMessage('Đã thay đổi mã giảm giá thành công!', 'success');
                        }, 100);
                    } else {
                        applyVoucher(code, voucher);
                        showVoucherMessage('Áp dụng mã giảm giá thành công!', 'success');
                    }
                } else {
                    showVoucherMessage('Đơn hàng tối thiểu ' + voucher.minOrder.toLocaleString() + '₫ để sử dụng mã này', 'error');
                }
            } else {
                showVoucherMessage('Mã giảm giá không hợp lệ', 'error');
            }
        }
        
        // Hàm áp dụng voucher
        function applyVoucher(code, voucher) {
            var subtotal = parseInt('${total}');
            var storeDiscount = parseInt('${discount}') || 0;
            var voucherDiscount = 0;
            
            if (voucher.type === 'percent') {
                voucherDiscount = subtotal * (voucher.discount / 100);
            } else if (voucher.type === 'fixed') {
                voucherDiscount = voucher.discount;
            } else if (voucher.type === 'freeship') {
                voucherDiscount = 0; // Sẽ xử lý phí ship riêng
            }
            
            var totalDiscount = storeDiscount + voucherDiscount;
            
            // Hiển thị voucher đã áp dụng
            $('#voucherApplied').show();
            $('.voucher-code').text('Mã: ' + code);
            $('.voucher-discount').text('-₫' + voucherDiscount.toLocaleString());
            
            // Hiển thị discount items
            $('#discountItems').show();
            
            // Hiển thị voucher discount
            $('#voucherDiscountRow').show();
            $('#voucherDiscountAmount').text(voucherDiscount.toLocaleString());
            
            // Hiển thị store discount nếu có
            if (storeDiscount > 0) {
                $('#storeDiscountRow').show();
                $('#storeDiscountAmount').text(storeDiscount.toLocaleString());
            }
            
            // Hiển thị total discount
            $('#totalDiscountRow').show();
            $('#totalDiscountAmount').text(totalDiscount.toLocaleString());
            
            // Cập nhật tổng tiền
            updateFinalTotal(totalDiscount);
            
            // Enable input và button để cho phép chỉnh sửa
            $('#voucherCode').prop('disabled', false);
            $('#applyVoucher').prop('disabled', false).html('OK');
            
            // Lưu thông tin voucher để có thể xóa sau
            $('#voucherCode').data('applied-voucher', code);
        }
        
        // Hàm cập nhật tổng tiền cuối cùng
        function updateFinalTotal(discountAmount) {
            var subtotal = parseInt('${total}');
            var shippingFee = parseInt('${shippingFee}');
            var tax = parseInt('${tax}');
            
            var finalTotal = subtotal - discountAmount + shippingFee + tax;
            $('.final-total').text('₫' + finalTotal.toLocaleString());
            
            // Cập nhật màu sắc cho final total
            if (discountAmount > 0) {
                $('.final-total').css('color', '#28a745');
            } else {
                $('.final-total').css('color', '#ff6b6b');
            }
        }
        
        // Hàm xóa voucher
        function removeVoucher() {
            var storeDiscount = parseInt('${discount}') || 0;
            
            // Ẩn voucher applied
            $('#voucherApplied').hide();
            
            // Ẩn voucher discount row
            $('#voucherDiscountRow').hide();
            
            // Cập nhật total discount
            if (storeDiscount > 0) {
                $('#totalDiscountAmount').text(storeDiscount.toLocaleString());
            } else {
                $('#discountItems').hide();
            }
            
            // Cập nhật tổng tiền
            updateFinalTotal(storeDiscount);
            
            // Clear input và reset button
            $('#voucherCode').val('').prop('disabled', false);
            $('#applyVoucher').prop('disabled', false).html('OK');
            
            // Xóa data voucher
            $('#voucherCode').removeData('applied-voucher');
            
            showVoucherMessage('Đã xóa mã giảm giá', 'success');
        }
        
        // Hàm hiển thị message voucher
        function showVoucherMessage(message, type) {
            var messageDiv = $('#voucherMessage');
            messageDiv.removeClass('success error').addClass(type).text(message).show();
            
            setTimeout(function() {
                messageDiv.fadeOut();
            }, 3000);
        }
        
        // Xử lý textarea notes
        $('#orderNotes').on('input', function() {
            var maxLength = 500; // Giới hạn 500 ký tự
            var currentLength = $(this).val().length;
            
            if (currentLength > maxLength) {
                $(this).val($(this).val().substring(0, maxLength));
                showVoucherMessage('Ghi chú không được vượt quá 500 ký tự', 'error');
            }
            
            // Cập nhật counter ngay lập tức
            updateNotesCounter();
        });
        
        // Hàm cập nhật counter cho notes
        function updateNotesCounter() {
            var maxLength = 500;
            var currentLength = $('#orderNotes').val().length;
            var remaining = maxLength - currentLength;
            
            var counter = $('#notesCounter');
            if (counter.length === 0) {
                counter = $('<small id="notesCounter" style="color: #666; font-size: 12px; margin-top: 5px; display: block;"></small>');
                $('#orderNotes').after(counter);
            }
            
            counter.text('Còn lại: ' + remaining + ' ký tự');
            
            if (remaining < 50) {
                counter.css('color', '#ff6b6b');
            } else {
                counter.css('color', '#666');
            }
        }
        
        // Hiển thị số ký tự còn lại
        $('#orderNotes').on('keyup', function() {
            updateNotesCounter();
        });
        
        // Khởi tạo counter khi trang load
        $(document).ready(function() {
            updateNotesCounter();
            
            // Hiển thị store discount nếu có
            var storeDiscount = parseInt('${discount}') || 0;
            if (storeDiscount > 0) {
                $('#discountItems').show();
                $('#storeDiscountRow').show();
                $('#storeDiscountAmount').text(storeDiscount.toLocaleString());
                $('#totalDiscountRow').show();
                $('#totalDiscountAmount').text(storeDiscount.toLocaleString());
            }
            
            // Xử lý form submission cho VNPay payments
            $('#checkoutForm').on('submit', function(e) {
                var selectedPaymentMethod = $('#paymentSelect').val();
                
                // Kiểm tra nếu là VNPay payment (ID = 2)
                if (selectedPaymentMethod == 2) {
                    // Hiển thị thông báo cho user biết sẽ chuyển đến VNPay
                    if (!confirm('Bạn đã chọn thanh toán qua VNPay. Bạn sẽ được chuyển đến cổng thanh toán VNPay để hoàn tất thanh toán. Tiếp tục?')) {
                        e.preventDefault();
                        return false;
                    }
                    
                    // Form sẽ submit bình thường đến CheckOutServlet
                    // CheckOutServlet sẽ xử lý và redirect đến PaymentServlet
                }
                // Nếu không phải VNPay, form sẽ submit bình thường đến CheckOutServlet
            });
            
            // Hiển thị thông tin payment method khi user chọn
            $('#paymentSelect').on('change', function() {
                var selectedMethod = $(this).val();
                var infoDiv = $('#paymentMethodInfo');
                var vnpayInfo = $('#vnpayInfo');
                var codInfo = $('#codInfo');
                
                // Ẩn tất cả info trước
                vnpayInfo.hide();
                codInfo.hide();
                
                // Hiển thị info tương ứng
                if (selectedMethod == 2) { // VNPay
                    vnpayInfo.show();
                    infoDiv.show();
                } else if (selectedMethod == 1) { // COD
                    codInfo.show();
                    infoDiv.show();
                } else {
                    infoDiv.hide();
                }
            });
            
            // Trigger change event khi trang load để hiển thị info cho option đầu tiên
            $('#paymentSelect').trigger('change');
        });
    });
    </script>
</body>
</html>