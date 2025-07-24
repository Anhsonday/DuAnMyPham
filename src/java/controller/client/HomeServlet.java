package controller.client;

import model.entity.User;
import model.entity.Product;
import model.entity.Category;
import model.entity.ProductImage;

import service.impl.ProductServiceImpl;
import service.impl.CategoryServiceImpl;
import service.impl.ProductImageServiceImpl;
import service.interfaces.ProductService;
import service.interfaces.CategoryService;
import service.interfaces.ProductImageService;
import service.interfaces.WishlistService;
import service.impl.WishlistServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;
import java.util.ArrayList;
import java.util.Map;
import java.util.HashMap;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "HomeServlet", urlPatterns = {"/home"})
public class HomeServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(HomeServlet.class.getName());
    private ProductService productService;
    private CategoryService categoryService;
    private WishlistService wishlistService;
    private ProductImageService productImageService;
    private static final int PRODUCTS_LIMIT = 84;
    
    @Override
    public void init() throws ServletException {
        super.init();
        productService = new ProductServiceImpl();
        categoryService = new CategoryServiceImpl();
        wishlistService = new WishlistServiceImpl();
        productImageService = new ProductImageServiceImpl();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        Map<Integer, Boolean> inWishlist = new HashMap<>();
        
        try {
            // Lấy các category chính cho navigation
            List<Category> allCategories = categoryService.getAllCategories();
            List<Category> mainCategories = new ArrayList<>();
            
            // Lọc các category chính (parent category với tên cụ thể)
            for (Category cat : allCategories) {
                if (cat.getParentCategoryId() != null && cat.getParentCategoryId().getCategoryId() == 1
                        && "active".equalsIgnoreCase(cat.getStatus()) 
                        && cat.getIsDeleted() != null && !cat.getIsDeleted()
                        && (cat.getCategoryName().equals("Chăm sóc da")
                            || cat.getCategoryName().equals("Chăm sóc tóc")
                            || cat.getCategoryName().equals("Chăm sóc cơ thể")
                            || cat.getCategoryName().equals("Nước hoa"))) {
                    mainCategories.add(cat);
                }
            }
            request.setAttribute("parentCategories", mainCategories);

            // Load products cho các tab
            Map<Integer, String> productImages = new HashMap<>();
            
            // Featured products (sản phẩm nổi bật)
            List<Product> featuredProducts = productService.getFeaturedProducts(PRODUCTS_LIMIT);
            
            // Top rated products (sản phẩm đánh giá cao)
            List<Product> topRatedProducts = productService.getTopRatedProducts(PRODUCTS_LIMIT);
            
            // On sale products (sản phẩm giảm giá)
            List<Product> onSaleProducts = productService.getOnSaleProducts(PRODUCTS_LIMIT);
            
            // Lấy tất cả sản phẩm để hiển thị
            List<Product> allProductsToDisplay = new ArrayList<>();
            allProductsToDisplay.addAll(featuredProducts);
            allProductsToDisplay.addAll(topRatedProducts);
            allProductsToDisplay.addAll(onSaleProducts);
            
            // Lấy hình ảnh chính cho tất cả sản phẩm
            for (Product p : allProductsToDisplay) {
                if (!productImages.containsKey(p.getProductId())) {
                    ProductImage mainImage = productImageService.findMainImageByProductId(p.getProductId());
                    if (mainImage != null) {
                        productImages.put(p.getProductId(), mainImage.getImageUrl());
                    }
                }
            }
            
            // Bestseller cho từng danh mục cha (con trực tiếp của Mỹ phẩm, id=1)
            Map<Integer, Product> bestsellers = new HashMap<>();
            System.out.println("========== DEBUG BESTSELLER ==========");
            for (Category cat : allCategories) {
                if (cat.getParentCategoryId() != null && cat.getParentCategoryId().getCategoryId() == 1) {
                    System.out.println("Category: " + cat.getCategoryName() + " (ID: " + cat.getCategoryId() + ")");
                    // Lấy tất cả categoryId con (bao gồm cả chính nó nếu cần)
                    List<Integer> childCatIds = new ArrayList<>();
                    childCatIds.add(cat.getCategoryId());
                    for (Category sub : allCategories) {
                        if (sub.getParentCategoryId() != null && sub.getParentCategoryId().getCategoryId().equals(cat.getCategoryId())) {
                            childCatIds.add(sub.getCategoryId());
                        }
                    }
                    List<Product> productsInCat = new ArrayList<>();
                    for (Integer cid : childCatIds) {
                        productsInCat.addAll(productService.getProductsByCategory(cid));
                    }
                    Product riceWaterBright = null;
                    if (!productsInCat.isEmpty()) {
                        for (Product p : productsInCat) {
                            System.out.println("  Product: " + p.getProductName() + " (ID: " + p.getProductId() + ")");
                            if (p.getProductName() != null && p.getProductName().toLowerCase().contains("rice water bright")) {
                                riceWaterBright = p;
                                System.out.println("  -> Found Rice Water Bright as bestseller");
                                break;
                            }
                        }
                        Product bestseller = riceWaterBright != null ? riceWaterBright : productsInCat.get(0);
                        bestsellers.put(cat.getCategoryId(), bestseller);
                        System.out.println("  -> Set bestseller: " + bestseller.getProductName() + " (ID: " + bestseller.getProductId() + ")");
                        ProductImage mainImage = productImageService.findMainImageByProductId(bestseller.getProductId());
                        if (mainImage != null) {
                            productImages.put(bestseller.getProductId(), mainImage.getImageUrl());
                            System.out.println("  -> Main image: " + mainImage.getImageUrl());
                        } else {
                            System.out.println("  -> No main image for product " + bestseller.getProductName());
                        }
                    } else {
                        System.out.println("  -> No products in this category or its subcategories");
                    }
                }
            }
            System.out.println("Bestseller map summary:");
            for (Map.Entry<Integer, Product> entry : bestsellers.entrySet()) {
                System.out.println("CategoryId: " + entry.getKey() + " - Product: " + entry.getValue().getProductName());
            }
            System.out.println("=======================================");
            request.setAttribute("bestsellers", bestsellers);
            
            // Kiểm tra wishlist cho user đã đăng nhập
            if (user != null) {
                for (Product p : allProductsToDisplay) {
                    inWishlist.put(p.getProductId(), wishlistService.isInWishlist(user.getUserId(), p.getProductId()));
                }
                
                // Lấy số lượng wishlist cho user đã đăng nhập
                int wishlistCount = wishlistService.getWishlistCount(user.getUserId());
                request.setAttribute("wishlistCount", wishlistCount);
            } else {
                request.setAttribute("wishlistCount", 0);
            }
            
            // Set attributes cho JSP
            request.setAttribute("featuredProducts", featuredProducts);
            request.setAttribute("topRatedProducts", topRatedProducts);
            request.setAttribute("onSaleProducts", onSaleProducts);
            request.setAttribute("productImages", productImages);
            request.setAttribute("inWishlist", inWishlist);
            

            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error loading home data", e);
            // Set default values khi có lỗi
            request.setAttribute("parentCategories", new ArrayList<Category>());
            request.setAttribute("featuredProducts", new ArrayList<Product>());
            request.setAttribute("topRatedProducts", new ArrayList<Product>());
            request.setAttribute("onSaleProducts", new ArrayList<Product>());
            request.setAttribute("productImages", new HashMap<Integer, String>());
            request.setAttribute("inWishlist", new HashMap<Integer, Boolean>());
            request.setAttribute("wishlistCount", 0);
        }
        
        // Kiểm tra role của user để hiển thị dashboard link
        if (user != null && "admin".equals(user.getRole())) {
            request.setAttribute("showDashboard", true);
        }
        
        // Forward đến home.jsp
        request.getRequestDispatcher("home.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}