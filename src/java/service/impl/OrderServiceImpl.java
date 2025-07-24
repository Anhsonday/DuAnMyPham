package service.impl;

import dao.interfaces.OrderDAO;
import dao.impl.OrderDAOImpl;
import dao.interfaces.ProductDAO;
import dao.impl.ProductDAOImpl;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityNotFoundException;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.entity.Order;
import model.entity.User;
import service.interfaces.OrderService;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.ZoneId;
import model.entity.Address;
import java.math.BigDecimal;
import java.time.format.DateTimeFormatter;
import model.entity.CartItem;
import model.entity.OrderItem;
import model.entity.Product;

/**
 * Implementation of OrderService
 */
public class OrderServiceImpl extends GenericService<Order> implements OrderService {
    
    @Override
    public void createOrder(Order o) {
        if(o == null) {
            throw new IllegalArgumentException("Không thể tạo đơn hàng");
        }
        doInTransaction(em -> {
            OrderDAO orderDAO = new OrderDAOImpl(em);
            o.setOrderNumber(getNextOrderNumber());
            orderDAO.add(o);
            em.flush();
            em.refresh(o);
        }, "Tạo đơn hàng thất bại");
    }

    @Override
    public void updateOrder(Order o) {
        if(o == null) {
            throw new IllegalArgumentException("Không thể cập nhật đơn hàng");
        }
        doInTransaction(em -> {
            OrderDAO orderDAO = new OrderDAOImpl(em);
            orderDAO.update(o);
        }, "Cập nhật trạng thái đơn hàng thất bại");
    }

    @Override
    public List<Order> getAllOrders() {
        return doInTransactionWithResult(em -> {
            OrderDAO orderDAO = new OrderDAOImpl(em);
            return orderDAO.findAll();
        }, "Lấy tất cả đơn hàng thất bại");
    }

    @Override
    public List<Order> getByUserID(int userID) {
        if(userID <= 0) {
            throw new IllegalArgumentException("ID không hợp lệ");
        }
        return doInTransactionWithResult(em -> {
            OrderDAO orderDAO = new OrderDAOImpl(em);
            return orderDAO.getByUserID(userID);
        }, "Lấy tất cả đơn hàng thất bại");
    }

    @Override
    public Order getOrderByID(int id) {
        if(id <= 0) {
            throw new IllegalArgumentException("ID không hợp lệ");
        }
        return doInTransactionWithResult(em -> {
            OrderDAO orderDAO = new OrderDAOImpl(em);
            return orderDAO.findById(id);
        }, "Lấy đơn hàng theo ID thất bại");
    }
    
    @Override
    public Order getOrderWithItems(int orderID) {
        if(orderID <= 0) {
            throw new IllegalArgumentException("ID không hợp lệ");
        }
        return doInTransactionWithResult(em -> {
            OrderDAO orderDAO = new OrderDAOImpl(em);
            return orderDAO.findOrderWithItems(orderID);
        }, "Lấy đơn hàng theo ID thất bại");
    }
    
    @Override
    public void updateOrderWithEntityManager(EntityManager em, Order o) {
        if(o == null) {
            throw new IllegalArgumentException("Không thể cập nhật đơn hàng");
        }
        OrderDAO orderDAO = new OrderDAOImpl(em);
        orderDAO.update(o);
    }
    
    @Override
    public void confirmOrder(EntityManager em, int orderID) {
        if(orderID <= 0) {
            throw new IllegalArgumentException("ID không hợp lệ");
        }
        Order order = getOrderWithItems(orderID);
        if(order == null) {
            throw new EntityNotFoundException("Không tìm thấy đơn hàng");
        }
        ProductDAO productDAO = new ProductDAOImpl(em);
        for (OrderItem oi : order.getOrderItemsCollection()) {
            if(!oi.getIsDeleted()) {
                Product p = productDAO.findById(oi.getProduct().getProductId());
                if (p == null) {
                    throw new EntityNotFoundException("Không tìm thấy sản phẩm với ID: " + oi.getProduct().getProductId());
                }
                if (p.getReservedQuantity() < oi.getQuantity()) {
                    throw new IllegalStateException("Không đủ hàng tồn kho cho sản phẩm với ID: " + p.getProductId());
                }
                p.setReservedQuantity(p.getReservedQuantity() - oi.getQuantity());
                p.setStock(p.getStock() - oi.getQuantity());
                productDAO.update(p);
            }
        }
    }

