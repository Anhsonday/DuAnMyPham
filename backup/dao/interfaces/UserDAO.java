package dao.interfaces;

import model.entity.User;

/**
 * DAO interface for User entity
 */
public interface UserDAO extends IGenericDAO<User, Integer> {
    
    /**
     * Find user by email
     * @param email email to search
     * @return User or null if not found
     */
    User findByEmail(String email);
    
    /**
     * Find user by reset token
     * @param resetToken reset token to search
     * @return User or null if not found
     */
    User findByResetToken(String resetToken);
    
    /**
     * Update user's last login time
     * @param userId user ID
     */
    void updateLastLogin(Integer userId);
    
    /**
     * Update user's reset token
     * @param email user email
     * @param resetToken new reset token
     */
    void updateResetToken(String email, String resetToken);
    
    /**
     * Update user's password
     * @param userId user ID
     * @param hashedPassword new hashed password
     */
    void updatePassword(Integer userId, String hashedPassword);
}
