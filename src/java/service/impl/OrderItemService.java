/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service.impl;

import dao.impl.OrderItemDAO;
import dao.interfaces.IOrderItemDAO;
import dao.interfaces.ProductDAO;
import dao.impl.ProductDAOImpl;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityNotFoundException;
import java.math.BigDecimal;
import java.util.List;
import model.entity.CartItem;
import model.entity.Order;
import model.entity.OrderItem;
import model.entity.Product;
import service.interfaces.ICartItemService;
import service.interfaces.IOrderItemService;

/**
 *
 * @author DELL
 */
public class OrderItemService extends GenericService<OrderItem> implements IOrderItemService {

    @Override
    public void createOrderItemFromSelected(List<CartItem> selected, Order order) {
        System.out.println("==> [DEBUG] Tạo OrderItem cho OrderID: " + order.getOrderID() + ", selected size: " + (selected == null ? "null" : selected.size()));
        if (selected == null || selected.isEmpty()) {
            System.out.println("==> [DEBUG] selected rỗng hoặc null khi tạo OrderItem!");
            throw new IllegalArgumentException("Không có sản phẩm nào được chọn để tạo đơn hàng!");
        }
        doInTransaction(em -> {
            IOrderItemDAO orderItemDAO = new OrderItemDAO(em);
            for (CartItem ci : selected) {
                System.out.println("==> [DEBUG] Tạo OrderItem cho CartItemID: " + ci.getCartItemID() + ", Product: " + ci.getProduct().getProductName() + ", Qty: " + ci.getQuantity());
                OrderItem oi = new OrderItem(
                        ci.getProduct().getProductName(),
                        ci.getQuantity(),
                        false, // isDeleted luôn là false
                        order,
                        ci.getProduct()
                );
                oi.setIsDeleted(false); // Đảm bảo luôn set false
                oi.setUnitPrice(ci.getProduct().getPrice());
                oi.setSubtotal(oi.getUnitPrice().multiply(BigDecimal.valueOf(oi.getQuantity())));
                reserveProduct(em, oi);
                orderItemDAO.add(oi);
                ICartItemService cartItemService = new CartItemService();
                ci.setStatus("checkout");
                cartItemService.updateCartItem(ci);
            }
        }, "Tạo OrderItem thất bại");
    }

    @Override
    public void updateOrderItem(OrderItem oi) {
        doInTransaction(em -> {
            if(oi == null) {
                throw new IllegalArgumentException("Sản phẩm không hợp lệ");
            }
            IOrderItemDAO orderItemDAO = new OrderItemDAO(em);
            orderItemDAO.update(oi);
        }, "Cập nhật sản phẩm trong đơn hàng thất bại");
    }
    
    
    @Override
    public void deleteOrderItem(int id) {
        doInTransaction(em -> {
            if(id <= 0) {
                throw new IllegalArgumentException("ID không hợp lệ");
            }
            IOrderItemDAO orderItemDAO = new OrderItemDAO(em);
            OrderItem oi = orderItemDAO.findById(id);
            if (oi == null) {
                throw new EntityNotFoundException("Không tìm thấy sản phẩm");
            }
            oi.setIsDeleted(true);
            updateOrderItem(oi);
        }, "Cập nhật sản phẩm trong đơn hàng thất bại");
    }

    @Override
    public List<OrderItem> getAllOrderItems() {
        return doInTransactionWithResult(em -> {
            IOrderItemDAO orderItemDAO = new OrderItemDAO(em);
            return orderItemDAO.findAll();
        }, "Lấy tất cả sản phẩm trong đơn hàng thất bại");
    }

    @Override
    public List<OrderItem> getByOrderID_Admin(int orderID) {
        if(orderID <= 0) {
            throw new IllegalArgumentException("ID không hợp lệ");
        }
        System.out.println("[DEBUG] getByOrderID_Admin - Truy vấn OrderItem với OrderID: " + orderID);
        List<OrderItem> result = doInTransactionWithResult(em -> {
            IOrderItemDAO orderItemDAO = new OrderItemDAO(em);
            return orderItemDAO.getByOrderID_Admin(orderID);
        }, "Lấy sản phẩm trong đơn hàng theo đơn thất bại");
        System.out.println("[DEBUG] getByOrderID_Admin - Số lượng OrderItem lấy được: " + (result == null ? "null" : result.size()));
        return result;
    }
    
    @Override
    public List<OrderItem> getByOrderID_User(int orderID) {
        if(orderID <= 0) {
            throw new IllegalArgumentException("ID không hợp lệ");
        }
        return doInTransactionWithResult(em -> {
            IOrderItemDAO orderItemDAO = new OrderItemDAO(em);
            return orderItemDAO.getByOrderID_User(orderID);
        }, "Lấy sản phẩm trong đơn hàng theo đơn thất bại");
    }

    @Override
    public OrderItem getOrderItemByID(int id) {
        if(id <= 0) {
            throw new IllegalArgumentException("ID không hợp lệ");
        }
        return doInTransactionWithResult(em -> {
            IOrderItemDAO orderItemDAO = new OrderItemDAO(em);
            return orderItemDAO.findById(id);
        }, "Lấy sản phẩm trong đơn hàng theo ID thất bại");
    }
    
    @Override
    public void reserveProduct(EntityManager em, OrderItem oi) {
        if(oi == null) {
            throw new IllegalArgumentException("Sản phẩm trong đơn hàng không hợp lệ");
        }
        ProductDAO productDAO = new ProductDAOImpl(em);
        Product p = productDAO.findById(oi.getProduct().getProductId());
        if (p == null) {
            throw new EntityNotFoundException("Không tìm thấy sản phẩm với ID: " + oi.getProduct().getProductId());
        }

        int available = p.getStock() - p.getReservedQuantity();
        if (available < oi.getQuantity()) {
            throw new IllegalStateException("Không đủ hàng tồn kho cho sản phẩm với ID: " + p.getProductId());
        }

        p.setReservedQuantity(p.getReservedQuantity() + oi.getQuantity());
        productDAO.update(p);
    }

}