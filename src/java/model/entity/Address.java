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
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import jakarta.xml.bind.annotation.XmlTransient;
import java.io.Serializable;
import java.util.Collection;

/**
 *
 * @author DELL
 */
@Entity
@Table(name = "Addresses")

public class Address implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "AddressID")
    private Integer addressID;
    @Basic(optional = false)
    @Column(name = "RecipientName")
    private String recipientName;
    @Basic(optional = false)
    @Column(name = "Phone")
    private String phone;
    @Basic(optional = false)
    @Column(name = "Province")
    private String province;
    @Basic(optional = false)
    @Column(name = "District")
    private String district;
    @Basic(optional = false)
    @Column(name = "Ward")
    private String ward;
    @Basic(optional = false)
    @Column(name = "AddressDetail")
    private String addressDetail;
    @Basic(optional = false)
    @Column(name = "IsDefault")
    private boolean isDefault;
    @Basic(optional = false)
    @Column(name = "AddressType")
    private String addressType;
    @Basic(optional = false)
    @Column(name = "IsDeleted")
    private boolean isDeleted;
    @JoinColumn(name = "UserID", referencedColumnName = "UserID")
    @ManyToOne(optional = false)
    private User user;
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "shippingAddress")
    private Collection<Order> ordersCollection;
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "billingAddress")
    private Collection<Order> ordersCollection1;

    public Address() {
    }

    public Address(Integer addressID) {
        this.addressID = addressID;
    }

    public Address(Integer addressID, String recipientName, String phone, String province, String district,
            String ward, String addressDetail, boolean isDefault, String addressType, boolean isDeleted, User user) {
        this.addressID = addressID;
        this.recipientName = recipientName;
        this.phone = phone;
        this.province = province;
        this.district = district;
        this.ward = ward;
        this.addressDetail = addressDetail;
        this.isDefault = isDefault;
        this.addressType = addressType;
        this.isDeleted = isDeleted;
        this.user = user;
    }
    
    public Address(String recipientName, String phone, String province, String district, String ward,
            String addressDetail, boolean isDefault, String addressType, boolean isDeleted, User user) {
        this.recipientName = recipientName;
        this.phone = phone;
        this.province = province;
        this.district = district;
        this.ward = ward;
        this.addressDetail = addressDetail;
        this.isDefault = isDefault;
        this.addressType = addressType;
        this.isDeleted = isDeleted;
        this.user = user;
    }

    public Integer getAddressID() {
        return addressID;
    }

    public void setAddressID(Integer addressID) {
        this.addressID = addressID;
    }

    public String getRecipientName() {
        return recipientName;
    }

    public void setRecipientName(String recipientName) {
        this.recipientName = recipientName;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getProvince() {
        return province;
    }

    public void setProvince(String province) {
        this.province = province;
    }

    public String getDistrict() {
        return district;
    }

    public void setDistrict(String district) {
        this.district = district;
    }

    public String getWard() {
        return ward;
    }

    public void setWard(String ward) {
        this.ward = ward;
    }

    public String getAddressDetail() {
        return addressDetail;
    }

    public void setAddressDetail(String addressDetail) {
        this.addressDetail = addressDetail;
    }

    public boolean getIsDefault() {
        return isDefault;
    }

    public void setIsDefault(boolean isDefault) {
        this.isDefault = isDefault;
    }

    public String getAddressType() {
        return addressType;
    }

    public void setAddressType(String addressType) {
        this.addressType = addressType;
    }

    public boolean getIsDeleted() {
        return isDeleted;
    }

    public void setIsDeleted(boolean isDeleted) {
        this.isDeleted = isDeleted;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    @XmlTransient
    public Collection<Order> getOrdersCollection() {
        return ordersCollection;
    }

    public void setOrdersCollection(Collection<Order> ordersCollection) {
        this.ordersCollection = ordersCollection;
    }

    @XmlTransient
    public Collection<Order> getOrdersCollection1() {
        return ordersCollection1;
    }

    public void setOrdersCollection1(Collection<Order> ordersCollection1) {
        this.ordersCollection1 = ordersCollection1;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (addressID != null ? addressID.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof Address)) {
            return false;
        }
        Address other = (Address) object;
        if ((this.addressID == null && other.addressID != null) || (this.addressID != null && !this.addressID.equals(other.addressID))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "model.entity.Addresses[ addressID=" + addressID + " ]";
    }
    
    public String getFullAddress() {
    return province + ", " + district + ", " + ward + ", " + addressDetail;
}
    
}
