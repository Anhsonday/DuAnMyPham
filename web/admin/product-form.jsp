<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>
            <c:choose>
                <c:when test="${product != null}">Sửa Sản Phẩm</c:when>
                <c:otherwise>Thêm Sản Phẩm Mới</c:otherwise>
            </c:choose>
        </title>
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <style>
            :root {
                --primary-gradient: linear-gradient(145deg, #667eea 0%, #764ba2 100%);
                --secondary-gradient: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
                --success-gradient: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
                --card-shadow: 0 20px 60px rgba(102, 126, 234, 0.1);
                --hover-shadow: 0 25px 80px rgba(102, 126, 234, 0.15);
                --border-radius: 20px;
                --transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            }

            * {
                box-sizing: border-box;
            }

            body {
                background: linear-gradient(135deg, #fff 0%, #667eea 100%);
                min-height: 100vh;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                position: relative;
                overflow-x: hidden;
            }

            body::before {
                content: '';
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background:
                    radial-gradient(circle at 20% 80%, rgba(120, 119, 198, 0.3) 0%, transparent 50%),
                    radial-gradient(circle at 80% 20%, rgba(255, 119, 198, 0.15) 0%, transparent 50%);
                pointer-events: none;
                z-index: 0;
            }

            .container {
                position: relative;
                z-index: 1;
            }

            .main-card {
                background: rgba(255, 255, 255, 0.95);
                backdrop-filter: blur(4px); /* Hoặc bỏ hẳn cho nhẹ */
                box-shadow: 0 8px 24px rgba(102, 126, 234, 0.13); /* giảm số px, giảm alpha */
                border-radius: var(--border-radius);

                margin: 2rem 0;
                overflow: hidden;
                transition: var(--transition);
                border: 1px solid rgba(255, 255, 255, 0.2);
            }

            .main-card:hover {
                box-shadow: var(--hover-shadow);
                transform: translateY(-5px);
            }

            .card-header {
                background: var(--primary-gradient);
                color: white;
                padding: 2rem;
                position: relative;
                overflow: hidden;
            }

/*                        .card-header::before {
                            content: '';
                            position: absolute;
                            top: -50%;
                            left: -50%;
                            width: 200%;
                            height: 200%;
                            background: linear-gradient(45deg, transparent, rgba(255,255,255,0.1), transparent);
                            transform: rotate(45deg);
                            animation: shimmer 3s infinite;
                        }
            
                        @keyframes shimmer {
                            0% { transform: translateX(-100%) translateY(-100%) rotate(45deg); }
                            100% { transform: translateX(100%) translateY(100%) rotate(45deg); }
                        }*/

            .card-title {
                font-weight: 700;
                font-size: 1.8rem;
                margin: 0;
                display: flex;
                align-items: center;
                gap: 15px;
                position: relative;
                z-index: 2;
            }

            .card-title i {
                font-size: 2rem;
                filter: drop-shadow(0 4px 8px rgba(0,0,0,0.2));
            }

            .card-body {
                padding: 2.5rem;
                background: linear-gradient(145deg, #ffffff 0%, #f8faff 100%);
            }

            .form-section {
                background: white;
                border-radius: 15px;
                padding: 1.5rem;
                margin-bottom: 2rem;
                box-shadow: 0 8px 32px rgba(0,0,0,0.06);
                border: 1px solid rgba(102, 126, 234, 0.1);
                transition: var(--transition);
            }

            .form-section:hover {
                box-shadow: 0 12px 40px rgba(0,0,0,0.1);
                transform: translateY(-2px);
            }

            .section-header {
                display: flex;
                align-items: center;
                gap: 12px;
                margin-bottom: 1.5rem;
                font-weight: 600;
                font-size: 1.2rem;
                color: #4a5568;
                padding-bottom: 0.5rem;
                border-bottom: 2px solid #e2e8f0;
            }

            .section-header i {
                background: var(--primary-gradient);
                color: white;
                padding: 8px;
                border-radius: 10px;
                font-size: 1rem;
            }

            .form-group {
                margin-bottom: 1.5rem;
                position: relative;
            }

            .form-control, .form-select {
                border: 2px solid #e2e8f0;
                border-radius: 12px;
                padding: 5px 16px;
                font-size: 0.95rem;
                transition: var(--transition);
                background: #f8faff;
            }

            .form-control:focus, .form-select:focus {
                border-color: #667eea;
                box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
                background: white;
                outline: none;
            }

            .form-control.is-invalid {
                border-color: #f56565;
                box-shadow: 0 0 0 3px rgba(245, 101, 101, 0.1);
            }

            label {
                font-weight: 600;
                color: #2d3748;
                margin-bottom: 8px;
                display: block;
                font-size: 0.95rem;
            }

            .required {
                color: #f56565;
                margin-left: 4px;
            }

            .form-check {
                background: #f8faff;
                padding: 12px 30px;
                border-radius: 12px;
                border: 2px solid #e2e8f0;
                transition: var(--transition);
            }

            .form-check:hover {
                border-color: #667eea;
                background: white;
            }

            .form-check-input:checked {
                background-color: #667eea;
                border-color: #667eea;
            }

            .btn {
                border-radius: 12px;
                padding: 12px 24px;
                font-weight: 600;
                font-size: 0.95rem;
                transition: var(--transition);
                border: none;
                position: relative;
                overflow: hidden;
            }

            .btn-primary {
                background: var(--primary-gradient);
                color: white;
                box-shadow: 0 8px 24px rgba(102, 126, 234, 0.3);
            }

            .btn-primary:hover {
                transform: translateY(-2px);
                box-shadow: 0 12px 32px rgba(102, 126, 234, 0.4);
                background: linear-gradient(145deg, #5a6fd8 0%, #6b5b95 100%);
            }

            .btn-secondary {
                background: linear-gradient(145deg, #718096 0%, #4a5568 100%);
                color: white;
                box-shadow: 0 8px 24px rgba(113, 128, 150, 0.3);
            }

            .btn-secondary:hover {
                transform: translateY(-2px);
                box-shadow: 0 12px 32px rgba(113, 128, 150, 0.4);
                color: white;
            }

            .btn-danger {
                background: var(--secondary-gradient);
                border: none;
                border-radius: 8px;
                padding: 6px 12px;
                font-size: 0.85rem;
            }

            .alert {
                border-radius: 12px;
                border: none;
                padding: 16px 20px;
                margin-bottom: 2rem;
                box-shadow: 0 8px 32px rgba(245, 101, 101, 0.15);
            }

            .alert-danger {
                background: linear-gradient(135deg, #fed7d7 0%, #feb2b2 100%);
                color: #742a2a;
            }

            /* Tab Styling */
            .nav-tabs {
                border: none;
                background: #f8faff;
                border-radius: 12px;
                padding: 4px;
                margin-bottom: 1rem;
            }

            .nav-tabs .nav-link {
                border: none;
                background: transparent;
                color: #4a5568;
                border-radius: 8px;
                margin: 0 2px;
                padding: 10px 20px;
                transition: var(--transition);
                font-weight: 500;
            }

            .nav-tabs .nav-link.active {
                background: white;
                color: #667eea;
                box-shadow: 0 4px 12px rgba(0,0,0,0.1);
                font-weight: 600;
            }

            .tab-content {
                background: white;
                border-radius: 12px;
                padding: 1.5rem;
                box-shadow: 0 4px 20px rgba(0,0,0,0.08);
                border: 1px solid #e2e8f0;
            }

            /* Image Upload */
            .image-upload-area {
                border: 3px dashed #cbd5e0;
                background: linear-gradient(145deg, #f8faff 0%, #e6fffa 100%);
                border-radius: 16px;
                cursor: pointer;
                padding: 2rem;
                text-align: center;
                transition: var(--transition);
                position: relative;
                overflow: hidden;
            }

            .image-upload-area::before {
                content: '';
                position: absolute;
                top: 0;
                left: -100%;
                width: 100%;
                height: 100%;
                background: linear-gradient(90deg, transparent, rgba(102, 126, 234, 0.1), transparent);
                transition: left 0.5s;
            }

            .image-upload-area:hover {
                border-color: #667eea;
                background: linear-gradient(145deg, #e6fffa 0%, #f0fff4 100%);
                transform: translateY(-2px);
                box-shadow: 0 8px 32px rgba(102, 126, 234, 0.15);
            }

            .image-upload-area:hover::before {
                left: 100%;
            }

            .image-upload-area i {
                font-size: 3rem;
                background: var(--success-gradient);
                -webkit-background-clip: text;
                -webkit-text-fill-color: transparent;
                background-clip: text;
                margin-bottom: 1rem;
                display: block;
            }

            .image-preview {
                background: white;
                border-radius: 16px;
                padding: 1rem;
                box-shadow: 0 8px 32px rgba(0,0,0,0.1);
                margin-bottom: 1rem;
                transition: var(--transition);
                position: relative;
                overflow: hidden;
                border: 2px solid #e2e8f0;
            }

            .image-preview:hover {
                transform: translateY(-4px);
                box-shadow: 0 16px 48px rgba(0,0,0,0.15);
                border-color: #667eea;
            }

            .image-preview.main {
                border: 3px solid #667eea;
                background: linear-gradient(145deg, #ffffff 0%, #f8faff 100%);
            }

            .image-preview img {
                max-width: 100%;
                max-height: 300px;
                border-radius: 12px;
                box-shadow: 0 4px 16px rgba(0,0,0,0.1);
                transition: var(--transition);
            }

            .image-preview:hover img {
                transform: scale(1.02);
            }

            .main-badge {
                position: absolute;
                top: 12px;
                left: 12px;
                background: var(--primary-gradient);
                color: white;
                padding: 6px 12px;
                border-radius: 20px;
                font-size: 0.8rem;
                font-weight: 600;
                box-shadow: 0 4px 12px rgba(102, 126, 234, 0.3);
                z-index: 10;
            }

            .order-input {
                width: 70px;
                margin-top: 8px;
                border-radius: 8px;
                border: 2px solid #e2e8f0;
                text-align: center;
                font-weight: 600;
            }

            .image-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
                gap: 1.5rem;
                margin-bottom: 2rem;
            }

            .fade-in {
                animation: fadeInUp 0.6s cubic-bezier(0.4, 0, 0.2, 1);
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

            .floating-action {
                position: fixed;
                bottom: 2rem;
                right: 2rem;
                z-index: 1000;
            }

            .floating-action .btn {
                border-radius: 50%;
                width: 60px;
                height: 60px;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 1.5rem;
                box-shadow: 0 8px 32px rgba(102, 126, 234, 0.3);
            }

            /* Responsive */
            @media (max-width: 768px) {
                .card-body {
                    padding: 1.5rem;
                }

                .form-section {
                    padding: 1rem;
                    margin-bottom: 1.5rem;
                }

                .image-grid {
                    grid-template-columns: 1fr;
                    gap: 1rem;
                }

                .main-card {
                    margin: 1rem 0;
                }
            }

            /* Custom scrollbar */
            ::-webkit-scrollbar {
                width: 8px;
            }

            ::-webkit-scrollbar-track {
                background: #f1f1f1;
                border-radius: 4px;
            }

            ::-webkit-scrollbar-thumb {
                background: var(--primary-gradient);
                border-radius: 4px;
            }

            ::-webkit-scrollbar-thumb:hover {
                background: linear-gradient(145deg, #5a6fd8 0%, #6b5b95 100%);
            }
            .main-image-wrapper-edit {
                position: relative;
                background: #fff;
                border-radius: 30px;
                box-shadow: 0 6px 40px #000dff16;
                min-height: 380px;
                max-width: 600px;
                margin-bottom: 24px;
                padding: 30px 0 22px 0;
                display: flex;
                align-items: center;
                justify-content: center;
                margin-left: auto;
                margin-right: auto;
            }
            .main-image-product-edit {
                max-width: 96%;
                max-height: 350px;
                object-fit: contain;
                border-radius: 20px;
                box-shadow: 0 4px 16px #6B73FF11;
                background: #fff;
            }
            .sub-images-scroll-edit {
                display: flex;
                flex-direction: column;
                align-items: center;     /* ẢNH PHỤ NẰM GIỮA */
                gap: 22px;
                padding: 16px 0 6px 0;
                max-height: 650px;
                overflow-y: auto;
            }


            .sub-image-wrapper-edit {
                flex: 0 0 auto;
                position: relative;
                width: 550px;     /* Tăng chiều rộng ảnh phụ */
                height: 300px;    /* Tăng chiều cao ảnh phụ */
                background: #fff;
                border-radius: 22px;
                box-shadow: 0 6px 24px #6B73FF13;
                display: flex;
                align-items: center;
                justify-content: center;
                margin-bottom: 14px;
                padding: 30px;
                transition: box-shadow .22s;
            }
            .sub-image-product-edit {
                max-width: 100%;
                max-height: 220px;   /* Tăng chiều cao ảnh trong khung */
                border-radius: 16px;
                object-fit: contain;
                background: #fff;
                transition: transform .18s;
            }
            .sub-image-actions {
                width: 100%;
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 12px;
                margin-top: 12px;
                margin-bottom: 6px;
                flex-wrap: wrap;
            }
            .order-input {
                width: 70px;
                border-radius: 8px;
                border: 2px solid #e2e8f0;
                text-align: center;
                font-weight: 600;
            }

            @media (max-width: 900px) {
                .main-image-wrapper-edit {
                    max-width: 99vw;
                    min-height: 180px;
                    padding: 10px 0;
                }
                .main-image-product-edit {
                    max-height: 140px;
                }
                .sub-image-wrapper-edit {
                    width: 110px;
                    height: 90px;
                }
                .sub-image-product-edit {
                    max-height: 70px;
                }
            }
            .btn-secondary-modern, .btn-secondary {
                background: linear-gradient(135deg, #ecebfa 0%, #b4b5ff 100%) !important;
                color: #6B73FF !important;
                margin-right: 5px;
            }

        </style>
    </head>
    <body>
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-lg-11 col-xl-10">
                    <div class="main-card fade-in">
                        <div class="card-header">
                            <h3 class="card-title">
                                <i class="fas fa-hand-holding-heart"></i>
                                <c:choose>
                                    <c:when test="${product != null}">Chỉnh Sửa Sản Phẩm</c:when>
                                    <c:otherwise>Thêm Sản Phẩm Mới</c:otherwise>
                                </c:choose>

                            </h3>
                            <div class="col-md-12 text-right">
                                <div class="d-flex justify-content-end flex-wrap gap-2">
                                    <a href="products" class="btn btn-secondary-modern btn-modern">
                                        <i class="fas fa-arrow-left"></i> Quay lại
                                    </a>

                                </div>
                            </div>
                        </div>

                        <div class="card-body">
                            <c:if test="${not empty errorMessage}">
                                <div class="alert alert-danger alert-dismissible fade show">
                                    <i class="fas fa-exclamation-triangle"></i> ${errorMessage}
                                    <button type="button" class="close" data-dismiss="alert">&times;</button>
                                </div>
                            </c:if>

                            <form action="products" method="post" enctype="multipart/form-data" onsubmit="return validateForm()">
                                <c:choose>
                                    <c:when test="${product != null}">
                                        <input type="hidden" name="action" value="update">
                                        <input type="hidden" name="productId" value="${product.productId}">
                                        <input type="hidden" name="isDeleted" value="${product.isDeleted}">
                                    </c:when>
                                    <c:otherwise>
                                        <input type="hidden" name="action" value="insert">
                                    </c:otherwise>
                                </c:choose>
                                <c:if test="${productDetail != null}">
                                    <input type="hidden" name="productDetailId" value="${productDetail.productDetailId}">
                                </c:if>

                                <!-- Thông Tin Sản Phẩm -->
                                <div class="form-section">
                                    <div class="section-header">
                                        <i class="fas fa-info-circle"></i>
                                        <span>Thông Tin Sản Phẩm</span>
                                    </div>
                                    <div class="row">
                                        <!-- Cột trái -->
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label for="productName">Tên Sản Phẩm <span class="required">*</span></label>
                                                <input type="text" class="form-control" id="productName" name="productName"
                                                       value="${product.productName}" required maxlength="255"
                                                       placeholder="Nhập tên sản phẩm">
                                            </div>
                                            <div class="form-group">
                                                <label for="brandName">Thương Hiệu <span class="required">*</span></label>
                                                <input type="text" class="form-control" id="brandName" name="brandName"
                                                       value="${product.brandName}" required maxlength="100"
                                                       placeholder="Nhập tên thương hiệu">
                                            </div>
                                            <div class="form-group">
                                                <label for="categoryId">Danh Mục <span class="required">*</span></label>
                                                <select class="form-control" id="categoryId" name="categoryId" required>
                                                    <option value="">-- Chọn danh mục --</option>
                                                    <c:forEach var="category" items="${listCategory}">
                                                        <option value="${category.categoryId}"
                                                                <c:if test="${product.categoryId.categoryId == category.categoryId}">selected</c:if>>
                                                            ${category.categoryName}
                                                        </option>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                            <div class="form-group">
                                                <label for="price">Giá Gốc (₫) <span class="required">*</span></label>
                                                <input type="number" class="form-control" id="price" name="price"
                                                       value="${product.price}" required min="0" step="1000" placeholder="0">
                                            </div>
                                            <div class="form-group">
                                                <label for="salePrice">Giá Khuyến Mãi (₫)</label>
                                                <input type="number" class="form-control" id="salePrice" name="salePrice"
                                                       value="${product.salePrice}" min="0" step="1000" placeholder="0">
                                            </div>
                                            <div class="form-group">
                                                <label for="reservedQuantity">Số lượng dự trữ</label>
                                                <input type="number" class="form-control" id="reservedQuantity" name="reservedQuantity"
                                                       value="${product.reservedQuantity}" min="0" placeholder="0">
                                            </div>
                                        </div>
                                        <!-- Cột phải -->
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label for="sku">SKU <span class="required">*</span></label>
                                                <input type="text" class="form-control" id="sku" name="sku"
                                                       value="${product.sku}" required maxlength="50"
                                                       placeholder="Mã sản phẩm (VD: MP001)">
                                            </div>
                                            <div class="form-group">
                                                <label for="stock">Số Lượng <span class="required">*</span></label>
                                                <input type="number" class="form-control" id="stock" name="stock"
                                                       value="${product.stock}" required min="0" placeholder="0">
                                            </div>
                                            <div class="form-group">
                                                <label for="quantityValue">Giá Trị</label>
                                                <input type="number" class="form-control" id="quantityValue" name="quantityValue"
                                                       value="${product.quantityValue}" min="0" step="0.01" placeholder="VD: 100">
                                            </div>
                                            <div class="form-group">
                                                <label for="quantityUnit">Đơn Vị</label>
                                                <input type="text" class="form-control" id="quantityUnit" name="quantityUnit"
                                                       value="${product.quantityUnit}" maxlength="20" placeholder="ml, g, ...">
                                            </div>
                                            <div class="form-group">
                                                <label for="status">Trạng Thái <span class="required">*</span></label>
                                                <select class="form-control" id="status" name="status" required>
                                                    <option value="active" <c:if test="${product.status == 'active'}">selected</c:if>>Hoạt động</option>
                                                    <option value="inactive" <c:if test="${product.status == 'inactive'}">selected</c:if>>Không hoạt động</option>
                                                    <option value="out_of_stock" <c:if test="${product.status == 'out_of_stock'}">selected</c:if>>Hết hàng</option>
                                                    </select>
                                                </div>
                                                <div class="form-group">
                                                    <div class="form-check">
                                                        <input class="form-check-input" type="checkbox" id="featured" name="featured"
                                                               value="1" <c:if test="${product != null && product.featured}">checked</c:if>>
                                                        <label class="form-check-label" for="featured">
                                                            <i class="fas fa-star text-warning"></i> Sản phẩm nổi bật
                                                        </label>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <!-- Mô tả ngắn -->
                                        <div class="form-group">
                                            <label for="shortDescription">Mô Tả Ngắn</label>
                                            <textarea class="form-control" id="shortDescription" name="shortDescription"
                                                      rows="3" maxlength="255" placeholder="Mô tả ngắn gọn về sản phẩm">${product.shortDescription}</textarea>
                                    </div>
                                </div>

                                <!-- Chi tiết sản phẩm -->
<div class="form-section">
    <div class="section-header">
        <i class="fas fa-clipboard-list"></i>
        <span>Thông Tin Chi Tiết</span>
    </div>
    <div class="row">
        <!-- Cột trái -->
        <div class="col-md-6">
            <div class="form-group">
                <label for="description">Mô tả chi tiết</label>
                <textarea class="form-control" id="description" name="description" rows="3"
                    placeholder="Nhập mô tả chi tiết về sản phẩm, công dụng, ưu điểm...">${productDetail != null ? productDetail.description : ''}</textarea>
            </div>
            <div class="form-group">
                <label for="ingredients">Thành phần</label>
                <input type="text" class="form-control" id="ingredients" name="ingredients"
                    value="${productDetail != null ? productDetail.ingredients : ''}"
                    placeholder="Ví dụ: Aqua, Glycerin, Niacinamide, ...">
            </div>
            <div class="form-group">
                <label for="origin">Xuất xứ</label>
                <input type="text" class="form-control" id="origin" name="origin"
                    value="${productDetail != null ? productDetail.origin : ''}"
                    placeholder="Ví dụ: Hàn Quốc, Pháp, Nhật Bản...">
            </div>
            <div class="form-group">
                <label for="skinConcerns">Vấn đề</label>
                <input type="text" class="form-control" id="skinConcerns" name="skinConcerns"
                    value="${productDetail != null ? productDetail.skinConcerns : ''}"
                    placeholder="Ví dụ: Da khô, da dầu, mụn, lão hóa...">
            </div>
        </div>
        <!-- Cột phải -->
        <div class="col-md-6">
            <div class="form-group">
                <label for="storageInstructions">Bảo quản</label>
                <input type="text" class="form-control" id="storageInstructions" name="storageInstructions"
                    value="${productDetail != null ? productDetail.storageInstructions : ''}"
                    placeholder="Ví dụ: Nơi khô ráo, tránh ánh nắng trực tiếp">
            </div>
            <div class="form-group">
                <label for="howToUse">Cách dùng</label>
                <input type="text" class="form-control" id="howToUse" name="howToUse"
                    value="${productDetail != null ? productDetail.howToUse : ''}"
                    placeholder="Ví dụ: Thoa đều lên mặt mỗi sáng và tối">
            </div>
            <div class="form-group">
                <label for="manufactureDate">Ngày sản xuất</label>
                <input type="date" class="form-control" id="manufactureDate" name="manufactureDate"
                    value="${productDetail != null ? productDetail.manufactureDate : ''}">
            </div>
            <div class="form-group">
                <label for="expiryDate">Hạn sử dụng</label>
                <input type="date" class="form-control" id="expiryDate" name="expiryDate"
                    value="${productDetail != null ? productDetail.expiryDate : ''}">
            </div>
        </div>
    </div>
</div>


                                <!-- Quản lý hình ảnh -->
                                <div class="form-section">
                                    <div class="section-header">
                                        <i class="fas fa-images"></i>
                                        <span>Quản Lý Hình Ảnh</span>
                                    </div>

                                    <!-- Hiển thị ảnh hiện tại -->
                                    <c:if test="${not empty productImages}">
                                        <h6 class="mb-3" style="color: #4a5568; font-weight: 600;">
                                            <i class="fas fa-image mr-2"></i>Hình ảnh hiện tại
                                        </h6>

                                        <!-- Ảnh chính -->
                                        <c:forEach var="image" items="${productImages}">
                                            <c:if test="${image.isMainImage == true}">
                                                <div class="main-image-wrapper-edit mb-3" id="img-block-${image.imageId}">
                                                    <img src="${pageContext.request.contextPath}/${image.imageUrl}" class="main-image-product-edit" />
                                                    <div class="main-badge">
                                                        <i class="fas fa-crown mr-1"></i>Ảnh chính
                                                    </div>
                                                    <button type="button" class="btn btn-danger btn-sm" style="position: absolute; top: 12px; right: 12px; z-index: 10;" onclick="markDelete('${image.imageId}')">
                                                        <i class="fas fa-trash"></i>
                                                    </button>
                                                    <input type="hidden" name="deleteImageIds" value="" id="delete-img-${image.imageId}">
                                                </div>
                                            </c:if>
                                        </c:forEach>

                                        <!-- Ảnh phụ -->
                                        <c:set var="hasSubImage" value="false"/>
                                        <c:forEach var="image" items="${productImages}">
                                            <c:if test="${image.isMainImage != true}">
                                                <c:set var="hasSubImage" value="true"/>
                                            </c:if>
                                        </c:forEach>
                                        <c:if test="${hasSubImage}">
                                            <div class="image-note mb-2">
                                                <span class="badge badge-sub-label"><i class="fas fa-images"></i> Ảnh phụ</span>
                                            </div>
                                            <div class="sub-images-scroll-edit mb-1 mt-2">
                                                <c:forEach var="image" items="${productImages}">
                                                    <c:if test="${image.isMainImage != true}">
                                                        <div class="sub-image-wrapper-edit" id="img-block-${image.imageId}">
                                                            <!-- ẢNH PHỤ -->
                                                            <img src="${pageContext.request.contextPath}/${image.imageUrl}" class="sub-image-product-edit" />

                                                            <!-- Hành động ở dưới ảnh -->
                                                            <div class="sub-image-actions" style="margin-top:16px;">
                                                                <button type="button" class="btn btn-danger btn-sm" onclick="markDelete('${image.imageId}')">
                                                                    <i class="fas fa-trash"></i> Xoá
                                                                </button>
                                                                <span class="badge badge-info ml-2 mr-2">Thứ tự hiển thị</span>
                                                                <input type="number" name="displayOrders[${image.imageId}]"
                                                                       value="${image.displayOrder}" min="1"
                                                                       class="form-control form-control-sm order-input" />
                                                            </div>
                                                            <input type="hidden" name="deleteImageIds" value="" id="delete-img-${image.imageId}">
                                                        </div>

                                                    </c:if>
                                                </c:forEach>
                                            </div>
                                        </c:if>
                                    </c:if>

                                    <!-- Tải ảnh mới -->
                                    <div class="upload-section mt-4">
                                        <div class="section-title">
                                            <i class="fas fa-upload"></i> Thêm hình ảnh mới
                                        </div>
                                        <div class="upload-grid row">
                                            <!-- Ảnh chính -->
                                            <div class="col-md-6">
                                                <label class="form-label">Ảnh chính</label>
                                                <ul class="nav nav-tabs" id="mainImageTab" role="tablist">
                                                    <li class="nav-item">
                                                        <a class="nav-link active" data-toggle="tab" href="#uploadMain" role="tab">Upload</a>
                                                    </li>
                                                    <li class="nav-item">
                                                        <a class="nav-link" data-toggle="tab" href="#linkMain" role="tab">Link ảnh</a>
                                                    </li>
                                                </ul>
                                                <div class="tab-content border rounded p-3 mt-2">
                                                    <div class="tab-pane fade show active" id="uploadMain" role="tabpanel">
                                                        <div class="image-upload-area text-center" onclick="document.getElementById('mainImage').click()">
                                                            <i class="fas fa-cloud-upload-alt fa-2x mb-2"></i>
                                                            <p class="text-muted">Kéo thả hoặc click để chọn ảnh chính</p>
                                                            <input type="file" class="d-none" id="mainImage" name="mainImage" accept="image/*" onchange="showMainFileName()">
                                                            <div id="mainImageName" style="margin-top:8px;font-size:15px;color:#007bff;"></div>
                                                        </div>

                                                    </div>
                                                    <div class="tab-pane fade" id="linkMain" role="tabpanel">
                                                        <label>URL ảnh chính</label>
                                                        <input type="text" name="mainImageUrl" class="form-control" placeholder="https://example.com/image.jpg" />
                                                    </div>
                                                </div>
                                            </div>
                                            <!-- Ảnh phụ -->
                                            <div class="col-md-6">
                                                <label class="form-label">Ảnh phụ</label>
                                                <ul class="nav nav-tabs" id="additionalImageTab" role="tablist">
                                                    <li class="nav-item">
                                                        <a class="nav-link active" data-toggle="tab" href="#uploadAdditional" role="tab">Upload</a>
                                                    </li>
                                                    <li class="nav-item">
                                                        <a class="nav-link" data-toggle="tab" href="#linkAdditional" role="tab">Link ảnh</a>
                                                    </li>
                                                </ul>
                                                <div class="tab-content border rounded p-3 mt-2">
                                                    <div class="tab-pane fade show active" id="uploadAdditional" role="tabpanel">
                                                        <div class="image-upload-area text-center" onclick="document.getElementById('subImages').click()">
                                                            <i class="fas fa-cloud-upload-alt fa-2x mb-2"></i>
                                                            <p class="text-muted">Kéo thả hoặc click để chọn ảnh phụ</p>
                                                            <input type="file" class="d-none" id="subImages" name="subImages" accept="image/*" multiple onchange="showSubFilesName()">
                                                            <div id="subImagesName" style="margin-top:8px;font-size:15px;color:#007bff;"></div>
                                                        </div>

                                                    </div>
                                                    <div class="tab-pane fade" id="linkAdditional" role="tabpanel">
                                                        <label>URL ảnh phụ</label>
                                                        <input type="text" name="subImageUrls" class="form-control" placeholder="https://example.com/image1.jpg, https://example.com/image2.jpg" />
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                        </div>
                        <!-- Nút submit -->
                        <div class="form-group text-right mt-4">
                            <a href="products" class="btn btn-secondary mr-2">
                                <i class="fas fa-times"></i> Hủy
                            </a>
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-save"></i>
                                <c:choose>
                                    <c:when test="${product != null}">Cập Nhật</c:when>
                                    <c:otherwise>Thêm Mới</c:otherwise>
                                </c:choose>
                            </button>
                        </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>
    <script>
                                                                function validateForm() {
                                                                    let isValid = true;
                                                                    $('.form-control').removeClass('is-invalid');
                                                                    // Validate required fields
                                                                    const requiredFields = ['productName', 'brandName', 'price', 'stock', 'sku', 'status', 'categoryId'];
                                                                    requiredFields.forEach(function (fieldId) {
                                                                        const field = document.getElementById(fieldId);
                                                                        if (!field.value.trim()) {
                                                                            field.classList.add('is-invalid');
                                                                            isValid = false;
                                                                        }
                                                                    });
                                                                    // Validate price
                                                                    const price = parseFloat(document.getElementById('price').value);
                                                                    const salePrice = parseFloat(document.getElementById('salePrice').value);
                                                                    if (price < 0) {
                                                                        document.getElementById('price').classList.add('is-invalid');
                                                                        alert('Giá gốc phải lớn hơn hoặc bằng 0!');
                                                                        isValid = false;
                                                                    }
                                                                    if (!isNaN(salePrice) && salePrice > 0 && salePrice >= price) {
                                                                        document.getElementById('salePrice').classList.add('is-invalid');
                                                                        alert('Giá khuyến mãi phải nhỏ hơn giá gốc!');
                                                                        isValid = false;
                                                                    }
                                                                    // Validate quantity
                                                                    const stock = parseInt(document.getElementById('stock').value);
                                                                    if (stock < 0) {
                                                                        document.getElementById('stock').classList.add('is-invalid');
                                                                        alert('Số lượng phải lớn hơn hoặc bằng 0!');
                                                                        isValid = false;
                                                                    }
                                                                    return isValid;
                                                                }

                                                                function markDelete(imageId) {
                                                                    // Đánh dấu ảnh sẽ xoá bằng cách set value cho input hidden
                                                                    document.getElementById('delete-img-' + imageId).value = imageId;
                                                                    // Ẩn luôn block ảnh trên giao diện
                                                                    document.getElementById('img-block-' + imageId).style.display = 'none';
                                                                }
                                                                function showMainFileName() {
                                                                    var input = document.getElementById('mainImage');
                                                                    var label = document.getElementById('mainImageName');
                                                                    if (input.files && input.files.length > 0) {
                                                                        label.textContent = input.files[0].name;
                                                                    } else {
                                                                        label.textContent = '';
                                                                    }
                                                                }

                                                                function showSubFilesName() {
                                                                    var input = document.getElementById('subImages');
                                                                    var label = document.getElementById('subImagesName');
                                                                    if (input.files && input.files.length > 0) {
                                                                        let names = [];
                                                                        for (let i = 0; i < input.files.length; i++) {
                                                                            names.push(input.files[i].name);
                                                                        }
                                                                        label.textContent = names.join(', ');
                                                                    } else {
                                                                        label.textContent = '';
                                                                    }
                                                                }

    </script>
</body>
</html>
