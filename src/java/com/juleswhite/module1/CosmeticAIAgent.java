package com.juleswhite.module1;

import java.util.*;
import java.util.stream.Collectors;
import java.math.BigDecimal;
import java.util.regex.Pattern;
import java.util.regex.Matcher;
import service.impl.ProductServiceImpl;
import service.impl.CartService;
import service.impl.CartItemService;
import service.interfaces.ProductService;
import model.entity.Product;
import model.entity.Cart;
import model.entity.CartItem;
import com.juleswhite.module1.QRBankUtil;
import service.impl.AddressService;
import service.impl.OrderServiceImpl;
import service.impl.OrderItemService;
import service.interfaces.IAddressService;
import service.interfaces.OrderService;
import service.interfaces.IOrderItemService;
import model.entity.Address;
import model.entity.Order;
import model.entity.OrderItem;

public class CosmeticAIAgent {
    private final LLM llm = new LLM();
    private final ProductService productService = new ProductServiceImpl();
    private final CartService cartService = new CartService();
    private final CartItemService cartItemService = new CartItemService();
    private final List<Product> availableProducts = productService.getActiveProducts();
    private final String sessionId = "SESSION_" + System.currentTimeMillis();
    private final List<Message> conversationHistory = new ArrayList<>();
    
    // Context variables
    private Product lastSelectedProduct = null;
    private List<Product> lastListedProducts = new ArrayList<>();
    private Integer userId = null; // Thêm userId để check giỏ hàng
    private String pendingCODInfo = null; // Lưu trạng thái chờ nhập thông tin COD

    // Bổ sung service cho nghiệp vụ mới
    private final IAddressService addressService = new AddressService();
    private final OrderService orderService = new OrderServiceImpl();
    private final IOrderItemService orderItemService = new OrderItemService();

    public CosmeticAIAgent() {
        initializeSystem();
    }
    
    // Constructor với userId
    public CosmeticAIAgent(Integer userId) {
        this.userId = userId;
        initializeSystem();
    }
    
    // Setter cho userId
    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    private void initializeSystem() {
        StringBuilder prompt = new StringBuilder("Bạn là AI Agent tư vấn mỹ phẩm. Các sản phẩm có:\n");
        availableProducts.forEach(p -> prompt.append("- ").append(formatProduct(p)).append("\n"));
        prompt.append("\nHãy tư vấn thân thiện, chuyên nghiệp bằng tiếng Việt.");
        conversationHistory.add(new Message("system", prompt.toString()));
    }

    // **1. LOGIC GIÁ - Ưu tiên SalePrice**
    private BigDecimal getEffectivePrice(Product p) {
        return (p.getSalePrice() != null && p.getSalePrice().compareTo(BigDecimal.ZERO) > 0) 
            ? p.getSalePrice() : p.getPrice();
    }

    private String formatProduct(Product p) {
        BigDecimal price = getEffectivePrice(p);
        String priceStr = String.format("%,.0f", price.doubleValue());
        boolean hasDiscount = p.getSalePrice() != null && p.getSalePrice().compareTo(p.getPrice()) < 0;
        
        if (hasDiscount) {
            return String.format("%s - %s (Giá KM: %s VNĐ, Gốc: %,.0f VNĐ)", 
                p.getProductName(), p.getShortDescription(), priceStr, p.getPrice().doubleValue());
        }
        return String.format("%s - %s (Giá: %s VNĐ)", 
            p.getProductName(), p.getShortDescription(), priceStr);
    }

    private Integer getCategoryID(Product p) {
        return (p.getCategoryId() != null) ? p.getCategoryId().getCategoryId() : null;
    }

    // **2. EXTRACT PRODUCTS từ AI response**
    private void extractProductsFromResponse(String aiResponse) {
        lastListedProducts.clear();
        
        // Tìm pattern "1. Tên sản phẩm", "2. Tên sản phẩm"
        Pattern pattern = Pattern.compile("(\\d+)\\. (.+?)(?=\\n|$)", Pattern.MULTILINE);
        Matcher matcher = pattern.matcher(aiResponse);
        
        while (matcher.find()) {
            String productText = matcher.group(2);
            
            // Tìm sản phẩm match với text
            Product found = availableProducts.stream()
                .filter(p -> productText.toLowerCase().contains(p.getProductName().toLowerCase()))
                .findFirst()
                .orElse(null);
                
            if (found != null) {
                lastListedProducts.add(found);
            }
        }
        
        System.out.println("DEBUG - Extracted " + lastListedProducts.size() + " products from AI response");
    }

    // **3. LOGIC SELECTION - Khi user chọn số**
    private void handleSelection(String input) {
        if (input.matches("^\\d+$") && !lastListedProducts.isEmpty()) {
            int idx = Integer.parseInt(input);
            if (idx > 0 && idx <= lastListedProducts.size()) {
                lastSelectedProduct = lastListedProducts.get(idx - 1);
                System.out.println("DEBUG - Selected: " + lastSelectedProduct.getProductName() + 
                    " - Price: " + getEffectivePrice(lastSelectedProduct));
            }
        }
    }

