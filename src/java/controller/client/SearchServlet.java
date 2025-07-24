package controller.client;

import model.entity.Product;
import model.entity.Category;
import model.entity.ProductImage;
import service.impl.ProductServiceImpl;
import service.impl.CategoryServiceImpl;
import service.impl.ProductImageServiceImpl;
import service.interfaces.ProductService;
import service.interfaces.CategoryService;
import service.interfaces.ProductImageService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.*;

@WebServlet(name = "SearchServlet", urlPatterns = {"/search"})
public class SearchServlet extends HttpServlet {
    private final ProductService productService = new ProductServiceImpl();
    private final CategoryService categoryService = new CategoryServiceImpl();
    private final ProductImageService productImageService = new ProductImageServiceImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String keyword = request.getParameter("q");
        String categoryIdStr = request.getParameter("categoryId");
        // Lấy tất cả categories
        List<Category> allCategories = null;
        try {
            allCategories = categoryService.getAllCategories();
        } catch (Exception e) {
            e.printStackTrace();
        }
        if (allCategories == null) {
            allCategories = new ArrayList<>();
        }
        request.setAttribute("allCategories", allCategories);

        // Lấy tất cả categoryId con (bao gồm cả chính nó nếu là cha)
        List<Integer> categoryIds = new ArrayList<>();
        Integer categoryId = null;
        boolean filterByCategory = false;
        if (categoryIdStr != null && !categoryIdStr.isEmpty() && !"-1".equals(categoryIdStr)) {
            try {
                categoryId = Integer.parseInt(categoryIdStr);
                // Xác định category được chọn
                Category selectedCat = null;
                for (Category cat : allCategories) {
                    if (cat.getCategoryId() == categoryId) {
                        selectedCat = cat;
                        break;
                    }
                }
                if (selectedCat != null) {
                    categoryIds.add(categoryId);
                    // Nếu là danh mục cha (có con), lấy thêm tất cả category con
                    boolean isParent = false;
                    for (Category cat : allCategories) {
                        if (cat.getParentCategoryId() != null && cat.getParentCategoryId().getCategoryId().equals(categoryId)) {
                            categoryIds.add(cat.getCategoryId());
                            isParent = true;
                        }
                    }
                    // Nếu không có con, chỉ lọc đúng danh mục con đó
                    // (categoryIds đã chỉ có 1 phần tử là categoryId)
                }
                filterByCategory = true;
            } catch (NumberFormatException ignore) {}
        }

        // Lấy danh sách sản phẩm tìm kiếm
        List<Product> results = new ArrayList<>();
        if ((keyword != null && !keyword.trim().isEmpty()) || filterByCategory) {
            List<Product> allResults = productService.searchProducts(keyword != null && !keyword.trim().isEmpty() ? keyword.trim() : null, null);
            if (filterByCategory && !categoryIds.isEmpty()) {
                results = new ArrayList<>();
                for (Product p : allResults) {
                    if (p.getCategoryId() != null && categoryIds.contains(p.getCategoryId().getCategoryId())) {
                        results.add(p);
                    }
                }
            } else {
                results = allResults;
            }
        } else {
            // Nếu không có từ khóa và không filterByCategory, lấy tất cả sản phẩm active
            results = productService.getActiveProducts();
        }

        // Lấy danh sách brand duy nhất từ kết quả tìm kiếm
        List<String> brands = new ArrayList<>();
        if (results != null && !results.isEmpty()) {
            for (Product p : results) {
                if (p != null && p.getBrandName() != null && !p.getBrandName().trim().isEmpty() && !brands.contains(p.getBrandName())) {
                    brands.add(p.getBrandName());
                }
            }
        }
        request.setAttribute("brands", brands);

        // Lấy các tham số lọc và sort
        String priceParam = request.getParameter("price");
        String brandParam = request.getParameter("brand");
        String availabilityParam = request.getParameter("availability");
        String sortParam = request.getParameter("sort");
        request.setAttribute("priceParam", priceParam);
        request.setAttribute("brandParam", brandParam);
        request.setAttribute("availabilityParam", availabilityParam);
        request.setAttribute("sortParam", sortParam);

