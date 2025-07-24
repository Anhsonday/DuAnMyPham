/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao.impl;

import dao.interfaces.IOrderItemDAO;
import jakarta.persistence.EntityManager;
import java.util.List;
import model.entity.OrderItem;

/**
 *
 * @author DELL
 */
public class OrderItemDAO extends GenericDAO<OrderItem, Integer> implements IOrderItemDAO {

    public OrderItemDAO(EntityManager em) {
        super(em, OrderItem.class);
    }
    
    @Override
    public List<OrderItem> getByOrderID_Admin(int orderID) {
        System.out.println("[DEBUG][OrderItemDAO] Truy vấn OrderItem với orderID=" + orderID);
        try {
            List<OrderItem> result = em.createQuery(
                "SELECT oi FROM OrderItem oi JOIN FETCH oi.product p LEFT JOIN FETCH p.productImagesCollection WHERE oi.order.orderID = :orderID", OrderItem.class)
                .setParameter("orderID", orderID)
                .getResultList();
            System.out.println("[DEBUG][OrderItemDAO] Số lượng OrderItem trả về: " + (result == null ? "null" : result.size()));
            return result;
        } catch (Exception e) {
            System.out.println("[DEBUG][OrderItemDAO] Exception: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }
    
    @Override
    public List<OrderItem> getByOrderID_User(int orderID) {
        return em.createQuery(
            "SELECT oi FROM OrderItem oi WHERE oi.order.orderID = :orderID AND oi.isDeleted = false", OrderItem.class)
        .setParameter("orderID", orderID)
        .getResultList();
    }
    
}
