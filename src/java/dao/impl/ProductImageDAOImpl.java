package dao.impl;

import dao.interfaces.ProductImageDAO;
import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import java.util.List;
import model.entity.ProductImage;

public class ProductImageDAOImpl extends GenericDAO<ProductImage, Integer> implements ProductImageDAO {

    public ProductImageDAOImpl(EntityManager em) {
        super(em, ProductImage.class);
    }

    @Override
    public List<ProductImage> findByProductId(Integer productId) {
        String jpql = "SELECT pi FROM ProductImage pi WHERE pi.productId.id = :productId AND pi.isDeleted = false ORDER BY pi.displayOrder";
        return em.createQuery(jpql, ProductImage.class)
                 .setParameter("productId", productId)
                 .getResultList();
    }

    @Override
    public ProductImage findMainImageByProductId(Integer productId) {
        String jpql = "SELECT pi FROM ProductImage pi WHERE pi.productId.id = :productId AND pi.isMainImage = true AND pi.isDeleted = false";
        try {
            return em.createQuery(jpql, ProductImage.class)
                     .setParameter("productId", productId)
                     .getSingleResult();
        } catch (NoResultException e) {
            return null;
        }
    }

    @Override
    public boolean softDelete(Integer imageId) {
        ProductImage img = findById(imageId);
        if (img != null) {
            img.setIsDeleted(true);
            update(img);
            return true;
        }
        return false;
    }

    @Override
    public boolean restore(Integer imageId) {
        ProductImage img = findById(imageId);
        if (img != null) {
            img.setIsDeleted(false);
            update(img);
            return true;
        }
        return false;
    }
} 