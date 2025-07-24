package dao.interfaces;

import model.entity.Category;
import java.util.List;

public interface CategoryDAO {
    Category findById(Integer id);
    List<Category> findAll();
    List<Category> findByParentId(Integer parentId);
    List<Category> findRootCategories();
    List<Category> findByName(String name);
} 