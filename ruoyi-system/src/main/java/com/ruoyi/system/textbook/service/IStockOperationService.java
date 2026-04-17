package com.ruoyi.system.textbook.service;

public interface IStockOperationService {
    boolean deductStock(Long bookId, int deductQty, String businessType, String businessNo, String operator);

    boolean addStock(Long bookId, int addQty, String businessType, String businessNo, String operator);

    int getCurrentStock(Long bookId);
}
