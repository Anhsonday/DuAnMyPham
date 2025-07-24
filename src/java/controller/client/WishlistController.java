package controller.client;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import model.entity.User;
import model.entity.Wishlist;
import service.interfaces.WishlistService;
import service.impl.WishlistServiceImpl;


import com.google.gson.Gson;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Logger;
import java.util.logging.Level;
import java.util.ArrayList;

/**
 * Controller xử lý các thao tác với Wishlist
 */
@WebServlet(urlPatterns = {"/wishlist", "/wishlist/toggle", "/wishlist/count", "/wishlist/add", "/wishlist/remove", "/wishlist/check", "/wishlist/clear-all"})
public class WishlistController extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(WishlistController.class.getName());
    private WishlistService wishlistService;
    private Gson gson;
    
    @Override
    public void init() throws ServletException {
        this.wishlistService = new WishlistServiceImpl();
        this.gson = new Gson();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        String pathInfo = request.getServletPath();
        
        // Riêng với action=count không yêu cầu đăng nhập nếu gọi qua AJAX
        if ("/wishlist/count".equals(pathInfo)) {
            String ajaxRequest = request.getHeader("X-Requested-With");
            if ("XMLHttpRequest".equals(ajaxRequest) && currentUser != null) {
                handleGetWishlistCount(request, response, currentUser.getUserId());
                return;
            }
        }
        
        // Các action khác yêu cầu đăng nhập
        if (currentUser == null) {
            if (isAjaxRequest(request)) {
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                response.setContentType("application/json;charset=UTF-8");
                response.getWriter().write("{\"error\":\"Please login to continue\",\"redirect\":\"login\"}");
            } else {
                response.sendRedirect(request.getContextPath() + "/login?returnUrl=" + 
                                    request.getRequestURL().toString());
            }
            return;
        }
        
        String action = request.getParameter("action");
        
        try {
            switch (action != null ? action : "list") {
                case "list":
                    handleListWishlist(request, response, currentUser.getUserId());
                    break;
                case "check":
                    handleCheckWishlist(request, response, currentUser.getUserId());
                    break;
                case "count":
                    handleGetWishlistCount(request, response, currentUser.getUserId());
                    break;
                case "popular":
                    handleGetPopularProducts(request, response);
                    break;
                default:
                    handleListWishlist(request, response, currentUser.getUserId());
                    break;
            }
        } catch (Exception e) {
            LOGGER.severe("Error in WishlistController GET: " + e.getMessage());
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Đã xảy ra lỗi");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String pathInfo = request.getServletPath();
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"error\": \"Please login to continue\"}");
            return;
        }
        
        String action = request.getParameter("action");
        
        if ("/wishlist/toggle".equals(pathInfo)) {
            handleToggleWishlist(request, response, user.getUserId());
        } else if ("/wishlist/clear-all".equals(pathInfo)) {
            handleClearWishlist(request, response, user.getUserId());
        } else if ("remove".equals(action)) {
            handleRemoveFromWishlist(request, response, user.getUserId());
        } else if ("clear".equals(action)) {
            handleClearWishlist(request, response, user.getUserId());
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
    
    private void handleListWishlist(HttpServletRequest request, HttpServletResponse response, int userId) 
            throws ServletException, IOException {
        try {
            // Log thông tin kết nối
            LOGGER.info("Getting wishlist for user: " + userId);
            
            // Lấy danh sách wishlist từ service
            List<Wishlist> wishlist = wishlistService.getUserWishlist(userId);
            int wishlistCount = wishlistService.getWishlistCount(userId);
            
            // Log chi tiết để debug
            LOGGER.info("Retrieved wishlist for user " + userId + ": " + wishlist.size() + " items");
            if (wishlist.isEmpty()) {
                LOGGER.info("Wishlist is empty for user " + userId);
            } else {
                LOGGER.info("Wishlist items found: " + wishlist.size());
                for (Wishlist item : wishlist) {
                    LOGGER.info("Wishlist item: " + 
                              "ID=" + item.getWishlistId() + ", " +
                              "ProductID=" + item.getProductId().getProductId() + ", " +
                              "ProductName=" + item.getProductId().getProductName() + ", " +
                              "Price=" + item.getProductId().getPrice());
                }
            }
            
            // Set attributes cho request
            request.setAttribute("wishlist", wishlist);
            request.setAttribute("wishlistCount", wishlistCount);
            
            // Nếu là AJAX request thì trả về JSON
            String ajaxRequest = request.getHeader("X-Requested-With");
            if ("XMLHttpRequest".equals(ajaxRequest)) {
                Map<String, Object> data = new HashMap<>();
                data.put("wishlist", wishlist);
                data.put("count", wishlistCount);
                
                response.setContentType("application/json;charset=UTF-8");
                PrintWriter out = response.getWriter();
                out.print(gson.toJson(data));
                return;
            }
            
            // Forward đến trang wishlist.jsp
            request.getRequestDispatcher("/client/wishlist.jsp").forward(request, response);
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error in handleListWishlist", e);
            LOGGER.severe("Stack trace: " + e.getMessage());
            e.printStackTrace(); // In ra log chi tiết hơn
            
            // Set empty list nếu có lỗi
            request.setAttribute("wishlist", new ArrayList<>());
            request.setAttribute("wishlistCount", 0);
            request.setAttribute("error", "Đã xảy ra lỗi khi tải danh sách yêu thích: " + e.getMessage());
            
            request.getRequestDispatcher("/client/wishlist.jsp").forward(request, response);
        }
    }
    
    private void handleCheckWishlist(HttpServletRequest request, HttpServletResponse response, int userId) 
            throws ServletException, IOException {
        
        try {
            int productId = Integer.parseInt(request.getParameter("productId"));
            boolean inWishlist = wishlistService.isInWishlist(userId, productId);
            
            Map<String, Object> data = new HashMap<>();
            data.put("inWishlist", inWishlist);
            data.put("productId", productId);
            
            response.setContentType("application/json;charset=UTF-8");
            PrintWriter out = response.getWriter();
            out.print(gson.toJson(data));
            
        } catch (NumberFormatException e) {
            sendJsonResponse(response, false, "ID sản phẩm không hợp lệ");
        }
    }
    
    private void handleGetWishlistCount(HttpServletRequest request, HttpServletResponse response, int userId) 
            throws ServletException, IOException {
        
        int count = wishlistService.getWishlistCount(userId);
        
        Map<String, Object> data = new HashMap<>();
        data.put("count", count);
        
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        out.print(gson.toJson(data));
    }
    
    private void handleGetPopularProducts(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        int limit = 10;
        try {
            limit = Integer.parseInt(request.getParameter("limit"));
        } catch (NumberFormatException e) {
            // Use default limit
        }
        
        List<?> popularProducts = wishlistService.getMostWishedProducts(limit);
        
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        out.print(gson.toJson(popularProducts));
    }
    
    private void handleAddToWishlist(HttpServletRequest request, HttpServletResponse response, int userId) 
            throws ServletException, IOException {
        
        try {
            int productId = Integer.parseInt(request.getParameter("productId"));
            
            boolean success = wishlistService.addToWishlist(userId, productId);
            int newCount = wishlistService.getWishlistCount(userId);
            
            if (success) {
                sendJsonResponse(response, true, "Đã thêm vào danh sách yêu thích", newCount);
            } else {
                sendJsonResponse(response, false, "Không thể thêm vào danh sách yêu thích");
            }
            
        } catch (NumberFormatException e) {
            sendJsonResponse(response, false, "ID sản phẩm không hợp lệ");
        }
    }
    
    private void handleRemoveFromWishlist(HttpServletRequest request, HttpServletResponse response, int userId) 
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        
        try {
            String wishlistIdStr = request.getParameter("wishlistId");
            String productIdStr = request.getParameter("productId");
            
            LOGGER.info("Removing wishlist item - User ID: " + userId + ", Product ID: " + productIdStr);
            
            if (productIdStr != null && !productIdStr.isEmpty()) {
                int productId = Integer.parseInt(productIdStr);
                
                // Thực hiện xóa
                wishlistService.removeFromWishlist(userId, productId);
                
                // Lấy số lượng mới
                int newCount = wishlistService.getWishlistCount(userId);
                
                Map<String, Object> jsonResponse = new HashMap<>();
                jsonResponse.put("success", true);
                jsonResponse.put("message", "Đã xóa sản phẩm khỏi danh sách yêu thích");
                jsonResponse.put("count", newCount);
                
                String jsonString = gson.toJson(jsonResponse);
                response.getWriter().write(jsonString);
                
            } else {
                Map<String, Object> jsonResponse = new HashMap<>();
                jsonResponse.put("success", false);
                jsonResponse.put("message", "Thiếu thông tin sản phẩm");
                
                String jsonString = gson.toJson(jsonResponse);
                response.getWriter().write(jsonString);
            }
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error removing from wishlist", e);
            
            Map<String, Object> jsonResponse = new HashMap<>();
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Lỗi khi xóa sản phẩm: " + e.getMessage());
            
            String jsonString = gson.toJson(jsonResponse);
            response.getWriter().write(jsonString);
        }
    }
    
    private void handleToggleWishlist(HttpServletRequest request, HttpServletResponse response, int userId) 
            throws ServletException, IOException {
        String productIdStr = request.getParameter("productId");
        
        try {
            int productId = Integer.parseInt(productIdStr);
            boolean isInWishlist = wishlistService.toggleWishlist(userId, productId);
            
            // Get updated wishlist count
            int wishlistCount = wishlistService.getWishlistCount(userId);
            
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            
            Map<String, Object> jsonResponse = new HashMap<>();
            jsonResponse.put("success", true);
            jsonResponse.put("inWishlist", isInWishlist);
            jsonResponse.put("count", wishlistCount);
            jsonResponse.put("message", isInWishlist ? "Đã thêm vào danh sách yêu thích" : "Đã xóa khỏi danh sách yêu thích");
            
            String jsonString = gson.toJson(jsonResponse);
            response.getWriter().write(jsonString);
            
        } catch (NumberFormatException e) {
            LOGGER.log(Level.WARNING, "Invalid product ID format: " + productIdStr, e);
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"Invalid product ID\"}");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error toggling wishlist", e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"Internal server error\"}");
        }
    }
    
    private void handleClearWishlist(HttpServletRequest request, HttpServletResponse response, int userId) 
            throws ServletException, IOException {
        
        wishlistService.clearWishlist(userId);
        boolean success = true;
        
        if (success) {
            sendJsonResponse(response, true, "Đã xóa tất cả sản phẩm khỏi danh sách yêu thích", 0);
        } else {
            sendJsonResponse(response, false, "Không thể xóa danh sách yêu thích");
        }
    }
    
    private void sendJsonResponse(HttpServletResponse response, boolean success, String message) 
            throws IOException {
        sendJsonResponse(response, success, message, null, null);
    }
    
    private void sendJsonResponse(HttpServletResponse response, boolean success, String message, Integer count) 
            throws IOException {
        sendJsonResponse(response, success, message, count, null);
    }
    
    private void sendJsonResponse(HttpServletResponse response, boolean success, String message, 
                                Integer count, Boolean isAdded) throws IOException {
        Map<String, Object> jsonResponse = new HashMap<>();
        jsonResponse.put("success", success);
        jsonResponse.put("message", message);
        
        if (count != null) {
            jsonResponse.put("count", count);
        }
        
        if (isAdded != null) {
            jsonResponse.put("isAdded", isAdded);
        }
        
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        out.print(gson.toJson(jsonResponse));
    }
    
    private static class WishlistResponse {
        private final boolean success;
        private final boolean inWishlist;
        
        public WishlistResponse(boolean success, boolean inWishlist) {
            this.success = success;
            this.inWishlist = inWishlist;
        }
    }

    // Helper method to check if request is AJAX
    private boolean isAjaxRequest(HttpServletRequest request) {
        return "XMLHttpRequest".equals(request.getHeader("X-Requested-With"));
    }
}
