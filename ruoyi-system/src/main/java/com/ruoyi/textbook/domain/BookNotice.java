package com.ruoyi.textbook.domain;

import java.util.Date;
import java.util.List;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;
import com.ruoyi.textbook.domain.BookClaimFormDetail;

public class BookNotice extends BaseEntity {
    private static final long serialVersionUID = 1L;

    private Long noticeId;

    @Excel(name = "通知编号")
    private String noticeNo;

    @Excel(name = "学期")
    private String semester;

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @Excel(name = "领取开始时间", width = 30, dateFormat = "yyyy-MM-dd HH:mm:ss")
    private Date pickupStart;

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @Excel(name = "领取结束时间", width = 30, dateFormat = "yyyy-MM-dd HH:mm:ss")
    private Date pickupEnd;

    @Excel(name = "领取地点")
    private String pickupLocation;

    @Excel(name = "状态", readConverterExp = "0=草稿,1=已发布,2=领取中,3=已完成,4=已作废")
    private String status;

    @Excel(name = "班级总数")
    private Integer totalClasses;

    @Excel(name = "已出库班级数")
    private Integer issuedClasses;

    @Excel(name = "备注")
    private String remark;

    private String delFlag;

    private String cancelReason;

    private String cancelBy;

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date cancelTime;

    private List<BookClaimFormDetail> details;

    public Long getNoticeId() { return noticeId; }
    public void setNoticeId(Long noticeId) { this.noticeId = noticeId; }
    public String getNoticeNo() { return noticeNo; }
    public void setNoticeNo(String noticeNo) { this.noticeNo = noticeNo; }
    public String getSemester() { return semester; }
    public void setSemester(String semester) { this.semester = semester; }
    public Date getPickupStart() { return pickupStart; }
    public void setPickupStart(Date pickupStart) { this.pickupStart = pickupStart; }
    public Date getPickupEnd() { return pickupEnd; }
    public void setPickupEnd(Date pickupEnd) { this.pickupEnd = pickupEnd; }
    public String getPickupLocation() { return pickupLocation; }
    public void setPickupLocation(String pickupLocation) { this.pickupLocation = pickupLocation; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public Integer getTotalClasses() { return totalClasses; }
    public void setTotalClasses(Integer totalClasses) { this.totalClasses = totalClasses; }
    public Integer getIssuedClasses() { return issuedClasses; }
    public void setIssuedClasses(Integer issuedClasses) { this.issuedClasses = issuedClasses; }
    public String getRemark() { return remark; }
    public void setRemark(String remark) { this.remark = remark; }
    public String getDelFlag() { return delFlag; }
    public void setDelFlag(String delFlag) { this.delFlag = delFlag; }

    public String getCancelReason() { return cancelReason; }
    public void setCancelReason(String cancelReason) { this.cancelReason = cancelReason; }
    public String getCancelBy() { return cancelBy; }
    public void setCancelBy(String cancelBy) { this.cancelBy = cancelBy; }
    public Date getCancelTime() { return cancelTime; }
    public void setCancelTime(Date cancelTime) { this.cancelTime = cancelTime; }

    public List<BookClaimFormDetail> getDetails() { return details; }
    public void setDetails(List<BookClaimFormDetail> details) { this.details = details; }

    @Override
    public String toString() {
        return new org.apache.commons.lang3.builder.ToStringBuilder(this, org.apache.commons.lang3.builder.ToStringStyle.MULTI_LINE_STYLE)
            .append("noticeId", noticeId).append("noticeNo", noticeNo)
            .append("semester", semester).append("status", status).toString();
    }
}
