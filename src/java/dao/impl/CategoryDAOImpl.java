package dao.impl;

import dao.interfaces.CategoryDAO;
import model.entity.Category;

import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import java.util.List;

public class CategoryDAOImpl implements CategoryDAO {
    private EntityManager em;

    public CategoryDAOImpl(EntityManager em) {
        this.em = em;
    }

    @Override
    public Category findById(Integer id) {
        return em.find(Category.class, id);
    }

    @Override
    public List<Category> findAll() {
        String jpql = "SELECT c FROM Category c WHERE c.isDeleted = false OR c.isDeleted IS NULL";
        TypedQuery<Category> query = em.createQuery(jpql, Category.class);
        return query.getResultList();
    }

    @Override
    public List<Category> findByParentId(Integer parentId) {
        String jpql = "SELECT c FROM Category c WHERE c.parentCategoryId.categoryId = :parentId AND (c.isDeleted = false OR c.isDeleted IS NULL)";
        TypedQuery<Category> query = em.createQuery(jpql, Category.class);
        query.setParameter("parentId", parentId);
        return query.getResultList();
    }

    @Override
    public List<Category> findRootCategories() {
        String jpql = "SELECT c FROM Category c WHERE c.parentCategoryId IS NULL AND (c.isDeleted = false OR c.isDeleted IS NULL)";
        TypedQuery<Category> query = em.createQuery(jpql, Category.class);
        return query.getResultList();
    }

    @Override
    public List<Category> findByName(String name) {
        String jpql = "SELECT c FROM Category c WHERE LOWER(c.categoryName) = :name AND (c.isDeleted = false OR c.isDeleted IS NULL)";
        TypedQuery<Category> query = em.createQuery(jpql, Category.class);
        query.setParameter("name", name.toLowerCase());
        return query.getResultList();
    }
} 