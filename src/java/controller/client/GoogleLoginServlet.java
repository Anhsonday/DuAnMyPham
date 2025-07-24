package controller.client;

import service.impl.UserServiceImpl;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.entity.User;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import utils.OAuthConfig;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.UUID;
import java.io.InputStream;
import java.io.File;

@WebServlet(urlPatterns = {"/auth/google", "/auth/google/callback", "/googlecallback"})
public class GoogleLoginServlet extends HttpServlet {
    
    // Google OAuth URLs
    private static final String GOOGLE_TOKEN_URL = "https://oauth2.googleapis.com/token";
    private final UserServiceImpl userService = new UserServiceImpl();

    /**
     * Xử lý GET request - chuyển hướng đến Google OAuth hoặc xử lý callback
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        System.out.println("=== GoogleLoginServlet doGet called ===");
        System.out.println("Request URI: " + request.getRequestURI());
        System.out.println("Servlet Path: " + request.getServletPath());
        System.out.println("Context Path: " + request.getContextPath());
        
        String path = request.getServletPath();
        if ("/auth/google".equals(path)) {
            System.out.println("Redirecting to Google OAuth...");
            // Chuyển hướng đến Google OAuth
            redirectToGoogle(request, response);
        } else if ("/auth/google/callback".equals(path) || "/googlecallback".equals(path)) {
            System.out.println("Handling Google callback...");
            // Xử lý callback từ Google
            handleGoogleCallback(request, response);
        } else {
            System.out.println("Unknown path: " + path);
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
    
    /**
     * Chuyển hướng người dùng đến Google OAuth
     */
    private void redirectToGoogle(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        String googleAuthURL = OAuthConfig.GOOGLE_AUTH_URL
                + "?response_type=code"
                + "&client_id=" + OAuthConfig.getGoogleClientId()
                + "&redirect_uri=" + OAuthConfig.getGoogleRedirectUri()
                + "&scope=email%20profile"
                + "&access_type=offline"
                + "&prompt=consent";
        
        System.out.println("Redirecting to Google OAuth: " + googleAuthURL);
        response.sendRedirect(googleAuthURL);
    }
    
