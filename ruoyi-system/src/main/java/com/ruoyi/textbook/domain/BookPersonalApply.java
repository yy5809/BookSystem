package com.ruoyi.textbook.domain;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.ruoyi.common.core.domain.BaseEntity;

public class BookPersonalApply extends BaseEntity {
    private static final long serialVersionUID = 1L;

    private Long applyId;
    private String applyNo;
    private Long teacherId;
    private String teacherName;
    private Long textbookId;
    private String isbn;
    private String bookName;
    private Integer applyQty;
    private String purpose;
    private String status;
    private String auditOpinion;
    private String auditBy;

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date auditTime;

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date issueTime;

    private String delFlag;
    private String remark;
    private Boolean registerShortage;
    private Integer shortageQty;
    private String shortageUrgency;
    private String shortageRemark;

    public Long getApplyId() { return applyId; }
    public void setApplyId(Long applyId) { this.applyId = applyId; }
    public String getApplyNo() { return applyNo; }
    public void setApplyNo(String applyNo) { this.applyNo = applyNo; }
    public Long getTeacherId() { return teacherId; }
    public void setTeacherId(Long teacherId) { this.teacherId = teacherId; }
    public String getTeacherName() { return teacherName; }
    public void setTeacherName(String teacherName) { this.teacherName = teacherName; }
    public Long getTextbookId() { return textbookId; }
    public void setTextbookId(Long textbookId) { this.textbookId = textbookId; }
    public String getIsbn() { return isbn; }
    public void setIsbn(String isbn) { this.isbn = isbn; }
    public String getBookName() { return bookName; }
    public void setBookName(String bookName) { this.bookName = bookName; }
    public Integer getApplyQty() { return applyQty; }
    public void setApplyQty(Integer applyQty) { this.applyQty = applyQty; }
    public String getPurpose() { return purpose; }
    public void setPurpose(String purpose) { this.purpose = purpose; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getAuditOpinion() { return auditOpinion; }
    public void setAuditOpinion(String auditOpinion) { this.auditOpinion = auditOpinion; }
    public String getAuditBy() { return auditBy; }
    public void setAuditBy(String auditBy) { this.auditBy = auditBy; }
    public Date getAuditTime() { return auditTime; }
    public void setAuditTime(Date auditTime) { this.auditTime = auditTime; }
    public Date getIssueTime() { return issueTime; }
    public void setIssueTime(Date issueTime) { this.issueTime = issueTime; }
    public String getDelFlag() { return delFlag; }
    public void setDelFlag(String delFlag) { this.delFlag = delFlag; }
    public String getRemark() { return remark; }
    public void setRemark(String remark) { this.remark = remark; }
    public Boolean getRegisterShortage() { return registerShortage; }
    public void setRegisterShortage(Boolean registerShortage) { this.registerShortage = registerShortage; }
    public Integer getShortageQty() { return shortageQty; }
    public void setShortageQty(Integer shortageQty) { this.shortageQty = shortageQty; }
    public String getShortageUrgency() { return shortageUrgency; }
    public void setShortageUrgency(String shortageUrgency) { this.shortageUrgency = shortageUrgency; }
    public String getShortageRemark() { return shortageRemark; }
    public void setShortageRemark(String shortageRemark) { this.shortageRemark = shortageRemark; }
}
