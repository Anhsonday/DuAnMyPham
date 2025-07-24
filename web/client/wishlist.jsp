<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="utils.ProductImageUtil" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html class="no-js" lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="context-path" content="${pageContext.request.contextPath}">
    <title>Danh sách yêu thích - Fish Shop</title>
    
    <!-- CSS -->
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
        .wishlist-container {
            padding: 60px 0;
            background-color: #f8f9fa;
        }
        
        .wishlist-header {
            text-align: center;
            margin-bottom: 50px;
            padding: 40px 0;
            background: linear-gradient(45deg, rgba(127, 173, 57, 0.1), rgba(149, 197, 80, 0.1));
            border-radius: 20px;
            position: relative;
            overflow: hidden;
        }
        
        .wishlist-header::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(to right, #7fad39, #95c550);
        }
        
        .wishlist-header h1 {
            color: #2c3e50;
            font-size: 2.8rem;
            margin-bottom: 15px;
            font-weight: 700;
            letter-spacing: -0.5px;
            position: relative;
            display: inline-block;
        }
        
        .wishlist-header h1 i {
            background: linear-gradient(45deg, #e74c3c, #ff7675);
            -webkit-background-clip: text;
            background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-right: 10px;
        }
        
        .wishlist-header p {
            color: #666;
            font-size: 1.2rem;
            max-width: 600px;
            margin: 0 auto;
            line-height: 1.6;
        }
        
        .wishlist-item {
            background: white;
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 25px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.05);
            transition: all 0.3s ease;
            border: 1px solid rgba(0,0,0,0.05);
            position: relative;
            overflow: hidden;
        }
        
        .wishlist-item::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 4px;
            height: 100%;
            background: linear-gradient(45deg, #7fad39, #95c550);
            opacity: 0;
            transition: opacity 0.3s ease;
        }
        
        .wishlist-item:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.1);
        }
        
        .wishlist-item:hover::before {
            opacity: 1;
        }
        
        .wishlist-item-image {
            width: 180px;
            height: 180px;
            object-fit: cover;
            border-radius: 15px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            border: 4px solid white;
        }
        
        .wishlist-item-image:hover {
            transform: scale(1.05);
            box-shadow: 0 8px 25px rgba(0,0,0,0.2);
        }
        
        .wishlist-item-info h4 {
            color: #333;
            margin-bottom: 15px;
            font-size: 1.5rem;
            font-weight: 600;
            line-height: 1.4;
            transition: color 0.3s ease;
        }
        
        .wishlist-item-info h4:hover {
            color: #7fad39;
        }
        
        .product-info-wrapper {
            background: linear-gradient(to right, #f8f9fa, #ffffff);
            padding: 20px;
            border-radius: 12px;
            margin-top: 15px;
            border: 1px solid rgba(0,0,0,0.03);
            box-shadow: inset 0 1px 3px rgba(0,0,0,0.02);
        }
        
        .wishlist-item-price {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 15px;
            padding-bottom: 10px;
            border-bottom: 1px dashed #dee2e6;
        }
        
        .current-price {
            color: #7fad39;
            font-size: 1.8rem;
            font-weight: bold;
        }
        
        .original-price {
            color: #999;
            font-size: 1.2rem;
            text-decoration: line-through;
        }
        
        .discount-percent {
            background: #e74c3c;
            color: white;
            padding: 4px 12px;
            border-radius: 15px;
            font-size: 1rem;
            font-weight: bold;
        }
        
        .product-details {
            display: flex;
            flex-direction: column;
            gap: 12px;
        }
        
        .wishlist-item-volume, 
        .wishlist-item-category,
        .wishlist-item-description,
        .stock-status {
            display: flex;
            align-items: flex-start;
            gap: 10px;
            color: #666;
            font-size: 1.4rem;
            line-height: 1.4;
        }
        
        .wishlist-item-volume i,
        .wishlist-item-category i,
        .wishlist-item-description i {
            color: #7fad39;
            width: 16px;
            text-align: center;
            margin-top: 5px;
        }

        .wishlist-item-description {
            font-style: italic;
            color: #777;
        }

        .wishlist-item-description i {
            color: #6c757d;
        }
         .stock-status {
            margin-top: 15px;
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 12px 20px;
            border-radius: 15px;
            position: relative;
            flex-wrap: wrap;
        }
        
        .stock-status.in-stock {
            color: #28a745;
            background: rgba(40, 167, 69, 0.1);
            font-size: 1.5rem;
            font-weight: 600;
        }
        
        .stock-status.out-of-stock {
            color: #ff4757;
            background: rgba(255, 71, 87, 0.1);
            animation: pulse 2s infinite;
            font-size: 1.5rem;
            font-weight: 600;
        }

        .stock-status.no-stock {
            color: #6c757d;
            background: rgba(108, 117, 125, 0.1);
            font-size: 1.5rem;
            font-weight: 600;
        }
        
        .stock-status i {
            font-size: 2rem;
        }
        
        .stock-status.out-of-stock i {
            animation: flame 0.8s infinite alternate;
            color: #ff4757;
        }

        .stock-status.no-stock i {
            color: #6c757d;
        }

        .stock-desc {
            display: block;
            width: 100%;
            margin-top: 8px;
            font-size: 1.1rem;
            opacity: 0.9;
            font-weight: 500;
        }
        
        @keyframes flame {
            0% {
                text-shadow: 0 0 10px #ff4757,
                           0 0 20px #ff4757,
                           0 0 30px #ff4757;
                transform: scale(1) rotate(-5deg);
            }
            100% {
                text-shadow: 0 0 20px #ff4757,
                           0 0 30px #ff4757,
                           0 0 40px #ff6b6b;
                transform: scale(1.1) rotate(5deg);
            }
        }
        
        @keyframes pulse {
            0% {
                box-shadow: 0 0 0 0 rgba(255, 71, 87, 0.4);
            }
            70% {
                box-shadow: 0 0 0 10px rgba(255, 71, 87, 0);
            }
            100% {
                box-shadow: 0 0 0 0 rgba(255, 71, 87, 0);
            }
        }
        
        .wishlist-item-date {
            color: #999;
            font-size: 0.8rem;
        }
        
        .wishlist-actions {
            display: flex;
            gap: 12px;
            margin-top: 20px;
            padding-top: 15px;
            border-top: 1px dashed rgba(0,0,0,0.1);
        }
        
        .btn-remove-wishlist, .btn-add-to-cart {
            flex: 1;
            border: none;
            padding: 15px 25px;
            border-radius: 30px;
            cursor: pointer;
            font-weight: 600;
            letter-spacing: 0.5px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            transition: all 0.3s ease;
            text-transform: uppercase;
            font-size: 1.1rem;
        }
        
        .btn-remove-wishlist {
            background: linear-gradient(45deg, #ff4b4b, #ff6b6b);
            color: white;
            box-shadow: 0 4px 15px rgba(220, 53, 69, 0.2);
        }
        
        .btn-remove-wishlist:hover {
            background: linear-gradient(45deg, #ff3b3b, #ff5b5b);
            transform: translateY(-2px);
            box-shadow: 0 6px 18px rgba(220, 53, 69, 0.25);
        }
        
        .btn-add-to-cart {
            background: linear-gradient(45deg, #7fad39, #95c550);
            color: white;
            box-shadow: 0 4px 15px rgba(127, 173, 57, 0.2);
        }
        
        .btn-add-to-cart:hover {
            background: linear-gradient(45deg, #74a031, #89b945);
            transform: translateY(-2px);
            box-shadow: 0 6px 18px rgba(127, 173, 57, 0.25);
        }
        
        .btn-add-to-cart i, .btn-remove-wishlist i {
            font-size: 1.1rem;
        }
        
        .empty-wishlist {
            text-align: center;
            padding: 80px 20px;
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .empty-wishlist i {
            font-size: 4rem;
            color: #ddd;
            margin-bottom: 20px;
        }
        
        .empty-wishlist h3 {
            color: #666;
            margin-bottom: 15px;
        }
        
        .empty-wishlist p {
            color: #999;
            margin-bottom: 30px;
        }
        
        .wishlist-actions-top {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            padding: 20px;
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .wishlist-count {
            font-size: 1.1rem;
            color: #666;
        }
        
        .btn-clear-all {
            background-color: #dc3545;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 4px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }
        
        .btn-clear-all:hover {
            background-color: #c82333;
        }
        
        .alert {
            padding: 15px;
            margin-bottom: 20px;
            border: 1px solid transparent;
            border-radius: 4px;
        }
        
        .alert-success {
            color: #155724;
            background-color: #d4edda;
            border-color: #c3e6cb;
        }
        
        .alert-danger {
            color: #721c24;
            background-color: #f8d7da;
            border-color: #f5c6cb;
        }
        
        @media (max-width: 768px) {
            .wishlist-item {
                padding: 15px;
            }
            
            .wishlist-item-image {
                width: 80px;
                height: 80px;
            }
            
            .wishlist-item-info h4 {
                font-size: 1.1rem;
            }
            
            .wishlist-actions {
                flex-direction: column;
            }
            
            .wishlist-actions-top {
                flex-direction: column;
                gap: 15px;
                text-align: center;
            }
        }

        /* Loading styles */
        .loading {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);
            display: none;
            justify-content: center;
            align-items: center;
            z-index: 9999;
        }
        
        .loading-spinner {
            background: white;
            padding: 20px;
            border-radius: 5px;
            text-align: center;
        }
        
        .loading-spinner i {
            color: #7fad39;
            font-size: 24px;
        }
    </style>
</head>

<body class="biolife-body">
    <!-- HEADER -->
    <jsp:include page="../header.jsp"></jsp:include>

    <!-- Main Content -->
    <div class="page-contain wishlist-container">
        <div class="container">
            <!-- Alert Container -->
            <div id="alert-container"></div>
            
            <!-- Wishlist Header -->
            <div class="wishlist-header">
                <h1><i class="fa fa-heart" style="color: #e74c3c;"></i> Danh sách yêu thích</h1>
                <p>Những sản phẩm bạn đã lưu để mua sau</p>
            </div>
            
            <!-- Wishlist Content -->
            <c:choose>
                <c:when test="${not empty wishlist and fn:length(wishlist) > 0}">
                    <!-- Wishlist Actions -->
                    <div class="wishlist-actions-top">
                        <div class="wishlist-count">
                            <strong>Bạn có <span id="wishlist-count">${wishlistCount}</span> sản phẩm yêu thích</strong>
                        </div>
                        <c:if test="${wishlistCount > 0}">
                            <button type="button" class="btn-clear-all" onclick="clearAllWishlist()">
                                <i class="fa fa-trash"></i> Xóa tất cả
                            </button>
                        </c:if>
                    </div>
                    
                    <!-- Wishlist Items -->
                    <div id="wishlist-items">
                        <c:forEach var="item" items="${wishlist}">
                            <div class="wishlist-item" data-wishlist-id="${item.wishlistId}" data-product-id="${item.productId.productId}">
                                <div class="row align-items-center">
                                    <div class="col-md-2">
                                        <c:choose>
                                            <c:when test="${not empty ProductImageUtil.getMainImageUrl(item.productId)}">
                                                <img src="${pageContext.request.contextPath}${ProductImageUtil.getMainImageUrl(item.productId)}" 
                                                     alt="${item.productId.productName}" 
                                                     class="wishlist-item-image">
                                            </c:when>
                                            <c:otherwise>
                                                <img src="${pageContext.request.contextPath}/assets/images/products/no-image.png" 
                                                     alt="No image" 
                                                     class="wishlist-item-image">
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="wishlist-item-info">
                                            <h4>${item.productId.productName}</h4>
                                            <div class="product-info-wrapper">
                                                <div class="wishlist-item-price">
                                                    <c:choose>
                                                        <c:when test="${item.productId.salePrice != null && item.productId.salePrice > 0 && item.productId.salePrice < item.productId.price}">
                                                            <span class="current-price">
                                                                <fmt:formatNumber value="${item.productId.salePrice}" type="number" maxFractionDigits="0"/>đ
                                                            </span>
                                                            <span class="original-price">
                                                                <fmt:formatNumber value="${item.productId.price}" type="number" maxFractionDigits="0"/>đ
                                                            </span>
                                                            <span class="discount-percent">
                                                                -<fmt:formatNumber value="${(item.productId.price - item.productId.salePrice) / item.productId.price * 100}" pattern="#0"/>%
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="current-price">
                                                                <fmt:formatNumber value="${item.productId.price}" type="number" maxFractionDigits="0"/>đ
                                                            </span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                                <div class="product-details">
                                                    <c:if test="${not empty item.productId.quantityValue}">
                                                        <div class="wishlist-item-volume">
                                                            <i class="fa fa-flask"></i>
                                                            <span>Thể tích: ${item.productId.quantityValue} ${item.productId.quantityUnit}</span>
                                                        </div>
                                                    </c:if>
                                                    <c:if test="${not empty item.productId.categoryId}">
                                                        <div class="wishlist-item-category">
                                                            <i class="fa fa-tag"></i>
                                                            <span>${item.productId.categoryId.categoryName}</span>
                                                        </div>
                                                    </c:if>
                                                    <c:if test="${not empty item.productId.shortDescription}">
                                                        <div class="wishlist-item-description">
                                                            <i class="fa fa-info-circle"></i>
                                                            <span>${item.productId.shortDescription}</span>
                                                        </div>
                                                    </c:if>
                                                    
                                                    <div class="stock-status ${item.productId.stock > 10 ? 'in-stock' : (item.productId.stock == 0 ? 'no-stock' : 'out-of-stock')}">
                                                        <i class="fa ${item.productId.stock > 10 ? 'fa-check-circle' : (item.productId.stock == 0 ? 'fa-times-circle' : 'fa-fire')}"></i>
                                                        <span>
                                                            ${item.productId.stock > 10 ? 'Còn hàng' : (item.productId.stock == 0 ? 'Hết hàng' : 'Cháy hàng!')}
                                                        </span>
                                                        <span class="stock-desc">
                                                            ${item.productId.stock > 10 ? 'Sẵn sàng giao hàng' : (item.productId.stock == 0 ? 'Tạm thời hết hàng' : 'Số lượng còn rất ít, nhanh tay đặt hàng!')}
                                                        </span>
                                                    </div>
                                                </div>
                                            </div>
                                            
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="wishlist-actions">
                                            <c:if test="${item.productId.stock > 0}">
                                                <button type="button" class="btn-add-to-cart" onclick="addToCart('${item.productId.productId}')">
                                                    <i class="fa fa-shopping-cart"></i> Thêm vào giỏ
                                                </button>
                                            </c:if>
                                            <c:if test="${item.productId.stock <= 0}">
                                                <span class="text-muted">Hết hàng</span>
                                            </c:if>
                                            <button type="button" class="btn-remove-wishlist" onclick="removeFromWishlist('${item.wishlistId}', '${item.productId.productId}')">
                                                <i class="fa fa-trash"></i> Xóa
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <!-- Empty Wishlist -->
                    <div class="empty-wishlist">
                        <i class="fa fa-heart-o"></i>
                        <h3>Danh sách yêu thích của bạn đang trống</h3>
                        <p>Hãy khám phá và thêm những sản phẩm yêu thích của bạn vào đây!</p>
                        <a href="${pageContext.request.contextPath}/home" class="continue-shopping">
                            <i class="fa fa-shopping-bag"></i> Khám phá sản phẩm
                        </a>
                    </div>

                    <style>
                    .empty-wishlist {
                        text-align: center;
                        padding: 60px 0;
                        background: rgba(127, 173, 57, 0.05);
                        border-radius: 20px;
                        box-shadow: 0 10px 30px rgba(0, 0, 0, 0.05);
                    }
                    
                    .empty-wishlist i {
                        font-size: 5rem;
                        background: linear-gradient(45deg, #7fad39, #95c550);
                        -webkit-background-clip: text;
                        background-clip: text;
                        -webkit-text-fill-color: transparent;
                        margin-bottom: 25px;
                        display: block;
                        animation: float 3s ease-in-out infinite;
                    }
                    
                    @keyframes float {
                        0%, 100% { transform: translateY(0); }
                        50% { transform: translateY(-10px); }
                    }
                    
                    .empty-wishlist h3 {
                        color: #2c3e50;
                        font-size: 1.8rem;
                        margin-bottom: 15px;
                        font-weight: 600;
                    }
                    
                    .empty-wishlist p {
                        color: #666;
                        font-size: 1.1rem;
                        margin-bottom: 30px;
                        max-width: 500px;
                        margin-left: auto;
                        margin-right: auto;
                        line-height: 1.6;
                    }
                    
                    .empty-wishlist .continue-shopping {
                        display: inline-block;
                        padding: 15px 40px;
                        background: linear-gradient(45deg, #7fad39, #95c550);
                        color: white;
                        text-decoration: none;
                        border-radius: 30px;
                        font-weight: 600;
                        font-size: 1.1rem;
                        transition: all 0.3s;
                        box-shadow: 0 5px 15px rgba(127, 173, 57, 0.3);
                    }
                    
                    .empty-wishlist .continue-shopping:hover {
                        transform: translateY(-2px);
                        box-shadow: 0 8px 20px rgba(127, 173, 57, 0.4);
                    }
                    
                    .empty-wishlist .continue-shopping:active {
                        transform: translateY(0);
                        box-shadow: 0 4px 12px rgba(127, 173, 57, 0.3);
                    }
                    
                    .empty-wishlist .continue-shopping i {
                        font-size: 1rem;
                        margin-right: 8px;
                        background: none;
                        -webkit-background-clip: initial;
                        background-clip: initial;
                        -webkit-text-fill-color: initial;
                        color: white;
                        display: inline;
                        margin-bottom: 0;
                        animation: none;
                    }
                    </style>
                </c:otherwise>
            </c:choose>

            <!-- Loading Indicator -->
            <div class="loading">
                <div class="loading-spinner">
                    <i class="fa fa-spinner fa-spin"></i>
                    <span>Đang xử lý...</span>
                </div>
            </div>
        </div>
    </div>

    <!-- FOOTER -->
    <jsp:include page="../footer.jsp"></jsp:include>

    <!-- Scripts -->
    <script src="assets/js/jquery-3.4.1.min.js"></script>
    <script src="assets/js/bootstrap.min.js"></script>
    <script src="assets/js/jquery.countdown.min.js"></script>
    <script src="assets/js/jquery.nice-select.min.js"></script>
    <script src="assets/js/jquery.nicescroll.min.js"></script>
    <script src="assets/js/slick.min.js"></script>
    <script src="assets/js/biolife.framework.js"></script>
    <script src="assets/js/functions.js"></script>

    <!-- Custom Script -->
    <script>
        // Hàm xóa sản phẩm khỏi wishlist
        function removeFromWishlist(wishlistId, productId) {
            if (!confirm('Bạn có chắc chắn muốn xóa sản phẩm này khỏi danh sách yêu thích?')) {
                return;
            }
            
            showLoading();
            
            $.ajax({
                url: '${pageContext.request.contextPath}/wishlist/toggle',
                type: 'POST',
                data: {
                    productId: productId
                },
                success: function(response) {
                    hideLoading();
                    if (response.success) {
                        // Xóa element khỏi DOM
                        $('.wishlist-item[data-wishlist-id="' + wishlistId + '"]').fadeOut(300, function() {
                            $(this).remove();
                            updateWishlistCount();
                            showAlert('Đã xóa sản phẩm khỏi danh sách yêu thích!', 'success');
                        });
                    } else {
                        showAlert('Có lỗi xảy ra khi xóa sản phẩm!', 'error');
                    }
                },
                error: function(xhr, status, error) {
                    hideLoading();
                    console.error('Error:', xhr.responseText);
                    showAlert('Có lỗi xảy ra khi xóa sản phẩm!', 'error');
                }
            });
        }
        
        // Hàm xóa tất cả wishlist
        function clearAllWishlist() {
            if (!confirm('Bạn có chắc chắn muốn xóa tất cả sản phẩm khỏi danh sách yêu thích?')) {
                return;
            }
            
            showLoading();
            
            $.ajax({
                url: '${pageContext.request.contextPath}/wishlist/clear-all',
                type: 'POST',
                success: function(response) {
                    hideLoading();
                    if (response.success) {
                        // Xóa tất cả elements khỏi DOM
                        $('#wishlist-items').fadeOut(300, function() {
                            $(this).empty();
                            // Hiển thị empty state
                            var emptyHtml = `
                                <div class="empty-wishlist">
                                    <i class="fa fa-heart-o"></i>
                                    <h3>Danh sách yêu thích của bạn đang trống</h3>
                                    <p>Hãy khám phá và thêm những sản phẩm yêu thích của bạn vào đây!</p>
                                    <a href="${pageContext.request.contextPath}/home" class="continue-shopping">
                                        <i class="fa fa-shopping-bag"></i> Khám phá sản phẩm
                                    </a>
                                </div>
                            `;
                            $(this).html(emptyHtml).fadeIn(300);
                        });
                        updateWishlistCount();
                        showAlert('Đã xóa tất cả sản phẩm khỏi danh sách yêu thích!', 'success');
                    } else {
                        showAlert('Có lỗi xảy ra khi xóa tất cả sản phẩm!', 'error');
                    }
                },
                error: function(xhr, status, error) {
                    hideLoading();
                    console.error('Error:', xhr.responseText);
                    showAlert('Có lỗi xảy ra khi xóa tất cả sản phẩm!', 'error');
                }
            });
        }
        
        // Hàm thêm vào giỏ hàng
        function addToCart(productId) {
            var isLoggedIn = "${not empty sessionScope.user}" === "true";
            if (!isLoggedIn) {
                window.location.href = '${pageContext.request.contextPath}/login';
                return;
            }
            
            showLoading();
            
            $.ajax({
                url: '${pageContext.request.contextPath}/cart',
                type: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                    'X-Requested-With': 'XMLHttpRequest'
                },
                data: 'action=add&productID=' + encodeURIComponent(productId) + '&quantity=1',
                success: function(response) {
                    hideLoading();
                    console.log('Cart response:', response);
                    if ((typeof response.success === 'undefined' && typeof response.cartCount !== 'undefined') || response.success) {
                        updateCartBadge(response.cartCount);
                        showAlert('Đã thêm sản phẩm vào giỏ hàng!', 'success');
                    } else {
                        showAlert((response && response.message) ? response.message : 'Có lỗi xảy ra, vui lòng thử lại!', 'error');
                    }
                },
                error: function(xhr, status, error) {
                    hideLoading();
                    console.error('Cart error:', xhr.responseText);
                    showAlert('Có lỗi xảy ra, vui lòng thử lại!', 'error');
                }
            });
        }
        
        // Hàm cập nhật số lượng wishlist
        function updateWishlistCount() {
            $.ajax({
                url: '${pageContext.request.contextPath}/wishlist/count',
                type: 'GET',
                success: function(response) {
                    var count = response.count || 0;
                    $('#wishlist-count').text(count);
                    
                    // Cập nhật badge trong header
                    var badge = document.getElementById('wishlist-count-badge');
                    if (badge) {
                        badge.textContent = count;
                        badge.style.display = count > 0 ? 'inline-block' : 'none';
                    }
                },
                error: function() {
                    console.log('Không thể cập nhật số lượng wishlist');
                }
            });
        }
        
        // Hàm cập nhật badge giỏ hàng
        function updateCartBadge(count) {
            var badges = document.querySelectorAll('#cart-badge');
            badges.forEach(function(badge) {
                badge.textContent = count;
                badge.style.display = count > 0 ? 'inline-block' : 'none';
            });
        }
        
        // Hàm hiển thị loading
        function showLoading() {
            $('.loading').show();
        }
        
        // Hàm ẩn loading
        function hideLoading() {
            $('.loading').hide();
        }
        
        // Hàm hiển thị alert
        function showAlert(message, type) {
            type = type || 'success';
            var alertClass = type === 'success' ? 'alert-success' : 'alert-danger';
            var alertHtml = `
                <div class="alert ${alertClass} alert-dismissible fade show" role="alert">
                    ${message}
                    <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
            `;
            
            $('#alert-container').html(alertHtml);
            
            // Tự động ẩn sau 3 giây
            setTimeout(function() {
                $('.alert').fadeOut(300, function() {
                    $(this).remove();
                });
            }, 3000);
        }
        
        // Khởi tạo khi trang load
        $(document).ready(function() {
            // Load wishlist count khi trang load
            updateWishlistCount();
        });
    </script>
</body>
</html>
