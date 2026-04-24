package com.ruoyi.textbook.domain.dto;

public class StockOperationResult {

    private boolean success;
    private Integer beforeStock;
    private Integer afterStock;
    private Integer changeNum;
    private String errorMessage;
    private Long stockLogId;

    public boolean isSuccess() { return success; }
    public void setSuccess(boolean success) { this.success = success; }
    public Integer getBeforeStock() { return beforeStock; }
    public void setBeforeStock(Integer beforeStock) { this.beforeStock = beforeStock; }
    public Integer getAfterStock() { return afterStock; }
    public void setAfterStock(Integer afterStock) { this.afterStock = afterStock; }
    public Integer getChangeNum() { return changeNum; }
    public void setChangeNum(Integer changeNum) { this.changeNum = changeNum; }
    public String getErrorMessage() { return errorMessage; }
    public void setErrorMessage(String errorMessage) { this.errorMessage = errorMessage; }
    public Long getStockLogId() { return stockLogId; }
    public void setStockLogId(Long stockLogId) { this.stockLogId = stockLogId; }

    public static StockOperationResult success(Integer beforeStock, Integer afterStock, Integer changeNum) {
        StockOperationResult result = new StockOperationResult();
        result.setSuccess(true);
        result.setBeforeStock(beforeStock);
        result.setAfterStock(afterStock);
        result.setChangeNum(changeNum);
        return result;
    }

    public static StockOperationResult failure(String errorMessage) {
        StockOperationResult result = new StockOperationResult();
        result.setSuccess(false);
        result.setErrorMessage(errorMessage);
        return result;
    }
}
