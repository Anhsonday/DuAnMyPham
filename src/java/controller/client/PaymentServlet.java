/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.client;

import jakarta.servlet.RequestDispatcher;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.math.BigDecimal;
import java.io.UnsupportedEncodingException;
import model.entity.Order;
import model.entity.Payment;
import model.entity.PaymentMethod;
import model.entity.User;
import service.impl.PaymentMethodService;
import service.impl.PaymentService;
import service.impl.VNPayService;
import service.impl.OrderItemService;
import service.interfaces.IPaymentMethodService;
import service.interfaces.IPaymentService;
import service.interfaces.IOrderItemService;

/**
 *
 * @author DELL
 */
@WebServlet(name = "PaymentServlet", urlPatterns = {"/payment"})
public class PaymentServlet extends HttpServlet {
    IPaymentService paymentService;
    IPaymentMethodService methodService;
    VNPayService vnpayService;
    IOrderItemService orderItemService; // Thêm dòng này
    
    // Constants for payment methods
    public static final int PAYMENT_METHOD_COD = 1;
    public static final int PAYMENT_METHOD_VNPAY = 2; // VNPay payment method
    
    public void init() {
        paymentService = new PaymentService();
        methodService = new PaymentMethodService();
        vnpayService = new VNPayService();
        orderItemService = new OrderItemService(); // Thêm dòng này
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
            out.println("<title>Servlet PaymentServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet PaymentServlet at " + request.getContextPath() + "</h1>");
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
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        Order order = (Order) session.getAttribute("order");
        if(user == null) {
            response.sendRedirect("login");
            return;
        }
        String action = request.getParameter("action");
        if(order == null) {
            response.sendRedirect("cart");
            return;
        }
        if ("create".equals(action) && order != null) {
            try {
                String amountParam = request.getParameter("amount");
                String methodIdParam = request.getParameter("paymentMethodId");
                System.out.println("[PaymentServlet] orderID: " + order.getOrderID());
                System.out.println("[PaymentServlet] amount: " + amountParam);
                System.out.println("[PaymentServlet] paymentMethodId: " + methodIdParam);
                if (amountParam != null && methodIdParam != null) {
                    BigDecimal amount = new BigDecimal(amountParam);
                    int paymentMethodId = Integer.parseInt(methodIdParam);
                    PaymentMethod paymentMethod = methodService.getMethodById(paymentMethodId);
                    if (order.getStatus() == null || !order.getStatus().equalsIgnoreCase("pending")) {
                        request.setAttribute("errorMsg", "Đơn hàng không hợp lệ hoặc đã được thanh toán!");
                        request.getRequestDispatcher("cart/checkout.jsp").forward(request, response);
                        return;
                    }
                    if (paymentMethodId == PAYMENT_METHOD_VNPAY) {
                        handleVNPayPayment(request, response, order, amount, paymentMethod);
                        return;
                    } else if (paymentMethodId == PAYMENT_METHOD_COD) {
                        handleCODPayment(request, response, order, amount, paymentMethod);
                        return;
                    } else {
                        request.setAttribute("errorMsg", "Phương thức thanh toán không được hỗ trợ");
                        request.getRequestDispatcher("cart/checkout.jsp").forward(request, response);
                        return;
                    }
                } else {
                    request.setAttribute("errorMsg", "Thiếu thông tin thanh toán!");
                    request.getRequestDispatcher("cart/checkout.jsp").forward(request, response);
                    return;
                }
            } catch (Exception e) {
                request.setAttribute("errorMsg", "Lỗi xử lý thanh toán: " + e.getMessage());
                request.getRequestDispatcher("cart/checkout.jsp").forward(request, response);
                return;
            }
        }
    }



    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

    private void handleVNPayPayment(HttpServletRequest request, HttpServletResponse response, 
                                   Order order, BigDecimal amount, PaymentMethod paymentMethod) 
            throws ServletException, IOException {
        try {
            // Tạo payment record với trạng thái pending
            Payment payment = new Payment(amount, "pending", false, order, paymentMethod);
            paymentService.createPayment(payment);


            // Tạo URL thanh toán VNPay
            String paymentUrl = vnpayService.createPaymentUrl(request, order.getOrderID(), amount.toString());

            // Lưu payment vào session để xử lý sau khi return từ VNPay
            HttpSession session = request.getSession(false);
            session.setAttribute("pendingPayment", payment);
            
            // Redirect đến VNPay
            response.sendRedirect(paymentUrl);
            
        } catch (UnsupportedEncodingException e) {
            throw new ServletException("Lỗi tạo URL thanh toán VNPay: " + e.getMessage(), e);
        }
    }

    private void handleCODPayment(HttpServletRequest request, HttpServletResponse response, 
                                   Order order, BigDecimal amount, PaymentMethod paymentMethod) 
            throws ServletException, IOException {
        try {
            Payment payment = new Payment(amount, "unpaid", false, order, paymentMethod);
            paymentService.createPayment(payment);
            HttpSession session = request.getSession(false);
            session.setAttribute("payment", payment);
            // Lấy danh sách sản phẩm của đơn hàng
            java.util.List<model.entity.OrderItem> orderItems = orderItemService.getByOrderID_Admin(order.getOrderID());
            session.setAttribute("orderItems", orderItems); // Đảm bảo success.jsp lấy được
            request.setAttribute("selectedItems", orderItems); // Có thể giữ lại nếu cần
            // Chuyển đến trang thành công rõ ràng
            request.setAttribute("successMsg", "Đặt hàng và thanh toán thành công!");
            request.getRequestDispatcher("cart/success.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("errorMsg", "Lỗi xử lý thanh toán COD: " + e.getMessage());
            request.getRequestDispatcher("cart/checkout.jsp").forward(request, response);
        }
    }

}
