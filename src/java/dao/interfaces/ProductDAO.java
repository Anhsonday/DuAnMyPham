package dao.interfaces;

import java.util.List;
import model.entity.Product;

/**
 * DAO interface for Product entity
 */
public interface ProductDAO extends IGenericDAO<Product, Integer> {
    
    /**
     * Get list of active products
     * @return List of active products
     */
    List<Product> getActiveProducts();
    
    /**
     * Get featured products with limit
     * @param limit Maximum number of products to return
     * @return List of featured products
     */
    List<Product> getFeaturedProducts(int limit);
    
    /**
     * Get top rated products with limit
     * @param limit Maximum number of products to return
     * @return List of top rated products
     */
    List<Product> getTopRatedProducts(int limit);
    
    /**
     * Get products on sale with limit
     * @param limit Maximum number of products to return
     * @return List of products on sale
     */
    List<Product> getOnSaleProducts(int limit);
    
    /**
     * Toggle isDeleted status of a product
     * @param productId Product ID
     * @return true if successful
     */
    boolean toggleIsDeleted(int productId);
    
    /**
     * Check if SKU exists
     * @param sku SKU to check
     * @return true if SKU exists
     */
    boolean isSkuExisted(String sku);
    
    /**
     * Find products by category ID
     * @param categoryId Category ID
     * @return List of products in category
     */
    List<Product> findByCategoryId(Integer categoryId);
    
    /**
     * Find products by brand name
     * @param brandName Brand name
     * @return List of products by brand
     */
    List<Product> findByBrandName(String brandName);
    
    /**
     * Search products by name
     * @param keyword Search keyword
     * @return List of matching products
     */
    List<Product> searchByName(String keyword);
    
    /**
     * Find products in price range
     * @param minPrice Minimum price
     * @param maxPrice Maximum price
     * @return List of products in range
     */
    List<Product> findByPriceRange(double minPrice, double maxPrice);
    
    /**
     * Search products by keyword and category
     * @param keyword Search keyword (nullable)
     * @param categoryId Category ID (nullable)
     * @return List of matching products
     */
    List<Product> searchProducts(String keyword, Integer categoryId);
} 
 
 
 
 