    @Override
    public void cancelOrder(int orderId) {
        doInTransaction(em -> {
            OrderDAO orderDAO = new OrderDAOImpl(em);
            orderDAO.cancelOrder(orderId);
        }, "Error cancelling order");
    }

    @Override
    public void returnOrder(int orderId, String reason) {
        doInTransaction(em -> {
            OrderDAO orderDAO = new OrderDAOImpl(em);
            orderDAO.returnOrder(orderId, reason);
        }, "Error returning order");
    }

    @Override
    public List<Order> searchAndSortOrders(String tab, String q, String sort) {
        return doInTransactionWithResult(em -> {
            OrderDAO orderDAO = new OrderDAOImpl(em);
            return orderDAO.searchAndSortOrders(tab, q, sort);
        }, "Error searching and sorting orders");
    }

    @Override
    public String getNextOrderNumber() {
        String datePart = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyyMMdd"));
        int max = doInTransactionWithResult(em -> {
            OrderDAO orderDAO = new OrderDAOImpl(em);
            return orderDAO.getMaxOrderNumberByDate(datePart);
        }, "Lấy orderNumber lớn nhất thất bại");
        return String.format("ORD-%s-%03d", datePart, max + 1);
    }
    
    @Override
    public BigDecimal getTotalAmount(List<CartItem> selectedItems) {
        BigDecimal totalAmount = BigDecimal.ZERO;
        if (selectedItems != null) {
            for (CartItem item : selectedItems) {
                totalAmount = totalAmount.add(item.getProduct().getPrice().multiply(BigDecimal.valueOf(item.getQuantity())));
            }
            return totalAmount;
        }
        return BigDecimal.ZERO;
    }
    
    @Override
    public BigDecimal getDiscount() {
        return BigDecimal.ZERO;
    }

    @Override
    public BigDecimal getShippingFee(Address addr) {
        if (addr == null) {
            throw new EntityNotFoundException("Không tìm thấy địa chỉ");
        }
        if (addr.getProvince().equalsIgnoreCase("ĐÀ NẴNG"))
            return new BigDecimal("20000");
        return new BigDecimal("30000");
    }

    @Override
    public BigDecimal getTax(BigDecimal totalAmount) {
        if(totalAmount == null || totalAmount.compareTo(BigDecimal.ZERO) <= 0) {
            return BigDecimal.ZERO;
        }
        BigDecimal taxRate = new BigDecimal("0.10");
        return (totalAmount.subtract(getDiscount())).multiply(taxRate);
    }

    @Override
    public BigDecimal getFinalAmount(BigDecimal totalAmount, Address addr) {
        if(totalAmount == null || totalAmount.compareTo(BigDecimal.ZERO) <= 0) {
            return BigDecimal.ZERO;
        }
        return totalAmount
                .subtract(getDiscount())
                .add(getShippingFee(addr))
                .add(getTax(totalAmount));
    }
    
    @Override
    public Order updateOrderStatus(Integer orderId, String status) {
        if (orderId == null) {
            throw new IllegalArgumentException("Order ID cannot be null");
        }
        if (status == null || status.trim().isEmpty()) {
            throw new IllegalArgumentException("Status cannot be empty");
        }
        
        return doInTransactionWithResult(em -> {
            OrderDAOImpl dao = new OrderDAOImpl(em);
            Order order = dao.findById(orderId);
            if (order == null) {
                throw new IllegalArgumentException("Order not found");
            }
            order.setStatus(Order.OrderStatus.fromString(status).getValue());
            order.setUpdatedAt(new Date());
            dao.update(order);
            return order;
        }, "Error updating order status");
    }
    
