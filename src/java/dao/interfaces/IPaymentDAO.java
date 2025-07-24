/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao.interfaces;

import java.util.List;
import model.entity.Payment;

/**
 *
 * @author DELL
 */
public interface IPaymentDAO extends IGenericDAO<Payment, Integer> {
    List<Payment> getByOrderID(int orderID);
    int countFailedByOrderID(int orderId);
    /**
     * Lấy số thứ tự lớn nhất của transactionID trong ngày (theo datePart yyyyMMdd)
     * @param datePart chuỗi ngày dạng yyyyMMdd
     * @return số thứ tự lớn nhất, nếu không có trả về 0
     */
    int getMaxTransactionNumberByDate(String datePart);
}
