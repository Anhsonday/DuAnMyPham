package service.impl;

import dao.impl.UserDAOImpl;
import dao.interfaces.UserDAO.UserStatistics;
import java.util.Date;
import java.util.List;
import model.entity.User;
import service.interfaces.UserService;
import utils.PasswordHasher;

/**
 * Service implementation for User entity that handles business logic
 */
public class UserServiceImpl extends GenericService<User> implements UserService {
    
    @Override
    public User login(String username, String password) {
        if (username == null || password == null || username.trim().isEmpty() || password.trim().isEmpty()) {
            return null;
        }
        
        return doInTransactionWithResult(em -> {
            UserDAOImpl dao = new UserDAOImpl(em);
            User user = dao.findByUsername(username);
            
            // If not found by username, try email
            if (user == null) {
                user = dao.findByEmail(username);
            }
            
            if (user == null || !"active".equals(user.getStatus())) {
                return null;
            }
            
            // Verify password
            if (PasswordHasher.verifyPassword(password, user.getPassword())) {
                // Update last login
                user.setLastLogin(new Date());
                dao.update(user);
                return user;
            }
            
            return null;
        }, "Error during login");
    }
    
    @Override
    public User register(User user) {
        if (user == null) {
            throw new IllegalArgumentException("User cannot be null");
        }
        if (user.getEmail() == null || user.getEmail().trim().isEmpty()) {
            throw new IllegalArgumentException("Email is required");
        }
        if (user.getPassword() == null || user.getPassword().trim().isEmpty()) {
            throw new IllegalArgumentException("Password is required");
        }
        if (user.getUsername() == null || user.getUsername().trim().isEmpty()) {
            throw new IllegalArgumentException("Username is required");
        }
        
        return doInTransactionWithResult(em -> {
            UserDAOImpl dao = new UserDAOImpl(em);
            
            // Check if email or username already exists
            if (dao.findByEmail(user.getEmail()) != null) {
                throw new IllegalArgumentException("Email already registered");
            }
            if (dao.findByUsername(user.getUsername()) != null) {
                throw new IllegalArgumentException("Username already taken");
            }
            
            // Set up new user
            user.setPassword(PasswordHasher.hashPassword(user.getPassword()));
            user.setRole(user.getRole() == null ? "customer" : user.getRole());
            user.setStatus("active");
            user.setIsDeleted(false);
            user.setCreatedAt(new Date());
            
            dao.add(user);
            return user;
        }, "Error registering user");
    }
    
    @Override
    public User findByEmail(String email) {
        if (email == null || email.trim().isEmpty()) {
            throw new IllegalArgumentException("Email cannot be empty");
            }
            
        return doInTransactionWithResult(em -> {
            UserDAOImpl dao = new UserDAOImpl(em);
            return dao.findByEmail(email);
        }, "Error finding user by email");
    }
    
    @Override
    public User findByGoogleId(String googleId) {
        if (googleId == null || googleId.trim().isEmpty()) {
            throw new IllegalArgumentException("Google ID cannot be empty");
        }
        
        return doInTransactionWithResult(em -> {
            UserDAOImpl dao = new UserDAOImpl(em);
            return dao.findByGoogleId(googleId);
        }, "Error finding user by Google ID");
    }
    
    @Override
    public User findByResetToken(String resetToken) {
        if (resetToken == null || resetToken.trim().isEmpty()) {
            throw new IllegalArgumentException("Reset token cannot be empty");
        }
        
        return doInTransactionWithResult(em -> {
            UserDAOImpl dao = new UserDAOImpl(em);
            return dao.findByResetToken(resetToken);
        }, "Error finding user by reset token");
    }
    
    @Override
    public void updateLastLogin(Integer userId) {
        if (userId == null) {
            throw new IllegalArgumentException("User ID cannot be null");
            }
            
        doInTransaction(em -> {
            UserDAOImpl dao = new UserDAOImpl(em);
            User user = dao.findById(userId);
            if (user == null) {
                throw new IllegalArgumentException("User not found");
            }
            user.setLastLogin(new Date());
            dao.update(user);
        }, "Error updating last login");
            }
            
    @Override
    public void updateResetToken(String email, String resetToken) {
        if (email == null || email.trim().isEmpty()) {
            throw new IllegalArgumentException("Email cannot be empty");
        }
        if (resetToken == null || resetToken.trim().isEmpty()) {
            throw new IllegalArgumentException("Reset token cannot be empty");
        }
        
        doInTransaction(em -> {
            UserDAOImpl dao = new UserDAOImpl(em);
            User user = dao.findByEmail(email);
            if (user == null) {
                throw new IllegalArgumentException("User not found");
            }
            user.setResetToken(resetToken);
            user.setResetTokenExpiry(new Date(System.currentTimeMillis() + 24 * 60 * 60 * 1000)); // 24 hours
            dao.update(user);
        }, "Error updating reset token");
    }
    