    // **4. LOGIC CHECK GIỎ HÀNG - Chi tiết sản phẩm và tổng tiền**
    private String getCartSummary() {
        if (userId == null) {
            return "Bạn cần đăng nhập để xem giỏ hàng.";
        }
        
        try {
            Cart cart = cartService.getActiveCart(userId);
            if (cart == null) {
                return "Giỏ hàng của bạn đang trống.";
            }
            
            List<CartItem> cartItems = cartItemService.getAllByCartID_Admin(cart.getCartID());
            if (cartItems == null || cartItems.isEmpty()) {
                return "Giỏ hàng của bạn đang trống.";
            }
            
            // Debug: Kiểm tra số lượng items và thông tin
            System.out.println("DEBUG - Cart ID: " + cart.getCartID());
            System.out.println("DEBUG - Cart items count: " + cartItems.size());
            for (CartItem item : cartItems) {
                System.out.println("DEBUG - Item: " + item.getProduct().getProductName() + 
                    ", Qty: " + item.getQuantity() + 
                    ", Price: " + item.getProduct().getPrice() + 
                    ", SalePrice: " + item.getProduct().getSalePrice() +
                    ", EffectivePrice: " + getEffectivePrice(item.getProduct()) +
                    ", Status: " + item.getStatus() +
                    ", IsDeleted: " + item.isIsDeleted());
            }
            
            // Lọc ra những items không bị xóa và có status phù hợp
            cartItems = cartItems.stream()
                .filter(item -> !item.isIsDeleted() && !"checkout".equalsIgnoreCase(item.getStatus()))
                .collect(Collectors.toList());
            
            System.out.println("DEBUG - After filtering, items count: " + cartItems.size());
            
            StringBuilder summary = new StringBuilder();
            summary.append("🛒 <b>Giỏ hàng của bạn:</b><br><br>");
            
            BigDecimal totalAmount = BigDecimal.ZERO;
            int totalItems = 0;
            
            for (int i = 0; i < cartItems.size(); i++) {
                CartItem item = cartItems.get(i);
                Product product = item.getProduct();
                BigDecimal effectivePrice = getEffectivePrice(product);
                BigDecimal itemTotal = effectivePrice.multiply(BigDecimal.valueOf(item.getQuantity()));
                
                summary.append(String.format("%d. <b>%s</b><br>", i + 1, product.getProductName()));
                summary.append(String.format("   Số lượng: %d<br>", item.getQuantity()));
                
                if (product.getSalePrice() != null && product.getSalePrice().compareTo(product.getPrice()) < 0) {
                    summary.append(String.format("   Giá: %,.0f VNĐ (KM từ %,.0f VNĐ)<br>", 
                        effectivePrice.doubleValue(), product.getPrice().doubleValue()));
                } else {
                    summary.append(String.format("   Giá: %,.0f VNĐ<br>", effectivePrice.doubleValue()));
                }
                
                summary.append(String.format("   Thành tiền: %,.0f VNĐ<br><br>", itemTotal.doubleValue()));
                
                totalAmount = totalAmount.add(itemTotal);
                totalItems += item.getQuantity();
            }
            
            summary.append(String.format("📊 <b>Tổng cộng:</b> %d sản phẩm<br>", totalItems));
            summary.append(String.format("💰 <b>Tổng tiền:</b> %,.0f VNĐ<br><br>", totalAmount.doubleValue()));
            summary.append("Bạn có muốn thanh toán không? (Chọn 'thanh toán khi nhận hàng' hoặc 'chuyển khoản VietQR')");
            
            return summary.toString();
            
        } catch (Exception e) {
            System.err.println("Error getting cart summary: " + e.getMessage());
            return "Có lỗi khi kiểm tra giỏ hàng. Vui lòng thử lại.";
        }
    }

