package service.interfaces;

import model.entity.ProductDetail;

/**
 * Service interface for ProductDetail entity
 */
public interface ProductDetailService extends IGenericService<ProductDetail> {
    
    /**
     * Get product detail by product ID
     * @param productId product ID
     * @return ProductDetail entity or null if not found
     */
    ProductDetail getProductDetailByProductId(Integer productId);
    
    /**
     * Create new product detail
     * @param productDetail product detail to create
     * @return created ProductDetail or null if failed
     */
    ProductDetail createProductDetail(ProductDetail productDetail);
    
    /**
     * Update existing product detail
     * @param productDetail product detail to update
     * @return updated ProductDetail or null if failed
     */
    ProductDetail updateProductDetail(ProductDetail productDetail);
    
    /**
     * Delete product detail by product ID
     * @param productId product ID
     * @return true if successful, false otherwise
     */
    boolean deleteByProductId(Integer productId);
} 
 
 