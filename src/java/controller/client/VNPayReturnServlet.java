
package controller.client;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import service.impl.VNPayService;
import service.impl.PaymentService;
import service.impl.OrderServiceImpl;
import service.interfaces.IPaymentService;
import service.interfaces.OrderService;
import model.entity.Order;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.logging.Logger;
import java.util.Map;

@WebServlet("/vnpay-return")
public class VNPayReturnServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(VNPayReturnServlet.class.getName());
    private VNPayService vnpayService;
    private IPaymentService paymentService;
    private OrderService orderService; // Thêm dòng này

    @Override
    public void init() throws ServletException {
        vnpayService = new VNPayService();
        paymentService = new PaymentService();
        orderService = new OrderServiceImpl(); // Thêm dòng này
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(); // Sửa: luôn tạo session nếu chưa có
        // Log toàn bộ query string và các tham số callback
        LOGGER.info("[VNPayReturnServlet] QueryString: " + request.getQueryString());
        LOGGER.info("[VNPayReturnServlet] vnp_TxnRef: " + request.getParameter("vnp_TxnRef") + ", vnp_ResponseCode: " + request.getParameter("vnp_ResponseCode") + ", vnp_Amount: " + request.getParameter("vnp_Amount"));
        // Log toàn bộ parameter map
        Map<String, String[]> paramMap = request.getParameterMap();
        StringBuilder paramLog = new StringBuilder("[VNPayReturnServlet] All Params: ");
        for (String key : paramMap.keySet()) {
            paramLog.append(key).append("=").append(java.util.Arrays.toString(paramMap.get(key))).append("; ");
        }
        LOGGER.info(paramLog.toString());
        // Log trạng thái session
        LOGGER.info("[VNPayReturnServlet] Session: " + (session == null ? "null" : "id=" + session.getId()));
        try {
            // Log trước validateResponse
            LOGGER.info("[VNPayReturnServlet] Trước validateResponse");
            boolean valid = vnpayService.validateResponse(request);
            LOGGER.info("[VNPayReturnServlet] validateResponse result: " + valid);
            if (valid) {
                String vnp_ResponseCode = request.getParameter("vnp_ResponseCode");
                String vnp_TxnRef = request.getParameter("vnp_TxnRef");
                int orderID = Integer.parseInt(vnp_TxnRef);

                LOGGER.info("VNPay response for order #" + orderID + ": ResponseCode=" + vnp_ResponseCode);

                if ("00".equals(vnp_ResponseCode)) {
                    // Thanh toán thành công
                    LOGGER.info("Payment successful for order #" + orderID);
                    paymentService.completeVNPayPayment(orderID);
                    Order order = orderService.getOrderById(orderID);
                    session.setAttribute("order", order);
                    service.impl.OrderItemService orderItemService = new service.impl.OrderItemService();
                    java.util.List<model.entity.OrderItem> orderItems = orderItemService.getByOrderID_Admin(orderID);
                    session.setAttribute("orderItems", orderItems);
                    session.setAttribute("orderNumber", order.getOrderNumber());
                    session.setAttribute("paymentMethod", "Thanh toán qua VNPay");
                    session.setAttribute("finalAmount", order.getFinalAmount());
                    LOGGER.info("[VNPayReturnServlet] Đã set order, orderItems, orderNumber, paymentMethod, finalAmount vào session cho orderID=" + orderID);
                    LOGGER.info("[VNPayReturnServlet] Redirecting to cart/success.jsp");
                    response.sendRedirect("cart/success.jsp");
                } else {
                    // Thanh toán thất bại
                    LOGGER.warning("Payment failed for order #" + orderID + ". ResponseCode: " + vnp_ResponseCode);
                    paymentService.updatePaymentStatus(orderID, "failed");
                    request.setAttribute("errorMessage", "Thanh toán thất bại: Mã lỗi " + vnp_ResponseCode);
                    LOGGER.info("[VNPayReturnServlet] Forwarding to cart/checkout.jsp (payment failed)");
                    request.getRequestDispatcher("cart/checkout.jsp").forward(request, response);
                }
            } else {
                // Xác thực thất bại
                LOGGER.warning("VNPay response validation failed.");
                request.setAttribute("errorMessage", "Xác thực thanh toán không thành công.");
                LOGGER.info("[VNPayReturnServlet] Forwarding to cart/checkout.jsp (validateResponse false)");
                request.getRequestDispatcher("cart/checkout.jsp").forward(request, response);
            }
        } catch (UnsupportedEncodingException e) {
            LOGGER.severe("Encoding error during VNPay response validation: " + e.getMessage());
            request.setAttribute("errorMessage", "Lỗi mã hóa khi xác thực phản hồi từ VNPay: " + e.getMessage());
            LOGGER.info("[VNPayReturnServlet] Forwarding to cart/checkout.jsp (UnsupportedEncodingException)");
            request.getRequestDispatcher("cart/checkout.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            LOGGER.severe("Invalid order ID format in vnp_TxnRef: " + e.getMessage());
            request.setAttribute("errorMessage", "Lỗi định dạng mã đơn hàng: " + e.getMessage());
            LOGGER.info("[VNPayReturnServlet] Forwarding to cart/checkout.jsp (NumberFormatException)");
            request.getRequestDispatcher("cart/checkout.jsp").forward(request, response);
        } catch (Exception e) {
            LOGGER.severe("Unexpected error during VNPay return processing: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi xử lý phản hồi từ VNPay: " + e.getMessage());
            LOGGER.info("[VNPayReturnServlet] Forwarding to cart/checkout.jsp (Exception)");
            request.getRequestDispatcher("cart/checkout.jsp").forward(request, response);
        }
    }

}
