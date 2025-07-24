/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service.interfaces;

import java.math.BigDecimal;
import java.util.List;
import model.entity.Cart;

/**
 *
 * @author DELL
 */
public interface ICartService {
    void createCart(Cart cart);
    void updateCart(Cart cart);
    List<Cart> getAllCarts();
    List<Cart> getByUserID(int userID);
    Cart getCartById(int id);
    Cart getCartWithItems(int cartID);
    BigDecimal getTotalAmount_User(int cartID);
    BigDecimal getTotalAmount_Admin(int cartID);
    Cart getActiveCart(int userID);
}
