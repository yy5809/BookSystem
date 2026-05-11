package com.ruoyi.textbook.domain;

import java.time.LocalDateTime;
import java.util.List;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

import javax.validation.constraints.Max;
import javax.validation.constraints.Min;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;

public class TbPurchase extends BaseEntity {
    private static final long serialVersionUID = 1L;

    private Long buyId;

    @Excel(name = "申请单号")
    @Size(max = 50, message = "申请单号长度不能超过50个字符")
    private String purchaseNo;

    @Excel(name = "申请人ID")
    private Long userId;

    @Excel(name = "申请人姓名")
    @Size(max = 50, message = "申请人姓名不能超过50个字符")
    private String userName;

    @Excel(name = "身份", readConverterExp = "1=教师,2=学生")
    @Size(max = 10, message = "身份类型不能超过10个字符")
    private String userType;

    @Excel(name = "班级/部门")
    @Size(max = 100, message = "班级/部门名称不能超过100个字符")
    private String deptName;

    @Excel(name = "申请数量")
    @Min(value = 1, message = "申请数量必须大于0")
    @Max(value = 100, message = "单次最多购买100本")
    private Integer buyNum;

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @Excel(name = "申请时间", width = 30, dateFormat = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime submitTime;

    @Excel(name = "状态", readConverterExp = "0=待审核,1=已通过,2=已驳回,3=已领书,4=已到货,5=已入库,6=已发货")
    private String status;

    private Long auditUserId;

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime auditTime;

    @Excel(name = "驳回原因")
    private String rejectReason;

    @Excel(name = "审核意见")
    private String auditOpinion;

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime receiveTime;

    private String delFlag;
    private List<TbPurchaseDetail> details;

    @NotNull(message = "教材ID不能为空")
    private Long bookId;

    @Size(max = 200, message = "教材名称不能超过200个字符")
    private String bookName;

    @Size(max = 50, message = "经费来源不能超过50个字符")
    private String fundingSource;

    private String fileHash;
    private Long supplierId;
    private String logisticsNo;
    private String logisticsCompany;
    private String invoiceNo;

    @Excel(name = "采购状态", readConverterExp = "0=待采购,1=已下单,2=已接单,3=已发货,4=已到货,5=已入库")
    private String purchaseStatus;

    private String archived;

    public Long getBuyId() { return buyId; }
    public void setBuyId(Long buyId) { this.buyId = buyId; }
    public String getPurchaseNo() { return purchaseNo; }
    public void setPurchaseNo(String purchaseNo) { this.purchaseNo = purchaseNo; }
    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }
    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }
    public String getUserType() { return userType; }
    public void setUserType(String userType) { this.userType = userType; }
    public String getDeptName() { return deptName; }
    public void setDeptName(String deptName) { this.deptName = deptName; }
    public Integer getBuyNum() { return buyNum; }
    public void setBuyNum(Integer buyNum) { this.buyNum = buyNum; }
    public LocalDateTime getSubmitTime() { return submitTime; }
    public void setSubmitTime(LocalDateTime submitTime) { this.submitTime = submitTime; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getAuditStatus() { return status; }
    public Long getAuditUserId() { return auditUserId; }
    public void setAuditUserId(Long auditUserId) { this.auditUserId = auditUserId; }
    public LocalDateTime getAuditTime() { return auditTime; }
    public void setAuditTime(LocalDateTime auditTime) { this.auditTime = auditTime; }
    public String getRejectReason() { return rejectReason; }
    public void setRejectReason(String rejectReason) { this.rejectReason = rejectReason; }
    public String getAuditOpinion() { return auditOpinion; }
    public void setAuditOpinion(String auditOpinion) { this.auditOpinion = auditOpinion; }
    public LocalDateTime getReceiveTime() { return receiveTime; }
    public void setReceiveTime(LocalDateTime receiveTime) { this.receiveTime = receiveTime; }
    public String getDelFlag() { return delFlag; }
    public void setDelFlag(String delFlag) { this.delFlag = delFlag; }
    public List<TbPurchaseDetail> getDetails() { return details; }
    public void setDetails(List<TbPurchaseDetail> details) { this.details = details; }

    public Long getBookId() { return bookId; }
    public void setBookId(Long bookId) { this.bookId = bookId; }
    public String getBookName() { return bookName; }
    public void setBookName(String bookName) { this.bookName = bookName; }
    public String getFundingSource() { return fundingSource; }
    public void setFundingSource(String fundingSource) { this.fundingSource = fundingSource; }
    public String getFileHash() { return fileHash; }
    public void setFileHash(String fileHash) { this.fileHash = fileHash; }
    public Long getSupplierId() { return supplierId; }
    public void setSupplierId(Long supplierId) { this.supplierId = supplierId; }
    public String getLogisticsNo() { return logisticsNo; }
    public void setLogisticsNo(String logisticsNo) { this.logisticsNo = logisticsNo; }
    public String getLogisticsCompany() { return logisticsCompany; }
    public void setLogisticsCompany(String logisticsCompany) { this.logisticsCompany = logisticsCompany; }
    public String getInvoiceNo() { return invoiceNo; }
    public void setInvoiceNo(String invoiceNo) { this.invoiceNo = invoiceNo; }

    public String getPurchaseStatus() { return purchaseStatus; }
    public void setPurchaseStatus(String purchaseStatus) { this.purchaseStatus = purchaseStatus; }
    public String getArchived() { return archived; }
    public void setArchived(String archived) { this.archived = archived; }

    public boolean isPending() { return "0".equals(this.status); }
    public boolean isApproved() { return "1".equals(this.status); }
    public boolean isReceived() { return "3".equals(this.status); }
    public boolean isArrived() { return "4".equals(this.status); }
    public boolean isInbound() { return "5".equals(this.status); }
    public boolean isShipped() { return "6".equals(this.status); }
    public boolean canDelete() { return isPending(); }
    public boolean canInbound() { return isArrived() || isShipped(); }
    public boolean canCancel(Long currentUserId) { return isPending() && this.userId != null && this.userId.equals(currentUserId); }

    @Override
    public String toString() {
        return new org.apache.commons.lang3.builder.ToStringBuilder(this, org.apache.commons.lang3.builder.ToStringStyle.MULTI_LINE_STYLE)
            .append("buyId", buyId).append("purchaseNo", purchaseNo)
            .append("userName", userName).append("status", status).toString();
    }
}
