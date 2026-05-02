package com.ruoyi.textbook.service;

import com.ruoyi.textbook.domain.TbInventory;
import com.ruoyi.textbook.domain.dto.StockOperationResult;

public interface IStockOperationService {
    boolean deductStock(Long bookId, int deductQty, String businessType, String businessNo, String operator);

    boolean addStock(Long bookId, int addQty, String businessType, String businessNo, String operator);

    int getCurrentStock(Long bookId);

    StockOperationResult deductStock(Long bookId, Integer quantity,
            Long operatorId, String operatorName,
            String refBizType, String refBizId, String remark);

    StockOperationResult addStock(Long bookId, Integer quantity,
            Long operatorId, String operatorName,
            String refBizType, String refBizId, String remark);

    void checkAndSendStockWarning(Long bookId, String bookName);

    TbInventory getStockInfo(Long bookId);
}
