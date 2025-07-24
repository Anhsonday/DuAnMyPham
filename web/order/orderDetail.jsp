<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<html>
<head>
    <title>Chi tiết đơn hàng</title>
    <link rel="stylesheet" href="../assets/css/bootstrap.min.css"/>
    <style>
        body {
            background: linear-gradient(135deg, #ede7f6 0%, #f3f6fd 100%);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0; padding: 0;
            min-height: 100vh;
            color: #333;
        }

        .order-detail-container {
            max-width: 860px;
            margin: 48px auto;
            background: #fff;
            border-radius: 28px;
            box-shadow: 0 14px 35px rgba(80, 60, 180, 0.18);
            padding: 40px 48px 48px;
            box-sizing: border-box;
        }

        .order-detail-title {
            font-weight: 900;
            font-size: 2.4rem;
            color: #6f42c1;
            text-align: center;
            margin-bottom: 32px;
            letter-spacing: 1.3px;
            text-shadow: 0 2px 12px rgba(127, 86, 195, 0.4);
        }

        .order-detail-info {
            font-size: 1.1rem;
            line-height: 1.6;
            margin-bottom: 28px;
            color: #444;
        }
        .order-detail-info b {
            color: #3a2e6f;
            font-weight: 700;
        }

        .badge-status {
            border-radius: 14px;
            padding: 8px 22px;
            font-size: 1rem;
            font-weight: 700;
            box-shadow: 0 3px 10px rgba(111, 66, 193, 0.18);
            display: inline-block;
            min-width: 132px;
            text-align: center;
        }
        .badge-pending { background: #fff3cd; color: #ff9800; }
        .badge-confirmed { background: #e3f2fd; color: #1976d2; }
        .badge-shipping { background: #e3f2fd; color: #1976d2; }
        .badge-delivered { background: #c8e6c9; color: #388e3c; }
        .badge-returned { background: #ede7f6; color: #7c43bd; }
        .badge-refunded { background: #ede7f6; color: #388e3c; }
        .badge-cancelled { background: #ffcdd2; color: #d32f2f; }

        table.order-detail-table {
            width: 100%;
            border-radius: 14px;
            border-collapse: separate;
            border-spacing: 0;
            overflow: hidden;
            background: #f8f6fc;
            box-shadow: 0 5px 14px rgba(80, 60, 180, 0.12);
            margin-bottom: 28px;
        }
        table.order-detail-table th {
            background: linear-gradient(90deg, #7c43bd 0%, #667eea 100%);
            color: #fff;
            font-weight: 800;
            padding: 12px 0;
            font-size: 1.08rem;
            text-align: center;
            box-shadow: inset 0 -3px 10px rgba(0,0,0,0.1);
        }
        table.order-detail-table td {
            background: #fff;
            padding: 14px 10px;
            font-size: 1.03rem;
            text-align: center;
            border-bottom: 1px solid #dcd6e2;
            vertical-align: middle;
            word-break: break-word;
        }
        table.order-detail-table tr:last-child td {
            border-bottom: none;
        }

        .order-detail-total {
            text-align: right;
            font-size: 1.28rem;
            font-weight: 900;
            color: #6f42c1;
            letter-spacing: 0.9px;
            margin-top: -10px;
            padding-bottom: 10px;
            border-bottom: 3.5px solid #7c43bd;
        }

        .order-detail-actions {
            display: flex;
            gap: 14px;
            justify-content: center;
            margin-top: 34px;
            flex-wrap: wrap;
        }
        .order-detail-actions form, .order-detail-actions a {
            margin: 0;
            display: inline-block;
        }

        .order-detail-actions .btn {
            min-width: auto;
            width: auto;
            height: 42px;
            font-size: 1.1rem;
            padding: 0 14px;
            border-radius: 28px;
            color: #fff;
            border: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            box-shadow: 0 3px 14px rgba(111, 66, 193, 0.4);
            transition: filter 0.2s cubic-bezier(0.77, 0, 0.175, 1);
            gap: 8px;
            white-space: nowrap;
        }
        .btn-view { background: #7c43bd; }
        .btn-cancel { background: #d32f2f; }
        .btn-refund { background: #29b6f6; }
        .btn-confirm { background: #43a047; }
        .btn-approve { background: #ff9800; }

        .order-detail-actions .btn:hover {
            filter: brightness(0.9);
            box-shadow: 0 4px 20px rgba(111, 66, 193, 0.6);
            text-decoration: none;
            color: #fff;
        }
        .order-detail-actions .btn i {
            font-size: 1.4rem;
        }

        /* Responsive */
        @media (max-width: 720px) {
            .order-detail-container {
                padding: 28px 24px 32px;
                max-width: 95vw;
            }
            .order-detail-title {
                font-size: 1.9rem;
            }
            .order-detail-info {
                font-size: 1rem;
                margin-bottom: 22px;
            }
            table.order-detail-table th,
            table.order-detail-table td {
                font-size: 0.92rem;
                padding: 10px 6px;
            }
            .order-detail-total {
                font-size: 1.12rem;
            }
            .order-detail-actions {
                gap: 10px;
            }
            .order-detail-actions .btn {
                height: 38px;
                font-size: 1rem;
                padding: 0 12px;
            }
            .order-detail-actions .btn i {
                font-size: 1.1rem;
            }
        }
    </style>
</head>
<body>
<div class="order-detail-container">
    <div class="order-detail-title">Chi tiết đơn hàng #${order.orderNumber}</div>
    <div class="order-detail-info">
        <b>Khách hàng:</b> ${order.user.username} <br/>
        <b>Trạng thái:</b>
        <span class="badge-status badge-${order.status}">
            <c:choose>
                <c:when test="${order.status == 'pending'}">Chờ xử lý</c:when>
                <c:when test="${order.status == 'confirmed'}">Đã xác nhận</c:when>
                <c:when test="${order.status == 'shipping'}">Đang giao</c:when>
                <c:when test="${order.status == 'delivered'}">Đã giao</c:when>
                <c:when test="${order.status == 'returned'}">Hoàn trả</c:when>
                <c:when test="${order.status == 'refunded'}">Hoàn tiền</c:when>
                <c:when test="${order.status == 'cancelled'}">Đã hủy</c:when>
                <c:otherwise><c:out value="${order.status}"/></c:otherwise>
            </c:choose>
        </span> <br/>
        <b>Ngày đặt:</b> <fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy HH:mm"/><br/>
        <b>Địa chỉ giao hàng:</b> ${order.shippingAddress.fullAddress}<br/>
        <b>Phương thức thanh toán:</b> ${order.paymentMethod.methodName}
    </div>

    <table class="order-detail-table table table-bordered">
        <thead>
            <tr>
                <th>#</th>
                <th>Sản phẩm</th>
                <th>Đơn giá</th>
                <th>Số lượng</th>
                <th>Thành tiền</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="item" items="${orderItems}" varStatus="status">
                <tr>
                    <td>${status.index + 1}</td>
                    <td>${item.productName}</td>
                    <td><fmt:formatNumber value="${item.unitPrice}" type="number" groupingUsed="true"/>đ</td>
                    <td>${item.quantity}</td>
                    <td><fmt:formatNumber value="${item.subtotal}" type="number" groupingUsed="true"/>đ</td>
                </tr>
            </c:forEach>
        </tbody>
    </table>

    <div class="order-detail-total">
        Tổng tiền: <fmt:formatNumber value="${order.finalAmount}" type="number" groupingUsed="true"/>đ
    </div>

    <div class="order-detail-actions">
        <a href="orders" class="btn btn-view" title="Quay lại">
            <i class="fa fa-arrow-left"></i> Quay lại
        </a>
        <c:if test="${order.status == 'pending'}">
            <form method="post" action="orders" style="display:inline;">
                <input type="hidden" name="action" value="cancel"/>
                <input type="hidden" name="orderID" value="${order.orderID}"/>
                <button type="submit" class="btn btn-cancel" title="Hủy đơn hàng"><i class="fa fa-times"></i> Hủy</button>
            </form>
        </c:if>
        <c:if test="${order.status == 'shipping' || order.status == 'confirmed'}">
            <form method="post" action="orders" style="display:inline;">
                <input type="hidden" name="action" value="delivered"/>
                <input type="hidden" name="orderID" value="${order.orderID}"/>
                <button type="submit" class="btn btn-confirm" title="Đã nhận hàng"><i class="fa fa-check"></i> Xác nhận</button>
            </form>
        </c:if>
        <c:if test="${order.status == 'delivered'}">
            <form method="post" action="orders" style="display:inline;">
                <input type="hidden" name="action" value="return"/>
                <input type="hidden" name="orderID" value="${order.orderID}"/>
                <input type="text" name="returnReason" placeholder="Lý do hoàn trả" required 
                       style="border-radius:6px; padding:6px 10px; margin-right:6px; max-width: 200px;"/>
                <button type="submit" class="btn btn-refund" title="Hoàn trả"><i class="fa fa-undo"></i> Hoàn trả</button>
            </form>
        </c:if>
    </div>

    <c:if test="${not empty errorMsg}">
        <div class="alert alert-danger text-center mt-4">${errorMsg}</div>
    </c:if>
    <c:if test="${not empty successMsg}">
        <div class="alert alert-success text-center mt-4">${successMsg}</div>
    </c:if>
</div>

<script src="https://kit.fontawesome.com/a2b7a6f5bf.js" crossorigin="anonymous"></script>
</body>
</html>
