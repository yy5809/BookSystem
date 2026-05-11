package com.ruoyi.textbook.domain.dto;

import com.ruoyi.common.annotation.Excel;

public class TbBookImportDTO {

    @Excel(name = "ISBN", sort = 0, width = 20)
    private String isbn;

    @Excel(name = "教材名称", sort = 1, width = 30)
    private String bookName;

    @Excel(name = "作者", sort = 2, width = 15)
    private String author;

    @Excel(name = "出版社", sort = 3, width = 20)
    private String publisher;

    @Excel(name = "版次", sort = 4, width = 10)
    private String edition;

    @Excel(name = "定价", sort = 5, width = 10)
    private String price;

    @Excel(name = "教材类型", sort = 6, width = 12)
    private String textbookType;

    @Excel(name = "适用课程", sort = 7, width = 15)
    private String courseName;

    @Excel(name = "适用专业", sort = 8, width = 15)
    private String major;

    @Excel(name = "入学年份（级）", sort = 9, width = 10)
    private String grade;

    private int rowIndex;
    private String errorMsg;

    public String getIsbn() { return isbn; }
    public void setIsbn(String isbn) { this.isbn = isbn; }
    public String getBookName() { return bookName; }
    public void setBookName(String bookName) { this.bookName = bookName; }
    public String getAuthor() { return author; }
    public void setAuthor(String author) { this.author = author; }
    public String getPublisher() { return publisher; }
    public void setPublisher(String publisher) { this.publisher = publisher; }
    public String getEdition() { return edition; }
    public void setEdition(String edition) { this.edition = edition; }
    public String getPrice() { return price; }
    public void setPrice(String price) { this.price = price; }
    public String getTextbookType() { return textbookType; }
    public void setTextbookType(String textbookType) { this.textbookType = textbookType; }
    public String getCourseName() { return courseName; }
    public void setCourseName(String courseName) { this.courseName = courseName; }
    public String getMajor() { return major; }
    public void setMajor(String major) { this.major = major; }
    public String getGrade() { return grade; }
    public void setGrade(String grade) { this.grade = grade; }
    public int getRowIndex() { return rowIndex; }
    public void setRowIndex(int rowIndex) { this.rowIndex = rowIndex; }
    public String getErrorMsg() { return errorMsg; }
    public void setErrorMsg(String errorMsg) { this.errorMsg = errorMsg; }
}