    // **5. LOGIC THANH TOÁN KHI NHẬN HÀNG (COD) - LINH HOẠT**
    private String processCODCheckout(String userInput) {
        if (userId == null) {
            return "Bạn cần đăng nhập để thanh toán.";
        }
        if (pendingCODInfo == null) {
            pendingCODInfo = "waiting";
            return "Vui lòng cung cấp thông tin nhận hàng theo format:\n" +
                   "Tên: [Tên người nhận]\n" +
                   "Địa chỉ: [Địa chỉ giao hàng]\n" +
                   "SĐT: [Số điện thoại]";
        } else if ("waiting".equals(pendingCODInfo)) {
            pendingCODInfo = null;
            try {
                // Nếu có lastSelectedProduct thì tạo đơn hàng nhanh cho sản phẩm này
                if (lastSelectedProduct != null) {
                    Product product = lastSelectedProduct;
                    BigDecimal price = getEffectivePrice(product);
                    StringBuilder confirmation = new StringBuilder();
                    confirmation.append("✅ <b>Đơn hàng COD đã được xác nhận!</b><br><br>");
                    confirmation.append("📋 <b>Thông tin nhận hàng:</b><br>");
                    confirmation.append(userInput + "<br><br>");
                    confirmation.append("🛒 <b>Chi tiết đơn hàng:</b><br>");
                    confirmation.append(String.format("1. %s x1 - %,.0f VNĐ<br>", product.getProductName(), price.doubleValue()));
                    confirmation.append(String.format("<br>💰 <b>Tổng tiền cần thanh toán:</b> %,.0f VNĐ<br><br>", price.doubleValue()));
                    confirmation.append("🚚 Đơn hàng sẽ được giao tận nơi trong 2-3 ngày làm việc.<br>");
                    confirmation.append("💵 Vui lòng chuẩn bị tiền mặt để thanh toán khi nhận hàng.<br>");
                    confirmation.append("📞 Nhân viên sẽ liên hệ trước khi giao hàng.<br><br>");
                    confirmation.append("Cảm ơn bạn đã mua hàng! 🎉");
                    return confirmation.toString();
                }
                // Nếu không có sản phẩm vừa chọn thì kiểm tra giỏ hàng
                Cart cart = cartService.getActiveCart(userId);
                if (cart == null) {
                    return "Không tìm thấy giỏ hàng hoặc bạn chưa chọn sản phẩm nào.";
                }
                List<CartItem> cartItems = cartItemService.getAllByCartID_Admin(cart.getCartID());
                cartItems = cartItems.stream()
                    .filter(item -> !item.isIsDeleted() && !"checkout".equalsIgnoreCase(item.getStatus()))
                    .collect(Collectors.toList());
                if (cartItems.isEmpty()) {
                    return "Không tìm thấy giỏ hàng hoặc bạn chưa chọn sản phẩm nào.";
                }
                BigDecimal totalAmount = BigDecimal.ZERO;
                for (CartItem item : cartItems) {
                    BigDecimal effectivePrice = getEffectivePrice(item.getProduct());
                    BigDecimal itemTotal = effectivePrice.multiply(BigDecimal.valueOf(item.getQuantity()));
                    totalAmount = totalAmount.add(itemTotal);
                }
                StringBuilder confirmation = new StringBuilder();
                confirmation.append("✅ <b>Đơn hàng COD đã được xác nhận!</b><br><br>");
                confirmation.append("📋 <b>Thông tin nhận hàng:</b><br>");
                confirmation.append(userInput + "<br><br>");
                confirmation.append("🛒 <b>Chi tiết đơn hàng:</b><br>");
                for (int i = 0; i < cartItems.size(); i++) {
                    CartItem item = cartItems.get(i);
                    Product product = item.getProduct();
                    BigDecimal effectivePrice = getEffectivePrice(product);
                    BigDecimal itemTotal = effectivePrice.multiply(BigDecimal.valueOf(item.getQuantity()));
                    confirmation.append(String.format("%d. %s x%d - %,.0f VNĐ<br>", i + 1, product.getProductName(), item.getQuantity(), itemTotal.doubleValue()));
                }
                confirmation.append(String.format("<br>💰 <b>Tổng tiền cần thanh toán:</b> %,.0f VNĐ<br><br>", totalAmount.doubleValue()));
                confirmation.append("🚚 Đơn hàng sẽ được giao tận nơi trong 2-3 ngày làm việc.<br>");
                confirmation.append("💵 Vui lòng chuẩn bị tiền mặt để thanh toán khi nhận hàng.<br>");
                confirmation.append("📞 Nhân viên sẽ liên hệ trước khi giao hàng.<br><br>");
                confirmation.append("Cảm ơn bạn đã mua hàng! 🎉");
                return confirmation.toString();
            } catch (Exception e) {
                System.err.println("Error processing COD checkout: " + e.getMessage());
                return "Có lỗi khi xử lý đơn hàng. Vui lòng thử lại.";
            }
        }
        return "";
    }

