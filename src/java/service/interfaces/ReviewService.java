package service.interfaces;

import model.entity.Review;
import java.util.List;

public interface ReviewService {
    void add(Review review);
    List<Review> getReviewsByProductId(int productId, boolean onlyApproved);
    boolean hasUserReviewedProduct(int userId, int productId, int orderId);
    boolean canUserReview(int userId, int productId);
    void approveReview(int reviewId);
    void rejectReview(int reviewId);
    /**
     * Lấy review theo ID
     */
    Review getReviewById(int reviewId);
    /**
     * Cập nhật review
     */
    void updateReview(model.entity.Review review);
} 