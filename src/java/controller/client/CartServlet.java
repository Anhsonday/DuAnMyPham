// ...existing code...
/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.client;

import jakarta.servlet.RequestDispatcher;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.math.BigDecimal;
import java.util.List;
import model.entity.Cart;
import model.entity.CartItem;
import model.entity.Product;
import model.entity.User;
import service.impl.CartItemService;
import service.impl.CartService;
import service.impl.ProductServiceImpl;
import service.interfaces.ICartItemService;
import service.interfaces.ICartService;
import service.interfaces.ProductService;

/**
 *
 * @author DELL
 */
@WebServlet(name = "CartServlet", urlPatterns = {"/cart"})
public class CartServlet extends HttpServlet {
    ICartService cartService;
    ICartItemService cartItemService;
    ProductService productService;
    
    public void init(){
        cartService = new CartService();
        cartItemService = new CartItemService();
        productService = new ProductServiceImpl();
    }
    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet CartServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet CartServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("miniCart".equals(action) && "XMLHttpRequest".equals(request.getHeader("X-Requested-With"))) {
            handleMiniCart(request, response);
            return;
        }
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            user = new User();
            user.setUserId(1);
            user.setEmail("hieuvo.23102004@gmail.com");
            user.setPhone("0123456789");
            session.setAttribute("user", user);
        }
        Cart cart = getCart(session, user);
        session.setAttribute("cart", cart);
        List<CartItem> items = cartItemService.getAllByCartID_User(cart.getCartID());
        List<CartItem> selected = cartItemService.getAllByCartID_UserSelected(cart.getCartID());
        int totalQuantity = selected.stream().mapToInt(CartItem::getQuantity).sum();
        java.math.BigDecimal selectedTotal = selected.stream()
            .map(item -> {
                BigDecimal price = item.getProduct().getSalePrice() != null
                    && item.getProduct().getSalePrice().compareTo(BigDecimal.ZERO) > 0
                    && item.getProduct().getSalePrice().compareTo(item.getProduct().getPrice()) < 0
                    ? item.getProduct().getSalePrice()
                    : item.getProduct().getPrice();
                return price.multiply(BigDecimal.valueOf(item.getQuantity()));
            })
            .reduce(BigDecimal.ZERO, BigDecimal::add);
        request.setAttribute("items", items);
        request.setAttribute("totalQuantity", totalQuantity);
        request.setAttribute("total", cartService.getTotalAmount_User(cart.getCartID()));
        request.setAttribute("selectedTotal", selectedTotal);
        request.setAttribute("selectedQuantity", totalQuantity);
        RequestDispatcher dispatcher = request.getRequestDispatcher("cart/cart.jsp");
        dispatcher.forward(request, response);
    }

    private void handleMiniCart(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json");
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        int cartCount = 0;
        List<Object> itemsJson = new java.util.ArrayList<>();
        service.impl.ProductImageServiceImpl productImageService = new service.impl.ProductImageServiceImpl();
        if (user != null) {
            Cart cart = getCart(session, user);
            List<CartItem> items = cartItemService.getAllByCartID_User(cart.getCartID());
            cartCount = items.stream().mapToInt(CartItem::getQuantity).sum();
            for (CartItem ci : items) {
                Product p = ci.getProduct();
                String img = "assets/images/no-image.png";
                if (p != null) {
                    var mainImg = productImageService.findMainImageByProductId(p.getProductId());
                    if (mainImg != null && mainImg.getImageUrl() != null) {
                        img = mainImg.getImageUrl();
                    }
                }
                java.util.Map<String, Object> itemMap = new java.util.HashMap<>();
                itemMap.put("image", img);
                itemMap.put("name", p != null ? p.getProductName() : "");
                itemMap.put("price", p != null ? p.getPrice().intValue() : 0);
                itemMap.put("quantity", ci.getQuantity());
                itemsJson.add(itemMap);
            }
        }
        String json = "{" +
            "\"cartCount\":" + cartCount + "," +
            "\"items\":" + new com.google.gson.Gson().toJson(itemsJson) +
            "}";
        response.getWriter().write(json);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    
    @Override
protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    HttpSession session = request.getSession();
    User user = (User) session.getAttribute("user");
    if (user == null) {
        user = new User();
        user.setUserId(1);
        session.setAttribute("user", user);
    }
    Cart cart = getCart(session, user);

    String action = request.getParameter("action");
    if(action == null)
        action = "";

    switch(action){
        case "add" -> { createCartItem(request, response, cart); return; }
        case "update" -> { updateCartItem(request, response, cart); return; }
        case "delete" -> { deleteCartItem(request, response, cart); return; }
        default -> {
            if ("XMLHttpRequest".equals(request.getHeader("X-Requested-With"))) {
                response.setContentType("application/json");
                response.getWriter().write("{\"success\":false,\"message\":\"Yêu cầu không hợp lệ!\"}");
                return;
            }
            response.sendRedirect("cart");
        }
    }
}

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>
    
    private boolean isOwner(CartItem item, Cart cart) {
        return item != null && item.getCart() != null && item.getCart().getCartID() == cart.getCartID();
    }

    private void createCartItem(HttpServletRequest request, HttpServletResponse response, Cart cart)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            if ("XMLHttpRequest".equals(request.getHeader("X-Requested-With"))) {
                response.setContentType("application/json");
                response.getWriter().write("{\"success\":false,\"message\":\"Bạn cần đăng nhập để thêm vào giỏ hàng!\"}");
                return;
            } else {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }
        }
        int id = parseIntSafe(request.getParameter("productID"), -1);
        int quantity = parseIntSafe(request.getParameter("quantity"), 1);
        if (id < 0 || quantity <= 0) {
            handleError(request, response, "Dữ liệu sản phẩm không hợp lệ (ID: " + id + ")", "cart/productListCart.jsp");
            return;
        }
        Product p = productService.getProductById(id);
        if (p == null) {
            handleError(request, response, "Sản phẩm không tồn tại (ID: " + id + ")", "cart/productListCart.jsp");
            return;
        }
        CartItem ci = new CartItem(quantity, "pending", false, cart, p);
        System.out.println("[DEBUG][CartServlet] Thêm vào giỏ: userId=" + user.getUserId() + ", cartId=" + cart.getCartID() + ", productId=" + id + ", quantity=" + quantity);
        try {
            cartItemService.createCartItem(ci);
            logAction("Add CartItem", ci);
            Cart updatedCart = getCart(request.getSession(), user);
            request.getSession().setAttribute("cart", updatedCart);
            List<CartItem> items = cartItemService.getAllByCartID_User(updatedCart.getCartID());
            System.out.println("[DEBUG][CartServlet] Danh sách CartItem sau khi thêm:");
            for (CartItem item : items) {
                System.out.println("  - productId=" + item.getProduct().getProductId() + ", quantity=" + item.getQuantity());
            }
            int cartCount = items.stream().mapToInt(CartItem::getQuantity).sum();
            System.out.println("[DEBUG][CartServlet] Sau khi thêm: cartId=" + updatedCart.getCartID() + ", cartCount=" + cartCount);
            if ("XMLHttpRequest".equals(request.getHeader("X-Requested-With"))) {
                response.setContentType("application/json");
                response.getWriter().write("{\"success\":true,\"cartCount\":" + cartCount + "}");
                return;
            }
        } catch (Exception e) {
            if ("XMLHttpRequest".equals(request.getHeader("X-Requested-With"))) {
                response.setContentType("application/json");
                response.getWriter().write("{\"success\":false,\"message\":\"" + e.getMessage().replace("\"", "\\\"") + "\"}");
                return;
            }
            handleError(request, response, "Lỗi thêm sản phẩm ID: " + id + ": " + e.getMessage(), "cart/productListCart.jsp");
        }
    }

    private void updateCartItem(HttpServletRequest request, HttpServletResponse response, Cart cart)
            throws ServletException, IOException {
        List<CartItem> items = cartItemService.getAllByCartID_User(cart.getCartID());
        boolean hasError = false;
        StringBuilder errorMsg = new StringBuilder();
        for (CartItem item : items) {
            int cartItemID = item.getCartItemID();
            String status = "selected".equalsIgnoreCase(request.getParameter("selected_" + cartItemID)) ? "selected" : "pending";
            String quantityStr = request.getParameter("quantity_" + cartItemID);
            if (quantityStr == null) continue;

            int quantity = parseIntSafe(quantityStr, -1);
            if (quantity < 1) {
                errorMsg.append("Số lượng không hợp lệ cho sản phẩm ID: ").append(cartItemID).append(". ");
                continue;
            }

            // Kiểm tra quyền sở hữu
            if (!isOwner(item, cart)) {
                hasError = true;
                errorMsg.append("Bạn không có quyền sửa sản phẩm ID: ").append(cartItemID).append(". ");
                continue;
            }

            Product p = item.getProduct();
            CartItem ci = new CartItem(cartItemID, quantity, status, false, cart, p);
            try {
                cartItemService.updateCartItem(ci);
                logAction("Update CartItem", ci);
            } catch (Exception e) {
                hasError = true;
                errorMsg.append("Lỗi cập nhật sản phẩm ID: ").append(cartItemID)
                        .append(": ").append(e.getMessage()).append(". ");
            }
        }
        if (hasError) {
            handleError(request, response, errorMsg.toString(), "cart/cart.jsp");
            return;
        }
        // Sửa đoạn này: chỉ tính tổng cho sản phẩm được chọn, lấy giá khuyến mãi nếu có
        List<CartItem> selected = cartItemService.getAllByCartID_UserSelected(cart.getCartID());
        BigDecimal selectedTotal = selected.stream()
            .map(item -> {
                BigDecimal price = item.getProduct().getSalePrice() != null
                    && item.getProduct().getSalePrice().compareTo(BigDecimal.ZERO) > 0
                    && item.getProduct().getSalePrice().compareTo(item.getProduct().getPrice()) < 0
                    ? item.getProduct().getSalePrice()
                    : item.getProduct().getPrice();
                return price.multiply(BigDecimal.valueOf(item.getQuantity()));
            })
            .reduce(BigDecimal.ZERO, BigDecimal::add);
        int selectedQuantity = selected.stream().mapToInt(CartItem::getQuantity).sum();
        String json = String.format("{\"total\": %d, \"quantity\": %d}", selectedTotal.intValue(), selectedQuantity);
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        out.write(json);
        out.flush();
    }

    private void deleteCartItem(HttpServletRequest request, HttpServletResponse response, Cart cart)
            throws ServletException, IOException {
        int id = parseIntSafe(request.getParameter("cartItemID"), -1);
        CartItem item = cartItemService.getCartItemById(id);
        // Kiểm tra quyền sở hữu
        if (!isOwner(item, cart)) {
            handleError(request, response, "Bạn không có quyền xóa sản phẩm này (ID: " + id + ")", "cart/cart.jsp");
            return;
        }
        try {
            cartItemService.deletedCartItem(id);
            logAction("Delete CartItem", id);
        } catch (Exception e) {
            handleError(request, response, "Lỗi xóa sản phẩm ID: " + id + ": " + e.getMessage(), "cart/cart.jsp");
        }
    }

    public Cart getCart(HttpSession session, User user) {
        Cart cart = (Cart) session.getAttribute("cart");
        if (cart == null) {
            cart = cartService.getActiveCart(user.getUserId());
            if (cart == null) {
                cart = new Cart("active", user);
                cartService.createCart(cart);
            }
            session.setAttribute("cart", cart);
        }
        return cart;
    }

    // --- Utility methods ---
    // Validate and parse integer safely
    private int parseIntSafe(String value, int defaultValue) {
        try {
            return Integer.parseInt(value);
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }

    // Handle error forwarding
    private void handleError(HttpServletRequest request, HttpServletResponse response, String msg, String page)
        throws ServletException, IOException {
    String requestedWith = request.getHeader("X-Requested-With");

        if ("XMLHttpRequest".equalsIgnoreCase(requestedWith)) {
            // AJAX request → trả JSON lỗi
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");

            // Escape JSON an toàn bằng cách thay \ và " (nếu dùng String thuần)
            String safeMsg = msg.replace("\\", "\\\\").replace("\"", "\\\"");

            try (PrintWriter out = response.getWriter()) {
                out.write("{\"error\": \"" + safeMsg + "\"}");
            }
        } else {
            // Request thường → forward về trang JSP
            request.setAttribute("errorMsg", msg);
            RequestDispatcher dispatcher = request.getRequestDispatcher(page);
            dispatcher.forward(request, response);
        }
    }

    // Simple log util (replace with logger in real project)
    private void logAction(String action, Object detail) {
        System.out.println("[CartServlet] " + action + ": " + detail);
    }
}


