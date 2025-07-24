package dao.impl;

import dao.interfaces.ProductDetailDAO;
import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import model.entity.ProductDetail;

/**
 * Implementation of ProductDetailDAO
 */
public class ProductDetailDAOImpl extends GenericDAO<ProductDetail, Integer> implements ProductDetailDAO {

    public ProductDetailDAOImpl(EntityManager em) {
        super(em, ProductDetail.class);
    }

    @Override
    public ProductDetail findByProductId(Integer productId) {
        String jpql = "SELECT pd FROM ProductDetail pd WHERE pd.productId.productId = :productId AND pd.isDeleted = false";
        try {
            return em.createQuery(jpql, ProductDetail.class)
                    .setParameter("productId", productId)
                    .getSingleResult();
        } catch (NoResultException e) {
            return null;
        }
    }

    @Override
    public boolean softDelete(Integer productDetailId) {
        try {
            ProductDetail detail = findById(productDetailId);
            if (detail != null) {
                detail.setIsDeleted(true);
                update(detail);
                return true;
            }
            return false;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
} 