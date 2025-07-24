<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="utils.ProductImageUtil" %>
<!DOCTYPE html>
<html class="no-js" lang="en">

<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Beauty Store - Mỹ Phẩm Cao Cấp</title>
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
        /* Hiệu ứng hover cho sản phẩm */
        .cart_item:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.1);
            transition: all 0.3s ease;
        }
        
        /* Hiệu ứng cho nút */
        .btn {
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }
        
        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }
        
        .btn::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
            transition: left 0.5s;
        }
        
        .btn:hover::before {
            left: 100%;
        }
        
        /* Hiệu ứng cho checkbox */
        .item-checkbox {
            transform: scale(1.2);
            transition: all 0.2s ease;
        }
        
        .item-checkbox:checked {
            animation: pulse 0.3s ease;
        }
        
        @keyframes pulse {
            0% { transform: scale(1.2); }
            50% { transform: scale(1.4); }
            100% { transform: scale(1.2); }
        }
        
        /* Hiệu ứng cho quantity input */
        .qty-input-get {
            transition: all 0.3s ease;
            border: 2px solid #e8e8e8;
        }
        
        .qty-input-get:focus {
            border-color: #ff6b6b;
            box-shadow: 0 0 10px rgba(255,107,107,0.3);
        }
        
        /* Hiệu ứng cho remove button */
        .btn-remove {
            transition: all 0.3s ease;
            background: linear-gradient(45deg, #ff6b6b, #ff8e8e);
            border: none;
            color: white;
            border-radius: 50%;
            width: 35px;
            height: 35px;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .btn-remove:hover {
            transform: scale(1.1) rotate(5deg);
            background: linear-gradient(45deg, #ff5252, #ff6b6b);
        }
        
        /* Hiệu ứng cho page title */
        .page-title {
            background: linear-gradient(45deg, #ff6b6b, #ff8e8e, #ff6b6b);
            background-size: 200% 200%;
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            animation: gradient 3s ease infinite;
        }
        
        @keyframes gradient {
            0% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
            100% { background-position: 0% 50%; }
        }
        
        /* Hiệu ứng cho subtotal */
        .stt-price {
            font-size: 1.2em;
            font-weight: bold;
            color: #ff6b6b;
            text-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        
        /* Hiệu ứng loading */
        .loading-spinner {
            display: inline-block;
            width: 20px;
            height: 20px;
            border: 3px solid #f3f3f3;
            border-top: 3px solid #ff6b6b;
            border-radius: 50%;
            animation: spin 1s linear infinite;
        }
        
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
        
        /* Hiệu ứng cho empty cart */
        .empty-cart {
            text-align: center;
            padding: 60px 20px;
            background: linear-gradient(135deg, #f8f9fa, #e9ecef);
            border-radius: 15px;
            margin: 20px 0;
        }
        
        .empty-cart h3 {
            color: #6c757d;
            margin-bottom: 20px;
            font-size: 1.5em;
        }
        
        .empty-cart .btn {
            background: linear-gradient(45deg, #ff6b6b, #ff8e8e);
            color: white;
            padding: 12px 30px;
            border-radius: 25px;
            text-decoration: none;
            display: inline-block;
            margin-top: 20px;
            font-weight: bold;
        }
        
        /* Hiệu ứng cho product images */
        .prd-thumb img {
            transition: all 0.3s ease;
            border-radius: 8px;
        }
        
        .prd-thumb:hover img {
            transform: scale(1.05);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }
        
        /* Hiệu ứng cho checkout button */
        .btn.checkout {
            background: linear-gradient(45deg, #28a745, #20c997);
            color: white;
            border: none;
            padding: 12px 30px;
            border-radius: 25px;
            font-weight: bold;
            text-transform: uppercase;
            letter-spacing: 1px;
            transition: all 0.3s ease;
            cursor: pointer;
        }
        
        .btn.checkout:hover {
            background: linear-gradient(45deg, #20c997, #28a745);
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(40,167,69,0.3);
        }
        
        /* Trạng thái disabled cho checkout button */
        .btn.checkout.disabled {
            background: linear-gradient(45deg, #6c757d, #495057);
            color: #adb5bd;
            cursor: not-allowed;
            opacity: 0.6;
            transform: none;
            box-shadow: none;
        }
        
        .btn.checkout.disabled:hover {
            background: linear-gradient(45deg, #6c757d, #495057);
            transform: none;
            box-shadow: none;
        }
        
        /* Hiệu ứng animation khi kích hoạt nút checkout */
        .btn.checkout.activated {
            animation: checkoutActivated 0.5s ease;
        }
        
        @keyframes checkoutActivated {
            0% { transform: scale(1); }
            50% { transform: scale(1.05); }
            100% { transform: scale(1); }
        }
        
        /* Hiệu ứng shake cho nút checkout khi bị từ chối */
        .btn.checkout.shake {
            animation: shake 0.6s ease-in-out;
        }
        
        @keyframes shake {
            0%, 100% { transform: translateX(0); }
            10%, 30%, 50%, 70%, 90% { transform: translateX(-5px); }
            20%, 40%, 60%, 80% { transform: translateX(5px); }
        }
    </style>
</head>
<body class="biolife-body">

<c:if test="${not empty errorMsg}">
    <div class="alert alert-danger" style="margin: 20px 0; font-size: 1.1em;">
        <c:out value="${errorMsg}" />
    </div>
</c:if>
<c:if test="${not empty successMsg}">
    <div class="alert alert-success" style="margin: 20px 0; font-size: 1.1em;">
        <c:out value="${successMsg}" />
    </div>
</c:if>

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
        <h1 class="page-title">Mỹ Phẩm Cao Cấp</h1>
    </div>

    <!--Navigation section-->
    <div class="container">
        <nav class="biolife-nav">
            <ul>
                <li class="nav-item"><a href="home" class="permal-link">Trang chủ</a></li>
                <li class="nav-item"><span class="current-page">Giỏ hàng</span></li>
            </ul>
        </nav>
    </div>

    <div class="page-contain shopping-cart">

        <!-- Main content -->
        <div id="main-content" class="main-content">
            <div class="container">

                <!--Top banner-->
                <div class="top-banner background-top-banner-for-shopping min-height-346px" style="background: linear-gradient(135deg, #ff6b9d, #c44569, #ff6b9d); position: relative; overflow: hidden; border-radius: 20px; margin: 20px 0;">
                    <!-- Background decorative elements -->
                    <div style="position: absolute; top: -50px; right: -50px; width: 200px; height: 200px; background: rgba(255,255,255,0.1); border-radius: 50%;"></div>
                    <div style="position: absolute; bottom: -30px; left: -30px; width: 150px; height: 150px; background: rgba(255,255,255,0.08); border-radius: 50%;"></div>
                    
                    <!-- Main content -->
                    <div style="position: relative; z-index: 2; padding: 40px; text-align: center; color: white;">
                        <!-- Beauty icons -->
                        <div style="margin-bottom: 20px;">
                            <i class="fa fa-heart" style="font-size: 24px; margin: 0 10px; color: #ffeaa7;"></i>
                            <i class="fa fa-star" style="font-size: 24px; margin: 0 10px; color: #ffeaa7;"></i>
                            <i class="fa fa-diamond" style="font-size: 24px; margin: 0 10px; color: #ffeaa7;"></i>
                        </div>
                        
                        <h3 class="title" style="font-size: 2.5em; font-weight: 700; margin-bottom: 15px; text-shadow: 2px 2px 4px rgba(0,0,0,0.3);">
                            ✨ Làm Đẹp Từ Thiên Nhiên ✨
                        </h3>
                        
                        <p class="subtitle" style="font-size: 1.2em; margin-bottom: 30px; opacity: 0.95; line-height: 1.6;">
                            Khám phá bộ sưu tập mỹ phẩm cao cấp với thành phần tự nhiên, an toàn cho làn da của bạn
                        </p>
                        
                        <!-- Features -->
                        <div style="display: flex; justify-content: center; gap: 30px; margin-bottom: 30px; flex-wrap: wrap;">
                            <div style="text-align: center; background: rgba(255,255,255,0.15); padding: 15px 20px; border-radius: 15px; backdrop-filter: blur(10px);">
                                <i class="fa fa-leaf" style="font-size: 20px; color: #ffeaa7; margin-bottom: 8px; display: block;"></i>
                                <span style="font-weight: 600;">100% Tự Nhiên</span>
                            </div>
                            <div style="text-align: center; background: rgba(255,255,255,0.15); padding: 15px 20px; border-radius: 15px; backdrop-filter: blur(10px);">
                                <i class="fa fa-shield" style="font-size: 20px; color: #ffeaa7; margin-bottom: 8px; display: block;"></i>
                                <span style="font-weight: 600;">An Toàn</span>
                            </div>
                            <div style="text-align: center; background: rgba(255,255,255,0.15); padding: 15px 20px; border-radius: 15px; backdrop-filter: blur(10px);">
                                <i class="fa fa-truck" style="font-size: 20px; color: #ffeaa7; margin-bottom: 8px; display: block;"></i>
                                <span style="font-weight: 600;">Miễn Phí Vận Chuyển</span>
                            </div>
                        </div>
                        
                        <!-- Special offer -->
                        <div style="background: rgba(255,255,255,0.2); padding: 20px; border-radius: 15px; margin-bottom: 25px; border: 2px solid rgba(255,255,255,0.3);">
                            <h4 style="font-size: 1.4em; margin-bottom: 10px; color: #ffeaa7;">
                                🎉 Ưu Đãi Đặc Biệt
                            </h4>
                            <p style="margin-bottom: 15px; font-size: 1.1em;">
                                Giảm <strong style="color: #ffeaa7;">20%</strong> cho đơn hàng đầu tiên + 
                                <strong style="color: #ffeaa7;">Miễn phí vận chuyển</strong> cho đơn từ 500K
                            </p>
                        </div>
                        
                        <!-- Action buttons -->
                        <div style="display: flex; justify-content: center; gap: 20px; flex-wrap: wrap;">
                            <a href="#" class="btn" style="background: linear-gradient(45deg, #ffeaa7, #fdcb6e); color: #2d3436; padding: 15px 30px; border-radius: 25px; text-decoration: none; font-weight: 600; font-size: 1.1em; transition: all 0.3s ease; box-shadow: 0 5px 15px rgba(0,0,0,0.2);">
                                <i class="fa fa-shopping-cart" style="margin-right: 8px;"></i>
                                Mua Sắm Ngay
                            </a>
                            <a href="#" class="btn" style="background: rgba(255,255,255,0.2); color: white; padding: 15px 30px; border-radius: 25px; text-decoration: none; font-weight: 600; font-size: 1.1em; transition: all 0.3s ease; border: 2px solid rgba(255,255,255,0.3);">
                                <i class="fa fa-gift" style="margin-right: 8px;"></i>
                                Khám Phá Bộ Sưu Tập
                            </a>
                        </div>
                        
                        <!-- Bottom decorative -->
                        <div style="margin-top: 30px; opacity: 0.7;">
                            <span style="font-size: 0.9em;">✨ Chăm sóc làn da của bạn với tình yêu và sự tận tâm ✨</span>
                        </div>
                    </div>
                </div>

                <!--Cart Table-->
                <div class="shopping-cart-container">
                    <div class="row">
                        <div class="col-lg-9 col-md-12 col-sm-12 col-xs-12">
                            <c:choose>
                                <c:when test="${not empty items}">
                                    <h3 class="box-title">Giỏ hàng của bạn</h3>
                                    <form class="shopping-cart-form" action="#" method="post">
                                        <table class="shop_table cart-form">
                                            <thead>
                                            <tr>
                                                <th><input type="checkbox" id="selectAll" /> Chọn tất cả</th>
                                                <th class="product-name">Sản Phẩm</th>
                                                <th class="product-price">Giá Tiền</th>
                                                <th class="product-quantity">Số lượng</th>
                                                <th class="product-subtotal">Tổng tiền</th>
                                                <th>Remove</th>
                                            </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="item" items="${items}">
                                                    <c:set var="p" value="${item.product}" />
                                                    <c:set var="mainImageUrl" value="${not empty item.product.productImagesCollection ? item.product.productImagesCollection[0].imageUrl : null}" />
                                                    <span style="display:none">[DEBUG] mainImageUrl: <c:out value="${mainImageUrl}"/></span>
                                                    <tr class="cart_item cart-row" data-id="${item.cartItemID}">
                                                        <td>
                                                            <input 
                                                                type="checkbox" 
                                                                class="item-checkbox"
                                                                id="cb_${item.cartItemID}"
                                                                <c:if test="${item.status eq 'selected'}">checked</c:if>
                                                            />
                                                        </td>
                                                        <td class="product-thumbnail" data-title="Product Name">
                                                            <a class="prd-thumb" href="#">
                                                                <figure>
                                                                    <img width="113" height="113"
                                                                        src="${pageContext.request.contextPath}${not empty mainImageUrl ? mainImageUrl : '/assets/images/products/default.jpg'}"
                                                                        alt="${item.product.productName}" class="item-image">
                                                                    <span style="display:none">[DEBUG] img src: <c:out value="${not empty mainImageUrl ? (fn:startsWith(mainImageUrl, '/') ? mainImageUrl : '/images/product/' + mainImageUrl) : '/assets/images/products/default.jpg'}"/></span>
                                                                </figure>
                                                            </a>
                                                            <a class="prd-name" href="#">${p.productName}</a>
                                                        </td>
                                                        <td class="product-price" data-title="Price">
                                                            <div class="price price-contain">
                                                                <ins>
                                                                    <span class="price-amount">
                                                                        <c:choose>
                                                                            <c:when test="${p.salePrice != null && p.salePrice > 0 && p.salePrice < p.price}">
                                                                                <fmt:formatNumber value="${p.salePrice}" type="number" groupingUsed="true"/>₫
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                <fmt:formatNumber value="${p.price}" type="number" groupingUsed="true"/>₫
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                    </span>
                                                                </ins>
                                                                <c:if test="${p.salePrice != null && p.salePrice > 0 && p.salePrice < p.price}">
                                                                    <del style="color:#888;font-size:0.95em;margin-left:6px;">
                                                                        <fmt:formatNumber value="${p.price}" type="number" groupingUsed="true"/>₫
                                                                    </del>
                                                                </c:if>
                                                            </div>
                                                        </td>
                                                        <td class="product-quantity" data-title="Quantity">
                                                            <div class="quantity-box type1">
                                                                <div class="qty-input">
                                                                    <input 
                                                                        type="number" 
                                                                        min="1" 
                                                                        class="qty-input-get" 
                                                                        id="qty_${item.cartItemID}" 
                                                                        value="${item.quantity}"
                                                                        data-price="${(p.salePrice != null && p.salePrice > 0 && p.salePrice < p.price) ? p.salePrice : p.price}"
                                                                    />
                                                                </div>
                                                            </div>
                                                        </td>
                                                        <td class="product-subtotal" data-title="Total">
                                                            <div class="price price-contain">
                                                                <ins>
                                                                    <span class="price-amount">
                                                                        <c:choose>
                                                                            <c:when test="${p.salePrice != null && p.salePrice > 0 && p.salePrice < p.price}">
                                                                                <fmt:formatNumber value="${p.salePrice * item.quantity}" type="number" groupingUsed="true"/>₫
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                <fmt:formatNumber value="${p.price * item.quantity}" type="number" groupingUsed="true"/>₫
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                    </span>
                                                                </ins>
                                                            </div>
                                                        </td>
                                                        <td>
                                                            <button type="button" class="btn btn-remove"
                                                                    onclick="removeItem('${item.cartItemID}')">
                                                                <i class="fa fa-trash-o" aria-hidden="true"></i>
                                                            </button>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </form>
                                </c:when>
                                <c:otherwise>
                                    <div class="empty-cart-container" style="text-align: center; padding: 80px 20px; background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%); border-radius: 20px; margin: 40px 0; box-shadow: 0 10px 30px rgba(0,0,0,0.1);">
                                        <div class="empty-cart-icon" style="font-size: 80px; margin-bottom: 20px; color: #ff6b6b;">
                                            🛒
                                        </div>
                                        <h3 style="color: #333; font-size: 28px; font-weight: 600; margin-bottom: 15px; text-shadow: 0 2px 4px rgba(0,0,0,0.1);">
                                            Giỏ hàng trống
                                        </h3>
                                        <p style="color: #666; font-size: 16px; margin-bottom: 30px; line-height: 1.6;">
                                            Bạn chưa có sản phẩm nào trong giỏ hàng.<br>
                                            Hãy khám phá các sản phẩm tuyệt vời của chúng tôi!
                                        </p>
                                        <a href="home" class="btn btn-shopping" style="
                                            background: linear-gradient(45deg, #ff6b6b, #ff8e8e);
                                            color: white;
                                            padding: 15px 40px;
                                            border-radius: 50px;
                                            text-decoration: none;
                                            font-weight: 600;
                                            font-size: 16px;
                                            display: inline-block;
                                            transition: all 0.3s ease;
                                            box-shadow: 0 5px 15px rgba(255,107,107,0.3);
                                            border: none;
                                            position: relative;
                                            overflow: hidden;
                                        ">
                                            <i class="fa fa-shopping-cart" style="margin-right: 8px;"></i>
                                            Mua sắm ngay
                                        </a>
                                        <style>
                                            .btn-shopping:hover {
                                                transform: translateY(-3px);
                                                box-shadow: 0 8px 25px rgba(255,107,107,0.4);
                                                background: linear-gradient(45deg, #ff5252, #ff6b6b);
                                            }
                                            .btn-shopping::before {
                                                content: '';
                                                position: absolute;
                                                top: 0;
                                                left: -100%;
                                                width: 100%;
                                                height: 100%;
                                                background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
                                                transition: left 0.5s;
                                            }
                                            .btn-shopping:hover::before {
                                                left: 100%;
                                            }
                                            .empty-cart-container {
                                                animation: fadeInUp 0.6s ease-out;
                                            }
                                            @keyframes fadeInUp {
                                                from {
                                                    opacity: 0;
                                                    transform: translateY(30px);
                                                }
                                                to {
                                                    opacity: 1;
                                                    transform: translateY(0);
                                                }
                                            }
                                        </style>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="col-lg-3 col-md-12 col-sm-12 col-xs-12">
                            <div class="shpcart-subtotal-block">
                                <div class="subtotal-line">
                                    <b class="stt-name">Subtotal (<span class="sub stt-quantity">${selectedQuantity} sản phẩm</span>)</b>
                                    <span class="stt-price"><fmt:formatNumber value="${selectedTotal}" type="number" groupingUsed="true"/>₫</span>
                                </div>
                                <div class="btn-checkout">
                                    <a href="#" class="btn checkout disabled" id="checkoutBtn">Mua hàng</a>
                                </div>
                                <div class="biolife-progress-bar">
                                    <table>
                                        <tr>
                                            <td class="first-position">
                                                <span class="index">$0</span>
                                            </td>
                                            <td class="mid-position">
                                                <div class="progress">
                                                    <div class="progress-bar" role="progressbar" style="width: 25%" aria-valuenow="25" aria-valuemin="0" aria-valuemax="100"></div>
                                                </div>
                                            </td>
                                            <td class="last-position">
                                                <span class="index">$99</span>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                                <p class="pickup-info"><b>Free Pickup</b> is available as soon as today More about shipping and pickup</p>
                            </div>
                        </div>
                    </div>
                </div>

                

            </div>
        </div>
    </div>

    <!-- FOOTER -->
    <jsp:include page="/footer.jsp"></jsp:include>

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
                    <span class="text">Giỏ hàng</span>
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
                <b class="title">Tài khoản</b>
                <ul class="list">
                    <li class="list-item"><a href="#">Đăng nhập/Đăng ký</a></li>
                    <li class="list-item"><a href="#">Yêu thích <span class="index">(8)</span></a></li>
                    <li class="list-item"><a href="#">Thanh toán</a></li>
                </ul>
            </div>
            <div class="glb-item currency">
                <b class="title">Tiền tệ</b>
                <ul class="list">
                    <li class="list-item"><a href="#">€ EUR (Euro)</a></li>
                    <li class="list-item"><a href="#">$ USD (Dollar)</a></li>
                    <li class="list-item"><a href="#">£ GBP (Pound)</a></li>
                    <li class="list-item"><a href="#">¥ JPY (Yen)</a></li>
                </ul>
            </div>
            <div class="glb-item languages">
                <b class="title">Ngôn ngữ</b>
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
    <script src="assets/js/jquery-3.4.1.min.js"></script>
    <script>
    // Hiệu ứng loading
    function showLoading(element) {
        element.html('<div class="loading-spinner"></div>');
    }
    
    function hideLoading(element, originalText) {
        element.html(originalText);
    }
    
    // Hiệu ứng notification
    function showNotification(message, type) {
        if (type === undefined) type = 'success';
        var bgColor = type === 'success' ? 'linear-gradient(45deg, #28a745, #20c997)' : 'linear-gradient(45deg, #dc3545, #c82333)';
        var notification = $('<div class="notification ' + type + '" style="position: fixed; top: 20px; right: 20px; padding: 15px 25px; background: ' + bgColor + '; color: white; border-radius: 8px; box-shadow: 0 5px 15px rgba(0,0,0,0.2); z-index: 9999; transform: translateX(100%); transition: transform 0.3s ease;">' + message + '</div>');
        
        $('body').append(notification);
        setTimeout(function() { 
            notification.css('transform', 'translateX(0)'); 
        }, 100);
        
        setTimeout(function() {
            notification.css('transform', 'translateX(100%)');
            setTimeout(function() { 
                notification.remove(); 
            }, 300);
        }, 3000);
    }
    
    // Hiệu ứng hover cho sản phẩm
    function addHoverEffects() {
        $('.cart_item').hover(
            function() {
                $(this).addClass('hover-effect');
            },
            function() {
                $(this).removeClass('hover-effect');
            }
        );
    }
    
    function updateAllItems() {
        var data = {};
        $('.cart-row').each(function () {
            var id = $(this).data('id');
            var checkbox = $(this).find('.item-checkbox')[0];
            data['selected_' + id] = checkbox.checked ? 'selected' : 'pending';
            data['quantity_' + id] = $(this).find('.qty-input-get').val();
        });

        data['action'] = 'update';
        
        var $btn = $('.btn-checkout .btn');
        var originalText = $btn.text();
        showLoading($btn);

        $.post('cart', data, function () {
            hideLoading($btn, originalText);
            showNotification('Cập nhật giỏ hàng thành công!', 'success');
            setTimeout(function() { location.reload(); }, 1000);
        }).fail(function() {
            hideLoading($btn, originalText);
            showNotification('Có lỗi xảy ra khi cập nhật giỏ hàng!', 'error');
        });
    }

    function updateSingleItem(id) {
        var data = {};
        data['selected_' + id] = $('#cb_' + id).is(':checked') ? 'selected' : 'pending';
        data['quantity_' + id] = $('#qty_' + id).val();
        data['action'] = 'update';
        
        var $row = $('[data-id="' + id + '"]');
        $row.addClass('updating');
        
        $.post('cart', data, function(res) {
            $row.removeClass('updating');
            if (res.error) {
                showNotification(res.error, 'error');
            } else {
                $('.stt-quantity').text(res.quantity + ' sản phẩm');
                $('.stt-price').text('₫' + parseInt(res.total).toLocaleString());
                showNotification('Cập nhật thành công!', 'success');
            }
        }, 'json').fail(function() {
            $row.removeClass('updating');
            showNotification('Có lỗi xảy ra!', 'error');
        });
    }

    function removeItem(id) {
        if (!confirm('Bạn có chắc chắn muốn xóa sản phẩm này?')) {
            return;
        }
        
        var data = {
            'cartItemID': id,
            'action': 'delete'
        };
        
        var $row = $('[data-id="' + id + '"]');
        $row.addClass('removing');
        
        $.post('cart', data, function() {
            $row.fadeOut(300, function() {
                $(this).remove();
                if ($('.cart-row').length === 0) {
                    location.reload();
                }
            });
            showNotification('Đã xóa sản phẩm khỏi giỏ hàng!', 'success');
        }).fail(function() {
            $row.removeClass('removing');
            showNotification('Có lỗi xảy ra khi xóa sản phẩm!', 'error');
        });
    }

    // Kiểm tra trạng thái thực tế của các item từ server
    function syncCheckboxState() {
        var checkedCount = $('.item-checkbox:checked').length;
        var totalCount = $('.item-checkbox').length;
        
        // Nếu tất cả item đều được check, thì check "Chọn tất cả"
        if (checkedCount === totalCount && totalCount > 0) {
            $('#selectAll').prop('checked', true);
            sessionStorage.setItem('selectAllChecked', 'true');
        } else {
            $('#selectAll').prop('checked', false);
            sessionStorage.setItem('selectAllChecked', 'false');
        }
        
        // Cập nhật trạng thái nút checkout
        updateCheckoutButtonState();
    }
    
    // Cập nhật trạng thái nút checkout dựa trên số lượng sản phẩm được chọn
    function updateCheckoutButtonState() {
        var checkedCount = $('.item-checkbox:checked').length;
        var $checkoutBtn = $('#checkoutBtn');
        
        if (checkedCount > 0) {
            // Có ít nhất 1 sản phẩm được chọn
            $checkoutBtn.removeClass('disabled');
            $checkoutBtn.attr('title', 'Tiến hành thanh toán (' + checkedCount + ' sản phẩm)');
            
            // Thêm hiệu ứng animation khi kích hoạt
            if ($checkoutBtn.hasClass('was-disabled')) {
                $checkoutBtn.removeClass('was-disabled');
                $checkoutBtn.addClass('activated');
                setTimeout(function() {
                    $checkoutBtn.removeClass('activated');
                }, 500);
            }
        } else {
            // Không có sản phẩm nào được chọn
            $checkoutBtn.addClass('disabled was-disabled');
            $checkoutBtn.attr('title', 'Vui lòng chọn ít nhất 1 sản phẩm để thanh toán');
        }
    }
    
    // Reset tất cả checkbox về unchecked và đồng bộ với server
    function resetAllCheckboxes() {
        $('.item-checkbox').prop('checked', false);
        $('#selectAll').prop('checked', false);
        sessionStorage.setItem('selectAllChecked', 'false');
        
        // Cập nhật status trong database về 'pending' cho tất cả items
        var data = {};
        $('.cart-row').each(function () {
            var id = $(this).data('id');
            data['selected_' + id] = 'pending';
            data['quantity_' + id] = $(this).find('.qty-input-get').val();
        });
        data['action'] = 'update';
        
        // Gửi request cập nhật tất cả items về status 'pending'
        $.post('cart', data, function(res) {
            if (res.error) {
                showNotification(res.error, 'error');
            } else {
                showNotification('Đã reset trạng thái giỏ hàng!', 'success');
            }
        }, 'json').fail(function() {
            showNotification('Có lỗi xảy ra khi reset giỏ hàng!', 'error');
        });
    }

    $(document).ready(function () {
        // Thêm hiệu ứng hover
        addHoverEffects();
        
        // Luôn xóa sessionStorage khi load trang cart để đảm bảo đồng bộ với server
        sessionStorage.removeItem('selectAllChecked');
        
        // KHÔNG resetAllCheckboxes khi load trang nữa!
        // Chỉ đồng bộ trạng thái checkbox với server
        syncCheckboxState();
        
        // Khởi tạo trạng thái nút checkout
        updateCheckoutButtonState();
        
        $('#selectAll').on('change', function () {
            var checked = this.checked;
            sessionStorage.setItem('selectAllChecked', checked);
            $('.item-checkbox').prop('checked', checked);
            
            if (checked) {
                $('.cart-row').addClass('selected');
            } else {
                $('.cart-row').removeClass('selected');
            }

            updateAllItems();
            
            // Cập nhật trạng thái nút checkout
            updateCheckoutButtonState();
        });
        
        // Hiệu ứng cho quantity input
        $('.qty-input-get').on('change', function() {
            var $row = $(this).closest('.cart-row');
            var price = parseFloat($(this).data('price'));
            var qty = parseInt($(this).val()) || 1;
            var total = price * qty;
            
            // Hiệu ứng animation cho tổng tiền
            $row.find('.product-subtotal .price-amount').fadeOut(200, function() {
                $(this).text('₫' + total.toLocaleString()).fadeIn(200);
            });
            
            var id = $(this).closest('.cart-row').data('id');
            updateSingleItem(id);
            
            // Cập nhật trạng thái nút checkout sau khi thay đổi số lượng
            setTimeout(function() {
                updateCheckoutButtonState();
            }, 200);
        });

        $('.item-checkbox').on('change', function() {
            var id = $(this).closest('.cart-row').data('id');
            updateSingleItem(id);
            
            // Đồng bộ trạng thái "Chọn tất cả" sau khi thay đổi từng item
            setTimeout(function() {
                syncCheckboxState();
            }, 100);
            
            // Cập nhật trạng thái nút checkout ngay lập tức
            updateCheckoutButtonState();
        });
        
        // Hiệu ứng cho remove button
        $('.btn-remove').on('click', function() {
            $(this).addClass('clicked');
            setTimeout(function() { $(this).removeClass('clicked'); }, 200);
        });
        
        // Hiệu ứng cho checkout button
        $('.btn.checkout').on('click', function(e) {
            e.preventDefault();
            var $btn = $(this);
            var checkedCount = $('.item-checkbox:checked').length;
            
            // Kiểm tra xem có sản phẩm nào được chọn không
            if (checkedCount === 0) {
                showNotification('⚠️ Vui lòng chọn ít nhất 1 sản phẩm để thanh toán!', 'warning');
                
                // Thêm hiệu ứng nhấp nháy cho nút để thu hút sự chú ý
                $btn.addClass('shake');
                setTimeout(function() {
                    $btn.removeClass('shake');
                }, 600);
                return;
            }
            
            var originalText = $btn.text();
            
            $btn.html('<div class="loading-spinner"></div> Đang xử lý...');
            $btn.prop('disabled', true);
            
            setTimeout(function() {
                $btn.html(originalText);
                $btn.prop('disabled', false);
                showNotification('Chuyển đến trang thanh toán...', 'success');
                // Chuyển đến trang checkout
                window.location.href = 'checkout';
            }, 2000);
        });
        
    });
    </script>
</body>

</html>