    @Override
    public void updatePassword(Integer userId, String newPassword) {
        if (userId == null) {
            throw new IllegalArgumentException("User ID cannot be null");
        }
        if (newPassword == null || newPassword.trim().isEmpty()) {
            throw new IllegalArgumentException("New password cannot be empty");
        }
        
        doInTransaction(em -> {
            UserDAOImpl dao = new UserDAOImpl(em);
            User user = dao.findById(userId);
            if (user == null) {
                throw new IllegalArgumentException("User not found");
            }
            user.setPassword(PasswordHasher.hashPassword(newPassword));
            user.setResetToken(null);
            user.setResetTokenExpiry(null);
            dao.update(user);
        }, "Error updating password");
    }
    
    @Override
    public User loginWithGoogle(String googleId, String email, String fullName, String avatar) {
        if (googleId == null || email == null) {
            return null;
        }
        
        return doInTransactionWithResult(em -> {
            UserDAOImpl dao = new UserDAOImpl(em);
            
            // Try to find by Google ID first
            User user = dao.findByGoogleId(googleId);
            
            // If not found by Google ID, try email
            if (user == null) {
                user = dao.findByEmail(email);
                
                if (user != null) {
                    // Update Google ID for existing user
                    user.setGoogleId(googleId);
                    user.setAvatar(avatar);
                    dao.update(user);
                } else {
                    // Create new user for Google login
                    user = new User();
                    
                    // Generate unique username from email
                    String baseUsername = email.split("@")[0];
                    String username = baseUsername;
                    int counter = 1;
                    
                    // Check if username exists and generate unique one
                    while (dao.isUsernameExists(username)) {
                        username = baseUsername + counter++;
                    }
                    
                    user.setUsername(username);
                    user.setEmail(email);
                    user.setFullName(fullName);
                    user.setGoogleId(googleId);
                    user.setAvatar(avatar);
                    user.setRole("customer");
                    user.setStatus("active");
                    user.setIsDeleted(false);
                    user.setCreatedAt(new Date());
                    
                    // Generate a random password (user won't use it)
                    user.setPassword(PasswordHasher.hashPassword("google_auth_" + System.currentTimeMillis()));
                    
                    dao.add(user);
                }
            }
            
            // Update last login
            user.setLastLogin(new Date());
            dao.update(user);
            
            return user;
        }, "Error during Google login");
    }
    
    @Override
    public User getUserById(int userId) {
        return doInTransactionWithResult(em -> {
            UserDAOImpl dao = new UserDAOImpl(em);
            return dao.findById(userId);
        }, "Error getting user by ID");
    }
    
    @Override
    public void updateProfile(User user) {
        if (user == null) {
            throw new IllegalArgumentException("User cannot be null");
        }
        if (user.getUserId() == null) {
            throw new IllegalArgumentException("User ID cannot be null");
        }
        
        doInTransaction(em -> {
            UserDAOImpl dao = new UserDAOImpl(em);
            User existingUser = dao.findById(user.getUserId());
            if (existingUser == null) {
                throw new IllegalArgumentException("User not found");
            }
            
            // Preserve sensitive/unchangeable data
            user.setEmail(existingUser.getEmail());
            user.setPassword(existingUser.getPassword());
            user.setRole(existingUser.getRole());
            user.setStatus(existingUser.getStatus());
            user.setCreatedAt(existingUser.getCreatedAt());
            user.setResetToken(existingUser.getResetToken());
            user.setResetTokenExpiry(existingUser.getResetTokenExpiry());
            user.setGoogleId(existingUser.getGoogleId());
            user.setIsDeleted(existingUser.getIsDeleted());
            
            dao.update(user);
        }, "Error updating profile");
    }
    
    @Override
    public void updateStatus(Integer userId, String status) {
        if (userId == null) {
            throw new IllegalArgumentException("User ID cannot be null");
        }
        if (status == null || status.trim().isEmpty()) {
            throw new IllegalArgumentException("Status cannot be empty");
        }
        
        doInTransaction(em -> {
            UserDAOImpl dao = new UserDAOImpl(em);
            User user = dao.findById(userId);
            if (user == null) {
                throw new IllegalArgumentException("User not found");
            }
            user.setStatus(status);
            dao.update(user);
        }, "Error updating user status");
    }
    
