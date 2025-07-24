<%-- 
    Document   : produc_detail
    Created on : May 20, 2025, 11:14:51 PM
    Author     : hoan6
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html class="no-js" lang="en">

<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>${product.productName} - Chi tiết sản phẩm</title>
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
        .product-thumnail {
            width: 220px;
            height: 220px;
            object-fit: cover;
            display: block;
            margin: 0 auto;
            background: #fff;
            border-radius: 12px;
        }

        /* Fire Effect Styles */
        .fire-status {
            position: relative;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 6px 12px;
            background: linear-gradient(135deg, #ff4500, #ff6347, #ff8c00);
            color: white;
            border-radius: 20px;
            font-weight: bold;
            text-shadow: 0 1px 2px rgba(0,0,0,0.5);
            box-shadow: 0 2px 8px rgba(255, 69, 0, 0.4);
            animation: fireGlow 2s ease-in-out infinite alternate;
        }

        @keyframes fireGlow {
            0% {
                box-shadow: 0 2px 8px rgba(255, 69, 0, 0.4);
                transform: scale(1);
            }
            100% {
                box-shadow: 0 4px 16px rgba(255, 69, 0, 0.8);
                transform: scale(1.02);
            }
        }

        .fire-icon {
            position: relative;
            width: 20px;
            height: 20px;
            display: inline-block;
        }

        .flame {
            position: absolute;
            width: 4px;
            height: 12px;
            background: linear-gradient(to top, #ff4500, #ff6347, #ffff00);
            border-radius: 50% 50% 50% 50% / 60% 60% 40% 40%;
            animation: flicker 0.8s ease-in-out infinite alternate;
        }

        .flame:nth-child(1) {
            left: 2px;
            animation-delay: 0s;
            transform: scale(1.2);
        }

        .flame:nth-child(2) {
            left: 6px;
            animation-delay: 0.2s;
            transform: scale(0.9);
        }

        .flame:nth-child(3) {
            left: 10px;
            animation-delay: 0.4s;
            transform: scale(1.1);
        }

        .flame:nth-child(4) {
            left: 14px;
            animation-delay: 0.6s;
            transform: scale(0.8);
        }

        @keyframes flicker {
            0% {
                transform: scaleY(1) scaleX(1);
                opacity: 1;
            }
            25% {
                transform: scaleY(1.1) scaleX(0.9);
                opacity: 0.9;
            }
            50% {
                transform: scaleY(0.9) scaleX(1.1);
                opacity: 1;
            }
            75% {
                transform: scaleY(1.2) scaleX(0.8);
                opacity: 0.8;
            }
            100% {
                transform: scaleY(0.8) scaleX(1.2);
                opacity: 1;
            }
        }

        /* Sparks effect */
        .fire-status::before {
            content: '';
            position: absolute;
            top: -5px;
            left: 50%;
            width: 2px;
            height: 2px;
            background: #ffff00;
            border-radius: 50%;
            animation: spark1 1.5s infinite;
        }

        .fire-status::after {
            content: '';
            position: absolute;
            top: -3px;
            right: 20%;
            width: 1px;
            height: 1px;
            background: #ff6347;
            border-radius: 50%;
            animation: spark2 2s infinite;
        }

        @keyframes spark1 {
            0%, 100% {
                opacity: 0;
                transform: translateY(0) translateX(-50%);
            }
            50% {
                opacity: 1;
                transform: translateY(-8px) translateX(-50%);
            }
        }

        @keyframes spark2 {
            0%, 100% {
                opacity: 0;
                transform: translateY(0);
            }
            30% {
                opacity: 1;
                transform: translateY(-6px);
            }
            70% {
                opacity: 0.5;
                transform: translateY(-12px);
            }
        }

        /* Enhanced status styles */
        .product-meta .status {
            margin: 10px 0;
        }

        .in-stock {
            color: #28a745;
            font-weight: bold;
            padding: 4px 8px;
            background: rgba(40, 167, 69, 0.1);
            border-radius: 8px;
        }

        .out-stock {
            color: #dc3545;
            font-weight: bold;
            padding: 4px 8px;
            background: rgba(220, 53, 69, 0.1);
            border-radius: 8px;
        }

        .discontinued {
            color: #6c757d;
            font-weight: bold;
            padding: 4px 8px;
            background: rgba(108, 117, 125, 0.1);
            border-radius: 8px;
        }

        /* Hot product badge */
        .hot-product-badge {
            position: absolute;
            top: 10px;
            right: 10px;
            background: linear-gradient(135deg, #ff4500, #ff6347);
            color: white;
            padding: 5px 10px;
            border-radius: 15px;
            font-size: 12px;
            font-weight: bold;
            z-index: 10;
            animation: pulse 2s infinite;
        }

        @keyframes pulse {
            0% {
                transform: scale(1);
                box-shadow: 0 0 0 0 rgba(255, 69, 0, 0.7);
            }
            70% {
                transform: scale(1.05);
                box-shadow: 0 0 0 10px rgba(255, 69, 0, 0);
            }
            100% {
                transform: scale(1);
                box-shadow: 0 0 0 0 rgba(255, 69, 0, 0);
            }
        }

        /* Product card enhancements */
        .contain-product {
            position: relative;
            transition: all 0.3s ease;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }

        .contain-product:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
        }

        /* Price styling improvements */
        .price {
            margin: 15px 0;
        }

        .price ins {
            text-decoration: none;
            color: #ff4500;
            font-weight: bold;
            font-size: 1.2em;
        }

        .price del {
            color: #999;
            margin-left: 10px;
        }

        /* Button improvements */
        .btn {
            transition: all 0.3s ease;
            border-radius: 8px;
        }

        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.2);
        }

        .add-to-cart-btn {
            background: linear-gradient(135deg, #28a745, #20c997);
            border: none;
            color: white;
        }

        .add-to-cart-btn:hover {
            background: linear-gradient(135deg, #20c997, #28a745);
        }

        .wishlist-btn {
            background: linear-gradient(135deg, #dc3545, #e83e8c);
            border: none;
            color: white;
        }

        .wishlist-btn:hover {
            background: linear-gradient(135deg, #e83e8c, #dc3545);
        }

        .wishlist-btn.added {
            background: linear-gradient(135deg, #ff4500, #ff6347);
        }

        /* Alert improvements */
        .alert {
            border-radius: 10px;
            border: none;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .alert-warning {
            background: linear-gradient(135deg, #fff3cd, #ffeaa7);
            color: #856404;
        }

        .alert-success {
            background: linear-gradient(135deg, #d4edda, #00b894);
            color: #155724;
        }

        .alert-danger {
            background: linear-gradient(135deg, #f8d7da, #e17055);
            color: #721c24;
        }

        .alert-info {
            background: linear-gradient(135deg, #d1ecf1, #74b9ff);
            color: #0c5460;
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
    <jsp:include page="header.jsp"></jsp:include>

    <!--Hero Section-->
    <div class="hero-section hero-background">
        <h1 class="page-title">${category.categoryName}</h1>
    </div>

    <!-- Thông báo sản phẩm đã bị xóa (chỉ hiển thị cho admin) -->
    <c:if test="${productDeleted}">
        <div class="container">
            <div class="alert alert-warning" role="alert" style="margin-top: 20px;">
                <i class="fa fa-exclamation-triangle"></i>
                <strong>Lưu ý:</strong> ${deletedMessage}
            </div>
        </div>
    </c:if>

    <!--Navigation section-->
    <div class="container">
        <nav class="biolife-nav">
            <ul>
                <li class="nav-item"><a href="${pageContext.request.contextPath}/home" class="permal-link">Trang chủ</a></li>
                <li class="nav-item"><a href="${pageContext.request.contextPath}/category?categoryId=${product.categoryId.categoryId}" class="permal-link">${category.categoryName}</a></li>
                <li class="nav-item"><span class="current-page">${product.productName}</span></li>
            </ul>
        </nav>
    </div>

    <div class="page-contain single-product">
        <div class="container">
            <!-- Main content -->
            <div id="main-content" class="main-content">
                
                <!-- summary info -->
                <div class="sumary-product single-layout">
                    <div class="media">
                        <ul class="biolife-carousel slider-for" data-slick='{"arrows":false,"dots":false,"slidesMargin":30,"slidesToShow":1,"slidesToScroll":1,"fade":true,"asNavFor":".slider-nav"}'>
                            <c:forEach var="img" items="${images}">
                                <li style="position: relative;">
                                    <c:if test="${product.status eq 'active' && product.stock <= 10 && product.stock > 0}">
                                        <div class="hot-product-badge">
                                            <div class="fire-icon">
                                                <div class="flame"></div>
                                                <div class="flame"></div>
                                                <div class="flame"></div>
                                                <div class="flame"></div>
                                            </div>
                                            HOT
                                        </div>
                                    </c:if>
                                    <img src="${pageContext.request.contextPath}${img.imageUrl}" 
                                         alt="${product.productName}" 
                                         width="500" height="500" 
                                         class="product-thumnail-1">
                                </li>
                            </c:forEach>
                        </ul>
                        <ul class="biolife-carousel slider-nav" data-slick='{"arrows":false,"dots":false,"centerMode":false,"focusOnSelect":true,"slidesMargin":10,"slidesToShow":4,"slidesToScroll":1,"asNavFor":".slider-for"}'>
                            <c:forEach var="img" items="${images}">
                                <li>
                                    <img src="${pageContext.request.contextPath}${img.imageUrl}" 
                                         alt="${product.productName}" 
                                         width="88" height="88" 
                                         class="product-thumnail-1">
                                </li>
                            </c:forEach>
                        </ul>
                    </div>
                    <div class="product-attribute">
                        <h3 class="title">${product.productName}</h3>
                        <div class="rating">
                            <c:set var="avgRating" value="${reviewStats.averageRating}" />
                            <p class="star-rating"><span class="width-${avgRating * 20}percent"></span></p>
                            <span class="review-count">(${reviewStats.totalReviews} Đánh giá)</span>
                            <span class="qa-text">Hỏi & Đáp</span>
                            <b class="category">Thương hiệu: ${product.brandName}</b>
                        </div>
                        <span class="sku">Mã SP: #${product.sku}</span> </br>
                        <b class="thetich">Thể tích: ${product.quantityValue} ${product.quantityUnit}</b>
                        <p class="excerpt">${product.shortDescription}</p>
                        
                        <div class="price">
                            <c:choose>
                                <c:when test="${product.salePrice != null && product.salePrice > 0 && product.salePrice < product.price}">
                                    <ins><span class="price-amount">
                                        <fmt:formatNumber value="${product.salePrice}" type="number" groupingUsed="true"/> <span class="currencySymbol">₫</span>
                                    </span></ins>
                                    <del><span class="price-amount">
                                        <fmt:formatNumber value="${product.price}" type="number" groupingUsed="true"/> <span class="currencySymbol">₫</span>
                                    </span></del>
                                </c:when>
                                <c:otherwise>
                                    <ins><span class="price-amount">
                                        <fmt:formatNumber value="${product.price}" type="number" groupingUsed="true"/> <span class="currencySymbol">₫</span>
                                    </span></ins>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <div class="product-meta">
                            <span class="stock">Số lượng còn: <b>${product.stock}</b></span></br>
                            <span class="status">Trạng thái: 
                                <b>
                                    <c:choose>
                                        <c:when test="${product.status eq 'active' && product.stock > 10}">
                                            <span class="in-stock">Còn hàng</span>
                                        </c:when>
                                        <c:when test="${product.status eq 'active' && product.stock <= 10 && product.stock > 0}">
                                            <span class="fire-status">
                                                <div class="fire-icon">
                                                    <div class="flame"></div>
                                                    <div class="flame"></div>
                                                    <div class="flame"></div>
                                                    <div class="flame"></div>
                                                </div>
                                                Cháy hàng
                                            </span>
                                        </c:when>
                                        <c:when test="${product.status eq 'active' && product.stock <= 0}">
                                            <span class="out-stock">Tạm hết hàng</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="discontinued">Ngừng kinh doanh</span>
                                        </c:otherwise>
                                    </c:choose>
                                </b>
                            </span></br>
                            <span class="category">Danh mục: <a href="${pageContext.request.contextPath}/category?categoryId=${product.categoryId}" class="permal-link">${category.categoryName}</a></span>
                        </div>
                    </div>
                    <div class="action-form">
                        <div class="quantity-box">
                            <span class="title">Số lượng:</span>
                            <div class="qty-input">
                                <c:choose>
                                    <c:when test="${!product.isDeleted && product.status eq 'active' && product.stock > 0}">
                                        <input type="text" name="qty" value="1" data-max_value="${product.stock}" data-min_value="1" data-step="1">
                                        <a href="#" class="qty-btn btn-up"><i class="fa fa-caret-up" aria-hidden="true"></i></a>
                                        <a href="#" class="qty-btn btn-down"><i class="fa fa-caret-down" aria-hidden="true"></i></a>
                                    </c:when>
                                    <c:otherwise>
                                        <input type="text" name="qty" value="0" disabled style="background-color: #f5f5f5;">
                                        <a href="#" class="qty-btn btn-up disabled" style="pointer-events: none; opacity: 0.5;"><i class="fa fa-caret-up" aria-hidden="true"></i></a>
                                        <a href="#" class="qty-btn btn-down disabled" style="pointer-events: none; opacity: 0.5;"><i class="fa fa-caret-down" aria-hidden="true"></i></a>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        <div class="buttons">
                            <c:choose>
                                <c:when test="${product.status eq 'active' && product.stock > 0 && !product.isDeleted}">
                                    <a href="#" class="btn add-to-cart-btn" data-product-id="${product.productId}">
                                        <i class="fa fa-cart-arrow-down" aria-hidden="true"></i>
                                        Thêm vào giỏ hàng
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <button class="btn btn-disabled" disabled>
                                        <c:choose>
                                            <c:when test="${product.isDeleted}">Sản phẩm đã bị xóa</c:when>
                                            <c:when test="${product.status ne 'active'}">Ngừng kinh doanh</c:when>
                                            <c:otherwise>Tạm hết hàng</c:otherwise>
                                        </c:choose>
                                    </button>
                                </c:otherwise>
                            </c:choose>
                            <p class="pull-row">
                                <c:choose>
                                    <c:when test="${!product.isDeleted && product.status eq 'active'}">
                                        <a href="#" class="btn wishlist-btn ${inWishlist ? 'added' : ''}" data-product-id="${product.productId}">
                                            <i class="fa fa-heart${inWishlist ? '' : '-o'}" aria-hidden="true"></i>
                                            ${inWishlist ? 'Đã thích' : 'Thêm vào yêu thích'}
                                        </a>
                                    </c:when>
                                    <c:otherwise>
                                        <button class="btn btn-disabled" disabled>
                                            <i class="fa fa-heart-o" aria-hidden="true"></i>
                                            Không thể thêm vào yêu thích
                                        </button>
                                    </c:otherwise>
                                </c:choose>
                            </p>
                        </div>
                    </div>
                </div>

                <!-- Tab info -->
                <div class="product-tabs single-layout biolife-tab-contain">
                    <div class="tab-head">
                        <ul class="tabs">
                            <li class="tab-element active">
                                <a href="#tab_1st" class="tab-link">Mô tả sản phẩm</a>
                            </li>
                            <li class="tab-element">
                                <a href="#tab_2nd" class="tab-link">Thông tin chi tiết</a>
                            </li>
                            <li class="tab-element">
                                <a href="#tab_3rd" class="tab-link">Đánh giá (${reviewStats.totalReviews})</a>
                            </li>
                        </ul>
                    </div>
                    <div class="tab-content">
                        <div id="tab_1st" class="tab-contain desc-tab active">
                            <p class="desc">${productDetail.description}</p>
                        </div>
                        <div id="tab_2nd" class="tab-contain"> 
                            <div class="desc-expand">
                                <span class="title">Thành phần</span>
                                <ul class="list">
                                    <li>${productDetail.ingredients}</li>
                                </ul>
                                
                                <span class="title">Công dụng</span>
                                <ul class="list">
                                    <li>${productDetail.skinConcerns}</li>
                                </ul>

                                <span class="title">Hướng dẫn sử dụng</span>
                                <ul class="list">
                                    <li>${productDetail.howToUse}</li>
                                </ul>

                                <span class="title">Hướng dẫn bảo quản</span>
                                <ul class="list">
                                    <li>${productDetail.storageInstructions}</li>
                                </ul>

                                <span class="title">Xuất xứ</span>
                                <ul class="list">
                                    <li>${productDetail.origin}</li>
                                </ul>

                                <span class="title">Ngày sản xuất</span>
                                <ul class="list">
                                    <li><fmt:formatDate value="${productDetail.manufactureDate}" pattern="dd/MM/yyyy"/></li>
                                </ul>

                                <span class="title">Hạn sử dụng</span>
                                <ul class="list">
                                    <li><fmt:formatDate value="${productDetail.expiryDate}" pattern="dd/MM/yyyy"/></li>
                                </ul>
                            </div>
                        </div>
                        <div id="tab_3rd" class="tab-contain review-tab">
                            <div class="container">
                                <div class="row">
                                    <div class="col-lg-5 col-md-5 col-sm-6 col-xs-12">
                                        <div class="rating-info">
                                            <p class="index"><strong class="rating">${reviewStats.averageRating}</strong>trên 5</p>
                                            <div class="rating">
                                                <p class="star-rating"><span class="width-${reviewStats.averageRating * 20}percent"></span></p>
                                            </div>
                                            <p class="see-all">Xem tất cả ${reviewStats.totalReviews} đánh giá</p>
                                            <ul class="options">
                                                <c:forEach var="stat" items="${reviewStats.ratingDistribution}">
                                                    <li>
                                                        <div class="detail-for">
                                                            <span class="option-name">${stat.rating} sao</span>
                                                            <span class="progres">
                                                                <span class="line-100percent">
                                                                    <span class="percent width-${stat.percentage}percent"></span>
                                                                </span>
                                                            </span>
                                                            <span class="number">${stat.count}</span>
                                                        </div>
                                                    </li>
                                                </c:forEach>
                                            </ul>
                                        </div>
                                    </div>
                                    <div class="col-lg-7 col-md-7 col-sm-6 col-xs-12">
                                        <c:if test="${param.reviewSuccess == '1'}">
                                            <div class="alert alert-success">Đánh giá của bạn đã được gửi thành công!</div>
                                        </c:if>
                                        <c:if test="${not empty requestScope.reviewError}">
                                            <div class="alert alert-danger">${requestScope.reviewError}</div>
                                        </c:if>
                                        <c:choose>
                                            <c:when test="${not empty sessionScope.user}">
                                                <c:set var="canReview" value="${requestScope.canReview}" />
                                                <c:choose>
                                                    <c:when test="${canReview}">
                                                        <div class="review-form-wrapper">
                                                            <span class="title">Gửi đánh giá của bạn</span>
                                                            <form action="${pageContext.request.contextPath}/review/add" method="post" class="review-form">
                                                                <input type="hidden" name="productId" value="${product.productId}">
                                                                <div class="comment-form-rating">
                                                                    <label>1. Đánh giá của bạn về sản phẩm:</label>
                                                                    <p class="stars">
                                                                        <span>
                                                                            <a class="btn-rating" data-value="1" href="#"><i class="fa fa-star-o" aria-hidden="true"></i></a>
                                                                            <a class="btn-rating" data-value="2" href="#"><i class="fa fa-star-o" aria-hidden="true"></i></a>
                                                                            <a class="btn-rating" data-value="3" href="#"><i class="fa fa-star-o" aria-hidden="true"></i></a>
                                                                            <a class="btn-rating" data-value="4" href="#"><i class="fa fa-star-o" aria-hidden="true"></i></a>
                                                                            <a class="btn-rating" data-value="5" href="#"><i class="fa fa-star-o" aria-hidden="true"></i></a>
                                                                        </span>
                                                                        <input type="hidden" name="rating" id="rating-value" value="5" />
                                                                    </p>
                                                                </div>
                                                                <p class="form-row">
                                                                    <textarea name="comment" id="txt-comment" cols="30" rows="10" placeholder="Viết đánh giá của bạn ở đây..."></textarea>
                                                                </p>
                                                                <p class="form-row">
                                                                    <textarea name="skinCondition" cols="30" rows="3" placeholder="Tình trạng của bạn sau khi sử dụng..."></textarea>
                                                                </p>
                                                                <p class="form-row">
                                                                    <button type="submit" name="submit">Gửi đánh giá</button>
                                                                </p>
                                                            </form>
                                                        </div>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div class="alert alert-info">Bạn chỉ có thể đánh giá sản phẩm đã mua và đã nhận hàng, mỗi sản phẩm chỉ được đánh giá 1 lần trong mỗi đơn hàng.</div>
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="alert alert-warning">Vui lòng <a href="login">đăng nhập</a> để gửi đánh giá.</div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                                <div id="comments">
                                    <ol class="commentlist">
                                        <c:forEach var="review" items="${reviews}">
                                            <li class="review">
                                                <div class="comment-container">
                                                    <div class="row">
                                                        <div class="comment-content col-lg-8 col-md-9 col-sm-8 col-xs-12">
                                                            <p class="comment-in">
                                                                <span class="post-name">
                                                                    <c:choose>
                                                                        <c:when test="${not empty review.userId}">
                                                                            ${review.userId.username}
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            Ẩn danh
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </span>
                                                                <span class="post-date">
                                                                    <fmt:formatDate value="${review.reviewDate}" pattern="dd/MM/yyyy HH:mm:ss"/>
                                                                    <c:if test="${review.updatedAt != null}">
                                                                        <span class="text-muted">(Đã sửa: <fmt:formatDate value="${review.updatedAt}" pattern="dd/MM/yyyy HH:mm:ss"/>)</span>
                                                                    </c:if>
                                                                </span>
                                                            </p>
                                                            <div class="rating">
                                                                <p class="star-rating">
                                                                    <span class="width-${review.rating * 20}percent"></span>
                                                                </p>
                                                            </div>
                                                            <p class="comment-text"><strong>Bình luận:</strong>${review.comment}</p>
                                                            <p class="skin-condition">
                                                                <strong>Tình trạng:</strong> ${review.skinCondition}
                                                            </p>
                                                            <c:if test="${sessionScope.user != null && review.userId.userId == sessionScope.user.userId}">
                                                                <a href="${pageContext.request.contextPath}/review/edit?id=${review.reviewId}" class="btn btn-sm btn-warning">Sửa</a>
                                                                <form action="${pageContext.request.contextPath}/review/delete" method="post" style="display:inline;">
                                                                    <input type="hidden" name="reviewId" value="${review.reviewId}" />
                                                                    <button type="submit" class="btn btn-sm btn-danger" onclick="return confirm('Bạn chắc chắn muốn xoá đánh giá này?')">Xoá</button>
                                                                </form>
                                                            </c:if>
                                                        </div>
                                                    </div>
                                                </div>
                                            </li>
                                        </c:forEach>
                                    </ol>
                                    <!-- Phân trang cho đánh giá -->
                                    <c:if test="${reviewStats.totalReviews > reviewsPerPage}">
                                        <div class="biolife-panigations-block version-2">
                                            <ul class="panigation-contain">
                                                <c:forEach var="i" begin="1" end="${totalReviewPages}">
                                                    <li>
                                                        <c:choose>
                                                            <c:when test="${i == currentReviewPage}">
                                                                <span class="current-page">${i}</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <a href="?id=${product.productId}&reviewPage=${i}" class="link-page">${i}</a>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </li>
                                                </c:forEach>
                                            </ul>
                                        </div>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Sản phẩm liên quan -->
                <div class="product-related-box single-layout">
                    <div class="biolife-title-box lg-margin-bottom-26px-im">
                        <span class="biolife-icon icon-organic"></span>
                        <span class="subtitle">Có thể bạn sẽ thích</span>
                        <h3 class="main-title">Sản phẩm liên quan</h3>
                    </div>
                    <ul class="products-list biolife-carousel nav-center-02 nav-none-on-mobile" 
                        data-slick='{"rows":1,"arrows":true,"dots":false,"infinite":false,"speed":400,"slidesMargin":0,"slidesToShow":5, "responsive":[{"breakpoint":1200, "settings":{ "slidesToShow": 4}},{"breakpoint":992, "settings":{ "slidesToShow": 3, "slidesMargin":20}},{"breakpoint":768, "settings":{ "slidesToShow": 2, "slidesMargin":10}}]}'>
                        
                        <c:forEach var="relatedProduct" items="${relatedProducts}">
                            <li class="product-item">
                                <div class="contain-product layout-default">
                                    <c:if test="${relatedProduct.status eq 'active' && relatedProduct.stock <= 10 && relatedProduct.stock > 0}">
                                        <div class="hot-product-badge">
                                            <div class="fire-icon">
                                                <div class="flame"></div>
                                                <div class="flame"></div>
                                                <div class="flame"></div>
                                                <div class="flame"></div>
                                            </div>
                                            HOT
                                        </div>
                                    </c:if>
                                    <div class="product-thumb">
                                        <a href="${pageContext.request.contextPath}/product-detail?id=${relatedProduct.productId}" class="link-to-product">
                                            <img src="${pageContext.request.contextPath}${relatedProductImages[relatedProduct.productId]}" 
                                                 alt="${relatedProduct.productName}" 
                                                 width="270" height="270" 
                                                 class="product-thumnail">
                                        </a>
                                    </div>
                                    <div class="info">
                                        <b class="categories">${category.categoryName}</b>
                                        <h4 class="product-title">
                                            <a href="${pageContext.request.contextPath}/product-detail?id=${relatedProduct.productId}" class="pr-name">
                                                ${relatedProduct.productName}
                                            </a>
                                        </h4>
                                        <div class="price">
                                            <c:choose>
                                                <c:when test="${relatedProduct.salePrice != null && relatedProduct.salePrice > 0 && relatedProduct.salePrice < relatedProduct.price}">
                                                    <ins><span class="price-amount">
                                                        <fmt:formatNumber value="${relatedProduct.salePrice}" type="number" groupingUsed="true"/>
                                                        <span class="currencySymbol">₫</span>
                                                    </span></ins>
                                                    <del><span class="price-amount">
                                                        <fmt:formatNumber value="${relatedProduct.price}" type="number" groupingUsed="true"/>
                                                        <span class="currencySymbol">₫</span>
                                                    </span></del>
                                                </c:when>
                                                <c:otherwise>
                                                    <ins><span class="price-amount">
                                                        <fmt:formatNumber value="${relatedProduct.price}" type="number" groupingUsed="true"/>
                                                        <span class="currencySymbol">₫</span>
                                                    </span></ins>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                        <div class="slide-down-box">
                                            <p class="message">${relatedProduct.shortDescription}</p>
                                            <div class="buttons">
                                                <a href="#" class="btn wishlist-btn" data-product-id="${relatedProduct.productId}">
                                                    <i class="fa fa-heart-o" aria-hidden="true"></i>
                                                </a>
                                                <a href="#" class="btn add-to-cart-btn" data-product-id="${relatedProduct.productId}">
                                                    <i class="fa fa-cart-arrow-down" aria-hidden="true"></i>Thêm vào giỏ
                                                </a>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </li>
                        </c:forEach>
                    </ul>
                </div>
            </div>
        </div>
    </div>

    <!-- FOOTER -->
    <jsp:include page="footer.jsp"></jsp:include>

    <!-- Scroll Top Button -->
    <a class="btn-scroll-top"><i class="biolife-icon icon-left-arrow"></i></a>

    <!-- Script -->
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
        $(document).ready(function() {
            // Load wishlist count when page loads
            loadWishlistCountOnPageLoad();
            
            // Xử lý thêm vào giỏ hàng
            $('.add-to-cart-btn').click(function(e) {
                e.preventDefault();
                var productId = $(this).data('product-id');
                var quantity = $('.qty-input input[name="qty"]').val();
                
                var isLoggedIn = "${not empty sessionScope.user}" === "true";
                if (!isLoggedIn) {
                    window.location.href = '${pageContext.request.contextPath}/login';
                    return;
                }
                
                $.ajax({
                    url: '${pageContext.request.contextPath}/cart',
                    type: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                        'X-Requested-With': 'XMLHttpRequest'
                    },
                    data: 'action=add&productID=' + encodeURIComponent(productId) + '&quantity=' + encodeURIComponent(quantity),
                    success: function(response) {
                        if ((typeof response.success === 'undefined' && typeof response.cartCount !== 'undefined') || response.success) {
                            updateCartBadge(response.cartCount);
                            showCartToast('Đã thêm vào giỏ hàng!');
                        } else {
                            showCartToast((response && response.message) ? response.message : 'Có lỗi xảy ra, vui lòng thử lại!', 'error');
                        }
                    },
                    error: function() {
                        showCartToast('Có lỗi xảy ra, vui lòng thử lại!', 'error');
                    }
                });
            });

            // Xử lý thêm/xóa wishlist
            $('.wishlist-btn').click(function(e) {
                e.preventDefault();
                var $btn = $(this);
                var productId = $btn.data('product-id');
                
                $.ajax({
                    url: '${pageContext.request.contextPath}/wishlist/toggle',
                    type: 'POST',
                    data: {
                        productId: productId
                    },
                    success: function(response) {
                        if(response.inWishlist) {
                            $btn.addClass('added');
                            $btn.find('i').removeClass('fa-heart-o').addClass('fa-heart');
                            $btn.text(' Đã thích');
                        } else {
                            $btn.removeClass('added');
                            $btn.find('i').removeClass('fa-heart').addClass('fa-heart-o');
                            $btn.text(' Thêm vào yêu thích');
                        }
                        
                        // Update wishlist count in header
                        updateWishlistCountBadge(response.count);
                        
                        // Show notification
                        showNotification(response.inWishlist ? 'Đã thêm vào danh sách yêu thích!' : 'Đã xóa khỏi danh sách yêu thích!');
                    },
                    error: function() {
                        alert('Vui lòng đăng nhập để sử dụng tính năng này!');
                    }
                });
            });

            // Xử lý đánh giá sao
            $('.btn-rating').click(function(e) {
                e.preventDefault();
                var rating = $(this).data('value');
                $('input[name="rating"]').val(rating);
                
                // Cập nhật hiển thị sao
                $('.btn-rating i').removeClass('fa-star').addClass('fa-star-o');
                $(this).prevAll('.btn-rating').addBack().find('i')
                    .removeClass('fa-star-o').addClass('fa-star');
            });

            // Tự động active tab Đánh giá nếu có anchor hoặc param tab=review
            if (window.location.hash === '#tab_3rd' || new URLSearchParams(window.location.search).get('tab') === 'review') {
                $('.tab-element').removeClass('active');
                $('.tab-link[href="#tab_3rd"]').parent().addClass('active');
                $('.tab-contain').removeClass('active');
                $('#tab_3rd').addClass('active');
            }

            // Add floating fire particles effect for hot products
            function createFireParticle() {
                if ($('.fire-status').length > 0) {
                    const particle = $('<div class="fire-particle"></div>');
                    const fireStatus = $('.fire-status').first();
                    const rect = fireStatus.get(0).getBoundingClientRect();
                    
                    particle.css({
                        position: 'fixed',
                        left: rect.left + Math.random() * rect.width + 'px',
                        top: rect.bottom + 'px',
                        width: '3px',
                        height: '3px',
                        background: '#ff4500',
                        borderRadius: '50%',
                        pointerEvents: 'none',
                        zIndex: 1000,
                        opacity: 0.8
                    });
                    
                    $('body').append(particle);
                    
                    particle.animate({
                        top: rect.top - 20,
                        opacity: 0
                    }, 1500, function() {
                        particle.remove();
                    });
                }
            }

            // Create fire particles periodically
            setInterval(createFireParticle, 800);
        });

        // Load wishlist count when page loads
        function loadWishlistCountOnPageLoad() {
            var isLoggedIn = '<c:out value="${not empty sessionScope.user}"/>' === 'true';
            if (isLoggedIn) {
                fetch('${pageContext.request.contextPath}/wishlist/count', {
                    method: 'GET',
                    headers: {
                        'X-Requested-With': 'XMLHttpRequest'
                    }
                })
                .then(response => response.json())
                .then(data => {
                    updateWishlistCountBadge(data.count);
                })
                .catch(error => {
                    console.error('Error loading wishlist count:', error);
                });
            }
        }
        
        // Update wishlist count badge in header
        function updateWishlistCountBadge(count) {
            const badge = document.getElementById('wishlist-count-badge');
            if (badge) {
                badge.textContent = count;
                badge.style.display = count > 0 ? 'inline-block' : 'none';
            }
        }
        
        // Show notification
        function showNotification(message, type) {
            type = type || 'success';
            var notification = document.createElement('div');
            notification.className = 'notification ' + type;
            notification.textContent = message;
            
            var styles = {
                position: 'fixed',
                top: '20px',
                right: '20px',
                padding: '15px 25px',
                backgroundColor: type === 'success' ? '#73814B' : '#dc3545',
                color: 'white',
                borderRadius: '4px',
                boxShadow: '0 2px 5px rgba(0,0,0,0.2)',
                zIndex: '9999',
                opacity: '0',
                transition: 'opacity 0.3s ease-in-out'
            };
            
            for (var prop in styles) {
                notification.style[prop] = styles[prop];
            }

            document.body.appendChild(notification);
            
            setTimeout(function() { 
                notification.style.opacity = '1'; 
            }, 10);
            
            setTimeout(function() {
                notification.style.opacity = '0';
                setTimeout(function() { 
                    notification.remove(); 
                }, 300);
            }, 3000);
        }

        // Cập nhật tất cả badge cart nếu có nhiều instance trên trang
        function updateCartBadge(count) {
            var badges = document.querySelectorAll('#cart-badge');
            badges.forEach(function(badge) {
                badge.textContent = count;
                badge.style.display = count > 0 ? 'inline-block' : 'none';
            });
        }
        
        function showCartToast(msg, type) {
            type = type || 'success';
            var toast = document.createElement('div');
            toast.className = 'cart-toast ' + type;
            toast.textContent = msg;
            toast.style.position = 'fixed';
            toast.style.top = '20px';
            toast.style.right = '20px';
            toast.style.background = type === 'success' ? '#73814B' : '#dc3545';
            toast.style.color = '#fff';
            toast.style.padding = '12px 24px';
            toast.style.borderRadius = '4px';
            toast.style.zIndex = 9999;
            toast.style.opacity = 0;
            toast.style.transition = 'opacity 0.3s';
            document.body.appendChild(toast);
            setTimeout(() => { toast.style.opacity = 1; }, 10);
            setTimeout(() => { toast.style.opacity = 0; setTimeout(() => toast.remove(), 300); }, 2000);
        }
    </script>
</body>
</html>