    // **6. LOGIC PAYMENT - LINH HOẠT**
    private String processPayment(String input) {
        if (userId == null) {
            return "Bạn cần đăng nhập để thanh toán.";
        }
        try {
            // Nếu có lastSelectedProduct thì thanh toán nhanh sản phẩm này
            if (lastSelectedProduct != null) {
                Product product = lastSelectedProduct;
                BigDecimal price = getEffectivePrice(product);
                String orderCode = "DH" + sessionId.replaceAll("[^0-9]", "") + "_SP" + product.getProductId();
                StringBuilder paymentInfo = new StringBuilder();
                paymentInfo.append("💳 <b>Thanh toán VietQR cho sản phẩm:</b><br><br>");
                paymentInfo.append("🛒 <b>Chi tiết đơn hàng:</b><br>");
                paymentInfo.append(String.format("1. %s x1 - %,.0f VNĐ<br>", product.getProductName(), price.doubleValue()));
                paymentInfo.append(String.format("<br>💰 <b>Tổng tiền cần thanh toán:</b> %,.0f VNĐ<br><br>", price.doubleValue()));
                String qrUrl;
                try {
                    qrUrl = QRBankUtil.getVietQRUrl("VCB", "1031253640", price.longValue(), orderCode, "HUYNH NGOC SON");
                } catch (Exception e) {
                    qrUrl = "https://img.vietqr.io/image/VCB-1031253640-compact2.png?amount=" + price.longValue() + "&addInfo=" + orderCode + "&accountName=HUYNH NGOC SON";
                }
                paymentInfo.append("🏦 <b>Thông tin chuyển khoản:</b><br>");
                paymentInfo.append("Ngân hàng: Vietcombank<br>");
                paymentInfo.append("💳 STK: <b>1031253640</b><br>");
                paymentInfo.append("👤 Chủ TK: <b>HUYNH NGOC SON</b><br>");
                paymentInfo.append("💵 Số tiền: <b>" + String.format("%,d", price.longValue()) + " VNĐ</b><br>");
                paymentInfo.append("📝 Nội dung: <b>" + orderCode + "</b><br>");
                paymentInfo.append("<img src=\"" + qrUrl + "\" alt=\"QR\" style=\"max-width:250px;\"><br>");
                paymentInfo.append("📧 Gửi biên lai sau khi chuyển khoản để xác nhận đơn hàng.");
                return paymentInfo.toString();
            }
            // Nếu không có sản phẩm vừa chọn thì kiểm tra giỏ hàng
            Cart cart = cartService.getActiveCart(userId);
            if (cart == null) {
                return "Giỏ hàng của bạn đang trống hoặc bạn chưa chọn sản phẩm nào.";
            }
            List<CartItem> cartItems = cartItemService.getAllByCartID_Admin(cart.getCartID());
            cartItems = cartItems.stream()
                .filter(item -> !item.isIsDeleted() && !"checkout".equalsIgnoreCase(item.getStatus()))
                .collect(Collectors.toList());
            if (cartItems.isEmpty()) {
                return "Giỏ hàng của bạn đang trống hoặc bạn chưa chọn sản phẩm nào.";
            }
            BigDecimal totalAmount = BigDecimal.ZERO;
            for (CartItem item : cartItems) {
                BigDecimal effectivePrice = getEffectivePrice(item.getProduct());
                BigDecimal itemTotal = effectivePrice.multiply(BigDecimal.valueOf(item.getQuantity()));
                totalAmount = totalAmount.add(itemTotal);
            }
            String orderCode = "DH" + sessionId.replaceAll("[^0-9]", "") + "_" + cart.getCartID();
            StringBuilder paymentInfo = new StringBuilder();
            paymentInfo.append("💳 <b>Thanh toán VietQR cho giỏ hàng:</b><br><br>");
            paymentInfo.append("🛒 <b>Chi tiết đơn hàng:</b><br>");
            for (int i = 0; i < cartItems.size(); i++) {
                CartItem item = cartItems.get(i);
                Product product = item.getProduct();
                BigDecimal effectivePrice = getEffectivePrice(product);
                BigDecimal itemTotal = effectivePrice.multiply(BigDecimal.valueOf(item.getQuantity()));
                paymentInfo.append(String.format("%d. %s x%d - %,.0f VNĐ<br>", i + 1, product.getProductName(), item.getQuantity(), itemTotal.doubleValue()));
            }
            paymentInfo.append(String.format("<br>💰 <b>Tổng tiền cần thanh toán:</b> %,.0f VNĐ<br><br>", totalAmount.doubleValue()));
            String qrUrl;
            try {
                qrUrl = QRBankUtil.getVietQRUrl("VCB", "1031253640", totalAmount.longValue(), orderCode, "HUYNH NGOC SON");
            } catch (Exception e) {
                qrUrl = "https://img.vietqr.io/image/VCB-1031253640-compact2.png?amount=" + totalAmount.longValue() + "&addInfo=" + orderCode + "&accountName=HUYNH NGOC SON";
            }
            paymentInfo.append("🏦 <b>Thông tin chuyển khoản:</b><br>");
            paymentInfo.append("Ngân hàng: Vietcombank<br>");
            paymentInfo.append("💳 STK: <b>1031253640</b><br>");
            paymentInfo.append("👤 Chủ TK: <b>HUYNH NGOC SON</b><br>");
            paymentInfo.append("💵 Số tiền: <b>" + String.format("%,d", totalAmount.longValue()) + " VNĐ</b><br>");
            paymentInfo.append("📝 Nội dung: <b>" + orderCode + "</b><br>");
            paymentInfo.append("<img src=\"" + qrUrl + "\" alt=\"QR\" style=\"max-width:250px;\"><br>");
            paymentInfo.append("📧 Gửi biên lai sau khi chuyển khoản để xác nhận đơn hàng.");
            return paymentInfo.toString();
        } catch (Exception e) {
            System.err.println("Error processing payment: " + e.getMessage());
            return "Có lỗi khi xử lý thanh toán. Vui lòng thử lại.";
        }
    }

