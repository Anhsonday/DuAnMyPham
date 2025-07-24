package service.impl;

import dao.impl.CategoryDAOImpl;
import java.util.List;
import model.entity.Category;
import service.interfaces.CategoryService;

/**
 * Implementation of CategoryService
 */
public class CategoryServiceImpl extends GenericService<Category> implements CategoryService {

    @Override
    public Category getCategoryById(Integer categoryId) {
        if (categoryId == null || categoryId <= 0) {
            return null;
        }
        
        return doInTransactionWithResult(em -> {
            CategoryDAOImpl dao = new CategoryDAOImpl(em);
            return dao.findById(categoryId);
        }, "Error getting category by ID");
    }
    
    @Override
    public List<Category> getAllCategories() {
        return doInTransactionForList(em -> {
            CategoryDAOImpl dao = new CategoryDAOImpl(em);
            return dao.findAll();
        }, "Error getting all categories");
    }

    @Override
    public List<Category> getCategoriesByParentId(Integer parentId) {
        if (parentId == null) {
            throw new IllegalArgumentException("Parent ID cannot be null");
        }
        
        return doInTransactionForList(em -> {
            CategoryDAOImpl dao = new CategoryDAOImpl(em);
            return dao.findByParentId(parentId);
        }, "Error getting categories by parent ID");
    }

    @Override
    public List<Category> getRootCategories() {
        return doInTransactionForList(em -> {
            CategoryDAOImpl dao = new CategoryDAOImpl(em);
            return dao.findRootCategories();
        }, "Error getting root categories");
    }

    @Override
    public boolean isCategoryNameExists(String categoryName) {
        if (categoryName == null || categoryName.trim().isEmpty()) {
            return false;
        }
        
        return doInTransactionWithResult(em -> {
            CategoryDAOImpl dao = new CategoryDAOImpl(em);
            List<Category> categories = dao.findByName(categoryName.trim());
            return !categories.isEmpty();
        }, "Error checking category name existence");
    }

    @Override
    public Category getCategoryByName(String categoryName) {
        if (categoryName == null || categoryName.trim().isEmpty()) {
            return null;
        }
        
        return doInTransactionWithResult(em -> {
            CategoryDAOImpl dao = new CategoryDAOImpl(em);
            List<Category> categories = dao.findByName(categoryName.trim());
            return categories.isEmpty() ? null : categories.get(0);
        }, "Error getting category by name");
    }
} 
 
 