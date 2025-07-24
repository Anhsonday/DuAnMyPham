<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!-- Bootstrap & Icons -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">

<style>
:root {
  --color-primary: #6f42c1;
  --color-secondary: #4886e5;
  --color-bg-main: #f3f6fd;
  --color-bg-table: #ffffff;
  --color-shadow: rgba(80,60,180,0.12);
}

body {
    background: linear-gradient(125deg, var(--color-bg-main) 65%, #ede7f6 100%);
    font-family: 'Segoe UI', 'Roboto', Arial, sans-serif;
    margin: 0;
    padding: 0;
    min-height: 100vh;
}

.main-content-admin {
    margin-left: 240px;
    min-height: 100vh;
    background: none;
    padding: 24px 0 64px 0;
}

.order-admin-container {
    background: var(--color-bg-table);
    border-radius: 28px;
    box-shadow: 0 8px 32px var(--color-shadow);
    max-width: 1420px;
    margin: 0 auto;
    padding: 0 0 32px 0;
}

.order-admin-header-bg {
    width: 100%;
    background: linear-gradient(100deg, #ede7f6 80%, #fff 100%);
    border-radius: 28px 28px 0 0;
    padding: 18px 0 0 0;
    margin-bottom: 0;
    display: flex;
    flex-direction: column;
    align-items: center;
    position: relative;
}
.order-admin-title {
    font-weight: bold;
    color: var(--color-primary);
    font-size: 2rem;
    letter-spacing: 1px;
    gap: 16px;
    margin-bottom: 18px;
    display: flex;
    align-items: center;
}
.order-admin-title .fa, .order-admin-title .bi {
    color: var(--color-secondary);
    font-size: 2.3rem;
}

.order-admin-tabs {
    display: flex;
    flex-wrap: wrap;
    justify-content: center;
    gap: 10px;
    margin-bottom: 18px;
    background: #e3eafc;
    border-radius: 18px;
    padding: 12px;
}
.order-admin-tab {
    font-weight: 700;
    padding: 9px 26px;
    border-radius: 22px;
    font-size: 1rem;
    background: #e3eafc;
    border: 2px solid transparent;
    color: var(--color-primary);
    transition: all 0.2s;
    text-decoration: none;
}
.order-admin-tab.active, .order-admin-tab:hover {
    background: var(--color-secondary);
    color: #fff;
    border-color: var(--color-primary);
    box-shadow: 0 2px 12px 0 var(--color-shadow);
}

.order-admin-search {
    display: flex;
    flex-wrap: wrap;
    gap: 14px;
    align-items: center;
    justify-content: center;
    margin-bottom: 18px;
    margin-top: 5px;
}
.order-admin-search input, .order-admin-search select {
    padding: 8px 15px;
    border-radius: 7px;
    border: 1.5px solid #bbc7f3;
    font-size: 1.07rem;
    background: #f6f8fe;
    min-width: 190px;
}
.order-admin-search button {
    padding: 8px 22px;
    border-radius: 7px;
    background: var(--color-secondary);
    color: #fff;
    font-weight: bold;
    border: none;
    font-size: 1.07rem;
    transition: background 0.18s;
    box-shadow: 0 2px 12px rgba(80,60,180,0.08);
}
.order-admin-search button:hover {
    background: var(--color-primary);
}

.order-admin-table-wrapper {
  padding: 0 12px;
  overflow-x: auto;
}
.order-admin-table {
  background: var(--color-bg-table);
  border-radius: 27px;
  overflow: visible;
  font-size: 1.02rem;
  margin: 0 auto;
  min-width: 1080px;
  max-width: 1350px;
  box-shadow: 0 8px 32px var(--color-shadow);
}
.order-admin-table th, .order-admin-table td {
  text-align: center;
  vertical-align: middle;
}
.order-admin-table th {
  background: linear-gradient(90deg, var(--color-primary) 0%, var(--color-secondary) 100%);
  color: #fff;
  font-weight: 900;
  font-size: 1.06rem;
  border-bottom: 2.5px solid #b39ddb;
  letter-spacing: 0.9px;
  text-shadow: 0 2px 8px var(--color-shadow);
  padding: 10px 0;
}
.order-admin-table td {
  padding: 6px 4px;
  background: #faf7fe;
  font-size: 0.98rem;
  min-width: 80px;
  max-width: 260px;
  overflow-wrap: break-word;
}
.order-admin-table tr {
  transition: background 0.18s;
}
.order-admin-table tbody tr:hover {
  background: #ede7f6;
}

.badge {
  border-radius: 16px;
  padding: 10px 28px;
  font-size: 1.13rem;
  font-weight: 800;
  letter-spacing: 0.8px;
  min-width: 120px;
  display: inline-flex;
  align-items: center;
  gap: 7px;
  box-shadow: 0 2px 8px rgba(80,60,180,0.10);
}
.badge-warning { background: #fff3cd; color: #ff9800;}
.badge-info { background: #e3f2fd; color: #1976d2;}
.badge-success { background: #c8e6c9; color: #388e3c;}
.badge-danger { background: #ffcdd2; color: #d32f2f;}
.badge-returned { background: #ede7f6; color: #7c43bd;}

.order-admin-table .btn-group {
    display: flex;
    flex-direction: row;
    gap: 8px;
    align-items: center;
    justify-content: center;
    width: 100%;
}

.order-admin-table .btn {
    min-width: 40px;
    width: 40px;
    height: 40px;
    font-size: 1.1rem;
    padding: 0;
    border-radius: 50%;
    border: none;
    display: flex;
    align-items: center;
    justify-content: center;
    background-clip: padding-box;
    transition: all 0.16s;
    position: relative;
    overflow: visible;
}
.btn-view    { background: #6f42c1; color: #fff; }
.btn-cancel  { background: #d32f2f; color: #fff; }
.btn-refund  { background: #29b6f6; color: #fff; }
.btn-confirm { background: #43a047; color: #fff; }
.btn-approve { background: #ff9800; color: #fff; }
.btn-hidden  { opacity: 0; pointer-events: none; }

.order-admin-table .btn:hover,
.order-admin-table .btn:focus {
    filter: brightness(0.91);
    box-shadow: 0 2px 8px var(--color-shadow), 0 0 0 3px #bbaaff30;
}

@media (max-width: 1400px) {
    .order-admin-table { min-width: 800px; }
}
@media (max-width: 1100px) {
    .order-admin-table { min-width: 600px; }
    .order-admin-title { font-size: 1.6rem; }
}
@media (max-width: 900px) {
    .main-content-admin { padding: 18px 1px; }
    .order-admin-title { font-size: 1.19rem; }
    .order-admin-table th, .order-admin-table td { font-size: 0.99rem; padding: 7px 2px; }
    .order-admin-table { min-width: 300px; }
}
@media (max-width: 600px) {
    .main-content-admin { padding: 8px 0; }
    .order-admin-title { font-size: 1.05rem; }
    .order-admin-table th, .order-admin-table td { font-size: 0.92rem; padding: 5px 1px; }
    .order-admin-table .btn { min-width: 36px; font-size: 0.93rem; }
    .order-admin-table { min-width: 280px; }
}

/* Fix Bootstrap tooltip không bị che chữ và tràn ra ngoài */
.tooltip {
  z-index: 9999 !important;
  font-size: 1rem;
  font-weight: 500;
}
</style>

<!-- Sidebar -->
<jsp:include page="/admin/includes/sidebar.jsp">
    <jsp:param name="page" value="orders" />
</jsp:include>

<div class="main-content-admin">
  <div class="order-admin-container">
    <div class="order-admin-header-bg">
      <span class="order-admin-title">
        <i class="fa fa-list-alt"></i> Quản lý đơn hàng
      </span>
      <div class="order-admin-tabs">
        <c:forEach var="s" items="${fn:split('all,pending,confirmed,shipping,delivered,returned,refunded,cancelled', ',')}">
          <a href="manageOrders?tab=${s}" class="order-admin-tab${tab == s ? ' active' : ''}">
            <c:choose>
              <c:when test="${s == 'all'}">Tất cả</c:when>
              <c:when test="${s == 'pending'}">Chờ xử lý</c:when>
              <c:when test="${s == 'confirmed'}">Đã xác nhận</c:when>
              <c:when test="${s == 'shipping'}">Đã vận chuyển</c:when>
              <c:when test="${s == 'delivered'}">Đã giao</c:when>
              <c:when test="${s == 'returned'}">Hoàn trả</c:when>
              <c:when test="${s == 'refunded'}">Hoàn tiền</c:when>
              <c:when test="${s == 'cancelled'}">Đã hủy</c:when>
            </c:choose>
          </a>
        </c:forEach>
      </div>
      <form class="order-admin-search" method="get" action="manageOrders">
        <input type="hidden" name="tab" value="${tab}"/>
        <input type="text" name="q" placeholder="Tìm kiếm mã đơn, khách hàng..." value="${param.q}"/>
        <select name="sort">
          <option value="createdAt_desc" ${param.sort == 'createdAt_desc' ? 'selected' : ''}>Mới nhất</option>
          <option value="createdAt_asc"  ${param.sort == 'createdAt_asc'  ? 'selected' : ''}>Cũ nhất</option>
          <option value="amount_desc"    ${param.sort == 'amount_desc'    ? 'selected' : ''}>Tổng tiền cao</option>
          <option value="amount_asc"     ${param.sort == 'amount_asc'     ? 'selected' : ''}>Tổng tiền thấp</option>
        </select>
        <button type="submit"><i class="fa fa-search"></i> Tìm kiếm</button>
      </form>
    </div>

    <c:if test="${not empty errorMsg}">
      <div class="alert alert-danger text-center mt-3">${errorMsg}</div>
    </c:if>
    <c:if test="${not empty successMsg}">
      <div class="alert alert-success text-center mt-3">${successMsg}</div>
    </c:if>

    <div class="order-admin-table-wrapper">
      <table class="table table-bordered table-hover order-admin-table align-middle">
        <thead>
          <tr>
            <th style="width: 13%;">Mã đơn</th>
            <th style="width: 17%;">Khách hàng</th>
            <th style="width: 18%;">Ngày đặt</th>
            <th style="width: 16%;">Trạng thái</th>
            <th style="width: 16%;">Tổng tiền</th>
            <th style="width: 20%;">Thao tác</th>
          </tr>
        </thead>
        <tbody>
  <c:forEach var="order" items="${orders}">
    <c:if test="${tab == 'all' || fn:toLowerCase(order.status) == fn:toLowerCase(tab)}">
      <tr>
        <td style="font-weight: bold;"><c:out value="${order.orderNumber}"/></td>
        <td>
          <c:choose>
            <c:when test="${not empty order.user}"><c:out value="${order.user.username}"/></c:when>
            <c:otherwise><i>Không có user</i></c:otherwise>
          </c:choose>
        </td>
        <td>
          <c:choose>
            <c:when test="${not empty order.createdAt}">
              <fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
            </c:when>
            <c:otherwise><i>Không có ngày</i></c:otherwise>
          </c:choose>
        </td>
        <td>
          <c:choose>
            <c:when test="${order.status == 'pending'}">
              <span class="badge badge-warning">
                  <i class="fas fa-clock"></i> Chờ xử lý
              </span>
            </c:when>
            <c:when test="${order.status == 'confirmed'}">
              <span class="badge badge-info">
                  <i class="fas fa-check"></i> Đã xác nhận
              </span>
            </c:when>
            <c:when test="${order.status == 'shipping'}">
              <span class="badge badge-info">
                  <i class="fas fa-truck"></i> Đã vận chuyển
              </span>
            </c:when>
            <c:when test="${order.status == 'delivered'}">
              <span class="badge badge-success">
                  <i class="fas fa-check-circle"></i> Đã giao
              </span>
            </c:when>
            <c:when test="${order.status == 'returned'}">
              <span class="badge badge-returned">
                  <i class="fas fa-undo"></i> Hoàn trả
              </span>
            </c:when>
            <c:when test="${order.status == 'refunded'}">
              <span class="badge badge-success">
                  <i class="fas fa-money-bill-wave"></i> Đã hoàn tiền
              </span>
            </c:when>
            <c:when test="${order.status == 'cancelled'}">
              <span class="badge badge-danger">
                  <i class="fas fa-times-circle"></i> Đã hủy
              </span>
            </c:when>
            <c:otherwise>
              <span class="badge badge-info"><c:out value="${order.status}"/></span>
            </c:otherwise>
          </c:choose>
        </td>
        <td>
          <c:choose>
            <c:when test="${not empty order.finalAmount}">
              <c:set var="amountFormatted">
                <fmt:formatNumber value="${order.finalAmount}" type="number" groupingUsed="true" />
              </c:set>
              ${amountFormatted}đ
              <!-- Nếu muốn thay dấu phân cách chấm sang phẩy: 
              ${fn:replace(amountFormatted, '.', ',')}đ 
              -->
            </c:when>
            <c:otherwise><i>Không có số tiền</i></c:otherwise>
          </c:choose>
        </td>
        <td>
          <div class="btn-group">
            <!-- Nút Xem -->
            <a href="manageOrders?action=detail&orderID=${order.orderID}" class="btn btn-view" data-bs-toggle="tooltip" title="Xem chi tiết đơn hàng">
              <i class="fa fa-eye"></i>
            </a>
            <!-- Nút Hủy -->
            <c:choose>
              <c:when test="${order.status != 'refunded' && order.status != 'cancelled'}">
                <form action="manageOrders" method="post" style="display:inline;">
                  <input type="hidden" name="action" value="cancel"/>
                  <input type="hidden" name="orderID" value="${order.orderID}"/>
                  <button type="submit" class="btn btn-cancel" data-bs-toggle="tooltip" title="Hủy đơn hàng" onclick="return confirm('Bạn có chắc chắn muốn hủy đơn hàng này?');">
                    <i class="fa fa-times"></i>
                  </button>
                </form>
              </c:when>
              <c:otherwise>
                <button class="btn btn-cancel btn-hidden" disabled><i class="fa fa-times"></i></button>
              </c:otherwise>
            </c:choose>
            <!-- Nút Hoàn tiền -->
            <c:choose>
              <c:when test="${order.status != 'refunded' && order.status != 'cancelled'}">
                <form action="manageOrders" method="post" style="display:inline;">
                  <input type="hidden" name="action" value="refund"/>
                  <input type="hidden" name="orderID" value="${order.orderID}"/>
                  <button type="submit" class="btn btn-refund" data-bs-toggle="tooltip" title="Hoàn tiền" onclick="return confirm('Bạn có chắc chắn muốn hoàn tiền cho đơn hàng này?');">
                    <i class="fa fa-money-bill-wave"></i>
                  </button>
                </form>
              </c:when>
              <c:otherwise>
                <button class="btn btn-refund btn-hidden" disabled><i class="fa fa-money-bill-wave"></i></button>
              </c:otherwise>
            </c:choose>
            <!-- Nút Xác nhận giao hàng -->
            <c:choose>
              <c:when test="${order.status == 'pending' || order.status == 'confirmed'}">
                <form action="manageOrders" method="post" style="display:inline;">
                  <input type="hidden" name="action" value="confirm"/>
                  <input type="hidden" name="orderID" value="${order.orderID}"/>
                  <button type="submit" class="btn btn-confirm" data-bs-toggle="tooltip" title="Xác nhận giao hàng" onclick="return confirm('Bạn có chắc chắn muốn giao đơn hàng này?');">
                    <i class="fa fa-truck"></i>
                  </button>
                </form>
              </c:when>
              <c:otherwise>
                <button class="btn btn-confirm btn-hidden" disabled><i class="fa fa-truck"></i></button>
              </c:otherwise>
            </c:choose>
            <!-- Nút Hoàn trả -->
            <c:choose>
              <c:when test="${order.status != 'returned' && order.status != 'refunded' && order.status != 'cancelled'}">
                <form action="manageOrders" method="post" style="display:inline;">
                  <input type="hidden" name="action" value="return"/>
                  <input type="hidden" name="orderID" value="${order.orderID}"/>
                  <button type="submit" class="btn btn-approve" data-bs-toggle="tooltip" title="Chuyển sang trạng thái hoàn trả" onclick="return confirm('Bạn có chắc chắn muốn chuyển đơn hàng này sang trạng thái hoàn trả?');">
                    <i class="fa fa-undo"></i>
                  </button>
                </form>
              </c:when>
              <c:otherwise>
                <button class="btn btn-approve btn-hidden" disabled><i class="fa fa-undo"></i></button>
              </c:otherwise>
            </c:choose>
          </div>
        </td>
      </tr>
    </c:if>
  </c:forEach>
</tbody>

      </table>
    </div>
    <c:if test="${totalPages > 1}">
        <nav aria-label="Page navigation" class="mt-4">
            <ul class="pagination justify-content-center">
                <c:forEach var="i" begin="1" end="${totalPages}">
                    <c:set var="pageTab" value="${empty tab ? 'all' : tab}" />
                    <li class="page-item ${i == currentPage ? 'active' : ''}">
                        <a class="page-link" href="manageOrders?tab=${pageTab}&q=${param.q}&sort=${param.sort}&page=${i}">${i}</a>
                    </li>
                </c:forEach>
            </ul>
        </nav>
    </c:if>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
  // Bootstrap tooltips
  document.addEventListener('DOMContentLoaded', function () {
    var tooltipList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
    tooltipList.forEach(function (tooltipTriggerEl) {
      new bootstrap.Tooltip(tooltipTriggerEl);
    });

    // Lưu vị trí cuộn trang
    window.addEventListener("beforeunload", function() {
      localStorage.setItem("adminOrderScroll", window.scrollY);
    });
    var scroll = localStorage.getItem("adminOrderScroll");
    if (scroll !== null) {
      window.scrollTo(0, parseInt(scroll));
    }
  });
</script>
