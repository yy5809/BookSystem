package com.ruoyi.textbook.domain;

import java.math.BigDecimal;
import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;

/**
 * 待购教材对象 tb_pending_purchase
 * 
 * @author ruoyi
 */
public class TbPendingPurchase extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 待购ID */
    private Long pendingId;

    /** 待购单编号 */
    @Excel(name = "待购单编号")
    private String pendingNo;

    /** 缺书单ID */
    private Long shortageId;

    /** 教材ID */
    @Excel(name = "教材ID")
    private Long bookId;

    /** 教材名称 */
    @Excel(name = "教材名称")
    private String bookName;

    /** ISBN编号 */
    @Excel(name = "ISBN编号")
    private String isbn;

    /** 作者 */
    @Excel(name = "作者")
    private String author;

    /** 出版社 */
    @Excel(name = "出版社")
    private String publisher;

    /** 预估价格 */
    @Excel(name = "预估价格")
    private BigDecimal price;

    /** 采购数量 */
    @Excel(name = "采购数量")
    private Integer purchaseQuantity;

    /** 状态(0待采购 1采购中 2已到货) */
    @Excel(name = "状态", readConverterExp = "0=待采购,1=采购中,2=已到货")
    private String status;

    /** 供应商 */
    @Excel(name = "供应商")
    private String supplier;

    /** 预计到货日期 */
    @JsonFormat(pattern = "yyyy-MM-dd")
    @Excel(name = "预计到货日期", width = 30, dateFormat = "yyyy-MM-dd")
    private Date expectedDate;

    /** 删除标志(0存在 1删除) */
    private String delFlag;

    public void setPendingId(Long pendingId) 
    {
        this.pendingId = pendingId;
    }

    public Long getPendingId() 
    {
        return pendingId;
    }

    public void setPendingNo(String pendingNo) 
    {
        this.pendingNo = pendingNo;
    }

    public String getPendingNo() 
    {
        return pendingNo;
    }

    public void setShortageId(Long shortageId) 
    {
        this.shortageId = shortageId;
    }

    public Long getShortageId() 
    {
        return shortageId;
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

    public void setPrice(BigDecimal price) 
    {
        this.price = price;
    }

    public BigDecimal getPrice() 
    {
        return price;
    }

    public void setPurchaseQuantity(Integer purchaseQuantity) 
    {
        this.purchaseQuantity = purchaseQuantity;
    }

    public Integer getPurchaseQuantity() 
    {
        return purchaseQuantity;
    }

    public void setStatus(String status) 
    {
        this.status = status;
    }

    public String getStatus() 
    {
        return status;
    }

    public void setSupplier(String supplier) 
    {
        this.supplier = supplier;
    }

    public String getSupplier() 
    {
        return supplier;
    }

    public void setExpectedDate(Date expectedDate) 
    {
        this.expectedDate = expectedDate;
    }

    public Date getExpectedDate() 
    {
        return expectedDate;
    }

    public void setDelFlag(String delFlag) 
    {
        this.delFlag = delFlag;
    }

    public String getDelFlag() 
    {
        return delFlag;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this, ToStringStyle.MULTI_LINE_STYLE)
            .append("pendingId", getPendingId())
            .append("pendingNo", getPendingNo())
            .append("shortageId", getShortageId())
            .append("bookId", getBookId())
            .append("bookName", getBookName())
            .append("isbn", getIsbn())
            .append("author", getAuthor())
            .append("publisher", getPublisher())
            .append("price", getPrice())
            .append("purchaseQuantity", getPurchaseQuantity())
            .append("status", getStatus())
            .append("supplier", getSupplier())
            .append("expectedDate", getExpectedDate())
            .append("remark", getRemark())
            .append("createBy", getCreateBy())
            .append("createTime", getCreateTime())
            .append("updateBy", getUpdateBy())
            .append("updateTime", getUpdateTime())
            .append("delFlag", getDelFlag())
            .toString();
    }
}
