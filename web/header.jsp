<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>


<style>
    .horizontal-menu {
    display: flex !important;
    flex-wrap: nowrap !important;
    align-items: center;
    width: 100%;
    padding: 0;
    margin: 0;
    list-style: none;
    background: #ea3a11;
    min-width: 0;
    box-sizing: border-box;
}
.horizontal-menu li {
    padding: 0 10px;
    min-width: 0;
    white-space: nowrap;
    flex-shrink: 0;
}
.header-marquee {
    flex: 1 1 0;
    min-width: 0;
    text-align: center;
    font-weight: 500;
    color: #fff;
    padding: 0 8px;
    white-space: nowrap;
    overflow: visible; /* Sửa lại để không bị cắt */
    text-overflow: unset; /* Không hiện ... */
}


</style>
<header id="header" class="header-area style-01 layout-04">
    <div class="header-top bg-main hidden-xs">
        <div class="container">
            <div class="top-bar left">
               <ul class="horizontal-menu">
    <li><a href="mailto:Organic@company.com"><i class="fa fa-envelope"></i> GroupVIII@gmail.com</a></li>
    <li><a href="tel:+84796570060"><i class="fa fa-phone"></i> (+84) 079 657 0060</a></li>
    
    <li>
        <a href="https://www.facebook.com/ngoc.son.76917" target="_blank">
            <i class="fa fa-facebook"></i>
        </a>
        <a href="https://chat.zalo.me/" target="_blank">
            <i class="fa fa-comment"></i>
        </a>
        <a href="https://www.instagram.com/sonnnw_8?igsh=MXVzaXAzYTQ1NDN1OA%3D%3D&utm_source=qr" target="_blank">
            <i class="fa fa-instagram"></i>
        </a>
    </li>
    
    <li class="header-marquee">🎉 Ưu đãi: FREESHIP99 | 10.000+ khách hàng tin dùng!</li>
    
