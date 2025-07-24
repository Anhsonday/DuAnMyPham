    /*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service.impl;

import dao.impl.CartItemDAO;
import dao.impl.ProductDAOImpl;
import dao.interfaces.ICartItemDAO;
import dao.interfaces.ProductDAO;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityNotFoundException;
import java.util.List;
import model.entity.CartItem;
import model.entity.Product;
import service.interfaces.ICartItemService;

/**
 *
 * @author DELL
 */
public class CartItemService extends GenericService<CartItem> implements ICartItemService {

    @Override
    public void createCartItem(CartItem ci) {
        if (ci == null) {
            throw new IllegalArgumentException("Sản phẩm trong giỏ không hợp lệ");
        }
        doInTransaction(em -> {
            checkStock(em, ci);
            ICartItemDAO cartItemDAO = new CartItemDAO(em);
            // Chỉ lấy CartItem đang hoạt động (isDeleted=false, status='pending')
            CartItem existing = cartItemDAO.getByCartID_Admin(ci.getCart().getCartID()).stream()
                .filter(item -> item.getProduct().getProductId().equals(ci.getProduct().getProductId())
                    && !item.isIsDeleted()
                    && "pending".equalsIgnoreCase(item.getStatus()))
                .findFirst().orElse(null);

            if (existing != null) {
                System.out.println("[DEBUG][CartItemService] Đã có sản phẩm trong giỏ (pending): productId=" + ci.getProduct().getProductId() + ", cộng dồn quantity: " + existing.getQuantity() + " + " + ci.getQuantity());
                existing.setQuantity(existing.getQuantity() + ci.getQuantity());
                cartItemDAO.update(existing);
            } else {
                System.out.println("[DEBUG][CartItemService] Thêm sản phẩm mới vào giỏ: productId=" + ci.getProduct().getProductId() + ", quantity=" + ci.getQuantity());
                try {
                    cartItemDAO.add(ci);
                } catch (Exception e) {
                    System.out.println("[ERROR][CartItemService] Lỗi khi add CartItem mới: " + e.getMessage());
                    throw e;
                }
            }
        }, "Thêm sản phẩm vào giỏ thất bại");
    }

    @Override
    public void updateCartItem(CartItem ci) {
        if (ci == null) {
            throw new IllegalArgumentException("Sản phẩm trong giỏ không hợp lệ");
        }
        doInTransaction(em -> {
            checkStock(em, ci);
            ICartItemDAO cartItemDAO = new CartItemDAO(em);
            CartItem existing = cartItemDAO.findById(ci.getCartItemID());
            if (existing != null) {
                existing.setQuantity(ci.getQuantity());
                existing.setStatus(ci.getStatus());
                cartItemDAO.update(existing);
            }
        }, "Cập nhật sản phẩm trong giỏ thất bại");
    }
    
    @Override
    public void deletedCartItem(int id) {
        if (id <= 0) {
            throw new IllegalArgumentException("ID không hợp lệ");
        }
        doInTransaction(em -> {
            ICartItemDAO cartItemDAO = new CartItemDAO(em);
            CartItem ci = cartItemDAO.findById(id);
            if(ci != null) {
                ci.setIsDeleted(true);
                cartItemDAO.update(ci);
            }
        }, "Cập nhật sản phẩm trong giỏ thất bại");
    }

    @Override
    public List<CartItem> getAllByCartID_Admin(int cartID) {
        if (cartID <= 0) {
            throw new IllegalArgumentException("Không tìm thấy giỏ hàng");
        }
        return doInTransactionWithResult(em -> {
            ICartItemDAO cartItemDAO = new CartItemDAO(em);
            return cartItemDAO.getByCartID_Admin(cartID);
        }, "Lấy tất cả sản phẩm trong giỏ thất bại");
    }

    @Override
    public List<CartItem> getAllByCartID_User(int cartID) {
        if (cartID <= 0) {
            throw new IllegalArgumentException("ID không hợp lệ");
        }
        return doInTransactionWithResult(em -> {
            ICartItemDAO cartItemDAO = new CartItemDAO(em);
            return cartItemDAO.getByCartID_User(cartID);
        }, "Lấy tất cả sản phẩm trong giỏ thất bại");
    }
    
    @Override
    public List<CartItem> getAllByCartID_UserSelected(int cartID) {
        if (cartID <= 0) {
            throw new IllegalArgumentException("ID không hợp lệ");
        }
        return doInTransactionWithResult(em -> {
            ICartItemDAO cartItemDAO = new CartItemDAO(em);
            return cartItemDAO.getByCartID_UserSelected(cartID);
        }, "Lấy tất cả sản phẩm đã chọn trong giỏ thất bại");
    }
    
    @Override
    public List<CartItem> getAllByCartID_UserCheckout(int cartID) {
        if (cartID <= 0) {
            throw new IllegalArgumentException("ID không hợp lệ");
        }
        return doInTransactionWithResult(em -> {
            ICartItemDAO cartItemDAO = new CartItemDAO(em);
            return cartItemDAO.getByCartID_UserCheckout(cartID);
        }, "Lấy tất cả sản phẩm đã mua trong giỏ thất bại");
    }

    @Override
    public CartItem getCartItemById(int id) {
        if (id <= 0) {
            throw new IllegalArgumentException("ID không hợp lệ");
        }
        return doInTransactionWithResult(em -> {
            ICartItemDAO cartItemDAO = new CartItemDAO(em);
            return cartItemDAO.findById(id);
        }, "Lấy sản phẩm trong giỏ theo ID thất bại");
    }

    @Override
    public void checkStock(EntityManager em, CartItem ci) {
        if (ci == null) {
            throw new IllegalArgumentException("Sản phẩm trong giỏ không hợp lệ");
        }
        ProductDAO productDAO = new ProductDAOImpl(em);
        Product p = productDAO.findById(ci.getProduct().getProductId());
        if (p == null) {
            throw new EntityNotFoundException("Không tìm thấy sản phẩm với ID: " + ci.getProduct().getProductId());
        }
        int available = p.getStock() - p.getReservedQuantity();
        if (available < ci.getQuantity()) {
            throw new IllegalStateException("Không đủ hàng tồn kho cho sản phẩm với ID: " + p.getProductId());
        }
    }
    
}
