/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service.impl;

import dao.impl.PaymentMethodDAO;
import dao.interfaces.IPaymentMethodDAO;
import java.util.List;
import model.entity.PaymentMethod;
import service.interfaces.IPaymentMethodService;
import java.util.logging.Logger;

/**
 *
 * @author DELL
 */
public class PaymentMethodService extends GenericService<PaymentMethod> implements IPaymentMethodService {

    @Override
    public void createMethod(PaymentMethod method) {
        if (method == null) {
            throw new IllegalArgumentException("Phương thức thanh toán không hợp lệ");
        }
        doInTransaction(em -> {
            IPaymentMethodDAO methodDAO = new PaymentMethodDAO(em);
            methodDAO.add(method);
        }, "Tạo phương thức thanh toán thất bại");
    }

    @Override
    public void updateMethod(PaymentMethod method) {
        if (method == null) {
            throw new IllegalArgumentException("Phương thức thanh toán không hợp lệ");
        }
        doInTransaction(em -> {
            IPaymentMethodDAO methodDAO = new PaymentMethodDAO(em);
            methodDAO.update(method);
        }, "Cập nhật phương thức thanh toán thất bại");
    }

    @Override
    public List<PaymentMethod> getAllMethods() {
        return doInTransactionWithResult(em -> {
            IPaymentMethodDAO methodDAO = new PaymentMethodDAO(em);
            return methodDAO.findAll();
        }, "Lấy tất cả phương thức thanh toán thất bại");
    }

    @Override
    public PaymentMethod getMethodById(int id) {
        return doInTransactionWithResult(em -> {
            IPaymentMethodDAO methodDAO = new PaymentMethodDAO(em);
            return methodDAO.findById(id);
        }, "Lấy phương thức thanh toán theo ID thất bại");
    }

    @Override
    public void ensureVNPayMethodExists() {
        doInTransaction(em -> {
            IPaymentMethodDAO methodDAO = new PaymentMethodDAO(em);
            
            Logger.getLogger(PaymentMethodService.class.getName()).info("Checking if VNPay payment method exists...");
            
            // Kiểm tra xem VNPay method đã tồn tại chưa
            PaymentMethod vnpayMethod = methodDAO.findById(PaymentMethod.PAYMENT_METHOD_VNPAY);
            if (vnpayMethod == null) {
                // Tạo VNPay payment method nếu chưa tồn tại
                PaymentMethod newVNPayMethod = new PaymentMethod(
                    PaymentMethod.PAYMENT_METHOD_VNPAY,
                    "Thanh toán qua VNPay",
                    "Thanh toán trực tuyến an toàn qua cổng thanh toán VNPay",
                    false
                );
                methodDAO.add(newVNPayMethod);
                Logger.getLogger(PaymentMethodService.class.getName()).info("Created VNPay payment method with ID: " + PaymentMethod.PAYMENT_METHOD_VNPAY);
            } else {
                Logger.getLogger(PaymentMethodService.class.getName()).info("VNPay payment method already exists with ID: " + vnpayMethod.getPaymentMethodID());
                // Cập nhật thông tin nếu đã tồn tại nhưng thông tin không đúng
                if (!"Thanh toán qua VNPay".equals(vnpayMethod.getMethodName())) {
                    vnpayMethod.setMethodName("Thanh toán qua VNPay");
                    vnpayMethod.setDescription("Thanh toán trực tuyến an toàn qua cổng thanh toán VNPay");
                    methodDAO.update(vnpayMethod);
                    Logger.getLogger(PaymentMethodService.class.getName()).info("Updated VNPay payment method information");
                }
            }
        }, "Đảm bảo VNPay payment method tồn tại thất bại");
    }
    
    @Override
    public String getPaymentMethodsDebugInfo() {
        return doInTransactionWithResult(em -> {
            IPaymentMethodDAO methodDAO = new PaymentMethodDAO(em);
            List<PaymentMethod> methods = methodDAO.findAll();
            
            StringBuilder info = new StringBuilder();
            info.append("Total payment methods: ").append(methods.size()).append("\n");
            
            for (PaymentMethod method : methods) {
                info.append("ID: ").append(method.getPaymentMethodID())
                     .append(", Name: ").append(method.getMethodName())
                     .append(", Description: ").append(method.getDescription())
                     .append(", IsDeleted: ").append(method.getIsDeleted())
                     .append("\n");
            }
            
            return info.toString();
        }, "Lấy thông tin debug payment methods thất bại");
    }
}
