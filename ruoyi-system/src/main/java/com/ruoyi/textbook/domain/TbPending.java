package com.ruoyi.textbook.domain;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

public class TbPending extends BaseEntity {
    private static final long serialVersionUID = 1L;

    private Long pendingId;

    @Excel(name = "采购单号")
    private String pendingNo;

    private Long lackId;
    private Long bookId;
    private String bookName;
    private String isbn;

    @Excel(name = "采购数量")
    private Integer purchaseNum;

    @Excel(name = "状态", readConverterExp = "0=待采购,1=采购中,2=已到货,3=已入库")
    private String status;

    @Excel(name = "供应商")
    private String supplier;

    @Excel(name = "供应商电话")
    private String supplierPhone;

    @JsonFormat(pattern = "yyyy-MM-dd")
    @Excel(name = "预计到货", dateFormat = "yyyy-MM-dd")
    private Date expectedDate;

    @JsonFormat(pattern = "yyyy-MM-dd")
    @Excel(name = "实际到货", dateFormat = "yyyy-MM-dd")
    private Date actualDate;

    private Long purchaseUserId;

    @Excel(name = "采购负责人")
    private String purchaserName;

    private String remark;
    private String delFlag;

    public Long getPendingId() { return pendingId; }
    public void setPendingId(Long pendingId) { this.pendingId = pendingId; }
    public String getPendingNo() { return pendingNo; }
    public void setPendingNo(String pendingNo) { this.pendingNo = pendingNo; }
    public Long getLackId() { return lackId; }
    public void setLackId(Long lackId) { this.lackId = lackId; }
    public Long getBookId() { return bookId; }
    public void setBookId(Long bookId) { this.bookId = bookId; }
    public String getBookName() { return bookName; }
    public void setBookName(String bookName) { this.bookName = bookName; }
    public String getIsbn() { return isbn; }
    public void setIsbn(String isbn) { this.isbn = isbn; }
    public Integer getPurchaseNum() { return purchaseNum; }
    public void setPurchaseNum(Integer purchaseNum) { this.purchaseNum = purchaseNum; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getSupplier() { return supplier; }
    public void setSupplier(String supplier) { this.supplier = supplier; }
    public String getSupplierPhone() { return supplierPhone; }
    public void setSupplierPhone(String supplierPhone) { this.supplierPhone = supplierPhone; }
    public Date getExpectedDate() { return expectedDate; }
    public void setExpectedDate(Date expectedDate) { this.expectedDate = expectedDate; }
    public Date getActualDate() { return actualDate; }
    public void setActualDate(Date actualDate) { this.actualDate = actualDate; }
    public Long getPurchaseUserId() { return purchaseUserId; }
    public void setPurchaseUserId(Long purchaseUserId) { this.purchaseUserId = purchaseUserId; }
    public String getPurchaserName() { return purchaserName; }
    public void setPurchaserName(String purchaserName) { this.purchaserName = purchaserName; }
    public String getRemark() { return remark; }
    public void setRemark(String remark) { this.remark = remark; }
    public String getDelFlag() { return delFlag; }
    public void setDelFlag(String delFlag) { this.delFlag = delFlag; }

    @Override
    public String toString() {
        return new org.apache.commons.lang3.builder.ToStringBuilder(this, org.apache.commons.lang3.builder.ToStringStyle.MULTI_LINE_STYLE)
            .append("pendingId", pendingId).append("pendingNo", pendingNo)
            .append("purchaseNum", purchaseNum).append("status", status).toString();
    }
}
