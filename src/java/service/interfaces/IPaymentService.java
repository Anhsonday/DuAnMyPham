/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service.interfaces;

import java.util.List;
import model.entity.Payment;

/**
 *
 * @author DELL
 */
public interface IPaymentService {
    void createPayment(Payment payment);
    void updatePayment(Payment payment);
    void deletePayment(int id);
    List<Payment> getAllPayments();
    List<Payment> getByOrderID(int orderID);
    Payment getPaymentById(int id);
    String getNextTransactionID();
    public boolean handlePaymentFailure(Payment payment);
    void completeVNPayPayment(int orderID);
    void updatePaymentStatus(int orderID, String status);
}