    @Override
    public List<Order> getOrdersByUserId(Integer userId) {
        if (userId == null) {
            throw new IllegalArgumentException("User ID cannot be null");
        }
        
        return doInTransactionForList(em -> {
            OrderDAOImpl dao = new OrderDAOImpl(em);
            return dao.findByUserId(userId);
        }, "Error getting orders by user ID");
    }
    
    @Override
    public List<Order> getOrdersByStatus(String status) {
        if (status == null || status.trim().isEmpty()) {
            throw new IllegalArgumentException("Status cannot be empty");
        }
        
        return doInTransactionForList(em -> {
            OrderDAOImpl dao = new OrderDAOImpl(em);
            return dao.findByStatus(status);
        }, "Error getting orders by status");
    }
    
    @Override
    public List<Order> getRecentOrders(int limit) {
        if (limit <= 0) {
            throw new IllegalArgumentException("Limit must be positive");
        }
        
        return doInTransactionForList(em -> {
            String jpql = "SELECT o FROM Order o WHERE o.isDeleted = false ORDER BY o.createdAt DESC";
            return em.createQuery(jpql, Order.class)
                    .setMaxResults(limit)
                    .getResultList();
        }, "Error getting recent orders");
    }
    
    // Admin methods
    @Override
    public int getTotalOrders(int adminUserId) {
        return doInTransactionWithResult(em -> {
            // Check if user is admin
            User admin = em.find(User.class, adminUserId);
            if (admin == null || !"admin".equals(admin.getRole())) {
                return 0;
            }
            
            String jpql = "SELECT COUNT(o) FROM Order o WHERE o.isDeleted = false";
            Long count = em.createQuery(jpql, Long.class).getSingleResult();
            return count.intValue();
        }, "Error getting total orders");
    }
    
    @Override
    public double getTotalRevenue(int adminUserId) {
        return doInTransactionWithResult(em -> {
            // Check if user is admin
            User admin = em.find(User.class, adminUserId);
            if (admin == null || !"admin".equals(admin.getRole())) {
                return 0.0;
            }
            // Chỉ tính các đơn đã xác nhận/thành công
            String jpql = "SELECT SUM(o.finalAmount) FROM Order o WHERE o.isDeleted = false AND (o.status = :confirmed OR o.status = :delivered OR o.status = :completed)";
            java.math.BigDecimal total = em.createQuery(jpql, java.math.BigDecimal.class)
                .setParameter("confirmed", "confirmed")
                .setParameter("delivered", "delivered")
                .setParameter("completed", "completed")
                .getSingleResult();
            return (total != null) ? total.doubleValue() : 0.0;
        }, "Error getting total revenue");
    }
    
    @Override
    public double getTodayRevenue(int adminUserId) {
        return doInTransactionWithResult(em -> {
            User admin = em.find(User.class, adminUserId);
            if (admin == null || !"admin".equals(admin.getRole())) {
                return 0.0;
            }
            // Lấy thời gian đầu và cuối ngày hôm nay
            LocalDate today = LocalDate.now();
            LocalDateTime startOfDay = today.atStartOfDay();
            LocalDateTime endOfDay = today.plusDays(1).atStartOfDay();
            java.util.Date startDate = java.util.Date.from(startOfDay.atZone(ZoneId.systemDefault()).toInstant());
            java.util.Date endDate = java.util.Date.from(endOfDay.atZone(ZoneId.systemDefault()).toInstant());
            String jpql = "SELECT SUM(o.totalAmount) FROM Order o WHERE o.isDeleted = false AND o.status != :cancelledStatus AND o.createdAt >= :startOfDay AND o.createdAt < :endOfDay";
            java.math.BigDecimal total = em.createQuery(jpql, java.math.BigDecimal.class)
                .setParameter("cancelledStatus", Order.OrderStatus.CANCELLED.getValue())
                .setParameter("startOfDay", startDate)
                .setParameter("endOfDay", endDate)
                .getSingleResult();
            return (total != null) ? total.doubleValue() : 0.0;
        }, "Error getting today's revenue");
    }
    
