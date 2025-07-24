/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service.impl;

import dao.impl.AddressDAO;
import dao.interfaces.IAddressDAO;
import java.util.List;
import model.entity.Address;
import service.interfaces.IAddressService;

/**
 *
 * @author DELL
 */
public class AddressService extends GenericService<Address> implements IAddressService {

    @Override
    public void createAddress(Address addr) {
        if (addr == null) {
            throw new IllegalArgumentException("Địa chỉ không hợp lệ");
        }
        doInTransaction(em -> {
            IAddressDAO addrDAO = new AddressDAO(em);
            addrDAO.add(addr);
        }, "Tạo địa chỉ thất bại");
    }

    @Override
    public void updateAddress(Address addr) {
        if (addr == null) {
            throw new IllegalArgumentException("Địa chỉ không hợp lệ");
        }
        doInTransaction(em -> {
            IAddressDAO addrDAO = new AddressDAO(em);
            addrDAO.update(addr);
        }, "Cập nhật địa chỉ thất bại");
    }
    
    @Override
    public void deleteAddress(int id) {
        if (id <= 0) {
            throw new IllegalArgumentException("Địa chỉ không hợp lệ");
        }
        doInTransaction(em -> {
            IAddressDAO addrDAO = new AddressDAO(em);
            Address addr = addrDAO.findById(id);
            if(addr != null) {
                addr.setIsDeleted(true);
                addrDAO.update(addr);
            }
        }, "Cập nhật địa chỉ thất bại");
    }

    @Override
    public List<Address> getAllAddresses() {
        return doInTransactionWithResult(em -> {
            IAddressDAO addrDAO = new AddressDAO(em);
            return addrDAO.findAll();
        }, "Lấy tất cả địa chỉ thất bại");
    }

    
    
    @Override
    public Address getAddressById(int id) {
        if (id <= 0) {
            throw new IllegalArgumentException("ID không hợp lệ");
        }
        return doInTransactionWithResult(em -> {
            IAddressDAO addrDAO = new AddressDAO(em);
            return addrDAO.findById(id);
        }, "Lấy địa chỉ theo ID thất bại");
    }

    @Override
    public List<Address> getShipAddrByUserID(int userID) {
        if (userID <= 0) {
            throw new IllegalArgumentException("ID không hợp lệ");
        }
        return doInTransactionWithResult(em -> {
            IAddressDAO addrDAO = new AddressDAO(em);
            return addrDAO.getShipAddrByUserID(userID);
        }, "Lấy tất cả địa chỉ giao hàng thất bại");
    }

    @Override
    public List<Address> getBillAddrByUserID(int userID) {
        if (userID <= 0) {
            throw new IllegalArgumentException("ID không hợp lệ");
        }
        return doInTransactionWithResult(em -> {
            IAddressDAO addrDAO = new AddressDAO(em);
            return addrDAO.getBillAddrByUserID(userID);
        }, "Lấy tất cả địa chỉ thanh toán thất bại");
    }

    @Override
    public List<Address> getShipAddrByUserID_Admin(int userID) {
        if (userID <= 0) {
            throw new IllegalArgumentException("ID không hợp lệ");
        }
        return doInTransactionWithResult(em -> {
            IAddressDAO addrDAO = new AddressDAO(em);
            return addrDAO.getShipAddrByUserID_Admin(userID);
        }, "Lấy tất cả địa chỉ giao hàng thất bại");
    }

    @Override
    public List<Address> getBillAddrByUserID_Admin(int userID) {
        if (userID <= 0) {
            throw new IllegalArgumentException("ID không hợp lệ");
        }
        return doInTransactionWithResult(em -> {
            IAddressDAO addrDAO = new AddressDAO(em);
            return addrDAO.getBillAddrByUserID_Admin(userID);
        }, "Lấy tất cả địa chỉ thanh toán thất bại");
    }
    
}
