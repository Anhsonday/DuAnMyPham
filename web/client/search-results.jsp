<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html class="no-js" lang="vi">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Kết quả tìm kiếm</title>
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
.product-thumnail-1 {
    width: 320px;
    height: 320px;
    object-fit: cover;
    display: block;
    margin: 0 auto;
    background: #fff;
    border-radius: 12px;
}
</style>
</head>
<body class="biolife-body">
<jsp:include page="/header.jsp"/>
<div class="hero-section hero-background">
    <h1 class="page-title">
        Kết quả tìm kiếm cho '<c:out value="${searchKeyword}"/>'
        <c:if test="${not empty searchCategoryId}">
            <c:forEach var="cat" items="${allCategories}">
                <c:if test="${cat.categoryId == searchCategoryId}">
                    trong '<c:out value="${cat.categoryName}"/>'
                </c:if>
            </c:forEach>
        </c:if>
    </h1>
</div>
<div class="page-contain category-page">
        <div class="container">
            <nav class="biolife-nav">
                <ul>
                    <li class="nav-item"><a href="${pageContext.request.contextPath}/home" class="permal-link">Trang chủ</a></li>
                    <li class="nav-item">
                        <span class="current-page">
                            Kết quả tìm kiếm
                            <c:if test="${not empty selectedCategory}">
                                - <c:out value="${selectedCategory.categoryName}"/>
                            </c:if>
                        </span>
                    </li>
                </ul>
            </nav>
            <div class="row">
                <!-- Main content -->
                <div id="main-content" class="main-content col-lg-12 col-md-12 col-sm-12 col-xs-12">

                    <div class="block-item recently-products-cat md-margin-bottom-39">
                        <ul class="products-list biolife-carousel nav-center-02 nav-none-on-mobile"
                            data-slick='{
                                "rows":1,
                                "arrows":true,
                                "dots":false,
                                "infinite":true,
                                "speed":400,
                                "slidesMargin":0,
                                "slidesToShow":5,
                                "autoplay": true,
                                "autoplaySpeed": 2000,
                                "responsive":[
                                    {"breakpoint":1200, "settings":{ "slidesToShow": 3}},
                                    {"breakpoint":992, "settings":{ "slidesToShow": 3, "slidesMargin":30}},
                                    {"breakpoint":768, "settings":{ "slidesToShow": 2, "slidesMargin":10}}
                                ]
                            }'>
                            <c:if test="${not empty allProducts}">
                                <c:forEach var="product" items="${allProducts}" varStatus="status">
                                    <c:if test="${status.index < 30}">
                                        <li class="product-item">
                                            <div class="contain-product layout-02">
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
                                                    <b class="categories">
                                                        ${product.categoryId.categoryName}
                                                    </b>
                                                    <h4 class="product-title"><a href="${pageContext.request.contextPath}/product-detail?id=${product.productId}" class="pr-name">${product.productName}</a></h4>
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
                                                </div>
                                            </div>
                                        </li>
                                    </c:if>
                                </c:forEach>
                            </c:if>
                        </ul>
                    </div>

                    <div class="product-category grid-style">

                        <div id="top-functions-area" class="top-functions-area" >
                            <div class="flt-item to-left group-on-mobile">
                                <span class="flt-title">Lựa chọn</span>
                                <a href="#" class="icon-for-mobile">
                                    <span></span>
                                    <span></span>
                                    <span></span>
                                </a>
                                <div class="wrap-selectors">
                                    <form action="search" name="frm-refine" method="get">
                                        <input type="hidden" name="q" value="${searchKeyword}" />
                                        <input type="hidden" name="categoryId" value="${searchCategoryId}" />
                                        <input type="hidden" name="page" value="1" />
                                        <span class="title-for-mobile">Refine Products By</span>
                                        <div data-title="Price:" class="selector-item">
                                            <select name="price" class="selector" onchange="this.form.submit()">
                                                <option value="all" ${param.price == 'all' ? 'selected' : ''}>Tất cả giá</option>
                                                <option value="class-1st" ${param.price == 'class-1st' ? 'selected' : ''}>Dưới 100.000₫</option>
                                                <option value="class-2nd" ${param.price == 'class-2nd' ? 'selected' : ''}>100.000₫ - 300.000₫</option>
                                                <option value="class-3rd" ${param.price == 'class-3rd' ? 'selected' : ''}>300.000₫ - 500.000₫</option>
                                                <option value="class-4th" ${param.price == 'class-4th' ? 'selected' : ''}>500.000₫ - 700.000₫</option>
                                                <option value="class-5th" ${param.price == 'class-5th' ? 'selected' : ''}>700.000₫ - 1.500.000₫</option>
                                                <option value="class-6th" ${param.price == 'class-6th' ? 'selected' : ''}>Trên 1.500.000₫</option>
                                            </select>
                                        </div>
                                        <div data-title="Brand:" class="selector-item">
                                            <select name="brand" class="selector" onchange="this.form.submit()">
                                                <option value="all" ${param.brand == 'all' ? 'selected' : ''}>Tất cả thương hiệu</option>
                                                <c:forEach var="b" items="${brands}">
                                                    <option value="${b}" ${param.brand == b ? 'selected' : ''}>${b}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div data-title="Avalability:" class="selector-item">
                                            <select name="availability" class="selector" onchange="this.form.submit()">
                                                <option value="all" ${param.availability == 'all' ? 'selected' : ''}>Tất cả trạng thái</option>
                                                <option value="in_stock" ${param.availability == 'in_stock' ? 'selected' : ''}>Còn hàng</option>
                                                <option value="out_of_stock" ${param.availability == 'out_of_stock' ? 'selected' : ''}>Hết hàng</option>
                                            </select>
                                        </div>
                                        <!-- Xóa nút Lọc -->
                                    </form>
                                </div>
                            </div>
                            <div class="flt-item to-right">
                                <span class="flt-title">Sắp xếp</span>
                                <div class="wrap-selectors">
                                    <div class="selector-item orderby-selector">
                                        <form action="search" method="get">
                                            <input type="hidden" name="q" value="${searchKeyword}" />
                                            <input type="hidden" name="categoryId" value="${searchCategoryId}" />
                                            <input type="hidden" name="page" value="1" />
                                            <!-- Debug để kiểm tra giá trị -->
                                            <!-- CategoryID: ${not empty selectedCategory ? selectedCategory.categoryId : 'Not selected'} -->
                                            
                                            <c:if test="${not empty param.price}">
                                                <input type="hidden" name="price" value="${param.price}" />
                                            </c:if>
                                            <c:if test="${not empty param.brand}">
                                                <input type="hidden" name="brand" value="${param.brand}" />
                                            </c:if>
                                            <c:if test="${not empty param.availability}">
                                                <input type="hidden" name="availability" value="${param.availability}" />
                                            </c:if>
                                            
                                            <select name="sort" class="orderby" aria-label="Shop order" onchange="this.form.submit()">
                                                <option value="default" ${param.sort == 'default' || param.sort == null ? 'selected' : ''}>Mặc định</option>
                                                <option value="name_asc" ${param.sort == 'name_asc' ? 'selected' : ''}>Tên A-Z</option>
                                                <option value="name_desc" ${param.sort == 'name_desc' ? 'selected' : ''}>Tên Z-A</option>
                                                <option value="price_asc" ${param.sort == 'price_asc' ? 'selected' : ''}>Giá thấp đến cao</option>
                                                <option value="price_desc" ${param.sort == 'price_desc' ? 'selected' : ''}>Giá cao đến thấp</option>
                                                <option value="newest" ${param.sort == 'newest' ? 'selected' : ''}>Mới nhất</option>
                                            </select>
                                        </form>
                                    </div>
                                    <div class="selector-item viewmode-selector">
                                        <a href="#" class="viewmode grid-mode active"><i class="biolife-icon icon-grid"></i></a>
                                        <a href="#" class="viewmode detail-mode"><i class="biolife-icon icon-list"></i></a>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <ul class="products-list">
                                <c:choose>
                                    <c:when test="${not empty products}">
                                        <c:forEach var="product" items="${products}">
                                            <li class="product-item col-lg-4 col-md-4 col-sm-4 col-xs-6">
                                                <div class="contain-product layout-default">
                                                    <div class="product-thumb">
                                                        <a href="${pageContext.request.contextPath}/product-detail?id=${product.productId}" class="link-to-product">
                                                                <c:choose>
                                                                    <c:when test="${not empty productImages[product.productId]}">
                                                                        <img src="${pageContext.request.contextPath}${productImages[product.productId]}" alt="${product.productName}" width="320" height="320" class="product-thumnail-1">
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <img src="${pageContext.request.contextPath}/assets/images/products/p-18.jpg" alt="${product.productName}" width="270" height="270" class="product-thumnail-1">
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </a>
                                                    </div>
                                                    <div class="info">
                                                        <b class="categories">
                                                            ${product.categoryId.categoryName}
                                                        </b>
                                                        <h4 class="product-title"><a href="${pageContext.request.contextPath}/product-detail?id=${product.productId}" class="pr-name">${product.productName}</a></h4>
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
                                                        <div class="shipping-info">
                                                            <p class="shipping-day">Giao hàng trong 3 ngày</p>
                                                            <p class="for-today">Nhận hàng miễn phí ngay hôm nay</p>
                                                        </div>
                                                        <div class="slide-down-box">
                                                            <p class="message">${product.shortDescription}</p>
                                                            <div class="buttons">
                                                                <a href="#" class="btn wishlist-btn" data-product-id="${product.productId}"><i class="fa fa-heart-o" aria-hidden="true"></i></a>
                                                                <a href="#" class="btn add-to-cart-btn" data-product-id="${product.productId}"><i class="fa fa-cart-arrow-down" aria-hidden="true"></i>Thêm vào giỏ</a>
                                                                
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </li>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <li class="col-lg-12">
                                            <div class="text-center" style="padding: 50px;">
                                                <h3>Không tìm thấy sản phẩm nào</h3>
                                                <p>Vui lòng thử tìm kiếm với từ khóa khác hoặc quay lại sau.</p>
                                            </div>
                                        </li>
                                    </c:otherwise>
                                </c:choose>
                            </ul>
                        </div>

                        <div class="biolife-panigations-block">
                            <ul class="panigation-contain">
                                <c:if test="${totalPages > 0}">
                                    <!-- First page -->
                                    <c:if test="${currentPage > 1}">
                                        <li>
                                            <a href="search?q=${searchKeyword}&categoryId=${searchCategoryId}&page=1<c:if test='${not empty param.price}'>&price=${param.price}</c:if><c:if test='${not empty param.brand}'>&brand=${param.brand}</c:if><c:if test='${not empty param.availability}'>&availability=${param.availability}</c:if><c:if test='${not empty param.sort}'>&sort=${param.sort}</c:if>" class="link-page first"><i class="fa fa-angle-double-left" aria-hidden="true"></i></a>
                                        </li>
                                        <!-- Previous page -->
                                        <li>
                                            <a href="search?q=${searchKeyword}&categoryId=${searchCategoryId}&page=${currentPage-1}<c:if test='${not empty param.price}'>&price=${param.price}</c:if><c:if test='${not empty param.brand}'>&brand=${param.brand}</c:if><c:if test='${not empty param.availability}'>&availability=${param.availability}</c:if><c:if test='${not empty param.sort}'>&sort=${param.sort}</c:if>" class="link-page prev"><i class="fa fa-angle-left" aria-hidden="true"></i></a>
                                        </li>
                                    </c:if>
                                    
                                    <!-- Page numbers -->
                                    <c:set var="startPage" value="${currentPage - 2}" />
                                    <c:if test="${startPage < 1}">
                                        <c:set var="startPage" value="1" />
                                    </c:if>
                                    
                                    <c:set var="endPage" value="${startPage + 4}" />
                                    <c:if test="${endPage > totalPages}">
                                        <c:set var="endPage" value="${totalPages}" />
                                    </c:if>
                                    
                                    <c:if test="${endPage - startPage < 4 && startPage > 1}">
                                        <c:set var="startPage" value="${endPage - 4}" />
                                        <c:if test="${startPage < 1}">
                                            <c:set var="startPage" value="1" />
                                        </c:if>
                                    </c:if>
                                    
                                    <c:forEach begin="${startPage}" end="${endPage}" var="i">
                                        <c:choose>
                                            <c:when test="${i == currentPage}">
                                                <li><span class="current-page">${i}</span></li>
                                            </c:when>
                                            <c:otherwise>
                                                <li>
                                                    <a href="search?q=${searchKeyword}&categoryId=${searchCategoryId}&page=${i}<c:if test='${not empty param.price}'>&price=${param.price}</c:if><c:if test='${not empty param.brand}'>&brand=${param.brand}</c:if><c:if test='${not empty param.availability}'>&availability=${param.availability}</c:if><c:if test='${not empty param.sort}'>&sort=${param.sort}</c:if>" class="link-page">${i}</a>
                                                </li>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:forEach>
                                    
                                    <!-- Next page -->
                                    <c:if test="${currentPage < totalPages}">
                                        <li>
                                            <a href="search?q=${searchKeyword}&categoryId=${searchCategoryId}&page=${currentPage+1}<c:if test='${not empty param.price}'>&price=${param.price}</c:if><c:if test='${not empty param.brand}'>&brand=${param.brand}</c:if><c:if test='${not empty param.availability}'>&availability=${param.availability}</c:if><c:if test='${not empty param.sort}'>&sort=${param.sort}</c:if>" class="link-page next"><i class="fa fa-angle-right" aria-hidden="true"></i></a>
                                        </li>
                                        <!-- Last page -->
                                        <li>
                                            <a href="search?q=${searchKeyword}&categoryId=${searchCategoryId}&page=${totalPages}<c:if test='${not empty param.price}'>&price=${param.price}</c:if><c:if test='${not empty param.brand}'>&brand=${param.brand}</c:if><c:if test='${not empty param.availability}'>&availability=${param.availability}</c:if><c:if test='${not empty param.sort}'>&sort=${param.sort}</c:if>" class="link-page last"><i class="fa fa-angle-double-right" aria-hidden="true"></i></a>
                                        </li>
                                    </c:if>
                                </c:if>
                            </ul>
                        </div>

                    </div>

                </div>
            </div>
        </div>
    </div>
