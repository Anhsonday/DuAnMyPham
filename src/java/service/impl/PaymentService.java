/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service.impl;

import dao.interfaces.IPaymentDAO;
import dao.impl.PaymentDAO;
import dao.interfaces.IPaymentMethodDAO;
import dao.impl.PaymentMethodDAO;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import model.entity.PaymentMethod;
import java.util.List;
import model.entity.Order;
import model.entity.Payment;
import service.interfaces.OrderService;
import service.impl.OrderServiceImpl;
import service.interfaces.IPaymentService;
import dao.interfaces.IOrderItemDAO;
import dao.impl.OrderItemDAO;
import model.entity.OrderItem;
import model.entity.Product;
import service.interfaces.IOrderItemService;
import service.impl.OrderItemService;

/**
 *
 * @author DELL
 */
public class PaymentService extends GenericService<Payment> implements IPaymentService {

    @Override
    public void createPayment(Payment payment) {
        doInTransaction(em -> {
            if(payment == null) {
                throw new IllegalArgumentException("Thanh toán không hợp lệ");
            }
            Order order = payment.getOrder();
            if(order == null) {
                throw new IllegalArgumentException(order + "Đơn hàng không tồn tại cho thanh toán này");
            }
            
            // Kiểm tra trạng thái order hợp lệ (ví dụ chỉ cho phép khi pending)
            if(order.getStatus() != null && !order.getStatus().equalsIgnoreCase("pending")) {
                throw new IllegalArgumentException("Chỉ có thể thanh toán cho đơn hàng ở trạng thái pending");
            }
            
            IPaymentDAO paymentDAO = new PaymentDAO(em);
            payment.setTransactionID(getNextTransactionID());
            
            if (payment.getPaymentMethod() == null) {
                throw new IllegalArgumentException("Phương thức thanh toán không được để trống");
            }
            
            // Xử lý trạng thái payment dựa trên phương thức thanh toán
            if(PaymentMethod.PAYMENT_METHOD_COD == payment.getPaymentMethod().getPaymentMethodID()) {
                payment.setStatus("unpaid"); // COD - chưa thanh toán
                // COD được xử lý ngay lập tức, cập nhật order status
                OrderService orderService = new OrderServiceImpl();
                order.setStatus("confirmed");
                orderService.updateOrderWithEntityManager(em, order);
                orderService.confirmOrder(em, order.getOrderID());
                // Trừ stock sản phẩm
                IOrderItemService orderItemService = new OrderItemService();
                List<OrderItem> orderItems = orderItemService.getByOrderID_Admin(order.getOrderID());
                for (OrderItem oi : orderItems) {
                    Product p = oi.getProduct();
                    if (p != null) {
                        int newStock = p.getStock() - oi.getQuantity();
                        p.setStock(Math.max(newStock, 0));
                        em.merge(p);
                    }
                }
                // TODO: Clear cart ở đây nếu cần (tuỳ vào session hoặc DB)
            } else if(PaymentMethod.PAYMENT_METHOD_VNPAY == payment.getPaymentMethod().getPaymentMethodID()) {
                payment.setStatus("pending"); // VNPay - đang chờ thanh toán
            } else {
                payment.setStatus("pending"); // Mặc định cho các phương thức khác
            }
            
            paymentDAO.add(payment);
        }, "Tạo thanh toán thất bại");
    }

    @Override
    public void updatePayment(Payment payment) {
        doInTransaction(em -> {
            if(payment == null) {
                throw new IllegalArgumentException("Thanh toán không hợp lệ");
            }
            IPaymentDAO paymentDAO = new PaymentDAO(em);
            paymentDAO.update(payment);
        }, "Cập nhật thanh toán thất bại");
    }
    
    @Override
    public void deletePayment(int id){
        if(id <= 0) {
            throw new IllegalArgumentException("ID không hợp lệ");
        }
        doInTransaction(em -> {
            IPaymentDAO paymentDAO = new PaymentDAO(em);
            Payment payment = paymentDAO.findById(id);
            if(payment == null) {
                throw new IllegalArgumentException("Không tìm thấy thanh toán để xóa");
            }
            payment.setIsDeleted(true);
            paymentDAO.update(payment);
        }, "Xóa thanh toán thất bại");
    }