</ul>



            </div>
            <div class="top-bar right">                <ul class="horizontal-menu">
                    <c:choose>
                        <c:when test="${not empty sessionScope.user}">                            <li class="horz-menu-item user-info dropdown-account">                                <a href="#" class="user-greeting dropdown-toggle" style="color: #fff; margin-right: 10px; font-weight: 500; text-decoration: none;">
                                    <!-- DEBUG: Avatar value = ${sessionScope.user.avatar} -->
                                    <!-- Display user avatar or default icon -->
                                    <c:choose>
                                        <c:when test="${not empty sessionScope.user.avatar}">
                                            <c:choose>
                                                <c:when test="${fn:startsWith(sessionScope.user.avatar, 'http')}">
                                                    <!-- Google avatar URL -->
                                                    <img src="${sessionScope.user.avatar}" alt="Avatar" style="width: 24px; height: 24px; border-radius: 50%; margin-right: 5px; vertical-align: middle;" onerror="console.log('Avatar load error:', this.src);">
                                                </c:when>
                                                <c:otherwise>
                                                    <!-- Local avatar file -->
                                                    <img src="${pageContext.request.contextPath}/uploads/avatars/${sessionScope.user.avatar}" alt="Avatar" style="width: 24px; height: 24px; border-radius: 50%; margin-right: 5px; vertical-align: middle;" onerror="console.log('Avatar load error:', this.src);">
                                                </c:otherwise>
                                            </c:choose>
                                        </c:when>
                                        <c:otherwise>
                                            <!-- Default user icon -->
                                            <i class="fa fa-user" aria-hidden="true" style="margin-right: 5px;"></i>
                                        </c:otherwise>
                                    </c:choose>
                                    Xin Chào, <strong>
                                        <c:choose>
                                            <c:when test="${not empty sessionScope.user.fullName}">
                                                ${sessionScope.user.fullName}
                                            </c:when>
                                            <c:otherwise>
                                                ${sessionScope.user.username}
                                            </c:otherwise>
                                        </c:choose>
                                    </strong>!
                                    <i class="fa fa-chevron-down" aria-hidden="true" style="margin-left: 5px; font-size: 12px;"></i>
                                </a><ul class="dropdown-menu account-menu">
                                    <li><a href="${pageContext.request.contextPath}/dashboard"><i class="fa fa-dashboard"></i>Dashboard</a></li>
                                    <li><a href="${pageContext.request.contextPath}/profile"><i class="fa fa-user"></i>Thông tin cá nhân</a></li>
                                    <li><a href="${pageContext.request.contextPath}/profile?action=edit"><i class="fa fa-edit"></i>Chỉnh sửa thông tin</a></li>
                                    <li><a href="${pageContext.request.contextPath}/profile?action=change-password"><i class="fa fa-key"></i>Đổi mật khẩu</a></li>
                                    <li><a href="${pageContext.request.contextPath}/wishlist"><i class="fa fa-heart"></i>Danh sách yêu thích</a></li>
                                    <li><a href="${pageContext.request.contextPath}/orders"><i class="fa fa-list-alt"></i>Đơn hàng của tôi</a></li>
                                        <c:if test="${sessionScope.user.role == 'admin'}">
                                        <li class="divider"></li>
                                        <li><a href="admin-dashboard"><i class="fa fa-cog"></i>Admin Dashboard</a></li>
                                        </c:if>
                                    <li class="divider"></li>
                                    <li><a href="logout"><i class="fa fa-sign-out"></i>Đăng Xuất</a></li>
                                </ul>
                            </li>
                        </c:when>
                        <c:otherwise>
                            <li class="horz-menu-item">
                                <a href="login" class="login-link">
                                    <i class="biolife-icon icon-login"></i>Login/Register
                                </a>
                            </li>
                        </c:otherwise>
                    </c:choose>
                </ul>
            </div>
        </div>
    </div>
    <div class="header-middle biolife-sticky-object ">
        <div class="container">
            <div class="row">
                <div class="col-lg-3 col-md-2 col-md-6 col-xs-6">
                    <a href="home" class="biolife-logo">
                        <img src="assets/images/organic-3.png" alt="biolife logo" width="215" height="80">
                    </a>
                </div>
                <div class="col-lg-6 col-md-7 hidden-sm hidden-xs">
                    <div class="primary-menu">
                        <ul class="menu biolife-menu clone-main-menu clone-primary-menu" id="primary-menu" data-menuname="main menu">
                            <li class="menu-item"><a href="home">Home</a></li>
                            <li class="menu-item menu-item-has-children has-megamenu">
                                <a href="about-shop.jsp" class="menu-name" data-title="Shop" >About Shop</a>
                            </li>
                            
                           <li class="menu-item menu-item-has-children has-child">
    <a href="#" class="menu-name" data-title="Product">Product</a>
    <ul class="sub-menu">
        <!-- Mục "Tất cả sản phẩm" -->
        <li class="menu-item">
            <a href="${pageContext.request.contextPath}/all-products">Tất cả sản phẩm</a>
        </li>
        <!-- Lặp các danh mục cấp 1 (parentCategoryId = 1) -->
        <c:forEach var="cat1" items="${allCategories}">
            <c:if test="${cat1.parentCategoryId != null && cat1.parentCategoryId.categoryId == 1}">
                <li class="menu-item
                    <c:forEach var='cat2' items='${allCategories}'>
                        <c:if test='${cat2.parentCategoryId != null && cat2.parentCategoryId.categoryId == cat1.categoryId}'> menu-item-has-children has-child</c:if>
                    </c:forEach>">
                    <a href="${pageContext.request.contextPath}/category?categoryId=${cat1.categoryId}">
                        ${cat1.categoryName}
                    </a>
                    <!-- Dropdown cấp 2 (nếu có) -->
                    <c:set var="hasChild" value="false" />
                    <c:forEach var="cat2" items="${allCategories}">
                        <c:if test="${cat2.parentCategoryId != null && cat2.parentCategoryId.categoryId == cat1.categoryId}">
                            <c:set var="hasChild" value="true" />
                        </c:if>
                    </c:forEach>
                    <c:if test="${hasChild}">
                        <ul class="sub-menu">
                            <c:forEach var="cat2" items="${allCategories}">
                                <c:if test="${cat2.parentCategoryId != null && cat2.parentCategoryId.categoryId == cat1.categoryId && cat2.categoryId != cat1.categoryId}">
                                    <li class="menu-item">
                                        <a href="${pageContext.request.contextPath}/category?categoryId=${cat2.categoryId}">
                                            ${cat2.categoryName}
                                        </a>
                                    </li>
                                </c:if>
                            </c:forEach>
                        </ul>
                    </c:if>
                </li>
            </c:if>
        </c:forEach>
    </ul>
