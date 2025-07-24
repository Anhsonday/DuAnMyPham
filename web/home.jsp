<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html class="no-js" lang="en">

<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Cửa Hàng Mỹ Phẩm</title>
    <link href="https://fonts.googleapis.com/css?family=Cairo:400,600,700&amp;display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css?family=Poppins:600&amp;display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css?family=Playfair+Display:400i,700i" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css?family=Ubuntu&amp;display=swap" rel="stylesheet">
    <link rel="shortcut icon" type="image/x-icon" href="assets/images/favicon.png"/>
    <link rel="stylesheet" type="text/css" href="assets/css/bootstrap.min.css">
    <link rel="stylesheet" type="text/css" href="assets/css/animate.min.css">
    <link rel="stylesheet" type="text/css" href="assets/css/font-awesome.min.css">
    <link rel="stylesheet" type="text/css" href="assets/css/nice-select.css">
    <link rel="stylesheet" type="text/css" href="assets/css/slick.min.css">
    <link rel="stylesheet" type="text/css" href="assets/css/style.css">
    <link rel="stylesheet" type="text/css" href="assets/css/main-color.css">

    <!-- Add this style section before closing </head> tag -->
    <style>
.banner-text-1, .banner-text-2 {
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    height: 100%;
    text-align: center;
    padding: 20px 10px;
}

.banner-text-1 .text1,
.banner-text-2 .text1 {
    font-size: 1.3rem;
    font-weight: 700;
    letter-spacing: 1px;
    color: #fff;
    margin-bottom: 8px;
    text-transform: uppercase;
}

.banner-text-1 .text2,
.banner-text-2 .text2 {
    font-size: 2rem;
    font-weight: 900;
    color: #fff;
    margin-bottom: 10px;
    line-height: 1.1;
    text-transform: uppercase;
}

.banner-text-1 .text3 {
    font-size: 1.1rem;
    color: #fff;
    margin-bottom: 10px;
    font-weight: 500;
}

.banner-text-1 .text4 {
    font-size: 1.5rem;
    color: #fff;
    font-weight: 700;
    margin-bottom: 18px;
}

.banner-btn-1, .banner-btn-2 {
    font-size: 1.1rem;
    font-weight: 700;
    padding: 10px 24px;
    border-radius: 25px;
    background: #6dbb43;
    color: #fff !important;
    border: none;
    margin-top: 10px;
    transition: background 0.2s;
    text-transform: uppercase;
    letter-spacing: 1px;
}

.banner-btn-1:hover, .banner-btn-2:hover {
    background: #4e8c2b;
    color: #fff;
}

.banner-text-2 .text1 {
    background: #ff5e7b;
    border-radius: 10px;
    padding: 30px 10px;
}

.banner-text-2 .text1 {
    font-size: 1.2rem;
    font-style: italic;
    color: #fff;
    margin-bottom: 8px;
}

