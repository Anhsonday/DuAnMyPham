package controller.admin;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import service.impl.OrderServiceImpl;
import service.interfaces.OrderService;
import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.entity.Order;

@WebServlet(name = "DashboardDataServlet", urlPatterns = {"/api/revenue-data"})
public class DashboardDataServlet extends HttpServlet {

    private OrderService orderService;
    
    @Override
    public void init() {
        orderService = new OrderServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Set response type to JSON
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        // Check if user is admin (you should implement proper session checking)
        // For now, we'll use admin ID 1 as default
        
        // Get date range parameter
        String range = request.getParameter("range");
        if (range == null || range.isEmpty()) {
            range = "this-week"; // Default range
        }
        
        // Get data based on range
        JsonObject result = getRevenueDataForRange(range);
        
        // Send response
        try (PrintWriter out = response.getWriter()) {
            out.print(result.toString());
            out.flush();
        }
    }
    
    private JsonObject getRevenueDataForRange(String range) {
        // Calculate start and end dates based on range
        Date startDate = null;
        Date endDate = new Date(); // Today's date
        List<String> labels = new ArrayList<>();
        
        Calendar cal = Calendar.getInstance();
        cal.setTime(endDate);
        
        // Set up date range and labels based on requested range
        switch (range) {
            case "today":
                // Set to beginning of today
                cal.set(Calendar.HOUR_OF_DAY, 0);
                cal.set(Calendar.MINUTE, 0);
                cal.set(Calendar.SECOND, 0);
                startDate = cal.getTime();
                
                // Generate hourly labels for today
                labels.add("6h");
                labels.add("9h");
                labels.add("12h");
                labels.add("15h");
                labels.add("18h");
                labels.add("21h");
                break;
                
            case "yesterday":
                // Set to beginning of yesterday
                cal.add(Calendar.DAY_OF_MONTH, -1);
                cal.set(Calendar.HOUR_OF_DAY, 0);
                cal.set(Calendar.MINUTE, 0);
                cal.set(Calendar.SECOND, 0);
                startDate = cal.getTime();
                
                // End date is end of yesterday
                cal.set(Calendar.HOUR_OF_DAY, 23);
                cal.set(Calendar.MINUTE, 59);
                cal.set(Calendar.SECOND, 59);
                endDate = cal.getTime();
                
                // Generate hourly labels for yesterday
                labels.add("6h");
                labels.add("9h");
                labels.add("12h");
                labels.add("15h");
                labels.add("18h");
                labels.add("21h");
                break;
                
            case "this-week":
                // Set to beginning of this week (assuming week starts on Monday)
                cal.set(Calendar.DAY_OF_WEEK, Calendar.MONDAY);
                cal.set(Calendar.HOUR_OF_DAY, 0);
                cal.set(Calendar.MINUTE, 0);
                cal.set(Calendar.SECOND, 0);
                startDate = cal.getTime();
                
                // Generate daily labels for this week
                String[] weekdays = {"Thứ 2", "Thứ 3", "Thứ 4", "Thứ 5", "Thứ 6", "Thứ 7", "CN"};
                for (String day : weekdays) labels.add(day);
                break;
                
            case "last-week":
                // Set to beginning of last week
                cal.add(Calendar.WEEK_OF_YEAR, -1);
                cal.set(Calendar.DAY_OF_WEEK, Calendar.MONDAY);
                cal.set(Calendar.HOUR_OF_DAY, 0);
                cal.set(Calendar.MINUTE, 0);
                cal.set(Calendar.SECOND, 0);
                startDate = cal.getTime();
                
                // End date is end of last week
                cal.add(Calendar.DAY_OF_WEEK, 6);
                cal.set(Calendar.HOUR_OF_DAY, 23);
                cal.set(Calendar.MINUTE, 59);
                cal.set(Calendar.SECOND, 59);
                endDate = cal.getTime();
                
                // Generate daily labels for last week
                String[] weekdaysLast = {"Thứ 2", "Thứ 3", "Thứ 4", "Thứ 5", "Thứ 6", "Thứ 7", "CN"};
                for (String day : weekdaysLast) labels.add(day);
                break;
                
            case "this-month":
                // Set to beginning of this month
                cal.set(Calendar.DAY_OF_MONTH, 1);
                cal.set(Calendar.HOUR_OF_DAY, 0);
                cal.set(Calendar.MINUTE, 0);
                cal.set(Calendar.SECOND, 0);
                startDate = cal.getTime();
                
                // Generate weekly labels for this month
                labels.add("Tuần 1");
                labels.add("Tuần 2");
                labels.add("Tuần 3");
                labels.add("Tuần 4");
                if (cal.getActualMaximum(Calendar.DAY_OF_MONTH) > 28) {
                    labels.add("Tuần 5");
                }
                break;
                
            case "last-month":
                // Set to beginning of last month
                cal.add(Calendar.MONTH, -1);
                cal.set(Calendar.DAY_OF_MONTH, 1);
                cal.set(Calendar.HOUR_OF_DAY, 0);
                cal.set(Calendar.MINUTE, 0);
                cal.set(Calendar.SECOND, 0);
                startDate = cal.getTime();
                
                // End date is end of last month
                cal.set(Calendar.DAY_OF_MONTH, cal.getActualMaximum(Calendar.DAY_OF_MONTH));
                cal.set(Calendar.HOUR_OF_DAY, 23);
                cal.set(Calendar.MINUTE, 59);
                cal.set(Calendar.SECOND, 59);
                endDate = cal.getTime();
                
                // Generate weekly labels for last month
                labels.add("Tuần 1");
                labels.add("Tuần 2");
                labels.add("Tuần 3");
                labels.add("Tuần 4");
                if (cal.getActualMaximum(Calendar.DAY_OF_MONTH) > 28) {
                    labels.add("Tuần 5");
                }
                break;
                
            case "this-year":
                // Set to beginning of this year
                cal.set(Calendar.DAY_OF_YEAR, 1);
                cal.set(Calendar.HOUR_OF_DAY, 0);
                cal.set(Calendar.MINUTE, 0);
                cal.set(Calendar.SECOND, 0);
                startDate = cal.getTime();
                
                // Generate monthly labels for this year
                String[] months = {"Tháng 1", "Tháng 2", "Tháng 3", "Tháng 4", "Tháng 5", "Tháng 6", "Tháng 7", "Tháng 8", "Tháng 9", "Tháng 10", "Tháng 11", "Tháng 12"};
                for (String m : months) labels.add(m);
                break;
                
            default:
                // Default to this week
                cal.set(Calendar.DAY_OF_WEEK, Calendar.MONDAY);
                cal.set(Calendar.HOUR_OF_DAY, 0);
                cal.set(Calendar.MINUTE, 0);
                cal.set(Calendar.SECOND, 0);
                startDate = cal.getTime();
                
                // Generate daily labels for this week as default
                String[] weekdaysDefault = {"Thứ 2", "Thứ 3", "Thứ 4", "Thứ 5", "Thứ 6", "Thứ 7", "CN"};
                for (String day : weekdaysDefault) labels.add(day);
                break;

        }
        
        // Get orders within the date range (lọc theo UpdatedAt thay vì CreatedAt)
        List<Order> allOrders = orderService.getOrdersByUpdatedDateRange(null, startDate, endDate); // null để lấy tất cả
        
        // Calculate revenue data based on range and orders
        List<BigDecimal> revenueData = calculateRevenueData(allOrders, startDate, endDate, range, labels.size());
        
        // Calculate order status breakdown
        int[] orderStatusCounts = calculateOrderStatusCounts(allOrders);
        
        // Build response JSON
        JsonObject result = new JsonObject();
        result.add("labels", new Gson().toJsonTree(labels));
        result.add("revenueData", new Gson().toJsonTree(revenueData));
        result.add("orderStatusData", new Gson().toJsonTree(orderStatusCounts));
        
        return result;
    }
    
