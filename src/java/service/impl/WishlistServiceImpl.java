package service.impl;

import dao.impl.WishlistDAOImpl;
import java.util.Date;
import java.util.List;
import model.entity.Product;
import model.entity.User;
import model.entity.Wishlist;
import service.interfaces.WishlistService;

public class WishlistServiceImpl extends GenericService<Wishlist> implements WishlistService {

    @Override
    public List<Wishlist> findByUserId(Integer userId) {
        return doInTransactionForList(em -> {
            WishlistDAOImpl dao = new WishlistDAOImpl(em);
            return dao.findByUserId(userId);
        }, "Error getting wishlist by user ID");
    }

    @Override
    public List<Wishlist> getUserWishlist(Integer userId) {
        return doInTransactionForList(em -> {
            WishlistDAOImpl dao = new WishlistDAOImpl(em);
            return dao.findByUserId(userId);
        }, "Error getting wishlist");
    }

    @Override
    public boolean addToWishlist(Integer userId, Integer productId) {
        return doInTransactionWithResult(em -> {
            WishlistDAOImpl dao = new WishlistDAOImpl(em);
            if (dao.isProductInWishlist(userId, productId)) return false;
            User user = em.find(User.class, userId);
            Product product = em.find(Product.class, productId);
            if (user == null || product == null) return false;
            Wishlist w = new Wishlist();
            w.setUserId(user);
            w.setProductId(product);
            w.setAddedAt(new Date());
            w.setIsDeleted(false);
            dao.add(w);
            return true;
        }, "Error adding to wishlist");
    }

    @Override
    public boolean removeFromWishlist(Integer userId, Integer productId) {
        return doInTransactionWithResult(em -> {
            WishlistDAOImpl dao = new WishlistDAOImpl(em);
            if (!dao.isProductInWishlist(userId, productId)) return false;
            dao.removeFromWishlist(userId, productId);
            return true;
        }, "Error removing from wishlist");
    }

    @Override
    public boolean toggleWishlistItem(Integer userId, Integer productId) {
        return doInTransactionWithResult(em -> {
            WishlistDAOImpl dao = new WishlistDAOImpl(em);
            if (dao.isProductInWishlist(userId, productId)) {
                dao.removeFromWishlist(userId, productId);
                return false;
            } else {
                User user = em.find(User.class, userId);
                Product product = em.find(Product.class, productId);
                if (user == null || product == null) return false;
                Wishlist w = new Wishlist();
                w.setUserId(user);
                w.setProductId(product);
                w.setAddedAt(new Date());
                w.setIsDeleted(false);
                dao.add(w);
                return true;
            }
        }, "Error toggling wishlist item");
    }

    @Override
    public boolean toggleWishlist(Integer userId, Integer productId) {
        return toggleWishlistItem(userId, productId);
    }

    @Override
    public boolean isProductInWishlist(Integer userId, Integer productId) {
        return doInTransactionWithResult(em -> {
            WishlistDAOImpl dao = new WishlistDAOImpl(em);
            return dao.isProductInWishlist(userId, productId);
        }, "Error checking wishlist");
    }

    @Override
    public boolean isInWishlist(Integer userId, Integer productId) {
        return isProductInWishlist(userId, productId);
    }

    @Override
    public int getWishlistCount(Integer userId) {
        return doInTransactionWithResult(em -> {
            WishlistDAOImpl dao = new WishlistDAOImpl(em);
            return dao.getWishlistCount(userId);
        }, "Error getting wishlist count");
    }

    @Override
    public void clearWishlist(Integer userId) {
        doInTransaction(em -> {
            String jpql = "DELETE FROM Wishlist w WHERE w.userId.userId = :userId";
            em.createQuery(jpql).setParameter("userId", userId).executeUpdate();
        }, "Error clearing wishlist");
    }

    @Override
    public boolean removeWishlistItem(Integer wishlistId, Integer userId) {
        return doInTransactionWithResult(em -> {
            WishlistDAOImpl dao = new WishlistDAOImpl(em);
            Wishlist wishlist = dao.findById(wishlistId);
            System.out.println("Found wishlist item: " + wishlist);
            if (wishlist != null) {
                System.out.println("Wishlist user ID: " + wishlist.getUserId().getUserId() + ", Requested user ID: " + userId);
                if (wishlist.getUserId().getUserId().equals(userId)) {
                    dao.delete(wishlistId);
                    System.out.println("Successfully deleted wishlist item: " + wishlistId);
                    return true;
                } else {
                    System.out.println("User ID mismatch. Cannot delete wishlist item.");
                }
            } else {
                System.out.println("Wishlist item not found with ID: " + wishlistId);
            }
            return false;
        }, "Error removing wishlist item");
    }

    @Override
    public List<?> getMostWishedProducts(int limit) {
        return doInTransactionWithResult(em -> {
            String jpql = "SELECT p.productId, p.productName, COUNT(w) as wishCount " +
                         "FROM Wishlist w JOIN w.productId p " +
                         "WHERE w.isDeleted = false " +
                         "GROUP BY p.productId, p.productName " +
                         "ORDER BY wishCount DESC";
            return em.createQuery(jpql)
                    .setMaxResults(limit)
                    .getResultList();
        }, "Error getting most wished products");
    }
}
