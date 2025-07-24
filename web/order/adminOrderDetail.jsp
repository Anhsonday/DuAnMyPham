<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<style>
body {
    background: #ede7f6;
    margin: 0;
    padding: 0;
    font-family: 'Nunito', 'Segoe UI', Arial, sans-serif;
}
.admin-order-detail-container {
    background: #fff;
    border-radius: 28px;
    box-shadow: 0 8px 32px rgba(80,60,180,0.18);
    max-width: 700px;
    margin: 40px auto 32px auto;
    padding: 36px 32px 32px 32px;
    display: flex;
    flex-direction: column;
    align-items: center;
}
.admin-order-detail-title {
    color: #5f3dc4;
    font-weight: 900;
    font-size: 1.6rem;
    margin-bottom: 18px;
    letter-spacing: 1px;
    text-align: center;
}
.admin-order-detail-info {
    width: 100%;
    margin-bottom: 18px;
    font-size: 1.08rem;
}
.admin-order-detail-info b {
    color: #333;
    font-weight: 700;
}
.admin-order-detail-badge {
    display: inline-block;
    border-radius: 10px;
    padding: 6px 18px;
    font-size: 1rem;
    font-weight: 700;
    margin-left: 8px;
}
.badge-pending { background: #fff3cd; color: #ff9800; }
.badge-shipped { background: #e3f2fd; color: #1976d2; }
.badge-delivered { background: #c8e6c9; color: #388e3c; }
.badge-returned { background: #ede7f6; color: #7c43bd; }
.badge-refunded { background: #ede7f6; color: #388e3c; }
.badge-cancelled { background: #ffcdd2; color: #d32f2f; }
.admin-order-detail-table {
    width: 100%;
    border-radius: 16px;
    overflow: hidden;
    box-shadow: 0 2px 8px rgba(80,60,180,0.07);
    margin-bottom: 24px;
    background: #f8f6fc;
}
.admin-order-detail-table th {
    background: linear-gradient(90deg, #7c43bd 0%, #667eea 100%);
    color: #fff;
    font-weight: 800;
    padding: 8px 0;
    font-size: 1.05rem;
    border-bottom: 2px solid #b39ddb;
    letter-spacing: 0.5px;
}
.admin-order-detail-table td {
    padding: 7px 6px;
    font-size: 1.02rem;
    text-align: center;
    background: #fff;
    position: relative;
}
.admin-order-detail-table .btn {
    position: relative;
    z-index: 1;
}
.admin-order-detail-table .btn .fa {
    pointer-events: none;
}
.admin-order-detail-table .btn:hover::after, .admin-order-detail-table .btn:focus::after {
    content: attr(data-tooltip);
    position: absolute;
    left: 50%;
    bottom: 110%;
    top: auto;
    transform: translateX(-50%);
    background: #222;
    color: #fff;
    font-size: 0.92rem;
    padding: 3px 8px;
    border-radius: 8px;
    white-space: nowrap;
    z-index: 10;
    opacity: 0.95;
    pointer-events: none;
    box-shadow: 0 2px 8px rgba(0,0,0,0.12);
    transition: opacity 0.15s;
}
.badge-deleted {
    background: #e0e0e0;
    color: #888;
    border-radius: 8px;
    padding: 5px 14px;
    font-size: 0.98rem;
    font-weight: 700;
    display: inline-block;
}
.admin-order-detail-total {
    text-align: right;
    font-size: 1.15rem;
    font-weight: 800;
    color: #5f3dc4;
    margin-top: 10px;
}
.admin-order-detail-actions {
    display: flex;
    gap: 12px;
    justify-content: center;
    margin-top: 18px;
}
.admin-order-detail-actions form, .admin-order-detail-actions a {
    display: inline-block;
    margin: 0;
}
.admin-order-detail-actions .btn {
    min-width: 38px;
    width: 38px;
    height: 38px;
    font-size: 1.1rem;
    padding: 0;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    text-align: center;
    border: none;
    margin: 0 2px;
    transition: filter 0.15s;
}
.btn-view { background: #7c43bd; color: #fff; }
.btn-cancel { background: #d32f2f; color: #fff; }
.btn-refund { background: #29b6f6; color: #fff; }
.btn-confirm { background: #43a047; color: #fff; }
.btn-approve { background: #ff9800; color: #fff; }
.admin-order-detail-actions .btn:hover { filter: brightness(0.92); }
.admin-order-detail-actions .btn .fa { margin: 0; font-size: 1.1em; display: inline-block; vertical-align: middle; }
.admin-order-detail-actions .btn span { display: none; }
.admin-order-detail-actions .btn:hover::after {
    content: attr(data-tooltip);
    position: absolute;
    left: 50%;
    bottom: 110%;
    top: auto;
    transform: translateX(-50%);
    background: #222;
    color: #fff;
    font-size: 0.92rem;
    padding: 3px 8px;
    border-radius: 8px;
    white-space: nowrap;
    z-index: 10;
    opacity: 0.95;
    pointer-events: none;
    box-shadow: 0 2px 8px rgba(0,0,0,0.12);
    transition: opacity 0.15s;
}
</style>
<div class="admin-order-detail-container">
    <div class="admin-order-detail-title">
        <i class="fa fa-file-text-o"></i> Chi tiết đơn hàng (Admin) #${order.orderNumber}
    </div>
    <div class="admin-order-detail-info">
        <b>Khách hàng:</b> ${order.user.username} <br/>
        <b>Trạng thái:</b> <span class="admin-order-detail-badge badge-${order.status}">
            <c:choose>
                <c:when test="${order.status == 'pending'}">Chờ xử lý</c:when>
                <c:when test="${order.status == 'shipped'}">Đã vận chuyển</c:when>
                <c:when test="${order.status == 'delivered'}">Đã giao</c:when>
                <c:when test="${order.status == 'returned'}">Hoàn trả</c:when>
                <c:when test="${order.status == 'refunded'}">Hoàn tiền</c:when>
                <c:when test="${order.status == 'cancelled'}">Đã hủy</c:when>
                <c:otherwise>${order.status}</c:otherwise>
            </c:choose>
        </span><br/>
        <b>Ngày đặt:</b> <fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy HH:mm"/><br/>
        <b>Địa chỉ giao hàng:</b> ${order.shippingAddress.fullAddress}<br/>
        <b>Phương thức thanh toán:</b> ${order.paymentMethod.methodName}
    </div>
    <table class="admin-order-detail-table">
        <thead>
            <tr>
                <th>#</th>
                <th>Sản phẩm</th>
                <th>Đơn giá</th>
                <th>Số lượng</th>
                <th>Thành tiền</th>
                <th>Hành động</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="item" items="${orderItems}" varStatus="stt">
                <tr>
                    <td>${stt.index + 1}</td>
                    <td>${item.productName}</td>
                    <td><fmt:formatNumber value="${item.unitPrice}" type="number" groupingUsed="true"/> ₫</td>
                    <td>${item.quantity}</td>
                    <td><fmt:formatNumber value="${item.subtotal}" type="number" groupingUsed="true"/> ₫</td>
                    <td>
                        <c:choose>
                            <c:when test="${item.isDeleted}">
                                <span class="badge-deleted">Đã xóa</span>
                            </c:when>
                            <c:otherwise>
                                <form action="manageOrders" method="post" style="display:inline;">
                                    <input type="hidden" name="action" value="deleteItem"/>
                                    <input type="hidden" name="orderItemID" value="${item.orderItemId}"/>
                                    <input type="hidden" name="orderID" value="${order.orderID}"/>
                                    <button type="submit" class="btn btn-cancel" data-tooltip="Xóa sản phẩm" onclick="return confirm('Xóa sản phẩm này khỏi đơn hàng?')">
                                        <i class="fa fa-trash"></i>
                                    </button>
                                </form>
                            </c:otherwise>
                        </c:choose>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
    <div class="admin-order-detail-total">
        Tổng tiền: <fmt:formatNumber value="${order.finalAmount}" type="number" groupingUsed="true"/> ₫
    </div>
    <div class="admin-order-detail-actions">
        <a href="manageOrders" class="btn btn-view" data-tooltip="Quay lại"><i class="fa fa-arrow-left"></i></a>
        <c:if test="${order.status != 'refunded' && order.status != 'cancelled'}">
            <form action="manageOrders" method="post" style="display:inline;">
                <input type="hidden" name="action" value="cancel"/>
                <input type="hidden" name="orderID" value="${order.orderID}"/>
                <button type="submit" class="btn btn-cancel" data-tooltip="Hủy đơn hàng"><i class="fa fa-times"></i></button>
            </form>
            <form action="manageOrders" method="post" style="display:inline;">
                <input type="hidden" name="action" value="refund"/>
                <input type="hidden" name="orderID" value="${order.orderID}"/>
                <button type="submit" class="btn btn-refund" data-tooltip="Hoàn tiền"><i class="fa fa-money"></i></button>
            </form>
        </c:if>
        <c:choose>
            <c:when test="${order.status == 'pending'}">
                <form action="manageOrders" method="post" style="display:inline;">
                    <input type="hidden" name="action" value="confirm"/>
                    <input type="hidden" name="orderID" value="${order.orderID}"/>
                    <button type="submit" class="btn btn-confirm" data-tooltip="Xác nhận giao hàng"><i class="fa fa-truck"></i></button>
                </form>
            </c:when>
            <c:when test="${order.status == 'refunded'}">
                <form action="manageOrders" method="post" style="display:inline;">
                    <input type="hidden" name="action" value="confirmRefunded"/>
                    <input type="hidden" name="orderID" value="${order.orderID}"/>
                    <button type="submit" class="btn btn-confirm" data-tooltip="Xác nhận đã hoàn tiền"><i class="fa fa-check"></i></button>
                </form>
            </c:when>
            <c:when test="${order.status == 'returned'}">
                <form action="manageOrders" method="post" style="display:inline;">
                    <input type="hidden" name="action" value="approveReturn"/>
                    <input type="hidden" name="orderID" value="${order.orderID}"/>
                    <button type="submit" class="btn btn-approve" data-tooltip="Duyệt hoàn trả"><i class="fa fa-check"></i></button>
                </form>
            </c:when>
        </c:choose>
    </div>
</div> 