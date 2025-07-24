package service.impl;

import dao.impl.ProductImageDAOImpl;
import model.entity.ProductImage;
import service.interfaces.ProductImageService;
import java.util.List;

public class ProductImageServiceImpl extends GenericService<ProductImage> implements ProductImageService {

    @Override
    public List<ProductImage> findByProductId(Integer productId) {
        return doInTransactionWithResult(em -> {
            ProductImageDAOImpl dao = new ProductImageDAOImpl(em);
            return dao.findByProductId(productId);
        }, "Error finding images by product ID");
    }

    @Override
    public ProductImage findMainImageByProductId(Integer productId) {
        return doInTransactionWithResult(em -> {
            ProductImageDAOImpl dao = new ProductImageDAOImpl(em);
            return dao.findMainImageByProductId(productId);
        }, "Error finding main image by product ID");
    }

    @Override
    public boolean softDelete(Integer imageId) {
        return doInTransactionWithResult(em -> {
            ProductImageDAOImpl dao = new ProductImageDAOImpl(em);
            return dao.softDelete(imageId);
        }, "Error soft deleting image");
    }

    @Override
    public boolean restore(Integer imageId) {
        return doInTransactionWithResult(em -> {
            ProductImageDAOImpl dao = new ProductImageDAOImpl(em);
            return dao.restore(imageId);
        }, "Error restoring image");
    }
    
    @Override
    public ProductImage insertProductImage(ProductImage productImage) {
        return doInTransactionWithResult(em -> {
            ProductImageDAOImpl dao = new ProductImageDAOImpl(em);
            dao.add(productImage);
            return productImage;
        }, "Error inserting product image");
    }
    
    @Override
    public ProductImage updateProductImage(ProductImage productImage) {
        return doInTransactionWithResult(em -> {
            ProductImageDAOImpl dao = new ProductImageDAOImpl(em);
            dao.update(productImage);
            return productImage;
        }, "Error updating product image");
    }
    
    @Override
    public boolean deleteProductImage(Integer imageId) {
        return doInTransactionWithResult(em -> {
            ProductImageDAOImpl dao = new ProductImageDAOImpl(em);
            dao.delete(imageId);
            return true;
        }, "Error deleting product image");
    }
} 