package service.impl;

import dao.impl.CartDAO;
import dao.interfaces.ICartDAO;
import java.math.BigDecimal;
import java.util.List;
import model.entity.Cart;
import model.entity.CartItem;
import service.interfaces.ICartService;
import jakarta.persistence.EntityNotFoundException;
import java.util.Collection;
import service.interfaces.ICartItemService;

/**
 *
 * @author DELL
 */
public class CartService extends GenericService<Cart> implements ICartService {

    @Override
    public void createCart(Cart cart) {
        if (cart == null) {
            throw new IllegalArgumentException("Giỏ hàng không hợp lệ");
        }
        doInTransaction(em -> {
            ICartDAO cartDAO = new CartDAO(em);
            cartDAO.add(cart);
        }, "Tạo giỏ hàng thất bại");
    }
    
    @Override
    public void updateCart(Cart cart) {
        if (cart == null) {
            throw new IllegalArgumentException("Giỏ hàng không hợp lệ");
        }
        doInTransaction(em -> {
            ICartDAO cartDAO = new CartDAO(em);
            cartDAO.update(cart);
        }, "Cập nhật giỏ hàng thất bại");
    }

    @Override
    public List<Cart> getAllCarts() {
        return doInTransactionWithResult(em -> {
            ICartDAO cartDAO = new CartDAO(em);
            return cartDAO.findAll();
        }, "Lấy tất cả giỏ hàng thất bại");
    }

    @Override
    public List<Cart> getByUserID(int userID) {
        if (userID <= 0) {
            throw new IllegalArgumentException("ID không hợp lệ");
        }
        return doInTransactionWithResult(em -> {
            ICartDAO cartDAO = new CartDAO(em);
            return cartDAO.getByUserID(userID);
        }, "Lấy giỏ hàng theo người dùng thất bại");
    }

    @Override
    public Cart getCartById(int id) {
        if (id <= 0) {
            throw new IllegalArgumentException("ID không hợp lệ");
        }
        return doInTransactionWithResult(em -> {
            ICartDAO cartDAO = new CartDAO(em);
            return cartDAO.findById(id);
        }, "Lấy giỏ hàng theo ID thất bại");
    }
    
    @Override
    public Cart getCartWithItems(int cartID) {
        if (cartID <= 0) {
            throw new IllegalArgumentException("ID không hợp lệ");
        }
        return doInTransactionWithResult(em -> {
            ICartDAO cartDAO = new CartDAO(em);
            return cartDAO.findCartWithItems(cartID);
        }, "Lấy giỏ hàng theo ID thất bại");
    }

    @Override
    public BigDecimal getTotalAmount_User(int cartID) {
        if (cartID <= 0) {
            throw new IllegalArgumentException("ID không hợp lệ");
        }
        Cart cart = getCartWithItems(cartID);
        if (cart == null) {
            throw new EntityNotFoundException("Không tìm thấy giỏ hàng");
        }
        Collection<CartItem> items = cart.getCartItemsCollection();
        if (items == null) {
            return BigDecimal.ZERO;
        }
        BigDecimal total = BigDecimal.ZERO;
        for (CartItem ci : items) {
            if ("selected".equalsIgnoreCase(ci.getStatus())) {
                total = total.add(ci.getSubTotal());
            }
        }
        return total;
    }

    @Override
    public BigDecimal getTotalAmount_Admin(int cartID) {
        if (cartID <= 0) {
            throw new IllegalArgumentException("ID không hợp lệ");
        }
        Cart cart = getCartWithItems(cartID);
        if (cart == null) {
            throw new EntityNotFoundException("Không tìm thấy giỏ hàng");
        }
        Collection<CartItem> items = cart.getCartItemsCollection();
        if (items == null) {
            return BigDecimal.ZERO;
        }
        BigDecimal total = BigDecimal.ZERO;
        for (CartItem ci : items) {
            total = total.add(ci.getProduct().getPrice().multiply(BigDecimal.valueOf(ci.getQuantity())));
        }
        return total;
    }

    @Override
    public Cart getActiveCart(int userID) {
        if (userID <= 0) {
            throw new IllegalArgumentException("ID không hợp lệ");
        }
        ICartItemService cartItemService = new CartItemService();
        for(Cart c : getByUserID(userID))
            if("active".equalsIgnoreCase(c.getStatus())){
                List<CartItem> selected = cartItemService.getAllByCartID_UserCheckout(c.getCartID());
                List<CartItem> items = cartItemService.getAllByCartID_User(c.getCartID());
                if(selected.size() != 0 && items.size() != 0 && selected.size() == items.size()) {
                    c.setStatus("checkout");
                    updateCart(c);
                } else {
                    return c;
                }
            }
        return null;
    }
}