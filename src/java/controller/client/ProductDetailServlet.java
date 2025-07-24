package controller.client;

import service.impl.ProductServiceImpl;
import service.impl.ProductDetailServiceImpl;
import service.impl.CategoryServiceImpl;
import service.interfaces.ProductService;
import service.interfaces.ProductDetailService;
import service.interfaces.CategoryService;
import model.entity.Product;
import model.entity.ProductDetail;
import model.entity.ProductImage;
import model.entity.Category;
import model.entity.User;
import service.interfaces.WishlistService;
import service.impl.WishlistServiceImpl;
import service.impl.ProductImageServiceImpl;
import service.interfaces.ProductImageService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.HashMap;
import java.util.Map;
import java.util.ArrayList;

@WebServlet(name = "ProductDetailServlet", urlPatterns = {"/product-detail"})
public class ProductDetailServlet extends HttpServlet {
    private ProductService productService;
    private ProductDetailService productDetailService;
    private CategoryService categoryService;
    private WishlistService wishlistService;
    private ProductImageService productImageService;

    @Override
    public void init() throws ServletException {
        productService = new ProductServiceImpl();
        productDetailService = new ProductDetailServiceImpl();
        categoryService = new CategoryServiceImpl();
        wishlistService = new WishlistServiceImpl();
        productImageService = new ProductImageServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("=== TEST DEBUG LOG: ProductDetailServlet doGet called ===");
        String productIdStr = request.getParameter("id");
        System.out.println("[DEBUG] ProductDetailServlet - Product ID from request: " + productIdStr);
        
        if (productIdStr == null || productIdStr.trim().isEmpty()) {
            System.out.println("[DEBUG] Redirect: productIdStr null or empty");
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }
        
        int productId;
        try {
            productId = Integer.parseInt(productIdStr);
            System.out.println("[DEBUG] ProductDetailServlet - Parsed product ID: " + productId);
        } catch (NumberFormatException e) {
            System.out.println("[DEBUG] Redirect: productIdStr not a number: " + productIdStr);
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        boolean isAdmin = user != null && "admin".equals(user.getRole());
        System.out.println("[DEBUG] Session user: " + (user != null ? user.getUsername() : "null") + ", role: " + (user != null ? user.getRole() : "null") + ", isAdmin: " + isAdmin);
        
        try {
            Product product = productService.getProductByIdWithAccessControl(productId, user);
            System.out.println("[DEBUG] Product object: " + product);
            System.out.println("[DEBUG] Product from DB: " + (product != null ? product.getProductName() : "null"));
            System.out.println("[DEBUG] Product status: " + (product != null ? product.getStatus() : "null"));
            System.out.println("[DEBUG] Product isDeleted: " + (product != null ? product.getIsDeleted() : "null"));
            System.out.println("[DEBUG] Product category: " + (product != null && product.getCategoryId() != null ? product.getCategoryId().getCategoryName() : "null"));
            
            if (product == null) {
                System.out.println("[DEBUG] Redirect: product not found or access denied for ID: " + productId);
                response.sendRedirect(request.getContextPath() + "/home");
                return;
            }
            
            // Kiểm tra trạng thái sản phẩm
            boolean isDeleted = Boolean.TRUE.equals(product.getIsDeleted());
            boolean isActive = "active".equals(product.getStatus());
            
            System.out.println("[DEBUG] Product: " + product.getProductName() + ", isDeleted: " + isDeleted + ", status: " + product.getStatus());
            
            // Admin có thể xem tất cả sản phẩm, nhưng hiển thị thông báo nếu sản phẩm đã bị xóa
            if (isAdmin && isDeleted) {
                request.setAttribute("productDeleted", true);
                request.setAttribute("deletedMessage", "Sản phẩm này đã bị xóa và chỉ admin mới có thể xem.");
            }
            
            System.out.println("Found product: " + product.getProductName()); // Debug line
            
            ProductDetail productDetail = productDetailService.getProductDetailByProductId(productId);
            List<ProductImage> images = productImageService.findByProductId(productId);
            System.out.println("[DEBUG] Images: " + (images != null ? images.size() : "null"));
            Category category = null;
            if (product.getCategoryId() != null) {
                category = product.getCategoryId();
            }
            System.out.println("[DEBUG] Category: " + (category != null ? category.getCategoryName() : "null"));
            
            // Lấy sản phẩm liên quan (cùng danh mục, không bao gồm sản phẩm hiện tại)
            // Chỉ hiển thị sản phẩm liên quan cho customer nếu sản phẩm hiện tại chưa bị xóa và có status = "active"
            List<Product> relatedProducts = new ArrayList<>();
            if (product.getCategoryId() != null && (isAdmin || (!isDeleted && isActive))) {
                List<Product> allProducts = productService.getActiveProducts();
                System.out.println("Found " + (allProducts != null ? allProducts.size() : 0) + " total products"); // Debug line
                
                if (allProducts != null) {
                    for (Product p : allProducts) {
                        try {
                            if (p != null && 
                                p.getCategoryId() != null && 
                                product.getCategoryId() != null &&
                                p.getCategoryId().getCategoryId().equals(product.getCategoryId().getCategoryId()) && 
                                !p.getProductId().equals(product.getProductId()) &&
                                "active".equals(p.getStatus()) &&
                                !Boolean.TRUE.equals(p.getIsDeleted()) &&
                                p.getStock() > 0) {
                                relatedProducts.add(p);
                                if (relatedProducts.size() >= 5) break;
                            }
                        } catch (Exception e) {
                            System.out.println("Error processing product: " + e.getMessage()); // Debug line
                            continue;
                        }
                    }
                }
            }
            
            System.out.println("Found " + relatedProducts.size() + " related products"); // Debug line
            
            // Lấy ảnh chính cho các sản phẩm liên quan
            Map<Integer, String> relatedProductImages = new HashMap<>();
            for (Product p : relatedProducts) {
                ProductImage mainImage = productImageService.findMainImageByProductId(p.getProductId());
                if (mainImage != null) {
                    relatedProductImages.put(p.getProductId(), mainImage.getImageUrl());
                }
            }

            // Chuẩn bị productImages map cho JSP (productId -> main image)
            Map<Integer, String> productImages = new HashMap<>();
            if (images != null && !images.isEmpty()) {
                String mainImage = null;
                for (ProductImage img : images) {
                    if (Boolean.TRUE.equals(img.getIsMainImage())) {
                        mainImage = img.getImageUrl();
                        break;
                    }
                }
                if (mainImage == null) {
                    mainImage = images.get(0).getImageUrl();
                }
                productImages.put(productId, mainImage);
            }
            
            request.setAttribute("product", product);
            request.setAttribute("productDetail", productDetail);
            request.setAttribute("images", images);
            request.setAttribute("category", category);
            request.setAttribute("productImages", productImages);
            request.setAttribute("relatedProducts", relatedProducts);
            request.setAttribute("relatedProductImages", relatedProductImages);
            
            // Kiểm tra sản phẩm có trong wishlist không (nếu đã đăng nhập)
            boolean inWishlist = false;
            
            if (user != null) {
                inWishlist = wishlistService.isInWishlist(user.getUserId(), productId);
                int wishlistCount = wishlistService.getWishlistCount(user.getUserId());
                request.setAttribute("wishlistCount", wishlistCount);
            } else {
                request.setAttribute("wishlistCount", 0);
            }
            
            request.setAttribute("inWishlist", inWishlist);

            // Xác định quyền review cho user hiện tại
            // Chỉ cho phép review nếu sản phẩm chưa bị xóa và có status = "active"
            boolean canReview = false;
            try {
                if (user != null && !isAdmin && !isDeleted && isActive) {
                    service.interfaces.ReviewService reviewService2 = new service.impl.ReviewServiceImpl();
                    service.interfaces.OrderService orderService = new service.impl.OrderServiceImpl();
                    java.util.List<Integer> orderIds = orderService.findDeliveredOrCompletedOrderIdsForUserAndProduct(user.getUserId(), productId);
                    System.out.println("[DEBUG][REVIEW] userId=" + user.getUserId() + ", productId=" + productId + ", orderIds=" + orderIds);
                    boolean hasUnreviewedOrder = false;
                    for (Integer orderId : orderIds) {
                        boolean reviewed = reviewService2.hasUserReviewedProduct(user.getUserId(), productId, orderId);
                        System.out.println("[DEBUG][REVIEW] orderId=" + orderId + ", reviewed=" + reviewed);
                        if (!reviewed) {
                            hasUnreviewedOrder = true;
                        }
                    }
                    canReview = !orderIds.isEmpty() && hasUnreviewedOrder;
                    System.out.println("[DEBUG][REVIEW] canReview=" + canReview);
                }
            } catch (Exception e) {
                System.out.println("[DEBUG] Error checking if user can review: " + e.getMessage());
                e.printStackTrace();
                // Không redirect, chỉ log lỗi và để canReview = false
            }
            request.setAttribute("canReview", canReview);

            // Lấy danh sách review đã duyệt cho sản phẩm
            service.interfaces.ReviewService reviewService = new service.impl.ReviewServiceImpl();
            java.util.List<model.entity.Review> reviews = reviewService.getReviewsByProductId(productId, true);
            System.out.println("[DEBUG] Reviews: " + (reviews != null ? reviews.size() : "null"));
            request.setAttribute("reviews", reviews);

            // (Optional) Tính toán reviewStats nếu cần cho giao diện
            if (reviews != null && !reviews.isEmpty()) {
                double avgRating = reviews.stream().mapToInt(model.entity.Review::getRating).average().orElse(0.0);
                int totalReviews = reviews.size();
                java.util.Map<Integer, Long> ratingDistribution = reviews.stream().collect(java.util.stream.Collectors.groupingBy(model.entity.Review::getRating, java.util.stream.Collectors.counting()));
                java.util.Map<String, Object> reviewStats = new java.util.HashMap<>();
                reviewStats.put("averageRating", avgRating);
                reviewStats.put("totalReviews", totalReviews);
                java.util.List<java.util.Map<String, Object>> ratingDistList = new java.util.ArrayList<>();
                for (int i = 5; i >= 1; i--) {
                    long count = ratingDistribution.getOrDefault(i, 0L);
                    double percent = totalReviews > 0 ? (count * 100.0 / totalReviews) : 0;
                    java.util.Map<String, Object> stat = new java.util.HashMap<>();
                    stat.put("rating", i);
                    stat.put("count", count);
                    stat.put("percentage", percent);
                    ratingDistList.add(stat);
                }
                reviewStats.put("ratingDistribution", ratingDistList);
                request.setAttribute("reviewStats", reviewStats);
            } else {
                request.setAttribute("reviewStats", null);
            }

            System.out.println("[DEBUG] Forwarding to product-detail.jsp with product: " + (product != null ? product.getProductName() : "null"));
            request.getRequestDispatcher("/product-detail.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.out.println("[DEBUG] ProductDetailServlet - Exception: " + e.getMessage());
            e.printStackTrace();
            System.out.println("[DEBUG] Redirect: Exception occurred, redirecting to home");
            response.sendRedirect(request.getContextPath() + "");
        }
    }
} 