/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao.impl;

import dao.interfaces.IPaymentDAO;
import jakarta.persistence.EntityManager;
import java.util.List;
import model.entity.Payment;

/**
 *
 * @author DELL
 */
public class PaymentDAO extends GenericDAO<Payment, Integer> implements IPaymentDAO {
    
    public PaymentDAO(EntityManager em) {
        super(em, Payment.class);
    }
    
    @Override
    public List<Payment> getByOrderID(int orderID) {
        return em.createQuery(
            "SELECT p FROM Payment p WHERE p.order.orderID = :orderID", Payment.class)
            .setParameter("orderID", orderID)
            .getResultList();
    }
    
    @Override
    public int countFailedByOrderID(int orderId) {
    return em.createQuery(
        "SELECT COUNT(p) FROM Payment p WHERE p.order.orderId = :orderId AND p.status = 'failed'", Long.class)
        .setParameter("orderId", orderId)
        .getSingleResult()
        .intValue();
    }

    /**
     * Lấy số thứ tự lớn nhất của transactionID trong ngày (theo datePart yyyyMMdd)
     * @param datePart chuỗi ngày dạng yyyyMMdd
     * @return số thứ tự lớn nhất, nếu không có trả về 0
     */
    @Override
    public int getMaxTransactionNumberByDate(String datePart) {
        // transactionID dạng: TXN-yyyyMMdd-xxx
        String prefix = "TXN-" + datePart + "-";
        List<String> ids = em.createQuery(
            "SELECT p.transactionID FROM Payment p WHERE p.transactionID LIKE :prefix", String.class)
            .setParameter("prefix", prefix + "%")
            .getResultList();
        int max = 0;
        for (String id : ids) {
            try {
                // Kiểm tra null và độ dài trước khi substring
                if (id != null && !id.trim().isEmpty() && id.length() >= 17) {
                    String numPart = id.substring(13); // TXN-YYYYMMDD-xxx
                    if (numPart != null && !numPart.trim().isEmpty()) {
                        int num = Integer.parseInt(numPart);
                        if (num > max) max = num;
                    }
                }
            } catch (Exception e) {
                // Bỏ qua nếu lỗi format

            }
        }
        return max;
    }

}