    @Override
    public int getTodayOrders(int adminUserId) {
        return doInTransactionWithResult(em -> {
            User admin = em.find(User.class, adminUserId);
            if (admin == null || !"admin".equals(admin.getRole())) {
                return 0;
            }
            // Lấy thời gian đầu và cuối ngày hôm nay
            LocalDate today = LocalDate.now();
            LocalDateTime startOfDay = today.atStartOfDay();
            LocalDateTime endOfDay = today.plusDays(1).atStartOfDay();
            java.util.Date startDate = java.util.Date.from(startOfDay.atZone(ZoneId.systemDefault()).toInstant());
            java.util.Date endDate = java.util.Date.from(endOfDay.atZone(ZoneId.systemDefault()).toInstant());
            String jpql = "SELECT COUNT(o) FROM Order o WHERE o.isDeleted = false AND o.createdAt >= :startOfDay AND o.createdAt < :endOfDay";
            Long count = em.createQuery(jpql, Long.class)
                    .setParameter("startOfDay", startDate)
                    .setParameter("endOfDay", endDate)
                    .getSingleResult();
            return (count != null) ? count.intValue() : 0;
        }, "Error getting today's orders");
    }
    
    @Override
    public int getPendingOrders(int adminUserId) {
        return doInTransactionWithResult(em -> {
            // Check if user is admin
            User admin = em.find(User.class, adminUserId);
            if (admin == null || !"admin".equals(admin.getRole())) {
                return 0;
            }
            
            String jpql = "SELECT COUNT(o) FROM Order o WHERE o.isDeleted = false AND o.status = :pendingStatus";
            Long count = em.createQuery(jpql, Long.class)
                    .setParameter("pendingStatus", Order.OrderStatus.PENDING.getValue())
                    .getSingleResult();
            return count.intValue();
        }, "Error getting pending orders");
    }
    
    @Override
    public double getRevenueGrowth(int adminUserId) {
        return doInTransactionWithResult(em -> {
            // Check if user is admin
            User admin = em.find(User.class, adminUserId);
            if (admin == null || !"admin".equals(admin.getRole())) {
                return 0.0;
            }
            
            // This is a simplified implementation
            // In a real application, you would compare current month with previous month
            return 0.0; // Placeholder
        }, "Error getting revenue growth");
    }
    
    @Override
    public Map<String, Object> getMonthlyRevenue(int adminUserId) {
        return doInTransactionWithResult(em -> {
            // Check if user is admin
            User admin = em.find(User.class, adminUserId);
            if (admin == null || !"admin".equals(admin.getRole())) {
                return new HashMap<>();
            }
            
            // This is a simplified implementation
            // In a real application, you would aggregate data by month
            Map<String, Object> monthlyData = new HashMap<>();
            monthlyData.put("currentMonth", 0.0);
            monthlyData.put("previousMonth", 0.0);
            return monthlyData;
        }, "Error getting monthly revenue");
    }
    
    @Override
    public List<Order> getRecentOrders(int adminUserId, int limit) {
        if (limit <= 0) {
            throw new IllegalArgumentException("Limit must be positive");
        }
        
        return doInTransactionForList(em -> {
            // Check if user is admin
            User admin = em.find(User.class, adminUserId);
            if (admin == null || !"admin".equals(admin.getRole())) {
                return List.of();
            }
            
            String jpql = "SELECT o FROM Order o WHERE o.isDeleted = false ORDER BY o.createdAt DESC";
            return em.createQuery(jpql, Order.class)
                    .setMaxResults(limit)
                    .getResultList();
        }, "Error getting recent orders");
    }
    
