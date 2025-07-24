package service.impl;

import dao.impl.ProductDAOImpl;
import dao.interfaces.ProductDAO;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import model.entity.Product;
import service.interfaces.ProductService;

/**
 * Implementation of ProductService
 */
public class ProductServiceImpl extends GenericService<Product> implements ProductService {
    
    @Override
    public Product getProductById(Integer productId) {
        if (productId == null || productId <= 0) {
            throw new IllegalArgumentException("Invalid product ID");
        }
        
        return doInTransactionWithResult(em -> {
            ProductDAO dao = new ProductDAOImpl(em);
            return dao.findById(productId);
        }, "Error getting product by ID");
    }
    
    @Override
    public Product getProductByIdWithAccessControl(Integer productId, boolean isAdmin) {
        // Tương thích cũ: nếu isAdmin true thì tạo user giả admin, ngược lại null (anonymous/customer)
        model.entity.User user = null;
        if (isAdmin) {
            user = new model.entity.User();
            user.setRole("admin");
        }
        return getProductByIdWithAccessControl(productId, user);
    }
    
    @Override
    public Product getProductByIdWithAccessControl(Integer productId, model.entity.User user) {
        if (productId == null || productId <= 0) {
            throw new IllegalArgumentException("Invalid product ID");
        }
        System.out.println("[DEBUG] User object: " + user);
        System.out.println("[DEBUG] User role: " + (user != null ? user.getRole() : "null"));
        return doInTransactionWithResult(em -> {
            ProductDAO dao = new ProductDAOImpl(em);
            Product product = dao.findById(productId);
            if (product == null) {
                return null;
            }
            if (user != null && user.getRole() != null && ("admin".equalsIgnoreCase(user.getRole()) || "customer".equalsIgnoreCase(user.getRole()))) {
                // Admin và customer đều xem được tất cả
                return product;
            }
            // Chưa đăng nhập chỉ xem sản phẩm chưa xóa và active
            if (Boolean.TRUE.equals(product.getIsDeleted()) || !"active".equals(product.getStatus())) {
                return null;
            }
            return product;
        }, "Error getting product by ID with access control");
    }
    
    @Override
    public Product createProduct(Product product) {
        validateProduct(product);
        
        return doInTransactionWithResult(em -> {
            ProductDAO dao = new ProductDAOImpl(em);
            
            // Validate SKU
            if (dao.isSkuExisted(product.getSku())) {
                throw new IllegalArgumentException("SKU already exists");
            }
            
            // Set default values
            product.setCreatedAt(new Date());
            product.setUpdatedAt(new Date());
            product.setIsDeleted(false);
            if (product.getFeatured() == null) {
                product.setFeatured(false);
            }
            if (product.getStatus() == null) {
                product.setStatus("active");
            }
            
            dao.add(product);
            return product;
        }, "Error creating product");
    }
    
    @Override
    public Product updateProduct(Product product) {
        validateProduct(product);
        
        if (product.getProductId() == null || product.getProductId() <= 0) {
            throw new IllegalArgumentException("Invalid product ID");
        }
        
        return doInTransactionWithResult(em -> {
            ProductDAO dao = new ProductDAOImpl(em);
            
            // Check if product exists
            Product existing = dao.findById(product.getProductId());
            if (existing == null) {
                throw new RuntimeException("Product not found");
            }
            
            // Validate SKU if changed
            if (!existing.getSku().equals(product.getSku()) && dao.isSkuExisted(product.getSku())) {
                throw new IllegalArgumentException("SKU already exists");
            }
            
            // Update timestamp
            product.setUpdatedAt(new Date());
            
            dao.update(product);
            return product;
        }, "Error updating product");
    }
    
    @Override
    public List<Product> getActiveProducts() {
        return doInTransactionForList(em -> {
            ProductDAO dao = new ProductDAOImpl(em);
            return dao.getActiveProducts();
        }, "Error getting active products");
    }
    
    @Override
    public List<Product> getFeaturedProducts(int limit) {
        if (limit <= 0) {
            throw new IllegalArgumentException("Limit must be positive");
        }
        
        return doInTransactionForList(em -> {
            ProductDAO dao = new ProductDAOImpl(em);
            return dao.getFeaturedProducts(limit);
        }, "Error getting featured products");
    }
    
    @Override
    public List<Product> getTopRatedProducts(int limit) {
        if (limit <= 0) {
            throw new IllegalArgumentException("Limit must be positive");
        }
        
        return doInTransactionForList(em -> {
            ProductDAO dao = new ProductDAOImpl(em);
            return dao.getTopRatedProducts(limit);
        }, "Error getting top rated products");
    }
    
    @Override
    public List<Product> getOnSaleProducts(int limit) {
        if (limit <= 0) {
            throw new IllegalArgumentException("Limit must be positive");
        }
        
        return doInTransactionForList(em -> {
            ProductDAO dao = new ProductDAOImpl(em);
            return dao.getOnSaleProducts(limit);
        }, "Error getting products on sale");
    }
    
    @Override
    public boolean toggleProductStatus(Integer productId) {
        if (productId == null || productId <= 0) {
            throw new IllegalArgumentException("Invalid product ID");
        }
        
        return doInTransactionWithResult(em -> {
            ProductDAO dao = new ProductDAOImpl(em);
            return dao.toggleIsDeleted(productId);
        }, "Error toggling product status");
    }
    
    @Override
    public boolean toggleIsDeleted(Integer productId) {
        if (productId == null || productId <= 0) {
            throw new IllegalArgumentException("Invalid product ID");
        }
        
        return doInTransactionWithResult(em -> {
            ProductDAO dao = new ProductDAOImpl(em);
            return dao.toggleIsDeleted(productId);
        }, "Error toggling product deleted status");
    }
    
