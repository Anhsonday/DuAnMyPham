/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao.interfaces;

import java.util.List;
import model.entity.Address;

/**
 *
 * @author DELL
 */
public interface IAddressDAO extends IGenericDAO<Address, Integer> {
    List<Address> getShipAddrByUserID(int userID);
    List<Address> getBillAddrByUserID(int userID);
    List<Address> getShipAddrByUserID_Admin(int userID);
    List<Address> getBillAddrByUserID_Admin(int userID);
}
