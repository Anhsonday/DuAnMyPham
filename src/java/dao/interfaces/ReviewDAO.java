package dao.interfaces;

import model.entity.Review;
import java.util.List;

public interface ReviewDAO extends IGenericDAO<Review, Integer> {
    List<Review> getReviewsByProductId(int productId, boolean onlyApproved);
    boolean hasUserReviewedProduct(int userId, int productId, int orderId);
    boolean canUserReview(int userId, int productId);
    void approveReview(int reviewId);
    void rejectReview(int reviewId);
} 