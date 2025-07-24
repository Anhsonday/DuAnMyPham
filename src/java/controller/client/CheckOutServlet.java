/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.client;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.math.BigDecimal;
import java.util.List;
import model.entity.Address;
import model.entity.Cart;
import model.entity.CartItem;
import model.entity.Order;
import model.entity.OrderItem;
import model.entity.PaymentMethod;
import model.entity.User;
import service.impl.AddressService;
import service.impl.CartItemService;
import service.impl.OrderItemService;
import service.impl.OrderServiceImpl;
import service.impl.PaymentMethodService;
import service.interfaces.IAddressService;
import service.interfaces.ICartItemService;
import service.interfaces.IOrderItemService;
import service.interfaces.OrderService;
import service.interfaces.IPaymentMethodService;
import util.db.EmailUtil;
import utils.ProductImageUtil;

/**
 *
 * @author DELL
 */
@WebServlet(name = "OrderServlet", urlPatterns = {"/checkout"})
public class CheckOutServlet extends HttpServlet {
    OrderService orderService;
    IOrderItemService orderItemService;
    IAddressService addrService;
    IPaymentMethodService methodService;
    ICartItemService cartItemService;
    
    public void init(){
        orderService = new OrderServiceImpl();
        orderItemService = new OrderItemService();
        addrService = new AddressService();
        methodService = new PaymentMethodService();
        cartItemService = new CartItemService();
    }
    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet OrderServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet OrderServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        Cart cart = (Cart) session.getAttribute("cart");
        if (cart == null) {
            response.sendRedirect("cart");
            return;
        }
        
        // Lấy danh sách items đã chọn
        List<CartItem> selectedItems = cartItemService.getAllByCartID_UserSelected(cart.getCartID());
        // KHÔNG cần set ảnh vào Product nữa, chỉ truyền selectedItems như cũ
        if (selectedItems == null || selectedItems.isEmpty()) {
            response.sendRedirect("cart");
            return;
        }
        
        // Tính toán các thông tin
        BigDecimal totalAmount = BigDecimal.ZERO;
        for (CartItem item : selectedItems) {
            totalAmount = totalAmount.add(item.getProduct().getPrice().multiply(BigDecimal.valueOf(item.getQuantity())));
        }
        
        // Lấy địa chỉ mặc định để tính phí ship
        List<Address> shippingAddresses = addrService.getShipAddrByUserID(user.getUserId());
        Address defaultShippingAddress = null;
        if (!shippingAddresses.isEmpty()) {
            defaultShippingAddress = shippingAddresses.stream()
                    .filter(addr -> addr.getIsDefault())
                    .findFirst()
                    .orElse(shippingAddresses.get(0));
        }
        // Nếu không có địa chỉ giao hàng, báo lỗi hợp lý
        if (defaultShippingAddress == null) {
            request.setAttribute("errorMsg", "Vui lòng thêm địa chỉ giao hàng trước khi thanh toán!");
            request.setAttribute("shippingAddresses", shippingAddresses);
            request.setAttribute("billingAddresses", addrService.getBillAddrByUserID(user.getUserId()));
            request.setAttribute("paymentMethods", methodService.getAllMethods());
            request.setAttribute("selectedItems", selectedItems);
            request.setAttribute("total", totalAmount);
            request.setAttribute("discount", orderService.getDiscount());
            request.setAttribute("shippingFee", BigDecimal.ZERO);
            request.setAttribute("tax", BigDecimal.ZERO);
            request.setAttribute("finalTotal", BigDecimal.ZERO);
            request.setAttribute("defaultShippingAddress", null);
            request.getRequestDispatcher("/cart/checkout.jsp").forward(request, response);
            return;
        }
        
        // Tính toán các khoản phí
        BigDecimal discount = orderService.getDiscount();
        BigDecimal shippingFee = defaultShippingAddress != null ? 
            orderService.getShippingFee(defaultShippingAddress) : BigDecimal.ZERO;
        BigDecimal tax = orderService.getTax(totalAmount);
        BigDecimal finalAmount = orderService.getFinalAmount(totalAmount, defaultShippingAddress);
        
        // Set attributes cho JSP
        request.setAttribute("shippingAddresses", shippingAddresses);
        request.setAttribute("billingAddresses", addrService.getBillAddrByUserID(user.getUserId()));
        
        // Đảm bảo VNPay payment method tồn tại
        methodService.ensureVNPayMethodExists();
        List<PaymentMethod> paymentMethods = methodService.getAllMethods();
        request.setAttribute("paymentMethods", paymentMethods);
        