</li>


                            
                            <li class="menu-item"><a href="contact_us.jsp">Contact</a></li>
                            
                        </ul>
                    </div>
                </div>
                <div class="col-lg-3 col-md-3 col-md-6 col-xs-6">
                    <div class="biolife-cart-info">
                                                <div class="wishlist-block hidden-sm hidden-xs">
                            <a href="${pageContext.request.contextPath}/wishlist" class="link-to wishlist-link">
                                <span class="icon-qty-combine">
                                    <i class="icon-heart-bold biolife-icon"></i>
                                    <span class="qty wishlist-count-badge" id="wishlist-count-badge" style="display: none;">0</span>
                                </span>
                            </a>
                        </div>
                        <div class="minicart-block">
                            <div class="minicart-contain">
                                <a href="${pageContext.request.contextPath}/cart" class="link-to" id="cart-link">
                                    <span class="icon-qty-combine">
                                        <i class="icon-cart-mini biolife-icon"></i>
                                        <span class="qty" id="cart-badge">0</span>
                                    </span>
                                    <span class="title">My Cart</span>
                                    
                                </a>
                                <div class="cart-content" id="mini-cart-content" style="display:none; position:absolute; right:0; background:#fff; border:1px solid #eee; border-radius:8px; min-width:320px; box-shadow:0 2px 8px rgba(0,0,0,0.15); z-index:9999;">
                                    <div id="mini-cart-items" style="max-height:320px; overflow-y:auto;"></div>
                                    <div style="padding:12px; border-top:1px solid #eee; text-align:right;">
                                        <a href="${pageContext.request.contextPath}/cart" class="btn btn-primary">Xem giỏ hàng</a>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="mobile-menu-toggle">
                            <a class="btn-toggle" data-object="open-mobile-menu" href="javascript:void(0)">
                                <span></span>
                                <span></span>
                                <span></span>
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>    </div>
    <div class="header-bottom hidden-sm hidden-xs">
        <div class="container">
            <div class="row">
                <div class="col-lg-3 col-md-4">
                    <div class="vertical-menu vertical-category-block">
                        <div class="block-title">
                            <span class="menu-icon">
                                <span class="line-1"></span>
                                <span class="line-2"></span>
                                <span class="line-3"></span>
                            </span>
                            <span class="menu-title">Danh mục sản phẩm</span>
                            <span class="angle" data-tgleclass="fa fa-caret-down"><i class="fa fa-caret-up" aria-hidden="true"></i></span>
                        </div>
                        <div class="wrap-menu">
                            <ul class="menu clone-main-menu">
                                <c:forEach var="cat1" items="${allCategories}">
                                    <c:if test="${cat1.parentCategoryId != null && cat1.parentCategoryId.categoryId == 1}">
                                        <li class="menu-item menu-item-has-children has-megamenu">
                                            <a href="${pageContext.request.contextPath}/category?categoryId=${cat1.categoryId}" class="menu-name">${cat1.categoryName}</a>
                                            <c:set var="hasChild" value="false" />
                                            <c:forEach var="cat2" items="${allCategories}">
                                                <c:if test="${cat2.parentCategoryId != null && cat2.parentCategoryId.categoryId == cat1.categoryId}">
                                                    <c:set var="hasChild" value="true" />
                                                </c:if>
                                            </c:forEach>
                                            <c:if test="${hasChild}">
                                                <div class="wrap-megamenu lg-width-900 md-width-640">
                                                    <div class="mega-content">
                                                        <div class="row">
                                                            <div class="col-lg-4 col-md-6 col-sm-12">
                                                                <div class="wrap-custom-menu vertical-menu">
                                                                    <h4 class="menu-title">${cat1.categoryName}</h4>
                                                                    <ul class="menu">
                                                                        <c:forEach var="cat2" items="${allCategories}">
                                                                            <c:if test="${cat2.parentCategoryId != null && cat2.parentCategoryId.categoryId == cat1.categoryId && cat2.categoryId != cat1.categoryId}">
                                                                                <li><a href="${pageContext.request.contextPath}/category?categoryId=${cat2.categoryId}">${cat2.categoryName}</a></li>
                                                                            </c:if>
                                                                        </c:forEach>
                                                                    </ul>
                                                                </div>
                                                            </div>
                                                            <div class="col-lg-4 col-md-6 col-sm-12">
                                                                <c:if test="${not empty bestsellers[cat1.categoryId]}">
   
    <c:set var="bsp" value="${bestsellers[cat1.categoryId]}" />
    <div class="biolife-products-block max-width-270">
        <h4 class="menu-title">Bestseller</h4>
        <ul class="products-list default-product-style">
            <li class="product-item">
                <div class="contain-product none-overlay">
                    <div class="product-thumb">
                        <a href="${pageContext.request.contextPath}/product-detail?id=${bsp.productId}" class="link-to-product">
                            <img src="${pageContext.request.contextPath}${productImages[bsp.productId]}" alt="${bsp.productName}" width="120" class="product-thumnail">
                        </a>
                    </div>
                    <div class="info">
                        <b class="categories">${bsp.categoryId.categoryName}</b>
                        <h4 class="product-title"><a href="${pageContext.request.contextPath}/product-detail?id=${bsp.productId}" class="pr-name">${bsp.productName}</a></h4>
                        <div class="price">
                            <c:choose>
                                <c:when test="${bsp.salePrice != null && bsp.salePrice > 0 && bsp.salePrice < bsp.price}">
                                    <ins><span class="price-amount"><fmt:formatNumber value='${bsp.salePrice}' type='number' groupingUsed='true'/> <span class='currencySymbol'>₫</span></span></ins>
                                    <del><span class="price-amount"><fmt:formatNumber value='${bsp.price}' type='number' groupingUsed='true'/> <span class='currencySymbol'>₫</span></span></del>
                                </c:when>
                                <c:otherwise>
                                    <ins><span class="price-amount"><fmt:formatNumber value='${bsp.price}' type='number' groupingUsed='true'/> <span class='currencySymbol'>₫</span></span></ins>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </li>
        </ul>
    </div>
