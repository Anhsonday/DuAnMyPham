package controller.admin;

import model.entity.User;
import service.impl.ProductServiceImpl;
import service.impl.UserServiceImpl;
import service.impl.OrderServiceImpl;
import service.interfaces.ProductService;
import service.interfaces.UserService;
import service.interfaces.OrderService;
import utils.SessionUtils;
import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.List;
import java.util.ArrayList;
import java.math.BigDecimal;
import java.text.NumberFormat;
import java.util.Locale;

@WebServlet(name = "AdminDashboardServlet", urlPatterns = {"/admin-dashboard"})
public class AdminDashboardServlet extends HttpServlet {
    
    private final ProductService productService;
    private final UserService userService;
    private final OrderService orderService;
    
    public AdminDashboardServlet() {
        this.productService = new ProductServiceImpl();
        this.userService = new UserServiceImpl();
        this.orderService = new OrderServiceImpl();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Get current user from session
        User currentUser = SessionUtils.getUser(request.getSession());
        
        // Check if user is logged in and is admin
        if (currentUser == null || !"admin".equals(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        try {
            // Lấy dữ liệu dashboard cho admin
            Map<String, Object> dashboardData = getDashboardData(currentUser.getUserId());
            
            // Đưa dữ liệu vào request
            request.setAttribute("dashboardData", dashboardData);
            request.setAttribute("totalProducts", dashboardData.get("totalProducts"));
            request.setAttribute("totalOrders", dashboardData.get("totalOrders"));
            request.setAttribute("totalUsers", dashboardData.get("totalUsers"));
            request.setAttribute("totalRevenue", dashboardData.get("totalRevenue"));
            request.setAttribute("todayRevenue", dashboardData.get("todayRevenue"));
            request.setAttribute("todayOrders", dashboardData.get("todayOrders"));
            request.setAttribute("pendingOrders", dashboardData.get("pendingOrders"));
            request.setAttribute("revenueGrowth", dashboardData.get("revenueGrowth"));
            request.setAttribute("monthlyRevenue", dashboardData.get("monthlyRevenue"));
            request.setAttribute("recentOrders", dashboardData.get("recentOrders"));
            request.setAttribute("topProducts", dashboardData.get("topProducts"));
            request.setAttribute("orderStatistics", dashboardData.get("orderStatistics"));
            
            // Tính tổng doanh thu thực tế (sum FinalAmount các đơn đã xác nhận/thành công)
            double revenueTotalRaw = orderService.getTotalRevenue(currentUser.getUserId());
            NumberFormat nf = NumberFormat.getInstance(new Locale("vi", "VN"));
            nf.setMaximumFractionDigits(0);
            String revenueTotalFormatted = nf.format(revenueTotalRaw);
            request.setAttribute("revenueTotalFormatted", revenueTotalFormatted);

            // Forward đến trang dashboard
            request.getRequestDispatcher("/admin-dashboard.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/home");
        }
    }
    
    private Map<String, Object> getDashboardData(int adminUserId) {
        Map<String, Object> data = new HashMap<>();
        
        try {
            // Thống kê tổng quan - sử dụng Service layer
            data.put("totalProducts", productService.getTotalProducts(adminUserId));
            data.put("totalOrders", orderService.getTotalOrders(adminUserId));
            data.put("totalUsers", userService.getTotalUsers(adminUserId));
            data.put("totalRevenue", orderService.getTotalRevenue(adminUserId));
            
            // Thống kê thêm
            data.put("todayRevenue", orderService.getTodayRevenue(adminUserId));
            data.put("todayOrders", orderService.getTodayOrders(adminUserId));
            data.put("pendingOrders", orderService.getPendingOrders(adminUserId));
            data.put("revenueGrowth", orderService.getRevenueGrowth(adminUserId));
            
            // Doanh thu theo tháng
            data.put("monthlyRevenue", orderService.getMonthlyRevenue(adminUserId));
            
            // Đơn hàng gần đây
            data.put("recentOrders", orderService.getRecentOrders(adminUserId, 10));
            
            // Top sản phẩm bán chạy
            data.put("topProducts", productService.getTopSellingProducts(adminUserId, 10));
            
            // Thống kê đơn hàng theo trạng thái
            data.put("orderStatistics", orderService.getOrderStatistics(adminUserId));
            
        } catch (Exception e) {
            e.printStackTrace();
            // Set default values if there's an error
            data.put("totalProducts", 0);
            data.put("totalOrders", 0);
            data.put("totalUsers", 0);
            data.put("totalRevenue", 0.0);
            data.put("todayRevenue", 0.0);
            data.put("todayOrders", 0);
            data.put("pendingOrders", 0);
            data.put("revenueGrowth", 0.0);
            data.put("monthlyRevenue", new HashMap<>());
            data.put("recentOrders", new ArrayList<>());
            data.put("topProducts", new ArrayList<>());
            data.put("orderStatistics", new HashMap<>());
        }
        
        return data;
    }
}