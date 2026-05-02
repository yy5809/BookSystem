package com.ruoyi.textbook.domain;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.ruoyi.common.core.domain.BaseEntity;

public class TbStockLog extends BaseEntity {
    private static final long serialVersionUID = 1L;

    private Long logId;
    private Long bookId;
    private String isbn;
    private String bookName;
    private String bizType;
    private Integer changeNum;
    private Integer beforeStock;
    private Integer afterStock;
    private Long operatorId;
    private String operatorName;
    private String refBizType;
    private String refBizId;
    private String remark;

    public Long getLogId() { return logId; }
    public void setLogId(Long logId) { this.logId = logId; }
    public Long getBookId() { return bookId; }
    public void setBookId(Long bookId) { this.bookId = bookId; }
    public String getIsbn() { return isbn; }
    public void setIsbn(String isbn) { this.isbn = isbn; }
    public String getBookName() { return bookName; }
    public void setBookName(String bookName) { this.bookName = bookName; }
    public String getBizType() { return bizType; }
    public void setBizType(String bizType) { this.bizType = bizType; }
    public Integer getChangeNum() { return changeNum; }
    public void setChangeNum(Integer changeNum) { this.changeNum = changeNum; }
    public Integer getBeforeStock() { return beforeStock; }
    public void setBeforeStock(Integer beforeStock) { this.beforeStock = beforeStock; }
    public Integer getAfterStock() { return afterStock; }
    public void setAfterStock(Integer afterStock) { this.afterStock = afterStock; }
    public Long getOperatorId() { return operatorId; }
    public void setOperatorId(Long operatorId) { this.operatorId = operatorId; }
    public String getOperatorName() { return operatorName; }
    public void setOperatorName(String operatorName) { this.operatorName = operatorName; }
    public String getRefBizType() { return refBizType; }
    public void setRefBizType(String refBizType) { this.refBizType = refBizType; }
    public String getRefBizId() { return refBizId; }
    public void setRefBizId(String refBizId) { this.refBizId = refBizId; }
    public String getRemark() { return remark; }
    public void setRemark(String remark) { this.remark = remark; }

    @Override
    public String toString() {
        return new org.apache.commons.lang3.builder.ToStringBuilder(this, org.apache.commons.lang3.builder.ToStringStyle.MULTI_LINE_STYLE)
            .append("logId", logId).append("bookId", bookId).append("isbn", isbn)
            .append("bizType", bizType).append("changeNum", changeNum)
            .append("beforeStock", beforeStock).append("afterStock", afterStock)
            .append("refBizType", refBizType).append("refBizId", refBizId)
            .append("remark", remark)
            .toString();
    }
}
