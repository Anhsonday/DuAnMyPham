/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model.entity;

import jakarta.persistence.Basic;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import jakarta.persistence.Temporal;
import jakarta.persistence.TemporalType;
import jakarta.xml.bind.annotation.XmlTransient;
import java.io.Serializable;
import java.util.Collection;
import java.util.Date;

/**
 *
 * @author DELL
 */
@Entity
@Table(name = "PaymentMethods")

public class PaymentMethod implements Serializable {
    // Constant cho các loại phương thức thanh toán
    public static final int PAYMENT_METHOD_COD = 1; // Thanh toán khi nhận hàng
    public static final int PAYMENT_METHOD_VNPAY = 2; // Thanh toán qua VNPay
    
    @OneToMany(mappedBy = "paymentMethod")
    private Collection<Payment> paymentsCollection;

    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "PaymentMethodID")
    private Integer paymentMethodID;
    @Basic(optional = false)
    @Column(name = "MethodName")
    private String methodName;
    @Column(name = "Description")
    private String description;
    @Basic(optional = false)
    @Column(name = "CreatedAt", insertable = false, updatable = false)
    @Temporal(TemporalType.TIMESTAMP)
    private Date createdAt;
    @Basic(optional = false)
    @Column(name = "UpdatedAt", insertable = false, updatable = false)
    @Temporal(TemporalType.TIMESTAMP)
    private Date updatedAt;
    @Basic(optional = false)
    @Column(name = "IsDeleted")
    private boolean isDeleted;
    @OneToMany(mappedBy = "paymentMethod")
    private Collection<Order> ordersCollection;

    public PaymentMethod() {
    }

    public PaymentMethod(Integer paymentMethodID) {
        this.paymentMethodID = paymentMethodID;
    }

    public PaymentMethod(Integer paymentMethodID, String methodName, String description, boolean isDeleted) {
        this.paymentMethodID = paymentMethodID;
        this.methodName = methodName;
        this.description = description;
        this.isDeleted = isDeleted;
    }
    
    public PaymentMethod(String methodName, String description, boolean isDeleted) {
        this.methodName = methodName;
        this.description = description;
        this.isDeleted = isDeleted;
    }

    public Integer getPaymentMethodID() {
        return paymentMethodID;
    }

    public void setPaymentMethodID(Integer paymentMethodID) {
        this.paymentMethodID = paymentMethodID;
    }

    public String getMethodName() {
        return methodName;
    }

    public void setMethodName(String methodName) {
        this.methodName = methodName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
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

    public boolean getIsDeleted() {
        return isDeleted;
    }

    public void setIsDeleted(boolean isDeleted) {
        this.isDeleted = isDeleted;
    }

    @XmlTransient
    public Collection<Order> getOrdersCollection() {
        return ordersCollection;
    }

    public void setOrdersCollection(Collection<Order> ordersCollection) {
        this.ordersCollection = ordersCollection;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (paymentMethodID != null ? paymentMethodID.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof PaymentMethod)) {
            return false;
        }
        PaymentMethod other = (PaymentMethod) object;
        if ((this.paymentMethodID == null && other.paymentMethodID != null) || (this.paymentMethodID != null && !this.paymentMethodID.equals(other.paymentMethodID))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "model.entity.PaymentMethods[ paymentMethodID=" + paymentMethodID + " ]";
    }

    @XmlTransient
    public Collection<Payment> getPaymentsCollection() {
        return paymentsCollection;
    }

    public void setPaymentsCollection(Collection<Payment> paymentsCollection) {
        this.paymentsCollection = paymentsCollection;
    }
    
}
