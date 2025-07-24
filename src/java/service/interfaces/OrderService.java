package service.interfaces;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;
import java.util.Map;
import model.entity.Address;
import model.entity.CartItem;
import model.entity.Order;
import jakarta.persistence.EntityManager;


/**
 * Service interface for Order entity
 */
public interface OrderService extends IGenericService<Order> {
    
    /**
     * Create new order
     * @param order order to create
     * @return created order with ID
     * @throws IllegalArgumentException if order is null or invalid
     * @throws RuntimeException if database error occurs
     */
    
    
    /**
     * Update order status
     * @param orderId order ID
     * @param status new status
     * @return updated order
     * @throws IllegalArgumentException if order ID is invalid
     * @throws RuntimeException if order not found or database error occurs
     */
    Order updateOrderStatus(Integer orderId, String status);
    
    /**
     * Get orders by user ID
     * @param userId user ID
     * @return List of user's orders
     * @throws IllegalArgumentException if user ID is invalid
     * @throws RuntimeException if database error occurs
     */
    List<Order> getOrdersByUserId(Integer userId);
    
    /**
     * Get orders by status
     * @param status order status
     * @return List of orders with specified status
     * @throws IllegalArgumentException if status is null or empty
     * @throws RuntimeException if database error occurs
     */
    List<Order> getOrdersByStatus(String status);
    
    /**
     * Get recent orders
     * @param limit maximum number of orders
     * @return List of recent orders
     * @throws IllegalArgumentException if limit <= 0
     * @throws RuntimeException if database error occurs
     */
    List<Order> getRecentOrders(int limit);
    
    // Admin methods
    /**
     * Get total number of orders (admin only)
     * @param adminUserId admin user ID for authorization
     * @return total number of orders
     * @throws RuntimeException if user is not admin or database error occurs
     */
    int getTotalOrders(int adminUserId);
    
    /**
     * Get total revenue (admin only)
     * @param adminUserId admin user ID for authorization
     * @return total revenue
     * @throws RuntimeException if user is not admin or database error occurs
     */
    double getTotalRevenue(int adminUserId);
    
    /**
     * Get today's revenue (admin only)
     * @param adminUserId admin user ID for authorization
     * @return today's revenue
     * @throws RuntimeException if user is not admin or database error occurs
     */
    double getTodayRevenue(int adminUserId);
    
    /**
     * Get today's orders count (admin only)
     * @param adminUserId admin user ID for authorization
     * @return today's orders count
     * @throws RuntimeException if user is not admin or database error occurs
     */
    int getTodayOrders(int adminUserId);
    
    /**
     * Get pending orders count (admin only)
     * @param adminUserId admin user ID for authorization
     * @return pending orders count
     * @throws RuntimeException if user is not admin or database error occurs
     */
    int getPendingOrders(int adminUserId);
    
    /**
     * Get revenue growth percentage (admin only)
     * @param adminUserId admin user ID for authorization
     * @return revenue growth percentage
     * @throws RuntimeException if user is not admin or database error occurs
     */
    double getRevenueGrowth(int adminUserId);
    
    /**
     * Get monthly revenue data (admin only)
     * @param adminUserId admin user ID for authorization
     * @return Map of monthly revenue data
     * @throws RuntimeException if user is not admin or database error occurs
     */
    Map<String, Object> getMonthlyRevenue(int adminUserId);
    
    /**
     * Get recent orders (admin only)
     * @param adminUserId admin user ID for authorization
     * @param limit maximum number of orders
     * @return List of recent orders
     * @throws IllegalArgumentException if limit <= 0
     * @throws RuntimeException if user is not admin or database error occurs
     */
    List<Order> getRecentOrders(int adminUserId, int limit);
    
    /**
     * Get order statistics (admin only)
     * @param adminUserId admin user ID for authorization
     * @return Map of order statistics
     * @throws RuntimeException if user is not admin or database error occurs
     */
    Map<String, Object> getOrderStatistics(int adminUserId);
    
    /**
     * Get orders by date range (admin only)
     * @param adminUserId admin user ID for authorization (nullable: null để lấy tất cả)
     * @param startDate start date
     * @param endDate end date
     * @return List of orders within date range
     * @throws RuntimeException if user is not admin or database error occurs
     */
    List<Order> getOrdersByDateRange(Integer adminUserId, Date startDate, Date endDate);

    /**
     * Lấy tất cả đơn hàng theo khoảng thời gian cập nhật trạng thái (UpdatedAt)
     */
    List<Order> getOrdersByUpdatedDateRange(Integer adminUserId, Date startDate, Date endDate);

    Integer findDeliveredOrderIdForUserAndProduct(int userId, int productId);
    Order getOrderById(Integer orderId);
    void createOrder(Order o);
    void updateOrder(Order o);
    List<Order> getAllOrders();
    List<Order> getByUserID(int userID);
    Order getOrderByID(int id);
    Order getOrderWithItems(int orderID);
    void updateOrderWithEntityManager(EntityManager em, Order o);
    void confirmOrder(EntityManager em, int orderID);
    /**
     * Hủy đơn hàng theo orderId
     */
    void cancelOrder(int orderId);
    String getNextOrderNumber();
    BigDecimal getTotalAmount(List<CartItem> selectedItems);
    BigDecimal getDiscount();
    BigDecimal getShippingFee(Address addr);
    BigDecimal getTax(BigDecimal totalAmount);
    BigDecimal getFinalAmount(BigDecimal totalAmount, Address addr);
    /**
     * Lấy tất cả orderId của user với product ở trạng thái delivered hoặc completed
     */
    List<Integer> findDeliveredOrCompletedOrderIdsForUserAndProduct(int userId, int productId);
    /**
     * Yêu cầu hoàn trả đơn hàng
     */
    void returnOrder(int orderId, String reason);

    /**
     * Tìm kiếm và sắp xếp đơn hàng theo tab, từ khóa, và kiểu sắp xếp
     */
    List<Order> searchAndSortOrders(String tab, String q, String sort);
    List<Order> getByUserIDAndStatus(int userID, String status);
} 