.banner-text-2 .text2 {
    font-size: 1.7rem;
    font-weight: 900;
    color: #fff;
    margin-bottom: 18px;
    line-height: 1.2;
}
.banner-img {
    width: 281px;
    height: 358px;
    object-fit: cover;
    object-position: center;
    display: block;
}
.product-thumnail {
    width: 300px;
    height: 300px;
    object-fit: cover;
    display: block;
    margin: 0 auto;
    background: #fff;
    border-radius: 12px;
}
.product-thumnail-1 {
    width: 277px;
    height: 185px;
    object-fit: cover;
    display: block;
    margin: 0 auto;
    background: #fff;
    border-radius: 12px;
}
.background-biolife-banner__promotion {
    
    background-size: cover;      /* hoặc contain nếu muốn toàn bộ ảnh hiển thị */
    background-position: center;
    background-repeat: no-repeat;
    min-height: 900px;           /* hoặc cao hơn nếu muốn */
    width: 100%;
    display: flex;
    align-items: center;
}
.biolife-banner__promotion .media .position-2{
    left: auto;
    right: -50px;
    top: auto;
    bottom: 230px;
}
.link-1 {
    width: 220px;
    height: 220px;
    object-fit: contain;
    display: block;
    margin: 0 auto;
    background: #fff;
    border-radius: 50%;
    padding: 20px;
    box-sizing: border-box;
}
.biolife-brd-container:nth-child(3) .link-1, /* Chanel */
.biolife-brd-container:nth-child(4) .link-1  /* Dior */ {
    padding: 40px;
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

    <!-- Page Contain -->
    <div class="page-contain">

        <!-- Main content -->
        <div id="main-content" class="main-content">

            <!--Block 01: Vertical Menu And Main Slide-->
            <div class="container">
                <div class="row">
                    <div class="col-lg-12 col-md-12 col-xs-12">
                        <div class="main-slide block-slider nav-change type02">
                            <ul class="biolife-carousel" data-slick='{  "arrows": true,
                                                                        "dots": false,
                                                                        "slidesMargin": 0,
                                                                        "slidesToShow": 1,
                                                                        "infinite": true,
                                                                        "speed": 1000,
                                                                        "autoplay": true,
                                                                        "autoplaySpeed": 3000}' >
                                <li>
                                    <div class="slide-contain slider-opt04__layout01">
                                        <div class="media"></div>
                                        
                                    </div>
                                </li>
                                <li>
                                    <div class="slide-contain slider-opt04__layout01 first-slide">
                                        <div class="media"></div>
                                        
                                    </div>
                                </li>
                                <li>
                                    <div class="slide-contain slider-opt04__layout01 second-slide">
                                        <div class="media"></div>
                                        
                                    </div>
                                </li>
                                <li>
                                    <div class="slide-contain slider-opt04__layout01 third-slide">
                                        <div class="media"></div>
                                        
                                    </div>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
            <!--Block 03: Categories-->
            <div class="wrap-category xs-margin-top-80px sm-margin-top-50px">
                <div class="container">
                    <div class="biolife-title-box style-02 xs-margin-bottom-33px">
                        <span class="subtitle">Danh Mục Nổi Bật 2025</span>
                        <h3 class="main-title">Danh Mục Nổi Bật</h3>
                        <p class="desc">Mỹ phẩm thiên nhiên được chọn lọc từ những nguồn nguyên liệu tốt nhất với quy trình an toàn nghiêm ngặt</p>
                    </div>

                    <ul class="biolife-carousel nav-center-bold nav-none-on-mobile" data-slick='{"arrows":true,"dots":false,"infinite":false,"speed":400,"slidesMargin":30,"slidesToShow":4, "responsive":[{"breakpoint":1200, "settings":{ "slidesToShow": 3}},{"breakpoint":992, "settings":{ "slidesToShow": 3}},{"breakpoint":768, "settings":{ "slidesToShow": 2}}, {"breakpoint":500, "settings":{ "slidesToShow": 1}}]}'>
                        <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
                        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
                        <c:forEach var="cat" items="${parentCategories}">
                            <li>
                                <div class="biolife-cat-box-item">
                                    <div class="cat-thumb">
                                        <a href="category?categoryId=${cat.categoryId}" class="cat-link">
                                            <c:choose>
                                                <c:when test="${cat.image != null && not empty cat.image}">
                                                    <c:choose>
                                                        <c:when test="${cat.image.startsWith('/')}">
                                                            <img src="${pageContext.request.contextPath}${cat.image}" width="277" height="185" class="product-thumnail-1">
                                                        </c:when>
                                                        <c:otherwise>
                                                            <img src="${pageContext.request.contextPath}/${cat.image}" width="277" height="185" alt="">
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:when>
                                                <c:otherwise>
                                                    <img src="${pageContext.request.contextPath}/assets/images/home-04/cat-thumb01.jpg" width="277" height="185" alt="">
                                                </c:otherwise>
                                            </c:choose>
                                        </a>
                                    </div>
                                    <a class="cat-info" href="category?categoryId=${cat.categoryId}">
                                        <h4 class="cat-name">${cat.categoryName}</h4>
                                    </a>
                                </div>
                            </li>
                        </c:forEach>
                    </ul>
                </div>
            </div>
            
            <div class="biolife-service type01 biolife-service__type01 sm-margin-top-25px xs-margin-top-45px">
                        <b class="txt-show-01">Thiên Nhiên</b>
                        <i class="txt-show-02">Mỹ Phẩm</i>
            </div>
            <!--Block 02: Banners-->
            <div class="banner-block sm-margin-top-30px xs-margin-top-50px">
                <div class="container">
                    <ul class="grid-twice-item">
                        <li>
                            <div class="biolife-banner biolife-banner__style-11">
                                <div class="banner-contain">
                                    <div class="media">
                                        <a href="${pageContext.request.contextPath}/all-products" class="bn-link">
                                            <img class="banner-img" src="https://www.focalskin.com/cdn/shop/products/02_c1460c70-4e54-414b-9ec4-dff31b3048fa_2048x.jpg?v=1676008814" width="281" height="358" alt="Mỹ phẩm thiên nhiên">
                                        </a>
                                    </div>
                                    <div class="text-content banner-text-1">
                                        <span class="text1">MỸ PHẨM THIÊN NHIÊN</span>
                                        <b class="text2">LÀN DA KHỎE MẠNH</b>
                                        <span class="text3">CHĂM SÓC SẮC ĐẸP AN TOÀN</span>
                                        <b class="text4">ƯU ĐÃI <span>50%</span> CHO SẢN PHẨM MỚI</b>
                                        <a href="${pageContext.request.contextPath}/all-products" class="btn btn-bold banner-btn-1">XEM TẤT CẢ SẢN PHẨM</a>
                                    </div>
                                </div>
                            </li>
                            <li>
                                <div class="biolife-banner biolife-banner__style-12">
                                    <div class="banner-contain">
                                        <div class="media">
                                            <a href="${pageContext.request.contextPath}/all-products" class="bn-link">
                                                <img class="banner-img" src="https://product.hstatic.net/200000649197/product/z4907701499127_26006b668cb3288c7644a4f60ecf00c4_b384fbe04ca046b984d7ac4a382638ce.jpg" width="281" height="358" alt="Dưỡng da tự nhiên">
                                            </a>
                                        </div>
                                        <div class="text-content banner-text-2">
                                            <i class="text1">Nước hoa tự nhiên</i>
                                            <b class="text2">100% CHIẾT XUẤT TỪ THIÊN NHIÊN</b>
                                            <a href="${pageContext.request.contextPath}/all-products" class="btn btn-thin banner-btn-2">XEM TẤT CẢ SẢN PHẨM</a>
                                        </div>
                                    </div>
                                </div>
                            </li>
                        </ul>
                    </div>
                    <div class="biolife-service type01 biolife-service__type01 sm-margin-top-60px xs-margin-top-45px">
                            
                            <ul class="services-list">
                                <li>
                                    <div class="service-inner">
                                        <span class="number">1</span>
                                        <span class="biolife-icon icon-beer"></span>
                                        <a class="srv-name" href="#">Sản phẩm chính hãng</a>
                                    </div>
                                </li>
                                <li>
                                    <div class="service-inner">
                                        <span class="number">2</span>
                                        <span class="biolife-icon icon-schedule"></span>
                                        <a class="srv-name" href="#">Đặt hàng và giao hàng đúng hẹn</a>
                                    </div>
                                </li>
                                <li>
                                    <div class="service-inner">
                                        <span class="number">3</span>
                                        <span class="biolife-icon icon-car"></span>
                                        <a class="srv-name" href="#">Miễn phí vận chuyển trong thành phố</a>
                                    </div>
                                </li>
                            </ul>
                    </div>
                </div>
                
                <!-- Block 06: Product Tab-->
                <div class="product-tab z-index-20 sm-margin-top-71px xs-margin-top-80px">
                    <div class="container">

                        
                        <div class="biolife-title-box biolife-title-box__icon-at-top-style hidden-icon-on-mobile sm-margin-bottom-24px">
                            <span class="icon-at-top biolife-icon icon-organic"></span>
                            <span class="subtitle">Tất cả sản phẩm tốt nhất dành cho bạn</span>
                            <h3 class="main-title">Sản Phẩm Liên Quan</h3>
                        </div>
                        <div class="biolife-tab biolife-tab-contain">
                            <div class="tab-head tab-head__sample-layout type-02 xs-margin-bottom-15px ">
                                <ul class="tabs">
                                    <li class="tab-element active">
                                        <a href="#tab01_1st" class="tab-link">Nổi Bật</a>
                                    </li>
                                    <li class="tab-element" >
                                        <a href="#tab01_2nd" class="tab-link">Đánh Giá Cao</a>
                                    </li>
                                    <li class="tab-element" >
                                        <a href="#tab01_3rd" class="tab-link">Khuyến Mãi</a>
                                    </li>
                                </ul>
                            </div>
                            <div class="tab-content">
                                <div id="tab01_1st" class="tab-contain active">
                                    <c:choose>
                                        <c:when test="${not empty featuredProducts}">
                                            <ul class="products-list biolife-carousel nav-center-02 nav-none-on-mobile eq-height-contain" data-slick='{"rows":2 ,"arrows":true,"dots":false,"infinite":true,"speed":400,"slidesMargin":10,"slidesToShow":4, "responsive":[{"breakpoint":1200, "settings":{ "slidesToShow": 4}},{"breakpoint":992, "settings":{ "slidesToShow": 3, "slidesMargin": 30}},{"breakpoint":768, "settings":{ "slidesToShow": 2, "slidesMargin": 15}}]}'>
                                                <c:forEach var="product" items="${featuredProducts}">
                                                    <li class="product-item">
                                                        <div class="contain-product layout-default">
                                                            <div class="product-thumb">
                                                                <a href="${pageContext.request.contextPath}/product-detail?id=${product.productId}" class="link-to-product">
                                                                    <c:choose>
                                                                        <c:when test="${not empty productImages[product.productId]}">
                                                                            <img src="${pageContext.request.contextPath}${productImages[product.productId]}" alt="${product.productName}" width="320" height="320" class="product-thumnail">
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <img src="${pageContext.request.contextPath}/assets/images/products/p-18.jpg" alt="${product.productName}" width="270" height="270" class="product-thumnail">
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </a>
                                                                
                                                            </div>
                                                            <div class="info">
                                                                <b class="categories">${product.brandName != null ? product.brandName : 'Product'}</b>
                                                                <h4 class="product-title"><a href="${pageContext.request.contextPath}/product-detail?id=${product.productId}" class="pr-name">${product.productName}</a></h4>
                                                                <div class="price ">
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
                                                                <div class="shipping-info">
                                                            <p class="shipping-day">Giao hàng trong 3 ngày</p>
                                                            <p class="for-today">Nhận hàng miễn phí ngay hôm nay</p>
                                                        </div>
                                                                <div class="slide-down-box">
                                                                    <p class="message">${product.shortDescription}</p>
                                                                    <div class="buttons">
                                                                        <a href="#" class="btn wishlist-btn ${inWishlist[product.productId] ? 'added' : ''}" data-product-id="${product.productId}">
                                                                            <i class="fa fa-heart${inWishlist[product.productId] ? '' : '-o'}" aria-hidden="true"></i>
                                                                        </a>
                                                                        <a class="btn add-to-cart-btn" data-product-id="${product.productId}">
                                                                            <i class="fa fa-cart-arrow-down" aria-hidden="true"></i>Thêm vào giỏ
                                                                        </a>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </li>
                                                </c:forEach>
                                            </ul>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="alert">Hiện tại không có sản phẩm nổi bật.</div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <div id="tab01_2nd" class="tab-contain ">
                                    <c:choose>
                                        <c:when test="${not empty topRatedProducts}">
                                    <ul class="products-list biolife-carousel nav-center-02 nav-none-on-mobile eq-height-contain" data-slick='{"rows":1 ,"arrows":true,"dots":false,"infinite":true,"speed":400,"slidesMargin":10,"slidesToShow":4, "responsive":[{"breakpoint":1200, "settings":{ "slidesToShow": 4}},{"breakpoint":992, "settings":{ "slidesToShow": 3, "slidesMargin":30}},{"breakpoint":768, "settings":{ "slidesToShow": 2, "rows":2, "slidesMargin":15}}]}'>
                                        <c:forEach var="product" items="${topRatedProducts}">
                                    <li class="product-item">
                                        <div class="contain-product layout-default">
                                            <div class="product-thumb">
                                                <a href="${pageContext.request.contextPath}/product-detail?id=${product.productId}" class="link-to-product">
                                                                <c:choose>
                                                                    <c:when test="${not empty productImages[product.productId]}">
                                                                        <img src="${pageContext.request.contextPath}${productImages[product.productId]}" alt="${product.productName}" width="270" height="270" class="product-thumnail">
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <img src="${pageContext.request.contextPath}/assets/images/products/p-18.jpg" alt="${product.productName}" width="270" height="270" class="product-thumnail">
                                                                    </c:otherwise>
                                                                </c:choose>
                                                </a>
                                                
                                            </div>
                                            <div class="info">
                                                            <b class="categories">${product.brandName != null ? product.brandName : 'Product'}</b>
                                                            <h4 class="product-title"><a href="#" class="pr-name">${product.productName}</a></h4>
                                                <div class="price ">
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
                                                            <div class="shipping-info">
                                                            <p class="shipping-day">Giao hàng trong 3 ngày</p>
                                                            <p class="for-today">Nhận hàng miễn phí ngay hôm nay</p>
                                                        </div>
                                                <div class="slide-down-box">
                                                                <p class="message">${product.shortDescription}</p>
                                                    <div class="buttons">
                                                        <a href="#" class="btn wishlist-btn ${inWishlist[product.productId] ? 'added' : ''}" data-product-id="${product.productId}">
                                                            <i class="fa fa-heart${inWishlist[product.productId] ? '' : '-o'}" aria-hidden="true"></i>
                                                        </a>
                                                        <a class="btn add-to-cart-btn" data-product-id="${product.productId}">
                                                            <i class="fa fa-cart-arrow-down" aria-hidden="true"></i>Thêm vào giỏ
                                                        </a>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </li>
                                            </c:forEach>
                                </ul>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="alert">Hiện tại không có sản phẩm đánh giá cao.</div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div id="tab01_3rd" class="tab-contain ">
                                <c:choose>
                                    <c:when test="${not empty onSaleProducts}">
                                <ul class="products-list biolife-carousel nav-center-02 nav-none-on-mobile eq-height-contain" data-slick='{"rows":1 ,"arrows":true,"dots":false,"infinite":true,"speed":400,"slidesMargin":10,"slidesToShow":4, "responsive":[{"breakpoint":1200, "settings":{ "slidesToShow": 4}},{"breakpoint":992, "settings":{ "slidesToShow": 3, "slidesMargin":30}},{"breakpoint":768, "settings":{ "slidesToShow": 2, "rows":2, "slidesMargin":15}}]}'>
                                            <c:forEach var="product" items="${onSaleProducts}">
                                    <li class="product-item">
                                        <div class="contain-product layout-default">
                                            <div class="product-thumb">
                                                <a href="${pageContext.request.contextPath}/product-detail?id=${product.productId}" class="link-to-product">
                                                                <c:choose>
                                                                    <c:when test="${not empty productImages[product.productId]}">
                                                                        <img src="${pageContext.request.contextPath}${productImages[product.productId]}" alt="${product.productName}" width="270" height="270" class="product-thumnail">
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <img src="${pageContext.request.contextPath}/assets/images/products/p-18.jpg" alt="${product.productName}" width="270" height="270" class="product-thumnail">
                                                                    </c:otherwise>
                                                                </c:choose>
                                                </a>
                                                
                                            </div>
                                            <div class="info">
                                                            <b class="categories">${product.brandName != null ? product.brandName : 'Product'}</b>
                                                            <h4 class="product-title"><a href="#" class="pr-name">${product.productName}</a></h4>
                                                <div class="price ">
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
                                                            <div class="shipping-info">
                                                            <p class="shipping-day">Giao hàng trong 3 ngày</p>
                                                            <p class="for-today">Nhận hàng miễn phí ngay hôm nay</p>
                                                        </div>
                                                <div class="slide-down-box">
                                                                <p class="message">${product.shortDescription}</p>
                                                    <div class="buttons">
                                                        <a href="#" class="btn wishlist-btn ${inWishlist[product.productId] ? 'added' : ''}" data-product-id="${product.productId}">
                                                            <i class="fa fa-heart${inWishlist[product.productId] ? '' : '-o'}" aria-hidden="true"></i>
                                                        </a>
                                                        <a class="btn add-to-cart-btn" data-product-id="${product.productId}" style="margin-left: 8px;">
                                                            <i class="fa fa-cart-arrow-down" aria-hidden="true"></i>Thêm vào giỏ
                                                        </a>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </li>
                                            </c:forEach>
                                </ul>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="alert">Hiện tại không có sản phẩm khuyến mãi.</div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>

                <!--Block 04: Banner Promotion 01 -->
                <div class="banner-promotion-01 xs-margin-top-50px sm-margin-top-11px">
                    <div class="biolife-banner promotion biolife-banner__promotion">
                        <div class="banner-contain">
                            <div class="media background-biolife-banner__promotion">
                                <div class="img-moving position-1">
                                    <img src="assets/images/home-03/img-moving-pst-1-geen.png" width="149" height="139" alt="img msv">
                                </div>
                                <div class="img-moving position-2">
                                    <img src="assets/images/home-03/img-moving-pst-22.png" width="385" height="665" alt="img msv">
                                </div>
                                <div class="img-moving position-3">
                                    <img src="assets/images/home-03/img-moving-pst-3-cutt.jpeg" width="384" height="151" alt="img msv">
                                </div>
                                <div class="img-moving position-4">
                                    <img src="assets/images/home-03/img-moving-pst-4.png" width="230" height="369" alt="img msv">
                                </div>
                            </div>
                            <div class="text-content">
                                <div class="container text-wrap">
                                    <i class="first-line">Mỹ phẩm thiên nhiên</i>
                                    <span class="second-line">Làn da luôn tươi mới</span>
                                    <p class="third-line">Chăm sóc sắc đẹp dễ dàng với những sản phẩm mỹ phẩm chất lượng cao từ thiên nhiên...</p>
                                    
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!--Block 05: Banner Promotion 02-->
                <div class="banner-promotion-02 z-index-20">
                    <div class="biolife-banner promotion2 biolife-banner__promotion2">
                        <div class="banner-contain">
                            <div class="container">
                                <div class="media"></div>
                                <div class="text-content">
                                    <b class="first-line">Làm Đẹp Dễ Dàng</b>
                                    <span class="second-line">Cuộc Sống Khỏe Mạnh, Hạnh Phúc</span>
                                    <p class="third-line">Làm đẹp dễ dàng với những sản phẩm mỹ phẩm chất lượng cao. Chúng tôi cung cấp đầy đủ các sản phẩm chăm sóc da, tóc và cơ thể từ những thương hiệu uy tín.</p>
                                    
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                

                <!--Block 07: Brands-->
                <div class="brand-slide sm-margin-top-100px background-fafafa xs-margin-top-80px xs-margin-bottom-80px">
                    <div class="container">
                        <ul class="biolife-carousel nav-center-bold nav-none-on-mobile" data-slick='{"rows":1,"arrows":true,"dots":false,"infinite":false,"speed":400,"slidesMargin":30,"slidesToShow":4, "responsive":[{"breakpoint":1200, "settings":{ "slidesToShow": 4}},{"breakpoint":992, "settings":{ "slidesToShow": 3}},{"breakpoint":768, "settings":{ "slidesToShow": 2, "slidesMargin":10}},{"breakpoint":450, "settings":{ "slidesToShow": 1, "slidesMargin":10}}]}'>
                            <li>
                                <div class="biolife-brd-container">
                                    <a href="#" class="link">
                                        <figure><img class="link-1" src="https://www.unilever.com.vn/content-images/92ui5egz/production/db75ae243befa00aa3cdb2eaf546b0c3aa2ab5d2-1080x1080.jpg?w=375&h=375&fit=crop&auto=format" width="214" height="163" alt=""></figure>
                                    </a>
                                </div>
                            </li>
                            <li>
                                <div class="biolife-brd-container">
                                    <a href="#" class="link">
                                        <figure><img class="link-1" src="https://doanhnhanplus.vn/wp-content/uploads/2018/05/850-loreal-france.jpg" width="214" height="363" alt=""></figure>
                                    </a>
                                </div>
                            </li>
                            <li>
                                <div class="biolife-brd-container">
                                    <a href="#" class="link">
                                        <figure><img class="link-1" src="assets/images/home-03/brd-03.jpg" width="153" height="163" alt=""></figure>
                                    </a>
                                </div>
                            </li>
                            <li>
                                <div class="biolife-brd-container">
                                    <a href="#" class="link">
                                        <figure><img class="link-1" src="assets/images/home-03/brd-04.jpg" width="124" height="103" alt=""></figure>
                                    </a>
                                </div>
                            </li>
                            <li>
                                <div class="biolife-brd-container">
                                    <a href="#" class="link">
                                        <figure><img class="link-1" src="https://www.unilever.com.vn/content-images/92ui5egz/production/db75ae243befa00aa3cdb2eaf546b0c3aa2ab5d2-1080x1080.jpg?w=375&h=375&fit=crop&auto=format" width="214" height="163" alt=""></figure>
                                    </a>
                                </div>
                            </li>
                            <li>
                                <div class="biolife-brd-container">
                                    <a href="#" class="link">
                                        <figure><img class="link-1" src="https://doanhnhanplus.vn/wp-content/uploads/2018/05/850-loreal-france.jpg" width="214" height="163" alt=""></figure>
                                    </a>
                                </div>
                            </li>
                            <li>
                                <div class="biolife-brd-container">
                                    <a href="#" class="link">
                                        <figure><img class="link-1" src="assets/images/home-03/brd-03.jpg" width="153" height="163" alt=""></figure>
                                    </a>
                                </div>
                            </li>
                            <li>
                                <div class="biolife-brd-container">
                                    <a href="#" class="link">
                                        <figure><img class="link-1" src="assets/images/home-03/brd-04.jpg" width="224" height="163" alt=""></figure>
                                    </a>
                                </div>
                            </li>
                        </ul>
                    </div>
                </div>

             

            </div>

        </div>

    </div>

    <!-- FOOTER -->
    <!-- FOOTER -->
    <jsp:include page="footer.jsp"></jsp:include>

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
                    <span class="text">Thanh Bên</span>
                </a>
            </div>
            <div class="mobile-block block-minicart">
                <a class="link-to-cart" href="#">
                    <span class="fa fa-shopping-bag" aria-hidden="true"></span>
                    <span class="text">Giỏ Hàng</span>
                </a>
            </div>
            <div class="mobile-block block-global">
                <a class="menu-bar myaccount-toggle btn-toggle" data-object="global-panel-opened" href="javascript:void(0)">
                    <span class="fa fa-globe"></span>
                    <span class="text">Toàn Cầu</span>
                </a>
            </div>
        </div>
    </div>

    <!--Mobile Global Menu-->
    <div class="mobile-block-global">
        <div class="biolife-mobile-panels">
            <span class="biolife-current-panel-title">Toàn Cầu</span>
            <a class="biolife-close-btn" data-object="global-panel-opened" href="#">&times;</a>
        </div>
        <div class="block-global-contain">
            <div class="glb-item my-account">
                <b class="title">Tài Khoản Của Tôi</b>
                <ul class="list">
                    <li class="list-item"><a href="#">Đăng nhập/Đăng ký</a></li>
                    <li class="list-item"><a href="#">Yêu thích <span class="index">(8)</span></a></li>
                    <li class="list-item"><a href="#">Thanh toán</a></li>
                </ul>
            </div>
            <div class="glb-item currency">
                <b class="title">Tiền Tệ</b>
                <ul class="list">
                    <li class="list-item"><a href="#">₫ VND (Việt Nam Đồng)</a></li>
                    <li class="list-item"><a href="#">$ USD (Đô la Mỹ)</a></li>
                    <li class="list-item"><a href="#">€ EUR (Euro)</a></li>
                    <li class="list-item"><a href="#">¥ JPY (Yên Nhật)</a></li>
                </ul>
            </div>
            <div class="glb-item languages">
                <b class="title">Ngôn Ngữ</b>
                <ul class="list inline">
                    <li class="list-item"><a href="#"><img src="assets/images/languages/us.jpg" alt="flag" width="24" height="18"></a></li>
                    <li class="list-item"><a href="#"><img src="assets/images/languages/fr.jpg" alt="flag" width="24" height="18"></a></li>
                    <li class="list-item"><a href="#"><img src="assets/images/languages/ger.jpg" alt="flag" width="24" height="18"></a></li>
                    <li class="list-item"><a href="#"><img src="assets/images/languages/jap.jpg" alt="flag" width="24" height="18"></a></li>
                </ul>
            </div>
        </div>
    </div>

    <!--Quickview Popup-->
    <div id="biolife-quickview-block" class="biolife-quickview-block">
        <div class="quickview-container">
            <a href="#" class="btn-close-quickview" data-object="open-quickview-block"><span class="biolife-icon icon-close-menu"></span></a>
            <div class="biolife-quickview-inner">
                <div class="media">
                    <ul class="biolife-carousel quickview-for" data-slick='{"arrows":false,"dots":false,"slidesMargin":30,"slidesToShow":1,"slidesToScroll":1,"fade":true,"asNavFor":".quickview-nav"}'>
                        <li><img src="assets/images/details-product/detail_01.jpg" alt="" width="500" height="500"></li>
                        <li><img src="assets/images/details-product/detail_02.jpg" alt="" width="500" height="500"></li>
                        <li><img src="assets/images/details-product/detail_03.jpg" alt="" width="500" height="500"></li>
                        <li><img src="assets/images/details-product/detail_04.jpg" alt="" width="500" height="500"></li>
                        <li><img src="assets/images/details-product/detail_05.jpg" alt="" width="500" height="500"></li>
                        <li><img src="assets/images/details-product/detail_06.jpg" alt="" width="500" height="500"></li>
                        <li><img src="assets/images/details-product/detail_07.jpg" alt="" width="500" height="500"></li>
                    </ul>
                    <ul class="biolife-carousel quickview-nav" data-slick='{"arrows":true,"dots":false,"centerMode":false,"focusOnSelect":true,"slidesMargin":10,"slidesToShow":3,"slidesToScroll":1,"asNavFor":".quickview-for"}'>
                        <li><img src="assets/images/details-product/thumb_01.jpg" alt="" width="88" height="88"></li>
                        <li><img src="assets/images/details-product/thumb_02.jpg" alt="" width="88" height="88"></li>
                        <li><img src="assets/images/details-product/thumb_03.jpg" alt="" width="88" height="88"></li>
                        <li><img src="assets/images/details-product/thumb_04.jpg" alt="" width="88" height="88"></li>
                        <li><img src="assets/images/details-product/thumb_05.jpg" alt="" width="88" height="88"></li>
                        <li><img src="assets/images/details-product/thumb_06.jpg" alt="" width="88" height="88"></li>
                        <li><img src="assets/images/details-product/thumb_07.jpg" alt="" width="88" height="88"></li>
                    </ul>
                </div>
                <div class="product-attribute">
                    <h4 class="title"><a href="#" class="pr-name">Mỹ Phẩm Thiên Nhiên</a></h4>
                    <div class="rating">
                        <p class="star-rating"><span class="width-80percent"></span></p>
                    </div>

                    <div class="price price-contain">
                        <ins><span class="price-amount"><span class="currencySymbol">â«</span>85.00</span></ins>
                        <del><span class="price-amount"><span class="currencySymbol">â«</span>95.00</span></del>
                    </div>
                    <p class="excerpt">Sản phẩm mỹ phẩm chất lượng cao được chiết xuất từ thiên nhiên, giúp chăm sóc và bảo vệ làn da của bạn một cách hiệu quả.</p>
                    <div class="from-cart">
                        <div class="qty-input">
                            <input type="text" name="qty12554" value="1" data-max_value="20" data-min_value="1" data-step="1">
                            <a href="#" class="qty-btn btn-up"><i class="fa fa-caret-up" aria-hidden="true"></i></a>
                            <a href="#" class="qty-btn btn-down"><i class="fa fa-caret-down" aria-hidden="true"></i></a>
                        </div>
                        <div class="buttons">
                            <a href="#" class="btn add-to-cart-btn btn-bold">Thêm vào giỏ</a>
                        </div>
                    </div>

                    <div class="product-meta">
                        <div class="product-atts">
                            <div class="product-atts-item">
                                <b class="meta-title">Danh Mục:</b>
                                <ul class="meta-list">
                                    <li><a href="#" class="meta-link">Chăm sóc da</a></li>
                                    <li><a href="#" class="meta-link">Chăm sóc tóc</a></li>
                                    <li><a href="#" class="meta-link">Chăm sóc cơ thể</a></li>
                                </ul>
                            </div>
                            <div class="product-atts-item">
                                <b class="meta-title">Thẻ:</b>
                                <ul class="meta-list">
                                    <li><a href="#" class="meta-link">mỹ phẩm</a></li>
                                    <li><a href="#" class="meta-link">thiên nhiên</a></li>
                                    <li><a href="#" class="meta-link">chăm sóc da</a></li>
                                </ul>
                            </div>
                            <div class="product-atts-item">
                                <b class="meta-title">Thương Hiệu:</b>
                                <ul class="meta-list">
                                    <li><a href="#" class="meta-link">Mỹ Phẩm Thiên Nhiên</a></li>
                                </ul>
                            </div>
                        </div>
                        <span class="sku">Mã SP: N/A</span>
                        <div class="biolife-social inline add-title">
                            <span class="fr-title">Chia sẻ:</span>
                            <ul class="socials">
                                <li><a href="#" title="twitter" class="socail-btn"><i class="fa fa-twitter" aria-hidden="true"></i></a></li>
                                <li><a href="#" title="facebook" class="socail-btn"><i class="fa fa-facebook" aria-hidden="true"></i></a></li>
                                <li><a href="#" title="pinterest" class="socail-btn"><i class="fa fa-pinterest" aria-hidden="true"></i></a></li>
                                <li><a href="#" title="youtube" class="socail-btn"><i class="fa fa-youtube" aria-hidden="true"></i></a></li>
                                <li><a href="#" title="instagram" class="socail-btn"><i class="fa fa-instagram" aria-hidden="true"></i></a></li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Scroll Top Button -->
    <a class="btn-scroll-top"><i class="biolife-icon icon-left-arrow"></i></a>

    <!-- Floating Chat Button - Open Chat Modal -->
    <div id="chat-redirect-button" class="chat-redirect-button" onclick="openChatModal()">
        <i class="fa fa-comments"></i>
        <div class="chat-tooltip">AI Chat Assistant</div>
    </div>

    <!-- Chat Modal -->
    <div id="chat-modal" class="chat-modal">
        <div class="chat-modal-content">
            <div class="chat-header">
                <div class="chat-title">
                    <i class="fa fa-robot"></i>
                    <span>AI Chat Assistant</span>
                </div>
                <button class="chat-close-btn" onclick="closeChatModal()">
                    <i class="fa fa-times"></i>
                </button>
            </div>
            <div class="chat-body">
                <iframe id="chat-iframe" src="${pageContext.request.contextPath}/client/chat-agent-new.jsp" frameborder="0"></iframe>
            </div>
        </div>
    </div>

    <script src="assets/js/jquery-3.4.1.min.js"></script>
    <script src="assets/js/bootstrap.min.js"></script>
    <script src="assets/js/jquery.countdown.min.js"></script>
    <script src="assets/js/jquery.nice-select.min.js"></script>
    <script src="assets/js/jquery.nicescroll.min.js"></script>
    <script src="assets/js/slick.min.js"></script>
    <script src="assets/js/biolife.framework.js"></script>
    <script src="assets/js/functions.js"></script>

    <!-- Chat Button and Modal Styles -->
    <style>
        .chat-redirect-button {
            position: fixed;
            bottom: 10px;
            right: 10px;
            width: 60px;
            height: 60px;
            background: linear-gradient(135deg, #6dbb43, #4e8c2b);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 24px;
            cursor: pointer;
            box-shadow: 0 4px 20px rgba(0,0,0,0.3);
            z-index: 1000;
            transition: all 0.3s ease;
            border: 2px solid white;
        }

        .chat-redirect-button:hover {
            transform: scale(1.1);
            box-shadow: 0 6px 25px rgba(0,0,0,0.4);
            background: linear-gradient(135deg, #4e8c2b, #3a6b1f);
        }

        .chat-redirect-button:hover .chat-tooltip {
            opacity: 1;
            visibility: visible;
            transform: translateY(-50%);
        }

        .chat-tooltip {
            position: absolute;
            right: 70px;
            top: 50%;
            transform: translateY(-50%);
            background: rgba(0,0,0,0.9);
            color: white;
            padding: 8px 12px;
            border-radius: 6px;
            font-size: 12px;
            white-space: nowrap;
            opacity: 0;
            visibility: hidden;
            transition: all 0.3s ease;
            pointer-events: none;
            font-weight: 500;
        }

        .chat-tooltip::after {
            content: '';
            position: absolute;
            right: -5px;
            top: 50%;
            transform: translateY(-50%);
            border-left: 5px solid rgba(0,0,0,0.9);
            border-top: 5px solid transparent;
            border-bottom: 5px solid transparent;
        }

        /* Chat Modal Styles */
        .chat-modal {
            display: none;
            position: fixed;
            z-index: 2000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.5);
            backdrop-filter: blur(5px);
        }

        .chat-modal-content {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            width: 90%;
            max-width: 900px;
            height: 99%;
            max-height: 1000px;
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.3);
            overflow: hidden;
            animation: modalSlideIn 0.3s ease-out;
        }

        @keyframes modalSlideIn {
            from {
                opacity: 0;
                transform: translate(-50%, -60%);
            }
            to {
                opacity: 1;
                transform: translate(-50%, -50%);
            }
        }

        .chat-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px 20px;
            background: linear-gradient(135deg, #6dbb43, #4e8c2b);
            color: white;
            border-radius: 15px 15px 0 0;
        }

        .chat-title {
            display: flex;
            align-items: center;
            font-size: 18px;
            font-weight: 600;
        }

        .chat-title i {
            margin-right: 10px;
            font-size: 20px;
        }

        .chat-close-btn {
            background: none;
            border: none;
            color: white;
            font-size: 20px;
            cursor: pointer;
            padding: 5px;
            border-radius: 50%;
            width: 35px;
            height: 35px;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: background 0.3s ease;
        }

        .chat-close-btn:hover {
            background: rgba(255,255,255,0.2);
        }

        .chat-body {
            height: calc(100% - 70px);
            overflow: hidden;
        }

        #chat-iframe {
            width: 100%;
            height: 100%;
            border: none;
        }

        @media (max-width: 768px) {
            .chat-redirect-button {
                width: 50px;
                height: 50px;
                font-size: 20px;
                bottom: 15px;
                right: 15px;
            }
            
            .chat-tooltip {
                display: none;
            }

            .chat-modal-content {
                width: 95%;
                height: 90%;
                max-height: none;
            }
        }
    </style>

    <!-- Add this script section before closing </body> tag -->
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Handle wishlist button clicks
            var wishlistButtons = document.querySelectorAll('.wishlist-btn');
            for (var i = 0; i < wishlistButtons.length; i++) {
                wishlistButtons[i].addEventListener('click', handleWishlistClick);
            }
            
            // Load wishlist count when page loads
            loadWishlistCountOnPageLoad();

            var isLoggedIn = "${not empty sessionScope.user}" === "true";
            // Đảm bảo contextPath luôn đúng
            window.contextPath = window.contextPath || '${pageContext.request.contextPath}';
            document.querySelectorAll('.add-to-cart-btn').forEach(function(btn) {
                btn.addEventListener('click', function(e) {
                    e.preventDefault();
                    console.log('[DEBUG] Clicked add-to-cart-btn', this);
                    var productId = this.getAttribute('data-product-id');
                    console.log('[DEBUG] Product ID:', productId);
                    if (!isLoggedIn) {
                        window.location.href = window.contextPath + "/login";
                        return;
                    }
                    fetch(window.contextPath + '/cart', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/x-www-form-urlencoded',
                            'X-Requested-With': 'XMLHttpRequest'
                        },
                        body: 'action=add&productID=' + encodeURIComponent(productId) + '&quantity=1'
                    })
                    .then(function(response) { return response.json(); })
                    .then(function(data) {
                        if ((typeof data.success === 'undefined' && typeof data.cartCount !== 'undefined') || data.success) {
                            updateCartBadge(data.cartCount);
                            window.dispatchEvent(new CustomEvent('cart-updated', { detail: { cartCount: data.cartCount } }));
                            showCartToast('Đã thêm vào giỏ hàng!');
                        } else {
                            showCartToast((data && data.message) ? data.message : 'Có lỗi xảy ra, vui lòng thử lại!', 'error');
                        }
                    })
                    .catch(function() { showCartToast('Có lỗi xảy ra, vui lòng thử lại!', 'error'); });
                });
            });
            // Cập nhật tất cả badge cart nếu có nhiều instance trên trang
            function updateCartBadge(count) {
                console.log('[DEBUG] updateCartBadge called, count =', count);
                var badges = document.querySelectorAll('#cart-badge');
                console.log('[DEBUG] Found', badges.length, 'badge(s) with id cart-badge');
                badges.forEach(function(badge) {
                    badge.textContent = count;
                    badge.style.display = count > 0 ? 'inline-block' : 'none';
                    console.log('[DEBUG] Badge updated:', badge, '->', badge.textContent);
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
        });

        function handleWishlistClick(e) {
            e.preventDefault();
            var button = this;
            var productId = button.getAttribute('data-product-id');
            var isLoggedIn = "${not empty sessionScope.user}" === "true";
            
            // Check if user is logged in
            if (!isLoggedIn) {
                window.location.href = '${pageContext.request.contextPath}/login';
                return;
            }
            
            // Toggle wishlist
            var xhr = new XMLHttpRequest();
            xhr.open('POST', '${pageContext.request.contextPath}/wishlist/toggle', true);
            xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
            
            xhr.onload = function() {
                if (xhr.status === 200) {
                    var data = JSON.parse(xhr.responseText);
                    if (data.success) {
                        // Update button state
                        var icon = button.querySelector('i');
                        if (data.inWishlist) {
                            button.classList.add('added');
                            icon.classList.remove('fa-heart-o');
                            icon.classList.add('fa-heart');
                        } else {
                            button.classList.remove('added');
                            icon.classList.remove('fa-heart');
                            icon.classList.add('fa-heart-o');
                        }
                        
                        // Update wishlist count in header
                        updateWishlistCountBadge(data.count);
                        
                        // Show notification
                        showNotification(data.inWishlist ? 'Đã thêm vào danh sách yêu thích!' : 'Đã xóa khỏi danh sách yêu thích!');
                    }
                } else {
                    showNotification('Có lỗi xảy ra. Vui lòng thử lại!', 'error');
                }
            };
            
            xhr.onerror = function() {
                showNotification('Có lỗi xảy ra. Vui lòng thử lại!', 'error');
            };
            
            xhr.send('productId=' + encodeURIComponent(productId));
        }

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

        // Update wishlist count badge in header
        function updateWishlistCountBadge(count) {
            const badge = document.getElementById('wishlist-count-badge');
            if (badge) {
                badge.textContent = count;
                badge.style.display = count > 0 ? 'inline-block' : 'none';
            }
        }
        
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

        // Chat Modal Functions
        function openChatModal() {
            document.getElementById('chat-modal').style.display = 'block';
            document.body.style.overflow = 'hidden'; // Prevent background scrolling
        }

        function closeChatModal() {
            document.getElementById('chat-modal').style.display = 'none';
            document.body.style.overflow = 'auto'; // Restore scrolling
        }

        // Close modal when clicking outside
        document.addEventListener('DOMContentLoaded', function() {
            const modal = document.getElementById('chat-modal');
            modal.addEventListener('click', function(e) {
                if (e.target === modal) {
                    closeChatModal();
                }
            });

            // Close modal with Escape key
            document.addEventListener('keydown', function(e) {
                if (e.key === 'Escape' && modal.style.display === 'block') {
                    closeChatModal();
                }
            });
        });
    </script>
</body>

</html>