        request.setAttribute("selectedItems", selectedItems);
        request.setAttribute("total", totalAmount);
        request.setAttribute("discount", discount);
        request.setAttribute("shippingFee", shippingFee);
        request.setAttribute("tax", tax);
        request.setAttribute("finalTotal", finalAmount);
        request.setAttribute("defaultShippingAddress", defaultShippingAddress);
        
        request.getRequestDispatcher("/cart/checkout.jsp").forward(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.-
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        Cart cart = (Cart) session.getAttribute("cart");
        if (cart == null) {
            response.sendRedirect("cart");
            return;
        }
        
        // Kiểm tra nếu là AJAX request để cập nhật thông tin đơn hàng
        String action = request.getParameter("action");
        if ("updateSummary".equals(action)) {
            handleUpdateSummary(request, response, cart);
            return;
        }
        
        try {
            // Validate input
            String shippingParam = request.getParameter("shippingAddressID");
            String billingParam = request.getParameter("billingAddressID");
            String paymentParam = request.getParameter("paymentMethodID");
            String voucherCode = request.getParameter("voucherCode");
            String notes = request.getParameter("notes");
            
            // Validate notes length
            if (notes != null && notes.length() > 500) {
                throw new IllegalArgumentException("Ghi chú không được vượt quá 500 ký tự.");
            }

            if (shippingParam == null || billingParam == null || paymentParam == null ||
                shippingParam.trim().isEmpty() || billingParam.trim().isEmpty() || paymentParam.trim().isEmpty()) {
                throw new IllegalArgumentException("Vui lòng chọn đầy đủ địa chỉ và phương thức thanh toán.");
            }

            int shipID = Integer.parseInt(shippingParam);
            int billID = Integer.parseInt(billingParam);
            int methodID = Integer.parseInt(paymentParam);

            Address shipAddr = addrService.getAddressById(shipID);
            Address billAddr = addrService.getAddressById(billID);
            PaymentMethod method = methodService.getMethodById(methodID);

            if (shipAddr == null || billAddr == null || method == null) {
                throw new IllegalArgumentException("Thông tin địa chỉ hoặc phương thức thanh toán không hợp lệ.");
            }

            // Lấy danh sách items đã chọn
            List<CartItem> selected = cartItemService.getAllByCartID_UserSelected(cart.getCartID());
            if (selected == null || selected.isEmpty()) {
                throw new IllegalArgumentException("Giỏ hàng của bạn đang trống.");
            }

            // Tính toán các thông tin
            BigDecimal totalAmount = orderService.getTotalAmount(selected);
            
            BigDecimal discount = orderService.getDiscount();
            BigDecimal voucherDiscount = BigDecimal.ZERO;
            
            // Xử lý voucher nếu có
            if (voucherCode != null && !voucherCode.trim().isEmpty()) {
                voucherDiscount = validateAndGetVoucherDiscount(voucherCode, totalAmount);
            }
            
            BigDecimal totalDiscount = discount.add(voucherDiscount);
            BigDecimal shippingFee = orderService.getShippingFee(shipAddr);
            BigDecimal tax = orderService.getTax(totalAmount);
            BigDecimal finalAmount = orderService.getFinalAmount(totalAmount, shipAddr).subtract(voucherDiscount);

            // Tạo đơn hàng với đầy đủ thông tin
            Order order = new Order();
            order.setStatus("pending");
            order.setTotalAmount(totalAmount);
            order.setDiscountAmount(totalDiscount);
            order.setShippingFee(shippingFee);
            order.setTax(tax);
            order.setFinalAmount(finalAmount);
            order.setShippingAddress(shipAddr);
            order.setBillingAddress(billAddr);
            order.setPaymentMethod(method);
            order.setUser(user);
            order.setNotes(notes != null ? notes.trim() : null);
            System.out.println("[DEBUG] Bắt đầu persist Order. Trước persist, orderID: " + order.getOrderID());
            orderService.createOrder(order);
            System.out.println("[DEBUG] Sau persist Order. orderID: " + order.getOrderID() + ", orderNumber: " + order.getOrderNumber());

            // Tạo OrderItems từ CartItems đã chọn
            System.out.println("[DEBUG] Bắt đầu tạo OrderItem cho OrderID: " + order.getOrderID());
            orderItemService.createOrderItemFromSelected(selected, order);
            System.out.println("[DEBUG] Đã gọi createOrderItemFromSelected cho OrderID: " + order.getOrderID());

            // Lấy danh sách OrderItems để gửi email
            System.out.println("[DEBUG] Trước khi lấy lại OrderItem: orderID=" + order.getOrderID() + ", selected.size=" + (selected == null ? "null" : selected.size()));
            List<OrderItem> items = orderItemService.getByOrderID_Admin(order.getOrderID());
            // KHÔNG cần set ảnh vào Product nữa, chỉ truyền items như cũ
            System.out.println("[DEBUG] Sau khi lấy lại OrderItem: orderID=" + order.getOrderID() + ", items.size=" + (items == null ? "null" : items.size()));
            if (items == null || items.isEmpty()) {
                System.out.println("[DEBUG] Không tìm thấy OrderItem cho OrderID: " + order.getOrderID());
                System.out.println("[DEBUG] selected CartItems:");
                if (selected != null) {
                    for (CartItem ci : selected) {
                        System.out.println("[DEBUG] CartItemID=" + ci.getCartItemID() + ", ProductID=" + (ci.getProduct() != null ? ci.getProduct().getProductId() : "null") + ", Qty=" + ci.getQuantity() + ", Status=" + ci.getStatus());
                    }
                }
                System.out.println("[DEBUG] Order info: orderID=" + order.getOrderID() + ", userID=" + (order.getUser() != null ? order.getUser().getUserId() : "null") + ", totalAmount=" + order.getTotalAmount());
                throw new IllegalStateException("Không tìm thấy sản phẩm trong đơn hàng! OrderID: " + order.getOrderID());
            }

            // Gửi mail
            sendOrderConfirmationEmail(user, items, finalAmount, notes);

            // Lưu order đã persist vào session
            session.setAttribute("order", order);
            session.setAttribute("orderItems", items);
            session.setAttribute("orderNumber", order.getOrderNumber());
            session.setAttribute("paymentMethod", method.getMethodName());
            session.setAttribute("finalAmount", finalAmount);
            // Sửa lỗi: truyền danh sách OrderItem sang JSP bằng selectedItems
            request.setAttribute("selectedItems", items);
            // Nếu forward sang checkout.jsp thì dùng dòng dưới:
            // request.getRequestDispatcher("cart/checkout.jsp").forward(request, response);
            // Nếu redirect sang trang khác thì giữ nguyên
            response.sendRedirect("payment?action=create&amount=" + finalAmount + "&paymentMethodId=" + method.getPaymentMethodID());

        } catch (Exception e) {

            request.setAttribute("errorMsg", "Lỗi khi thanh toán: " + e.getMessage());
            
            // Lấy lại notes từ request để giữ lại khi có lỗi
            String notes = request.getParameter("notes");
            if (notes != null && notes.length() > 500) {
                notes = notes.substring(0, 500); // Cắt bớt nếu vượt quá 500 ký tự
            }
            
            // Tính toán lại các thông tin để hiển thị trong form
            List<CartItem> selectedItems = cartItemService.getAllByCartID_UserSelected(cart.getCartID());
            BigDecimal totalAmount = orderService.getTotalAmount(selectedItems);
            
            List<Address> shippingAddresses = addrService.getShipAddrByUserID(user.getUserId());
            Address defaultShippingAddress = null;
            if (!shippingAddresses.isEmpty()) {
                defaultShippingAddress = shippingAddresses.stream()
                        .filter(addr -> addr.getIsDefault())
                        .findFirst()
                        .orElse(shippingAddresses.get(0));
            }
            
            BigDecimal discount = orderService.getDiscount();
            BigDecimal shippingFee = defaultShippingAddress != null ? 
                orderService.getShippingFee(defaultShippingAddress) : BigDecimal.ZERO;
            BigDecimal tax = orderService.getTax(totalAmount);
            BigDecimal finalAmount = orderService.getFinalAmount(totalAmount, defaultShippingAddress);
            
            // Bổ sung set lại các attribute cần thiết cho checkout.jsp
            request.setAttribute("shippingAddresses", shippingAddresses);
            request.setAttribute("billingAddresses", addrService.getBillAddrByUserID(user.getUserId()));
            request.setAttribute("paymentMethods", methodService.getAllMethods());
            request.setAttribute("selectedItems", selectedItems);
            request.setAttribute("total", totalAmount);
            request.setAttribute("discount", discount);
            request.setAttribute("shippingFee", shippingFee);
            request.setAttribute("tax", tax);
            request.setAttribute("finalTotal", finalAmount);
            request.setAttribute("defaultShippingAddress", defaultShippingAddress);
            request.setAttribute("notes", notes); // Giữ lại notes khi có lỗi
            
            request.getRequestDispatcher("cart/checkout.jsp").forward(request, response);
        }
    }
    
