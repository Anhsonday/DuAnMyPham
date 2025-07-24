package service.interfaces;

import java.util.List;
import model.entity.Category;

/**
 * Service interface for Category entity
 */
public interface CategoryService extends IGenericService<Category> {
    
    /**
     * Get category by ID
     * @param categoryId category ID
     * @return Category entity or null if not found
     */
    Category getCategoryById(Integer categoryId);
    
    /**
     * Get all active categories
     * @return List of active categories
     */
    List<Category> getAllCategories();
    
    /**
     * Get categories by parent ID
     * @param parentId parent category ID
     * @return List of child categories
     */
    List<Category> getCategoriesByParentId(Integer parentId);
    
    /**
     * Get root categories (no parent)
     * @return List of root categories
     */
    List<Category> getRootCategories();
    
    /**
     * Check if category name exists
     * @param categoryName category name to check
     * @return true if exists, false otherwise
     */
    boolean isCategoryNameExists(String categoryName);
    
    /**
     * Get category by name
     * @param categoryName category name
     * @return Category entity or null if not found
     */
    Category getCategoryByName(String categoryName);
} 
 
 