    @Override
    public List<Payment> getAllPayments() {
        return doInTransactionWithResult(em -> {
            IPaymentDAO paymentDAO = new PaymentDAO(em);
            return paymentDAO.findAll();
        }, "Lấy tất cả thanh toán thất bại");
    }

    @Override
    public List<Payment> getByOrderID(int orderID) {
        if(orderID <= 0) {
            throw new IllegalArgumentException("ID không hợp lệ");
        }
        return doInTransactionWithResult(em -> {
            IPaymentDAO paymentDAO = new PaymentDAO(em);
            return paymentDAO.getByOrderID(orderID);
        }, "Lấy tất cả thanh toán thất bại");
    }

    @Override
    public Payment getPaymentById(int id) {
        if(id <= 0) {
            throw new IllegalArgumentException("ID không hợp lệ");
        }
        return doInTransactionWithResult(em -> {
            IPaymentDAO paymentDAO = new PaymentDAO(em);
            return paymentDAO.findById(id);
        }, "Lấy thanh toán theo ID thất bại");
    }

    @Override
    public String getNextTransactionID() {
        String datePart = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyyMMdd"));
        int max = doInTransactionWithResult(em -> {
            IPaymentDAO paymentDAO = new PaymentDAO(em);
            return paymentDAO.getMaxTransactionNumberByDate(datePart);
        }, "Lấy transactionID lớn nhất thất bại");
        // Đảm bảo format đúng, tránh lỗi substring
        return String.format("TXN-%s-%03d", datePart, max + 1);
    }

    @Override
    public boolean handlePaymentFailure(Payment payment) {
        return doInTransactionWithResult(em -> {
            IPaymentDAO paymentDAO = new PaymentDAO(em);
            int failedCount = paymentDAO.countFailedByOrderID(payment.getOrder().getOrderID());

            if (failedCount >= 5) {
                OrderService orderService = new OrderServiceImpl();
                orderService.cancelOrder(payment.getOrder().getOrderID());
                return true;
            }
            return false;
        }, "Xử lý thất bại thanh toán lỗi");
    }
    
    @Override
    public void completeVNPayPayment(int orderID) {
        doInTransaction(em -> {
            IPaymentDAO paymentDAO = new PaymentDAO(em);
            var payments = paymentDAO.getByOrderID(orderID);
            if (!payments.isEmpty()) {
                Payment payment = payments.get(0);
                payment.setStatus("paid");
                paymentDAO.update(payment);
                // Cập nhật order status
                OrderService orderService = new OrderServiceImpl();
                Order order = payment.getOrder();
                order.setStatus("confirmed");
                orderService.updateOrderWithEntityManager(em, order);
                orderService.confirmOrder(em, order.getOrderID());
                // Trừ stock sản phẩm
                IOrderItemService orderItemService = new OrderItemService();
                List<OrderItem> orderItems = orderItemService.getByOrderID_Admin(order.getOrderID());
                for (OrderItem oi : orderItems) {
                    Product p = oi.getProduct();
                    if (p != null) {
                        int newStock = p.getStock() - oi.getQuantity();
                        p.setStock(Math.max(newStock, 0));
                        em.merge(p);
                    }
                }
                // TODO: Clear cart ở đây nếu cần (tuỳ vào session hoặc DB)
            }
        }, "Hoàn tất thanh toán VNPay thất bại");
    }
    
    @Override    
    public void updatePaymentStatus(int orderID, String status) {
        try {
            // Lấy payment theo orderID
            var payments = getByOrderID(orderID);
            if (!payments.isEmpty()) {
                Payment payment = payments.get(0); // Lấy payment đầu tiên
                payment.setStatus(status);
                updatePayment(payment);
            }
        } catch (Exception e) {
        }
    }
    
}
