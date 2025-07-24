package dao.impl;

import dao.interfaces.UserDAO;
import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import java.util.List;
import model.entity.User;

public class UserDAOImpl extends GenericDAO<User, Integer> implements UserDAO {

    public UserDAOImpl(EntityManager em) {
        super(em, User.class);
    }

    @Override
    public User findByUsername(String username) {
        String jpql = "SELECT u FROM User u WHERE u.username = :username AND u.isDeleted = false";
        try {
            return em.createQuery(jpql, User.class)
                     .setParameter("username", username)
                     .getSingleResult();
        } catch (NoResultException e) {
            return null;
        }
    }

    @Override
    public User findByEmail(String email) {
        String jpql = "SELECT u FROM User u WHERE u.email = :email AND u.isDeleted = false";
        try {
            return em.createQuery(jpql, User.class)
                     .setParameter("email", email)
                     .getSingleResult();
        } catch (NoResultException e) {
            return null;
        }
    }

    @Override
    public boolean isUsernameExists(String username) {
        String jpql = "SELECT COUNT(u) FROM User u WHERE u.username = :username AND u.isDeleted = false";
        Long count = em.createQuery(jpql, Long.class)
                       .setParameter("username", username)
                       .getSingleResult();
        return count > 0;
    }

    @Override
    public boolean isEmailExists(String email) {
        String jpql = "SELECT COUNT(u) FROM User u WHERE u.email = :email AND u.isDeleted = false";
        Long count = em.createQuery(jpql, Long.class)
                       .setParameter("email", email)
                       .getSingleResult();
        return count > 0;
    }

    @Override
    public boolean changePassword(int userId, String newPasswordHash) {
        User user = findById(userId);
        if (user != null) {
            user.setPassword(newPasswordHash);
            update(user);
            return true;
        }
        return false;
    }

    @Override
    public boolean updateLastLogin(int userId) {
        User user = findById(userId);
        if (user != null) {
            user.setLastLogin(new java.util.Date());
            update(user);
            return true;
        }
        return false;
    }

    @Override
    public List<User> searchUsers(String keyword) {
        String jpql = "SELECT u FROM User u WHERE u.isDeleted = false AND (u.username LIKE :kw OR u.email LIKE :kw OR u.fullName LIKE :kw OR u.phone LIKE :kw)";
        return em.createQuery(jpql, User.class)
                 .setParameter("kw", "%" + keyword + "%")
                 .getResultList();
    }

    @Override
    public List<User> getUsersByRole(String role) {
        String jpql = "SELECT u FROM User u WHERE u.role = :role AND u.isDeleted = false";
        return em.createQuery(jpql, User.class)
                 .setParameter("role", role)
                 .getResultList();
    }

    @Override
    public List<User> getUsersByStatus(String status) {
        String jpql = "SELECT u FROM User u WHERE u.status = :status AND u.isDeleted = false";
        return em.createQuery(jpql, User.class)
                 .setParameter("status", status)
                 .getResultList();
    }

    @Override
    public boolean updateUserStatus(int userId, String status) {
        User user = findById(userId);
        if (user != null) {
            user.setStatus(status);
            update(user);
            return true;
        }
        return false;
    }

    @Override
    public boolean updateUserRole(int userId, String role) {
        User user = findById(userId);
        if (user != null) {
            user.setRole(role);
            update(user);
            return true;
        }
        return false;
    }
}