<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html class="no-js" lang="vi">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Danh sách địa chỉ - Beauty Store</title>
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
        .addresses-container {
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 8px 32px rgba(0,0,0,0.08);
            padding: 32px 28px;
            margin: 40px auto;
            max-width: 800px;
            position: relative;
        }
        
        .page-header {
            text-align: center;
            margin-bottom: 32px;
        }
        
        .page-title {
            font-size: 1.6em;
            font-weight: bold;
            color: #ff6b6b;
            margin-bottom: 8px;
        }
        
        .page-subtitle {
            color: #666;
            font-size: 14px;
        }
        
        .address-card {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 16px;
            border: 2px solid transparent;
            transition: all 0.3s ease;
            position: relative;
        }
        
        .address-card:hover {
            border-color: #ff6b6b;
            box-shadow: 0 4px 12px rgba(255,107,107,0.1);
            transform: translateY(-2px);
        }
        
        .address-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 12px;
        }
        
        .address-info {
            flex: 1;
        }
        
        .recipient-name {
            font-weight: 600;
            font-size: 16px;
            color: #333;
            margin-bottom: 4px;
        }
        
        .address-type {
            display: inline-block;
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: 500;
            margin-bottom: 8px;
        }
        
        .type-shipping {
            background: #e3f2fd;
            color: #1976d2;
        }
        
        .type-billing {
            background: #f3e5f5;
            color: #7b1fa2;
        }
        
        .default-badge {
            background: linear-gradient(45deg, #ff6b6b, #ff5252);
            color: white;
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 11px;
            font-weight: 600;
            margin-left: 8px;
        }
        
        .address-details {
            color: #666;
            font-size: 14px;
            line-height: 1.5;
        }
        
        .address-phone {
            color: #ff6b6b;
            font-weight: 500;
            margin-top: 8px;
        }
        
        .address-actions {
            display: flex;
            gap: 8px;
            margin-top: 16px;
        }
        
        .btn {
            padding: 8px 16px;
            border-radius: 6px;
            font-weight: 600;
            font-size: 13px;
            border: none;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
            text-align: center;
        }
        
        .btn-edit {
            background: linear-gradient(45deg, #28a745, #20c997);
            color: white;
        }
        
        .btn-edit:hover {
            background: linear-gradient(45deg, #20c997, #28a745);
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(40,167,69,0.3);
        }
        
        .btn-delete {
            background: linear-gradient(45deg, #dc3545, #c82333);
            color: white;
        }
        
        .btn-delete:hover {
            background: linear-gradient(45deg, #c82333, #dc3545);
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(220,53,69,0.3);
        }
        
        .btn-add {
            background: linear-gradient(45deg, #ff6b6b, #ff5252);
            color: white;
            padding: 12px 24px;
            font-size: 14px;
        }
        
        .btn-add:hover {
            background: linear-gradient(45deg, #ff5252, #ff6b6b);
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(255,107,107,0.3);
        }
        
        .empty-state {
            text-align: center;
            padding: 40px 20px;
            color: #666;
        }
        
        .empty-state i {
            font-size: 48px;
            color: #ddd;
            margin-bottom: 16px;
        }
        
        .empty-state h3 {
            color: #999;
            margin-bottom: 8px;
        }
        
        .empty-state p {
            color: #bbb;
            margin-bottom: 24px;
        }
        
        .page-actions {
            text-align: center;
            margin-top: 32px;
        }
        
        @media (max-width: 600px) {
            .addresses-container {
                margin: 20px 10px;
                padding: 24px 20px;
            }
            
            .address-header {
                flex-direction: column;
                gap: 12px;
            }
            
            .address-actions {
                flex-direction: column;
            }
            
            .btn {
                width: 100%;
            }
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

    <!-- MAIN CONTENT -->
    <div class="page-contain">
        <div class="container">
            <div class="row">
                <div class="col-lg-12">
                    <div class="addresses-container">
                        <div class="page-header">
                            <h2 class="page-title">Danh sách địa chỉ</h2>
                            <p class="page-subtitle">Quản lý địa chỉ giao hàng và thanh toán của bạn</p>
                        </div>
                        
                        <c:if test="${empty addresses}">
                            <div class="empty-state">
                                <i class="fa fa-map-marker"></i>
                                <h3>Chưa có địa chỉ nào</h3>
                                <p>Bạn chưa thêm địa chỉ nào. Hãy thêm địa chỉ đầu tiên để bắt đầu.</p>
                                <a href="addresses?action=create" class="btn btn-add">
                                    <i class="fa fa-plus"></i> Thêm địa chỉ mới
                                </a>
                            </div>
                        </c:if>
                        
                        <c:if test="${not empty addresses}">
                            <c:forEach var="address" items="${addresses}">
                                <div class="address-card">
                                    <div class="address-header">
                                        <div class="address-info">
                                            <div class="recipient-name">${address.recipientName}</div>
                                            <div>
                                                <span class="address-type type-${address.addressType}">
                                                    <c:choose>
                                                        <c:when test="${address.addressType == 'shipping'}">
                                                            <i class="fa fa-truck"></i> Giao hàng
                                                        </c:when>
                                                        <c:otherwise>
                                                            <i class="fa fa-credit-card"></i> Thanh toán
                                                        </c:otherwise>
                                                    </c:choose>
                                                </span>
                                                <c:if test="${address.isDefault}">
                                                    <span class="default-badge">Mặc định</span>
                                                </c:if>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <div class="address-details">
                                        ${address.addressDetail}, ${address.ward}, ${address.district}, ${address.province}
                                    </div>
                                    
                                    <div class="address-phone">
                                        <i class="fa fa-phone"></i> ${address.phone}
                                    </div>
                                    
                                    <div class="address-actions">
                                        <a href="updateAddress?id=${address.addressID}" class="btn btn-edit">
                                            <i class="fa fa-edit"></i> Chỉnh sửa
                                        </a>
                                        <a href="deleteAddress?id=${address.addressID}" class="btn btn-delete" 
                                           onclick="return confirm('Bạn có chắc chắn muốn xóa địa chỉ này?')">
                                            <i class="fa fa-trash"></i> Xóa
                                        </a>
                                    </div>
                                </div>
                            </c:forEach>
                            
                            <div class="page-actions">
                                <a href="addresses?action=create" class="btn btn-add">
                                    <i class="fa fa-plus"></i> Thêm địa chỉ mới
                                </a>
                            </div>
                        </c:if>
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
                            <a href="#" class="logo footer-logo">Beauty Store</a>
                            <div class="footer-phone-info">
                                <i class="biolife-icon icon-head-phone"></i>
                                <p class="r-info">
                                    <span>Got Questions ?</span>
                                    <span>(700) 9001-1909  (900) 689 -66</span>
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
                    <li class="list-item"><a href="#">€ EUR (Euro)</a></li>
                    <li class="list-item"><a href="#">$ USD (Dollar)</a></li>
                    <li class="list-item"><a href="#">£ GBP (Pound)</a></li>
                    <li class="list-item"><a href="#">¥ JPY (Yen)</a></li>
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
            // Hover effects for address cards
            $('.address-card').hover(
                function() {
                    $(this).addClass('hover');
                },
                function() {
                    $(this).removeClass('hover');
                }
            );
            
            // Confirm delete action
            $('.btn-delete').click(function(e) {
                if (!confirm('Bạn có chắc chắn muốn xóa địa chỉ này?')) {
                    e.preventDefault();
                }
            });
        });
    </script>
</body>
</html> 