    /**
     * Calculate revenue for each label period
     */
    private List<BigDecimal> calculateRevenueData(List<Order> orders, Date startDate, Date endDate, String range, int numPeriods) {
        List<BigDecimal> revenueData = new ArrayList<>();
        
        // Initialize revenue data with zeros
        for (int i = 0; i < numPeriods; i++) {
            revenueData.add(BigDecimal.ZERO);
        }
        
        // If no orders, return zeros
        if (orders == null || orders.isEmpty()) {
            return revenueData;
        }
        
        // Group orders by period and sum up revenue
        for (Order order : orders) {
            if (order.getCreatedAt() == null || order.getTotalAmount() == null) {
                continue;
            }
            
            int periodIndex = calculatePeriodIndex(order.getCreatedAt(), startDate, range, numPeriods);
            if (periodIndex >= 0 && periodIndex < numPeriods) {
                BigDecimal currentValue = revenueData.get(periodIndex);
                revenueData.set(periodIndex, currentValue.add(order.getTotalAmount()));
            }
        }
        
        return revenueData;
    }
    
    /**
     * Calculate which period index an order belongs to
     */
    private int calculatePeriodIndex(Date orderDate, Date startDate, String range, int numPeriods) {
        Calendar orderCal = Calendar.getInstance();
        orderCal.setTime(orderDate);
        
        Calendar startCal = Calendar.getInstance();
        startCal.setTime(startDate);
        
        switch (range) {
            case "today":
            case "yesterday":
                // Hourly periods
                int hour = orderCal.get(Calendar.HOUR_OF_DAY);
                if (hour < 6) return -1; // Before first period
                if (hour >= 21) return 5; // Last period
                return (hour - 6) / 3; // 6-8=0, 9-11=1, 12-14=2, 15-17=3, 18-20=4
                
            case "this-week":
            case "last-week":
                // Daily periods
                int dayDiff = orderCal.get(Calendar.DAY_OF_WEEK) - startCal.get(Calendar.DAY_OF_WEEK);
                if (dayDiff < 0) dayDiff += 7;
                return dayDiff;
                
            case "this-month":
            case "last-month":
                // Weekly periods
                int day = orderCal.get(Calendar.DAY_OF_MONTH);
                return (day - 1) / 7; // 1-7=0, 8-14=1, 15-21=2, 22-28=3, 29-31=4
                
            case "this-year":
                // Monthly periods
                return orderCal.get(Calendar.MONTH);
                
            default:
                // Default to daily for this week
                int defaultDayDiff = orderCal.get(Calendar.DAY_OF_WEEK) - startCal.get(Calendar.DAY_OF_WEEK);
                if (defaultDayDiff < 0) defaultDayDiff += 7;
                return defaultDayDiff;
        }
    }
    
    /**
     * Tính số lượng đơn hàng theo trạng thái: [Chờ xử lý, Đang giao, Hoàn thành, Hoàn trả, Đã hủy, Đã hoàn tiền]
     */
    private int[] calculateOrderStatusCounts(List<Order> orders) {
        int[] counts = new int[6]; // [Chờ xử lý, Đang giao, Hoàn thành, Hoàn trả, Đã hủy, Đã hoàn tiền]
        if (orders == null || orders.isEmpty()) {
            return counts;
        }
        for (Order order : orders) {
            if (order.getStatus() == null) continue;
            String st = order.getStatus().toLowerCase();
            switch (st) {
                case "pending":
                    counts[0]++; // Chờ xử lý
                    break;
                case "shipping":
                    counts[1]++; // Đang giao
                    break;
                case "delivered":
                case "confirmed":
                    counts[2]++; // Hoàn thành
                    break;
                case "returned":
                    counts[3]++; // Hoàn trả
                    break;
                case "cancelled":
                    counts[4]++; // Đã hủy
                    break;
                case "refunded":
                    counts[5]++; // Đã hoàn tiền
                    break;
                default:
                    break;
            }
        }
        return counts;
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Forward POST to GET for consistency
        doGet(request, response);
    }
} 


