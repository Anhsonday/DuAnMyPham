package controller.admin;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.entity.Order;
import service.impl.OrderServiceImpl;
import service.interfaces.OrderService;
import java.io.IOException;
import java.util.List;
import service.impl.OrderItemService;
import service.interfaces.IOrderItemService;

@WebServlet(name = "ManageOrderServlet", urlPatterns = {"/manageOrders"})
public class ManageOrderServlet extends HttpServlet {
    private OrderService orderService;
    private IOrderItemService orderItemService;

    @Override
    public void init() {
        orderService = new OrderServiceImpl();
        orderItemService = new OrderItemService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
//        HttpSession session = request.getSession(false);
//        User user = (User) (session != null ? session.getAttribute("user") : null);
//        if (user == null || !"admin".equalsIgnoreCase(user.getRole())) {
//            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied. Admin role required.");
//            return;
//        }
        String action = request.getParameter("action");
        if (action == null) action = "list";
        switch (action) {
            case "detail":
                showOrderDetail(request, response);
                break;
            default:
                listOrders(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
//        HttpSession session = request.getSession(false);
//        User user = (User) (session != null ? session.getAttribute("user") : null);
//        if (user == null || !"admin".equalsIgnoreCase(user.getRole())) {
//            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied. Admin role required.");
//            return;
//        }
        String action = request.getParameter("action");
        if (action == null) action = "";
        switch (action) {
            case "confirm":
                confirmShipping(request, response);
                break;
            case "cancel":
                cancelOrder(request, response);
                break;
            case "deleteItem":
                deleteOrderItem(request, response);
                break;
            case "refund":
                refundOrder(request, response);
                break;
            case "return":
                returnOrder(request, response);
                break;
            default:
                response.sendRedirect("/manageOrders");
        }
    }

    private void listOrders(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String tab = request.getParameter("tab");
        if (tab == null || tab.trim().isEmpty()) tab = "all";
        request.setAttribute("tab", tab); // Đảm bảo JSP nhận đúng giá trị tab
        String q = request.getParameter("q");
        String sort = request.getParameter("sort");
        // PHÂN TRANG
        int page = 1;
        int pageSize = 10;
        String pageParam = request.getParameter("page");
        if (pageParam != null) {
            try { page = Integer.parseInt(pageParam); } catch (Exception ignored) {}
        }
        List<Order> allOrders = orderService.searchAndSortOrders(tab, q, sort);
        int totalOrders = allOrders.size();
        int totalPages = (int) Math.ceil((double) totalOrders / pageSize);
        int fromIndex = (page - 1) * pageSize;
        int toIndex = Math.min(fromIndex + pageSize, totalOrders);
        List<Order> orders = (fromIndex < toIndex) ? allOrders.subList(fromIndex, toIndex) : java.util.Collections.emptyList();
        request.setAttribute("orders", orders);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/order/adminListOrders.jsp");
        dispatcher.forward(request, response);
    }

    private void showOrderDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("orderID");
        if (idStr == null) {
            response.sendRedirect("/order/adminOrderDetail.jsp");
            return;
        }
        int orderID = Integer.parseInt(idStr);
        Order order = orderService.getOrderWithItems(orderID);
        if (order == null) {
            request.setAttribute("errorMsg", "Không tìm thấy đơn hàng.");
            listOrders(request, response);
            return;
        }
        request.setAttribute("order", order);
        request.setAttribute("orderItems", orderItemService.getByOrderID_Admin(orderID));
        RequestDispatcher dispatcher = request.getRequestDispatcher("/order/adminOrderDetail.jsp");
        dispatcher.forward(request, response);
    }

    private void confirmShipping(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("orderID");
        if (idStr == null) {
            response.sendRedirect("/manageOrders");
            return;
        }
        int orderID = Integer.parseInt(idStr);
        try {
            orderService.updateOrderStatus(orderID, "shipping");
            request.setAttribute("successMsg", "Đã xác nhận đơn hàng là đã vận chuyển.");
        } catch (Exception e) {
            request.setAttribute("errorMsg", e.getMessage());
        }
        listOrders(request, response);
    }

    private void cancelOrder(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("orderID");
        if (idStr == null) {
            response.sendRedirect("/manageOrders");
            return;
        }
        int orderID = Integer.parseInt(idStr);
        try {
            orderService.cancelOrder(orderID);
            request.setAttribute("successMsg", "Đã hủy đơn hàng.");
        } catch (Exception e) {
            request.setAttribute("errorMsg", e.getMessage());
        }
        listOrders(request, response);
    }

    private void deleteOrderItem(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String orderItemIdStr = request.getParameter("orderItemID");
        String orderIdStr = request.getParameter("orderID");
        if (orderItemIdStr == null || orderIdStr == null) {
            response.sendRedirect("/manageOrders");
            return;
        }
        int orderItemID = Integer.parseInt(orderItemIdStr);
        int orderID = Integer.parseInt(orderIdStr);
        orderItemService.deleteOrderItem(orderItemID);
        // Load lại chi tiết đơn hàng
        request.setAttribute("successMsg", "Đã xóa sản phẩm khỏi đơn hàng.");
        request.setAttribute("orderID", orderID);
        showOrderDetail(request, response);
    }

    private void refundOrder(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("orderID");
        if (idStr == null) {
            response.sendRedirect("/manageOrders");
            return;
        }
        int orderID = Integer.parseInt(idStr);
        try {
            orderService.updateOrderStatus(orderID, "refunded");
            request.setAttribute("successMsg", "Đã hoàn tiền cho đơn hàng.");
        } catch (Exception e) {
            request.setAttribute("errorMsg", e.getMessage());
        }
        listOrders(request, response);
    }

    private void returnOrder(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("orderID");
        if (idStr == null) {
            response.sendRedirect("/manageOrders");
            return;
        }
        int orderID = Integer.parseInt(idStr);
        try {
            orderService.updateOrderStatus(orderID, "returned");
            request.setAttribute("successMsg", "Đã chuyển đơn hàng sang trạng thái hoàn trả.");
        } catch (Exception e) {
            request.setAttribute("errorMsg", e.getMessage());
        }
        listOrders(request, response);
    }
} 