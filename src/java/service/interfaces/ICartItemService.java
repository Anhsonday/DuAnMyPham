/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service.interfaces;

import jakarta.persistence.EntityManager;
import java.util.List;
import model.entity.CartItem;

/**
 *
 * @author DELL
 */
public interface ICartItemService {
    void createCartItem(CartItem ci);
    void updateCartItem(CartItem ci);
    void deletedCartItem(int id);
    List<CartItem> getAllByCartID_Admin(int cartID);
    List<CartItem> getAllByCartID_User(int cartID);
    List<CartItem> getAllByCartID_UserSelected(int cartID);
    List<CartItem> getAllByCartID_UserCheckout(int cartID);
    CartItem getCartItemById(int id);
    void checkStock(EntityManager em, CartItem ci);
}
