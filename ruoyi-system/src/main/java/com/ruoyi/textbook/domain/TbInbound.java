package com.ruoyi.textbook.domain;

import java.math.BigDecimal;
import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

public class TbInbound extends BaseEntity {
    private static final long serialVersionUID = 1L;

    private Long inId;

    @Excel(name = "入库单号")
    private String inboundNo;

    private Long pendingId;
    private Long bookId;

    @Excel(name = "教材名称")
    private String bookName;

    @Excel(name = "ISBN")
    private String isbn;

    @Excel(name = "入库数量")
    private Integer inNum;

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @Excel(name = "入库时间", width = 30, dateFormat = "yyyy-MM-dd HH:mm:ss")
    private Date inTime;

    @Excel(name = "操作人ID")
    private Long operatorId;
    private String inReason;

    private String operatorName;

    @Excel(name = "供应商")
    private String supplier;

    @Excel(name = "供应商电话")
    private String supplierPhone;

    @Excel(name = "单价")
    private BigDecimal unitPrice;

    @Excel(name = "总价")
    private BigDecimal totalPrice;

    private Long purchaseId;
    private Long supplierId;

    private String remark;
    private String delFlag;

    public Long getInId() { return inId; }
    public void setInId(Long inId) { this.inId = inId; }
    public String getInboundNo() { return inboundNo; }
    public void setInboundNo(String inboundNo) { this.inboundNo = inboundNo; }
    public Long getPendingId() { return pendingId; }
    public void setPendingId(Long pendingId) { this.pendingId = pendingId; }
    public Long getBookId() { return bookId; }
    public void setBookId(Long bookId) { this.bookId = bookId; }
    public String getBookName() { return bookName; }
    public void setBookName(String bookName) { this.bookName = bookName; }
    public String getIsbn() { return isbn; }
    public void setIsbn(String isbn) { this.isbn = isbn; }
    public Integer getInNum() { return inNum; }
    public void setInNum(Integer inNum) { this.inNum = inNum; }
    public Date getInTime() { return inTime; }
    public void setInTime(Date inTime) { this.inTime = inTime; }
    public Long getOperatorId() { return operatorId; }
    public void setOperatorId(Long operatorId) { this.operatorId = operatorId; }
    public String getInReason() { return inReason; }
    public void setInReason(String inReason) { this.inReason = inReason; }
    public String getOperatorName() { return operatorName; }
    public void setOperatorName(String operatorName) { this.operatorName = operatorName; }
    public String getSupplier() { return supplier; }
    public void setSupplier(String supplier) { this.supplier = supplier; }
    public String getSupplierPhone() { return supplierPhone; }
    public void setSupplierPhone(String supplierPhone) { this.supplierPhone = supplierPhone; }
    public BigDecimal getUnitPrice() { return unitPrice; }
    public void setUnitPrice(BigDecimal unitPrice) { this.unitPrice = unitPrice; }
    public BigDecimal getTotalPrice() { return totalPrice; }
    public void setTotalPrice(BigDecimal totalPrice) { this.totalPrice = totalPrice; }
    public Long getPurchaseId() { return purchaseId; }
    public void setPurchaseId(Long purchaseId) { this.purchaseId = purchaseId; }
    public Long getSupplierId() { return supplierId; }
    public void setSupplierId(Long supplierId) { this.supplierId = supplierId; }
    public String getRemark() { return remark; }
    public void setRemark(String remark) { this.remark = remark; }
    public String getDelFlag() { return delFlag; }
    public void setDelFlag(String delFlag) { this.delFlag = delFlag; }

    @Override
    public String toString() {
        return new org.apache.commons.lang3.builder.ToStringBuilder(this, org.apache.commons.lang3.builder.ToStringStyle.MULTI_LINE_STYLE)
            .append("inId", inId).append("inboundNo", inboundNo)
            .append("pendingId", pendingId).append("bookId", bookId)
            .append("bookName", bookName).append("isbn", isbn)
            .append("inNum", inNum).append("inTime", inTime)
            .append("operatorId", operatorId).append("operatorName", operatorName)
            .append("supplier", supplier)
            .append("unitPrice", unitPrice).append("totalPrice", totalPrice)
            .append("purchaseId", purchaseId).append("supplierId", supplierId)
            .append("delFlag", delFlag).toString();
    }
}