    @Override
    public void softDelete(Integer userId) {
        if (userId == null) {
            throw new IllegalArgumentException("User ID cannot be null");
            }
            
        doInTransaction(em -> {
            UserDAOImpl dao = new UserDAOImpl(em);
            User user = dao.findById(userId);
            if (user == null) {
                throw new IllegalArgumentException("User not found");
            }
            user.setIsDeleted(true);
            user.setStatus("inactive");
            dao.update(user);
        }, "Error soft deleting user");
    }
    
    @Override
    public boolean isEmailExists(String email) {
        if (email == null || email.trim().isEmpty()) {
            throw new IllegalArgumentException("Email cannot be empty");
            }
            
        return doInTransactionWithResult(em -> {
            UserDAOImpl dao = new UserDAOImpl(em);
            return dao.isEmailExists(email);
        }, "Error checking email existence");
    }
    
    @Override
    public boolean isUsernameExists(String username) {
        if (username == null || username.trim().isEmpty()) {
            throw new IllegalArgumentException("Username cannot be empty");
        }
        
        return doInTransactionWithResult(em -> {
            UserDAOImpl dao = new UserDAOImpl(em);
            return dao.isUsernameExists(username);
        }, "Error checking username existence");
    }
    
    @Override
    public boolean changePassword(int userId, String oldPassword, String newPassword) {
        if (oldPassword == null || newPassword == null) {
            return false;
        }
        
        return doInTransactionWithResult(em -> {
            UserDAOImpl dao = new UserDAOImpl(em);
            User user = dao.findById(userId);
            
            if (user == null) {
                return false;
            }
            
            // Verify old password
            if (!PasswordHasher.verifyPassword(oldPassword, user.getPassword())) {
            return false;
        }
            
            // Update password
            user.setPassword(PasswordHasher.hashPassword(newPassword));
            dao.update(user);
            
            return true;
        }, "Error changing password");
    }
    
    // Admin operations
    @Override
    public List<User> getAllUsers(int adminUserId) {
        return doInTransactionWithResult(em -> {
            UserDAOImpl dao = new UserDAOImpl(em);
            
            // Check if user is admin
            User admin = dao.findById(adminUserId);
            if (admin == null || !"admin".equals(admin.getRole())) {
                return List.of();
            }
            
            return dao.findAll();
        }, "Error getting all users");
    }
    
    @Override
    public List<User> getUsersWithPagination(int page, int pageSize, int adminUserId) {
        return doInTransactionWithResult(em -> {
            UserDAOImpl dao = new UserDAOImpl(em);
            
            // Check if user is admin
            User admin = dao.findById(adminUserId);
            if (admin == null || !"admin".equals(admin.getRole())) {
                return List.of();
            }
            
            int offset = (page - 1) * pageSize;
            String jpql = "SELECT u FROM User u WHERE u.isDeleted = false ORDER BY u.createdAt DESC";
            return em.createQuery(jpql, User.class)
                    .setFirstResult(offset)
                    .setMaxResults(pageSize)
                    .getResultList();
        }, "Error getting users with pagination");
    }
    
    @Override
    public List<User> searchUsers(String keyword, int adminUserId) {
        return doInTransactionWithResult(em -> {
            UserDAOImpl dao = new UserDAOImpl(em);
            
            // Check if user is admin
            User admin = dao.findById(adminUserId);
            if (admin == null || !"admin".equals(admin.getRole())) {
                return List.of();
            }
            
            return dao.searchUsers(keyword);
        }, "Error searching users");
    }
    
    @Override
    public List<User> getUsersByRole(String role, int adminUserId) {
        return doInTransactionWithResult(em -> {
            UserDAOImpl dao = new UserDAOImpl(em);
            
            // Check if user is admin
            User admin = dao.findById(adminUserId);
            if (admin == null || !"admin".equals(admin.getRole())) {
                return List.of();
            }
            
            return dao.getUsersByRole(role);
        }, "Error getting users by role");
    }
    
    @Override
    public List<User> getUsersByStatus(String status, int adminUserId) {
        return doInTransactionWithResult(em -> {
            UserDAOImpl dao = new UserDAOImpl(em);
            
            // Check if user is admin
            User admin = dao.findById(adminUserId);
            if (admin == null || !"admin".equals(admin.getRole())) {
                return List.of();
            }
            
            return dao.getUsersByStatus(status);
        }, "Error getting users by status");
    }
    