    @Override
    public boolean isSkuExists(String sku) {
        if (sku == null || sku.trim().isEmpty()) {
            throw new IllegalArgumentException("SKU cannot be empty");
        }
        
        return doInTransactionWithResult(em -> {
            ProductDAO dao = new ProductDAOImpl(em);
            return dao.isSkuExisted(sku);
        }, "Error checking SKU existence");
    }
    
    @Override
    public boolean isSkuExisted(String sku) {
        return isSkuExists(sku);
    }
    
    @Override
    public List<Product> getProductsByCategory(Integer categoryId) {
        if (categoryId == null || categoryId <= 0) {
            throw new IllegalArgumentException("Invalid category ID");
        }
        
        return doInTransactionForList(em -> {
            ProductDAO dao = new ProductDAOImpl(em);
            return dao.findByCategoryId(categoryId);
        }, "Error getting products by category");
    }
    
    @Override
    public List<Product> getProductsByBrand(String brandName) {
        if (brandName == null || brandName.trim().isEmpty()) {
            throw new IllegalArgumentException("Brand name cannot be empty");
        }
        
        return doInTransactionForList(em -> {
            ProductDAO dao = new ProductDAOImpl(em);
            return dao.findByBrandName(brandName);
        }, "Error getting products by brand");
    }
    
    @Override
    public List<Product> searchProducts(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            throw new IllegalArgumentException("Search keyword cannot be empty");
        }
        
        return doInTransactionForList(em -> {
            ProductDAO dao = new ProductDAOImpl(em);
            return dao.searchByName(keyword);
        }, "Error searching products");
    }
    
    @Override
    public List<Product> getProductsByPriceRange(double minPrice, double maxPrice) {
        if (minPrice < 0 || maxPrice < minPrice) {
            throw new IllegalArgumentException("Invalid price range");
        }
        
        return doInTransactionForList(em -> {
            ProductDAO dao = new ProductDAOImpl(em);
            return dao.findByPriceRange(minPrice, maxPrice);
        }, "Error getting products by price range");
    }
    
    @Override
    public Product updateStock(Integer productId, int stockChange) {
        if (productId == null || productId <= 0) {
            throw new IllegalArgumentException("Invalid product ID");
        }
        return doInTransactionWithResult(em -> {
            ProductDAO dao = new ProductDAOImpl(em);
            Product product = dao.findById(productId);
            if (product == null) {
                throw new RuntimeException("Product not found");
            }
            int newStock = product.getStock() + stockChange;
            if (newStock < 0) {
                throw new IllegalArgumentException("Resulting stock would be negative");
            }
            product.setStock(newStock);
            product.setUpdatedAt(new Date());
            dao.update(product);
            return product;
        }, "Error updating product stock");
    }
    
    @Override
    public List<Product> searchProducts(String keyword, Integer categoryId) {
        return doInTransactionForList(em -> {
            ProductDAO dao = new ProductDAOImpl(em);
            return dao.searchProducts(keyword, categoryId);
        }, "Error searching products by keyword and category");
    }
    
    private void validateProduct(Product product) {
        if (product == null) {
            throw new IllegalArgumentException("Product cannot be null");
        }
        if (product.getProductName() == null || product.getProductName().trim().isEmpty()) {
            throw new IllegalArgumentException("Product name cannot be empty");
        }
        if (product.getPrice() == null || product.getPrice().compareTo(BigDecimal.ZERO) < 0) {
            throw new IllegalArgumentException("Price cannot be negative");
        }
        if (product.getSalePrice() != null && product.getSalePrice().compareTo(product.getPrice()) > 0) {
            throw new IllegalArgumentException("Sale price cannot be greater than regular price");
        }
        if (product.getStock() < 0) {
            throw new IllegalArgumentException("Stock cannot be negative");
        }
        if (product.getSku() == null || product.getSku().trim().isEmpty()) {
            throw new IllegalArgumentException("SKU cannot be empty");
        }
    }
    
    // Admin methods
    @Override
    public int getTotalProducts(int adminUserId) {
        return doInTransactionWithResult(em -> {
            // Check if user is admin
            model.entity.User admin = em.find(model.entity.User.class, adminUserId);
            if (admin == null || !"admin".equals(admin.getRole())) {
                return 0;
            }
            
            String jpql = "SELECT COUNT(p) FROM Product p WHERE p.isDeleted = false";
            Long count = em.createQuery(jpql, Long.class).getSingleResult();
            return count.intValue();
        }, "Error getting total products");
    }
    
    @Override
    public List<?> getTopSellingProducts(int adminUserId, int limit) {
        if (limit <= 0) {
            throw new IllegalArgumentException("Limit must be positive");
        }
        
        return doInTransactionWithResult(em -> {
            // Check if user is admin
            model.entity.User admin = em.find(model.entity.User.class, adminUserId);
            if (admin == null || !"admin".equals(admin.getRole())) {
                return List.of();
            }
            
            // This is a simplified implementation
            // In a real application, you would join with order details to get actual sales data
            String jpql = "SELECT p.productId, p.productName, p.price, p.stock FROM Product p " +
                         "WHERE p.isDeleted = false AND p.status = 'active' " +
                         "ORDER BY p.stock DESC";
            return em.createQuery(jpql)
                    .setMaxResults(limit)
                    .getResultList();
        }, "Error getting top selling products");
    }
    
    @Override
    public List<Product> getAllProducts() {
        return doInTransactionForList(em -> {
            ProductDAO dao = new ProductDAOImpl(em);
            return dao.findAll();
        }, "Error getting all products");
    }
} 
 
 