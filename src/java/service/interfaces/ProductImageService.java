package service.interfaces;

import java.util.List;
import model.entity.ProductImage;

public interface ProductImageService extends IGenericService<ProductImage> {
    List<ProductImage> findByProductId(Integer productId);
    ProductImage findMainImageByProductId(Integer productId);
    boolean softDelete(Integer imageId);
    boolean restore(Integer imageId);
    
    // Additional methods needed by ProductServlet
    ProductImage insertProductImage(ProductImage productImage);
    ProductImage updateProductImage(ProductImage productImage);
    boolean deleteProductImage(Integer imageId);
} 