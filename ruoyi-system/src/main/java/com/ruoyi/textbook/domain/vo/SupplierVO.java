package com.ruoyi.textbook.domain.vo;

import java.math.BigDecimal;

public class SupplierVO {
    private Long supplierId;
    private String supplierCode;
    private String supplierName;
    private String contactPerson;
    private String contactPhone;
    private String contactEmail;
    private String address;
    private BigDecimal discountRate;
    private String paymentTerms;
    private String status;

    public Long getSupplierId() { return supplierId; }
    public void setSupplierId(Long supplierId) { this.supplierId = supplierId; }

    public String getSupplierCode() { return supplierCode; }
    public void setSupplierCode(String supplierCode) { this.supplierCode = supplierCode; }

    public String getSupplierName() { return supplierName; }
    public void setSupplierName(String supplierName) { this.supplierName = supplierName; }

    public String getContactPerson() { return contactPerson; }
    public void setContactPerson(String contactPerson) { this.contactPerson = contactPerson; }

    public String getContactPhone() {
        if (contactPhone != null && contactPhone.length() > 7) {
            return contactPhone.substring(0, 3) + "****" + contactPhone.substring(contactPhone.length() - 4);
        }
        return contactPhone;
    }
    public void setContactPhone(String contactPhone) { this.contactPhone = contactPhone; }

    public String getContactEmail() {
        if (contactEmail != null && contactEmail.contains("@")) {
            int atIndex = contactEmail.indexOf("@");
            String prefix = contactEmail.substring(0, atIndex);
            if (prefix.length() > 2) {
                return prefix.substring(0, 2) + "***" + contactEmail.substring(atIndex);
            }
            return "***" + contactEmail.substring(atIndex);
        }
        return contactEmail;
    }
    public void setContactEmail(String contactEmail) { this.contactEmail = contactEmail; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public BigDecimal getDiscountRate() { return discountRate; }
    public void setDiscountRate(BigDecimal discountRate) { this.discountRate = discountRate; }

    public String getPaymentTerms() { return paymentTerms; }
    public void setPaymentTerms(String paymentTerms) { this.paymentTerms = paymentTerms; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}