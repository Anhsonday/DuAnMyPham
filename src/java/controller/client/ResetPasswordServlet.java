package controller.client;

import service.impl.UserServiceImpl;
import service.interfaces.UserService;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.entity.User;
import utils.EmailUtil;

/**
 * Servlet xử lý reset mật khẩu
 */
@WebServlet(name = "ResetPasswordServlet", urlPatterns = {"/reset-password"})
public class ResetPasswordServlet extends HttpServlet {
    
    private final UserService userService = new UserServiceImpl();

    /**
     * Xử lý GET request - hiển thị trang reset mật khẩu
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Chuyển hướng đến trang reset mật khẩu
        request.getRequestDispatcher("reset-password.jsp").forward(request, response);
    }

    /**
     * Xử lý POST request - xử lý reset mật khẩu
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Set encoding để hỗ trợ tiếng Việt
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        // Lấy thông tin từ form
        String email = request.getParameter("email");
        String resetCode = request.getParameter("resetCode");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        
        System.out.println("Reset password attempt for email: " + email);
        
        try {
            // Validation
            StringBuilder errors = new StringBuilder();
            
            if (email == null || email.trim().isEmpty()) {
                errors.append("Vui lòng nhập địa chỉ email. ");
            }
            
            if (resetCode == null || resetCode.trim().isEmpty()) {
                errors.append("Vui lòng nhập mã xác thực. ");
            } else if (resetCode.trim().length() != 6) {
                errors.append("Mã xác thực phải có 6 chữ số. ");
            }
            
            if (newPassword == null || newPassword.trim().isEmpty()) {
                errors.append("Vui lòng nhập mật khẩu mới. ");
            } else if (newPassword.length() < 6) {
                errors.append("Mật khẩu mới phải có ít nhất 6 ký tự. ");
            }
            
            if (confirmPassword == null || !newPassword.equals(confirmPassword)) {
                errors.append("Xác nhận mật khẩu không khớp. ");
            }
            
            // Nếu có lỗi validation
            if (errors.length() > 0) {
                request.setAttribute("error", errors.toString());
                request.setAttribute("enteredEmail", email);
                request.setAttribute("enteredResetCode", resetCode);
                request.getRequestDispatcher("reset-password.jsp").forward(request, response);
                return;
            }
            
            // Tìm user theo reset token
            User user = userService.findByResetToken(resetCode.trim());
            
            if (user != null && email.trim().equalsIgnoreCase(user.getEmail())) {
                // Token hợp lệ và email khớp, reset mật khẩu
                try {
                    userService.updatePassword(user.getUserId(), newPassword);
                    
                    System.out.println("Password reset successful for: " + email);
                    
                    // Gửi email thông báo
                    try {
                        EmailUtil.sendPasswordChangedNotification(email, user.getFullName());
                    } catch (Exception e) {
                        System.out.println("Failed to send email notification: " + e.getMessage());
                        // Không fail toàn bộ process nếu gửi email thất bại
                    }
                    
                    // Xóa thông tin trong session
                    HttpSession session = request.getSession();
                    session.removeAttribute("resetEmail");
                    session.removeAttribute("successMessage");
                    
                    // Redirect về trang login với thông báo thành công
                    request.setAttribute("success", 
                        "Mật khẩu đã được đặt lại thành công! Vui lòng đăng nhập với mật khẩu mới.");
                    request.getRequestDispatcher("login.jsp").forward(request, response);
                    
                } catch (Exception e) {
                    System.out.println("Failed to reset password for: " + email + " - " + e.getMessage());
                    e.printStackTrace();
                    request.setAttribute("error", "Có lỗi xảy ra khi đặt lại mật khẩu. Vui lòng thử lại!");
                    request.setAttribute("enteredEmail", email);
                    request.setAttribute("enteredResetCode", resetCode);
                    request.getRequestDispatcher("reset-password.jsp").forward(request, response);
                }
                
            } else {
                // Token không hợp lệ hoặc email không khớp
                System.out.println("Invalid token or email mismatch for email: " + email);
                request.setAttribute("error", "Mã xác thực không đúng hoặc đã hết hạn. Vui lòng yêu cầu mã mới!");
                request.setAttribute("enteredEmail", email);
                request.setAttribute("enteredResetCode", resetCode);
                request.getRequestDispatcher("reset-password.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            System.out.println("Error during password reset: " + e.getMessage());
            e.printStackTrace();
            
            request.setAttribute("error", "Có lỗi xảy ra trong quá trình đặt lại mật khẩu: " + e.getMessage());
            request.setAttribute("enteredEmail", email);
            request.setAttribute("enteredResetCode", resetCode);
            request.getRequestDispatcher("reset-password.jsp").forward(request, response);
        }
    }
} 