package com.ruoyi.textbook.domain;

import java.math.BigDecimal;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;

/**
 * 购书明细信息对象 tb_purchase_detail
 * 
 * @author ruoyi
 */
public class TbPurchaseDetail extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 明细ID */
    private Long detailId;

    /** 购书ID */
    @Excel(name = "购书ID")
    private Long purchaseId;

    /** 教材ID */
    @Excel(name = "教材ID")
    private Long bookId;

    /** 教材名称 */
    @Excel(name = "教材名称")
    private String bookName;

    /** ISBN编号 */
    @Excel(name = "ISBN编号")
    private String isbn;

    /** 数量 */
    @Excel(name = "数量")
    private Integer quantity;

    /** 单价 */
    @Excel(name = "单价")
    private BigDecimal unitPrice;

    /** 总价 */
    @Excel(name = "总价")
    private BigDecimal totalPrice;

    /** 作者 */
    @Excel(name = "作者")
    private String author;

    /** 出版社 */
    @Excel(name = "出版社")
    private String publisher;

    /** 版次 */
    @Excel(name = "版次")
    private String edition;

    /** 教材类型 */
    @Excel(name = "教材类型")
    private String textbookType;

    /** 申请学院 */
    @Excel(name = "申请学院")
    private String college;

    /** 适用专业 */
    @Excel(name = "适用专业")
    private String major;

    /** 适用年级 */
    @Excel(name = "适用年级")
    private String grade;

    // remark inherited from BaseEntity

    public void setDetailId(Long detailId)
    {
        this.detailId = detailId;
    }

    public Long getDetailId()
    {
        return detailId;
    }

    public void setPurchaseId(Long purchaseId)
    {
        this.purchaseId = purchaseId;
    }

    public Long getPurchaseId()
    {
        return purchaseId;
    }

    public void setBookId(Long bookId)
    {
        this.bookId = bookId;
    }

    public Long getBookId()
    {
        return bookId;
    }

    public void setBookName(String bookName)
    {
        this.bookName = bookName;
    }

    public String getBookName()
    {
        return bookName;
    }

    public void setIsbn(String isbn)
    {
        this.isbn = isbn;
    }

    public String getIsbn()
    {
        return isbn;
    }

    public void setQuantity(Integer quantity)
    {
        this.quantity = quantity;
    }

    public Integer getQuantity()
    {
        return quantity;
    }

    public void setUnitPrice(BigDecimal unitPrice)
    {
        this.unitPrice = unitPrice;
    }

    public BigDecimal getUnitPrice()
    {
        return unitPrice;
    }

    public void setTotalPrice(BigDecimal totalPrice)
    {
        this.totalPrice = totalPrice;
    }

    public BigDecimal getTotalPrice()
    {
        return totalPrice;
    }

    public void setAuthor(String author)
    {
        this.author = author;
    }

    public String getAuthor()
    {
        return author;
    }

    public void setPublisher(String publisher)
    {
        this.publisher = publisher;
    }

    public String getPublisher()
    {
        return publisher;
    }

    public void setEdition(String edition) { this.edition = edition; }
    public String getEdition() { return edition; }
    public void setTextbookType(String textbookType) { this.textbookType = textbookType; }
    public String getTextbookType() { return textbookType; }
    public void setCollege(String college) { this.college = college; }
    public String getCollege() { return college; }
    public void setMajor(String major) { this.major = major; }
    public String getMajor() { return major; }
    public void setGrade(String grade) { this.grade = grade; }
    public String getGrade() { return grade; }

    @Override
    public String toString() {
        return new ToStringBuilder(this, ToStringStyle.MULTI_LINE_STYLE)
            .append("detailId", getDetailId())
            .append("purchaseId", getPurchaseId())
            .append("bookId", getBookId())
            .append("bookName", getBookName())
            .append("isbn", getIsbn())
            .append("quantity", getQuantity())
            .append("unitPrice", getUnitPrice())
            .append("totalPrice", getTotalPrice())
            .append("author", getAuthor())
            .append("publisher", getPublisher())
            .append("edition", getEdition())
            .append("textbookType", getTextbookType())
            .append("college", getCollege())
            .append("major", getMajor())
            .append("grade", getGrade())
            .toString();
    }
}