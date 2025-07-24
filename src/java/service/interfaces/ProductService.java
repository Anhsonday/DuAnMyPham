package service.interfaces;

import java.util.List;
import model.entity.Product;

/**
 * Service interface for Product entity
 */
public interface ProductService extends IGenericService<Product> {
    
    /**
     * Get product by ID
     * @param productId product ID
     * @return product or null if not found
     * @throws IllegalArgumentException if ID is invalid
     * @throws RuntimeException if database error occurs
     */
    Product getProductById(Integer productId);
    
    /**
     * Get product by ID with access control (cũ, dùng boolean isAdmin)
     */
    Product getProductByIdWithAccessControl(Integer productId, boolean isAdmin);
    /**
     * Get product by ID with access control (mới, nhận User)
     */
    Product getProductByIdWithAccessControl(Integer productId, model.entity.User user);
    
    /**
     * Create new product
     * @param product product to create
     * @return created product with ID
     * @throws IllegalArgumentException if:
     * - product is null
     * - product name is empty
     * - price is negative
     * - sale price is greater than regular price
     * - quantity is negative
     * - SKU already exists
     * @throws RuntimeException if database error occurs
     */
    Product createProduct(Product product);
    
    /**
     * Update existing product
     * @param product product to update
     * @return updated product
     * @throws IllegalArgumentException if:
     * - product is null
     * - product ID is invalid
     * - product name is empty
     * - price is negative
     * - sale price is greater than regular price
     * - quantity is negative
     * - SKU already exists (for different product)
     * @throws RuntimeException if product not found or database error occurs
     */
    Product updateProduct(Product product);
    
    /**
     * Get active products (not deleted and status = active)
     * @return List of active products
     * @throws RuntimeException if database error occurs
     */
    List<Product> getActiveProducts();
    
    /**
     * Get featured products
     * @param limit maximum number of products
     * @return List of featured products
     * @throws IllegalArgumentException if limit <= 0
     * @throws RuntimeException if database error occurs
     */
    List<Product> getFeaturedProducts(int limit);
    
    /**
     * Get top rated products
     * @param limit maximum number of products
     * @return List of top rated products
     * @throws IllegalArgumentException if limit <= 0
     * @throws RuntimeException if database error occurs
     */
    List<Product> getTopRatedProducts(int limit);
    
    /**
     * Get products on sale
     * @param limit maximum number of products
     * @return List of products on sale
     * @throws IllegalArgumentException if limit <= 0
     * @throws RuntimeException if database error occurs
     */
    List<Product> getOnSaleProducts(int limit);
    
    /**
     * Toggle product deleted status
     * @param productId product ID
     * @return true if successful
     * @throws IllegalArgumentException if ID is invalid
     * @throws RuntimeException if database error occurs
     */
    boolean toggleProductStatus(Integer productId);
    
    /**
     * Toggle product isDeleted field
     * @param productId product ID
     * @return true if successful
     * @throws IllegalArgumentException if ID is invalid
     * @throws RuntimeException if database error occurs
     */
    boolean toggleIsDeleted(Integer productId);
    
    /**
     * Check if SKU exists
     * @param sku SKU to check
     * @return true if exists
     * @throws IllegalArgumentException if SKU is null or empty
     * @throws RuntimeException if database error occurs
     */
    boolean isSkuExists(String sku);
    
    /**
     * Check if SKU existed (alias for isSkuExists)
     * @param sku SKU to check
     * @return true if exists
     * @throws IllegalArgumentException if SKU is null or empty
     * @throws RuntimeException if database error occurs
     */
    boolean isSkuExisted(String sku);
    
    /**
     * Get products by category
     * @param categoryId category ID
     * @return List of products in category
     * @throws IllegalArgumentException if category ID is invalid
     * @throws RuntimeException if database error occurs
     */
    List<Product> getProductsByCategory(Integer categoryId);
    
    /**
     * Get products by brand name
     * @param brandName brand name
     * @return List of products by brand
     * @throws IllegalArgumentException if brand name is null or empty
     * @throws RuntimeException if database error occurs
     */
    List<Product> getProductsByBrand(String brandName);
    
    /**
     * Search products by name
     * @param keyword search keyword
     * @return List of matching products
     * @throws IllegalArgumentException if keyword is null or empty
     * @throws RuntimeException if database error occurs
     */
    List<Product> searchProducts(String keyword);
    
    /**
     * Search products by keyword and category
     * @param keyword search keyword (nullable)
     * @param categoryId category ID (nullable)
     * @return List of matching products
     */
    List<Product> searchProducts(String keyword, Integer categoryId);
    
    /**
     * Get products in price range
     * @param minPrice minimum price
     * @param maxPrice maximum price
     * @return List of products in range
     * @throws IllegalArgumentException if:
     * - minPrice > maxPrice
     * - minPrice or maxPrice is negative
     * @throws RuntimeException if database error occurs
     */
    List<Product> getProductsByPriceRange(double minPrice, double maxPrice);
    
    /**
     * Update product stock
     * @param productId product ID
     * @param stockChange change in stock (positive: add, negative: subtract)
     * @return updated product
     * @throws IllegalArgumentException if:
     * - product ID is invalid
     * - resulting stock would be negative
     * @throws RuntimeException if product not found or database error occurs
     */
    Product updateStock(Integer productId, int stockChange);
    
    // Admin methods
    /**
     * Get total number of products (admin only)
     * @param adminUserId admin user ID for authorization
     * @return total number of products
     * @throws RuntimeException if user is not admin or database error occurs
     */
    int getTotalProducts(int adminUserId);
    
    /**
     * Get top selling products (admin only)
     * @param adminUserId admin user ID for authorization
     * @param limit maximum number of products
     * @return List of top selling products with sales data
     * @throws IllegalArgumentException if limit <= 0
     * @throws RuntimeException if user is not admin or database error occurs
     */
    List<?> getTopSellingProducts(int adminUserId, int limit);
    
    /**
     * Get all products (admin only)
     * @return List of all products
     * @throws RuntimeException if database error occurs
     */
    List<Product> getAllProducts();
} 
 
 