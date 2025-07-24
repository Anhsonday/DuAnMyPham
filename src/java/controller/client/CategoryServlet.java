package controller.client;

import model.entity.User;
import model.entity.Product;
import model.entity.Category;
import model.entity.ProductImage;

import service.impl.ProductServiceImpl;
import service.impl.CategoryServiceImpl;
import service.impl.ProductImageServiceImpl;
import service.impl.WishlistServiceImpl;
import service.interfaces.ProductService;
import service.interfaces.CategoryService;
import service.interfaces.ProductImageService;
import service.interfaces.WishlistService;
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
import java.math.BigDecimal;

@WebServlet(name = "CategoryServlet", urlPatterns = {"/category/*"})
public class CategoryServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(CategoryServlet.class.getName());
    private ProductService productService;
    private CategoryService categoryService;
    private ProductImageService productImageService;
    private WishlistService wishlistService;
    
    // Define number of products per page
    private static final int PRODUCTS_PER_PAGE = 9;
    
    @Override
    public void init() throws ServletException {
        super.init();
        productService = new ProductServiceImpl();
        categoryService = new CategoryServiceImpl();
        productImageService = new ProductImageServiceImpl();
        wishlistService = new WishlistServiceImpl();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            // Debug: In ra tất cả request parameters
            System.out.println("DEBUG: All request parameters:");
            java.util.Enumeration<String> paramNames = request.getParameterNames();
            while (paramNames.hasMoreElements()) {
                String paramName = paramNames.nextElement();
                String[] paramValues = request.getParameterValues(paramName);
                for (String value : paramValues) {
                    System.out.println("DEBUG: " + paramName + " = " + value);
                }
            }
            
            // Get page parameter (default is 1)
            int currentPage = 1;
            String pageParam = request.getParameter("page");
            if (pageParam != null && !pageParam.isEmpty()) {
                try {
                    currentPage = Integer.parseInt(pageParam);
                    if (currentPage < 1) currentPage = 1;
                } catch (NumberFormatException e) {
                    LOGGER.warning("Invalid page parameter: " + pageParam);
                }
            }
            
            // Lấy tất cả categories
            List<Category> allCategories = null;
            try {
                allCategories = categoryService.getAllCategories();
            } catch (Exception e) {
                LOGGER.severe("Error getting categories: " + e.getMessage());
                e.printStackTrace();
            }
            
            if (allCategories == null) {
                allCategories = new ArrayList<>();
                LOGGER.warning("getAllCategories returned null, using empty list instead");
            }
            List<Category> parentCategories = new ArrayList<>();
            for (Category cat : allCategories) {
                if (cat != null && cat.getParentCategoryId() == null
                        && "active".equalsIgnoreCase(cat.getStatus()) && cat.getIsDeleted() != null && !cat.getIsDeleted()) {
                    parentCategories.add(cat);
                }
            }
            request.setAttribute("parentCategories", parentCategories);

            // Lấy các tham số lọc
            String priceParam = request.getParameter("price");
            String brandParam = request.getParameter("brand");
            String availabilityParam = request.getParameter("availability");
            String sortParam = request.getParameter("sort");
            
            System.out.println("DEBUG PARAMS: price=" + priceParam + 
                               ", brand=" + brandParam + 
                               ", availability=" + availabilityParam + 
                               ", sort=" + sortParam);

            // Lấy categoryId từ request
            String categoryIdStr = request.getParameter("categoryId");
            Integer categoryId = null;
            if (categoryIdStr != null && !categoryIdStr.isEmpty()) {
                try {
                    categoryId = Integer.parseInt(categoryIdStr);
                    LOGGER.info("Category ID from request: " + categoryId);
                } catch (NumberFormatException e) {
                    LOGGER.warning("Invalid category ID: " + categoryIdStr);
                }
            } else {
                LOGGER.info("No category ID provided in request");
            }

            List<Product> allProducts = productService.getActiveProducts();
            // Lấy danh sách brand duy nhất
            List<String> brands = new ArrayList<>();
            System.out.println("DEBUG: allProducts size: " + (allProducts != null ? allProducts.size() : "null"));
            
            if (allProducts != null && !allProducts.isEmpty()) {
                for (Product p : allProducts) {
                    if (p != null) {
                        System.out.println("DEBUG: Product " + p.getProductId() + " brand: " + p.getBrandName());
                        if (p.getBrandName() != null && !p.getBrandName().trim().isEmpty() && !brands.contains(p.getBrandName())) {
                            brands.add(p.getBrandName());
                            System.out.println("DEBUG: Added brand: " + p.getBrandName());
                        }
                    }
                }
            }
            System.out.println("DEBUG: Total brands found: " + brands.size());
            request.setAttribute("brands", brands);

            if (categoryId != null) {
                // Lấy thông tin category được chọn
                Category selectedCategory = null;
                for (Category cat : allCategories) {
                    if (cat.getCategoryId() == categoryId) {
                        selectedCategory = cat;
                        break;
                    }
                }
                if (selectedCategory != null) {
                    request.setAttribute("selectedCategory", selectedCategory);
                    System.out.println("DEBUG: Selected category: " + selectedCategory.getCategoryName() + " (ID: " + selectedCategory.getCategoryId() + ")");
                    
                    // Kiểm tra xem có phải category cha không
                    boolean hasChild = false;
                    List<Integer> childCategoryIds = new ArrayList<>();
                    for (Category cat : allCategories) {
                        if (cat.getParentCategoryId() != null && cat.getParentCategoryId().getCategoryId().equals(selectedCategory.getCategoryId())
                            && "active".equalsIgnoreCase(cat.getStatus())
                            && cat.getIsDeleted() != null && !cat.getIsDeleted()) {
                            hasChild = true;
                            childCategoryIds.add(cat.getCategoryId());
                            System.out.println("DEBUG: Found child category: " + cat.getCategoryName() + " (ID: " + cat.getCategoryId() + ")");
                        }
                    }
                    boolean isParentCategory = hasChild;
                    request.setAttribute("isParentCategory", isParentCategory);
                    System.out.println("DEBUG: Child categories count: " + childCategoryIds.size());
                    
                    List<Product> productsToShow = new ArrayList<>();
                    // Lấy danh sách brand chỉ thuộc về sản phẩm trong category này
                    List<String> categoryBrands = new ArrayList<>();
                    Map<Integer, String> productImages = new HashMap<>();
                    
                    if (allProducts != null) {
                        if (isParentCategory) {
                            // Nếu là danh mục cấp 1, lấy tất cả sản phẩm của các category con cấp 2
                            for (Product p : allProducts) {
                                if (p != null && p.getCategoryId() != null && childCategoryIds.contains(p.getCategoryId().getCategoryId())) {
                                    productsToShow.add(p);
                                    // Thêm brand vào danh sách nếu chưa có
                                    if (p.getBrandName() != null && !p.getBrandName().trim().isEmpty() 
                                            && !categoryBrands.contains(p.getBrandName())) {
                                        categoryBrands.add(p.getBrandName());
                                    }
                                    System.out.println("DEBUG: Added product from child category: " + p.getProductName() + " (ID: " + p.getProductId() + ", Category: " + p.getCategoryId().getCategoryId() + ")");
                                }
                            }
                        } else {
                            // Nếu là danh mục cấp 2, chỉ lấy sản phẩm của chính category đó
                            for (Product p : allProducts) {
                                if (p != null && p.getCategoryId() != null && p.getCategoryId().getCategoryId().equals(categoryId)) {
                                    productsToShow.add(p);
                                    // Thêm brand vào danh sách nếu chưa có
                                    if (p.getBrandName() != null && !p.getBrandName().trim().isEmpty() 
                                            && !categoryBrands.contains(p.getBrandName())) {
                                        categoryBrands.add(p.getBrandName());
                                    }
                                    System.out.println("DEBUG: Added product from direct category: " + p.getProductName() + " (ID: " + p.getProductId() + ")");
                                }
                            }
                        }
                        System.out.println("DEBUG: Total products to show before filtering: " + productsToShow.size());
                        System.out.println("DEBUG: Category-specific brands found: " + categoryBrands.size());
                        
                        // Gửi danh sách brand theo category tới JSP
                        request.setAttribute("brands", categoryBrands);
                        // Lọc theo price
                        if (priceParam != null && !"all".equals(priceParam)) {
                            List<Product> filtered = new ArrayList<>();
                            System.out.println("DEBUG: Filtering by price: " + priceParam);
                            System.out.println("DEBUG: Products before filter: " + productsToShow.size());
                            
                            for (Product p : productsToShow) {
                                try {
                                    // Kiểm tra null và lấy giá đúng
                                    java.math.BigDecimal price;
                                    if (p.getSalePrice() != null && p.getSalePrice().compareTo(java.math.BigDecimal.ZERO) > 0 && p.getSalePrice().compareTo(p.getPrice()) < 0) {
                                        price = p.getSalePrice();
                                    } else {
                                        price = p.getPrice();
                                    }
                                    
                                    if (price == null) {
                                        System.out.println("DEBUG: Product " + p.getProductId() + " has null price");
                                        continue;
                                    }
                                    
                                    System.out.println("DEBUG: Product " + p.getProductId() + " price: " + price);
                                    
                                    boolean match = false;
                                    
                                    // Dùng doubleValue() để đơn giản hóa so sánh
                                    double priceValue = price.doubleValue();
                                    
                                    switch (priceParam) {
                                        case "class-1st":
                                            match = priceValue < 100000;
                                            break;
                                        case "class-2nd":
                                            match = priceValue >= 100000 && priceValue <= 300000;
                                            break;
                                        case "class-3rd":
                                            match = priceValue > 300000 && priceValue <= 500000;
                                            break;
                                        case "class-4th":
                                            match = priceValue > 500000 && priceValue <= 700000;
                                            break;
                                        case "class-5th":
                                            match = priceValue > 700000 && priceValue <= 1500000;
                                            break;
                                        case "class-6th":
                                            match = priceValue > 1500000;
                                            break;
                                    }
                                    
                                    if (match) {
                                        filtered.add(p);
                                        System.out.println("DEBUG: Product " + p.getProductId() + " matched price filter: " + priceParam);
                                    }
                                } catch (Exception e) {
                                    System.out.println("DEBUG: Error processing price for product " + p.getProductId() + ": " + e.getMessage());
                                    e.printStackTrace();
                                }
                            }
                            System.out.println("DEBUG: Products after price filter: " + filtered.size());
                            productsToShow = filtered;
                        }
                        // Lọc theo brand
                        if (brandParam != null && !"all".equals(brandParam)) {
                            List<Product> filtered = new ArrayList<>();
                            for (Product p : productsToShow) {
                                if (brandParam.equals(p.getBrandName())) {
                                    filtered.add(p);
                                }
                            }
                            productsToShow = filtered;
                        }
                        // Lọc theo availability
                        if (availabilityParam != null && !"all".equals(availabilityParam)) {
                            List<Product> filtered = new ArrayList<>();
                            for (Product p : productsToShow) {
                                if ("in_stock".equals(availabilityParam) && p.getStock() > 0) {
                                    filtered.add(p);
                                } else if ("out_of_stock".equals(availabilityParam) && p.getStock() <= 0) {
                                    filtered.add(p);
                                }
                            }
                            productsToShow = filtered;
                        }
                        
                        // Sắp xếp sản phẩm theo tiêu chí
                        if (sortParam != null && !sortParam.equals("default")) {
                            try {
                                System.out.println("DEBUG: Sorting by: " + sortParam);
                                switch (sortParam) {
                                    case "name_asc":
                                        productsToShow.sort((p1, p2) -> {
                                            if (p1.getProductName() == null) return -1;
                                            if (p2.getProductName() == null) return 1;
                                            return p1.getProductName().compareTo(p2.getProductName());
                                        });
                                        break;
                                    case "name_desc":
                                        productsToShow.sort((p1, p2) -> {
                                            if (p1.getProductName() == null) return 1;
                                            if (p2.getProductName() == null) return -1;
                                            return p2.getProductName().compareTo(p1.getProductName());
                                        });
                                        break;
                                    case "price_asc":
                                        productsToShow.sort((p1, p2) -> {
                                            try {
                                                BigDecimal price1 = getEffectivePrice(p1);
                                                BigDecimal price2 = getEffectivePrice(p2);
                                                return price1.compareTo(price2);
                                            } catch (Exception e) {
                                                System.out.println("Error comparing prices: " + e.getMessage());
                                                return 0;
                                            }
                                        });
                                        break;
                                    case "price_desc":
                                        productsToShow.sort((p1, p2) -> {
                                            try {
                                                BigDecimal price1 = getEffectivePrice(p1);
                                                BigDecimal price2 = getEffectivePrice(p2);
                                                return price2.compareTo(price1);
                                            } catch (Exception e) {
                                                System.out.println("Error comparing prices: " + e.getMessage());
                                                return 0;
                                            }
                                        });
                                        break;
                                    case "newest":
                                        productsToShow.sort((p1, p2) -> {
                                            try {
                                                if (p1.getCreatedAt() == null) return 1;
                                                if (p2.getCreatedAt() == null) return -1;
                                                return p2.getCreatedAt().compareTo(p1.getCreatedAt());
                                            } catch (Exception e) {
                                                System.out.println("Error comparing dates: " + e.getMessage());
                                                return 0;
                                            }
                                        });
                                        break;
                                }
                                System.out.println("DEBUG: After sorting, products count: " + productsToShow.size());
                            } catch (Exception e) {
                                System.out.println("ERROR during sorting: " + e.getMessage());
                                e.printStackTrace();
                            }
                        }
                        
                        // Calculate pagination
                        int totalProducts = productsToShow.size();
                        int totalPages = (int) Math.ceil((double) totalProducts / PRODUCTS_PER_PAGE);
                        
                        // Adjust currentPage if it's out of bounds
                        if (currentPage > totalPages && totalPages > 0) {
                            currentPage = totalPages;
                        }
                        
                        // Get products for current page
                        List<Product> productsForCurrentPage = new ArrayList<>();
                        int startIdx = (currentPage - 1) * PRODUCTS_PER_PAGE;
                        int endIdx = Math.min(startIdx + PRODUCTS_PER_PAGE, totalProducts);
                        
                        if (startIdx < totalProducts) {
                            productsForCurrentPage = productsToShow.subList(startIdx, endIdx);
                        }
                        
                        System.out.println("DEBUG: Page " + currentPage + " of " + totalPages + 
                                           " (showing " + productsForCurrentPage.size() + " products)");
                        
                        // Lấy ảnh chính cho toàn bộ sản phẩm của carousel
                        for (Product p : productsToShow) {
                            ProductImage mainImage = productImageService.findMainImageByProductId(p.getProductId());
                            if (mainImage != null) {
                                productImages.put(p.getProductId(), mainImage.getImageUrl());
                            }
                        }
                        
                        // Set pagination attributes
                        request.setAttribute("currentPage", currentPage);
                        request.setAttribute("totalPages", totalPages);
                        request.setAttribute("products", productsForCurrentPage);
                        request.setAttribute("allProducts", productsToShow);  // Keep all products for carousel
                        request.setAttribute("allProductsForCarousel", productsToShow); // Thêm dòng này để truyền toàn bộ sản phẩm cho carousel
                        request.setAttribute("productImages", productImages);
                        request.setAttribute("productCount", totalProducts);
                        
                        LOGGER.info("Found " + totalProducts + " products for category " + categoryId + 
                                  ", showing page " + currentPage + " of " + totalPages);
                        LOGGER.info("Selected category: " + selectedCategory.getCategoryName());
                    } else {
                        // If no products found
                        request.setAttribute("products", new ArrayList<>());
                        request.setAttribute("productImages", new HashMap<>());
                        request.setAttribute("productCount", 0);
                        request.setAttribute("currentPage", 1);
                        request.setAttribute("totalPages", 0);
                    }
                } else {
                    // Nếu không tìm thấy category, truyền empty list
                    request.setAttribute("products", new ArrayList<>());
                    request.setAttribute("productImages", new HashMap<>());
                    request.setAttribute("productCount", 0);
                    request.setAttribute("currentPage", 1);
                    request.setAttribute("totalPages", 0);
                }
            } else {
                // Nếu không có categoryId, truyền empty list
                request.setAttribute("products", new ArrayList<>());
                request.setAttribute("productImages", new HashMap<>());
                request.setAttribute("productCount", 0);
                request.setAttribute("currentPage", 1);
                request.setAttribute("totalPages", 0);
            }
            
            // Sau khi lấy allCategories từ service
            request.setAttribute("allCategories", allCategories);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error in CategoryServlet.doGet", e);
            e.printStackTrace();
            request.setAttribute("error", "Error loading category data: " + e.getMessage());
            
            // Ensure minimum attributes are set to avoid JSP errors
            request.setAttribute("products", new ArrayList<>());
            request.setAttribute("allProducts", new ArrayList<>());
            request.setAttribute("productImages", new HashMap<>());
            request.setAttribute("productCount", 0);
            request.setAttribute("currentPage", 1);
            request.setAttribute("totalPages", 0);
            request.setAttribute("brands", new ArrayList<>());
        }
        
        // Check user session
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user != null && "admin".equals(user.getRole())) {
            request.setAttribute("showDashboard", true);
        }
        
        try {
            // Forward to category.jsp
            request.getRequestDispatcher("category.jsp").forward(request, response);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error forwarding to category.jsp", e);
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }

    // Helper method để lấy giá hiệu quả (sale price nếu có, không thì regular price)
    private BigDecimal getEffectivePrice(Product p) {
        if (p == null) return BigDecimal.ZERO;
        
        if (p.getSalePrice() != null && 
            p.getSalePrice().compareTo(BigDecimal.ZERO) > 0 && 
            p.getPrice() != null &&
            p.getSalePrice().compareTo(p.getPrice()) < 0) {
            return p.getSalePrice();
        }
        
        return p.getPrice() != null ? p.getPrice() : BigDecimal.ZERO;
    }
} 