    @Override
    public boolean createUser(User user, int adminUserId) {
        return doInTransactionWithResult(em -> {
            UserDAOImpl dao = new UserDAOImpl(em);
            
            // Check if user is admin
            User admin = dao.findById(adminUserId);
            if (admin == null || !"admin".equals(admin.getRole())) {
                return false;
            }
            
            // Validate user data
            if (!validateUserData(user)) {
                return false;
            }
            
            // Check if username or email exists
            if (dao.isUsernameExists(user.getUsername()) || dao.isEmailExists(user.getEmail())) {
            return false;
        }
            
            // Hash password
            user.setPassword(PasswordHasher.hashPassword(user.getPassword()));
            
            // Set timestamps
            user.setCreatedAt(new Date());
            
            // Set default values if not provided
            if (user.getRole() == null) user.setRole("customer");
            if (user.getStatus() == null) user.setStatus("active");
            user.setIsDeleted(false);
            
            dao.add(user);
            return true;
        }, "Error creating user");
    }
    
    @Override
    public boolean updateUser(User user, int adminUserId) {
        return doInTransactionWithResult(em -> {
            UserDAOImpl dao = new UserDAOImpl(em);
            
            // Check if user is admin
            User admin = dao.findById(adminUserId);
            if (admin == null || !"admin".equals(admin.getRole())) {
                return false;
            }
            
            // Get existing user
            User existingUser = dao.findById(user.getUserId());
            if (existingUser == null) {
                return false;
            }
            
            // Check if username or email changed and already exists
            if (!existingUser.getUsername().equals(user.getUsername()) && dao.isUsernameExists(user.getUsername())) {
                return false;
            }
            
            if (!existingUser.getEmail().equals(user.getEmail()) && dao.isEmailExists(user.getEmail())) {
            return false;
        }
            
            // Preserve some fields
            user.setCreatedAt(existingUser.getCreatedAt());
            
            // Update password if provided and not empty
            if (user.getPassword() != null && !user.getPassword().isEmpty() && !user.getPassword().equals(existingUser.getPassword())) {
                user.setPassword(PasswordHasher.hashPassword(user.getPassword()));
            } else {
                user.setPassword(existingUser.getPassword());
            }
            
            dao.update(user);
            return true;
        }, "Error updating user");
    }
    
    @Override
    public boolean deleteUser(int userId, int adminUserId) {
        return doInTransactionWithResult(em -> {
            UserDAOImpl dao = new UserDAOImpl(em);
            
            // Check if user is admin
            User admin = dao.findById(adminUserId);
            if (admin == null || !"admin".equals(admin.getRole())) {
                return false;
            }
            
            // Don't allow admin to delete themselves
            if (userId == adminUserId) {
                return false;
            }
            
            User user = dao.findById(userId);
            if (user != null) {
                user.setIsDeleted(true);
                user.setStatus("inactive");
                dao.update(user);
                return true;
            }
            return false;
        }, "Error deleting user");
    }
    
    @Override
    public boolean restoreUser(int userId, int adminUserId) {
        return doInTransactionWithResult(em -> {
            UserDAOImpl dao = new UserDAOImpl(em);
            
            // Check if user is admin
            User admin = dao.findById(adminUserId);
            if (admin == null || !"admin".equals(admin.getRole())) {
                return false;
            }
            
            String jpql = "SELECT u FROM User u WHERE u.userId = :userId";
            try {
                User user = em.createQuery(jpql, User.class)
                             .setParameter("userId", userId)
                             .getSingleResult();
                
                user.setIsDeleted(false);
                user.setStatus("active");
                dao.update(user);
                return true;
        } catch (Exception e) {
            return false;
        }
        }, "Error restoring user");
    }
    
    @Override
    public boolean updateUserStatus(int userId, String status, int adminUserId) {
        return doInTransactionWithResult(em -> {
            UserDAOImpl dao = new UserDAOImpl(em);
            
            // Check if user is admin
            User admin = dao.findById(adminUserId);
            if (admin == null || !"admin".equals(admin.getRole())) {
                return false;
            }
            
            // Don't allow admin to deactivate themselves
            if (userId == adminUserId && "inactive".equals(status)) {
                return false;
            }
            
            return dao.updateUserStatus(userId, status);
        }, "Error updating user status");
    }
    
    @Override
    public boolean updateUserRole(int userId, String role, int adminUserId) {
        return doInTransactionWithResult(em -> {
            UserDAOImpl dao = new UserDAOImpl(em);
            
            // Check if user is admin
            User admin = dao.findById(adminUserId);
            if (admin == null || !"admin".equals(admin.getRole())) {
                return false;
            }
            
            return dao.updateUserRole(userId, role);
        }, "Error updating user role");
    }
    
