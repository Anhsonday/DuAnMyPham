<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html class="no-js" lang="vi">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Cập nhật địa chỉ - Beauty Store</title>
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
        .address-form-container {
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 8px 32px rgba(0,0,0,0.08);
            padding: 32px 28px;
            margin: 40px auto;
            max-width: 600px;
            position: relative;
        }
        
        .form-header {
            text-align: center;
            margin-bottom: 28px;
        }
        
        .form-title {
            font-size: 1.4em;
            font-weight: bold;
            color: #ff6b6b;
            margin-bottom: 8px;
        }
        
        .form-subtitle {
            color: #666;
            font-size: 14px;
        }
        
        .form-group {
            margin-bottom: 18px;
        }
        
        .form-label {
            font-weight: 600;
            color: #333;
            margin-bottom: 6px;
            display: block;
            font-size: 14px;
        }
        
        .form-control {
            border: 2px solid #e1e5e9;
            border-radius: 8px;
            padding: 10px 14px;
            font-size: 14px;
            transition: all 0.3s ease;
            width: 100%;
            background: #fff;
        }
        
        .form-control:focus {
            outline: none;
            border-color: #ff6b6b;
            box-shadow: 0 0 0 3px rgba(255,107,107,0.1);
        }
        
        .radio-group {
            display: flex;
            gap: 20px;
            margin-bottom: 18px;
            justify-content: center;
        }
        
        .radio-item {
            display: flex;
            align-items: center;
            gap: 6px;
            cursor: pointer;
        }
        
        .radio-item input[type="radio"] {
            accent-color: #ff6b6b;
            transform: scale(1.1);
        }
        
        .radio-item label {
            font-weight: 500;
            color: #333;
            margin: 0;
            cursor: pointer;
        }
        
        .checkbox-group {
            display: flex;
            align-items: center;
            gap: 8px;
            margin-bottom: 20px;
        }
        
        .checkbox-group input[type="checkbox"] {
            accent-color: #ff6b6b;
            transform: scale(1.1);
        }
        
        .checkbox-group label {
            font-weight: 500;
            color: #333;
            margin: 0;
            cursor: pointer;
        }
        
        .form-buttons {
            display: flex;
            gap: 12px;
            justify-content: center;
            margin-top: 24px;
        }
        
        .btn {
            padding: 10px 24px;
            border-radius: 6px;
            font-weight: 600;
            font-size: 14px;
            border: none;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
            text-align: center;
        }
        
        .btn-primary {
            background: linear-gradient(45deg, #ff6b6b, #ff5252);
            color: white;
        }
        
        .btn-primary:hover {
            background: linear-gradient(45deg, #ff5252, #ff6b6b);
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(255,107,107,0.3);
        }
        
        .btn-secondary {
            background: #6c757d;
            color: white;
        }
        
        .btn-secondary:hover {
            background: #5a6268;
            transform: translateY(-1px);
        }
        
        .required {
            color: #ff6b6b;
        }
        
        @media (max-width: 600px) {
            .address-form-container {
                margin: 20px 10px;
                padding: 24px 20px;
            }
            
            .radio-group {
                flex-direction: column;
                gap: 12px;
                align-items: flex-start;
            }
            
            .form-buttons {
                flex-direction: column;
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
                    <div class="address-form-container">
                        <div class="form-header">
                            <h2 class="form-title">Cập nhật địa chỉ</h2>
                            <p class="form-subtitle">Chỉnh sửa thông tin địa chỉ của bạn</p>
                        </div>
                        
                        <form action="updateAddress" method="post" id="addressForm">
                            <input type="hidden" name="addressID" value="${address.addressID}">
                            
                            <!-- Loại địa chỉ -->
                            <div class="form-group">
                                <label class="form-label">Loại địa chỉ <span class="required">*</span></label>
                                <div class="radio-group">
                                    <div class="radio-item">
                                        <input type="radio" id="shipping" name="addressType" value="shipping" 
                                               <c:if test="${address.addressType == 'shipping'}">checked</c:if>>
                                        <label for="shipping">Địa chỉ giao hàng</label>
                                    </div>
                                    <div class="radio-item">
                                        <input type="radio" id="billing" name="addressType" value="billing"
                                               <c:if test="${address.addressType == 'billing'}">checked</c:if>>
                                        <label for="billing">Địa chỉ thanh toán</label>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Họ và tên -->
                            <div class="form-group">
                                <label class="form-label">Họ và tên <span class="required">*</span></label>
                                <input type="text" name="recipientName" class="form-control" 
                                       value="${address.recipientName}" placeholder="Nhập họ và tên..." required>
                            </div>
                            
                            <!-- Số điện thoại -->
                            <div class="form-group">
                                <label class="form-label">Số điện thoại <span class="required">*</span></label>
                                <input type="tel" name="phone" class="form-control" 
                                       value="${address.phone}" placeholder="Nhập số điện thoại..." required>
                            </div>
                            
                            <!-- Tỉnh/Thành phố -->
                            <div class="form-group">
                                <label class="form-label">Tỉnh/Thành phố <span class="required">*</span></label>
                                <input type="text" name="province" class="form-control" 
                                       value="${address.province}" placeholder="Nhập tỉnh/thành phố..." required>
                            </div>
                            
                            <!-- Quận/Huyện -->
                            <div class="form-group">
                                <label class="form-label">Quận/Huyện <span class="required">*</span></label>
                                <input type="text" name="district" class="form-control" 
                                       value="${address.district}" placeholder="Nhập quận/huyện..." required>
                            </div>
                            
                            <!-- Phường/Xã -->
                            <div class="form-group">
                                <label class="form-label">Phường/Xã <span class="required">*</span></label>
                                <input type="text" name="ward" class="form-control" 
                                       value="${address.ward}" placeholder="Nhập phường/xã..." required>
                            </div>
                            
                            <!-- Địa chỉ chi tiết -->
                            <div class="form-group">
                                <label class="form-label">Địa chỉ chi tiết <span class="required">*</span></label>
                                <input type="text" name="addressDetail" class="form-control" 
                                       value="${address.addressDetail}" placeholder="Nhập địa chỉ chi tiết..." required>
                            </div>
                            
                            <!-- Địa chỉ mặc định -->
                            <div class="checkbox-group">
                                <input type="checkbox" id="isDefault" name="isDefault" value="true"
                                       <c:if test="${address.isDefault}">checked</c:if>>
                                <label for="isDefault">Đặt làm địa chỉ mặc định</label>
                            </div>
                            
                            <!-- Buttons -->
                            <div class="form-buttons">
                                <a href="listAddresses" class="btn btn-secondary">Quay lại</a>
                                <button type="submit" class="btn btn-primary">Cập nhật địa chỉ</button>
                            </div>
                        </form>
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
            // Form validation
            $('#addressForm').on('submit', function(e){
                var isValid = true;
                
                // Check required fields
                $(this).find('[required]').each(function(){
                    if (!$(this).val().trim()) {
                        isValid = false;
                        $(this).addClass('is-invalid');
                    } else {
                        $(this).removeClass('is-invalid');
                    }
                });
                
                if (!isValid) {
                    e.preventDefault();
                    alert('Vui lòng điền đầy đủ thông tin bắt buộc');
                }
            });
            
            // Remove invalid class on input
            $('.form-control').on('input', function(){
                $(this).removeClass('is-invalid');
            });
        });
    </script>
</body>
</html> 