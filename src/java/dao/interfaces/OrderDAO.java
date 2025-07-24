package dao.interfaces;

import java.util.List;
import model.entity.Order;

/**
 * DAO interface for Order entity
 */
public interface OrderDAO extends IGenericDAO<Order, Integer> {
    
    /**
     * Find orders by user ID
     * @param userId user ID to search for
     * @return List of orders for the user
     */
    List<Order> findByUserId(Integer userId);
    
    /**
     * Find orders by status
     * @param status order status to search for
     * @return List of orders with the specified status
     */
    List<Order> findByStatus(String status);

    List<Order> getByUserID(int userID);
    Order findOrderWithItems(Integer orderID);
    int getMaxOrderNumberByDate(String datePart);
    void cancelOrder(int orderId);
    void returnOrder(int orderId, String reason);
    List<Order> searchAndSortOrders(String tab, String q, String sort);
    List<Order> getByUserIDAndStatus(int userID, String status);
} 