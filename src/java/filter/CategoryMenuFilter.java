package filter;

import model.entity.Category;
import service.impl.CategoryServiceImpl;
import service.interfaces.CategoryService;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.List;

@WebFilter("/*")
public class CategoryMenuFilter implements Filter {

    private CategoryService categoryService;

    @Override
    public void init(FilterConfig filterConfig) {
        categoryService = new CategoryServiceImpl();
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpReq = (HttpServletRequest) request;
        // Kiểm tra nếu chưa có allCategories hoặc luôn lấy mới
        if (httpReq.getAttribute("allCategories") == null) {
            List<Category> allCategories = categoryService.getAllCategories();
            request.setAttribute("allCategories", allCategories);
        }
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {}
}
