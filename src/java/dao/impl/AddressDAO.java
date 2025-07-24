/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao.impl;

import dao.interfaces.IAddressDAO;
import jakarta.persistence.EntityManager;
import java.util.List;
import model.entity.Address;

/**
 *
 * @author DELL
 */
public class AddressDAO extends GenericDAO<Address,Integer> implements IAddressDAO {
    
    public AddressDAO(EntityManager em) {
        super(em, Address.class);
    }

    @Override
    public List<Address> getShipAddrByUserID(int userID) {
        return em.createQuery(
            "SELECT a FROM Address a WHERE a.user.userId = :userID AND a.addressType = 'shipping' AND a.isDeleted = false", Address.class)
        .setParameter("userID", userID)
        .getResultList();
    }
    
    @Override
    public List<Address> getBillAddrByUserID(int userID) {
        return em.createQuery(
            "SELECT a FROM Address a WHERE a.user.userId = :userID AND a.addressType = 'billing' AND a.isDeleted = false", Address.class)
        .setParameter("userID", userID)
        .getResultList();
    }

    @Override
    public List<Address> getShipAddrByUserID_Admin(int userID) {
        return em.createQuery(
            "SELECT a FROM Address a WHERE a.user.userId = :userID AND a.addressType = 'shipping'", Address.class)
        .setParameter("userID", userID)
        .getResultList();
    }
    
    @Override
    public List<Address> getBillAddrByUserID_Admin(int userID) {
        return em.createQuery(
            "SELECT a FROM Address a WHERE a.user.userId = :userID AND a.addressType = 'billing'", Address.class)
        .setParameter("userID", userID)
        .getResultList();
    }

}