</c:if>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </c:if>
                                        </li>
                                    </c:if>
                                </c:forEach>
                            </ul>
                        </div>
                    </div>
                </div>
                <div class="col-lg-9 col-md-8 padding-top-2px">
                    <div class="header-search-bar layout-01">
                        <form action="${pageContext.request.contextPath}/search" class="form-search" name="desktop-search" method="get">
    <input type="text" name="q" class="input-text" value="${param.q}" placeholder="Tìm kiếm...">
    <select name="categoryId">
        <option value="-1" ${empty param.categoryId || param.categoryId == '-1' ? "selected" : ""}>Tất cả danh mục</option>
        <c:forEach var="cat" items="${allCategories}">
            <c:if test="${cat.parentCategoryId != null && cat.parentCategoryId.categoryId == 1}">
                <option value="${cat.categoryId}" ${param.categoryId == cat.categoryId ? "selected" : ""}>
                    ${cat.categoryName}
                </option>
            </c:if>
        </c:forEach>
    </select>
    <button type="submit" class="btn-submit"><i class="biolife-icon icon-search"></i></button>
</form>


                    </div>
                    <div class="live-info">
                        <p class="telephone"><i class="fa fa-phone" aria-hidden="true"></i><b class="phone-number">(+84) 079 657 0060</b></p>
                        <p class="working-time">Mon-Fri: 8:30am-7:30pm; Sat-Sun: 9:30am-4:30pm</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</header>

