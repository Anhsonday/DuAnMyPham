package controller.client;

import service.impl.UserServiceImpl;
import service.interfaces.UserService;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.entity.User;

/**
 * Servlet xử lý đăng ký người dùng
 */
@WebServlet(name = "RegisterServlet", urlPatterns = {"/register"})
public class RegisterServlet extends HttpServlet {
    
    private final UserService userService = new UserServiceImpl();

    /**
     * Xử lý GET request - hiển thị trang đăng ký
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Chuyển hướng đến trang đăng ký
        request.getRequestDispatcher("register.jsp").forward(request, response);
    }

    /**
     * Xử lý POST request - xử lý thông tin đăng ký
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Set encoding để hỗ trợ tiếng Việt
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        // Lấy thông tin từ form
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String fullname = request.getParameter("fullname");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirm_password");
        String agreeTerms = request.getParameter("agree_terms");
        
        System.out.println("Registration attempt - Username: " + username + ", Email: " + email);
        
        try {
            // Validation
            StringBuilder errors = new StringBuilder();
            
            // Kiểm tra các trường bắt buộc
            if (username == null || username.trim().isEmpty()) {
                errors.append("Tên đăng nhập không được để trống. ");
            } else if (username.length() < 3) {
                errors.append("Tên đăng nhập phải có ít nhất 3 ký tự. ");
            }
            
            if (email == null || email.trim().isEmpty()) {
                errors.append("Email không được để trống. ");
            } else if (!isValidEmail(email)) {
                errors.append("Email không hợp lệ. ");
            }
            
            if (fullname == null || fullname.trim().isEmpty()) {
                errors.append("Họ tên không được để trống. ");
            }
            
            if (password == null || password.trim().isEmpty()) {
                errors.append("Mật khẩu không được để trống. ");
            } else if (password.length() < 6) {
                errors.append("Mật khẩu phải có ít nhất 6 ký tự. ");
            }
            
            if (confirmPassword == null || !password.equals(confirmPassword)) {
                errors.append("Xác nhận mật khẩu không khớp. ");
            }
            
            if (agreeTerms == null) {
                errors.append("Bạn phải đồng ý với điều khoản dịch vụ. ");
            }
            
            // Kiểm tra username và email đã tồn tại
            if (errors.length() == 0) {
                if (userService.isUsernameExists(username)) {
                    errors.append("Tên đăng nhập đã tồn tại. ");
                }
                
                if (userService.isEmailExists(email)) {
                    errors.append("Email đã được sử dụng. ");
                }
            }
            
            // Nếu có lỗi, quay lại trang đăng ký
            if (errors.length() > 0) {
                request.setAttribute("error", errors.toString());
                // Giữ lại thông tin đã nhập để user không phải nhập lại
                request.setAttribute("enteredUsername", username);
                request.setAttribute("enteredEmail", email);
                request.setAttribute("enteredFullname", fullname);
                request.setAttribute("enteredPhone", phone);
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }
            
            // Tạo user mới
            User newUser = new User();
            newUser.setUsername(username.trim());
            newUser.setEmail(email.trim());
            newUser.setFullName(fullname.trim());
            newUser.setPhone(phone != null ? phone.trim() : "");
            newUser.setPassword(password);
            newUser.setRole("customer");
            newUser.setStatus("active");
            
            // Đăng ký user sử dụng Service
            User registeredUser = userService.register(newUser);
            
            if (registeredUser != null) {
                System.out.println("User registration successful: " + username);
                // Đăng ký thành công, chuyển về trang đăng nhập với thông báo
                request.setAttribute("success", "Đăng ký thành công! Vui lòng đăng nhập.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            } else {
                System.out.println("User registration failed: " + username);
                request.setAttribute("error", "Đăng ký thất bại! Vui lòng thử lại.");
                // Giữ lại thông tin đã nhập
                request.setAttribute("enteredUsername", username);
                request.setAttribute("enteredEmail", email);
                request.setAttribute("enteredFullname", fullname);
                request.setAttribute("enteredPhone", phone);
                request.getRequestDispatcher("register.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            System.out.println("Error during registration: " + e.getMessage());
            e.printStackTrace();
            
            request.setAttribute("error", "Có lỗi xảy ra trong quá trình đăng ký: " + e.getMessage());
            // Giữ lại thông tin đã nhập
            request.setAttribute("enteredUsername", username);
            request.setAttribute("enteredEmail", email);
            request.setAttribute("enteredFullname", fullname);
            request.setAttribute("enteredPhone", phone);
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }
    
    /**
     * Kiểm tra email hợp lệ
     */
    private boolean isValidEmail(String email) {
        return email != null && email.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$");
    }
} 