    private void sendOrderConfirmationEmail(User user, List<OrderItem> items, BigDecimal totalAmount, String notes) {
        String orderNumber = orderService.getNextOrderNumber();
        StringBuilder productNames = new StringBuilder();
        for (OrderItem item : items) {
            if (item != null && item.getProduct() != null && item.getProduct().getProductName() != null) {
                productNames.append(item.getProduct().getProductName())
                            .append(" (x").append(item.getQuantity()).append("), ");
            }
        }
        if (productNames.length() > 2) {
            productNames.setLength(productNames.length() - 2);
        }

        String subject = "Xác nhận đơn hàng #" + orderNumber;
        StringBuilder content = new StringBuilder();
        content.append("Xin chào ").append(user.getUsername() != null ? user.getUsername() : "Khách hàng").append(",\n");
        content.append("Cảm ơn bạn đã mua sắm tại cửa hàng!\n");
        content.append("Mã đơn hàng: #").append(orderNumber).append("\n");
        content.append("Sản phẩm: ").append(productNames).append("\n");
        content.append("Tổng giá trị đơn hàng: ").append(String.format("%,.0f₫", totalAmount)).append("\n");
        
        if (notes != null && !notes.trim().isEmpty()) {
            content.append("Ghi chú đơn hàng: ").append(notes.trim()).append("\n");
        }
        
        content.append("Đơn hàng của bạn đã được ghi nhận và sẽ được xử lý sớm nhất.\n");
        content.append("Trân trọng!");

        if (user.getEmail() != null) {
            EmailUtil.sendMail(user.getEmail(), subject, content.toString());
        }
    }
    