<!-- Wishlist JavaScript -->
<c:if test="${not empty sessionScope.user}">
    <script>
        // Set context path for JavaScript
        window.contextPath = '${pageContext.request.contextPath}';
        
        document.addEventListener('DOMContentLoaded', function() {
            // Check if jQuery is already loaded
            if (typeof jQuery === 'undefined') {
                // Load jQuery dynamically if not available
                var script = document.createElement('script');
                script.src = 'https://code.jquery.com/jquery-3.6.0.min.js';
                script.onload = initializeUserFeatures;
                document.head.appendChild(script);
            } else {
                // jQuery already loaded, proceed directly
                initializeUserFeatures();
            }
        });
        
        function initializeUserFeatures() {
            // Load wishlist count
            loadWishlistCount();
            
            // Initialize dropdown functionality with direct DOM handling for better reliability
            const dropdownToggle = document.querySelector('.dropdown-toggle');
            const dropdownMenu = document.querySelector('.dropdown-menu');
            const dropdownAccount = document.querySelector('.dropdown-account');
            
            if (dropdownToggle) {
                // Add direct click listener to the toggle button
                dropdownToggle.addEventListener('click', function(e) {
                    e.preventDefault();
                    e.stopPropagation();
                    dropdownAccount.classList.toggle('open');
                });
                
                // Close dropdown when clicking elsewhere
                document.addEventListener('click', function(e) {
                    if (!dropdownAccount.contains(e.target)) {
                        dropdownAccount.classList.remove('open');
                    }
                });
                
                // Prevent dropdown from closing when clicking inside menu
                if (dropdownMenu) {
                    dropdownMenu.addEventListener('click', function(e) {
                        e.stopPropagation();
                    });
                }
                
                // Log that initialization was successful
                console.log('Dropdown menu initialized successfully');
            } else {
                console.warn('Dropdown toggle element not found');
            }
        }

        function loadWishlistCount() {
            try {
                $.ajax({
                    url: '${pageContext.request.contextPath}/wishlist/count',
                    type: 'GET',
                    dataType: 'json',
                    headers: {
                        'X-Requested-With': 'XMLHttpRequest'
                    },
                    success: function (response) {
                        updateWishlistCount(response.count);
                    },
                    error: function (xhr, status, error) {
                        // Silently fail for wishlist count
                        console.log('Could not load wishlist count:', error);
                    }
                });
            } catch (e) {
                console.log('Error in loadWishlistCount:', e);
            }
        }

        function updateWishlistCount(count) {
            try {
                const badge = $('#wishlist-count-badge');
                if (badge) {
                    if (count > 0) {
                        badge.text(count).show();
                    } else {
                        badge.hide();
                    }
                }
            } catch (e) {
                console.log('Error in updateWishlistCount:', e);
            }
        }
        
        // Hàm cập nhật wishlist count từ bên ngoài
        function updateWishlistCountBadge(count) {
            updateWishlistCount(count);
        }
    </script>

    <style>
        /* Account Dropdown Enhanced Styles */
        #header {
            position: relative;
            z-index: 999;
        }

        /* Enhanced Account Dropdown */
        #header .dropdown-account {
            position: relative;
            display: inline-block;
        }

        #header .dropdown-toggle {
            cursor: pointer;
            transition: all 0.3s ease;
            user-select: none;
            display: flex;
            align-items: center;
            background: rgba(255, 255, 255, 0.1);
            padding: 0px 10px;
            margin: 5px 0px;
            border-radius: 30px;
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        #header .dropdown-toggle:hover {
            background: rgba(255, 255, 255, 0.2);
            transform: translateY(-1px);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        #header .dropdown-toggle img {
            border: 2px solid #fff;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
            transition: all 0.3s ease;
        }

        #header .dropdown-toggle:hover img {
            transform: scale(1.1);
        }

        #header .dropdown-toggle strong {
            position: relative;
            display: inline-block;
        }

        #header .dropdown-toggle strong:after {
            content: '';
            position: absolute;
            width: 0;
            height: 2px;
            bottom: -2px;
            left: 0;
            background: #fff;
            transition: all 0.3s ease;
        }

        #header .dropdown-toggle:hover strong:after {
            width: 100%;
        }

        #header .dropdown-toggle .fa-chevron-down {
            transition: all 0.3s ease;
            margin-left: 8px;
            font-size: 10px;
            background: rgba(255, 255, 255, 0.2);
            width: 18px;
            height: 18px;
            border-radius: 50%;
            display: inline-flex;
            align-items: center;
            justify-content: center;
        }

        #header .dropdown-account.open .dropdown-toggle .fa-chevron-down {
            transform: rotate(180deg);
            background: #fff;
            color: #73814B;
        }

        /* Beautifully styled dropdown menu */
        #header .dropdown-menu {
            position: absolute !important;
            top: 130% !important;
            right: 0 !important;
            background: #ffffff !important;
            border-radius: 12px !important;
            min-width: 250px !important;
            padding: 0 !important;
            margin: 0 !important;
            opacity: 0 !important;
            visibility: hidden !important;
            transform: translateY(15px) !important;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.15) !important;
            transition: all 0.4s cubic-bezier(0.165, 0.84, 0.44, 1) !important;
            border: none !important;
            overflow: hidden !important;
            z-index: 10000 !important;
        }

        #header .dropdown-account.open .dropdown-menu {
            opacity: 1 !important;
            visibility: visible !important;
            transform: translateY(10px) !important;
        }

        /* User info header in dropdown */
        #header .dropdown-menu:before {
            content: "";
            position: absolute;
            top: -8px;
            right: 20px;
            border-left: 8px solid transparent;
            border-right: 8px solid transparent;
            border-bottom: 8px solid #ffffff;
        }

        /* Add user header section */
        #header .dropdown-menu:after {
            content: "";
            display: block;
            height: 5px;
            width: 100%;
            background: linear-gradient(to right, #73814B, #89a34f, #73814B);
            position: absolute;
            top: 0;
            left: 0;
        }

        /* Menu items styling */
        #header .dropdown-menu li {
            list-style: none !important;
            margin: 0 !important;
            padding: 0 !important;
            position: relative !important;
        }

        #header .dropdown-menu li:first-child {
            margin-top: 5px !important;
        }

        #header .dropdown-menu li a {
            display: flex !important;
            align-items: center !important;
            padding: 12px 20px !important;
            color: #4a4a4a !important;
            font-size: 14px !important;
            font-weight: 500 !important;
            text-decoration: none !important;
            transition: all 0.3s ease !important;
            border-left: 3px solid transparent !important;
            border-bottom: 1px solid rgba(0,0,0,0.03) !important;
            position: relative !important;
            overflow: hidden !important;
        }

        #header .dropdown-menu li:last-child a {
            border-bottom: none !important;
        }

        #header .dropdown-menu li a:before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            height: 100%;
            width: 0;
            background: rgba(115, 129, 75, 0.08);
            z-index: -1;
            transition: all 0.3s ease;
        }

        #header .dropdown-menu li a:hover {
            color: #73814B !important;
            border-left-color: #73814B !important;
            padding-left: 24px !important;
            background: transparent !important;
            transform: none !important;
        }

        #header .dropdown-menu li a:hover:before {
            width: 100%;
        }

        #header .dropdown-menu li a i {
            margin-right: 12px !important;
            font-size: 16px !important;
            width: 20px !important;
            text-align: center !important;
            color: #73814B !important;
            opacity: 0.75 !important;
            transition: all 0.3s ease !important;
        }

        #header .dropdown-menu li a:hover i {
            opacity: 1 !important;
            transform: scale(1.15) !important;
        }

        /* Divider styling */
        #header .dropdown-menu .divider {
            height: 1px !important;
            margin: 6px 0 !important;
            background: linear-gradient(to right, rgba(0,0,0,0.02), rgba(0,0,0,0.06), rgba(0,0,0,0.02)) !important;
            border: none !important;
        }

        /* Logout specific styling */
        #header .dropdown-menu li:last-child a {
            color: #e74c3c !important;
        }

        #header .dropdown-menu li:last-child a i {
            color: #e74c3c !important;
        }

        #header .dropdown-menu li:last-child a:hover {
            background: rgba(231, 76, 60, 0.08) !important;
            border-left-color: #e74c3c !important;
        }

        /* Admin item styling */
        #header .dropdown-menu li a[href*="admin"] {
            color: #3498db !important;
        }

        #header .dropdown-menu li a[href*="admin"] i {
            color: #3498db !important;
        }

        #header .dropdown-menu li a[href*="admin"]:hover {
            background: rgba(52, 152, 219, 0.08) !important;
            border-left-color: #3498db !important;
        }

        /* Mobile responsive */
        @media (max-width: 768px) {
            #header .dropdown-account {
                position: static;
            }

            #header .dropdown-menu {
                position: fixed !important;
                top: 60px !important;
                right: 10px !important;
                left: 10px !important;
                min-width: auto !important;
                max-width: none !important;
                border-radius: 8px !important;
                transform: translateY(8px) !important;
            }

            #header .dropdown-toggle {
                padding: 4px 10px;
            }
        }

        @media (max-width: 480px) {
            #header .dropdown-menu {
                right: 5px !important;
                left: 5px !important;
                border-radius: 8px !important;
            }

            #header .dropdown-menu li a {
                padding: 15px 20px !important;
                font-size: 15px !important;
            }
            
            #header .dropdown-toggle {
                padding: 3px 8px;
            }
            
            #header .dropdown-toggle img {
                width: 20px !important;
                height: 20px !important;
            }
        }

        /* Animation for menu items */
        @keyframes fadeInItem {
            from {
                opacity: 0;
                transform: translateY(8px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        #header .dropdown-menu li {
            opacity: 0;
            transform: translateY(8px);
            animation: fadeInItem 0.3s ease forwards;
        }

        #header .dropdown-menu li:nth-child(1) { animation-delay: 0.05s; }
        #header .dropdown-menu li:nth-child(2) { animation-delay: 0.1s; }
        #header .dropdown-menu li:nth-child(3) { animation-delay: 0.15s; }
        #header .dropdown-menu li:nth-child(4) { animation-delay: 0.2s; }
        #header .dropdown-menu li:nth-child(5) { animation-delay: 0.25s; }
        #header .dropdown-menu li:nth-child(6) { animation-delay: 0.3s; }
        #header .dropdown-menu li:nth-child(7) { animation-delay: 0.35s; }
        #header .dropdown-menu li:nth-child(8) { animation-delay: 0.4s; }
        #header .dropdown-menu li:nth-child(9) { animation-delay: 0.45s; }

        /* Wishlist styles in header */
        .wishlist-link {
            position: relative;
            display: inline-block;
            padding: 10px;
            transition: all 0.3s ease;
        }

        .wishlist-link:hover {
            transform: scale(1.1);
        }

        .wishlist-link .icon-qty-combine {
            position: relative;
            display: inline-block;
        }

        .wishlist-link i.fa-heart {
            font-size: 24px;
            color: #666;
            transition: all 0.3s ease;
        }

        .wishlist-link:hover i.fa-heart {
            color: #73814B;
        }

        .wishlist-count-badge {
            position: absolute;
            top: -8px;
            right: -8px;
            background-color: #73814B;
            color: white;
            border-radius: 50%;
            padding: 2px 6px;
            font-size: 12px;
            min-width: 20px;
            text-align: center;
            box-shadow: 0 2px 5px rgba(0,0,0,0.2);
            transition: all 0.3s ease;
        }

        .wishlist-link:hover .wishlist-count-badge {
            transform: scale(1.1);
            background-color: #5c6a3d;
        }

        /* Animation for count update */
        @keyframes countUpdate {
            0% { transform: scale(1); }
            50% { transform: scale(1.2); }
            100% { transform: scale(1); }
        }

        .wishlist-count-badge.updating {
            animation: countUpdate 0.3s ease-in-out;
        }
    </style>
</c:if>

<script>
    // Đảm bảo contextPath luôn đúng
    window.contextPath = window.contextPath || '${pageContext.request.contextPath}';
    // Hàm cập nhật badge giỏ hàng
    function updateCartBadge(count) {
        var badge = document.getElementById('cart-badge');
        if (badge) {
            badge.textContent = count;
            badge.style.display = count > 0 ? 'inline-block' : 'none';
            badge.classList.add('updating');
            setTimeout(() => badge.classList.remove('updating'), 300);
        }
    }
    // Hàm load số lượng cart khi load trang
    function loadCartCountOnPageLoad() {
        fetch(window.contextPath + '/cart?action=miniCart', {
            method: 'GET',
            headers: { 'X-Requested-With': 'XMLHttpRequest' }
        })
        .then(response => response.json())
        .then(data => {
            updateCartBadge(data.cartCount);
        });
    }
    document.addEventListener('DOMContentLoaded', loadCartCountOnPageLoad);
    // Lắng nghe sự kiện custom khi thêm vào giỏ hàng từ trang khác
    window.addEventListener('cart-updated', function(e) {
        if (e.detail && typeof e.detail.cartCount !== 'undefined') {
            updateCartBadge(e.detail.cartCount);
        }
    });
</script>