    // ====== BỔ SUNG NGHIỆP VỤ LINH HOẠT CHO COD & CHUYỂN KHOẢN ======
    // Helper: Lấy địa chỉ mặc định shipping của user
    private Address getDefaultShippingAddress(int userId) {
        List<Address> addresses = addressService.getShipAddrByUserID(userId);
        if (addresses == null || addresses.isEmpty()) return null;
        for (Address addr : addresses) {
            if (addr.getIsDefault()) return addr;
        }
        return addresses.get(0); // fallback nếu không có default
    }

    // Helper: Lưu địa chỉ user nhập (COD) với kiểm tra đầu vào
    private Address createAddressFromUserInput(String userInput, int userId) {
        String[] lines = userInput.split("\n");
        String name = "", phone = "", province = "", district = "", ward = "", detail = "";
        for (String line : lines) {
            if (line.toLowerCase().contains("tên:")) name = line.replaceFirst("(?i)tên:", "").trim();
            if (line.toLowerCase().contains("địa chỉ:")) detail = line.replaceFirst("(?i)địa chỉ:", "").trim();
            if (line.toLowerCase().contains("sđt:")) phone = line.replaceFirst("(?i)sđt:", "").trim();
        }
        // Kiểm tra thiếu thông tin
        if (name.isEmpty() || phone.isEmpty() || detail.isEmpty()) {
            throw new IllegalArgumentException("Vui lòng nhập đầy đủ tên, số điện thoại và địa chỉ giao hàng!");
        }
        Address addr = new Address(name, phone, province, district, ward, detail, false, "shipping", false, new model.entity.User(userId));
        addressService.createAddress(addr);
        return addr;
    }

    // Helper: Tạo Order và OrderItem, cập nhật trạng thái Cart/CartItem
    private String createOrderAndCheckout(List<CartItem> cartItems, Address shippingAddr, String status, String notes) {
        if (cartItems == null || cartItems.isEmpty() || shippingAddr == null) return "Không đủ thông tin để tạo đơn hàng.";
        BigDecimal total = BigDecimal.ZERO;
        for (CartItem ci : cartItems) {
            BigDecimal price = getEffectivePrice(ci.getProduct());
            total = total.add(price.multiply(BigDecimal.valueOf(ci.getQuantity())));
        }
        Order order = new Order();
        order.setUser(cartItems.get(0).getCart().getUser());
        order.setShippingAddress(shippingAddr);
        order.setBillingAddress(shippingAddr);
        order.setStatus(status);
        order.setTotalAmount(total);
        order.setDiscountAmount(BigDecimal.ZERO);
        order.setShippingFee(BigDecimal.ZERO);
        order.setTax(BigDecimal.ZERO);
        order.setFinalAmount(total);
        order.setNotes(notes);
        orderService.createOrder(order);
        orderItemService.createOrderItemFromSelected(cartItems, order);
        for (CartItem ci : cartItems) {
            ci.setStatus("checkout");
            cartItemService.updateCartItem(ci);
        }
        return "Đặt hàng thành công! Mã đơn: " + order.getOrderNumber();
    }

    // Hàm mới: Đặt hàng COD linh hoạt
    public String processCODCheckoutFlexible(String userInput) {
        if (userId == null) {
            return "Bạn cần đăng nhập để thanh toán.";
        }
        if (pendingCODInfo == null) {
            pendingCODInfo = "waiting";
            return "Vui lòng cung cấp thông tin nhận hàng theo format:\nTên: [Tên người nhận]\nĐịa chỉ: [Địa chỉ giao hàng]\nSĐT: [Số điện thoại]";
        } else if ("waiting".equals(pendingCODInfo)) {
            pendingCODInfo = null;
            try {
                Cart cart = cartService.getActiveCart(userId);
                if (cart == null) return "Không tìm thấy giỏ hàng hoặc bạn chưa chọn sản phẩm nào.";
                List<CartItem> cartItems = cartItemService.getAllByCartID_UserSelected(cart.getCartID());
                cartItems = cartItems.stream().filter(item -> !item.isIsDeleted() && !"checkout".equalsIgnoreCase(item.getStatus())).collect(java.util.stream.Collectors.toList());
                if (cartItems.isEmpty()) return "Không tìm thấy sản phẩm nào để đặt hàng.";
                Address addr = createAddressFromUserInput(userInput, userId);
                String result = createOrderAndCheckout(cartItems, addr, Order.OrderStatus.PENDING.getValue(), "COD");
                return result + "\nĐơn hàng sẽ được giao tận nơi trong 2-3 ngày làm việc.";
            } catch (Exception e) {
                System.err.println("Error processing COD checkout: " + e.getMessage());
                return "Có lỗi khi xử lý đơn hàng. Vui lòng thử lại.";
            }
        }
        return "";
    }