    @Override
    public boolean resetPassword(int userId, String newPassword, int adminUserId) {
        return doInTransactionWithResult(em -> {
            UserDAOImpl dao = new UserDAOImpl(em);
            
            // Check if user is admin
            User admin = dao.findById(adminUserId);
            if (admin == null || !"admin".equals(admin.getRole())) {
                return false;
            }
            
            // Validate password
            if (!validatePassword(newPassword)) {
                return false;
            }
            
            String hashedPassword = PasswordHasher.hashPassword(newPassword);
            return dao.changePassword(userId, hashedPassword);
        }, "Error resetting password");
    }
    
    @Override
    public int getTotalPages(int pageSize, int adminUserId) {
        return doInTransactionWithResult(em -> {
            UserDAOImpl dao = new UserDAOImpl(em);
            
            // Check if user is admin
            User admin = dao.findById(adminUserId);
            if (admin == null || !"admin".equals(admin.getRole())) {
                return 0;
            }
            
            String jpql = "SELECT COUNT(u) FROM User u WHERE u.isDeleted = false";
            Long count = em.createQuery(jpql, Long.class).getSingleResult();
            return (int) Math.ceil((double) count / pageSize);
        }, "Error getting total pages");
    }
    
    @Override
    public UserStatistics getUserStatistics(int adminUserId) {
        return doInTransactionWithResult(em -> {
            UserDAOImpl dao = new UserDAOImpl(em);
            
            // Check if user is admin
            User admin = dao.findById(adminUserId);
            if (admin == null || !"admin".equals(admin.getRole())) {
                return new UserStatistics();
            }
            
            String jpql = "SELECT COUNT(u), " +
                          "SUM(CASE WHEN u.status = 'active' THEN 1 ELSE 0 END), " +
                          "SUM(CASE WHEN u.status = 'inactive' THEN 1 ELSE 0 END), " +
                          "SUM(CASE WHEN u.role = 'admin' THEN 1 ELSE 0 END), " +
                          "SUM(CASE WHEN u.role = 'customer' THEN 1 ELSE 0 END), " +
                          "SUM(CASE WHEN u.createdAt >= :oneMonthAgo THEN 1 ELSE 0 END) " +
                          "FROM User u WHERE u.isDeleted = false";
            
            Date oneMonthAgo = new Date(System.currentTimeMillis() - 30L * 24 * 60 * 60 * 1000);
            
            Object[] results = (Object[]) em.createQuery(jpql)
                    .setParameter("oneMonthAgo", oneMonthAgo)
                    .getSingleResult();
            
            return new UserStatistics(
                    ((Number) results[0]).intValue(),
                    ((Number) results[1]).intValue(),
                    ((Number) results[2]).intValue(),
                    ((Number) results[3]).intValue(),
                    ((Number) results[4]).intValue(),
                    ((Number) results[5]).intValue()
            );
        }, "Error getting user statistics");
    }
    
    @Override
    public boolean isUserAdmin(int userId) {
        return doInTransactionWithResult(em -> {
            UserDAOImpl dao = new UserDAOImpl(em);
            User user = dao.findById(userId);
            return user != null && "admin".equals(user.getRole());
        }, "Error checking if user is admin");
    }
    
    @Override
    public boolean validateUserData(User user) {
        if (user == null) return false;
        
        // Validate username
        if (user.getUsername() == null || user.getUsername().trim().length() < 3 || user.getUsername().trim().length() > 50) {
            return false;
        }
        
        // Validate email
        if (user.getEmail() == null || !user.getEmail().matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
            return false;
        }
        
        // Validate password (only for new users)
        if (user.getUserId() == null && !validatePassword(user.getPassword())) {
            return false;
        }
        
        return true;
    }
    
    @Override
    public boolean validatePassword(String password) {
        if (password == null) return false;
        
        // Simple validation: at least 6 characters
        return password.length() >= 6;
        
        // For stronger validation, use:
        // return password.matches("^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$%^&+=])(?=\\S+$).{8,}$");
    }
    
    @Override
    public int getTotalUsers(int adminUserId) {
        return doInTransactionWithResult(em -> {
            UserDAOImpl dao = new UserDAOImpl(em);
            
            // Check if user is admin
            User admin = dao.findById(adminUserId);
            if (admin == null || !"admin".equals(admin.getRole())) {
                return 0;
            }
            
            String jpql = "SELECT COUNT(u) FROM User u WHERE u.isDeleted = false";
            Long count = em.createQuery(jpql, Long.class).getSingleResult();
            return count.intValue();
        }, "Error getting total users");
    }
}
