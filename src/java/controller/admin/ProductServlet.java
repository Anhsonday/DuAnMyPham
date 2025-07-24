package controller.admin;

import service.impl.ProductServiceImpl;
import service.impl.CategoryServiceImpl;
import service.impl.ProductDetailServiceImpl;
import service.impl.ProductImageServiceImpl;
import service.interfaces.ProductService;
import service.interfaces.CategoryService;
import service.interfaces.ProductDetailService;
import service.interfaces.ProductImageService;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.Date;
import java.util.ArrayList;
import java.util.List;
import model.entity.Category;
import model.entity.Product;
import model.entity.ProductDetail;
import model.entity.ProductImage;

@WebServlet("/products")
@MultipartConfig
public class ProductServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private ProductService productService;
    private CategoryService categoryService;
    private ProductDetailService productDetailService;
    private ProductImageService productImageService;

    @Override
    public void init() throws ServletException {
        productService = new ProductServiceImpl();
        categoryService = new CategoryServiceImpl();
        productDetailService = new ProductDetailServiceImpl();
        productImageService = new ProductImageServiceImpl();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        try {
            switch (action) {
                case "new":
                    showNewForm(request, response);
                    break;
                case "insert":
                    insertProduct(request, response);
                    break;
                case "delete":
                    deleteProduct(request, response);
                    break;
                case "restore":
                    restoreProduct(request, response);
                    break;
                case "edit":
                    showEditForm(request, response);
                    break;
                case "update":
                    updateProduct(request, response);
                    break;
                case "view":
                    viewProduct(request, response);
                    break;
                default:
                    listProducts(request, response);
                    break;
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            request.setAttribute("errorMessage", "Đã xảy ra lỗi: " + ex.getMessage());
            listProducts(request, response);
        }
    }

    private void listProducts(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Product> listProduct = productService.getAllProducts();
        request.setAttribute("listProduct", listProduct);

        List<Category> listCategory = categoryService.getAllCategories();
        request.setAttribute("listCategory", listCategory);

        RequestDispatcher dispatcher = request.getRequestDispatcher("admin/products.jsp");
        dispatcher.forward(request, response);
    }

    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Category> listCategory = categoryService.getAllCategories();
        request.setAttribute("listCategory", listCategory);
        RequestDispatcher dispatcher = request.getRequestDispatcher("admin/product-form.jsp");
        dispatcher.forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect("products?action=list");
            return;
        }
        int id = Integer.parseInt(idStr);

        Product product = productService.getProductById(id);
        List<Category> listCategory = categoryService.getAllCategories();
        ProductDetail productDetail = productDetailService.getProductDetailByProductId(id);
        List<ProductImage> productImages = productImageService.findByProductId(id);

        request.setAttribute("product", product);
        request.setAttribute("listCategory", listCategory);
        request.setAttribute("productDetail", productDetail);
        request.setAttribute("productImages", productImages);

        // Xử lý hình ảnh sản phẩm
        ProductImage mainImage = null;
        List<String> subImageUrls = new ArrayList<>();
        for (ProductImage img : productImages) {
            if (img.getIsMainImage() != null && img.getIsMainImage()) {
                mainImage = img;
            } else {
                subImageUrls.add(img.getImageUrl());
            }
        }
        request.setAttribute("mainImageUrl", mainImage != null ? mainImage.getImageUrl() : null);
        request.setAttribute("subImageUrls", subImageUrls);

        RequestDispatcher dispatcher = request.getRequestDispatcher("admin/product-form.jsp");
        dispatcher.forward(request, response);
    }

    private void insertProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // ===== VALIDATION =====
            String productName = request.getParameter("productName");
            String priceStr = request.getParameter("price");
            String categoryIdStr = request.getParameter("categoryId");
            String stockStr = request.getParameter("stock");
            String sku = request.getParameter("sku");

            if (productName == null || productName.trim().isEmpty()) {
                throw new IllegalArgumentException("Tên sản phẩm không được để trống");
            }
            if (priceStr == null || priceStr.trim().isEmpty()) {
                throw new IllegalArgumentException("Giá sản phẩm không được để trống");
            }
            if (categoryIdStr == null || categoryIdStr.trim().isEmpty()) {
                throw new IllegalArgumentException("Danh mục không được để trống");
            }
            if (sku == null || sku.trim().isEmpty()) {
                throw new IllegalArgumentException("SKU không được để trống");
            }
            if (productService.isSkuExisted(sku.trim())) {
                request.setAttribute("errorMessage", "SKU đã tồn tại, vui lòng chọn mã SKU khác!");
                showNewForm(request, response);
                return;
            }

            // ===== SET PRODUCT =====
            Product product = new Product();
            int categoryId = 0;
            try {
                categoryId = Integer.parseInt(categoryIdStr);
            } catch (NumberFormatException e) {
                categoryId = 0;
            }
            if (categoryId > 0) {
                Category category = categoryService.getCategoryById(categoryId);
                product.setCategoryId(category);
            } else {
                product.setCategoryId(null);
            }
            product.setProductName(productName.trim());
            product.setBrandName(request.getParameter("brandName"));
            product.setShortDescription(request.getParameter("shortDescription"));
            product.setPrice(new BigDecimal(priceStr));

            String salePriceStr = request.getParameter("salePrice");
            if (salePriceStr != null && !salePriceStr.trim().isEmpty()) {
                try {
                    BigDecimal salePrice = new BigDecimal(salePriceStr);
                    product.setSalePrice(salePrice.compareTo(BigDecimal.ZERO) > 0 ? salePrice : null);
                } catch (NumberFormatException e) {
                    product.setSalePrice(null);
                }
            } else {
                product.setSalePrice(null);
            }

            product.setStock(stockStr != null && !stockStr.trim().isEmpty() ? Integer.parseInt(stockStr) : 0);
            product.setSku(sku.trim());
            product.setQuantityValue(request.getParameter("quantityValue") != null && !request.getParameter("quantityValue").isEmpty()
                    ? new BigDecimal(request.getParameter("quantityValue")) : null);
            product.setQuantityUnit(request.getParameter("quantityUnit"));
            product.setStatus(request.getParameter("status"));
            String featuredStr = request.getParameter("featured");
            boolean featured = featuredStr != null && (featuredStr.equals("1") || featuredStr.equals("true"));
            product.setFeatured(featured);
            product.setIsDeleted(false);
            product.setCreatedAt(new Date());
            product.setUpdatedAt(new Date());

            String reservedQuantityStr = request.getParameter("reservedQuantity");
            product.setReservedQuantity(reservedQuantityStr != null && !reservedQuantityStr.trim().isEmpty()
                    ? Integer.parseInt(reservedQuantityStr) : 0);

            // ===== INSERT PRODUCT =====
            Product createdProduct = productService.createProduct(product);
            int productId = createdProduct != null ? createdProduct.getProductId() : 0;

            // ===== SET PRODUCT DETAIL =====
            ProductDetail productDetail = null;
            String description = request.getParameter("description");
            String ingredients = request.getParameter("ingredients");
            String origin = request.getParameter("origin");
            String skinConcerns = request.getParameter("skinConcerns");
            String storageInstructions = request.getParameter("storageInstructions");
            String howToUse = request.getParameter("howToUse");
            String manufactureDate = request.getParameter("manufactureDate");
            String expiryDate = request.getParameter("expiryDate");

            boolean hasProductDetailData
                    = (description != null && !description.trim().isEmpty())
                    || (ingredients != null && !ingredients.trim().isEmpty())
                    || (origin != null && !origin.trim().isEmpty())
                    || (skinConcerns != null && !skinConcerns.trim().isEmpty())
                    || (storageInstructions != null && !storageInstructions.trim().isEmpty())
                    || (howToUse != null && !howToUse.trim().isEmpty())
                    || (manufactureDate != null && !manufactureDate.trim().isEmpty())
                    || (expiryDate != null && !expiryDate.trim().isEmpty());

            boolean productDetailSuccess = true;
            if (hasProductDetailData && productId > 0) {
                productDetail = new ProductDetail();
                Product productRef = productService.getProductById(productId);
                productDetail.setProductId(productRef);
                productDetail.setDescription(description);
                productDetail.setIngredients(ingredients);
                productDetail.setOrigin(origin);
                productDetail.setSkinConcerns(skinConcerns);
                productDetail.setStorageInstructions(storageInstructions);
                productDetail.setHowToUse(howToUse);
                if (manufactureDate != null && !manufactureDate.trim().isEmpty()) {
                    productDetail.setManufactureDate(java.sql.Date.valueOf(manufactureDate));
                } else {
                    productDetail.setManufactureDate(null);
                }
                productDetail.setExpiryDate(expiryDate != null && !expiryDate.isEmpty()
                        ? java.sql.Date.valueOf(expiryDate) : null);
                productDetail.setIsDeleted(false);
                productDetailSuccess = productDetailService.createProductDetail(productDetail) != null;
            }

            // ===== HANDLE IMAGES =====
            if (productId > 0) {
                handleImages(request, productId);
            }

            // ===== FINAL RESPONSE =====
            if (productId > 0 && productDetailSuccess) {
                request.getSession().setAttribute("successMessage", "Thêm sản phẩm thành công!");
                response.sendRedirect("products");
            } else {
                StringBuilder errorMsg = new StringBuilder("Không thể thêm ");
                if (productId <= 0) {
                    errorMsg.append("sản phẩm, ");
                }
                if (!productDetailSuccess) {
                    errorMsg.append("chi tiết sản phẩm, ");
                }
                errorMsg.append("vui lòng thử lại.");
                request.setAttribute("errorMessage", errorMsg.toString());
                showNewForm(request, response);
            }
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Định dạng số không hợp lệ");
            showNewForm(request, response);
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Đã xảy ra lỗi: " + e.getMessage());
            showNewForm(request, response);
        }
    }

    private void updateProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // ===== VALIDATION =====
            String productName = request.getParameter("productName");
            String priceStr = request.getParameter("price");
            String categoryIdStr = request.getParameter("categoryId");
            String stockStr = request.getParameter("stock");
            String sku = request.getParameter("sku");

            if (productName == null || productName.trim().isEmpty()) {
                throw new IllegalArgumentException("Tên sản phẩm không được để trống");
            }
            if (priceStr == null || priceStr.trim().isEmpty()) {
                throw new IllegalArgumentException("Giá sản phẩm không được để trống");
            }
            if (categoryIdStr == null || categoryIdStr.trim().isEmpty()) {
                throw new IllegalArgumentException("Danh mục không được để trống");
            }
            if (sku == null || sku.trim().isEmpty()) {
                throw new IllegalArgumentException("SKU không được để trống");
            }

            // ===== SET PRODUCT =====
            Product product = new Product();
            int productId = Integer.parseInt(request.getParameter("productId"));
            product.setProductId(productId);
            int categoryId = 0;
            try {
                categoryId = Integer.parseInt(request.getParameter("categoryId"));
            } catch (NumberFormatException e) {
                categoryId = 0;
            }
            if (categoryId > 0) {
                Category category = categoryService.getCategoryById(categoryId);
                product.setCategoryId(category);
            } else {
                product.setCategoryId(null);
            }
            product.setProductName(productName.trim());
            product.setBrandName(request.getParameter("brandName"));
            product.setShortDescription(request.getParameter("shortDescription"));
            product.setPrice(new BigDecimal(priceStr));
            String salePriceStr = request.getParameter("salePrice");
            if (salePriceStr != null && !salePriceStr.trim().isEmpty()) {
                try {
                    BigDecimal salePrice = new BigDecimal(salePriceStr);
                    product.setSalePrice(salePrice.compareTo(BigDecimal.ZERO) > 0 ? salePrice : null);
                } catch (NumberFormatException e) {
                    product.setSalePrice(null);
                }
            } else {
                product.setSalePrice(null);
            }

            product.setStock(stockStr != null && !stockStr.trim().isEmpty() ? Integer.parseInt(stockStr) : 0);
            product.setSku(sku.trim());
            product.setQuantityValue(request.getParameter("quantityValue") != null && !request.getParameter("quantityValue").isEmpty()
                    ? new BigDecimal(request.getParameter("quantityValue")) : null);
            product.setQuantityUnit(request.getParameter("quantityUnit"));
            product.setStatus(request.getParameter("status"));
            String featuredStr = request.getParameter("featured");
            boolean featured = featuredStr != null && (featuredStr.equals("1") || featuredStr.equals("true"));
            product.setFeatured(featured);
            String isDeletedStr = request.getParameter("isDeleted");
            product.setIsDeleted(isDeletedStr != null && (isDeletedStr.equals("1") || isDeletedStr.equals("true")));
            product.setUpdatedAt(new Date());

            String reservedQuantityStr = request.getParameter("reservedQuantity");
            product.setReservedQuantity(reservedQuantityStr != null && !reservedQuantityStr.trim().isEmpty()
                    ? Integer.parseInt(reservedQuantityStr) : 0);

            // Trong updateProduct, sau khi tạo Product product và set các trường:
            Product oldProduct = productService.getProductById(productId);
            if (oldProduct != null) {
                product.setCreatedAt(oldProduct.getCreatedAt());
            }

            // ===== SET PRODUCT DETAIL =====
            ProductDetail productDetail = null;
            String description = request.getParameter("description");
            String ingredients = request.getParameter("ingredients");
            String origin = request.getParameter("origin");
            String skinConcerns = request.getParameter("skinConcerns");
            String storageInstructions = request.getParameter("storageInstructions");
            String howToUse = request.getParameter("howToUse");
            String manufactureDate = request.getParameter("manufactureDate");
            String expiryDate = request.getParameter("expiryDate");

            boolean hasProductDetailData
                    = (description != null && !description.trim().isEmpty())
                    || (ingredients != null && !ingredients.trim().isEmpty())
                    || (origin != null && !origin.trim().isEmpty())
                    || (skinConcerns != null && !skinConcerns.trim().isEmpty())
                    || (storageInstructions != null && !storageInstructions.trim().isEmpty())
                    || (howToUse != null && !howToUse.trim().isEmpty())
                    || (manufactureDate != null && !manufactureDate.trim().isEmpty())
                    || (expiryDate != null && !expiryDate.trim().isEmpty());

            if (hasProductDetailData) {
                productDetail = new ProductDetail();
                productDetail.setProductId(product);
                productDetail.setDescription(description);
                productDetail.setIngredients(ingredients);
                productDetail.setOrigin(origin);
                productDetail.setSkinConcerns(skinConcerns);
                productDetail.setStorageInstructions(storageInstructions);
                productDetail.setHowToUse(howToUse);
                if (manufactureDate != null && !manufactureDate.trim().isEmpty()) {
                    productDetail.setManufactureDate(java.sql.Date.valueOf(manufactureDate));
                } else {
                    productDetail.setManufactureDate(null);
                }
                productDetail.setExpiryDate(expiryDate != null && !expiryDate.isEmpty()
                        ? java.sql.Date.valueOf(expiryDate) : null);
                productDetail.setIsDeleted(false);
            }

            // ===== UPDATE PRODUCT && detail =====
            boolean productSuccess = productService.updateProduct(product) != null;
            boolean productDetailSuccess = true;

            if (hasProductDetailData) {
                ProductDetail existingDetail = productDetailService.getProductDetailByProductId(product.getProductId());
                if (existingDetail != null) {
                    productDetail.setProductDetailId(existingDetail.getProductDetailId());
                    productDetailSuccess = productDetailService.updateProductDetail(productDetail) != null;
                } else {
                    productDetailSuccess = productDetailService.createProductDetail(productDetail) != null;
                }
            }

            // ===== HANDLE IMAGES =====
            handleImages(request, productId);

            // ===== FINAL RESPONSE =====
            if (productSuccess && productDetailSuccess) {
                request.getSession().setAttribute("successMessage", "Cập nhật sản phẩm thành công!");
                response.sendRedirect("products");
            } else {
                StringBuilder errorMsg = new StringBuilder("Không thể cập nhật ");
                if (!productSuccess) {
                    errorMsg.append("sản phẩm, ");
                }
                if (!productDetailSuccess) {
                    errorMsg.append("chi tiết sản phẩm, ");
                }
                errorMsg.append("vui lòng thử lại.");
                request.setAttribute("errorMessage", errorMsg.toString());
                request.setAttribute("product", product);
                if (hasProductDetailData) {
                    request.setAttribute("productDetail", productDetail);
                }
                showEditForm(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Đã xảy ra lỗi: " + e.getMessage());
            showEditForm(request, response);
        }
    }

    private void handleImages(HttpServletRequest request, int productId) throws Exception {
        // 1. Xoá ảnh được chọn
        String[] deleteImageIds = request.getParameterValues("deleteImageIds");
        if (deleteImageIds != null) {
            for (String idStr : deleteImageIds) {
                try {
                    int imgId = Integer.parseInt(idStr);
                    productImageService.deleteProductImage(imgId);
                } catch (NumberFormatException ignored) {}
            }
        }

        // 2. Cập nhật lại thứ tự hiển thị
        List<ProductImage> images = productImageService.findByProductId(productId);
        for (ProductImage img : images) {
            String orderStr = request.getParameter("displayOrders[" + img.getImageId() + "]");
            if (orderStr != null) {
                try {
                    int order = Integer.parseInt(orderStr);
                    img.setDisplayOrder(order);
                    productImageService.updateProductImage(img);
                } catch (NumberFormatException ignored) {}
            }
        }

        // 3. Đổi ảnh chính nếu chọn lại từ ảnh cũ
        String mainImageIdStr = request.getParameter("mainImageId");
        images = productImageService.findByProductId(productId);
        if (mainImageIdStr != null && !mainImageIdStr.isEmpty() && images != null && !images.isEmpty()) {
            try {
                int mainImageId = Integer.parseInt(mainImageIdStr);
                boolean found = false;
                int order = 1;
                for (ProductImage img : images) {
                    if (img.getImageId() == mainImageId) {
                        img.setIsMainImage(true);
                        img.setDisplayOrder(0);
                        found = true;
                    } else {
                        img.setIsMainImage(false);
                        img.setDisplayOrder(order++);
                    }
                    productImageService.updateProductImage(img);
                }
                if (!found && !images.isEmpty()) {
                    ProductImage first = images.get(0);
                    first.setIsMainImage(true);
                    first.setDisplayOrder(0);
                    productImageService.updateProductImage(first);
                }
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }

        // 4. Upload ảnh chính mới (nếu có)
        String uploadDirPath = request.getServletContext().getRealPath("/images");
        java.io.File uploadDir = new java.io.File(uploadDirPath);
        if (!uploadDir.exists()) uploadDir.mkdirs();

        jakarta.servlet.http.Part mainImagePart = request.getPart("mainImage");
        if (mainImagePart != null && mainImagePart.getSize() > 0) {
            images = productImageService.findByProductId(productId);
            for (ProductImage img : images) {
                if (img.getIsMainImage() != null && img.getIsMainImage()) {
                    productImageService.deleteProductImage(img.getImageId());
                }
            }
            String fileName = java.nio.file.Paths.get(mainImagePart.getSubmittedFileName()).getFileName().toString();
            String uploadPath = uploadDirPath + java.io.File.separator + fileName;
            mainImagePart.write(uploadPath);
            ProductImage mainImg = new ProductImage();
            Product productRef = productService.getProductById(productId);
            mainImg.setProductId(productRef);
            mainImg.setImageUrl("/images/" + fileName);
            mainImg.setIsMainImage(true);
            mainImg.setDisplayOrder(0);
            mainImg.setIsDeleted(false);
            productImageService.insertProductImage(mainImg);
        }

        // 5. Thêm ảnh chính từ link (nếu có)
        String mainImageUrl = request.getParameter("mainImageUrl");
        if (mainImageUrl != null && !mainImageUrl.trim().isEmpty()) {
            images = productImageService.findByProductId(productId);
            for (ProductImage img : images) {
                if (img.getIsMainImage() != null && img.getIsMainImage()) {
                    productImageService.deleteProductImage(img.getImageId());
                }
            }
            ProductImage mainImg = new ProductImage();
            Product productRef = productService.getProductById(productId);
            mainImg.setProductId(productRef);
            mainImg.setImageUrl(mainImageUrl.trim());
            mainImg.setIsMainImage(true);
            mainImg.setDisplayOrder(0);
            mainImg.setIsDeleted(false);
            productImageService.insertProductImage(mainImg);
        }

        // 6. Upload ảnh phụ mới (nếu có)
        List<ProductImage> currentImages = productImageService.findByProductId(productId);
        int maxOrder = 0;
        for (ProductImage img : currentImages) {
            if ((img.getIsMainImage() == null || !img.getIsMainImage()) && img.getDisplayOrder() > maxOrder)
                maxOrder = img.getDisplayOrder();
        }
        int displayOrder = maxOrder + 1;

        for (jakarta.servlet.http.Part part : request.getParts()) {
            if (part.getName().equals("subImages") && part.getSize() > 0) {
                String fileName = java.nio.file.Paths.get(part.getSubmittedFileName()).getFileName().toString();
                String uploadPath = uploadDirPath + java.io.File.separator + fileName;
                part.write(uploadPath);
                ProductImage subImg = new ProductImage();
                Product productRef = productService.getProductById(productId);
                subImg.setProductId(productRef);
                subImg.setImageUrl("/images/" + fileName);
                subImg.setIsMainImage(false);
                subImg.setDisplayOrder(displayOrder++);
                subImg.setIsDeleted(false);
                productImageService.insertProductImage(subImg);
            }
        }

        // 7. Thêm ảnh phụ từ link (nếu có)
        String additionalImageUrls = request.getParameter("additionalImageUrls");
        if (additionalImageUrls != null && !additionalImageUrls.trim().isEmpty()) {
            String[] urls = additionalImageUrls.split("\\r?\\n");
            for (String url : urls) {
                if (!url.trim().isEmpty()) {
                    ProductImage subImg = new ProductImage();
                    Product productRef = productService.getProductById(productId);
                    subImg.setProductId(productRef);
                    subImg.setImageUrl(url.trim());
                    subImg.setIsMainImage(false);
                    subImg.setDisplayOrder(displayOrder++);
                    subImg.setIsDeleted(false);
                    productImageService.insertProductImage(subImg);
                }
            }
        }
    }

    private void deleteProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int productId = Integer.parseInt(request.getParameter("id"));
            boolean success = productService.toggleIsDeleted(productId);

            if (success) {
                response.sendRedirect("products");
            } else {
                throw new ServletException("Không thể cập nhật trạng thái xóa sản phẩm");
            }
        } catch (NumberFormatException e) {
            throw new ServletException("ID sản phẩm không hợp lệ", e);
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("Lỗi khi xử lý yêu cầu xóa sản phẩm", e);
        }
    }

    private void restoreProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int productId = Integer.parseInt(request.getParameter("id"));
            boolean success = productService.toggleIsDeleted(productId);

            if (success) {
                response.sendRedirect("products");
            } else {
                throw new ServletException("Không thể khôi phục sản phẩm");
            }
        } catch (NumberFormatException e) {
            throw new ServletException("ID sản phẩm không hợp lệ", e);
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("Lỗi khi xử lý yêu cầu khôi phục sản phẩm", e);
        }
    }

    private void viewProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Product product = productService.getProductById(id);
        List<Category> categorys = categoryService.getAllCategories();
        ProductDetail productDetail = productDetailService.getProductDetailByProductId(id);
        List<ProductImage> productImage = productImageService.findByProductId(id);

        request.setAttribute("productImages", productImage);
        request.setAttribute("productDetail", productDetail);
        request.setAttribute("categorys", categorys);
        request.setAttribute("product", product);
        RequestDispatcher dispatcher = request.getRequestDispatcher("admin/product-view.jsp");
        dispatcher.forward(request, response);
    }
} 