    // Hàm mới: Đặt hàng chuyển khoản linh hoạt
    public String processPaymentFlexible(String input) {
        if (userId == null) {
            return "Bạn cần đăng nhập để thanh toán.";
        }
        try {
            Cart cart = cartService.getActiveCart(userId);
            if (cart == null) return "Giỏ hàng của bạn đang trống hoặc bạn chưa chọn sản phẩm nào.";
            List<CartItem> cartItems = cartItemService.getAllByCartID_UserSelected(cart.getCartID());
            cartItems = cartItems.stream().filter(item -> !item.isIsDeleted() && !"checkout".equalsIgnoreCase(item.getStatus())).collect(java.util.stream.Collectors.toList());
            if (cartItems.isEmpty()) return "Không tìm thấy sản phẩm nào để đặt hàng.";
            Address addr = getDefaultShippingAddress(userId);
            if (addr == null) return "Bạn chưa có địa chỉ mặc định. Vui lòng thêm địa chỉ trước khi thanh toán.";
            String result = createOrderAndCheckout(cartItems, addr, Order.OrderStatus.CONFIRMED.getValue(), "VietQR");
            return result + "\nVui lòng chuyển khoản theo hướng dẫn để hoàn tất đơn hàng.";
        } catch (Exception e) {
            System.err.println("Error processing payment: " + e.getMessage());
            return "Có lỗi khi xử lý thanh toán. Vui lòng thử lại.";
        }
    }

    // Hàm mới: Đặt hàng linh hoạt theo phương thức thanh toán
    public String processOrderFlexible(boolean isCOD, String userInput) {
        if (userId == null) {
            return "Bạn cần đăng nhập để đặt hàng.";
        }
        try {
            Cart cart = cartService.getActiveCart(userId);
            if (cart == null) return "Không tìm thấy giỏ hàng hoặc bạn chưa chọn sản phẩm nào.";
            List<CartItem> cartItems = cartItemService.getAllByCartID_UserSelected(cart.getCartID());
            cartItems = cartItems.stream().filter(item -> !item.isIsDeleted() && !"checkout".equalsIgnoreCase(item.getStatus())).collect(java.util.stream.Collectors.toList());
            if (cartItems.isEmpty()) return "Không tìm thấy sản phẩm nào để đặt hàng.";
            Address addr;
            String status;
            String notes;
            if (isCOD) {
                // COD: lấy địa chỉ user nhập, trạng thái pending
                addr = createAddressFromUserInput(userInput, userId);
                status = Order.OrderStatus.PENDING.getValue();
                notes = "COD";
            } else {
                // Chuyển khoản: lấy địa chỉ mặc định, trạng thái confirmed
                addr = getDefaultShippingAddress(userId);
                if (addr == null) return "Bạn chưa có địa chỉ mặc định. Vui lòng thêm địa chỉ trước khi thanh toán.";
                status = Order.OrderStatus.CONFIRMED.getValue();
                notes = "VietQR";
            }
            String result = createOrderAndCheckout(cartItems, addr, status, notes);
            if (isCOD) {
                return result + "\nĐơn hàng sẽ được giao tận nơi trong 2-3 ngày làm việc. Trạng thái: pending.";
            } else {
                // Sinh mã QR cho chuyển khoản
                BigDecimal total = cartItems.stream().map(ci -> getEffectivePrice(ci.getProduct()).multiply(BigDecimal.valueOf(ci.getQuantity()))).reduce(BigDecimal.ZERO, BigDecimal::add);
                String orderCode = "DH" + sessionId.replaceAll("[^0-9]", "") + "_" + cart.getCartID();
                String qrUrl;
                try {
                    qrUrl = QRBankUtil.getVietQRUrl("VCB", "1031253640", total.longValue(), orderCode, "HUYNH NGOC SON");
                } catch (Exception e) {
                    qrUrl = "https://img.vietqr.io/image/VCB-1031253640-compact2.png?amount=" + total.longValue() + "&addInfo=" + orderCode + "&accountName=HUYNH NGOC SON";
                }
                return result + "\nVui lòng chuyển khoản theo hướng dẫn để hoàn tất đơn hàng. Trạng thái: confirmed.\nMã QR chuyển khoản: " + qrUrl;
            }
        } catch (Exception e) {
            System.err.println("Error processing flexible order: " + e.getMessage());
            return "Có lỗi khi xử lý đặt hàng. Vui lòng thử lại.";
        }
    }

