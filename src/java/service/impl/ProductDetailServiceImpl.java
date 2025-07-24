package service.impl;

import dao.impl.ProductDetailDAOImpl;
import model.entity.ProductDetail;
import service.interfaces.ProductDetailService;

/**
 * Implementation of ProductDetailService
 */
public class ProductDetailServiceImpl extends GenericService<ProductDetail> implements ProductDetailService {

    @Override
    public ProductDetail getProductDetailByProductId(Integer productId) {
        if (productId == null) {
            throw new IllegalArgumentException("Product ID cannot be null");
        }
        
        return doInTransactionWithResult(em -> {
            ProductDetailDAOImpl dao = new ProductDetailDAOImpl(em);
            return dao.findByProductId(productId);
        }, "Error getting product detail by product ID");
    }

    @Override
    public ProductDetail createProductDetail(ProductDetail productDetail) {
        if (productDetail == null) {
            throw new IllegalArgumentException("Product detail cannot be null");
        }
        
        return doInTransactionWithResult(em -> {
            ProductDetailDAOImpl dao = new ProductDetailDAOImpl(em);
            productDetail.setIsDeleted(false);
            dao.add(productDetail);
            return productDetail;
        }, "Error creating product detail");
    }

    @Override
    public ProductDetail updateProductDetail(ProductDetail productDetail) {
        if (productDetail == null || productDetail.getProductDetailId() == null) {
            throw new IllegalArgumentException("Product detail and its ID cannot be null");
        }
        
        return doInTransactionWithResult(em -> {
            ProductDetailDAOImpl dao = new ProductDetailDAOImpl(em);
            dao.update(productDetail);
            return productDetail;
        }, "Error updating product detail");
    }

    @Override
    public boolean deleteByProductId(Integer productId) {
        if (productId == null) {
            throw new IllegalArgumentException("Product ID cannot be null");
        }
        
        return doInTransactionWithResult(em -> {
            ProductDetailDAOImpl dao = new ProductDetailDAOImpl(em);
            ProductDetail productDetail = dao.findByProductId(productId);
            if (productDetail != null) {
                productDetail.setIsDeleted(true);
                dao.update(productDetail);
                return true;
            }
            return false;
        }, "Error deleting product detail by product ID");
    }
} 