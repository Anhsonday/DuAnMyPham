package controller.client;

import service.impl.UserServiceImpl;
import service.interfaces.UserService;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.entity.User;
import utils.SessionUtils;
import java.util.Base64;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

/**
 * Servlet xử lý đăng nhập
 */
@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {
    
    private final UserService userService = new UserServiceImpl();

    /**
     * Xử lý GET request - hiển thị trang đăng nhập
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Kiểm tra remember me cookies và set vào request attributes
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            String rememberedUsername = null;
            String rememberedPassword = null;
            
            for (Cookie cookie : cookies) {
                if ("remembered_username".equals(cookie.getName())) {
                    rememberedUsername = java.net.URLDecoder.decode(cookie.getValue(), StandardCharsets.UTF_8);
                } else if ("remembered_password".equals(cookie.getName())) {
                    try {
                        // Decode the password from Base64
                        rememberedPassword = new String(Base64.getDecoder().decode(cookie.getValue()));
                    } catch (Exception e) {
                        // Ignore invalid encoding
                    }
                }
            }
            
            // Set remembered values để hiển thị trong form
            if (rememberedUsername != null) {
                request.setAttribute("rememberedUsername", rememberedUsername);
                request.setAttribute("isRemembered", true);
                System.out.println("Found remembered username: " + rememberedUsername);
            }
            if (rememberedPassword != null) {
                request.setAttribute("rememberedPassword", rememberedPassword);
                System.out.println("Found remembered password");
            }
        }
        
        // Chuyển hướng đến trang đăng nhập
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }

    /**
     * Xử lý POST request - xử lý thông tin đăng nhập
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Set encoding để hỗ trợ tiếng Việt
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        // Lấy thông tin từ form
        String username = request.getParameter("user");
        String password = request.getParameter("pass");
        String remember = request.getParameter("remember");
        
        System.out.println("Login attempt - Username: " + username + ", Remember: " + remember);
        
        try {
            // Kiểm tra đăng nhập sử dụng UserService
            User user = userService.login(username, password);
            
            if (user != null) {
                // Đăng nhập thành công
                HttpSession session = request.getSession();
                session.setAttribute("user", user);
                
                System.out.println("Login successful for user: " + user.getUsername());
                
                // Xử lý Remember Me
                if ("1".equals(remember)) {
                    // URL encode username để tránh ký tự không hợp lệ
                    String encodedUsername = URLEncoder.encode(user.getUsername(), StandardCharsets.UTF_8);
                    Cookie usernameCookie = new Cookie("remembered_username", encodedUsername);
                    
                    // Encode password với Base64 để bảo mật cơ bản
                    String encodedPassword = Base64.getEncoder().encodeToString(password.getBytes());
                    Cookie passwordCookie = new Cookie("remembered_password", encodedPassword);
                    
                    // Set thời gian sống 30 ngày
                    int maxAge = 30 * 24 * 60 * 60; // 30 days in seconds
                    usernameCookie.setMaxAge(maxAge);
                    passwordCookie.setMaxAge(maxAge);
                    
                    // Set path
                    usernameCookie.setPath("/");
                    passwordCookie.setPath("/");
                    
                    // Set HttpOnly để tránh XSS
                    usernameCookie.setHttpOnly(true);
                    passwordCookie.setHttpOnly(true);
                    
                    response.addCookie(usernameCookie);
                    response.addCookie(passwordCookie);
                    
                    System.out.println("Remember me cookies set for user: " + user.getUsername());
                } else {
                    // Xóa cookies nếu không chọn remember
                    clearRememberMeCookies(response);
                }
                
                // Chuyển hướng theo role
                if ("admin".equals(user.getRole())) {
                    response.sendRedirect("admin-dashboard");
                } else {
                    response.sendRedirect("home");
                }
            } else {
                // Đăng nhập thất bại
                System.out.println("Login failed for username: " + username);
                
                request.setAttribute("error", "Tên đăng nhập hoặc mật khẩu không đúng!");
                
                // Giữ lại thông tin đã nhập để user không phải nhập lại
                request.setAttribute("enteredUsername", username);
                if ("1".equals(remember)) {
                    request.setAttribute("isRemembered", true);
                }
                
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            System.out.println("Error during login: " + e.getMessage());
            e.printStackTrace();
            
            request.setAttribute("error", "Có lỗi xảy ra trong quá trình đăng nhập. Vui lòng thử lại!");
            request.setAttribute("enteredUsername", username);
            if ("1".equals(remember)) {
                request.setAttribute("isRemembered", true);
            }
            
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
    
    /**
     * Xóa remember me cookies
     */
    private void clearRememberMeCookies(HttpServletResponse response) {
        Cookie usernameCookie = new Cookie("remembered_username", "");
        Cookie passwordCookie = new Cookie("remembered_password", "");
        
        usernameCookie.setMaxAge(0);
        passwordCookie.setMaxAge(0);
        usernameCookie.setPath("/");
        passwordCookie.setPath("/");
        
        response.addCookie(usernameCookie);
        response.addCookie(passwordCookie);
    }
}