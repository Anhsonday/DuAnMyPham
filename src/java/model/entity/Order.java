package model.entity;

import jakarta.persistence.Basic;
import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import jakarta.persistence.Temporal;
import jakarta.persistence.TemporalType;
import jakarta.xml.bind.annotation.XmlTransient;
import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Collection;
import java.util.Date;

/**
 *
 * @author DELL
 */
@Entity
@Table(name = "Orders")

public class Order implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "OrderID")
    private Integer orderID;
    @Basic(optional = false)
    @Column(name = "OrderNumber")
    private String orderNumber;
    @Basic(optional = false)
    @Column(name = "Status")
    private String status;
    // @Max(value=?)  @Min(value=?)//if you know range of your decimal fields consider using these annotations to enforce field validation
    @Basic(optional = false)
    @Column(name = "TotalAmount")
    private BigDecimal totalAmount;
    @Basic(optional = false)
    @Column(name = "DiscountAmount")
    private BigDecimal discountAmount;
    @Basic(optional = false)
    @Column(name = "ShippingFee")
    private BigDecimal shippingFee;
    @Basic(optional = false)
    @Column(name = "Tax")
    private BigDecimal tax;
    @Basic(optional = false)
    @Column(name = "FinalAmount")
    private BigDecimal finalAmount;
    @Column(name = "Notes")
    private String notes;
    @Basic(optional = false)
    @Column(name = "CreatedAt", insertable = false, updatable = false)
    @Temporal(TemporalType.TIMESTAMP)
    private Date createdAt;
    @Basic(optional = false)
    @Column(name = "UpdatedAt", insertable = false, updatable = false)
    @Temporal(TemporalType.TIMESTAMP)
    private Date updatedAt;
    @Column(name = "IsDeleted")
    private Boolean isDeleted = false;
    @JoinColumn(name = "ShippingAddressID", referencedColumnName = "AddressID")
    @ManyToOne(optional = false)
    private Address shippingAddress;
    @JoinColumn(name = "BillingAddressID", referencedColumnName = "AddressID")
    @ManyToOne(optional = false)
    private Address billingAddress;
    @JoinColumn(name = "PaymentMethodID", referencedColumnName = "PaymentMethodID")
    @ManyToOne
    private PaymentMethod paymentMethod;
    @JoinColumn(name = "UserID", referencedColumnName = "UserID")
    @ManyToOne
    private User user;
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "order")
    private Collection<OrderItem> orderItemsCollection;
    
    
    
    // Enum for Order Status
    public enum OrderStatus {
        PENDING("pending"),
        CONFIRMED("confirmed"),
        SHIPPING("shipping"),
        DELIVERED("delivered"),
        RETURNED("returned"),
        CANCELLED("cancelled"),
        REFUNDED("refunded");
        
        private final String value;
        
        OrderStatus(String value) {
            this.value = value;
        }
        
        public String getValue() {
            return value;
        }
        
        public static OrderStatus fromString(String text) {
            if (text == null || text.trim().isEmpty()) {
                return PENDING; // Default to PENDING if null/empty
            }
            
            for (OrderStatus status : OrderStatus.values()) {
                if (status.value.equalsIgnoreCase(text.trim())) {
                    return status;
                }
            }
            
            // Log the invalid value for debugging
            System.err.println("Warning: Invalid OrderStatus value found in database: '" + text + "'. Defaulting to PENDING.");
            return PENDING; // Default to PENDING instead of throwing exception
        }
        
        // Method to safely convert from database value
        public static OrderStatus safeFromString(String text) {
            try {
                return fromString(text);
            } catch (Exception e) {
                System.err.println("Error converting OrderStatus from string: '" + text + "'. Error: " + e.getMessage());
                return PENDING;
            }
        }
    }
    
    
    // Constructors
    public Order() {
        this.isDeleted = false;
    }

    public Order(Integer orderID) {
        this.orderID = orderID;
    }

    public Order(Integer orderID, String status, BigDecimal totalAmount, BigDecimal discountAmount, BigDecimal shippingFee,
            BigDecimal tax, BigDecimal finalAmount, String notes, Address shippingAddress,
            Address billingAddress, PaymentMethod paymentMethod, User user) {
        this.orderID = orderID;
        this.status = status;
        this.totalAmount = totalAmount;
        this.shippingFee = shippingFee;
        this.tax = tax;
        this.finalAmount = finalAmount;
        this.notes = notes;
        this.shippingAddress = shippingAddress;
        this.billingAddress = billingAddress;
        this.paymentMethod = paymentMethod;
        this.user = user;
    }
    
    public Order(String status, BigDecimal totalAmount, BigDecimal discountAmount, BigDecimal shippingFee,
            BigDecimal tax, BigDecimal finalAmount, String notes, Address shippingAddress,
            Address billingAddress, PaymentMethod paymentMethod, User user) {
        this.status = status;
        this.totalAmount = totalAmount;
        this.shippingFee = shippingFee;
        this.tax = tax;
        this.finalAmount = finalAmount;
        this.notes = notes;
        this.shippingAddress = shippingAddress;
        this.billingAddress = billingAddress;
        this.paymentMethod = paymentMethod;
        this.user = user;
    }

    public Integer getOrderID() {
        return orderID;
    }

    public void setOrderID(Integer orderID) {
        this.orderID = orderID;
    }

    public String getOrderNumber() {
        return orderNumber;
    }

    public void setOrderNumber(String orderNumber) {
        this.orderNumber = orderNumber;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public BigDecimal getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(BigDecimal totalAmount) {
        this.totalAmount = totalAmount;
    }

    public BigDecimal getDiscountAmount() {
        return discountAmount;
    }

    public void setDiscountAmount(BigDecimal discountAmount) {
        this.discountAmount = discountAmount;
    }

    public BigDecimal getShippingFee() {
        return shippingFee;
    }

    public void setShippingFee(BigDecimal shippingFee) {
        this.shippingFee = shippingFee;
    }

    public BigDecimal getTax() {
        return tax;
    }

    public void setTax(BigDecimal tax) {
        this.tax = tax;
    }

    public BigDecimal getFinalAmount() {
        return finalAmount;
    }

    public void setFinalAmount(BigDecimal finalAmount) {
        this.finalAmount = finalAmount;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public Date getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Date updatedAt) {
        this.updatedAt = updatedAt;
    }

    public Address getShippingAddress() {
        return shippingAddress;
    }

    public void setShippingAddress(Address shippingAddress) {
        this.shippingAddress = shippingAddress;
    }

    public Address getBillingAddress() {
        return billingAddress;
    }

    public void setBillingAddress(Address billingAddress) {
        this.billingAddress = billingAddress;
    }

    public PaymentMethod getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(PaymentMethod paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    @XmlTransient
    public Collection<OrderItem> getOrderItemsCollection() {
        return orderItemsCollection;
    }

    public void setOrderItemsCollection(Collection<OrderItem> orderItemsCollection) {
        this.orderItemsCollection = orderItemsCollection;
    }

    // Logic helper methods for order status
    public boolean isActive() {
        OrderStatus currentStatus = OrderStatus.fromString(this.status);
        return !Boolean.TRUE.equals(this.isDeleted) && currentStatus != OrderStatus.CANCELLED;
    }

    public boolean canBeCancelled() {
        OrderStatus currentStatus = OrderStatus.fromString(this.status);
        return currentStatus == OrderStatus.PENDING || currentStatus == OrderStatus.CONFIRMED;
    }

    public boolean isCompleted() {
        OrderStatus currentStatus = OrderStatus.fromString(this.status);
        return currentStatus == OrderStatus.DELIVERED;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (orderID != null ? orderID.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof Order)) {
            return false;
        }
        Order other = (Order) object;
        if ((this.orderID == null && other.orderID != null) || (this.orderID != null && !this.orderID.equals(other.orderID))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "model.entity.Orders[ orderID=" + orderID + " ]";
    }
} 