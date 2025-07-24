package dao.interfaces;

import java.util.List;
import model.entity.ProductDetail;

/**
 * DAO interface for ProductDetail entity
 */
public interface ProductDetailDAO extends IGenericDAO<ProductDetail, Integer> {
    
    /**
     * Find product detail by product ID
     * @param productId product ID to search for
     * @return ProductDetail object if found, null otherwise
     */
    ProductDetail findByProductId(Integer productId);
    
    /**
     * Soft delete a product detail
     * @param productDetailId ID of product detail to delete
     * @return true if successful, false otherwise
     */
    boolean softDelete(Integer productDetailId);
} 
 
 
 
 