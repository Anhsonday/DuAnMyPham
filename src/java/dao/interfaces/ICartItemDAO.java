/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao.interfaces;

import java.util.List;
import model.entity.CartItem;

/**
 *
 * @author DELL
 */
public interface ICartItemDAO extends IGenericDAO<CartItem, Integer> {
    List<CartItem> getByCartID_Admin(int cartID);
    List<CartItem> getByCartID_User(int cartID);
    List<CartItem> getByCartID_UserSelected(int cartID);
    List<CartItem> getByCartID_UserCheckout(int cartID);
}
