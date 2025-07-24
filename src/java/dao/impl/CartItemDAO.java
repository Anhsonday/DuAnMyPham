/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao.impl;

import dao.interfaces.ICartItemDAO;
import jakarta.persistence.EntityManager;
import java.util.List;
import model.entity.CartItem;

/**
 *
 * @author DELL
 */
public class CartItemDAO extends GenericDAO<CartItem, Integer> implements ICartItemDAO {

    public CartItemDAO(EntityManager em) {
        super(em, CartItem.class);
    }
    
    @Override
    public List<CartItem> getByCartID_Admin(int cartID) {
        return em.createQuery(
            "SELECT ci FROM CartItem ci JOIN FETCH ci.product p LEFT JOIN FETCH p.productImagesCollection WHERE ci.cart.cartID = :cartID",
            CartItem.class)
            .setParameter("cartID", cartID)
            .getResultList();
    }

    @Override
    public List<CartItem> getByCartID_User(int cartID) {
        return em.createQuery(
            "SELECT ci FROM CartItem ci JOIN FETCH ci.product p LEFT JOIN FETCH p.productImagesCollection WHERE ci.cart.cartID = :cartID AND ci.status != 'checkout' AND ci.isDeleted = false",
            CartItem.class)
            .setParameter("cartID", cartID)
            .getResultList();
    }

    @Override
    public List<CartItem> getByCartID_UserSelected(int cartID) {
        return em.createQuery(
            "SELECT ci FROM CartItem ci JOIN FETCH ci.product p LEFT JOIN FETCH p.productImagesCollection WHERE ci.cart.cartID = :cartID AND ci.status = 'selected' AND ci.isDeleted = false",
            CartItem.class)
            .setParameter("cartID", cartID)
            .getResultList();
    }

    @Override
    public List<CartItem> getByCartID_UserCheckout(int cartID) {
        return em.createQuery(
            "SELECT ci FROM CartItem ci WHERE ci.cart.cartID = :cartID AND ci.status = 'checkout'", CartItem.class)
        .setParameter("cartID", cartID)
        .getResultList();
    }
    
}
