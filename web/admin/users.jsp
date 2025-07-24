<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý người dùng - Fish Shop Admin</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- DataTables CSS -->
    <link href="https://cdn.datatables.net/1.13.4/css/dataTables.bootstrap5.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
        <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
      <style>
    body {
        background: #f5f6fa;
    }
    .main-content {
        background: #f5f6fa;
        min-height: 100vh;
        padding-bottom: 40px;
    }
    .stats-card {
        border-left: 4px solid #6dbb43;
        border-radius: 12px;
        box-shadow: 0 2px 8px rgba(109,187,67,0.08);
        transition: transform 0.2s, box-shadow 0.2s;
        background: #fff;
    }
    .stats-card:hover {
        transform: translateY(-3px) scale(1.02);
        box-shadow: 0 6px 18px rgba(109,187,67,0.13);
    }
    .user-avatar {
        width: 44px;
        height: 44px;
        border-radius: 50%;
        object-fit: cover;
        border: 2px solid #e0e0e0;
        background: #fff;
        box-shadow: 0 1px 4px rgba(0,0,0,0.07);
    }
    .user-avatar.bg-secondary {
        background: #bdbdbd !important;
    }
    .status-badge {
        font-size: 0.85em;
        padding: 0.35em 0.8em;
        border-radius: 12px;
        font-weight: 600;
        letter-spacing: 0.5px;
        box-shadow: 0 1px 4px rgba(0,0,0,0.06);
    }
    .role-badge {
        font-size: 0.85em;
        padding: 0.35em 0.8em;
        border-radius: 12px;
        font-weight: 600;
        letter-spacing: 0.5px;
        box-shadow: 0 1px 4px rgba(0,0,0,0.06);
    }
    .badge.bg-danger, .badge.bg-primary {
        color: #fff !important;
    }
    .badge.bg-danger {
        background: linear-gradient(135deg, #ff5e7b, #c471ed) !important;
    }
    .badge.bg-primary {
        background: linear-gradient(135deg, #6dbb43, #4e8c2b) !important;
    }
    .badge.bg-success {
        background: linear-gradient(135deg, #43e97b, #38f9d7) !important;
        color: #fff !important;
    }
    .badge.bg-warning {
        background: linear-gradient(135deg, #fa709a, #fee140) !important;
        color: #fff !important;
    }
    .card {
        border-radius: 14px;
        box-shadow: 0 2px 10px rgba(109,187,67,0.07);
        border: none;
    }
    .card-header {
        background: linear-gradient(135deg, #6dbb43, #4e8c2b);
        color: #fff;
        border-radius: 14px 14px 0 0;
        border: none;
        font-weight: 600;
        letter-spacing: 0.5px;
    }
    .card-title {
        font-size: 1.2rem;
        font-weight: 700;
    }
    .table {
        background: #fff;
        border-radius: 10px;
        overflow: hidden;
        margin-bottom: 0;
    }
    .table thead.table-dark th {
        background: linear-gradient(135deg, #6dbb43, #4e8c2b);
        color: #fff;
        font-size: 1rem;
        font-weight: 700;
        border: none;
    }
    .table-striped>tbody>tr:nth-of-type(odd) {
        background-color: #f7fafc;
    }
    .table-hover>tbody>tr:hover {
        background-color: #eafbe7;
        transition: background 0.2s;
    }
    .table td, .table th {
        vertical-align: middle;
        padding: 0.75rem 0.7rem;
    }
    .btn-group .btn {
        border-radius: 8px !important;
        margin-right: 4px;
        font-size: 0.95em;
        padding: 0.35em 0.7em;
        box-shadow: 0 1px 4px rgba(0,0,0,0.06);
        transition: background 0.2s, color 0.2s;
    }
    .btn-group .btn:last-child {
        margin-right: 0;
    }
    .btn-outline-info:hover, .btn-outline-primary:hover, .btn-outline-warning:hover, .btn-outline-success:hover, .btn-outline-danger:hover {
        color: #fff !important;
    }
    .btn-outline-info:hover {
        background: #17a2b8;
    }
    .btn-outline-primary:hover {
        background: #6dbb43;
    }
    .btn-outline-warning:hover {
        background: #ffc107;
    }
    .btn-outline-success:hover {
        background: #43e97b;
    }
    .btn-outline-danger:hover {
        background: #ff5e7b;
    }
    .card .form-label {
        font-weight: 600;
        color: #4e8c2b;
    }
    .form-select, .form-control {
        border-radius: 8px;
        box-shadow: none;
        border: 1px solid #e0e0e0;
    }
    .form-select:focus, .form-control:focus {
        border-color: #6dbb43;
        box-shadow: 0 0 0 2px rgba(109,187,67,0.13);
    }
    .alert {
        border-radius: 10px;
        font-size: 1em;
        box-shadow: 0 2px 8px rgba(109,187,67,0.08);
    }
    .modal-content {
        border-radius: 14px;
        box-shadow: 0 4px 18px rgba(109,187,67,0.13);
    }
    .modal-header {
        background: linear-gradient(135deg, #6dbb43, #4e8c2b);
        color: #fff;
        border-radius: 14px 14px 0 0;
    }
    .modal-title {
        font-weight: 700;
    }
    .btn-primary, .btn-primary:focus {
        background: linear-gradient(135deg, #6dbb43, #4e8c2b);
        border: none;
        font-weight: 600;
        letter-spacing: 0.5px;
        border-radius: 8px;
    }
    .btn-primary:hover {
        background: linear-gradient(135deg, #4e8c2b, #6dbb43);
    }
    .btn-secondary, .btn-secondary:focus {
        border-radius: 8px;
    }
    /* Filter card */
    .card.mb-4 {
        border-radius: 12px;
        box-shadow: 0 2px 8px rgba(109,187,67,0.08);
        border: none;
        background: #fff;
    }
    .form-label {
        font-weight: 600;
        color: #4e8c2b;
    }
    /* Responsive */
    @media (max-width: 991px) {
        .main-content {
            padding: 10px 0 40px 0;
        }
        .card, .card-header, .modal-content {
            border-radius: 10px !important;
        }
        .user-avatar {
            width: 36px;
            height: 36px;
        }
    }
</style>
</head>

<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <jsp:include page="includes/sidebar.jsp">
                <jsp:param name="page" value="users" />
            </jsp:include>

            <!-- Main content -->
            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 main-content">
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2">Quản lý người dùng</h1>                    <div class="btn-toolbar mb-2 mb-md-0">
                        <a href="${pageContext.request.contextPath}/admin-users?action=create" class="btn btn-primary">
                            <i class="fas fa-plus me-2"></i>Thêm người dùng
                        </a>
                    </div>
                </div>                <!-- Success/Error Messages -->
                <c:if test="${not empty sessionScope.successMessage}">
                    <div class="alert alert-success alert-dismissible fade show">
                        <i class="fas fa-check-circle me-2"></i>${sessionScope.successMessage}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                    <c:remove var="successMessage" scope="session"/>
                </c:if>
                
                <c:if test="${not empty sessionScope.errorMessage}">
                    <div class="alert alert-danger alert-dismissible fade show">
                        <i class="fas fa-exclamation-circle me-2"></i>${sessionScope.errorMessage}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                    <c:remove var="errorMessage" scope="session"/>
                </c:if>
                
                <!-- Fallback for request scope messages -->
                <c:if test="${not empty successMessage}">
                    <div class="alert alert-success alert-dismissible fade show">
                        <i class="fas fa-check-circle me-2"></i>${successMessage}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>
                
                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-danger alert-dismissible fade show">
                        <i class="fas fa-exclamation-circle me-2"></i>${errorMessage}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <!-- Statistics Cards -->
                <c:if test="${not empty userStatistics}">
                    <div class="row mb-4">
                        <div class="col-xl-3 col-md-6 mb-4">
                            <div class="card stats-card h-100 py-2">
                                <div class="card-body">
                                    <div class="row no-gutters align-items-center">
                                        <div class="col mr-2">
                                            <div class="text-xs font-weight-bold text-primary text-uppercase mb-1">
                                                Tổng người dùng
                                            </div>
                                            <div class="h5 mb-0 font-weight-bold text-gray-800">
                                                ${userStatistics.totalUsers}
                                            </div>
                                        </div>
                                        <div class="col-auto">
                                            <i class="fas fa-users fa-2x text-gray-300"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="col-xl-3 col-md-6 mb-4">
                            <div class="card stats-card h-100 py-2">
                                <div class="card-body">
                                    <div class="row no-gutters align-items-center">
                                        <div class="col mr-2">
                                            <div class="text-xs font-weight-bold text-success text-uppercase mb-1">
                                                Người dùng hoạt động
                                            </div>
                                            <div class="h5 mb-0 font-weight-bold text-gray-800">
                                                ${userStatistics.activeUsers}
                                            </div>
                                        </div>
                                        <div class="col-auto">
                                            <i class="fas fa-user-check fa-2x text-gray-300"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="col-xl-3 col-md-6 mb-4">
                            <div class="card stats-card h-100 py-2">
                                <div class="card-body">
                                    <div class="row no-gutters align-items-center">
                                        <div class="col mr-2">
                                            <div class="text-xs font-weight-bold text-info text-uppercase mb-1">
                                                Quản trị viên
                                            </div>
                                            <div class="h5 mb-0 font-weight-bold text-gray-800">
                                                ${userStatistics.adminUsers}
                                            </div>
                                        </div>
                                        <div class="col-auto">
                                            <i class="fas fa-user-shield fa-2x text-gray-300"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="col-xl-3 col-md-6 mb-4">
                            <div class="card stats-card h-100 py-2">
                                <div class="card-body">
                                    <div class="row no-gutters align-items-center">
                                        <div class="col mr-2">
                                            <div class="text-xs font-weight-bold text-warning text-uppercase mb-1">
                                                Mới tháng này
                                            </div>
                                            <div class="h5 mb-0 font-weight-bold text-gray-800">
                                                ${userStatistics.newUsersThisMonth}
                                            </div>
                                        </div>
                                        <div class="col-auto">
                                            <i class="fas fa-user-plus fa-2x text-gray-300"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:if>

                <!-- Filters and Search -->
                <div class="card mb-4">
                    <div class="card-body">
                        <form method="GET" action="${pageContext.request.contextPath}/admin-users" class="row g-3">
                            <div class="col-md-3">
                                <label for="roleFilter" class="form-label">Lọc theo vai trò</label>
                                <select class="form-select" id="roleFilter" name="role">
                                    <option value="">Tất cả vai trò</option>
                                    <option value="admin" ${roleFilter == 'admin' ? 'selected' : ''}>Admin</option>
                                    <option value="customer" ${roleFilter == 'customer' ? 'selected' : ''}>Customer</option>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <label for="statusFilter" class="form-label">Lọc theo trạng thái</label>
                                <select class="form-select" id="statusFilter" name="status">
                                    <option value="">Tất cả trạng thái</option>
                                    <option value="active" ${statusFilter == 'active' ? 'selected' : ''}>Hoạt động</option>
                                    <option value="inactive" ${statusFilter == 'inactive' ? 'selected' : ''}>Không hoạt động</option>
                                </select>
                            </div>
                            <div class="col-md-4">
                                <label for="keyword" class="form-label">Tìm kiếm</label>
                                <input type="text" class="form-control" id="keyword" name="keyword" 
                                       placeholder="Tên, email, số điện thoại..." value="${searchKeyword}">
                            </div>
                            <div class="col-md-2 d-flex align-items-end">
                                <button type="submit" class="btn btn-outline-primary me-2">
                                    <i class="fas fa-search"></i>
                                </button>
                                <a href="${pageContext.request.contextPath}/admin-users" class="btn btn-outline-secondary">
                                    <i class="fas fa-times"></i>
                                </a>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- Users Table -->
                <div class="card">
                    <div class="card-header">
                        <h5 class="card-title mb-0">
                            <i class="fas fa-list me-2"></i>
                            Danh sách người dùng
                            <c:if test="${not empty searchResults}">
                                - Kết quả tìm kiếm: "${searchKeyword}"
                            </c:if>
                        </h5>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-striped table-hover" id="usersTable">
                                <thead class="table-dark">
                                    <tr>
                                        <th>ID</th>
                                        <th>Avatar</th>
                                        <th>Tên đăng nhập</th>
                                        <th>Họ tên</th>
                                        <th>Email</th>
                                        <th>Số điện thoại</th>
                                        <th>Vai trò</th>
                                        <th>Trạng thái</th>
                                        <th>Ngày tạo</th>
                                        <th>Lần đăng nhập cuối</th>
                                        <th>Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="user" items="${users}">
                                        <tr>
                                            <td>${user.userId}</td>
                                            <td>                                                <c:choose>
                                                    <c:when test="${not empty user.avatar}">
                                                        <c:choose>
                                                            <c:when test="${fn:startsWith(user.avatar, 'http')}">
                                                                <img src="${user.avatar}" alt="Avatar" class="user-avatar" onerror="this.style.display='none';this.parentNode.innerHTML='<i class=&#39;fas fa-user text-white&#39;></i>';">
                                                            </c:when>
                                                            <c:otherwise>
                                                                <img src="${pageContext.request.contextPath}/uploads/avatars/${user.avatar}" alt="Avatar" class="user-avatar" onerror="this.style.display='none';this.parentNode.innerHTML='<i class=&#39;fas fa-user text-white&#39;></i>';">
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div class="user-avatar bg-secondary d-flex align-items-center justify-content-center">
                                                            <i class="fas fa-user text-white"></i>
                                                        </div>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                ${user.username}
                                                <c:if test="${not empty user.googleId}">
                                                    <i class="fab fa-google text-danger ms-1" title="Đăng nhập Google"></i>
                                                </c:if>
                                            </td>
                                            <td>${user.fullName}</td>
                                            <td>${user.email}</td>
                                            <td>${user.phone}</td>
                                            <td>
                                                <span class="badge role-badge ${user.role == 'admin' ? 'bg-danger' : 'bg-primary'}">
                                                    ${user.role == 'admin' ? 'Admin' : 'Customer'}
                                                </span>
                                            </td>
                                            <td>
                                                <span class="badge status-badge ${user.status == 'active' ? 'bg-success' : 'bg-warning'}">
                                                    ${user.status == 'active' ? 'Hoạt động' : 'Không hoạt động'}
                                                </span>
                                            </td>
                                            <td>
                                                <fmt:formatDate value="${user.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty user.lastLogin}">
                                                        <fmt:formatDate value="${user.lastLogin}" pattern="dd/MM/yyyy HH:mm"/>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted">Chưa đăng nhập</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <div class="btn-group" role="group">
                                                    <a href="${pageContext.request.contextPath}/admin-users?action=view&id=${user.userId}" 
                                                       class="btn btn-sm btn-outline-info" title="Xem chi tiết">
                                                        <i class="fas fa-eye"></i>
                                                    </a>
                                                    <a href="${pageContext.request.contextPath}/admin-users?action=edit&id=${user.userId}" 
                                                       class="btn btn-sm btn-outline-primary" title="Chỉnh sửa">
                                                        <i class="fas fa-edit"></i>
                                                    </a>                                                    <c:if test="${user.userId != sessionScope.user.userId}">
                                                        <c:choose>
                                                            <c:when test="${user.status == 'active'}">
                                                                <button type="button" class="btn btn-sm btn-outline-warning" 
                                                                        onclick="updateUserStatus(<c:out value='${user.userId}'/>, 'inactive')" title="Vô hiệu hóa">
                                                                    <i class="fas fa-ban"></i>
                                                                </button>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <button type="button" class="btn btn-sm btn-outline-success" 
                                                                        onclick="updateUserStatus(<c:out value='${user.userId}'/>, 'active')" title="Kích hoạt">
                                                                    <i class="fas fa-check"></i>
                                                                </button>
                                                            </c:otherwise>
                                                        </c:choose>
                                                        <button type="button" class="btn btn-sm btn-outline-danger" 
                                                                onclick="deleteUser(<c:out value='${user.userId}'/>)" title="Xóa">
                                                            <i class="fas fa-trash"></i>
                                                        </button>
                                                    </c:if>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>

                        <!-- Pagination -->
                        <c:if test="${totalPages > 1 and empty searchResults}">
                            <nav aria-label="User pagination">
                                <ul class="pagination justify-content-center">
                                    <c:if test="${currentPage > 1}">
                                        <li class="page-item">
                                            <a class="page-link" href="?page=${currentPage - 1}&pageSize=${pageSize}">Previous</a>
                                        </li>
                                    </c:if>
                                    
                                    <c:forEach begin="1" end="${totalPages}" var="page">
                                        <li class="page-item ${page == currentPage ? 'active' : ''}">
                                            <a class="page-link" href="?page=${page}&pageSize=${pageSize}">${page}</a>
                                        </li>
                                    </c:forEach>
                                    
                                    <c:if test="${currentPage < totalPages}">
                                        <li class="page-item">
                                            <a class="page-link" href="?page=${currentPage + 1}&pageSize=${pageSize}">Next</a>
                                        </li>
                                    </c:if>
                                </ul>
                            </nav>
                        </c:if>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <!-- Create User Modal -->
    <div class="modal fade" id="createUserModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Thêm người dùng mới</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form method="POST" action="${pageContext.request.contextPath}/admin-users">
                    <input type="hidden" name="action" value="create">
                    <div class="modal-body">
                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="username" class="form-label">Tên đăng nhập <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" id="username" name="username" required>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="email" class="form-label">Email <span class="text-danger">*</span></label>
                                    <input type="email" class="form-control" id="email" name="email" required>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="password" class="form-label">Mật khẩu <span class="text-danger">*</span></label>
                                    <input type="password" class="form-control" id="password" name="password" required>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="phone" class="form-label">Số điện thoại</label>
                                    <input type="tel" class="form-control" id="phone" name="phone">
                                </div>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label for="fullName" class="form-label">Họ tên <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" id="fullName" name="fullName" required>
                        </div>
                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="role" class="form-label">Vai trò</label>
                                    <select class="form-select" id="role" name="role">
                                        <option value="customer">Customer</option>
                                        <option value="admin">Admin</option>
                                    </select>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="status" class="form-label">Trạng thái</label>
                                    <select class="form-select" id="status" name="status">
                                        <option value="active">Hoạt động</option>
                                        <option value="inactive">Không hoạt động</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label for="avatar" class="form-label">URL Avatar</label>
                            <input type="url" class="form-control" id="avatar" name="avatar">
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn btn-primary">Tạo người dùng</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.4/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.4/js/dataTables.bootstrap5.min.js"></script>
    
    <script>
        $(document).ready(function() {
            // Initialize DataTable
            $('#usersTable').DataTable({
                "pageLength": 10,
                "searching": false,
                "lengthChange": false,
                "info": false,
                "paging": false,
                "columnDefs": [
                    { "orderable": false, "targets": [1, 10] }
                ]
            });
        });

        function updateUserStatus(userId, status) {
            if (confirm('Bạn có chắc chắn muốn thay đổi trạng thái người dùng này?')) {
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = '${pageContext.request.contextPath}/admin-users';
                
                const actionInput = document.createElement('input');
                actionInput.type = 'hidden';
                actionInput.name = 'action';
                actionInput.value = 'updateStatus';
                
                const userIdInput = document.createElement('input');
                userIdInput.type = 'hidden';
                userIdInput.name = 'userId';
                userIdInput.value = userId;
                
                const statusInput = document.createElement('input');
                statusInput.type = 'hidden';
                statusInput.name = 'status';
                statusInput.value = status;
                
                form.appendChild(actionInput);
                form.appendChild(userIdInput);
                form.appendChild(statusInput);
                
                document.body.appendChild(form);
                form.submit();
            }
        }

        function deleteUser(userId) {
            if (confirm('Bạn có chắc chắn muốn xóa người dùng này? Thao tác này có thể được hoàn tác.')) {
                window.location.href = '${pageContext.request.contextPath}/admin-users?action=delete&id=' + userId;
            }
        }

        // Auto-hide alerts after 5 seconds
        setTimeout(function() {
            $('.alert').fadeOut();
        }, 5000);
    </script>
</body>
</html>
