package com.ruoyi.textbook.domain;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

public class TbShortage extends BaseEntity {
    private static final long serialVersionUID = 1L;

    private Long lackId;
    private Long bookId;

    @Excel(name = "教材名称")
    private String bookName;

    @Excel(name = "ISBN")
    private String isbn;

    @Excel(name = "缺书数量")
    private Integer lackNum;

    @Excel(name = "紧急程度", readConverterExp="0=普通,1=紧急")
    private String urgency;

    @Excel(name = "登记人ID")
    private Long registerId;

    @Excel(name = "登记人姓名")
    private String registerName;

    @Excel(name = "处理状态", readConverterExp = "0=未处理,1=已纳入采购,2=已到货,3=已完成")
    private String handleStatus;

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date handleTime;

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @Excel(name = "登记时间", width = 30, dateFormat = "yyyy-MM-dd HH:mm:ss")
    private Date registerTime;

    @Excel(name = "来源购书单ID")
    private Long purchaseId;

    @Excel(name = "缺书来源", readConverterExp = "1=领书缺货,2=库存预警")
    private String source;

    @Excel(name = "来源记录ID")
    private Long sourceId;

    @Excel(name = "备注")
    private String remark;

    private String delFlag;

    public Long getLackId() { return lackId; }
    public void setLackId(Long lackId) { this.lackId = lackId; }
    public Long getBookId() { return bookId; }
    public void setBookId(Long bookId) { this.bookId = bookId; }
    public String getBookName() { return bookName; }
    public void setBookName(String bookName) { this.bookName = bookName; }
    public String getIsbn() { return isbn; }
    public void setIsbn(String isbn) { this.isbn = isbn; }
    public Integer getLackNum() { return lackNum; }
    public void setLackNum(Integer lackNum) { this.lackNum = lackNum; }
    public String getUrgency() { return urgency; }
    public void setUrgency(String urgency) { this.urgency = urgency; }
    public Long getRegisterId() { return registerId; }
    public void setRegisterId(Long registerId) { this.registerId = registerId; }
    public String getRegisterName() { return registerName; }
    public void setRegisterName(String registerName) { this.registerName = registerName; }
    public String getHandleStatus() { return handleStatus; }
    public void setHandleStatus(String handleStatus) { this.handleStatus = handleStatus; }
    public Date getHandleTime() { return handleTime; }
    public void setHandleTime(Date handleTime) { this.handleTime = handleTime; }
    public Date getRegisterTime() { return registerTime; }
    public void setRegisterTime(Date registerTime) { this.registerTime = registerTime; }
    public Long getPurchaseId() { return purchaseId; }
    public void setPurchaseId(Long purchaseId) { this.purchaseId = purchaseId; }
    public String getSource() { return source; }
    public void setSource(String source) { this.source = source; }
    public Long getSourceId() { return sourceId; }
    public void setSourceId(Long sourceId) { this.sourceId = sourceId; }
    public String getRemark() { return remark; }
    public void setRemark(String remark) { this.remark = remark; }
    public String getDelFlag() { return delFlag; }
    public void setDelFlag(String delFlag) { this.delFlag = delFlag; }

    @Override
    public String toString() {
        return new org.apache.commons.lang3.builder.ToStringBuilder(this, org.apache.commons.lang3.builder.ToStringStyle.MULTI_LINE_STYLE)
            .append("lackId", lackId).append("lackNum", lackNum)
            .append("handleStatus", handleStatus).toString();
    }
}