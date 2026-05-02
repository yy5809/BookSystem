package com.ruoyi.textbook.domain;

import java.math.BigDecimal;
import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;

public class TbBook extends BaseEntity {
    private static final long serialVersionUID = 1L;

    private Long bookId;

    @Excel(name = "ISBN", sort = 0, width = 20)
    private String isbn;

    @Excel(name = "教材名称", sort = 1, width = 30)
    private String bookName;

    @Excel(name = "作者", sort = 2, width = 15)
    private String author;

    @Excel(name = "出版社", sort = 3, width = 20)
    private String publisher;

    @JsonFormat(pattern = "yyyy-MM-dd")
    @Excel(name = "出版日期", sort = 4, width = 15, dateFormat = "yyyy-MM-dd")
    private Date publishDate;

    @Excel(name = "版次", sort = 5, width = 10)
    private String edition;
    private String printTimes;
    private String format;
    private String binding;

    @Excel(name = "定价", sort = 6)
    private BigDecimal price;

    @Excel(name = "字数", sort = 7)
    private Integer wordCount;

    @Excel(name = "页数", sort = 8)
    private Integer pageCount;

    @Excel(name = "适用课程", sort = 9)
    private String courseName;

    @Excel(name = "适用专业", sort = 10)
    private String major;

    @Excel(name = "适用年级", sort = 11)
    private String grade;

    @Excel(name = "教材类型", sort = 12)
    private String textbookType;

    @Excel(name = "分类", sort = 13)
    private String category;
    private String description;
    private String coverImage;

    @Excel(name = "状态", sort = 14, readConverterExp = "0=正常,1=停用")
    private String status;
    private String delFlag;

    @Excel(name = "信息状态", sort = 15, readConverterExp = "0=待完善,1=已完善")
    private String infoStatus;

    private String infoSource;

    public Long getBookId() { return bookId; }
    public void setBookId(Long bookId) { this.bookId = bookId; }
    public String getBookName() { return bookName; }
    public void setBookName(String bookName) { this.bookName = bookName; }
    public String getIsbn() { return isbn; }
    public void setIsbn(String isbn) { this.isbn = isbn; }
    public String getAuthor() { return author; }
    public void setAuthor(String author) { this.author = author; }
    public String getPublisher() { return publisher; }
    public void setPublisher(String publisher) { this.publisher = publisher; }
    public Date getPublishDate() { return publishDate; }
    public void setPublishDate(Date publishDate) { this.publishDate = publishDate; }
    public String getEdition() { return edition; }
    public void setEdition(String edition) { this.edition = edition; }
    public String getPrintTimes() { return printTimes; }
    public void setPrintTimes(String printTimes) { this.printTimes = printTimes; }
    public String getFormat() { return format; }
    public void setFormat(String format) { this.format = format; }
    public String getBinding() { return binding; }
    public void setBinding(String binding) { this.binding = binding; }
    public BigDecimal getPrice() { return price; }
    public void setPrice(BigDecimal price) { this.price = price; }
    public Integer getWordCount() { return wordCount; }
    public void setWordCount(Integer wordCount) { this.wordCount = wordCount; }
    public Integer getPageCount() { return pageCount; }
    public void setPageCount(Integer pageCount) { this.pageCount = pageCount; }
    public String getCourseName() { return courseName; }
    public void setCourseName(String courseName) { this.courseName = courseName; }
    public String getMajor() { return major; }
    public void setMajor(String major) { this.major = major; }
    public String getGrade() { return grade; }
    public void setGrade(String grade) { this.grade = grade; }
    public String getTextbookType() { return textbookType; }
    public void setTextbookType(String textbookType) { this.textbookType = textbookType; }
    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public String getCoverImage() { return coverImage; }
    public void setCoverImage(String coverImage) { this.coverImage = coverImage; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getDelFlag() { return delFlag; }
    public void setDelFlag(String delFlag) { this.delFlag = delFlag; }
    public String getInfoStatus() { return infoStatus; }
    public void setInfoStatus(String infoStatus) { this.infoStatus = infoStatus; }
    public String getInfoSource() { return infoSource; }
    public void setInfoSource(String infoSource) { this.infoSource = infoSource; }

    public boolean isInfoComplete() { return "1".equals(this.infoStatus); }
    public boolean isInfoIncomplete() { return "0".equals(this.infoStatus); }

    @Override
    public String toString() {
        return new ToStringBuilder(this, ToStringStyle.MULTI_LINE_STYLE)
            .append("bookId", bookId).append("bookName", bookName)
            .append("isbn", isbn).append("author", author)
            .append("publisher", publisher).append("price", price)
            .append("textbookType", textbookType).append("status", status).toString();
    }
}
