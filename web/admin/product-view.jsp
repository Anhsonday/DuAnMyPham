<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Chi Tiết Sản Phẩm - ${product.productName}</title>
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <style>
            /*--- RESET VÀ CƠ BẢN ---*/
            body {
                font-family: 'Inter', sans-serif;
                background: linear-gradient(135deg, #fff 0%, #667eea 100%);
                min-height: 100vh;
                padding: 24px 0;
            }

            .main-container {
                max-width: 1300px;
                margin: 0 auto;
                padding: 0 20px;
            }

            /*--- HEADER SẢN PHẨM ---*/
            .product-header {
                background: rgba(255,255,255,0.96);
                border-radius: 24px;
                padding: 34px 32px 32px 40px;
                margin-bottom: 38px;
                box-shadow: 0 12px 48px 0 rgba(76,81,255,0.12);
                border: 1.5px solid #ecebfa;
                position: relative;
                overflow: hidden;
            }
            .product-header.bg-danger {
                background: linear-gradient(120deg, #f56565 70%, #fff 100%);
                color: white;
            }
            .product-header .glow {
                position: absolute;
                right: -60px;
                top: -30px;
                width: 200px;
                height: 160px;
                background: radial-gradient(circle, #7f6aff55 0%, #fff0 80%);
                z-index: 0;
            }
            .product-title {
                font-size: 2.5rem;
                font-weight: 700;
                color: #2d3748;
                margin-bottom: 15px;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                -webkit-background-clip: text;
                -webkit-text-fill-color: transparent;
                background-clip: text;
            }
            .product-title .fa-spa {
                filter: drop-shadow(0 1px 2px #b4b5ff75);
            }
            .product-header .badge {
                box-shadow: 0 2px 12px #667eea20;
                border: 1.5px solid #ecebfa;
                font-weight: 600;
            }
            .product-header .badge-danger-modern {
                animation: pulseDanger 1.5s infinite;
            }
            @keyframes pulseDanger {
                0%, 100% {
                    box-shadow: 0 0 10px 0 #f5656570;
                }
                50% {
                    box-shadow: 0 0 18px 6px #f5656533;
                }
            }
            .product-subtitle {
                font-size: 1.11rem;
                color: #49507b;
                font-weight: 500;
                margin-bottom: 0;
            }

            /*--- CARD ---*/
            .modern-card, .card.info-card {
                background: rgba(255,255,255,0.97);
                border-radius: 22px;
                padding: 28px 28px 18px 28px;
                margin-bottom: 28px;
                box-shadow: 0 8px 28px 0 rgba(106,92,255,0.08);
                border: 1px solid #ecebfa;
                transition: box-shadow .3s cubic-bezier(.3,.4,.2,1), transform .25s;
                position: relative;
                overflow: hidden;
            }
            .modern-card:hover, .card.info-card:hover {
                box-shadow: 0 12px 36px 0 rgba(106,92,255,0.16);
                transform: translateY(-3px) scale(1.012);
            }

            /*--- HEADER CỦA CARD ---*/
            .card-header-modern {
                display: flex;
                align-items: center;
                gap: 12px;
                margin-bottom: 22px;
                padding-bottom: 13px;
                border-bottom: 2px solid #e7e9f7;
                font-weight: 600;
                font-size: 1.22rem;
                color: #1e2238;
            }
            .card-header-modern i {
                font-size: 1.3rem;
                background: linear-gradient(135deg, #6B73FF 0%, #000DFF 100%);
                -webkit-background-clip: text;
                -webkit-text-fill-color: transparent;
            }
            .info-card .card-header {
                background: none;
                border-bottom: 2px solid #e7e9f7;
                font-weight: 600;
                font-size: 1.14rem;
                color: #2d3748;
                padding-bottom: 8px;
            }

            /*--- LIST, FEATURE ---*/
            .feature-list {
                list-style: none;
                margin: 0;
                padding: 0;
            }
            .feature-item, .feature-list>li {
                display: flex;
                align-items: center;
                justify-content: space-between;
                padding: 13px 0;
                border-bottom: 1px solid #e6e9f3;
                transition: background .18s;
                gap: 4px;
            }
            .feature-item:last-child, .feature-list>li:last-child {
                border-bottom: none;
            }
            .feature-item:hover, .feature-list>li:hover {
                background: #e4eafd20;
                margin: 0 -10px;
                padding: 13px 10px;
                border-radius: 10px;
            }
            .feature-label {
                display: flex;
                align-items: center;
                font-weight: 500;
                color: #585e8e;
                min-width: 138px;
                gap: 6px;
                font-size: 1.04rem;
            }
            .feature-label i {
                width: 18px;
                text-align: center;
                color: #667eea;
            }
            .feature-value {
                flex: 1;
                text-align: right;
                color: #21253b;
                font-weight: 500;
                font-size: 1.03rem;
            }

            /*--- BADGE ---*/
            .modern-badge {
                padding: 8px 17px;
                border-radius: 18px;
                font-size: 0.92rem;
                font-weight: 700;
                letter-spacing: .5px;
                margin-right: 4px;
            }
            .badge-success-modern {
                background: linear-gradient(135deg, #48bb78 0%, #38a169 100%);
                color: #fff;
                border: 1.5px solid #a5d6b2;
            }
            .badge-warning-modern {
                background: linear-gradient(135deg, #ed8936 0%, #dd6b20 100%);
                color: #fff;
                border: 1.5px solid #f8cd89;
            }
            .badge-danger-modern {
                background: linear-gradient(135deg, #f56565 0%, #e53e3e 100%);
                color: #fff;
                border: 1.5px solid #feb2b2;
            }
            .badge-primary-modern {
                background: linear-gradient(135deg, #6B73FF 0%, #000DFF 100%);
                color: #fff;
                border: 1.5px solid #b4b5ff;
            }
            .badge-secondary {
                background: #ecebfa;
                color: #6c7bff;
                border: 1.5px solid #d1d6fd;
            }
            .badge-info-modern {
                background: linear-gradient(135deg, #4299e1 0%, #3182ce 100%);
                color: #fff;
                border: 1.5px solid #90cdf4;
                font-weight: 600;
            }

            /*--- PRICE ---*/
            .price-container {
                text-align: center;
                padding: 23px 14px;
                background: linear-gradient(135deg, #6B73FF 0%, #000DFF 100%);
                border-radius: 16px;
                color: white;
                margin: 20px 0;
                box-shadow: 0 4px 14px #7a80ff27;
            }
            .current-price {
                font-size: 2.13rem;
                font-weight: 800;
                margin-bottom: 9px;
                letter-spacing: -.5px;
            }
            .original-price {
                font-size: 1.04rem;
                text-decoration: line-through;
                opacity: 0.85;
            }
            .discount-badge {
                background: rgba(255,255,255,0.17);
                padding: 9px 18px;
                border-radius: 12px;
                margin-top: 13px;
                font-weight: 600;
                color: #fff;
            }

            /*--- IMAGE ---*/
            .image-gallery {
                border-radius: 16px;
                overflow: hidden;
                box-shadow: 0 8px 24px #000dff18;
            }
            .main-image {
                width: 100%;
                height: 600px;
                object-fit: cover;
                transition: transform .3s;
            }
            .main-image:hover {
                transform: scale(1.03);
            }
            .thumbnail-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(72px,1fr));
                gap: 8px;
                margin-top: 13px;
            }
            .thumbnail {
                width: 100%;
                height: 220px;
                object-fit: cover;
                border-radius: 8px;
                cursor: pointer;
                border: 2px solid transparent;
                transition: all .24s;
            }
            .thumbnail:hover {
                border-color: #6B73FF;
                transform: scale(1.08);
                box-shadow: 0 0 8px #6B73FF40;
            }

            /*--- ALERT ---*/
            .alert-modern {
                border-radius: 13px;
                border: none;
                padding: 18px 18px;
                margin: 14px 0;
                font-weight: 600;
                font-size: 1.01rem;
                background: #fff5;
            }
            .alert-danger-modern {
                background: linear-gradient(135deg, #fed7d7 0%, #feb2b2 100%);
                color: #c53030;
            }
            .alert-warning-modern {
                background: linear-gradient(135deg, #fefcbf 0%, #faf089 100%);
                color: #d69e2e;
            }
            .alert-success-modern {
                background: linear-gradient(135deg, #c6f6d5 0%, #9ae6b4 100%);
                color: #2f855a;
            }
            .alert .fa-exclamation-triangle, .alert-modern .fa-exclamation-triangle {
                animation: bounceIn .8s infinite alternate;
            }
            @keyframes bounceIn {
                0% {
                    transform: translateY(-2px);
                }
                100% {
                    transform: translateY(4px);
                }
            }

            /*--- BUTTON ---*/
            .btn-modern, .btn {
                padding: 12px 30px !important;
                border-radius: 26px !important;
                font-weight: 700 !important;
                letter-spacing: .7px;
                transition: all .26s cubic-bezier(.39,.4,.29,1);
                box-shadow: 0 4px 12px #6B73FF22;
                border: none !important;
                outline: none !important;
                position: relative;
            }
            .btn-primary-modern, .btn-primary {
                background: linear-gradient(135deg, #6B73FF 0%, #000DFF 100%) !important;
                color: #fff !important;
            }
            .btn-primary-modern:hover, .btn-primary:hover {
                filter: brightness(1.07) contrast(1.08);
                transform: translateY(-2px) scale(1.03);
            }
            .btn-warning-modern, .btn-warning {
                background: linear-gradient(135deg, #ed8936 0%, #dd6b20 100%) !important;
                color: #fff !important;
            }
            .btn-danger-modern, .btn-danger {
                background: linear-gradient(135deg, #f56565 0%, #e53e3e 100%) !important;
                color: #fff !important;
            }
            .btn-secondary-modern, .btn-secondary {
                background: linear-gradient(135deg, #ecebfa 0%, #b4b5ff 100%) !important;
                color: #6B73FF !important;
            }
            .btn:active {
                filter: brightness(.96);
            }

            .btn-lg {
                font-size: 1.14rem;
                padding: 16px 34px !important;
                border-radius: 30px !important;
            }

            /*--- ACTION GROUP ---*/
            .action-buttons {
                display: flex;
                gap: 18px;
                justify-content: center;
                flex-wrap: wrap;
                padding: 28px 0;
                margin-bottom: 12px;
            }
            .btn-group .btn {
                min-width: 180px;
                margin: 0 3px;
            }

            /*--- MODAL ---*/
            .modal-content {
                border-radius: 18px !important;
                border: none;
            }
            .modal-header.bg-danger {
                background: linear-gradient(120deg, #f56565 70%, #fff 100%) !important;
                color: white;
                border-top-left-radius: 18px;
                border-top-right-radius: 18px;
                border-bottom: none;
            }
            .modal-footer {
                border-top: none;
            }
            .modal-body {
                padding: 34px 20px;
            }
            #deleteModal .fa-trash-alt {
                animation: shake .8s infinite alternate;
            }
            @keyframes shake {
                0% {
                    transform: rotate(-8deg);
                }
                100% {
                    transform: rotate(9deg);
                }
            }

            /*--- RESPONSIVE ---*/
            @media (max-width: 900px) {
                .product-title {
                    font-size: 2.1rem;
                }
                .modern-card, .card.info-card {
                    padding: 17px 8px 8px 10px;
                }
                .main-image {
                    height: 200px;
                }
            }
            @media (max-width: 600px) {
                .main-container {
                    padding: 0 2px;
                }
                .modern-card, .card.info-card {
                    padding: 8px 4px;
                }
                .product-header {
                    padding: 15px 7px 8px 8px;
                }
                .main-image {
                    height: 120px;
                }
            }
            .product-images-card {
    width: 100%;
    max-width: 100% !important; /* bạn tăng giảm theo ý muốn, hoặc 100% */
    margin-left: auto;
    margin-right: auto;
}

.main-image-wrapper {
    background: #fff;
    border-radius: 32px;
    box-shadow: 0 6px 40px #000dff16;
    min-height: 440px;
    padding: 36px 24px;
    display: flex;
    justify-content: center;
    align-items: center;
}
.main-image-product {
    width: 100%;
    max-width: 630px;
    max-height: 590px;
    object-fit: contain;
    border-radius: 24px;
    box-shadow: 0 8px 32px #6B73FF18;
    background: #fff;
    transition: transform .25s;
}
.main-image-product:hover {
    transform: scale(1.04);
}
.image-note {
    text-align: left;
    margin-bottom: 7px;
}
.badge-main-label {
    background: linear-gradient(90deg, #fde68a 0%, #fbbf24 100%);
    color: #7c4700;
    font-weight: 700;
    font-size: 1rem;
    padding: 9px 16px 9px 14px;
    border-radius: 20px;
    box-shadow: 0 2px 12px #fbbf2420;
    margin-bottom: 4px;
    display: inline-flex;
    align-items: center;
    gap: 7px;
}
.badge-sub-label {
    background: linear-gradient(90deg, #c7d2fe 0%, #6366f1 90%);
    color: #23234b;
    font-weight: 600;
    font-size: 0.97rem;
    padding: 8px 16px 8px 12px;
    border-radius: 18px;
    box-shadow: 0 2px 12px #6366f125;
    margin-bottom: 2px;
    display: inline-flex;
    align-items: center;
    gap: 6px;
}
.sub-images-scroll {
    display: flex;
    overflow-x: auto;
    gap: 17px;
    padding: 14px 0;
    scroll-behavior: smooth;
}
.sub-image-wrapper {
    flex: 0 0 auto;
    width: 100%;
    max-width: 380px;
    height: 300px;
    border-radius: 13px;
    box-shadow: 0 2px 10px #000dff11;
    background: #f8fafc;
    display: flex;
    align-items: center;
    justify-content: center;
    transition: box-shadow .2s;
}
.sub-image-wrapper:hover {
    box-shadow: 0 8px 30px #6B73FF22;
}
.sub-image-product {
    max-width: 100%;
    max-height: 325px;
    border-radius: 11px;
    object-fit: contain;
    background: #fff;
    transition: transform .18s;
}
.sub-image-product:hover {
    transform: scale(1.07);
    box-shadow: 0 0 8px #6B73FF33;
}
/* Responsive */
@media (max-width: 1200px) {
    .product-images-card {
        max-width: 100vw;
    }
    .main-image-wrapper {
        min-height: 260px;
        padding: 14px 2vw;
    }
    .main-image-product {
        max-width: 98vw;
        max-height: 230px;
    }
}
@media (max-width: 800px) {
    .main-image-wrapper {
        min-height: 180px;
        padding: 8px 1vw;
    }
    .main-image-product {
        max-width: 95vw;
        max-height: 140px;
    }
    .sub-image-wrapper {
        width: 90px;
        height: 60px;
    }
    .sub-image-product {
        max-height: 48px;
    }
}

        </style>
    </head>
    <body>
        <div class="main-container">
            <c:if test="${empty product}">
                <div class="modern-card alert-danger-modern animate-in">
                    <div class="text-center">
                        <i class="fas fa-exclamation-triangle fa-4x mb-4" style="color: #c53030;"></i>
                        <h3>Không tìm thấy sản phẩm!</h3>
                        <p class="mb-4">Sản phẩm bạn đang tìm không tồn tại hoặc đã bị xóa.</p>
                        <a href="products" class="btn btn-primary-modern btn-modern">
                            <i class="fas fa-arrow-left"></i> Quay lại danh sách
                        </a>
                    </div>
                </div>
            </c:if>

            <c:if test="${not empty product}">
                <!-- Product Header -->
                <div class="product-header ${product.isDeleted == true ? 'bg-danger' : ''} animate-in">
                    <div class="glow"></div>
                    <div class="row align-items-center">
                        <div class="col-md-8">
                            <div style="position: relative;">
                                <h1 class="product-title">
                                    <i class="fas fa-hand-holding-heart"></i> ${product.productName}
                                </h1>
                                <c:if test="${product.featured}">
                                    <span class="badge badge-warning-modern modern-badge mt-2" style="position:absolute; right:0; top:100%;">
                                        <i class="fas fa-star"></i> Nổi bật
                                    </span>
                                </c:if>
                                <c:if test="${product.isDeleted == true}">
                                    <span class="badge badge-danger-modern modern-badge ml-2">
                                        <i class="fas fa-trash-alt"></i> Đã xóa
                                    </span>
                                </c:if>
                            </div>


                            <c:if test="${product.isDeleted == true}">
                                <div class="alert-danger-modern alert-modern">
                                    <i class="fas fa-exclamation-circle"></i>
                                    <strong>Lưu ý:</strong> Sản phẩm này đã bị xóa và không hiển thị cho khách hàng.
                                </div>
                            </c:if>
                            <p class="product-subtitle">
                                <c:choose>
                                    <c:when test="${not empty product.shortDescription}">
                                        ${product.shortDescription}
                                    </c:when>
                                    <c:otherwise>
                                        <em>Không có mô tả ngắn</em>
                                    </c:otherwise>
                                </c:choose>
                            </p>
                        </div>
                        <div class="col-md-4 text-right">
                            <div class="d-flex justify-content-end flex-wrap gap-2">
                                <a href="products" class="btn btn-secondary-modern btn-modern">
                                    <i class="fas fa-arrow-left"></i> Quay lại
                                </a>
                                <a href="products?action=edit&id=${product.productId}" class="btn btn-warning-modern btn-modern">
                                    <i class="fas fa-edit"></i> Sửa
                                </a>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="row">
                    <!-- Left Column - Basic Info -->
                    <div class="col-lg-6">
                        <!-- Basic Information -->
                        <div class="modern-card floating-element animate-in">
                            <div class="card-header-modern">
                                <i class="fas fa-info-circle"></i>
                                <h3>Thông Tin Cơ Bản</h3>
                            </div>
                            <div class="card-body">
                                <ul class="feature-list">
                                    <li class="feature-item">
                                        <span class="feature-label">
                                            <i class="fas fa-hashtag"></i> ID:
                                        </span>
                                        <span class="feature-value">
                                            <code class="bg-light p-1 rounded">${product.productId}</code>
                                        </span>
                                    </li>
                                    <li class="feature-item">
                                        <span class="feature-label">
                                            <i class="fas fa-tags"></i> Danh mục:
                                        </span>
                                        <span class="feature-value">
                                            <c:set var="found" value="false" />
                                            <c:forEach var="category" items="${categorys}">
                                                <c:if test="${category.categoryId == product.categoryId.categoryId}">
                                                    <c:set var="found" value="true" />
                                                    <c:if test="${category.parentCategoryId != null}">
                                                        <c:forEach var="parentCategory" items="${categorys}">
                                                            <c:if test="${parentCategory.categoryId == category.parentCategoryId.categoryId}">
                                                                <span class="badge badge-secondary mr-1">
                                                                    ${parentCategory.categoryName}
                                                                </span>
                                                            </c:if>
                                                        </c:forEach>
                                                        <i class="fas fa-arrow-right text-muted mx-1"></i>
                                                    </c:if>
                                                    <span class="badge badge-primary-modern modern-badge">
                                                        ${category.categoryName}
                                                    </span>
                                                </c:if>
                                            </c:forEach>
                                            <c:if test="${!found}">
                                                <span class="text-muted">
                                                    <i class="fas fa-exclamation-circle"></i> Chưa phân loại
                                                </span>
                                            </c:if>
                                        </span>
                                    </li>
                                    <li class="feature-item">
                                        <span class="feature-label">
                                            <i class="fas fa-barcode"></i> SKU:
                                        </span>
                                        <span class="feature-value">
                                            <code class="bg-light p-2 rounded">${product.sku}</code>
                                        </span>
                                    </li>
                                    <li class="feature-item">
                                        <span class="feature-label">
                                            <i class="fas fa-toggle-on"></i> Trạng thái:
                                        </span>
                                        <span class="feature-value">
                                            <c:choose>
                                                <c:when test="${product.status == 'active'}">
                                                    <span class="badge badge-success-modern modern-badge">
                                                        <i class="fas fa-check"></i> Hoạt động
                                                    </span>
                                                </c:when>
                                                <c:when test="${product.status == 'inactive'}">
                                                    <span class="badge badge-secondary modern-badge">
                                                        <i class="fas fa-pause"></i> Không hoạt động
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge badge-warning-modern modern-badge">
                                                        <i class="fas fa-exclamation-triangle"></i> Hết hàng
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </span>
                                    </li>
                                    <li class="feature-item">
                                        <span class="feature-label">
                                            <i class="fas fa-warehouse"></i> Số lượng:
                                        </span>
                                        <span class="feature-value">
                                            <span class="badge ${product.stock > 10 ? 'badge-success-modern' : (product.stock > 0 ? 'badge-warning-modern' : 'badge-danger-modern')} modern-badge">
                                                ${product.stock} sản phẩm
                                            </span>
                                            <span class="badge badge-info-modern">Đã giữ: ${product.reservedQuantity}</span>
                                        </span>
                                    </li>
                                    <li class="feature-item">
                                        <span class="feature-label">
                                            <i class="fas fa-flask"></i> Thương hiệu:
                                        </span>
                                        <span class="feature-value">${product.brandName}</span>
                                    </li>
                                    
                                    <li class="feature-item">
                                        <span class="feature-label">
                                            <i class="fas fa-balance-scale"></i> Giá trị:
                                        </span>
                                        <span class="feature-value">
                                            <c:if test="${product.quantityValue != null}">
                                                ${product.quantityValue} ${product.quantityUnit}
                                            </c:if>
                                            <c:if test="${product.quantityValue == null}">
                                                <span class="text-muted">Không xác định</span>
                                            </c:if>
                                        </span>
                                    </li>
                                </ul>

                                <!-- Quantity Alert -->
                                <c:if test="${product.stock <= 10}">
                                    <div class="mt-3">
                                        <c:choose>
                                            <c:when test="${product.stock == 0}">
                                                <div class="alert-danger-modern alert-modern">
                                                    <i class="fas fa-exclamation-triangle"></i>
                                                    <strong>Hết hàng!</strong> Sản phẩm này đã hết hàng.
                                                </div>
                                            </c:when>
                                            <c:when test="${product.stock <= 5}">
                                                <div class="alert-danger-modern alert-modern">
                                                    <i class="fas fa-exclamation-triangle"></i>
                                                    <strong>Sắp hết hàng!</strong> Chỉ còn ${product.stock} sản phẩm.
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="alert-warning-modern alert-modern">
                                                    <i class="fas fa-info-circle"></i>
                                                    <strong>Số lượng thấp!</strong> Còn ${product.stock} sản phẩm.
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </c:if>
                            </div>
                        </div>

                        <!-- Pricing Information -->
                        <div class="modern-card floating-element animate-in">
                            <div class="card-header-modern">
                                <i class="fas fa-money-bill-wave"></i>
                                <h3>Thông Tin Giá</h3>
                            </div>
                            <div class="price-container">
                                <c:choose>
                                    <c:when test="${product.salePrice != null && product.salePrice > 0}">
                                        <div class="current-price">
                                            <i class="fas fa-tags"></i>
                                            <fmt:formatNumber value="${product.salePrice}" type="currency" currencySymbol="₫" pattern="#,##0 ₫"/>
                                        </div>
                                        <div class="original-price">
                                            Giá gốc: <fmt:formatNumber value="${product.price}" type="currency" currencySymbol="₫" pattern="#,##0 ₫"/>
                                        </div>
                                        <div class="discount-badge">
                                            <i class="fas fa-percentage"></i>
                                            Tiết kiệm: <fmt:formatNumber value="${product.price - product.salePrice}" type="currency" currencySymbol="₫" pattern="#,##0 ₫"/>
                                            (<fmt:formatNumber value="${((product.price - product.salePrice) / product.price) * 100}" pattern="#.#"/>%)
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="current-price">
                                            <i class="fas fa-money-bill"></i>
                                            <fmt:formatNumber value="${product.price}" type="currency" currencySymbol="₫" pattern="#,##0 ₫"/>
                                        </div>
                                        <div style="opacity: 0.8;">Giá niêm yết</div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        
                    </div>

                    <!-- Right Column - Details -->
                    <div class="col-lg-6">
                        <!-- Description -->
                        <div class="modern-card floating-element animate-in">
                            <div class="card-header-modern">
                                <i class="fas fa-file-alt"></i>
                                <h3>Mô Tả Chi Tiết</h3>
                            </div>
                            <div class="card-body">
                                <c:choose>
                                    <c:when test="${not empty productDetail && not empty productDetail.description}">
                                        <div style="white-space: pre-line; line-height: 1.8; color: #4a5568;">
                                            ${productDetail.description}
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="text-center text-muted py-5">
                                            <i class="fas fa-file-alt fa-4x mb-3" style="color: #cbd5e0;"></i>
                                            <h5>Chưa có mô tả</h5>
                                            <p>Chưa có mô tả chi tiết cho sản phẩm này</p>
                                            <a href="products?action=edit&id=${product.productId}" class="btn btn-primary-modern btn-modern">
                                                <i class="fas fa-plus"></i> Thêm mô tả
                                            </a>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <!-- Skin Care Details -->
                        <div class="modern-card floating-element animate-in">
                            <div class="card-header-modern">
                                <i class="fas fa-seedling"></i>
                                <h3>Thông Tin Chăm Sóc Da</h3>
                            </div>
                            <div class="card-body">
                                <c:choose>
                                    <c:when test="${not empty productDetail}">
                                        <ul class="feature-list">
                                            <li class="feature-item">
                                                <span class="feature-label">
                                                    <i class="fas fa-leaf"></i> Thành phần:
                                                </span>
                                                <span class="feature-value">
                                                    <c:choose>
                                                        <c:when test="${not empty productDetail.ingredients}">
                                                            ${productDetail.ingredients}
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="text-muted">Chưa có thông tin</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </li>

                                            <li class="feature-item">
                                                <span class="feature-label">
                                                    <i class="fas fa-globe-asia"></i> Xuất xứ:
                                                </span>
                                                <span class="feature-value">
                                                    <c:choose>
                                                        <c:when test="${not empty productDetail.origin}">
                                                            ${productDetail.origin}
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="text-muted">Chưa có thông tin</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </li>

                                            <li class="feature-item">
                                                <span class="feature-label"><i class="fas fa-heartbeat"></i> Công dụng:</span>
                                                <span class="feature-value">
                                                    <c:choose>
                                                        <c:when test="${not empty productDetail.skinConcerns}">
                                                            ${productDetail.skinConcerns}
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="text-muted">Chưa có thông tin</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </li>
                                            <li>
                                                <span class="feature-label"><i class="fas fa-archive"></i> Bảo quản:</span>
                                                <span class="feature-value">
                                                    <c:choose>
                                                        <c:when test="${not empty productDetail.storageInstructions}">
                                                            ${productDetail.storageInstructions}
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="text-muted">Chưa có thông tin</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </li>
                                            <li>
                                                <span class="feature-label"><i class="fas fa-hands-wash"></i> Hướng dẫn sử dụng:</span>
                                                <span class="feature-value">
                                                    <c:choose>
                                                        <c:when test="${not empty productDetail.howToUse}">
                                                            ${productDetail.howToUse}
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="text-muted">Chưa có thông tin</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </li>
                                            <li>
                                                <span class="feature-label"><i class="fas fa-calendar-plus"></i> Ngày sản xuất:</span>
                                                <span class="feature-value">
                                                    <c:choose>
                                                        <c:when test="${productDetail.manufactureDate != null}">
                                                            <fmt:formatDate value="${productDetail.manufactureDate}" pattern="dd/MM/yyyy"/>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="text-muted">Chưa có thông tin</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </li>
                                            <li>
                                                <span class="feature-label"><i class="fas fa-calendar-times"></i> Hạn sử dụng:</span>
                                                <span class="feature-value">
                                                    <c:choose>
                                                        <c:when test="${productDetail.expiryDate != null}">
                                                            <fmt:formatDate value="${productDetail.expiryDate}" pattern="dd/MM/yyyy"/>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="text-muted">Chưa có thông tin</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </li>
                                        </ul>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="text-center text-muted py-4">
                                            <i class="fas fa-seedling fa-3x mb-3"></i>
                                            <p class="font-italic">Chưa có thông tin chi tiết cho sản phẩm này</p>
                                            <a href="products?action=edit&id=${product.productId}" class="btn btn-sm btn-outline-primary">
                                                <i class="fas fa-plus"></i> Thêm thông tin chi tiết
                                            </a>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        <!-- Timeline -->
                        <div class="card info-card">
                            <div class="card-header">
                                <i class="fas fa-history"></i> Lịch Sử & Thời Gian
                            </div>
                            <div class="card-body">
                                <ul class="feature-list">
                                    <li>
                                        <span class="feature-label"><i class="fas fa-calendar-plus"></i> Ngày tạo:</span>
                                        <span class="feature-value">
                                            <c:choose>
                                                <c:when test="${product.createdAt != null}">
                                                    ${product.createdAt}
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-muted">Không xác định</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </span>
                                    </li>
                                    <li>
                                        <span class="feature-label"><i class="fas fa-calendar-check"></i> Cập nhật:</span>
                                        <span class="feature-value">
                                            <c:choose>
                                                <c:when test="${product.updatedAt != null}">
                                                    ${product.updatedAt}
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-muted">Không xác định</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </span>
                                    </li>
                                    <li>
                                        <span class="feature-label"><i class="fas fa-star"></i> Sản phẩm nổi bật:</span>
                                        <span class="feature-value">
                                            <c:choose>
                                                <c:when test="${product.featured}">
                                                    <span class="badge badge-warning"><i class="fas fa-star"></i> Có</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge badge-light"><i class="far fa-star"></i> Không</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </span>
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
                      <div class="row">
    <div class="col-lg-12">
        <div class="modern-card floating-element animate-in product-images-card">
            <div class="card-header-modern">
                <i class="fas fa-images"></i>
                <h3>Hình Ảnh Sản Phẩm</h3>
            </div>
            <div class="card-body">
                <c:choose>
                    <c:when test="${not empty productImages}">
                        <!-- Chú thích Ảnh chính -->
                        <div class="image-note mb-2">
                            <span class="badge badge-main-label"><i class="fas fa-crown"></i> Ảnh chính </span>
                        </div>
                        <!-- Ảnh chính -->
                        <c:forEach var="image" items="${productImages}">
                            <c:if test="${image.isMainImage == true}">
                                <div class="main-image-wrapper mb-3">
                                    <img src="${pageContext.request.contextPath}/${image.imageUrl}" class="main-image-product" alt="Main Product Image">
                                </div>
                            </c:if>
                        </c:forEach>
                        <!-- Chú thích Ảnh phụ -->
                        <c:set var="hasSubImage" value="false"/>
                        <c:forEach var="image" items="${productImages}">
                            <c:if test="${image.isMainImage != true}">
                                <c:set var="hasSubImage" value="true"/>
                            </c:if>
                        </c:forEach>
                        <c:if test="${hasSubImage}">
                            <div class="image-note mb-2">
                                <span class="badge badge-sub-label"><i class="fas fa-images"></i> Ảnh phụ </span>
                            </div>
                            <div class="sub-images-scroll mb-1 mt-2">
                                <c:forEach var="image" items="${productImages}">
                                    <c:if test="${image.isMainImage != true}">
                                        <div class="sub-image-wrapper mb-3">
                                            <img src="${pageContext.request.contextPath}/${image.imageUrl}" class="sub-image-product" alt="Sub Product Image">
                                        </div>
                                    </c:if>
                                </c:forEach>
                            </div>
                        </c:if>
                    </c:when>
                    <c:otherwise>
                        <div class="text-center text-muted py-5">
                            <i class="fas fa-images fa-4x mb-3" style="color: #cbd5e0;"></i>
                            <h5>Chưa có hình ảnh</h5>
                            <p>Chưa có hình ảnh cho sản phẩm này</p>
                            <a href="products?action=edit&id=${product.productId}" class="btn btn-primary-modern btn-modern">
                                <i class="fas fa-plus"></i> Thêm ảnh
                            </a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</div>

              
                <!-- Action Buttons -->
                <div class="row">
                    <div class="col-12">
                        <div class="action-buttons text-center">
                            <div class="btn-group" role="group" aria-label="Product Actions">
                                <a href="products" class="btn btn-secondary btn-lg">
                                    <i class="fas fa-list"></i> Danh sách sản phẩm
                                </a>
                                <a href="products?action=edit&id=${product.productId}" class="btn btn-warning btn-lg">
                                    <i class="fas fa-edit"></i> Chỉnh sửa
                                </a>
                                <button type="button" class="btn btn-danger btn-lg" onclick="confirmDelete(${product.productId}, '${product.productName}')">
                                    <i class="fas fa-trash"></i> Xóa sản phẩm
                                </button>
                                <a href="products?action=new" class="btn btn-primary btn-lg">
                                    <i class="fas fa-plus"></i> Thêm sản phẩm mới
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </c:if>
        </div>
        <!-- Delete Confirmation Modal -->
        <div class="modal fade" id="deleteModal" tabindex="-1" role="dialog" aria-labelledby="deleteModalLabel" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header bg-danger text-white">
                        <h5 class="modal-title" id="deleteModalLabel">
                            <i class="fas fa-exclamation-triangle"></i> Xác nhận xóa sản phẩm
                        </h5>
                        <button type="button" class="close text-white" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        <div class="text-center">
                            <i class="fas fa-trash-alt text-danger" style="font-size: 3rem; margin-bottom: 1rem;"></i>
                            <h5>Bạn có chắc chắn muốn xóa sản phẩm này?</h5>
                            <p class="text-muted">
                                Sản phẩm: <strong id="productName" class="text-dark"></strong>
                            </p>
                            <div class="alert alert-warning">
                                <i class="fas fa-exclamation-triangle"></i>
                                <strong>Cảnh báo:</strong> Hành động này không thể hoàn tác!
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">
                            <i class="fas fa-times"></i> Hủy bỏ
                        </button>
                        <a href="#" id="confirmDeleteBtn" class="btn btn-danger">
                            <i class="fas fa-trash"></i> Xác nhận xóa
                        </a>
                    </div>
                </div>
            </div>
        </div>
        <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"></script>
        <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>
        <script>
                                    function confirmDelete(productId, productName) {
                                        document.getElementById('productName').textContent = productName;
                                        document.getElementById('confirmDeleteBtn').href = 'products?action=delete&id=' + productId;
                                        $('#deleteModal').modal('show');
                                    }
                                    $('#deleteModal').on('shown.bs.modal', function () {
                                        $('#confirmDeleteBtn').focus();
                                    });
                                    $(document).ready(function () {
                                        $('.btn').click(function () {
                                            var btn = $(this);
                                            if (!btn.hasClass('btn-secondary') && !btn.attr('data-dismiss')) {
                                                btn.append(' <i class="fas fa-spinner fa-spin"></i>');
                                                btn.prop('disabled', true);
                                            }
                                        });
                                    });
        </script>
    </body>
</html>
