package model.entity;

import java.io.Serializable;
import java.math.BigDecimal;
import jakarta.persistence.*;

@Entity
@Table(name = "OrderItems")
public class OrderItem implements Serializable {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "OrderItemID")
    private Integer orderItemId;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "OrderID")
    private Order order;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ProductID")
    private Product product;
    
    @Column(name = "ProductName", length = 255)
    private String productName;
    
    @Column(name = "Quantity")
    private Integer quantity;
    
    @Column(name = "UnitPrice", precision = 12, scale = 2)
    private BigDecimal unitPrice;
    
    @Column(name = "Subtotal", precision = 12, scale = 2)
    private BigDecimal subtotal;
    
    @Column(name = "IsDeleted")
    private Boolean isDeleted = false;
    
    // Constructors
    public OrderItem() {
        this.isDeleted = false;
    }
    
    public OrderItem(Order order, Product product, Integer quantity, BigDecimal unitPrice) {
        this();
        this.order = order;
        this.product = product;
        this.productName = product.getProductName();
        this.quantity = quantity;
        this.unitPrice = unitPrice;
        this.subtotal = unitPrice.multiply(new BigDecimal(quantity));
    }

    public OrderItem(String productName, int quantity, boolean isDeleted, Order order, Product product) {
        this.productName = productName;
        this.quantity = quantity;
        this.isDeleted = isDeleted;
        this.order = order;
        this.product = product;
    }
    
    // Getters and Setters
    public Integer getOrderItemId() {
        return orderItemId;
    }
    
    public void setOrderItemId(Integer orderItemId) {
        this.orderItemId = orderItemId;
    }
    
    public Order getOrder() {
        return order;
    }
    
    public void setOrder(Order order) {
        this.order = order;
    }
    
    public Product getProduct() {
        return product;
    }
    
    public void setProduct(Product product) {
        this.product = product;
        if (product != null) {
            this.productName = product.getProductName();
        }
    }
    
    public String getProductName() {
        return productName;
    }
    
    public void setProductName(String productName) {
        this.productName = productName;
    }
    
    public Integer getQuantity() {
        return quantity;
    }
    
    public void setQuantity(Integer quantity) {
        this.quantity = quantity;
        calculateSubtotal();
    }
    
    public BigDecimal getUnitPrice() {
        return unitPrice;
    }
    
    public void setUnitPrice(BigDecimal unitPrice) {
        this.unitPrice = unitPrice;
        calculateSubtotal();
    }
    
    public BigDecimal getSubtotal() {
        return subtotal;
    }
    
    public void setSubtotal(BigDecimal subtotal) {
        this.subtotal = subtotal;
    }
    
    public Boolean getIsDeleted() {
        return isDeleted;
    }
    
    public void setIsDeleted(Boolean isDeleted) {
        this.isDeleted = isDeleted;
    }
    
    // Business methods
    private void calculateSubtotal() {
        if (this.unitPrice != null && this.quantity != null) {
            this.subtotal = this.unitPrice.multiply(new BigDecimal(this.quantity));
        }
    }
    
    public boolean isActive() {
        return !isDeleted;
    }
    
    @Override
    public String toString() {
        return "OrderItem{" +
                "orderItemId=" + orderItemId +
                ", productName='" + productName + '\'' +
                ", quantity=" + quantity +
                ", unitPrice=" + unitPrice +
                ", subtotal=" + subtotal +
                '}';
    }
} 