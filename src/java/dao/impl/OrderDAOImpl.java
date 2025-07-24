package dao.impl;

import dao.interfaces.OrderDAO;
import jakarta.persistence.EntityManager;
import java.util.List;
import model.entity.Order;

/**
 * Implementation of OrderDAO
 */
public class OrderDAOImpl extends GenericDAO<Order, Integer> implements OrderDAO {

    public OrderDAOImpl(EntityManager em) {
        super(em, Order.class);
    }

    @Override
    public List<Order> findByUserId(Integer userId) {
        String jpql = "SELECT o FROM Order o WHERE o.user.userId = :userId AND o.isDeleted = false ORDER BY o.createdAt DESC";
        return em.createQuery(jpql, Order.class)
                 .setParameter("userId", userId)
                 .getResultList();
    }

    @Override
    public List<Order> findByStatus(String status) {
        String jpql = "SELECT o FROM Order o WHERE o.status = :status AND o.isDeleted = false ORDER BY o.createdAt DESC";
        return em.createQuery(jpql, Order.class)
                 .setParameter("status", status)
                 .getResultList();
    }
    @Override
    public List<Order> getByUserID(int userID) {
        return em.createQuery(
            "SELECT o FROM Order o WHERE o.user.userId = :userID", Order.class)
        .setParameter("userID", userID)
        .getResultList();
    }
    
    @Override
    public Order findOrderWithItems(Integer orderID) {
        return em.createQuery(
            "SELECT o FROM Order o JOIN FETCH o.orderItemsCollection WHERE o.orderID = :orderID", Order.class)
            .setParameter("orderID", orderID)
            .getSingleResult();
    }
    
    @Override
    public int getMaxOrderNumberByDate(String datePart) {
        String prefix = "ORD-" + datePart + "-";
        List<String> ids = em.createQuery(
            "SELECT o.orderNumber FROM Order o WHERE o.orderNumber LIKE :prefix", String.class)
            .setParameter("prefix", prefix + "%")
            .getResultList();
        int max = 0;
        for (String id : ids) {
            try {
                String numPart = id.substring(13); // ORD-YYYYMMDD-xxx
                int num = Integer.parseInt(numPart);
                if (num > max) max = num;
            } catch (Exception e) {
                // Bỏ qua nếu lỗi format
            }
        }
        return max;
    }

    @Override
    public void cancelOrder(int orderId) {
        Order order = em.find(Order.class, orderId);
        if (order == null) throw new IllegalArgumentException("Không tìm thấy đơn hàng.");
        String status = order.getStatus().toLowerCase();
        if (status.equals("delivered") || status.equals("completed") || status.equals("refunded") || status.equals("cancelled")) {
            throw new IllegalStateException("Chỉ có thể hủy đơn hàng chưa giao hoặc chưa hoàn thành.");
        }
        order.setStatus("cancelled");
    }

    @Override
    public void returnOrder(int orderId, String reason) {
        Order order = em.find(Order.class, orderId);
        if (order == null) throw new IllegalArgumentException("Không tìm thấy đơn hàng.");
        String status = order.getStatus().toLowerCase();
        if (!status.equals("delivered") && !status.equals("completed")) {
            throw new IllegalStateException("Chỉ có thể hoàn trả đơn hàng đã giao thành công.");
        }
        order.setStatus("refunded");
        order.setNotes((order.getNotes() != null ? order.getNotes() + "\n" : "") + "Yêu cầu hoàn trả: " + reason);
    }

    @Override
    public List<Order> searchAndSortOrders(String tab, String q, String sort) {
        StringBuilder jpql = new StringBuilder("SELECT o FROM Order o WHERE o.isDeleted = false");
        if (tab != null && !tab.equals("all")) {
            switch (tab) {
                case "pending": jpql.append(" AND o.status = 'pending'"); break;
                case "shipping": jpql.append(" AND o.status = 'shipping'"); break;
                case "delivered": jpql.append(" AND o.status = 'delivered'"); break;
                case "refunded": jpql.append(" AND o.status = 'refunded'"); break;
                case "cancelled": jpql.append(" AND o.status = 'cancelled'"); break;
            }
        }
        if (q != null && !q.trim().isEmpty()) {
            jpql.append(" AND (CAST(o.orderID AS string) LIKE :q OR LOWER(o.customerName) LIKE :q2)");
        }
        if (sort != null && !sort.trim().isEmpty()) {
            switch (sort) {
                case "date_asc": jpql.append(" ORDER BY o.createdAt ASC"); break;
                case "date_desc": jpql.append(" ORDER BY o.createdAt DESC"); break;
                case "amount_asc": jpql.append(" ORDER BY o.finalAmount ASC"); break;
                case "amount_desc": jpql.append(" ORDER BY o.finalAmount DESC"); break;
                default: jpql.append(" ORDER BY o.createdAt DESC");
            }
        } else {
            jpql.append(" ORDER BY o.createdAt DESC");
        }
        var query = em.createQuery(jpql.toString(), Order.class);
        if (q != null && !q.trim().isEmpty()) {
            query.setParameter("q", "%" + q.trim().toLowerCase() + "%");
            query.setParameter("q2", "%" + q.trim().toLowerCase() + "%");
        }
        return query.getResultList();
    }

    @Override
    public List<Order> getByUserIDAndStatus(int userID, String status) {
        return em.createQuery(
            "SELECT o FROM Order o WHERE o.user.userId = :userID AND o.status = :status ORDER BY o.createdAt DESC", Order.class)
        .setParameter("userID", userID)
        .setParameter("status", status)
        .getResultList();
    }
} 