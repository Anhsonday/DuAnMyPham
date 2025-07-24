<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Quản Lý Sản Phẩm</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
        
        
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
        <style>
            /* Modern Product Management Styles - Scaled to 80% */
            :root {
                --primary-gradient: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                --secondary-gradient: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
                --success-gradient: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
                --warning-gradient: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
                --danger-gradient: linear-gradient(135deg, #fa709a 0%, #fee140 100%);
                --info-gradient: linear-gradient(135deg, #a8edea 0%, #fed6e3 100%);

                --shadow-soft: 0 6.4px 25.6px 0 rgba(31, 38, 135, 0.37);
                --shadow-hover: 0 12px 28px rgba(31, 38, 135, 0.2);
                --border-radius: 16px;
                --transition: all 0.3s cubic-bezier(0.25, 0.8, 0.25, 1);
            }

            /* Global Styles */
            body {
                background: linear-gradient(135deg, white 0%, #764ba2 100%);
                min-height: 100vh;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                margin: 0;
                padding: 0;
                font-size: 0.8rem; /* 80% of default */
            }

            .container-fluid {
                padding: 2.4rem; /* 80% of 3rem */
                max-width: 1600px; /* 80% of 2000px */
                margin: 0 auto;
            }

            /* Glass Card Effect */
            .card {
                border-radius: 22.4px; /* 80% of 28px */
                box-shadow: 0 8px 25.6px 0 rgba(90,120,200,0.16), 0 1.6px 6.4px 0 rgba(60,72,88,0.12);
                overflow: hidden;
            }
            
            .card-header {
                background: linear-gradient(90deg, #57d6fd 0%, #7857fd 100%);
                color: #fff;
                padding: 22.4px 30.4px 16px 30.4px; /* 80% of original */
                border-radius: 22.4px 22.4px 0 0 !important;
                display: flex;
                align-items: center;
                justify-content: space-between;
                border-bottom: none;
            }
            
            .card-title {
                font-size: 1.68rem; /* 80% of 2.1rem */
                font-weight: 800;
                text-shadow: 0.8px 2.4px 6.4px #8671e7a2;
                letter-spacing: .032em; /* 80% of .04em */
                margin-bottom: 0;
            }
            
            .btn-primary {
                background: linear-gradient(90deg,#ee9ca7 0%, #ffdde1 100%);
                color: #424874 !important;
                border: none;
                border-radius: 9.6px; /* 80% of 12px */
                font-size: 0.864em; /* 80% of 1.08em */
                font-weight: 600;
                box-shadow: 0 2.4px 11.2px #c48ce25a;
                padding: 8px 20px; /* 80% of 10px 25px */
                transition: box-shadow .2s, background .25s, color .18s;
            }
            
            .btn-primary:hover, .btn-primary:focus {
                background: linear-gradient(90deg, #a8edea 0%, #fed6e3 100%);
                color: #7c2ae8 !important;
                box-shadow: 0 6.4px 24px #9469e46a;
            }
            
            .table-responsive {
                border-radius: 16px; /* 80% of 20px */
                box-shadow: var(--shadow-soft);
                overflow-y: auto;
                overflow-x: auto;
                max-height: 640px; /* 80% of 800px */
            }

            .table {
                width: 100%;
                background: rgba(255, 255, 255, 0.9);
                backdrop-filter: blur(8px); /* 80% of 10px */
                margin: 0;
                border-collapse: separate;
                border-spacing: 0;
            }

            .table thead th {
                background: var(--primary-gradient);
                color: white;
                font-weight: 700;
                text-align: center;
                padding: 0.96rem 0.64rem; /* 80% of 1.2rem 0.8rem */
                font-size: 0.76rem; /* 80% of 0.95rem */
                text-transform: uppercase;
                letter-spacing: 0.4px; /* 80% of 0.5px */
                border: none;
                position: sticky;
                top: 0;
                z-index: 10;
            }

            .table tbody td {
                padding: 0.8rem 0.64rem; /* 80% of 1rem 0.8rem */
                vertical-align: middle;
                text-align: center;
                border-bottom: 1px solid rgba(0, 0, 0, 0.05);
                transition: var(--transition);
            }

            .table-hover tbody tr {
                transition: box-shadow .22s, transform .18s, background .15s;
            }
            
            .table-hover tbody tr:hover {
                background: linear-gradient(90deg,#e8f0fe 0%, #ffe3ed 100%);
                box-shadow: 0 1.6px 17.6px #e9c8ff7a;
                transform: scale(1.0096); /* 80% of 1.012 */
                z-index: 2;
                position: relative;
            }
            
            .badge {
                font-size: 0.784em; /* 80% of 0.98em */
                padding: 5.6px 14.4px; /* 80% of 7px 18px */
                border-radius: 12px; /* 80% of 15px */
                font-weight: 600;
                box-shadow: 0 1.6px 6.4px #c0b2ff42;
            }
            
            .badge-success {
                background: linear-gradient(90deg,#81fbb8 0%, #28c76f 100%);
                color: #23653a;
            }
            
            .badge-warning {
                background: linear-gradient(90deg,#fff886 0%, #f072b6 100%);
                color: #86550b;
            }
            
            .badge-danger {
                background: linear-gradient(90deg,#fdc5c5 0%, #fc5c7d 100%);
                color: #84213b;
            }
            
            .badge-secondary {
                background: linear-gradient(90deg,#e0eafc 0%, #cfdef3 100%);
                color: #424874;
            }
            
            .badge-info {
                background: linear-gradient(90deg,#43e97b 0%, #38f9d7 100%);
                color: #17575c;
            }
            
            .featured-badge {
                background: linear-gradient(90deg,#f7971e 0%, #ffd200 100%);
                color: white;
                font-size: 0.784em; /* 80% of 0.98em */
                border-radius: 8px; /* 80% of 10px */
                padding: 4.8px 11.2px; /* 80% of 6px 14px */
                margin-top: 1.6px; /* 80% of 2px */
                box-shadow: 0 1.6px 6.4px #f8d34b66;
            }
            
            .skin-type-badge {
                background: linear-gradient(90deg,pink 0%, white 100%);
                color: #432885;
                font-size: 0.792em; /* 80% of 0.99em */
                border-radius: 8px; /* 80% of 10px */
                padding: 4.8px 11.2px; /* 80% of 6px 14px */
            }
            
            .brand-name, .product-name {
                font-weight: 700;
                color: #5643fa;
            }
            
            .actions-col {
                min-width: 96px; /* 80% of 120px */
                text-align: center;
            }
            
            .btn-action-group .btn {
                border-radius: 6.4px; /* 80% of 8px */
                font-size: 0.864em; /* 80% of 1.08em */
                margin-bottom: 5.6px; /* 80% of 7px */
                margin-right: 0;
                transition: box-shadow .17s, background .21s, color .15s;
            }
            
            .btn-info {
                background: linear-gradient(90deg,#d7d2cc 0%, #304352 100%);
                color: #fff !important;
                border: none;
            }
            
            .btn-info:hover {
                background: #81ecec !important;
                color: #342343 !important;
            }
            
            .btn-warning {
                background: linear-gradient(90deg,#fceabb 0%, #f8b500 100%);
                color: #654321 !important;
                border: none;
            }
            
            .btn-warning:hover {
                background: #fffde4 !important;
                color: #f59e00 !important;
            }
            
            .btn-danger {
                background: linear-gradient(90deg,#ff5858 0%, #f09819 100%);
                color: #fff !important;
                border: none;
            }
            
            .btn-danger:hover {
                background: #ffc3a0 !important;
                color: #84213b !important;
            }
            
            .btn-success {
                background: linear-gradient(90deg,#43e97b 0%, #38f9d7 100%);
                color: #fff !important;
                border: none;
            }
            
            .btn-success:hover {
                background: #bff098 !important;
                color: #17575c !important;
            }
            
            .empty-state {
                background: linear-gradient(120deg,#f6d365 0%, #fda085 100%);
                border-radius: 22.4px; /* 80% of 28px */
                margin-top: 24px; /* 80% of 30px */
                padding: 49.6px 0; /* 80% of 62px */
                box-shadow: 0 1.6px 9.6px #dcb6f5a5;
            }
            
            .empty-state i {
                color: #ad5389;
            }
            
            @media (max-width: 1100px) {
                .table th, .table td {
                    font-size: 0.76em; /* 80% of 0.95em */
                    padding: 6.4px 3.2px; /* 80% of 8px 4px */
                }
            }
            
            .btn-action {
                width: 2rem; /* 80% of 2.5rem */
                height: 2rem; /* 80% of 2.5rem */
                border-radius: 50%;
                border: none;
                display: inline-flex;
                align-items: center;
                justify-content: center;
                margin: 0.16rem; /* 80% of 0.2rem */
                transition: all 0.3s ease;
                font-size: 0.72rem; /* 80% of 0.9rem */
                position: relative;
                overflow: hidden;
            }

            .btn-action::before {
                content: '';
                position: absolute;
                top: 50%;
                left: 50%;
                width: 0;
                height: 0;
                background: rgba(255,255,255,0.3);
                border-radius: 50%;
                transform: translate(-50%, -50%);
                transition: all 0.3s ease;
            }

            .btn-action:hover::before {
                width: 100%;
                height: 100%;
            }

            .btn-action:hover {
                transform: translateY(-1.6px); /* 80% of -2px */
                box-shadow: 0 6.4px 16px rgba(0,0,0,0.3);
            }

            .btn-view {
                background: var(--info-gradient);
                color: var(--text-primary);
            }
            
            .btn-edit {
                background: var(--warning-gradient);
                color: white;
            }
            
            .btn-delete {
                background: var(--danger-gradient);
                color: white;
            }
            
            .btn-restore {
                background: var(--success-gradient);
                color: white;
            }

            /* Additional scaling for modals */
            .modal-dialog {
                transform: scale(0.8);
                transform-origin: center;
            }

            .modal-title {
                font-size: 1.2rem; /* 80% of 1.5rem */
            }

            .modal-body {
                padding: 1.2rem; /* 80% of 1.5rem */
            }

            .modal-footer {
                padding: 0.8rem 1.2rem; /* 80% of 1rem 1.5rem */
            }

            /* Alert scaling */
            .alert {
                padding: 0.8rem 1.2rem; /* 80% of 1rem 1.5rem */
                margin-bottom: 0.8rem; /* 80% of 1rem */
                border-radius: 0.4rem; /* 80% of 0.5rem */
            }

            /* Icon scaling */
            .fas {
                font-size: 0.8em;
            }

            /* Tooltip scaling */
            .tooltip {
                font-size: 0.7rem; /* 80% of default */
            }
        </style>
    </head>
    <body>
        <div class="container-fluid">
            <div class="row">
                <!-- Thêm sidebar -->
            <jsp:include page="includes/sidebar.jsp">
                <jsp:param name="page" value="products" />
            </jsp:include>
                <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
                    <div class="card">
                        <div class="card-header">
                            <span class="card-title">
                                <i class="fas fa-hand-holding-heart"></i> Quản Lý Sản Phẩm Chăm Sóc Da
                            </span>
                            <a href="products?action=new" class="btn btn-primary shadow" style="box-shadow: 0 0 14.4px #ff7eb3a6;">
                                <i class="fas fa-plus"></i> Thêm sản phẩm mới
                            </a>
                        </div>
                        <div class="card-body">
                            <!-- Thông báo thành công/thất bại -->
                            <c:if test="${not empty successMessage}">
                                <div class="alert alert-success alert-dismissible fade show">
                                    <i class="fas fa-check-circle"></i> ${successMessage}
                                    <button type="button" class="close" data-dismiss="alert">&times;</button>
                                </div>
                            </c:if>
                            <c:if test="${not empty errorMessage}">
                                <div class="alert alert-danger alert-dismissible fade show">
                                    <i class="fas fa-exclamation-circle"></i> ${errorMessage}
                                    <button type="button" class="close" data-dismiss="alert">&times;</button>
                                </div>
                            </c:if>
                            <!-- Bảng sản phẩm VIP -->
                            <div class="table-responsive">
                                <table class="table table-striped table-hover">
                                    <thead>
                                        <tr>
                                            <th>ID</th>
                                            <th>Tên sản phẩm</th>
                                            <th>Thương hiệu</th>
                                            <th>Danh mục</th>
                                            <th>Mô tả ngắn</th>
                                            <th>Giá gốc</th>
                                            <th>Giá khuyến mãi</th>
                                            <th>Số lượng</th>
                                            <th>Đã giữ chỗ</th>
                                            <th>SKU</th>
                                            <th>Giá trị</th>
                                            <th>Đơn vị</th>
                                            <th>Trạng thái</th>
                                            <th>Nổi bật</th>
                                            
                                            <th>Ngày tạo</th>
                                            <th class="actions-col">Hành động</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="product" items="${listProduct}">
                                            <tr>
                                                <td>${product.productId}</td>
                                                <td class="product-name">${product.productName}</td>
                                                <td><span class="brand-name">${product.brandName}</span></td>
                                                <td>
                                                    <c:forEach var="category" items="${listCategory}">
                                                        <c:if test="${category.categoryId == product.categoryId.categoryId}">
                                                            <div>${category.categoryName}</div>
                                                            <c:if test="${category.parentCategoryId != null}">
                                                                <c:forEach var="parentCategory" items="${listCategory}">
                                                                    <c:if test="${parentCategory.categoryId == category.parentCategoryId.categoryId}">
                                                                        <small class="text-muted">${parentCategory.categoryName}</small>
                                                                    </c:if>
                                                                </c:forEach>
                                                            </c:if>
                                                        </c:if>
                                                    </c:forEach>
                                                </td>
                                                
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${not empty product.shortDescription}">
                                                            <span data-toggle="tooltip" data-placement="top" title="${product.shortDescription}">
                                                                <i class="fas fa-info-circle"></i>
                                                                <span style="font-size:0.776em">${product.shortDescription}</span>
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="text-muted">-</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${product.price != null && product.price > 0}">
                                                            <fmt:formatNumber value="${product.price}" type="currency" currencySymbol="₫" pattern="#,##0 ₫"/>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="text-muted">-</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${product.salePrice != null && product.salePrice > 0}">
                                                            <span class="text-danger font-weight-bold">
                                                                <fmt:formatNumber value="${product.salePrice}" type="currency" currencySymbol="₫" pattern="#,##0 ₫"/>
                                                            </span>
                                                            <c:if test="${product.salePrice < product.price}">
                                                                <div class="text-success small font-italic">
                                                                    -<fmt:formatNumber value="${(product.price - product.salePrice) * 100 / product.price}" maxFractionDigits="0"/>%
                                                                </div>
                                                            </c:if>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="text-muted">-</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${product.stock > 10}">
                                                            <span class="badge badge-success">${product.stock}</span>
                                                        </c:when>
                                                        <c:when test="${product.stock > 0}">
                                                            <span class="badge badge-warning">${product.stock}</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge badge-danger">${product.stock}</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <span class="badge badge-info">${product.reservedQuantity}</span>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${not empty product.sku}">
                                                            <span class="badge"><code>${product.sku}</code></span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="text-muted">-</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>

                                                <td>
                                                    <c:choose>
                                                        <c:when test="${not empty product.quantityValue}">
                                                            ${product.quantityValue}
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="text-muted">-</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${not empty product.quantityUnit}">
                                                            ${product.quantityUnit}
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="text-muted">-</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${product.status == 'active'}">
                                                            <span class="badge badge-success">
                                                                <i class="fas fa-check"></i> Hoạt động
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${product.status == 'inactive'}">
                                                            <span class="badge badge-secondary">
                                                                <i class="fas fa-pause"></i> Không hoạt động
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${product.status == 'out_of_stock'}">
                                                            <span class="badge badge-warning">
                                                                <i class="fas fa-exclamation-triangle"></i> Hết hàng
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge badge-secondary">${product.status}</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:if test="${product.featured}">
                                                        <span class="featured-badge badge">
                                                            <i class="fas fa-star"></i>
                                                        </span>
                                                    </c:if>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${not empty product.createdAt}">
                                                            <fmt:formatDate value="${product.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="text-muted">-</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="actions-col">
                                                    <div class="btn-group-vertical btn-group-sm btn-action-group" role="group">
                                                        <a href="products?action=view&id=${product.productId}" 
                                                           class="btn btn-info" 
                                                           data-toggle="tooltip" title="Xem chi tiết">
                                                            <i class="fas fa-eye"></i>
                                                        </a>
                                                        <a href="products?action=edit&id=${product.productId}" 
                                                           class="btn btn-warning"
                                                           data-toggle="tooltip" title="Chỉnh sửa">
                                                            <i class="fas fa-edit"></i>
                                                        </a>
                                                        <c:choose>
                                                            <c:when test="${product.isDeleted == false}">
                                                                <button type="button" 
                                                                        class="btn btn-danger" 
                                                                        data-bs-toggle="modal"
                                                                        data-bs-target="#deleteModal${product.productId}"
                                                                        title="Xóa sản phẩm">
                                                                    <i class="fas fa-trash"></i>
                                                                </button>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <button type="button" 
                                                                        class="btn btn-success" 
                                                                        data-bs-toggle="modal" 
                                                                        data-bs-target="#restoreModal${product.productId}"
                                                                        title="Khôi phục">
                                                                    <i class="fas fa-undo"></i>
                                                                </button>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                </td>
                                            </tr>
                                            <!-- Modal xác nhận xóa -->
                                        <div id="deleteModal${product.productId}" class="modal fade" tabindex="-1">
                                            <div class="modal-dialog">
                                                <div class="modal-content">
                                                    <form action="products?action=delete" method="POST">
                                                        <div class="modal-header">
                                                            <h4 class="modal-title">
                                                                <i class="fas fa-exclamation-triangle text-warning"></i>
                                                                Xác nhận xóa sản phẩm
                                                            </h4>
                                                            <button type="button" class="close" data-dismiss="modal">&times;</button>
                                                        </div>
                                                        <div class="modal-body">
                                                            <p>Bạn có chắc chắn muốn xóa sản phẩm <strong>"${product.productName}"</strong> không?</p>
                                                            <div class="alert alert-warning">
                                                                <small><i class="fas fa-info-circle"></i> Sản phẩm sẽ được đánh dấu là đã xóa nhưng vẫn giữ lại trong hệ thống.</small>
                                                            </div>
                                                        </div>
                                                        <div class="modal-footer">
                                                            <input type="hidden" name="productId" value="${product.productId}">
                                                            <input type="hidden" name="id" value="${product.productId}">
                                                            <button type="button" class="btn btn-secondary" data-dismiss="modal">
                                                                <i class="fas fa-times"></i> Hủy
                                                            </button>
                                                            <button type="submit" class="btn btn-danger">
                                                                <i class="fas fa-trash"></i> Xóa
                                                            </button>
                                                        </div>
                                                    </form>
                                                </div>
                                            </div>
                                        </div>
                                        <!-- Modal xác nhận khôi phục -->
                                        <div id="restoreModal${product.productId}" class="modal fade" tabindex="-1">
                                            <div class="modal-dialog">
                                                <div class="modal-content">
                                                    <form action="products?action=restore" method="POST">
                                                        <div class="modal-header">
                                                            <h4 class="modal-title">
                                                                <i class="fas fa-undo text-success"></i>
                                                                Xác nhận khôi phục sản phẩm
                                                            </h4>
                                                            <button type="button" class="close" data-dismiss="modal">&times;</button>
                                                        </div>
                                                        <div class="modal-body">
                                                            <p>Bạn có chắc chắn muốn khôi phục sản phẩm <strong>"${product.productName}"</strong> không?</p>
                                                            <div class="alert alert-info">
                                                                <small><i class="fas fa-info-circle"></i> Sản phẩm sẽ được khôi phục và có thể sử dụng bình thường.</small>
                                                            </div>
                                                        </div>
                                                        <div class="modal-footer">
                                                            <input type="hidden" name="productId" value="${product.productId}">
                                                            <input type="hidden" name="id" value="${product.productId}">
                                                            <button type="button" class="btn btn-secondary" data-dismiss="modal">
                                                                <i class="fas fa-times"></i> Hủy
                                                            </button>
                                                            <button type="submit" class="btn btn-success">
                                                                <i class="fas fa-undo"></i> Khôi phục
                                                            </button>
                                                        </div>
                                                    </form>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                            <!-- Empty State -->
                            <c:if test="${empty listProduct}">
                                <div class="empty-state text-center">
                                    <i class="fas fa-crown fa-3x mb-3"></i>
                                    <h5 class="text-muted">Chưa có sản phẩm nào</h5>
                                    <p class="text-muted">Hãy thêm sản phẩm chăm sóc da đầu tiên của bạn và làm chủ bộ sưu tập VIP!</p>
                                    <a href="products?action=new" class="btn btn-primary" style="font-size:1.11em;">
                                        <i class="fas fa-plus"></i> Thêm sản phẩm mới
                                    </a>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </main>
            </div>
        </div>
        <script>
            $(function () {
                $('[data-toggle="tooltip"]').tooltip();
            });
        </script>
    </body>
</html>
