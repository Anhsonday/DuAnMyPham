/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao.interfaces;

import java.util.List;
import model.entity.OrderItem;

/**
 *
 * @author DELL
 */
public interface IOrderItemDAO extends IGenericDAO<OrderItem, Integer> {
    List<OrderItem> getByOrderID_Admin(int orderID);
    List<OrderItem> getByOrderID_User(int orderID);
}