        // Lọc theo price
        if (priceParam != null && !"all".equals(priceParam)) {
            List<Product> filtered = new ArrayList<>();
            for (Product p : results) {
                java.math.BigDecimal price;
                if (p.getSalePrice() != null && p.getSalePrice().compareTo(java.math.BigDecimal.ZERO) > 0 && p.getSalePrice().compareTo(p.getPrice()) < 0) {
                    price = p.getSalePrice();
                } else {
                    price = p.getPrice();
                }
                if (price == null) continue;
                double priceValue = price.doubleValue();
                boolean match = false;
                switch (priceParam) {
                    case "class-1st": match = priceValue < 100000; break;
                    case "class-2nd": match = priceValue >= 100000 && priceValue <= 300000; break;
                    case "class-3rd": match = priceValue > 300000 && priceValue <= 500000; break;
                    case "class-4th": match = priceValue > 500000 && priceValue <= 700000; break;
                    case "class-5th": match = priceValue > 700000 && priceValue <= 1500000; break;
                    case "class-6th": match = priceValue > 1500000; break;
                }
                if (match) filtered.add(p);
            }
            results = filtered;
        }
        // Lọc theo brand
        if (brandParam != null && !"all".equals(brandParam)) {
            List<Product> filtered = new ArrayList<>();
            for (Product p : results) {
                if (brandParam.equals(p.getBrandName())) {
                    filtered.add(p);
                }
            }
            results = filtered;
        }
        // Lọc theo trạng thái
        if (availabilityParam != null && !"all".equals(availabilityParam)) {
            List<Product> filtered = new ArrayList<>();
            for (Product p : results) {
                if ("in_stock".equals(availabilityParam) && p.getStock() > 0) {
                    filtered.add(p);
                } else if ("out_of_stock".equals(availabilityParam) && p.getStock() <= 0) {
                    filtered.add(p);
                }
            }
            results = filtered;
        }
        // Sắp xếp
        if (sortParam != null && !"default".equals(sortParam)) {
            switch (sortParam) {
                case "name_asc":
                    results.sort((p1, p2) -> {
                        if (p1.getProductName() == null) return -1;
                        if (p2.getProductName() == null) return 1;
                        return p1.getProductName().compareTo(p2.getProductName());
                    });
                    break;
                case "name_desc":
                    results.sort((p1, p2) -> {
                        if (p1.getProductName() == null) return 1;
                        if (p2.getProductName() == null) return -1;
                        return p2.getProductName().compareTo(p1.getProductName());
                    });
                    break;
                case "price_asc":
                    results.sort((p1, p2) -> {
                        java.math.BigDecimal price1 = (p1.getSalePrice() != null && p1.getSalePrice().compareTo(java.math.BigDecimal.ZERO) > 0 && p1.getSalePrice().compareTo(p1.getPrice()) < 0) ? p1.getSalePrice() : p1.getPrice();
                        java.math.BigDecimal price2 = (p2.getSalePrice() != null && p2.getSalePrice().compareTo(java.math.BigDecimal.ZERO) > 0 && p2.getSalePrice().compareTo(p2.getPrice()) < 0) ? p2.getSalePrice() : p2.getPrice();
                        if (price1 == null) return -1;
                        if (price2 == null) return 1;
                        return price1.compareTo(price2);
                    });
                    break;
                case "price_desc":
                    results.sort((p1, p2) -> {
                        java.math.BigDecimal price1 = (p1.getSalePrice() != null && p1.getSalePrice().compareTo(java.math.BigDecimal.ZERO) > 0 && p1.getSalePrice().compareTo(p1.getPrice()) < 0) ? p1.getSalePrice() : p1.getPrice();
                        java.math.BigDecimal price2 = (p2.getSalePrice() != null && p2.getSalePrice().compareTo(java.math.BigDecimal.ZERO) > 0 && p2.getSalePrice().compareTo(p2.getPrice()) < 0) ? p2.getSalePrice() : p2.getPrice();
                        if (price1 == null) return 1;
                        if (price2 == null) return -1;
                        return price2.compareTo(price1);
                    });
                    break;
                case "newest":
                    results.sort((p1, p2) -> {
                        if (p1.getCreatedAt() == null) return 1;
                        if (p2.getCreatedAt() == null) return -1;
                        return p2.getCreatedAt().compareTo(p1.getCreatedAt());
                    });
                    break;
            }
        }

        // Phân trang
        int page = 1;
        int pageSize = 9;
        String pageStr = request.getParameter("page");
        if (pageStr != null) {
            try {
                page = Integer.parseInt(pageStr);
                if (page < 1) page = 1;
            } catch (NumberFormatException ignore) {}
        }
        int totalProducts = results.size();
        int totalPages = (int) Math.ceil((double) totalProducts / pageSize);
        int fromIndex = (page - 1) * pageSize;
        int toIndex = Math.min(fromIndex + pageSize, totalProducts);
        List<Product> pagedProducts = new ArrayList<>();
        if (fromIndex < totalProducts) {
            pagedProducts = results.subList(fromIndex, toIndex);
        }

        // Lấy ảnh chính cho các sản phẩm hiện tại
        Map<Integer, String> productImages = new HashMap<>();
        for (Product p : pagedProducts) {
            ProductImage mainImage = productImageService.findMainImageByProductId(p.getProductId());
            if (mainImage != null) {
                productImages.put(p.getProductId(), mainImage.getImageUrl());
            }
        }
        request.setAttribute("productImages", productImages);

        // Xác định selectedCategory nếu có categoryId
        Category selectedCategory = null;
        if (categoryId != null && allCategories != null) {
            for (Category cat : allCategories) {
                if (cat.getCategoryId() == categoryId) {
                    selectedCategory = cat;
                    break;
                }
            }
        }
        request.setAttribute("selectedCategory", selectedCategory);

        // Truyền allProducts cho carousel (danh sách đã lọc trước phân trang)
        request.setAttribute("allProducts", results);

        // Truyền lại các filter/sort về JSP qua param (hoặc giữ lại từng biến nếu JSP dùng)
        request.setAttribute("param", request.getParameterMap());

        request.setAttribute("products", pagedProducts);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("searchKeyword", keyword);
        request.setAttribute("searchCategoryId", categoryId);
        request.getRequestDispatcher("client/search-results.jsp").forward(request, response);
    }
} 