package controller.client;

import model.entity.Product;
import model.entity.ProductImage;
import service.impl.ProductServiceImpl;
import service.impl.ProductImageServiceImpl;
import service.interfaces.ProductService;
import service.interfaces.ProductImageService;
import service.interfaces.CategoryService;
import service.impl.CategoryServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.*;

@WebServlet(name = "AllProductsServlet", urlPatterns = {"/all-products"})
public class AllProductsServlet extends HttpServlet {

    private final ProductService productService = new ProductServiceImpl();
    private final ProductImageService productImageService = new ProductImageServiceImpl();
    private static final int PAGE_SIZE = 20;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        // Lấy danh sách sản phẩm active
        List<Product> allProducts = productService.getActiveProducts();

        // Lọc brand
        List<String> brands = new ArrayList<>();
        if (allProducts != null) {
            for (Product p : allProducts) {
                if (p.getBrandName() != null && !p.getBrandName().isEmpty() && !brands.contains(p.getBrandName())) {
                    brands.add(p.getBrandName());
                }
            }
        }
        request.setAttribute("brands", brands);

        // Lọc sản phẩm theo request param
        String priceParam = request.getParameter("price");
        String brandParam = request.getParameter("brand");
        String availabilityParam = request.getParameter("availability");
        String sortParam = request.getParameter("sort");

        List<Product> filteredProducts = new ArrayList<>(allProducts);

        // Lọc theo giá
        if (priceParam != null && !"all".equals(priceParam)) {
            List<Product> temp = new ArrayList<>();
            for (Product p : filteredProducts) {
                double price = (p.getSalePrice() != null && p.getSalePrice().doubleValue() > 0 && p.getSalePrice().doubleValue() < p.getPrice().doubleValue())
                        ? p.getSalePrice().doubleValue() : p.getPrice().doubleValue();
                switch (priceParam) {
                    case "class-1st": if (price < 100_000) temp.add(p); break;
                    case "class-2nd": if (price >= 100_000 && price <= 300_000) temp.add(p); break;
                    case "class-3rd": if (price > 300_000 && price <= 500_000) temp.add(p); break;
                    case "class-4th": if (price > 500_000 && price <= 700_000) temp.add(p); break;
                    case "class-5th": if (price > 700_000 && price <= 1_500_000) temp.add(p); break;
                    case "class-6th": if (price > 1_500_000) temp.add(p); break;
                }
            }
            filteredProducts = temp;
        }

        // Lọc theo thương hiệu
        if (brandParam != null && !"all".equals(brandParam)) {
            List<Product> temp = new ArrayList<>();
            for (Product p : filteredProducts) {
                if (brandParam.equals(p.getBrandName())) {
                    temp.add(p);
                }
            }
            filteredProducts = temp;
        }

        // Lọc theo trạng thái kho
        if (availabilityParam != null && !"all".equals(availabilityParam)) {
            List<Product> temp = new ArrayList<>();
            for (Product p : filteredProducts) {
                if ("in_stock".equals(availabilityParam) && p.getStock() > 0) temp.add(p);
                if ("out_of_stock".equals(availabilityParam) && p.getStock() <= 0) temp.add(p);
            }
            filteredProducts = temp;
        }

        // Sắp xếp
        if (sortParam != null && !"default".equals(sortParam)) {
            switch (sortParam) {
                case "name_asc":
                    filteredProducts.sort(Comparator.comparing(p -> p.getProductName() != null ? p.getProductName() : ""));
                    break;
                case "name_desc":
                    filteredProducts.sort((p1, p2) -> (p2.getProductName() != null ? p2.getProductName() : "")
                                                        .compareTo(p1.getProductName() != null ? p1.getProductName() : ""));
                    break;
                case "price_asc":
                    filteredProducts.sort(Comparator.comparing(p -> {
                        double price = (p.getSalePrice() != null && p.getSalePrice().doubleValue() > 0 && p.getSalePrice().doubleValue() < p.getPrice().doubleValue())
                                ? p.getSalePrice().doubleValue() : p.getPrice().doubleValue();
                        return price;
                    }));
                    break;
                case "price_desc":
                    filteredProducts.sort((p1, p2) -> {
                        double price1 = (p1.getSalePrice() != null && p1.getSalePrice().doubleValue() > 0 && p1.getSalePrice().doubleValue() < p1.getPrice().doubleValue())
                                        ? p1.getSalePrice().doubleValue() : p1.getPrice().doubleValue();
                        double price2 = (p2.getSalePrice() != null && p2.getSalePrice().doubleValue() > 0 && p2.getSalePrice().doubleValue() < p2.getPrice().doubleValue())
                                        ? p2.getSalePrice().doubleValue() : p2.getPrice().doubleValue();
                        return Double.compare(price2, price1);
                    });
                    break;
                case "newest":
                    filteredProducts.sort(Comparator.comparing(Product::getCreatedAt, Comparator.nullsLast(Comparator.reverseOrder())));
                    break;
            }
        }

        // Phân trang
        int totalProducts = filteredProducts.size();
        int totalPages = (int) Math.ceil((double) totalProducts / PAGE_SIZE);

        int currentPage = 1;
        String pageParam = request.getParameter("page");
        if (pageParam != null) {
            try {
                currentPage = Integer.parseInt(pageParam);
            } catch (NumberFormatException ignore) {}
        }
        if (currentPage < 1) currentPage = 1;
        if (currentPage > totalPages && totalPages > 0) currentPage = totalPages;

        int fromIndex = (currentPage - 1) * PAGE_SIZE;
        int toIndex = Math.min(fromIndex + PAGE_SIZE, totalProducts);
        List<Product> pageProducts = new ArrayList<>();
        if (fromIndex < totalProducts) {
            pageProducts = filteredProducts.subList(fromIndex, toIndex);
        }

        // Lấy ảnh chính cho toàn bộ sản phẩm (carousel và danh sách)
        Map<Integer, String> productImages = new HashMap<>();
        for (Product p : filteredProducts) {
            ProductImage img = productImageService.findMainImageByProductId(p.getProductId());
            if (img != null) productImages.put(p.getProductId(), img.getImageUrl());
        }

        request.setAttribute("products", pageProducts);
        request.setAttribute("productImages", productImages);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("currentPage", currentPage);

        // Để carousel hoặc suggest dùng toàn bộ filteredProducts
        request.setAttribute("allProducts", filteredProducts);

        // Ẩn selectedCategory để JSP hiện đúng "All Products"
        request.setAttribute("selectedCategory", null);

        // Brands để select trong filter
        request.setAttribute("brands", brands);

        // Lấy danh sách category cho menu header
        CategoryService categoryService = new CategoryServiceImpl();
        List<model.entity.Category> allCategories = categoryService.getAllCategories();
        request.setAttribute("allCategories", allCategories);

        request.getRequestDispatcher("client/all-products.jsp").forward(request, response);
    }
}
