package com.ruoyi.textbook.domain;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

public class TbInventory extends BaseEntity {
    private static final long serialVersionUID = 1L;

    private Long stockId;
    private Long bookId;
    private String bookName;
    private String isbn;

    @Excel(name = "作者")
    private String author;

    @Excel(name = "出版社")
    private String publisher;

    @Excel(name = "专业方向")
    private String major;

    @Excel(name = "库存数量")
    private Integer stockNum;

    @Excel(name = "存放地址")
    private String storageAddr;

    @Excel(name = "预警数量")
    private Integer warningNum;

    @Excel(name = "累计采购")
    private Integer totalPurchase;

    @Excel(name = "累计出库")
    private Integer totalIssued;

    @Excel(name = "库存状态", readConverterExp = "normal=正常,warning=warning,shortage=shortage")
    private String stockStatus;

    private Integer version;

    private String delFlag;

    public Long getStockId() { return stockId; }
    public void setStockId(Long stockId) { this.stockId = stockId; }
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
    public String getMajor() { return major; }
    public void setMajor(String major) { this.major = major; }
    public Integer getStockNum() { return stockNum; }
    public void setStockNum(Integer stockNum) { this.stockNum = stockNum; }
    public String getStorageAddr() { return storageAddr; }
    public void setStorageAddr(String storageAddr) { this.storageAddr = storageAddr; }
    public Integer getWarningNum() { return warningNum; }
    public void setWarningNum(Integer warningNum) { this.warningNum = warningNum; }
    public Integer getTotalPurchase() { return totalPurchase; }
    public void setTotalPurchase(Integer totalPurchase) { this.totalPurchase = totalPurchase; }
    public Integer getTotalIssued() { return totalIssued; }
    public void setTotalIssued(Integer totalIssued) { this.totalIssued = totalIssued; }
    public String getDelFlag() { return delFlag; }
    public void setDelFlag(String delFlag) { this.delFlag = delFlag; }
    public Integer getVersion() { return version; }
    public void setVersion(Integer version) { this.version = version; }
    public String getStockStatus() { return stockStatus; }
    public void setStockStatus(String stockStatus) { this.stockStatus = stockStatus; }

    @Override
    public String toString() {
        return new org.apache.commons.lang3.builder.ToStringBuilder(this, org.apache.commons.lang3.builder.ToStringStyle.MULTI_LINE_STYLE)
            .append("stockId", stockId).append("bookId", bookId)
            .append("stockNum", stockNum).append("stockStatus", stockStatus).append("warningNum", warningNum).toString();
    }
}
