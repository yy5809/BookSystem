package com.ruoyi.system.textbook.service.impl;

import java.util.Date;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.system.textbook.domain.BookStockFlow;
import com.ruoyi.system.textbook.mapper.BookStockFlowMapper;
import com.ruoyi.textbook.mapper.TbInventoryMapper;
import com.ruoyi.system.textbook.service.IStockOperationService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class StockOperationServiceImpl implements IStockOperationService {

    private static final Logger log = LoggerFactory.getLogger(StockOperationServiceImpl.class);

    @Autowired
    private TbInventoryMapper inventoryMapper;

    @Autowired
    private BookStockFlowMapper stockFlowMapper;

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean deductStock(Long bookId, int deductQty, String businessType, String businessNo, String operator) {
        int currentStock = inventoryMapper.selectStockNumByBookId(bookId);
        if (currentStock < deductQty) {
            throw new ServiceException("库存不足！当前库存: " + currentStock + ", 需要扣减: " + deductQty);
        }

        int currentVersion = inventoryMapper.selectVersionByBookId(bookId);
        int affected = inventoryMapper.deductStockWithVersion(bookId, deductQty, currentVersion);
        if (affected == 0) {
            throw new ServiceException("库存数据已被其他操作修改，请重试（并发冲突）");
        }

        int newStock = currentStock - deductQty;
        recordFlow(bookId, businessType, businessNo, -deductQty, currentStock, newStock, operator);
        log.info("[库存扣减] bookId={}, 扣减数量={}, 剩余库存={}, 操作人={}", bookId, deductQty, newStock, operator);
        return true;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean addStock(Long bookId, int addQty, String businessType, String businessNo, String operator) {
        int currentStock = inventoryMapper.selectStockNumByBookId(bookId);
        int currentVersion = inventoryMapper.selectVersionByBookId(bookId);

        int affected = inventoryMapper.addStockWithVersion(bookId, addQty, currentVersion);
        if (affected == 0) {
            throw new ServiceException("库存数据已被其他操作修改，请重试（并发冲突）");
        }

        int newStock = currentStock + addQty;
        recordFlow(bookId, businessType, businessNo, addQty, currentStock, newStock, operator);
        log.info("[库存增加] bookId={}, 增加数量={}, 新库存={}, 操作人={}", bookId, addQty, newStock, operator);
        return true;
    }

    @Override
    public int getCurrentStock(Long bookId) {
        return inventoryMapper.selectStockNumByBookId(bookId);
    }

    private void recordFlow(Long bookId, String businessType, String businessNo,
                            int changeQty, int stockBefore, int stockAfter, String operator) {
        BookStockFlow flow = new BookStockFlow();
        flow.setTextbookId(bookId);
        flow.setBusinessType(businessType);
        flow.setBusinessNo(businessNo);
        flow.setChangeQty(changeQty);
        flow.setStockBefore(stockBefore);
        flow.setStockAfter(stockAfter);
        flow.setOperator(operator);
        flow.setOperateTime(new Date());
        stockFlowMapper.insertBookStockFlow(flow);
    }
}
