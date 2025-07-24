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
import jakarta.xml.bind.annotation.XmlRootElement;
import java.io.Serializable;

/**
 *
 * @author sonhuynh081104
 */
@Entity
@Table(name = "ProductImages")
public class ProductImage implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "ImageID")
    private Integer imageId;
    @Basic(optional = false)
    @Column(name = "ImageURL")
    private String imageUrl;
    @Column(name = "IsMainImage")
    private Boolean isMainImage;
    @Column(name = "DisplayOrder")
    private Integer displayOrder;
    @Column(name = "IsDeleted")
    private Boolean isDeleted;
    @JoinColumn(name = "ProductID", referencedColumnName = "ProductID")
    @ManyToOne(optional = false)
    private Product productId;

    public ProductImage() {
    }
    // Constructor đầy đủ
    public ProductImage(int imageId, Product productId, String imageUrl, boolean isMainImage, 
                      int displayOrder, boolean isDeleted) {
        this.imageId = imageId;
        this.productId = productId;
        this.imageUrl = imageUrl;
        this.isMainImage = isMainImage;
        this.displayOrder = displayOrder;
        this.isDeleted = isDeleted;
    }

    // Constructor không có imageId (dùng cho insert)
    public ProductImage(Product productId, String imageUrl, boolean isMainImage, 
                       int displayOrder, boolean isDeleted) {
        this.productId = productId;
        this.imageUrl = imageUrl;
        this.isMainImage = isMainImage;
        this.displayOrder = displayOrder;
        this.isDeleted = isDeleted;
    }

    public Integer getImageId() {
        return imageId;
    }

    public void setImageId(Integer imageId) {
        this.imageId = imageId;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public Boolean getIsMainImage() {
        return isMainImage;
    }

    public void setIsMainImage(Boolean isMainImage) {
        this.isMainImage = isMainImage;
    }

    public Integer getDisplayOrder() {
        return displayOrder;
    }

    public void setDisplayOrder(Integer displayOrder) {
        this.displayOrder = displayOrder;
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
        hash += (imageId != null ? imageId.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof ProductImage)) {
            return false;
        }
        ProductImage other = (ProductImage) object;
        if ((this.imageId == null && other.imageId != null) || (this.imageId != null && !this.imageId.equals(other.imageId))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "model.entity.ProductImage[ imageId=" + imageId + " ]";
    }
    
}
