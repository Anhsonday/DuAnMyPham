/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
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
import jakarta.persistence.NamedQueries;
import jakarta.persistence.NamedQuery;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import jakarta.persistence.Temporal;
import jakarta.persistence.TemporalType;
import jakarta.xml.bind.annotation.XmlRootElement;
import jakarta.xml.bind.annotation.XmlTransient;
import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.Collection;
import java.util.Date;

/**
 *
 * @author sonhuynh081104
 */
@Entity
@Table(name = "Products")

public class Product implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "ProductID")
    private Integer productId;
    @Basic(optional = false)
    @Column(name = "ProductName")
    private String productName;
    @Basic(optional = false)
    @Column(name = "BrandName")
    private String brandName;
    @Column(name = "ShortDescription")
    private String shortDescription;
    // @Max(value=?)  @Min(value=?)//if you know range of your decimal fields consider using these annotations to enforce field validation
    @Basic(optional = false)
    @Column(name = "Price")
    private BigDecimal price;
    @Column(name = "SalePrice")
    private BigDecimal salePrice;
    @Column(name = "SKU")
    private String sku;
    @Column(name = "QuantityValue")
    private BigDecimal quantityValue;
    @Column(name = "QuantityUnit")
    private String quantityUnit;
    @Column(name = "Status")
    private String status;
    @Column(name = "Featured")
    private Boolean featured;
    @Column(name = "CreatedAt")
    @Temporal(TemporalType.TIMESTAMP)
    private Date createdAt;
    @Column(name = "UpdatedAt")
    @Temporal(TemporalType.TIMESTAMP)
    private Date updatedAt;
    @Column(name = "IsDeleted")
    private Boolean isDeleted;
    @Column(name = "Stock")
    private int stock;
    @Column(name = "ReservedQuantity")
    private int reservedQuantity; // Chỉ hiển thị cho admin
    @JoinColumn(name = "CategoryID", referencedColumnName = "CategoryID")
    @ManyToOne
    private Category categoryId;
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "productId")
    private Collection<ProductImage> productImagesCollection;
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "productId")
    private Collection<ProductDetail> productDetailsCollection;
    @OneToMany(mappedBy = "productId")
    private Collection<Wishlist> wishlistCollection;

    public Product() {
    }

    public Product(int productId, Category categoryId, String productName, String brandName,
                  String shortDescription, BigDecimal price, BigDecimal salePrice, int stock, int reservedQuantity,
                  String sku, BigDecimal quantityValue, String quantityUnit, String status, boolean featured,
                  String createdAt, String updatedAt, boolean isDeleted) {
        this.productId = productId;
        this.categoryId = categoryId;
        this.productName = productName;
        this.brandName = brandName;
        
        this.shortDescription = shortDescription;
        this.price = price;
        this.salePrice = salePrice;
        this.stock = stock;
        this.reservedQuantity = reservedQuantity;
        this.sku = sku;
        this.quantityValue = quantityValue;
        this.quantityUnit = quantityUnit;
        this.status = status;
        this.featured = featured;
        this.isDeleted = isDeleted;
    }

    // Getters and setters (tương tự như trên, đổi tên cho đúng với DB mới)
    // ... (bạn có thể copy lại phần getter/setter từ file cũ và sửa tên trường cho đúng)

    // Ví dụ:
    public boolean isActive() {
        return "active".equalsIgnoreCase(status);
    }
    
    public void setActive(boolean active) {
        this.status = active ? "active" : "inactive";
    }

    public Integer getProductId() {
        return productId;
    }

    public void setProductId(Integer productId) {
        this.productId = productId;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public String getBrandName() {
        return brandName;
    }

    public void setBrandName(String brandName) {
        this.brandName = brandName;
    }

    public String getShortDescription() {
        return shortDescription;
    }

    public void setShortDescription(String shortDescription) {
        this.shortDescription = shortDescription;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public BigDecimal getSalePrice() {
        return salePrice;
    }

    public void setSalePrice(BigDecimal salePrice) {
        this.salePrice = salePrice;
    }

    public int getStock() {
        return stock;
    }
    public void setStock(int stock) {
        this.stock = stock;
    }
    public int getReservedQuantity() {
        return reservedQuantity;
    }
    public void setReservedQuantity(int reservedQuantity) {
        this.reservedQuantity = reservedQuantity;
    }

    public String getSku() {
        return sku;
    }

    public void setSku(String sku) {
        this.sku = sku;
    }

    public BigDecimal getQuantityValue() {
        return quantityValue;
    }

    public void setQuantityValue(BigDecimal quantityValue) {
        this.quantityValue = quantityValue;
    }

    public String getQuantityUnit() {
        return quantityUnit;
    }

    public void setQuantityUnit(String quantityUnit) {
        this.quantityUnit = quantityUnit;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Boolean getFeatured() {
        return featured;
    }

    public void setFeatured(Boolean featured) {
        this.featured = featured;
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

    public Boolean getIsDeleted() {
        return isDeleted;
    }

    public void setIsDeleted(Boolean isDeleted) {
        this.isDeleted = isDeleted;
    }

    public Category getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(Category categoryId) {
        this.categoryId = categoryId;
    }

    public Collection<ProductImage> getProductImagesCollection() {
        return productImagesCollection;
    }

    public void setProductImagesCollection(Collection<ProductImage> productImagesCollection) {
        this.productImagesCollection = productImagesCollection;
    }

    public Collection<ProductDetail> getProductDetailsCollection() {
        return productDetailsCollection;
    }

    public void setProductDetailsCollection(Collection<ProductDetail> productDetailsCollection) {
        this.productDetailsCollection = productDetailsCollection;
    }

    public Collection<Wishlist> getWishlistCollection() {
        return wishlistCollection;
    }

    public void setWishlistCollection(Collection<Wishlist> wishlistCollection) {
        this.wishlistCollection = wishlistCollection;
    }
    
}
