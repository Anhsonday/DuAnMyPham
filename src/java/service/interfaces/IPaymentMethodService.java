/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service.interfaces;

import java.util.List;
import model.entity.PaymentMethod;

/**
 *
 * @author DELL
 */
public interface IPaymentMethodService extends IGenericService<PaymentMethod> {
    void createMethod(PaymentMethod method);
    void updateMethod(PaymentMethod method);
    List<PaymentMethod> getAllMethods();
    PaymentMethod getMethodById(int id);
    void ensureVNPayMethodExists();
    String getPaymentMethodsDebugInfo();
}