    // Hàm mới: Đặt hàng đơn lẻ an toàn (1 sản phẩm, chuyển khoản hoặc COD)
    public String processSingleProductOrderSafe(Product product, boolean isCOD, int userId, String userInput) {
        if (userId == 0 || product == null) {
            return "Bạn cần đăng nhập và chọn sản phẩm để đặt hàng.";
        }
        try {
            // Tạo CartItem tạm cho sản phẩm đơn lẻ
            Cart tempCart = new Cart("active", new model.entity.User(userId));
            CartItem tempItem = new CartItem(1, "selected", false, tempCart, product);
            List<CartItem> cartItems = java.util.Collections.singletonList(tempItem);
            Address addr;
            String notes;
            if (isCOD) {
                try {
                    addr = createAddressFromUserInput(userInput, userId);
                } catch (IllegalArgumentException ex) {
                    return ex.getMessage();
                }
                notes = "COD";
            } else {
                addr = getDefaultShippingAddress(userId);
                if (addr == null) return "Bạn bắt buộc phải nhập địa chỉ trước khi thanh toán.";
                notes = "VietQR";
            }
            String result = createOrderAndCheckout(cartItems, addr, Order.OrderStatus.PENDING.getValue(), notes);
            if (isCOD) {
                return result + "\nĐơn hàng của bạn đang chờ xác nhận và sẽ được giao tận nơi trong 2-3 ngày làm việc. Trạng thái: pending.";
            } else {
                BigDecimal total = getEffectivePrice(product);
                String orderCode = "DH" + sessionId.replaceAll("[^0-9]", "") + "_SP" + product.getProductId();
                String qrUrl;
                try {
                    qrUrl = QRBankUtil.getVietQRUrl("VCB", "1031253640", total.longValue(), orderCode, "HUYNH NGOC SON");
                } catch (Exception e) {
                    qrUrl = "https://img.vietqr.io/image/VCB-1031253640-compact2.png?amount=" + total.longValue() + "&addInfo=" + orderCode + "&accountName=HUYNH NGOC SON";
                }
                return result + "\nVui lòng chuyển khoản theo hướng dẫn để hoàn tất đơn hàng. Đơn hàng sẽ được admin xác nhận khi nhận được tiền. Trạng thái: pending.\nMã QR chuyển khoản: " + qrUrl;
            }
        } catch (Exception e) {
            System.err.println("Error processing single product order: " + e.getMessage());
            return "Có lỗi khi xử lý đặt hàng. Vui lòng thử lại.";
        }
    }

    // Sửa lại processOrderSafe: nếu lastSelectedProduct != null thì mua đơn lẻ, còn lại là giỏ hàng
    public String processOrderSafe(boolean isCOD, String userInput) {
        if (userId == null) {
            return "Bạn cần đăng nhập để đặt hàng.";
        }
        try {
            if (lastSelectedProduct != null) {
                // Mua đơn lẻ
                return processSingleProductOrderSafe(lastSelectedProduct, isCOD, userId, userInput);
            }
            // Mua theo giỏ hàng
            Cart cart = cartService.getActiveCart(userId);
            if (cart == null) return "Không tìm thấy giỏ hàng hoặc bạn chưa chọn sản phẩm nào.";
            List<CartItem> cartItems = cartItemService.getAllByCartID_UserSelected(cart.getCartID());
            cartItems = cartItems.stream().filter(item -> !item.isIsDeleted() && !"checkout".equalsIgnoreCase(item.getStatus())).collect(java.util.stream.Collectors.toList());
            if (cartItems.isEmpty()) return "Không tìm thấy sản phẩm nào để đặt hàng.";
            Address addr;
            String notes;
            if (isCOD) {
                try {
                    addr = createAddressFromUserInput(userInput, userId);
                } catch (IllegalArgumentException ex) {
                    return ex.getMessage();
                }
                notes = "COD";
            } else {
                addr = getDefaultShippingAddress(userId);
                if (addr == null) return "Bạn bắt buộc phải nhập địa chỉ trước khi thanh toán.";
                notes = "VietQR";
            }
            String result = createOrderAndCheckout(cartItems, addr, Order.OrderStatus.PENDING.getValue(), notes);
            if (isCOD) {
                return result + "\nĐơn hàng của bạn đang chờ xác nhận và sẽ được giao tận nơi trong 2-3 ngày làm việc. Trạng thái: pending.";
            } else {
                BigDecimal total = cartItems.stream().map(ci -> getEffectivePrice(ci.getProduct()).multiply(BigDecimal.valueOf(ci.getQuantity()))).reduce(BigDecimal.ZERO, BigDecimal::add);
                String orderCode = "DH" + sessionId.replaceAll("[^0-9]", "") + "_" + cart.getCartID();
                String qrUrl;
                try {
                    qrUrl = QRBankUtil.getVietQRUrl("VCB", "1031253640", total.longValue(), orderCode, "HUYNH NGOC SON");
                } catch (Exception e) {
                    qrUrl = "https://img.vietqr.io/image/VCB-1031253640-compact2.png?amount=" + total.longValue() + "&addInfo=" + orderCode + "&accountName=HUYNH NGOC SON";
                }
                return result + "\nVui lòng chuyển khoản theo hướng dẫn để hoàn tất đơn hàng. Đơn hàng sẽ được admin xác nhận khi nhận được tiền. Trạng thái: pending.\nMã QR chuyển khoản: " + qrUrl;
            }
        } catch (Exception e) {
            System.err.println("Error processing safe order: " + e.getMessage());
            return "Có lỗi khi xử lý đặt hàng. Vui lòng thử lại.";
        }
    }

