package service.impl;

import service.interfaces.ReviewService;
import dao.interfaces.ReviewDAO;
import dao.impl.ReviewDAOImpl;
import model.entity.Review;
import java.util.List;

public class ReviewServiceImpl extends GenericService<Review> implements ReviewService {
    @Override
    public List<Review> getReviewsByProductId(int productId, boolean onlyApproved) {
        return doInTransactionWithResult(em -> {
            ReviewDAO dao = new ReviewDAOImpl(em);
            return dao.getReviewsByProductId(productId, onlyApproved);
        }, "Error getting reviews by product ID");
    }

    @Override
    public boolean hasUserReviewedProduct(int userId, int productId, int orderId) {
        return doInTransactionWithResult(em -> {
            ReviewDAO dao = new ReviewDAOImpl(em);
            return dao.hasUserReviewedProduct(userId, productId, orderId);
        }, "Error checking if user reviewed product");
    }

    @Override
    public boolean canUserReview(int userId, int productId) {
        return doInTransactionWithResult(em -> {
            ReviewDAO dao = new ReviewDAOImpl(em);
            return dao.canUserReview(userId, productId);
        }, "Error checking if user can review");
    }

    @Override
    public void approveReview(int reviewId) {
        doInTransaction(em -> {
            ReviewDAO dao = new ReviewDAOImpl(em);
            dao.approveReview(reviewId);
        }, "Error approving review");
    }

    @Override
    public void rejectReview(int reviewId) {
        doInTransaction(em -> {
            ReviewDAO dao = new ReviewDAOImpl(em);
            dao.rejectReview(reviewId);
        }, "Error rejecting review");
    }

    @Override
    public void add(Review review) {
        doInTransaction(em -> {
            ReviewDAO dao = new ReviewDAOImpl(em);
            dao.add(review);
        }, "Error adding review");
    }

    @Override
    public Review getReviewById(int reviewId) {
        return doInTransactionWithResult(em -> {
            ReviewDAO dao = new ReviewDAOImpl(em);
            return dao.findById(reviewId);
        }, "Error getting review by ID");
    }

    @Override
    public void updateReview(Review review) {
        doInTransaction(em -> {
            ReviewDAO dao = new ReviewDAOImpl(em);
            dao.update(review);
        }, "Error updating review");
    }
} 