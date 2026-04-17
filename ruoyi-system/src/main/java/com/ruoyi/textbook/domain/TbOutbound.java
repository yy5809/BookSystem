package com.ruoyi.textbook.domain;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

public class TbOutbound extends BaseEntity {
    private static final long serialVersionUID = 1L;

    private Long outId;
    private String outboundNo;
    private Long buyId;
    private String purchaseNo;
    private Long bookId;
    private String bookName;
    private String isbn;

    @Excel(name = "出库数量")
    private Integer outNum;

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @Excel(name = "出库时间", width = 30, dateFormat = "yyyy-MM-dd HH:mm:ss")
    private Date outTime;

    @Excel(name = "领书人ID")
    private Long receiveId;

    @Excel(name = "领书人")
    private String userName;

    @Excel(name = "部门")
    private String deptName;

    @Excel(name = "操作人ID")
    private Long operatorId;
    private String outReason;

    private String operatorName;

    private String remark;
    private String delFlag;

    public Long getOutId() { return outId; }
    public void setOutId(Long outId) { this.outId = outId; }
    public String getOutboundNo() { return outboundNo; }
    public void setOutboundNo(String outboundNo) { this.outboundNo = outboundNo; }
    public Long getBuyId() { return buyId; }
    public void setBuyId(Long buyId) { this.buyId = buyId; }
    public String getPurchaseNo() { return purchaseNo; }
    public void setPurchaseNo(String purchaseNo) { this.purchaseNo = purchaseNo; }
    public Long getBookId() { return bookId; }
    public void setBookId(Long bookId) { this.bookId = bookId; }
    public String getBookName() { return bookName; }
    public void setBookName(String bookName) { this.bookName = bookName; }
    public String getIsbn() { return isbn; }
    public void setIsbn(String isbn) { this.isbn = isbn; }
    public Integer getOutNum() { return outNum; }
    public void setOutNum(Integer outNum) { this.outNum = outNum; }
    public Date getOutTime() { return outTime; }
    public void setOutTime(Date outTime) { this.outTime = outTime; }
    public Long getReceiveId() { return receiveId; }
    public void setReceiveId(Long receiveId) { this.receiveId = receiveId; }
    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }
    public String getDeptName() { return deptName; }
    public void setDeptName(String deptName) { this.deptName = deptName; }
    public Long getOperatorId() { return operatorId; }
    public void setOperatorId(Long operatorId) { this.operatorId = operatorId; }
    public String getOutReason() { return outReason; }
    public void setOutReason(String outReason) { this.outReason = outReason; }
    public String getOperatorName() { return operatorName; }
    public void setOperatorName(String operatorName) { this.operatorName = operatorName; }
    public String getRemark() { return remark; }
    public void setRemark(String remark) { this.remark = remark; }
    public String getDelFlag() { return delFlag; }
    public void setDelFlag(String delFlag) { this.delFlag = delFlag; }

    @Override
    public String toString() {
        return new org.apache.commons.lang3.builder.ToStringBuilder(this, org.apache.commons.lang3.builder.ToStringStyle.MULTI_LINE_STYLE)
            .append("outId", outId).append("outboundNo", outboundNo)
            .append("buyId", buyId).append("purchaseNo", purchaseNo)
            .append("bookId", bookId).append("bookName", bookName)
            .append("outNum", outNum).append("outTime", outTime)
            .append("userName", userName).append("deptName", deptName)
            .append("operatorName", operatorName).toString();
    }
}
