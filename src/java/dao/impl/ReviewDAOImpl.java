package dao.impl;

import dao.interfaces.ReviewDAO;
import dao.impl.GenericDAO;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import model.entity.Review;
import java.util.List;

public class ReviewDAOImpl extends GenericDAO<Review, Integer> implements ReviewDAO {
    public ReviewDAOImpl(EntityManager em) {
        super(em, Review.class);
    }

    @Override
    public List<Review> getReviewsByProductId(int productId, boolean onlyApproved) {
        String jpql = "SELECT r FROM Review r WHERE r.productId.productId = :productId AND r.isDeleted = false";
        if (onlyApproved) {
            jpql += " AND r.status = 'approved'";
        }
        jpql += " ORDER BY r.reviewDate DESC";
        TypedQuery<Review> query = em.createQuery(jpql, Review.class);
        query.setParameter("productId", productId);
        return query.getResultList();
    }

    @Override
    public boolean hasUserReviewedProduct(int userId, int productId, int orderId) {
        String jpql = "SELECT COUNT(r) FROM Review r WHERE r.userId.userId = :userId AND r.productId.productId = :productId AND r.orderId.orderID = :orderId AND r.isDeleted = false";
        Long count = em.createQuery(jpql, Long.class)
            .setParameter("userId", userId)
            .setParameter("productId", productId)
            .setParameter("orderId", orderId)
            .getSingleResult();
        return count > 0;
    }

    @Override
    public boolean canUserReview(int userId, int productId) {
        String jpql = "SELECT COUNT(oi) FROM OrderItem oi JOIN oi.order o WHERE o.user.userId = :userId AND oi.product.productId = :productId AND (o.status = 'delivered' OR o.status = 'completed')";
        Long count = em.createQuery(jpql, Long.class)
            .setParameter("userId", userId)
            .setParameter("productId", productId)
            .getSingleResult();
        return count > 0;
    }

    @Override
    public void approveReview(int reviewId) {
        Review review = em.find(Review.class, reviewId);
        if (review != null) {
            review.setStatus("approved");
            em.merge(review);
        }
    }

    @Override
    public void rejectReview(int reviewId) {
        Review review = em.find(Review.class, reviewId);
        if (review != null) {
            review.setStatus("rejected");
            em.merge(review);
        }
    }
} 