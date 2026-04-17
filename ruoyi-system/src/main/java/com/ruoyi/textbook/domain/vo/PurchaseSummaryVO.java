package com.ruoyi.textbook.domain.vo;

import java.time.LocalDateTime;
import java.util.List;

public class PurchaseSummaryVO {
    private Long buyId;
    private String purchaseNo;
    private String userName;
    private String bookName;
    private Integer buyNum;
    private String auditStatus;
    private String auditStatusDesc;
    private LocalDateTime submitTime;

    public Long getBuyId() { return buyId; }
    public void setBuyId(Long buyId) { this.buyId = buyId; }
    public String getPurchaseNo() { return purchaseNo; }
    public void setPurchaseNo(String purchaseNo) { this.purchaseNo = purchaseNo; }
    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }
    public String getBookName() { return bookName; }
    public void setBookName(String bookName) { this.bookName = bookName; }
    public Integer getBuyNum() { return buyNum; }
    public void setBuyNum(Integer buyNum) { this.buyNum = buyNum; }
    public String getAuditStatus() { return auditStatus; }
    public void setAuditStatus(String auditStatus) { this.auditStatus = auditStatus; }
    public String getAuditStatusDesc() { return auditStatusDesc; }
    public void setAuditStatusDesc(String auditStatusDesc) { this.auditStatusDesc = auditStatusDesc; }
    public LocalDateTime getSubmitTime() { return submitTime; }
    public void setSubmitTime(LocalDateTime submitTime) { this.submitTime = submitTime; }
}
