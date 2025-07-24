/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service.interfaces;

import jakarta.persistence.EntityManager;
import java.util.List;
import model.entity.CartItem;
import model.entity.Order;
import model.entity.OrderItem;

/**
 *
 * @author DELL
 */
public interface IOrderItemService {
    void createOrderItemFromSelected(List<CartItem> selected, Order order);
    void updateOrderItem(OrderItem oi);
    void deleteOrderItem(int id);
    List<OrderItem> getAllOrderItems();
    List<OrderItem> getByOrderID_Admin(int orderID);
    List<OrderItem> getByOrderID_User(int orderID);
    OrderItem getOrderItemByID(int id);
    void reserveProduct(EntityManager em, OrderItem oi);
}