    /**
     * Xử lý callback từ Google OAuth
     */
    private void handleGoogleCallback(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String code = request.getParameter("code");
        String error = request.getParameter("error");
        
        if (error != null) {
            System.out.println("Google OAuth error: " + error);
            request.setAttribute("error", "Đăng nhập Google bị hủy hoặc có lỗi xảy ra!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }
        
        if (code == null) {
            System.out.println("No authorization code received from Google");
            request.setAttribute("error", "Không nhận được mã xác thực từ Google!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }
        
        try {
            // Lấy access token từ Google
            String accessToken = getAccessToken(code);
            
            if (accessToken != null) {
                // Lấy thông tin user từ Google
                JsonObject userInfo = getUserInfo(accessToken);
                
                if (userInfo != null) {
                    // Xử lý đăng nhập/đăng ký user
                    handleGoogleUser(userInfo, request, response);
                } else {
                    throw new Exception("Không thể lấy thông tin người dùng từ Google");
                }
            } else {
                throw new Exception("Không thể lấy access token từ Google");
            }
            
        } catch (Exception e) {
            System.out.println("Google login error: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Lỗi trong quá trình đăng nhập Google: " + e.getMessage());
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
    
    /**
     * Lấy access token từ Google bằng authorization code
     */
    private String getAccessToken(String code) throws Exception {
        String tokenRequestBody = "code=" + URLEncoder.encode(code, StandardCharsets.UTF_8)
                + "&client_id=" + URLEncoder.encode(OAuthConfig.getGoogleClientId(), StandardCharsets.UTF_8)
                + "&client_secret=" + URLEncoder.encode(OAuthConfig.getGoogleClientSecret(), StandardCharsets.UTF_8)
                + "&redirect_uri=" + URLEncoder.encode(OAuthConfig.getGoogleRedirectUri(), StandardCharsets.UTF_8)
                + "&grant_type=" + URLEncoder.encode(OAuthConfig.getGoogleGrantType(), StandardCharsets.UTF_8);
        
        URL url = new URL(GOOGLE_TOKEN_URL);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
        conn.setDoOutput(true);
        
        // Gửi request
        conn.getOutputStream().write(tokenRequestBody.getBytes(StandardCharsets.UTF_8));
        
        // Đọc response
        BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8));
        StringBuilder response = new StringBuilder();
        String line;
        while ((line = reader.readLine()) != null) {
            response.append(line);
        }
        reader.close();
        
        JsonParser parser = new JsonParser();
        JsonObject tokenResponse = parser.parse(response.toString()).getAsJsonObject();
        
        return tokenResponse.has("access_token") ? tokenResponse.get("access_token").getAsString() : null;
    }
    
    /**
     * Lấy thông tin user từ Google bằng access token
     */
    private JsonObject getUserInfo(String accessToken) throws Exception {
        URL url = new URL(OAuthConfig.GOOGLE_USER_INFO_URL + "?access_token=" + URLEncoder.encode(accessToken, StandardCharsets.UTF_8));
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");
        
        BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8));
        StringBuilder response = new StringBuilder();
        String line;
        while ((line = reader.readLine()) != null) {
            response.append(line);
        }
        reader.close();
        
        JsonParser parser = new JsonParser();
        JsonObject userInfo = parser.parse(response.toString()).getAsJsonObject();
        
        return userInfo;
    }
    
    /**
     * Xử lý thông tin user từ Google - tạo mới hoặc đăng nhập
     */
    private void handleGoogleUser(JsonObject userInfo, HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String googleId = userInfo.get("id").getAsString();
        String email = userInfo.get("email").getAsString();
        String name = userInfo.get("name").getAsString();
        String picture = userInfo.has("picture") ? userInfo.get("picture").getAsString() : null;
        String avatarFileName = null;
        // Nếu có avatar Google, tải về server
        if (picture != null && !picture.isEmpty()) {
            try {
                String ext = picture.contains(".png") ? ".png" : ".jpg";
                String fileName = "google_" + UUID.randomUUID() + ext;
                String uploadDir = request.getServletContext().getRealPath("/uploads/avatars");
                File dir = new File(uploadDir);
                if (!dir.exists()) dir.mkdirs();
                InputStream in = new URL(picture).openStream();
                Files.copy(in, Paths.get(uploadDir, fileName), StandardCopyOption.REPLACE_EXISTING);
                avatarFileName = fileName;
            } catch (Exception ex) {
                System.out.println("[GoogleLogin] Lỗi tải avatar Google: " + ex.getMessage());
                avatarFileName = null;
            }
        }
        System.out.println("Google user info - ID: " + googleId + ", Email: " + email + ", Name: " + name);
        System.out.println("Google avatar local file: " + avatarFileName);
        try {
            // Sử dụng UserService để xử lý Google login, truyền avatarFileName (nếu có) thay vì URL
            User user = userService.loginWithGoogle(googleId, email, name, avatarFileName);
            if (user != null) {
                // Đăng nhập user thành công
                loginUser(user, request, response);
            } else {
                throw new ServletException("Không thể xử lý đăng nhập Google");
            }
        } catch (Exception e) {
            System.out.println("Error during Google user handling: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Lỗi trong quá trình xử lý thông tin người dùng Google: " + e.getMessage());
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
    
    /**
     * Đăng nhập user vào session
     */
    private void loginUser(User user, HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        
        try {
            // Cập nhật lastLogin
            userService.updateLastLogin(user.getUserId());
            
            // Lấy lại user từ database để đảm bảo có thông tin mới nhất
            User refreshedUser = userService.getUserById(user.getUserId());
            if (refreshedUser != null) {
                user = refreshedUser;
            }
            
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            
            System.out.println("Google login successful for user: " + user.getUsername());
            System.out.println("User avatar in session: " + user.getAvatar());
            
            // Chuyển hướng theo role
            if ("admin".equals(user.getRole())) {
                response.sendRedirect("admin-dashboard");
            } else {
                response.sendRedirect("home");
            }
            
        } catch (Exception e) {
            System.out.println("Error during user login: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("login.jsp?error=login_failed");
        }
    }
}