    private void handleUpdateSummary(HttpServletRequest request, HttpServletResponse response, Cart cart) 
            throws ServletException, IOException {
        try {
            String shippingParam = request.getParameter("shippingAddressID");
            String voucherCode = request.getParameter("voucherCode");
            
            if (shippingParam == null || shippingParam.trim().isEmpty()) {
                response.setContentType("application/json");
                response.getWriter().write("{\"success\": false, \"message\": \"Invalid shipping address\"}");
                return;
            }

            int shipID = Integer.parseInt(shippingParam);
            Address shipAddr = addrService.getAddressById(shipID);
            if (shipAddr == null) {
                response.setContentType("application/json");
                response.getWriter().write("{\"success\": false, \"message\": \"Address not found\"}");
                return;
            }

            // Tính toán lại thông tin
            List<CartItem> selected = cartItemService.getAllByCartID_UserSelected(cart.getCartID());
            BigDecimal totalAmount = BigDecimal.ZERO;
            if (selected != null) {
                for (CartItem item : selected) {
                    totalAmount = totalAmount.add(item.getProduct().getPrice().multiply(BigDecimal.valueOf(item.getQuantity())));
                }
            }
            
            BigDecimal discount = orderService.getDiscount();
            BigDecimal voucherDiscount = BigDecimal.ZERO;
            
            // Xử lý voucher nếu có
            if (voucherCode != null && !voucherCode.trim().isEmpty()) {
                voucherDiscount = validateAndGetVoucherDiscount(voucherCode, totalAmount);
            }
            
            BigDecimal totalDiscount = discount.add(voucherDiscount);
            BigDecimal shippingFee = orderService.getShippingFee(shipAddr);
            BigDecimal tax = orderService.getTax(totalAmount);
            BigDecimal finalAmount = orderService.getFinalAmount(totalAmount, shipAddr).subtract(voucherDiscount);

            // Trả về JSON response
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            String jsonResponse = String.format(
                "{\"success\": true, \"discount\": %s, \"voucherDiscount\": %s, \"shippingFee\": %s, \"tax\": %s, \"finalTotal\": %s}",
                totalDiscount, voucherDiscount, shippingFee, tax, finalAmount
            );
            response.getWriter().write(jsonResponse);

        } catch (Exception e) {

            response.setContentType("application/json");
            response.getWriter().write("{\"success\": false, \"message\": \"Update failed\"}");
        }
    }
    
    private BigDecimal validateAndGetVoucherDiscount(String voucherCode, BigDecimal totalAmount) {
        // Demo voucher validation - sẽ được thay thế bằng database lookup
        switch (voucherCode.toUpperCase()) {
            case "SAVE10":
                if (totalAmount.compareTo(BigDecimal.valueOf(300000)) >= 0) {
                    return totalAmount.multiply(BigDecimal.valueOf(0.10));
                }
                break;
            case "SAVE15":
                if (totalAmount.compareTo(BigDecimal.valueOf(600000)) >= 0) {
                    return totalAmount.multiply(BigDecimal.valueOf(0.105));
                }
                break;
            case "DISCOUNT50K":
                if (totalAmount.compareTo(BigDecimal.valueOf(400000)) >= 0) {
                    return BigDecimal.valueOf(50000);
                }
                break;
            case "FREESHIP":
                if (totalAmount.compareTo(BigDecimal.valueOf(500000)) >= 0) {
                    return BigDecimal.ZERO; // Sẽ xử lý phí ship riêng
                }
                break;
        }
        return BigDecimal.ZERO;
    }

}
