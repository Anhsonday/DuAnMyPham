package controller.client;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.entity.Review;
import model.entity.User;
import model.entity.Product;
import model.entity.Order;
import service.impl.ReviewServiceImpl;
import service.impl.ProductServiceImpl;
import service.impl.OrderServiceImpl;
import service.interfaces.ReviewService;
import service.interfaces.ProductService;
import service.interfaces.OrderService;
import java.io.IOException;
import java.util.Date;

@WebServlet(name = "ReviewServlet", urlPatterns = {"/review/add", "/review/edit", "/review/delete"})
public class ReviewServlet extends HttpServlet {
    private ReviewService reviewService;
    private ProductService productService;
    private OrderService orderService;

    @Override
    public void init() throws ServletException {
        reviewService = new ReviewServiceImpl();
        productService = new ProductServiceImpl();
        orderService = new OrderServiceImpl();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String servletPath = request.getServletPath();
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login?redirect=" + request.getRequestURI());
            return;
        }
        try {
            if ("/review/add".equals(servletPath)) {
                int productId = Integer.parseInt(request.getParameter("productId"));
                int rating = Integer.parseInt(request.getParameter("rating"));
                String comment = request.getParameter("comment");
                String skinCondition = request.getParameter("skinCondition");
                if (!reviewService.canUserReview(user.getUserId(), productId)) {
                    response.sendRedirect(request.getContextPath() + "/product-detail?id=" + productId + "&reviewError=notallowed#tab_3rd");
                    return;
                }
                Integer orderId = orderService.findDeliveredOrderIdForUserAndProduct(user.getUserId(), productId);
                if (orderId == null) {
                    response.sendRedirect(request.getContextPath() + "/product-detail?id=" + productId + "&reviewError=noorder#tab_3rd");
                    return;
                }
                if (reviewService.hasUserReviewedProduct(user.getUserId(), productId, orderId)) {
                    response.sendRedirect(request.getContextPath() + "/product-detail?id=" + productId + "&reviewError=already#tab_3rd");
                    return;
                }
                Review review = new Review();
                review.setProductId(productService.getProductById(productId));
                review.setUserId(user);
                review.setOrderId(orderService.getOrderById(orderId));
                review.setRating(rating);
                review.setComment(comment);
                review.setSkinCondition(skinCondition);
                review.setReviewDate(new Date());
                review.setStatus("approved");
                review.setIsVerifiedPurchase(true);
                review.setIsDeleted(false);
                review.setUpdatedAt(null); // Đảm bảo review mới không có updatedAt
                reviewService.add(review);
                response.sendRedirect(request.getContextPath() + "/product-detail?id=" + productId + "&reviewSuccess=1#tab_3rd");
                return;
            } else if ("/review/edit".equals(servletPath)) {
                int reviewId = Integer.parseInt(request.getParameter("reviewId"));
                String comment = request.getParameter("comment");
                int rating = Integer.parseInt(request.getParameter("rating"));
                String skinCondition = request.getParameter("skinCondition");
                Review review = reviewService.getReviewById(reviewId);
                if (review == null || review.getUserId().getUserId() != user.getUserId()) {
                    response.sendError(403, "Không có quyền sửa review này!");
                    return;
                }
                review.setComment(comment);
                review.setRating(rating);
                review.setSkinCondition(skinCondition);
                review.setUpdatedAt(new Date());
                reviewService.updateReview(review);
                response.sendRedirect(request.getContextPath() + "/product-detail?id=" + review.getProductId().getProductId() + "&reviewEdit=1#tab_3rd");
                return;
            } else if ("/review/delete".equals(servletPath)) {
                int reviewId = Integer.parseInt(request.getParameter("reviewId"));
                Review review = reviewService.getReviewById(reviewId);
                if (review == null || review.getUserId().getUserId() != user.getUserId()) {
                    response.sendError(403, "Không có quyền xoá review này!");
                    return;
                }
                review.setIsDeleted(true);
                review.setUpdatedAt(new Date());
                reviewService.updateReview(review);
                response.sendRedirect(request.getContextPath() + "/product-detail?id=" + review.getProductId().getProductId() + "&reviewDeleted=1#tab_3rd");
                return;
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/product-detail?id=" + request.getParameter("productId") + "&reviewError=exception#tab_3rd");
        }
    }

    // GET cho edit review
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String servletPath = request.getServletPath();
        if ("/review/edit".equals(servletPath)) {
            int reviewId = Integer.parseInt(request.getParameter("id"));
            Review review = reviewService.getReviewById(reviewId);
            User user = (User) request.getSession().getAttribute("user");
            if (review == null || user == null || review.getUserId().getUserId() != user.getUserId()) {
                response.sendError(403, "Không có quyền sửa review này!");
                return;
            }
            request.setAttribute("review", review);
            request.getRequestDispatcher("/client/account/edit-review.jsp").forward(request, response);
        } else {
            super.doGet(request, response);
        }
    }
} 