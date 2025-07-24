/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service.interfaces;

import java.util.List;
import model.entity.Address;
/**
 *
 * @author DELL
 */
public interface IAddressService {
    void createAddress(Address Addr);
    void updateAddress(Address Addr);
    void deleteAddress(int id);
    List<Address> getAllAddresses();
    Address getAddressById(int id);
    List<Address> getShipAddrByUserID(int userID);
    List<Address> getBillAddrByUserID(int userID);
    List<Address> getShipAddrByUserID_Admin(int userID);
    List<Address> getBillAddrByUserID_Admin(int userID);
}
