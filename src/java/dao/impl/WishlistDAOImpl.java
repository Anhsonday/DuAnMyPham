package dao.impl;

import dao.interfaces.WishlistDAO;
import jakarta.persistence.EntityManager;
import java.util.List;
import model.entity.Wishlist;

public class WishlistDAOImpl extends GenericDAO<Wishlist, Integer> implements WishlistDAO {
    public WishlistDAOImpl(EntityManager em) {
        super(em, Wishlist.class);
    }

    @Override
    public List<Wishlist> findByUserId(Integer userId) {
        String jpql = "SELECT w FROM Wishlist w " +
                     "JOIN FETCH w.productId p " +
                     "LEFT JOIN FETCH p.productImagesCollection " +
                     "LEFT JOIN FETCH p.categoryId " +
                     "WHERE w.userId.userId = :userId AND w.isDeleted = false";
        return em.createQuery(jpql, Wishlist.class)
                 .setParameter("userId", userId)
                 .getResultList();
    }

    @Override
    public boolean isProductInWishlist(Integer userId, Integer productId) {
        String jpql = "SELECT COUNT(w) FROM Wishlist w WHERE w.userId.userId = :userId AND w.productId.productId = :productId AND w.isDeleted = false";
        Long count = em.createQuery(jpql, Long.class)
                       .setParameter("userId", userId)
                       .setParameter("productId", productId)
                       .getSingleResult();
        return count > 0;
    }

    @Override
    public int getWishlistCount(Integer userId) {
        String jpql = "SELECT COUNT(w) FROM Wishlist w WHERE w.userId.userId = :userId AND w.isDeleted = false";
        Long count = em.createQuery(jpql, Long.class)
                       .setParameter("userId", userId)
                       .getSingleResult();
        return count.intValue();
    }

    @Override
    public void removeFromWishlist(Integer userId, Integer productId) {
        System.out.println("Removing from wishlist - UserId: " + userId + ", ProductId: " + productId);
        
        String jpql = "UPDATE Wishlist w SET w.isDeleted = true WHERE w.userId.userId = :userId AND w.productId.productId = :productId";
        
        try {
            int updated = em.createQuery(jpql)
                .setParameter("userId", userId)
                .setParameter("productId", productId)
                .executeUpdate();
                
            System.out.println("Number of records updated: " + updated);
            
            if (updated == 0) {
                throw new RuntimeException("Không tìm thấy sản phẩm trong danh sách yêu thích");
            }
            
            // Đảm bảo thay đổi được lưu vào database
            em.flush();
            
        } catch (Exception e) {
            System.err.println("Error in removeFromWishlist: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Lỗi khi xóa sản phẩm khỏi danh sách yêu thích", e);
        }
    }
}
