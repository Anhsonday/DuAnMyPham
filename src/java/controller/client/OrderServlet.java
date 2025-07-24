package controller.client;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.entity.Order;
import model.entity.OrderItem;
import model.entity.User;
import service.impl.OrderItemService;
import service.impl.OrderServiceImpl;
import service.interfaces.IOrderItemService;
import service.interfaces.OrderService;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "OrderServlet", urlPatterns = {"/orders"})
public class OrderServlet extends HttpServlet {
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
        HttpSession session = request.getSession(false);
        User user = (User) (session != null ? session.getAttribute("user") : null);
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        String action = request.getParameter("action");
        if (action == null) action = "list";
        switch (action) {
            case "detail":
                showOrderDetail(request, response, user);
                break;
            default:
                String status = request.getParameter("status");
                // PHÂN TRANG
                int page = 1;
                int pageSize = 10;
                String pageParam = request.getParameter("page");
                if (pageParam != null) {
                    try { page = Integer.parseInt(pageParam); } catch (Exception ignored) {}
                }
                List<Order> allOrders;
                if (status == null || status.trim().isEmpty() || status.equals("all")) {
                    allOrders = orderService.getByUserID(user.getUserId());
                } else {
                    allOrders = orderService.getByUserIDAndStatus(user.getUserId(), status);
                }
                int totalOrders = allOrders.size();
                int totalPages = (int) Math.ceil((double) totalOrders / pageSize);
                int fromIndex = (page - 1) * pageSize;
                int toIndex = Math.min(fromIndex + pageSize, totalOrders);
                List<Order> orders = (fromIndex < toIndex) ? allOrders.subList(fromIndex, toIndex) : java.util.Collections.emptyList();
                request.setAttribute("orders", orders);
                request.setAttribute("currentPage", page);
                request.setAttribute("totalPages", totalPages);
                RequestDispatcher dispatcher = request.getRequestDispatcher("/order/listOrders.jsp");
                dispatcher.forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (User) (session != null ? session.getAttribute("user") : null);
        if (user == null) {
            response.sendRedirect("login");
            return;
        }
        String action = request.getParameter("action");
        if ("cancel".equals(action)) {
            cancelOrder(request, response, user);
        } else if ("return".equals(action)) {
            returnOrder(request, response, user);
        } else if ("delivered".equals(action)) {
            markOrderDelivered(request, response, user);
        } else if ("refund".equals(action)) {
            refundOrder(request, response, user);
        } else if ("confirm".equals(action)) {
            confirmOrder(request, response, user);
        } else if ("approveReturn".equals(action)) {
            approveReturnOrder(request, response, user);
        } else if ("confirmRefunded".equals(action)) {
            confirmRefundedOrder(request, response, user);
        } else {
            response.sendRedirect("orders");
        }
    }

    private void listOrders(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        List<Order> orders = orderService.getByUserID(user.getUserId());
        request.setAttribute("orders", orders);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/order/listOrders.jsp");
        dispatcher.forward(request, response);
    }

    private void showOrderDetail(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        String idStr = request.getParameter("orderID");
        if (idStr == null) {
            response.sendRedirect("orders");
            return;
        }
        int orderID = Integer.parseInt(idStr);
        Order order = orderService.getOrderWithItems(orderID);
        if (order == null || order.getUser() == null || !order.getUser().getUserId().equals(user.getUserId())) {
            request.setAttribute("errorMsg", "Không tìm thấy đơn hàng hoặc bạn không có quyền xem.");
            listOrders(request, response, user);
            return;
        }
        List<OrderItem> orderItems = orderItemService.getByOrderID_User(orderID);
        request.setAttribute("order", order);
        request.setAttribute("orderItems", orderItems);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/order/orderDetail.jsp");
        dispatcher.forward(request, response);
    }

    private void cancelOrder(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        String idStr = request.getParameter("orderID");
        if (idStr == null) {
            response.sendRedirect("orders");
            return;
        }
        int orderID = Integer.parseInt(idStr);
        Order order = orderService.getOrderByID(orderID);
        if (order == null || order.getUser() == null || !order.getUser().getUserId().equals(user.getUserId())) {
            request.setAttribute("errorMsg", "Không tìm thấy đơn hàng hoặc bạn không có quyền hủy.");
            listOrders(request, response, user);
            return;
        }
        if (!"pending".equalsIgnoreCase(order.getStatus())) {
            request.setAttribute("errorMsg", "Chỉ có thể hủy đơn hàng ở trạng thái chờ xử lý.");
            listOrders(request, response, user);
            return;
        }
        order.setStatus("cancelled");
        orderService.updateOrder(order);
        request.setAttribute("successMsg", "Đã hủy đơn hàng thành công.");
        listOrders(request, response, user);
    }

    private void returnOrder(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        String idStr = request.getParameter("orderID");
        String reason = request.getParameter("returnReason");
        if (idStr == null) {
            response.sendRedirect("orders");
            return;
        }
        int orderID = Integer.parseInt(idStr);
        Order order = orderService.getOrderByID(orderID);
        if (order == null || order.getUser() == null || !order.getUser().getUserId().equals(user.getUserId())) {
            request.setAttribute("errorMsg", "Không tìm thấy đơn hàng hoặc bạn không có quyền hoàn trả hàng.");
            listOrders(request, response, user);
            return;
        }
        try {
            orderService.returnOrder(orderID, reason);
            request.setAttribute("successMsg", "Đã gửi yêu cầu hoàn trả hàng cho đơn hàng.");
        } catch (Exception e) {
            request.setAttribute("errorMsg", e.getMessage());
        }
        listOrders(request, response, user);
    }

