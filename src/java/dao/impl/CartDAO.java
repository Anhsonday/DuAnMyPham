/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao.impl;

import dao.interfaces.ICartDAO;
import jakarta.persistence.EntityManager;
import java.util.List;
import model.entity.Cart;

/**
 *
 * @author DELL
 */
public class CartDAO extends GenericDAO<Cart, Integer> implements ICartDAO {

    public CartDAO(EntityManager em) {
        super(em, Cart.class);
    }
    
    @Override
    public List<Cart> getByUserID(int userID) {
        return em.createQuery(
            "SELECT c FROM Cart c WHERE c.user.userId = :userID", Cart.class)
        .setParameter("userID", userID)
        .getResultList();
    }
    
    @Override
    public Cart findCartWithItems(int cartID) {
    return em.createQuery(
        "SELECT c FROM Cart c LEFT JOIN FETCH c.cartItemsCollection WHERE c.cartID = :cartID", Cart.class)
        .setParameter("cartID", cartID)
        .getSingleResult();
    }

}
