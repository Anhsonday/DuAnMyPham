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
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import jakarta.persistence.Temporal;
import jakarta.persistence.TemporalType;
import jakarta.xml.bind.annotation.XmlRootElement;
import jakarta.xml.bind.annotation.XmlTransient;
import java.io.Serializable;
import java.util.Collection;
import java.util.Date;

/**
 *
 * @author sonhuynh081104
 */
@Entity
@Table(name = "Categories")

public class Category implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "CategoryID")
    private Integer categoryId;
    @Column(name = "CategoryName")
    private String categoryName;
    @Column(name = "Description")
    private String description;
    @Column(name = "Image")
    private String image;
    @Column(name = "Status")
    private String status;
    @Column(name = "DisplayOrder")
    private Integer displayOrder;
    @Column(name = "CreatedAt")
    @Temporal(TemporalType.TIMESTAMP)
    private Date createdAt;
    @Column(name = "UpdatedAt")
    @Temporal(TemporalType.TIMESTAMP)
    private Date updatedAt;
    @Column(name = "IsDeleted")
    private Boolean isDeleted;
    @OneToMany(mappedBy = "categoryId")
    private Collection<Product> productsCollection;
    @OneToMany(mappedBy = "parentCategoryId")
    private Collection<Category> categoriesCollection;
    @JoinColumn(name = "ParentCategoryID", referencedColumnName = "CategoryID")
    @ManyToOne
    private Category parentCategoryId;

    public Category() {
    }

    public Category(int categoryId, String categoryName, String status) {
        this.categoryId = categoryId;
        this.categoryName = categoryName;
        this.status = status;
    }

    public Category(int categoryId, Category parentCategoryId, String categoryName, String description, String image, String status,
                    int displayOrder, boolean isDeleted) {
        this.categoryId = categoryId;
        this.parentCategoryId = parentCategoryId;
        this.categoryName = categoryName;
        this.description = description;
        this.image = image;
        this.status = status;
        this.displayOrder = displayOrder;
        this.isDeleted = isDeleted;
    }

    public Integer getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(Integer categoryId) {
        this.categoryId = categoryId;
    }

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Integer getDisplayOrder() {
        return displayOrder;
    }

    public void setDisplayOrder(Integer displayOrder) {
        this.displayOrder = displayOrder;
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

    public Collection<Product> getProductsCollection() {
        return productsCollection;
    }

    public void setProductsCollection(Collection<Product> productsCollection) {
        this.productsCollection = productsCollection;
    }

    public Collection<Category> getCategoriesCollection() {
        return categoriesCollection;
    }

    public void setCategoriesCollection(Collection<Category> categoriesCollection) {
        this.categoriesCollection = categoriesCollection;
    }

    public Category getParentCategoryId() {
        return parentCategoryId;
    }

    public void setParentCategoryId(Category parentCategoryId) {
        this.parentCategoryId = parentCategoryId;
    }

    public boolean isActive() {
        return "active".equalsIgnoreCase(status);
    }
    
    public void setActive(boolean active) {
        this.status = active ? "active" : "inactive";
    }
    
}
