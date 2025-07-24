/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao.interfaces;

import java.util.List;
import model.entity.Cart;

/**
 *
 * @author DELL
 */
public interface ICartDAO extends IGenericDAO<Cart, Integer> {
    List<Cart> getByUserID(int userID);
    Cart findCartWithItems(int cartID);
}