    // Sửa lại xử lý hội thoại để ưu tiên đơn lẻ nếu vừa chọn sản phẩm
    public String processUserInputSafe(String userInput) {
        String lower = userInput.toLowerCase();
        // Nếu user chọn số thứ tự sản phẩm
        if (userInput.matches("^\\d+$")) {
            int idx = Integer.parseInt(userInput);
            if (idx > 0 && idx <= lastListedProducts.size()) {
                lastSelectedProduct = lastListedProducts.get(idx - 1);
                return "Bạn đã chọn: " + lastSelectedProduct.getProductName() + ". Bạn muốn thanh toán bằng COD hay chuyển khoản?";
            }
        }
        // Nếu user gõ chuyển khoản hoặc COD
        if (lower.contains("chuyển khoản")) {
            if (lastSelectedProduct != null) {
                String result = processSingleProductOrderSafe(lastSelectedProduct, false, userId, "");
                lastSelectedProduct = null; // reset để tránh lặp lại
                return result;
            } else {
                return processOrderSafe(false, "");
            }
        }
        if (lower.contains("cod") || lower.contains("thanh toán khi nhận hàng") || lower.contains("tiền mặt")) {
            if (lastSelectedProduct != null) {
                return "Vui lòng nhập thông tin nhận hàng theo format:\nTên: [Tên người nhận]\nĐịa chỉ: [Địa chỉ giao hàng]\nSĐT: [Số điện thoại]";
            } else {
                return "Vui lòng nhập thông tin nhận hàng cho giỏ hàng theo format:\nTên: [Tên người nhận]\nĐịa chỉ: [Địa chỉ giao hàng]\nSĐT: [Số điện thoại]";
            }
        }
        // Nếu user nhập thông tin nhận hàng sau khi chọn COD
        if (lastSelectedProduct != null && (userInput.toLowerCase().contains("tên:") && userInput.toLowerCase().contains("địa chỉ:") && userInput.toLowerCase().contains("sđt:"))) {
            String result = processSingleProductOrderSafe(lastSelectedProduct, true, userId, userInput);
            lastSelectedProduct = null;
            return result;
        }
        // Nếu user nhập thông tin nhận hàng cho giỏ hàng
        if (userInput.toLowerCase().contains("tên:") && userInput.toLowerCase().contains("địa chỉ:") && userInput.toLowerCase().contains("sđt:")) {
            return processOrderSafe(true, userInput);
        }
        // Mặc định trả về tư vấn
        return "Bạn cần hỗ trợ gì thêm? Hãy chọn sản phẩm hoặc phương thức thanh toán!";
    }

    // **7. MAIN PROCESSOR - Cập nhật với logic mới LINH HOẠT**
    public String processUserInput(String userInput) {
        conversationHistory.add(new Message("user", userInput));
        String lower = userInput.toLowerCase();
        // Nếu người dùng gõ "giỏ hàng" hoặc "cart" thì chỉ cho phép thanh toán giỏ hàng
        if (lower.contains("giỏ hàng") || lower.contains("cart")) {
            return getCartSummary();
        }
        // Nếu người dùng gõ "thanh toán khi nhận hàng" hoặc "cod" hoặc "tiền mặt" thì ưu tiên sản phẩm vừa chọn, nếu không có thì mới dùng giỏ hàng
        if (lower.contains("thanh toán khi nhận hàng") || lower.contains("cod") || lower.contains("tiền mặt")) {
            return processCODCheckout(userInput);
        }
        // Nếu người dùng gõ "chuyển khoản" hoặc "vietqr" hoặc "qr" thì ưu tiên sản phẩm vừa chọn, nếu không có thì mới dùng giỏ hàng
        if (lower.contains("chuyển khoản") || lower.contains("vietqr") || lower.contains("qr")) {
            return processPayment(userInput);
        }
        // Xử lý chọn sản phẩm
        if (userInput.matches("^\\d+$")) {
            handleSelection(userInput);
        }
        // Sinh response từ AI (TỰ NHIÊN)
        try {
            String response = llm.generateResponse(conversationHistory);
            if (response.contains("1.") && response.contains("2.")) {
                extractProductsFromResponse(response);
            }
            conversationHistory.add(new Message("assistant", response));
            return response;
        } catch (Exception e) {
            return "Lỗi kỹ thuật. Vui lòng thử lại.";
        }
    }

    // **8. UTILITY METHODS**
    public String getGreeting() {
        try {
            List<Message> greeting = Arrays.asList(
                conversationHistory.get(0),
                new Message("user", "Xin chào, tôi cần tư vấn mỹ phẩm")
            );
            return llm.generateResponse(greeting);
        } catch (Exception e) {
            return "Xin chào! Tôi là AI tư vấn mỹ phẩm. Bạn cần hỗ trợ gì?";
        }
    }

    public boolean shouldEndConversation(String input) {
        return Arrays.asList("bye", "tạm biệt", "kết thúc", "exit").contains(input.toLowerCase().trim());
    }

    public String getConversationSummary() {
        if (conversationHistory.size() <= 1) return "Chưa có cuộc trò chuyện.";
        
        StringBuilder summary = new StringBuilder("Tóm tắt cuộc trò chuyện:\n");
        for (int i = 1; i < conversationHistory.size(); i++) {
            Message msg = conversationHistory.get(i);
            String role = msg.getRole().equals("user") ? "Khách" : "AI";
            summary.append(role).append(": ").append(msg.getContent()).append("\n");
        }
        return summary.toString();
    }
}
