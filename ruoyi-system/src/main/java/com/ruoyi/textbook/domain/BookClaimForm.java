package com.ruoyi.textbook.domain;

import java.util.Date;
import java.util.List;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

public class BookClaimForm extends BaseEntity {
    private static final long serialVersionUID = 1L;

    private Long formId;

    @Excel(name = "领书单号")
    private String formNo;

    private Long noticeId;

    private Long collegeId;

    private Long majorId;

    private Long classId;

    @Excel(name = "班级名称")
    private String className;

    @Excel(name = "学业阶段")
    private String gradeLevel;

    @Excel(name = "状态", readConverterExp = "0=待领取,1=部分出库,2=已出库")
    private String status;

    @Excel(name = "应发总数")
    private Integer plannedQty;

    @Excel(name = "实发总数")
    private Integer issuedQty;

    @Excel(name = "领书人")
    private String receiverName;

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @Excel(name = "出库时间", width = 30, dateFormat = "yyyy-MM-dd HH:mm:ss")
    private Date issueTime;

    @Excel(name = "备注")
    private String remark;

    private String delFlag;

    private List<BookClaimFormDetail> details;

    public Long getFormId() { return formId; }
    public void setFormId(Long formId) { this.formId = formId; }
    public String getFormNo() { return formNo; }
    public void setFormNo(String formNo) { this.formNo = formNo; }
    public Long getNoticeId() { return noticeId; }
    public void setNoticeId(Long noticeId) { this.noticeId = noticeId; }
    public Long getCollegeId() { return collegeId; }
    public void setCollegeId(Long collegeId) { this.collegeId = collegeId; }
    public Long getMajorId() { return majorId; }
    public void setMajorId(Long majorId) { this.majorId = majorId; }
    public Long getClassId() { return classId; }
    public void setClassId(Long classId) { this.classId = classId; }
    public String getClassName() { return className; }
    public void setClassName(String className) { this.className = className; }
    public String getGradeLevel() { return gradeLevel; }
    public void setGradeLevel(String gradeLevel) { this.gradeLevel = gradeLevel; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public Integer getPlannedQty() { return plannedQty; }
    public void setPlannedQty(Integer plannedQty) { this.plannedQty = plannedQty; }
    public Integer getIssuedQty() { return issuedQty; }
    public void setIssuedQty(Integer issuedQty) { this.issuedQty = issuedQty; }
    public String getReceiverName() { return receiverName; }
    public void setReceiverName(String receiverName) { this.receiverName = receiverName; }
    public Date getIssueTime() { return issueTime; }
    public void setIssueTime(Date issueTime) { this.issueTime = issueTime; }
    public String getRemark() { return remark; }
    public void setRemark(String remark) { this.remark = remark; }
    public String getDelFlag() { return delFlag; }
    public void setDelFlag(String delFlag) { this.delFlag = delFlag; }
    public List<BookClaimFormDetail> getDetails() { return details; }
    public void setDetails(List<BookClaimFormDetail> details) { this.details = details; }

    @Override
    public String toString() {
        return new org.apache.commons.lang3.builder.ToStringBuilder(this, org.apache.commons.lang3.builder.ToStringStyle.MULTI_LINE_STYLE)
            .append("formId", formId).append("formNo", formNo)
            .append("className", className).append("status", status).toString();
    }
}
