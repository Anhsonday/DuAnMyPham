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
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import jakarta.persistence.Temporal;
import jakarta.persistence.TemporalType;
import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;

/**
 *
 * @author DELL
 */
@Entity
@Table(name = "CartItems")

public class CartItem implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "CartItemID")
    private Integer cartItemID;
    @Basic(optional = false)
    @Column(name = "Quantity")
    private int quantity;
    @Column(name = "AddedAt", insertable = false, updatable = false)
    @Temporal(TemporalType.TIMESTAMP)
    private Date addedAt;
    @Basic(optional = false)
    @Column(name = "Status")
    private String status;
    @Basic(optional = false)
    @Column(name = "IsDeleted")
    private boolean isDeleted;
    @JoinColumn(name = "CartID", referencedColumnName = "CartID")
    @ManyToOne(optional = false)
    private Cart cart;
    @JoinColumn(name = "ProductID", referencedColumnName = "ProductID")
    @ManyToOne(optional = false)
    private Product product;

    public CartItem() {
    }

    public CartItem(Integer cartItemID) {
        this.cartItemID = cartItemID;
    }

    public CartItem(Integer cartItemID, int quantity, String status, boolean isDeleted, Cart cart, Product product) {
        this.cartItemID = cartItemID;
        this.quantity = quantity;
        this.status = status;
        this.isDeleted = isDeleted;
        this.cart = cart;
        this.product = product;
    }
    
    public CartItem(int quantity, String status, boolean isDeleted, Cart cart, Product product) {
        this.quantity = quantity;
        this.status = status;
        this.isDeleted = isDeleted;
        this.cart = cart;
        this.product = product;
    }

    public Integer getCartItemID() {
        return cartItemID;
    }

    public void setCartItemID(Integer cartItemID) {
        this.cartItemID = cartItemID;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public Date getAddedAt() {
        return addedAt;
    }

    public void setAddedAt(Date addedAt) {
        this.addedAt = addedAt;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public boolean isIsDeleted() {
        return isDeleted;
    }

    public void setIsDeleted(boolean isDeleted) {
        this.isDeleted = isDeleted;
    }

    public Cart getCart() {
        return cart;
    }

    public void setCart(Cart cart) {
        this.cart = cart;
    }

    public Product getProduct() {
        return product;
    }

    public void setProduct(Product product) {
        this.product = product;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (cartItemID != null ? cartItemID.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof CartItem)) {
            return false;
        }
        CartItem other = (CartItem) object;
        if ((this.cartItemID == null && other.cartItemID != null) || (this.cartItemID != null && !this.cartItemID.equals(other.cartItemID))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "model.entity.CartItems[ cartItemID=" + cartItemID + " ]";
    }
    
    public BigDecimal getSubTotal(){
        return product.getPrice().multiply(BigDecimal.valueOf(quantity));
    }
    
}
