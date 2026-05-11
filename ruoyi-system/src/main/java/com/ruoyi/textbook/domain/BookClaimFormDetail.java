package com.ruoyi.textbook.domain;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;
import java.math.BigDecimal;

public class BookClaimFormDetail extends BaseEntity {
    private static final long serialVersionUID = 1L;

    private Long detailId;

    private Long formId;

    private Long textbookId;

    @Excel(name = "ISBN")
    private String isbn;

    @Excel(name = "教材名称")
    private String bookName;

    @Excel(name = "作者")
    private String author;

    @Excel(name = "出版社")
    private String publisher;

    @Excel(name = "定价")
    private BigDecimal price;

    @Excel(name = "应发数量")
    private Integer plannedQty;

    @Excel(name = "实发数量")
    private Integer issuedQty;

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @Excel(name = "创建时间", width = 30, dateFormat = "yyyy-MM-dd HH:mm:ss")
    private Date createTime;

    private Long collegeId;

    private Long majorId;

    private Long classId;

    private String className;

    private String gradeLevel;

    public Long getDetailId() { return detailId; }
    public void setDetailId(Long detailId) { this.detailId = detailId; }
    public Long getFormId() { return formId; }
    public void setFormId(Long formId) { this.formId = formId; }
    public Long getTextbookId() { return textbookId; }
    public void setTextbookId(Long textbookId) { this.textbookId = textbookId; }
    public String getIsbn() { return isbn; }
    public void setIsbn(String isbn) { this.isbn = isbn; }
    public String getBookName() { return bookName; }
    public void setBookName(String bookName) { this.bookName = bookName; }
    public String getAuthor() { return author; }
    public void setAuthor(String author) { this.author = author; }
    public String getPublisher() { return publisher; }
    public void setPublisher(String publisher) { this.publisher = publisher; }
    public BigDecimal getPrice() { return price; }
    public void setPrice(BigDecimal price) { this.price = price; }
    public Integer getPlannedQty() { return plannedQty; }
    public void setPlannedQty(Integer plannedQty) { this.plannedQty = plannedQty; }
    public Integer getIssuedQty() { return issuedQty; }
    public void setIssuedQty(Integer issuedQty) { this.issuedQty = issuedQty; }
    public Date getCreateTime() { return createTime; }
    public void setCreateTime(Date createTime) { this.createTime = createTime; }

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

    @Override
    public String toString() {
        return new org.apache.commons.lang3.builder.ToStringBuilder(this, org.apache.commons.lang3.builder.ToStringStyle.MULTI_LINE_STYLE)
            .append("detailId", detailId).append("formId", formId)
            .append("bookName", bookName).append("plannedQty", plannedQty).toString();
    }
}
