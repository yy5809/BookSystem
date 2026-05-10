package com.ruoyi.textbook.domain.dto;

import com.ruoyi.common.annotation.Excel;
import javax.validation.constraints.Max;
import javax.validation.constraints.Min;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.Pattern;
import javax.validation.constraints.Size;

public class TbPurchaseImportDTO {

    @Excel(name = "ISBN", sort = 0, width = 20)
    @NotBlank(message = "ISBN不能为空")
    @Pattern(regexp = "^(\\d{10}|\\d{13})$", message = "ISBN格式错误，必须为10位或13位数字")
    private String isbn;

    @Excel(name = "教材名称", sort = 1, width = 30)
    @NotBlank(message = "教材名称不能为空")
    @Size(max = 200, message = "教材名称长度不能超过200")
    private String bookName;

    @Excel(name = "版次", sort = 2, width = 10)
    private String edition;

    @Excel(name = "作者", sort = 3, width = 15)
    private String author;

    @Excel(name = "出版社", sort = 4, width = 20)
    private String publisher;

    @Excel(name = "定价", sort = 5, width = 10)
    private java.math.BigDecimal price;

    @Excel(name = "教材类型", sort = 6, width = 15)
    private String textbookType;

    @Excel(name = "申请学院", sort = 7, width = 15)
    @NotBlank(message = "申请学院不能为空")
    private String college;

    @Excel(name = "适用专业", sort = 8, width = 15)
    @NotBlank(message = "适用专业不能为空")
    private String major;

    @Excel(name = "适用年级", sort = 9, width = 20)
    private String grade;

    @Excel(name = "采购数量", sort = 10, width = 12)
    @Min(value = 1, message = "采购数量必须大于0")
    @Max(value = 9999, message = "采购数量不能超过9999")
    private Integer quantity;

    @Excel(name = "备注", sort = 11, width = 30)
    private String remark;

    private int rowIndex;

    private String errorMsg;

    public String getIsbn() { return isbn; }
    public void setIsbn(String isbn) { this.isbn = isbn; }
    public String getBookName() { return bookName; }
    public void setBookName(String bookName) { this.bookName = bookName; }
    public String getEdition() { return edition; }
    public void setEdition(String edition) { this.edition = edition; }
    public Integer getQuantity() { return quantity; }
    public void setQuantity(Integer quantity) { this.quantity = quantity; }
    public String getCollege() { return college; }
    public void setCollege(String college) { this.college = college; }
    public String getMajor() { return major; }
    public void setMajor(String major) { this.major = major; }
    public String getGrade() { return grade; }
    public void setGrade(String grade) { this.grade = grade; }
    public String getRemark() { return remark; }
    public void setRemark(String remark) { this.remark = remark; }
    public String getAuthor() { return author; }
    public void setAuthor(String author) { this.author = author; }
    public String getPublisher() { return publisher; }
    public void setPublisher(String publisher) { this.publisher = publisher; }
    public java.math.BigDecimal getPrice() { return price; }
    public void setPrice(java.math.BigDecimal price) { this.price = price; }
    public String getTextbookType() { return textbookType; }
    public void setTextbookType(String textbookType) { this.textbookType = textbookType; }
    public int getRowIndex() { return rowIndex; }
    public void setRowIndex(int rowIndex) { this.rowIndex = rowIndex; }
    public String getErrorMsg() { return errorMsg; }
    public void setErrorMsg(String errorMsg) { this.errorMsg = errorMsg; }

    public boolean isValidRow() {
        return isbn != null && !isbn.trim().isEmpty()
            || bookName != null && !bookName.trim().isEmpty();
    }
}
