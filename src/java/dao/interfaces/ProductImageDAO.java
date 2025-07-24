package dao.interfaces;

import java.util.List;
import model.entity.ProductImage;

public interface ProductImageDAO extends IGenericDAO<ProductImage, Integer> {
    List<ProductImage> findByProductId(Integer productId);
    ProductImage findMainImageByProductId(Integer productId);
    boolean softDelete(Integer imageId);
    boolean restore(Integer imageId);
} 