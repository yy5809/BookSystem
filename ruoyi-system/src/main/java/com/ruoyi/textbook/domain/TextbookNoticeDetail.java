package com.ruoyi.textbook.domain;

import com.ruoyi.common.core.domain.BaseEntity;

public class TextbookNoticeDetail extends BaseEntity {
    private Long detailId;
    private Long noticeId;
    private Long textbookId;
    private String isbn;
    private String bookName;
    private Integer plannedQty;
    private Long collegeId;
    private Long majorId;
    private Long classId;
    private String className;
    private String gradeLevel;
    private String delFlag;

    public Long getDetailId() { return detailId; }
    public void setDetailId(Long detailId) { this.detailId = detailId; }
    public Long getNoticeId() { return noticeId; }
    public void setNoticeId(Long noticeId) { this.noticeId = noticeId; }
    public Long getTextbookId() { return textbookId; }
    public void setTextbookId(Long textbookId) { this.textbookId = textbookId; }
    public String getIsbn() { return isbn; }
    public void setIsbn(String isbn) { this.isbn = isbn; }
    public String getBookName() { return bookName; }
    public void setBookName(String bookName) { this.bookName = bookName; }
    public Integer getPlannedQty() { return plannedQty; }
    public void setPlannedQty(Integer plannedQty) { this.plannedQty = plannedQty; }
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
    public String getDelFlag() { return delFlag; }
    public void setDelFlag(String delFlag) { this.delFlag = delFlag; }
}
