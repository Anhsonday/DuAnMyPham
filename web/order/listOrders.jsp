<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <title>Đơn hàng của tôi</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet"/>

    <style>
        body {
            background: #f8f9fa;
            font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
            padding-top: 30px;
            padding-bottom: 30px;
        }
        h2 {
            color: #4b3c93;
            font-weight: 700;
            margin-bottom: 30px;
            text-align: center;
            text-shadow: 0 1px 3px rgba(75, 60, 147, 0.25);
        }
        /* Filter dạng tab theo trạng thái */
        .order-tabs {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            gap: 12px;
            margin-bottom: 25px;
            max-width: 780px;
            margin-left: auto;
            margin-right: auto;
        }
        .order-tab {
            padding: 10px 26px;
            border-radius: 22px;
            font-weight: 600;
            font-size: 1rem;
            cursor: pointer;
            text-decoration: none;
            color: #4b3c93;
            background: #e3eafc;
            border: none;
            box-shadow: 0 2px 8px rgba(75, 60, 147, 0.16);
            transition: 0.2s ease-in-out;
            user-select: none;
        }
        .order-tab:hover {
            background: #7868e6;
            color: white;
            box-shadow: 0 3px 14px rgba(120,104,230,0.6);
        }
        .order-tab.active {
            background: #4b3c93;
            color: white;
            box-shadow: 0 4px 18px rgba(75, 60, 147, 0.7);
            cursor: default;
        }

        /* Bảng đơn hàng */
        .order-table {
            max-width: 900px;
            margin: 0 auto;
            box-shadow: 0 8px 24px rgb(120 104 230 / 0.15);
            border-radius: 12px;
            background: white;
            overflow-x: auto;
        }
        .order-table table {
            border-collapse: separate;
            border-spacing: 0;
            width: 100%;
            min-width: 650px;
        }
        .order-table thead tr {
            background: linear-gradient(90deg, #775fd6, #4b3c93);
            color: #fff;
            font-weight: 700;
            box-shadow: 0 2px 6px rgb(120 104 230 / 0.6);
            border-top-left-radius: 12px;
            border-top-right-radius: 12px;
        }
        .order-table thead th {
            padding: 14px 18px;
            text-align: center;
            vertical-align: middle;
            font-size: 1rem;
        }
        .order-table tbody tr {
            border-bottom: 1.5px solid #eee;
            transition: background-color 0.2s ease-in-out;
        }
        .order-table tbody tr:hover {
            background-color: #f0ebff;
        }
        .order-table tbody td {
            color: #4a4a4a;
            text-align: center;
            padding: 12px 15px;
            font-size: 0.95rem;
            vertical-align: middle;
            word-wrap: break-word;
        }
        /* Badge trạng thái theo màu sắc */
        .badge-status {
            font-weight: 600;
            padding: 8px 16px;
            font-size: 0.9rem;
            border-radius: 18px;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            min-width: 110px;
            justify-content: center;
            color: white;
            box-shadow: 0 2px 10px rgb(75 60 147 / 0.2);
        }
        .badge-pending {
            background-color: #f9b115;
            box-shadow: 0 2px 6px rgb(249 177 21 / 0.5);
        }
        .badge-confirmed {
            background-color: #3b82f6;
            box-shadow: 0 2px 6px rgb(59 130 246 / 0.6);
        }
        .badge-shipping {
            background-color: #0ea5e9;
            box-shadow: 0 2px 6px rgb(14 165 233 / 0.6);
        }
        .badge-delivered {
            background-color: #10b981;
            box-shadow: 0 2px 6px rgb(16 185 129 / 0.5);
        }
        .badge-cancelled {
            background-color: #ef4444;
            box-shadow: 0 2px 6px rgb(239 68 68 / 0.5);
        }
        .badge-returned {
            background-color: #a855f7;
            box-shadow: 0 2px 6px rgb(168 85 247 / 0.5);
        }
        .badge-refunded {
            background-color: #6366f1;
            box-shadow: 0 2px 6px rgb(99 102 241 / 0.5);
        }
        .btn-detail {
            background-color: #4b3c93;
            border: none;
            padding: 6px 14px;
            font-size: 0.9rem;
            font-weight: 700;
            border-radius: 22px;
            color: #fff;
            box-shadow: 0 3px 12px rgb(75 60 147 / 0.4);
            transition: background-color 0.3s ease;
            text-decoration: none;
            display: inline-block;
        }
        .btn-detail:hover {
            background-color: #7868e6;
            box-shadow: 0 4px 16px rgb(120 104 230 / 0.6);
            text-decoration: none;
            color: #fff;
        }
        @media (max-width: 600px) {
            .order-tabs {
                max-width: 100%;
                gap: 8px;
            }
            .order-tab {
                padding: 8px 18px;
                font-size: 0.9rem;
            }
            .order-table table {
                min-width: 100%;
            }
            .order-table tbody td, .order-table thead th {
                font-size: 0.85rem;
                padding: 10px 8px;
            }
            h2 {
                font-size: 1.6rem;
            }
        }
    </style>
</head>
<body>
<div class="container">
    <a href="home" class="btn btn-outline-primary mb-3" style="font-weight:600;"><i class="fa fa-arrow-left"></i> Quay lại trang chủ</a>
    <h2>Đơn hàng của tôi</h2>

    <!-- Thanh tab trạng thái -->
    <div class="order-tabs" role="tablist" aria-label="Filter orders by status">
        <a href="orders?status=all" class="order-tab ${param.status == null || param.status == 'all' ? 'active' : ''}">Tất cả</a>
        <a href="orders?status=pending" class="order-tab ${param.status == 'pending' ? 'active' : ''}">Chờ xác nhận</a>
        <a href="orders?status=confirmed" class="order-tab ${param.status == 'confirmed' ? 'active' : ''}">Đã xác nhận</a>
        <a href="orders?status=shipping" class="order-tab ${param.status == 'shipping' ? 'active' : ''}">Đang giao</a>
        <a href="orders?status=delivered" class="order-tab ${param.status == 'delivered' ? 'active' : ''}">Đã giao</a>
        <a href="orders?status=returned" class="order-tab ${param.status == 'returned' ? 'active' : ''}">Đã hoàn trả</a>
        <a href="orders?status=refunded" class="order-tab ${param.status == 'refunded' ? 'active' : ''}">Đã hoàn tiền</a>
        <a href="orders?status=cancelled" class="order-tab ${param.status == 'cancelled' ? 'active' : ''}">Đã hủy</a>
    </div>

    <c:if test="${not empty orders}">
        <div class="order-table">
            <table class="table mb-0">
                <thead>
                <tr>
                    <th>Mã đơn</th>
                    <th>Ngày đặt</th>
                    <th>Trạng thái</th>
                    <th>Tổng tiền</th>
                    <th>Chi tiết</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="order" items="${orders}">
                    <c:if test="${param.status == null || param.status == 'all' || order.status == param.status}">
                        <tr>
                            <td>${order.orderNumber}</td>
                            <td><fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy HH:mm:ss"/></td>
                            <td>
                                <c:choose>
                                    <c:when test="${order.status eq 'pending'}">
                                        <span class="badge-status badge-pending"><i class="fa fa-clock"></i> Chờ xác nhận</span>
                                    </c:when>
                                    <c:when test="${order.status eq 'confirmed'}">
                                        <span class="badge-status badge-confirmed"><i class="fa fa-check-circle"></i> Đã xác nhận</span>
                                    </c:when>
                                    <c:when test="${order.status eq 'shipping'}">
                                        <span class="badge-status badge-shipping"><i class="fa fa-truck"></i> Đang giao</span>
                                    </c:when>
                                    <c:when test="${order.status eq 'delivered'}">
                                        <span class="badge-status badge-delivered"><i class="fa fa-check"></i> Đã giao</span>
                                    </c:when>
                                    <c:when test="${order.status eq 'cancelled'}">
                                        <span class="badge-status badge-cancelled"><i class="fa fa-times-circle"></i> Đã hủy</span>
                                    </c:when>
                                    <c:when test="${order.status eq 'returned'}">
                                        <span class="badge-status badge-returned"><i class="fa fa-undo"></i> Đã hoàn trả</span>
                                    </c:when>
                                    <c:when test="${order.status eq 'refunded'}">
                                        <span class="badge-status badge-refunded"><i class="fa fa-money-bill"></i> Đã hoàn tiền</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge badge-secondary">${order.status}</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:set var="amountFormatted">
                                    <fmt:formatNumber value="${order.finalAmount}" type="number" groupingUsed="true" />
                                </c:set>
                                ${fn:replace(amountFormatted, ".", ",")}đ
                            </td>
                            <td>
                                <a href="orders?action=detail&orderID=${order.orderID}" class="btn-detail" title="Xem chi tiết đơn hàng">
                                    Xem chi tiết
                                </a>
                            </td>
                        </tr>
                    </c:if>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </c:if>

    <c:if test="${totalPages > 1}">
        <nav aria-label="Page navigation" class="mt-4">
            <ul class="pagination justify-content-center">
                <c:forEach var="i" begin="1" end="${totalPages}">
                    <c:set var="pageStatus" value="${empty param.status ? 'all' : param.status}" />
                    <li class="page-item ${i == currentPage ? 'active' : ''}">
                        <a class="page-link" href="orders?status=${pageStatus}&page=${i}">${i}</a>
                    </li>
                </c:forEach>
            </ul>
        </nav>
    </c:if>

    <c:if test="${empty orders}">
        <div class="alert alert-info text-center mt-4">Bạn chưa có đơn hàng nào.</div>
    </c:if>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://kit.fontawesome.com/a2b7a6f5bf.js" crossorigin="anonymous"></script>
</body>
</html>
