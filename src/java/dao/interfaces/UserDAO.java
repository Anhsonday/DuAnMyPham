package dao.interfaces;

import dao.interfaces.IGenericDAO;
import java.util.List;
import model.entity.User;

/**
 * DAO interface for User entity
 */
public interface UserDAO extends IGenericDAO<User, Integer> {
    
    /**
     * Find user by username
     * @param username username to search
     * @return User or null if not found
     */
    User findByUsername(String username);
    
    /**
     * Find user by email
     * @param email email to search
     * @return User or null if not found
     */
    User findByEmail(String email);
    
    /**
     * Find user by Google ID
     * @param googleId Google ID to search
     * @return User or null if not found
     */
    User findByGoogleId(String googleId);
    
    /**
     * Find user by reset token
     * @param resetToken reset token to search
     * @return User or null if not found
     */
    User findByResetToken(String resetToken);
    
    /**
     * Check if username exists
     * @param username username to check
     * @return true if username exists
     */
    boolean isUsernameExists(String username);
    
    /**
     * Check if email exists
     * @param email email to check
     * @return true if email exists
     */
    boolean isEmailExists(String email);
    
    /**
     * Update user's password
     * @param userId user ID
     * @param newPasswordHash new hashed password
     * @return true if successful
     */
    boolean changePassword(int userId, String newPasswordHash);
    
    /**
     * Update user's last login time
     * @param userId user ID
     * @return true if successful
     */
    boolean updateLastLogin(int userId);
    
    /**
     * Search users by keyword
     * @param keyword search keyword
     * @return list of matching users
     */
    List<User> searchUsers(String keyword);
    
    /**
     * Get users by role
     * @param role role to filter by
     * @return list of users with the specified role
     */
    List<User> getUsersByRole(String role);
    
    /**
     * Get users by status
     * @param status status to filter by
     * @return list of users with the specified status
     */
    List<User> getUsersByStatus(String status);
    
    /**
     * Update user's status
     * @param userId user ID
     * @param status new status
     * @return true if successful
     */
    boolean updateUserStatus(int userId, String status);
    
    /**
     * Update user's role
     * @param userId user ID
     * @param role new role
     * @return true if successful
     */
    boolean updateUserRole(int userId, String role);
    
    /**
     * User statistics class
     */
    public static class UserStatistics {
        private int totalUsers;
        private int activeUsers;
        private int inactiveUsers;
        private int adminUsers;
        private int customerUsers;
        private int newUsersThisMonth;
        
        public UserStatistics() {
        }
        
        public UserStatistics(int totalUsers, int activeUsers, int inactiveUsers, int adminUsers, int customerUsers, int newUsersThisMonth) {
            this.totalUsers = totalUsers;
            this.activeUsers = activeUsers;
            this.inactiveUsers = inactiveUsers;
            this.adminUsers = adminUsers;
            this.customerUsers = customerUsers;
            this.newUsersThisMonth = newUsersThisMonth;
        }
        
        public int getTotalUsers() {
            return totalUsers;
        }
        
        public int getActiveUsers() {
            return activeUsers;
        }
        
        public int getInactiveUsers() {
            return inactiveUsers;
        }
        
        public int getAdminUsers() {
            return adminUsers;
        }
        
        public int getCustomerUsers() {
            return customerUsers;
        }
        
        public int getNewUsersThisMonth() {
            return newUsersThisMonth;
        }
    }
}
