/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao.impl;

import dao.interfaces.IPaymentMethodDAO;
import jakarta.persistence.EntityManager;
import model.entity.PaymentMethod;

/**
 *
 * @author DELL
 */
public class PaymentMethodDAO extends GenericDAO<PaymentMethod, Integer> implements IPaymentMethodDAO {
    
    public PaymentMethodDAO(EntityManager em) {
        super(em, PaymentMethod.class);
    }
    
}
