package controller.admin;

import model.entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.logging.Logger;
import service.impl.ReviewServiceImpl;
import service.interfaces.ReviewService;
import model.entity.Review;

/**
 * Admin Panel Controller - Main admin dashboard
 */
@WebServlet(name = "AdminPanelController", urlPatterns = {"/admin/reviews", "/admin/review/approve", "/admin/review/reject"})
public class AdminPanelController extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(AdminPanelController.class.getName());
    private ReviewService reviewService;

    @Override
    public void init() throws ServletException {
        reviewService = new ReviewServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check admin authentication
        if (!isAdminAuthenticated(request, response)) {
            return;
        }

        LOGGER.info("AdminPanelController: Loading admin panel");

        String action = request.getServletPath();
        if ("/admin/reviews".equals(action)) {
            // Thông báo không còn chức năng duyệt review
            request.setAttribute("pendingReviews", null);
            request.getRequestDispatcher("/admin/reviews.jsp").forward(request, response);
        } else if ("/admin/review/approve".equals(action)) {
            int reviewId = Integer.parseInt(request.getParameter("id"));
            reviewService.approveReview(reviewId);
            response.sendRedirect(request.getContextPath() + "/admin/reviews");
        } else if ("/admin/review/reject".equals(action)) {
            int reviewId = Integer.parseInt(request.getParameter("id"));
            reviewService.rejectReview(reviewId);
            response.sendRedirect(request.getContextPath() + "/admin/reviews");
        }
    }

    /**
     * Check if user is admin
     */
    private boolean isAdminAuthenticated(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }

        User user = (User) session.getAttribute("user");
        if (user == null || !"admin".equalsIgnoreCase(user.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied. Admin role required.");
            return false;
        }

        return true;
    }
}
