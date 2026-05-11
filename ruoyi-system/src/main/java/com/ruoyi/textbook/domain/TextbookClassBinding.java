package com.ruoyi.textbook.domain;

import com.ruoyi.common.core.domain.BaseEntity;

public class TextbookClassBinding extends BaseEntity {
    private static final long serialVersionUID = 1L;

    private Long bindingId;
    private String semester;
    private String college;
    private String major;
    private String className;
    private Long bookId;
    private String isbn;
    private String bookName;
    private Integer plannedQty;
    private String source;
    private Long pendingId;

    public Long getBindingId() { return bindingId; }
    public void setBindingId(Long bindingId) { this.bindingId = bindingId; }

    public String getSemester() { return semester; }
    public void setSemester(String semester) { this.semester = semester; }

    public String getCollege() { return college; }
    public void setCollege(String college) { this.college = college; }

    public String getMajor() { return major; }
    public void setMajor(String major) { this.major = major; }

    public String getClassName() { return className; }
    public void setClassName(String className) { this.className = className; }

    public Long getBookId() { return bookId; }
    public void setBookId(Long bookId) { this.bookId = bookId; }

    public String getIsbn() { return isbn; }
    public void setIsbn(String isbn) { this.isbn = isbn; }

    public String getBookName() { return bookName; }
    public void setBookName(String bookName) { this.bookName = bookName; }

    public Integer getPlannedQty() { return plannedQty; }
    public void setPlannedQty(Integer plannedQty) { this.plannedQty = plannedQty; }

    public String getSource() { return source; }
    public void setSource(String source) { this.source = source; }

    public Long getPendingId() { return pendingId; }
    public void setPendingId(Long pendingId) { this.pendingId = pendingId; }
}