    private void markOrderDelivered(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        String idStr = request.getParameter("orderID");
        if (idStr == null) {
            response.sendRedirect("orders");
            return;
        }
        int orderID = Integer.parseInt(idStr);
        Order order = orderService.getOrderByID(orderID);
        if (order == null || order.getUser() == null || !order.getUser().getUserId().equals(user.getUserId())) {
            request.setAttribute("errorMsg", "Không tìm thấy đơn hàng hoặc bạn không có quyền xác nhận.");
            listOrders(request, response, user);
            return;
        }
        if (!"shipping".equalsIgnoreCase(order.getStatus()) && !"confirmed".equalsIgnoreCase(order.getStatus())) {
            request.setAttribute("errorMsg", "Chỉ xác nhận đơn hàng đang giao hoặc đã xác nhận.");
            listOrders(request, response, user);
            return;
        }
        order.setStatus("delivered");
        orderService.updateOrder(order);
        request.setAttribute("successMsg", "Đã xác nhận nhận hàng thành công.");
        listOrders(request, response, user);
    }

    private void refundOrder(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        String idStr = request.getParameter("orderID");
        if (idStr == null) {
            response.sendRedirect("orders");
            return;
        }
        int orderID = Integer.parseInt(idStr);
        Order order = orderService.getOrderByID(orderID);
        if (order == null || order.getUser() == null || !order.getUser().getUserId().equals(user.getUserId())) {
            request.setAttribute("errorMsg", "Không tìm thấy đơn hàng hoặc bạn không có quyền hoàn tiền.");
            listOrders(request, response, user);
            return;
        }
        if (!"delivered".equalsIgnoreCase(order.getStatus()) && !"returned".equalsIgnoreCase(order.getStatus())) {
            request.setAttribute("errorMsg", "Chỉ hoàn tiền cho đơn đã giao hoặc đã hoàn trả.");
            listOrders(request, response, user);
            return;
        }
        order.setStatus("refunded");
        orderService.updateOrder(order);
        request.setAttribute("successMsg", "Đã hoàn tiền cho đơn hàng.");
        listOrders(request, response, user);
    }

    private void confirmOrder(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        String idStr = request.getParameter("orderID");
        if (idStr == null) {
            response.sendRedirect("orders");
            return;
        }
        int orderID = Integer.parseInt(idStr);
        Order order = orderService.getOrderByID(orderID);
        if (order == null || order.getUser() == null || !order.getUser().getUserId().equals(user.getUserId())) {
            request.setAttribute("errorMsg", "Không tìm thấy đơn hàng hoặc bạn không có quyền xác nhận.");
            listOrders(request, response, user);
            return;
        }
        if (!"pending".equalsIgnoreCase(order.getStatus())) {
            request.setAttribute("errorMsg", "Chỉ xác nhận đơn hàng ở trạng thái chờ xử lý.");
            listOrders(request, response, user);
            return;
        }
        order.setStatus("confirmed");
        orderService.updateOrder(order);
        request.setAttribute("successMsg", "Đã xác nhận đơn hàng thành công.");
        listOrders(request, response, user);
    }

    private void approveReturnOrder(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        String idStr = request.getParameter("orderID");
        if (idStr == null) {
            response.sendRedirect("orders");
            return;
        }
        int orderID = Integer.parseInt(idStr);
        Order order = orderService.getOrderByID(orderID);
        if (order == null || order.getUser() == null || !order.getUser().getUserId().equals(user.getUserId())) {
            request.setAttribute("errorMsg", "Không tìm thấy đơn hàng hoặc bạn không có quyền duyệt hoàn trả.");
            listOrders(request, response, user);
            return;
        }
        if (!"returned".equalsIgnoreCase(order.getStatus())) {
            request.setAttribute("errorMsg", "Chỉ duyệt hoàn trả cho đơn đã hoàn trả.");
            listOrders(request, response, user);
            return;
        }
        order.setStatus("refunded");
        orderService.updateOrder(order);
        request.setAttribute("successMsg", "Đã duyệt hoàn trả và hoàn tiền cho đơn hàng.");
        listOrders(request, response, user);
    }

    private void confirmRefundedOrder(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        String idStr = request.getParameter("orderID");
        if (idStr == null) {
            response.sendRedirect("orders");
            return;
        }
        int orderID = Integer.parseInt(idStr);
        Order order = orderService.getOrderByID(orderID);
        if (order == null || order.getUser() == null || !order.getUser().getUserId().equals(user.getUserId())) {
            request.setAttribute("errorMsg", "Không tìm thấy đơn hàng hoặc bạn không có quyền xác nhận hoàn tiền.");
            listOrders(request, response, user);
            return;
        }
        if (!"refunded".equalsIgnoreCase(order.getStatus())) {
            request.setAttribute("errorMsg", "Chỉ xác nhận hoàn tiền cho đơn đã hoàn tiền.");
            listOrders(request, response, user);
            return;
        }
        order.setStatus("completed");
        orderService.updateOrder(order);
        request.setAttribute("successMsg", "Đã xác nhận hoàn tiền thành công.");
        listOrders(request, response, user);
    }
} 