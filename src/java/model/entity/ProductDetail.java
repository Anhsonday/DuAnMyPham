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
import jakarta.persistence.NamedQueries;
import jakarta.persistence.NamedQuery;
import jakarta.persistence.Table;
import jakarta.persistence.Temporal;
import jakarta.persistence.TemporalType;
import jakarta.xml.bind.annotation.XmlRootElement;
import java.io.Serializable;
import java.util.Date;

/**
 *
 * @author sonhuynh081104
 */
@Entity
@Table(name = "ProductDetails")

public class ProductDetail implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "ProductDetailID")
    private Integer productDetailId;
    @Column(name = "Description")
    private String description;
    @Column(name = "Ingredients")
    private String ingredients;
    @Column(name = "Origin")
    private String origin;
    @Column(name = "SkinConcerns")
    private String skinConcerns;
    @Column(name = "StorageInstructions")
    private String storageInstructions;
    @Column(name = "HowToUse")
    private String howToUse;
    @Column(name = "ManufactureDate")
    @Temporal(TemporalType.DATE)
    private Date manufactureDate;
    @Column(name = "ExpiryDate")
    @Temporal(TemporalType.DATE)
    private Date expiryDate;
    @Column(name = "IsDeleted")
    private Boolean isDeleted;
    @JoinColumn(name = "ProductID", referencedColumnName = "ProductID")
    @ManyToOne(optional = false)
    private Product productId;

    public ProductDetail() {
    }
    public ProductDetail(int productDetailId, Product productId, String description, String ingredients, String origin,
                        String skinConcerns, String storageInstructions, String howToUse,
                        java.sql.Date manufactureDate, java.sql.Date expiryDate, boolean isDeleted) {
        this.productDetailId = productDetailId;
        this.productId = productId;
        this.description = description;
        this.ingredients = ingredients;
        this.origin = origin;
        this.skinConcerns = skinConcerns;
        this.storageInstructions = storageInstructions;
        this.howToUse = howToUse;
        this.manufactureDate = manufactureDate;
        this.expiryDate = expiryDate;
        this.isDeleted = isDeleted;
    }
    public ProductDetail(Integer productDetailId) {
        this.productDetailId = productDetailId;
    }

    public Integer getProductDetailId() {
        return productDetailId;
    }

    public void setProductDetailId(Integer productDetailId) {
        this.productDetailId = productDetailId;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getIngredients() {
        return ingredients;
    }

    public void setIngredients(String ingredients) {
        this.ingredients = ingredients;
    }

    public String getOrigin() {
        return origin;
    }

    public void setOrigin(String origin) {
        this.origin = origin;
    }

    public String getSkinConcerns() {
        return skinConcerns;
    }

    public void setSkinConcerns(String skinConcerns) {
        this.skinConcerns = skinConcerns;
    }

    public String getStorageInstructions() {
        return storageInstructions;
    }

    public void setStorageInstructions(String storageInstructions) {
        this.storageInstructions = storageInstructions;
    }

    public String getHowToUse() {
        return howToUse;
    }

    public void setHowToUse(String howToUse) {
        this.howToUse = howToUse;
    }

    public Date getManufactureDate() {
        return manufactureDate;
    }

    public void setManufactureDate(Date manufactureDate) {
        this.manufactureDate = manufactureDate;
    }

    public Date getExpiryDate() {
        return expiryDate;
    }

    public void setExpiryDate(Date expiryDate) {
        this.expiryDate = expiryDate;
    }

    public Boolean getIsDeleted() {
        return isDeleted;
    }

    public void setIsDeleted(Boolean isDeleted) {
        this.isDeleted = isDeleted;
    }

    public Product getProductId() {
        return productId;
    }

    public void setProductId(Product productId) {
        this.productId = productId;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (productDetailId != null ? productDetailId.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof ProductDetail)) {
            return false;
        }
        ProductDetail other = (ProductDetail) object;
        if ((this.productDetailId == null && other.productDetailId != null) || (this.productDetailId != null && !this.productDetailId.equals(other.productDetailId))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "model.entity.ProductDetails[ productDetailID=" + productDetailId + " ]";
    }
    
}
