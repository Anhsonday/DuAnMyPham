package controller.client;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import model.entity.User;
import service.impl.UserServiceImpl;
import service.interfaces.UserService;
import utils.PasswordHasher;

import java.io.File;
import java.io.IOException;
import java.util.UUID;

/**
 * Controller xử lý profile người dùng
 */
@WebServlet(name = "ProfileController", urlPatterns = {"/profile"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class ProfileController extends HttpServlet {
    
    private UserService userService;
    
    @Override
    public void init() throws ServletException {
        userService = new UserServiceImpl();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String action = request.getParameter("action");
        
        switch (action != null ? action : "view") {
            case "view":
                showProfile(request, response, currentUser);
                break;
            case "dashboard":
                showDashboard(request, response, currentUser);
                break;
            case "edit":
                showEditProfile(request, response, currentUser);
                break;
            case "change-password":
                showChangePassword(request, response);
                break;
            default:
                showProfile(request, response, currentUser);
                break;
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String action = request.getParameter("action");
        
        switch (action != null ? action : "") {
            case "update-profile":
                updateProfile(request, response, currentUser);
                break;
            case "update-avatar":
                updateAvatar(request, response, currentUser);
                break;
            case "change-password":
                changePassword(request, response, currentUser);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/profile");
                break;
        }
    }
    
    /**
     * Hiển thị trang profile
     */
    private void showProfile(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        
        try {
            // Lấy thông tin user mới nhất từ DB
            User updatedUser = userService.getUserById(user.getUserId());
            if (updatedUser != null) {
                request.getSession().setAttribute("user", updatedUser);
                request.setAttribute("user", updatedUser);
            } else {
                request.setAttribute("user", user);
            }
        } catch (Exception e) {
            System.out.println("Error getting user by ID: " + e.getMessage());
            request.setAttribute("user", user);
        }
        
        request.getRequestDispatcher("client/account/profile.jsp").forward(request, response);
    }
    
    /**
     * Hiển thị trang dashboard
     */
    private void showDashboard(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        
        try {
            // Lấy thông tin user mới nhất từ DB
            User updatedUser = userService.getUserById(user.getUserId());
            if (updatedUser != null) {
                request.getSession().setAttribute("user", updatedUser);
                request.setAttribute("user", updatedUser);
            } else {
                request.setAttribute("user", user);
            }
        } catch (Exception e) {
            System.out.println("Error getting user by ID: " + e.getMessage());
            request.setAttribute("user", user);
        }
        
        request.getRequestDispatcher("client/account/dashboard.jsp").forward(request, response);
    }
    
    /**
     * Hiển thị trang chỉnh sửa profile
     */
    private void showEditProfile(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        
        try {
            User updatedUser = userService.getUserById(user.getUserId());
            if (updatedUser != null) {
                request.setAttribute("user", updatedUser);
            } else {
                request.setAttribute("user", user);
            }
        } catch (Exception e) {
            System.out.println("Error getting user by ID: " + e.getMessage());
            request.setAttribute("user", user);
        }
        
        request.getRequestDispatcher("client/account/edit-profile.jsp").forward(request, response);
    }
    
    /**
     * Hiển thị trang đổi mật khẩu
     */
    private void showChangePassword(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Đảm bảo user luôn có trong request để JSP có thể sử dụng
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        if (currentUser != null) {
            request.setAttribute("user", currentUser);
        }
        
        request.getRequestDispatcher("client/account/change-password.jsp").forward(request, response);
    }
    
    /**
     * Cập nhật thông tin profile
     */
    private void updateProfile(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws ServletException, IOException {
        
        try {
            // Lấy thông tin từ form
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            
            // Validation
            if (fullName == null || fullName.trim().isEmpty()) {
                request.setAttribute("error", "Họ tên không được để trống");
                showEditProfile(request, response, currentUser);
                return;
            }
            
            if (email == null || email.trim().isEmpty()) {
                request.setAttribute("error", "Email không được để trống");
                showEditProfile(request, response, currentUser);
                return;
            }
            
            // Kiểm tra email đã tồn tại (trừ email hiện tại)
            User existingUser = userService.findByEmail(email.trim());
            if (existingUser != null && !existingUser.getUserId().equals(currentUser.getUserId())) {
                request.setAttribute("error", "Email đã được sử dụng bởi tài khoản khác");
                showEditProfile(request, response, currentUser);
                return;
            }
            
            // Cập nhật thông tin user
            currentUser.setFullName(fullName.trim());
            currentUser.setEmail(email.trim());
            currentUser.setPhone(phone != null ? phone.trim() : "");
            
            // Lưu vào database sử dụng Service
            userService.updateProfile(currentUser);
            
            // Cập nhật session
            request.getSession().setAttribute("user", currentUser);
            request.setAttribute("success", "Cập nhật thông tin thành công");
            showProfile(request, response, currentUser);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            showEditProfile(request, response, currentUser);
        }
    }
    
    /**
     * Cập nhật avatar
     */
    private void updateAvatar(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws ServletException, IOException {
        
        try {
            Part filePart = request.getPart("avatar");
            
            if (filePart == null || filePart.getSize() == 0) {
                System.out.println("[AvatarUpload] Không có file được gửi lên hoặc file rỗng");
                request.setAttribute("error", "Vui lòng chọn file ảnh");
                showEditProfile(request, response, currentUser);
                return;
            }
            
            String contentType = filePart.getContentType();
            System.out.println("[AvatarUpload] Content-Type: " + contentType);
            
            if (!isValidImageType(contentType)) {
                System.out.println("[AvatarUpload] Loại file không hợp lệ: " + contentType);
                request.setAttribute("error", "Chỉ chấp nhận file ảnh (JPG, PNG, GIF, WEBP)");
                showEditProfile(request, response, currentUser);
                return;
            }
            
            String originalFileName = getFileName(filePart);
            String fileExtension = getFileExtension(originalFileName);
            String newFileName = "avatar_" + currentUser.getUserId() + "_" + UUID.randomUUID().toString() + fileExtension;
            String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads" + File.separator + "avatars";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                boolean created = uploadDir.mkdirs();
                System.out.println("[AvatarUpload] Tạo thư mục uploads/avatars: " + created);
            }
            
            // Xóa avatar cũ nếu có
            if (currentUser.getAvatar() != null && !currentUser.getAvatar().isEmpty()) {
                String oldAvatarPath = uploadPath + File.separator + currentUser.getAvatar();
                File oldFile = new File(oldAvatarPath);
                if (oldFile.exists()) {
                    boolean deleted = oldFile.delete();
                    System.out.println("[AvatarUpload] Xóa avatar cũ: " + deleted);
                }
            }
            
            // Lưu file mới
            String filePath = uploadPath + File.separator + newFileName;
            filePart.write(filePath);
            
            // Cập nhật avatar trong database
            currentUser.setAvatar(newFileName);
            userService.updateProfile(currentUser);
            
            // Cập nhật session
            request.getSession().setAttribute("user", currentUser);
            request.setAttribute("success", "Cập nhật avatar thành công");
            showEditProfile(request, response, currentUser);
            
        } catch (Exception e) {
            System.out.println("[AvatarUpload] Exception: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra khi upload ảnh: " + e.getMessage());
            showEditProfile(request, response, currentUser);
        }
    }
    
    /**
     * Đổi mật khẩu
     */
    private void changePassword(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws ServletException, IOException {
        
        System.out.println("=== DEBUG: changePassword method called ===");
        
        try {
            String currentPassword = request.getParameter("currentPassword");
            String newPassword = request.getParameter("newPassword");
            String confirmPassword = request.getParameter("confirmPassword");
            
            System.out.println("Current password length: " + (currentPassword != null ? currentPassword.length() : "null"));
            System.out.println("New password length: " + (newPassword != null ? newPassword.length() : "null"));
            System.out.println("Confirm password length: " + (confirmPassword != null ? confirmPassword.length() : "null"));
            
            // Validation
            if (currentPassword == null || currentPassword.isEmpty()) {
                System.out.println("ERROR: Current password is empty");
                request.setAttribute("error", "Vui lòng nhập mật khẩu hiện tại");
                request.setAttribute("user", currentUser);
                showChangePassword(request, response);
                return;
            }
            
            if (newPassword == null || newPassword.isEmpty()) {
                System.out.println("ERROR: New password is empty");
                request.setAttribute("error", "Vui lòng nhập mật khẩu mới");
                request.setAttribute("user", currentUser);
                showChangePassword(request, response);
                return;
            }
            
            if (newPassword.length() < 6) {
                System.out.println("ERROR: New password too short: " + newPassword.length());
                request.setAttribute("error", "Mật khẩu mới phải có ít nhất 6 ký tự");
                request.setAttribute("user", currentUser);
                showChangePassword(request, response);
                return;
            }
            
            if (!newPassword.equals(confirmPassword)) {
                System.out.println("ERROR: Passwords don't match");
                request.setAttribute("error", "Xác nhận mật khẩu không khớp");
                request.setAttribute("user", currentUser);
                showChangePassword(request, response);
                return;
            }
            
            System.out.println("Validating current password...");
            // Kiểm tra mật khẩu hiện tại
            boolean passwordValid = PasswordHasher.verifyPassword(currentPassword, currentUser.getPassword());
            System.out.println("Password validation result: " + passwordValid);
            
            if (!passwordValid) {
                System.out.println("ERROR: Current password is incorrect");
                request.setAttribute("error", "Mật khẩu hiện tại không đúng");
                request.setAttribute("user", currentUser);
                showChangePassword(request, response);
                return;
            }
            
            System.out.println("Changing password using service...");
            // Sử dụng Service để đổi mật khẩu
            boolean success = userService.changePassword(currentUser.getUserId(), currentPassword, newPassword);
            System.out.println("Password change result: " + success);
            
            if (success) {
                System.out.println("Password change successful");
                // Cập nhật user object trong session
                User updatedUser = userService.getUserById(currentUser.getUserId());
                if (updatedUser != null) {
                    request.getSession().setAttribute("user", updatedUser);
                }
                request.setAttribute("success", "Đổi mật khẩu thành công");
                showProfile(request, response, updatedUser != null ? updatedUser : currentUser);
            } else {
                System.out.println("ERROR: Password change failed");
                request.setAttribute("error", "Có lỗi xảy ra khi đổi mật khẩu");
                request.setAttribute("user", currentUser);
                showChangePassword(request, response);
            }
            
        } catch (Exception e) {
            System.out.println("EXCEPTION in changePassword: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            request.setAttribute("user", currentUser);
            showChangePassword(request, response);
        }
        
        System.out.println("=== DEBUG: changePassword method completed ===");
    }
    
    /**
     * Kiểm tra loại file ảnh hợp lệ
     */
    private boolean isValidImageType(String contentType) {
        return contentType != null && (
            contentType.equals("image/jpeg") ||
            contentType.equals("image/jpg") ||
            contentType.equals("image/png") ||
            contentType.equals("image/gif") ||
            contentType.equals("image/webp")
        );
    }
    
    /**
     * Lấy tên file từ Part
     */
    private String getFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        String[] tokens = contentDisp.split(";");
        for (String token : tokens) {
            if (token.trim().startsWith("filename")) {
                return token.substring(token.indexOf("=") + 2, token.length() - 1);
            }
        }
        return "";
    }
    
    /**
     * Lấy phần mở rộng file
     */
    private String getFileExtension(String fileName) {
        if (fileName == null || fileName.isEmpty()) {
            return "";
        }
        int lastDotIndex = fileName.lastIndexOf(".");
        if (lastDotIndex == -1) {
            return "";
        }
        return fileName.substring(lastDotIndex);
    }
}
