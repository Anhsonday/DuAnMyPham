package dao.impl;

import dao.interfaces.ProductDAO;
import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import jakarta.persistence.TypedQuery;
import java.util.List;
import model.entity.Product;
import model.entity.Review;
import java.util.stream.Collectors;

/**
 * Implementation of ProductDAO using JPA
 */
public class ProductDAOImpl extends GenericDAO<Product, Integer> implements ProductDAO {

    public ProductDAOImpl(EntityManager em) {
        super(em, Product.class);
    }

    @Override
    public List<Product> getActiveProducts() {
        String jpql = "SELECT p FROM Product p WHERE p.status = :status AND p.isDeleted = false";
        return em.createQuery(jpql, Product.class)
                 .setParameter("status", "active")
                 .getResultList();
    }

    @Override
    public List<Product> getFeaturedProducts(int limit) {
        String jpql = "SELECT p FROM Product p WHERE p.featured = true AND p.status = :status " +
                     "AND p.isDeleted = false ORDER BY p.createdAt DESC";
        return em.createQuery(jpql, Product.class)
                 .setParameter("status", "active")
                 .setMaxResults(limit)
                 .getResultList();
    }

    @Override
    public List<Product> getTopRatedProducts(int limit) {
        String jpql = "SELECT p, AVG(r.rating) as avgRating " +
                     "FROM Review r JOIN r.productId p " +
                     "WHERE p.status = :status AND p.isDeleted = false " +
                     "AND r.isDeleted = false AND r.status = 'approved' " +
                     "GROUP BY p " +
                     "ORDER BY avgRating DESC";
        
        return em.createQuery(jpql, Object[].class)
                 .setParameter("status", "active")
                 .setMaxResults(limit)
                 .getResultList()
                 .stream()
                 .map(result -> (Product) result[0])
                 .collect(Collectors.toList());
    }

    @Override
    public List<Product> getOnSaleProducts(int limit) {
        String jpql = "SELECT p FROM Product p WHERE p.status = :status AND p.isDeleted = false " +
                     "AND p.salePrice IS NOT NULL AND p.salePrice > 0 AND p.salePrice < p.price " +
                     "ORDER BY (p.price - p.salePrice) DESC";
        return em.createQuery(jpql, Product.class)
                 .setParameter("status", "active")
                 .setMaxResults(limit)
                 .getResultList();
    }

    @Override
    public boolean toggleIsDeleted(int productId) {
        String jpql = "UPDATE Product p SET p.isDeleted = CASE WHEN p.isDeleted = false THEN true ELSE false END, " +
                     "p.updatedAt = CURRENT_TIMESTAMP WHERE p.productId = :productId";
        int rowsAffected = em.createQuery(jpql)
                            .setParameter("productId", productId)
                            .executeUpdate();
        return rowsAffected > 0;
    }

    @Override
    public boolean isSkuExisted(String sku) {
        String jpql = "SELECT COUNT(p) FROM Product p WHERE p.sku = :sku";
        try {
            Long count = em.createQuery(jpql, Long.class)
                          .setParameter("sku", sku)
                          .getSingleResult();
            return count > 0;
        } catch (NoResultException e) {
            return false;
        }
    }

    @Override
    public List<Product> findByCategoryId(Integer categoryId) {
        String jpql = "SELECT p FROM Product p WHERE p.categoryId.categoryId = :categoryId " +
                     "AND p.isDeleted = false";
        return em.createQuery(jpql, Product.class)
                 .setParameter("categoryId", categoryId)
                 .getResultList();
    }

    @Override
    public List<Product> findByBrandName(String brandName) {
        String jpql = "SELECT p FROM Product p WHERE p.brandName = :brandName " +
                     "AND p.isDeleted = false";
        return em.createQuery(jpql, Product.class)
                 .setParameter("brandName", brandName)
                 .getResultList();
    }

    @Override
    public List<Product> searchByName(String keyword) {
        String jpql = "SELECT p FROM Product p WHERE LOWER(p.productName) LIKE LOWER(:keyword) " +
                     "AND p.isDeleted = false";
        return em.createQuery(jpql, Product.class)
                 .setParameter("keyword", "%" + keyword + "%")
                 .getResultList();
    }

    @Override
    public List<Product> findByPriceRange(double minPrice, double maxPrice) {
        String jpql = "SELECT p FROM Product p WHERE p.price BETWEEN :minPrice AND :maxPrice " +
                     "AND p.isDeleted = false";
        return em.createQuery(jpql, Product.class)
                 .setParameter("minPrice", minPrice)
                 .setParameter("maxPrice", maxPrice)
                 .getResultList();
    }

    @Override
    public List<Product> searchProducts(String keyword, Integer categoryId) {
        String jpql = "SELECT p FROM Product p WHERE p.isDeleted = false";
        boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();
        boolean hasCategory = categoryId != null && categoryId > 0;
        if (hasKeyword) {
            jpql += " AND LOWER(p.productName) LIKE LOWER(:keyword)";
        }
        if (hasCategory) {
            jpql += " AND p.categoryId.categoryId = :categoryId";
        }
        TypedQuery<Product> query = em.createQuery(jpql, Product.class);
        if (hasKeyword) {
            query.setParameter("keyword", "%" + keyword + "%");
        }
        if (hasCategory) {
            query.setParameter("categoryId", categoryId);
        }
        return query.getResultList();
    }
}