    @Override
    public Map<String, Object> getOrderStatistics(int adminUserId) {
        return doInTransactionWithResult(em -> {
            // Check if user is admin
            User admin = em.find(User.class, adminUserId);
            if (admin == null || !"admin".equals(admin.getRole())) {
                return new HashMap<>();
            }
            
            Map<String, Object> stats = new HashMap<>();
            
            // Get counts by status
            String jpql = "SELECT o.status, COUNT(o) FROM Order o WHERE o.isDeleted = false GROUP BY o.status";
            List<Object[]> results = em.createQuery(jpql).getResultList();
            
            for (Object[] result : results) {
                String status = (String) result[0];
                Long count = (Long) result[1];
                stats.put(status + "Count", count.intValue());
            }
            
            return stats;
        }, "Error getting order statistics");
    }
    
    @Override
    public List<Order> getOrdersByDateRange(Integer adminUserId, Date startDate, Date endDate) {
        if (startDate == null || endDate == null) {
            throw new IllegalArgumentException("Start date and end date cannot be null");
        }
        return doInTransactionForList(em -> {
            if (adminUserId != null) {
                User admin = em.find(User.class, adminUserId);
                if (admin == null || !"admin".equals(admin.getRole())) {
                    return List.of();
                }
            }
            String jpql = "SELECT o FROM Order o WHERE o.isDeleted = false AND o.createdAt BETWEEN :startDate AND :endDate ORDER BY o.createdAt DESC";
            return em.createQuery(jpql, Order.class)
                    .setParameter("startDate", startDate)
                    .setParameter("endDate", endDate)
                    .getResultList();
        }, "Error getting orders by date range");
    }

    @Override
    public Integer findDeliveredOrderIdForUserAndProduct(int userId, int productId) {
        return doInTransactionWithResult(em -> {
            String jpql = "SELECT o.orderID FROM Order o JOIN o.orderItemsCollection oi WHERE o.user.userId = :userId AND oi.product.productId = :productId AND o.status = 'delivered' AND o.isDeleted = false";
            List<Integer> orderIds = em.createQuery(jpql, Integer.class)
                .setParameter("userId", userId)
                .setParameter("productId", productId)
                .setMaxResults(1)
                .getResultList();
            return orderIds.isEmpty() ? null : orderIds.get(0);
        }, "Error finding delivered orderId for user and product");
    }

    @Override
    public List<Integer> findDeliveredOrCompletedOrderIdsForUserAndProduct(int userId, int productId) {
        return doInTransactionWithResult(em -> {
            String jpql = "SELECT o.orderID FROM Order o JOIN o.orderItemsCollection oi WHERE o.user.userId = :userId AND oi.product.productId = :productId AND (o.status = 'delivered' OR o.status = 'completed') AND o.isDeleted = false";
            return em.createQuery(jpql, Integer.class)
                .setParameter("userId", userId)
                .setParameter("productId", productId)
                .getResultList();
        }, "Error finding delivered/completed orderIds for user and product");
    }

    @Override
    public Order getOrderById(Integer orderId) {
        return doInTransactionWithResult(em -> {
            return em.find(Order.class, orderId);
        }, "Error getting order by ID");
    }

    @Override
    public List<Order> getOrdersByUpdatedDateRange(Integer adminUserId, Date startDate, Date endDate) {
        return doInTransactionWithResult(em -> {
            String jpql = "SELECT o FROM Order o WHERE o.isDeleted = false AND o.updatedAt >= :startDate AND o.updatedAt <= :endDate";
            if (adminUserId != null) {
                jpql += " AND o.user.userId = :adminUserId";
            }
            var query = em.createQuery(jpql, Order.class)
                .setParameter("startDate", startDate)
                .setParameter("endDate", endDate);
            if (adminUserId != null) {
                query.setParameter("adminUserId", adminUserId);
            }
            return query.getResultList();
        }, "Error getting orders by updated date range");
    }

    @Override
    public List<Order> getByUserIDAndStatus(int userID, String status) {
        if (status == null || status.equals("all") || status.isEmpty()) {
            return getByUserID(userID);
        }
        return doInTransactionWithResult(em -> {
            OrderDAO orderDAO = new OrderDAOImpl(em);
            return orderDAO.getByUserIDAndStatus(userID, status);
        }, "Lấy đơn hàng theo user và trạng thái thất bại");
    }
} 