<jsp:include page="/footer.jsp"/>
<script src="${pageContext.request.contextPath}/assets/js/jquery-3.4.1.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/bootstrap.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/jquery.countdown.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/jquery.nice-select.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/jquery.nicescroll.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/slick.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/biolife.framework.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/functions.js"></script>

<!-- Custom Script -->
<script>
    $(document).ready(function() {
        // Load wishlist count when page loads
        loadWishlistCountOnPageLoad();
        
        // Handle wishlist button clicks
        $('.wishlist-btn').click(function(e) {
            e.preventDefault();
            var $btn = $(this);
            var productId = $btn.data('product-id');
            
            var isLoggedIn = "${not empty sessionScope.user}" === "true";
            if (!isLoggedIn) {
                window.location.href = '${pageContext.request.contextPath}/login';
                return;
            }
            
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
                    } else {
                        $btn.removeClass('added');
                        $btn.find('i').removeClass('fa-heart').addClass('fa-heart-o');
                    }
                    
                    // Update wishlist count in header
                    updateWishlistCountBadge(response.count);
                    
                    // Show notification
                    showNotification(response.inWishlist ? 'Đã thêm vào danh sách yêu thích!' : 'Đã xóa khỏi danh sách yêu thích!');
                },
                error: function() {
                    showNotification('Vui lòng đăng nhập để sử dụng tính năng này!', 'error');
                }
            });
        });
        
        // Handle add to cart button clicks
        $('.add-to-cart-btn').click(function(e) {
            e.preventDefault();
            var productId = $(this).data('product-id');
            
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
                data: 'action=add&productID=' + encodeURIComponent(productId) + '&quantity=1',
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
</script>
</body>
</html> 