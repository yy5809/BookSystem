package com.ruoyi.textbook.service.impl;

import java.util.Date;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.DateUtils;
import com.ruoyi.textbook.domain.TbBook;
import com.ruoyi.textbook.domain.TbInventory;
import com.ruoyi.textbook.domain.TbStockLog;
import com.ruoyi.textbook.domain.dto.StockOperationResult;
import com.ruoyi.textbook.mapper.TbBookMapper;
import com.ruoyi.textbook.mapper.TbInventoryMapper;
import com.ruoyi.textbook.mapper.TbStockLogMapper;
import com.ruoyi.textbook.service.IStockOperationService;
import com.ruoyi.textbook.service.NoticeService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class StockOperationServiceImpl implements IStockOperationService {

    private static final Logger log = LoggerFactory.getLogger(StockOperationServiceImpl.class);

    @Autowired
    private TbInventoryMapper inventoryMapper;

    @Autowired
    private TbBookMapper tbBookMapper;

    @Autowired
    private TbStockLogMapper tbStockLogMapper;

    @Autowired
    private NoticeService noticeService;

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean deductStock(Long bookId, int deductQty, String businessType, String businessNo, String operator) {
        if (deductQty <= 0) {
            throw new ServiceException("扣减数量必须为正数");
        }
        TbInventory inventory = inventoryMapper.selectTbInventoryByBookId(bookId);
        if (inventory == null) {
            throw new ServiceException("库存记录不存在，bookId=" + bookId);
        }
        int currentStock = inventory.getStockNum();
        if (currentStock < deductQty) {
            throw new ServiceException("库存不足！当前库存: " + currentStock + ", 需要扣减: " + deductQty);
        }

        int currentVersion = inventory.getVersion() != null ? inventory.getVersion() : 0;
        int affected = inventoryMapper.deductStockWithVersion(bookId, deductQty, currentVersion);
        if (affected <= 0) {
            throw new ServiceException("库存数据已被其他操作修改，请刷新后重试");
        }
        int actualStock = inventoryMapper.selectStockNumByBookId(bookId);

        TbStockLog stockLog = createStockLog(bookId, -deductQty, currentStock, actualStock,
                null, operator, businessType, businessNo, null);
        tbStockLogMapper.insert(stockLog);

        checkAndSendStockWarning(bookId, inventory.getBookName());

        log.info("[库存扣减] bookId={}, 扣减数量={}, 剩余库存={}, 操作人={}", bookId, deductQty, actualStock, operator);
        return true;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean addStock(Long bookId, int addQty, String businessType, String businessNo, String operator) {
        if (addQty <= 0) {
            throw new ServiceException("入库数量必须为正数");
        }
        TbInventory inventory = inventoryMapper.selectTbInventoryByBookId(bookId);
        if (inventory == null) {
            throw new ServiceException("库存记录不存在，bookId=" + bookId);
        }
        int currentStock = inventory.getStockNum();
        int currentVersion = inventory.getVersion() != null ? inventory.getVersion() : 0;
        int affected = inventoryMapper.addStockWithVersion(bookId, addQty, currentVersion);
        if (affected <= 0) {
            throw new ServiceException("库存数据已被其他操作修改，请刷新后重试");
        }
        int actualStock = inventoryMapper.selectStockNumByBookId(bookId);

        TbStockLog stockLog = createStockLog(bookId, addQty, currentStock, actualStock,
                null, operator, businessType, businessNo, null);
        tbStockLogMapper.insert(stockLog);

        log.info("[库存增加] bookId={}, 增加数量={}, 新库存={}, 操作人={}", bookId, addQty, actualStock, operator);
        return true;
    }

    @Override
    public int getCurrentStock(Long bookId) {
        return inventoryMapper.selectStockNumByBookId(bookId);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public StockOperationResult deductStock(Long bookId, Integer quantity,
            Long operatorId, String operatorName,
            String refBizType, String refBizId, String remark) {

        if (bookId == null) {
            return StockOperationResult.failure("教材ID不能为空");
        }
        if (quantity == null || quantity <= 0) {
            return StockOperationResult.failure("扣减数量必须为正整数");
        }

        TbInventory inventory = inventoryMapper.selectTbInventoryByBookId(bookId);
        if (inventory == null) {
            return StockOperationResult.failure("教材库存记录不存在，bookId=" + bookId);
        }

        int beforeStock = inventory.getStockNum();
        if (beforeStock < quantity) {
            return StockOperationResult.failure(
                    String.format("库存不足，当前库存：%d，需求：%d", beforeStock, quantity));
        }

        int currentVersion = inventory.getVersion() != null ? inventory.getVersion() : 0;
        int rowsAffected = inventoryMapper.deductStockWithVersion(bookId, quantity, currentVersion);
        if (rowsAffected <= 0) {
            return StockOperationResult.failure("并发冲突：该教材库存已被其他操作修改，请刷新后重试");
        }

        int afterStock = inventoryMapper.selectStockNumByBookId(bookId);

        TbStockLog stockLog = createStockLog(bookId, -quantity, beforeStock, afterStock,
                operatorId, operatorName, refBizType, refBizId, remark);
        tbStockLogMapper.insert(stockLog);

        checkAndSendStockWarning(bookId, inventory.getBookName());

        log.info("【库存扣减】成功，bookId={}, 扣减数量={}, 操作前={}, 操作后={}",
                bookId, quantity, beforeStock, afterStock);

        return StockOperationResult.success(beforeStock, afterStock, -quantity);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public StockOperationResult addStock(Long bookId, Integer quantity,
            Long operatorId, String operatorName,
            String refBizType, String refBizId, String remark) {

        if (bookId == null) {
            return StockOperationResult.failure("教材ID不能为空");
        }
        if (quantity == null || quantity <= 0) {
            return StockOperationResult.failure("增加数量必须为正整数");
        }

        TbInventory inventory = inventoryMapper.selectTbInventoryByBookId(bookId);
        Integer beforeStock = (inventory != null) ? inventory.getStockNum() : 0;

        if (inventory == null) {
            TbBook bookInfo = tbBookMapper.selectTbBookByBookId(bookId);
            inventory = new TbInventory();
            inventory.setBookId(bookId);
            inventory.setBookName(bookInfo != null ? bookInfo.getBookName() : "");
            inventory.setIsbn(bookInfo != null ? bookInfo.getIsbn() : "");
            inventory.setStockNum(quantity);
            inventory.setWarningNum(10);
            inventory.setCreateTime(DateUtils.getNowDate());
            try {
                inventoryMapper.insertTbInventory(inventory);
                log.info("【库存增加】创建新库存记录成功，bookId={}, 初始库存={}", bookId, quantity);
            } catch (DuplicateKeyException dke) {
                log.info("【库存增加】库存记录并发创建冲突，改用累加方式，bookId={}", bookId);
                inventory = inventoryMapper.selectTbInventoryByBookId(bookId);
                if (inventory == null) {
                    return StockOperationResult.failure("库存记录创建失败，请重试");
                }
                beforeStock = inventory.getStockNum();
                StockOperationResult versionResult = addStockWithVersion(inventory, quantity,
                        operatorId, operatorName, refBizType, refBizId, remark);
                if (!versionResult.isSuccess()) {
                    return versionResult;
                }
                int afterStock = inventoryMapper.selectStockNumByBookId(bookId);
                versionResult.setAfterStock(afterStock);
                return versionResult;
            }
        } else {
            StockOperationResult versionResult = addStockWithVersion(inventory, quantity,
                    operatorId, operatorName, refBizType, refBizId, remark);
            if (!versionResult.isSuccess()) {
                return versionResult;
            }
            int afterStock = inventoryMapper.selectStockNumByBookId(bookId);
            versionResult.setAfterStock(afterStock);
            return versionResult;
        }

        int afterStock = inventoryMapper.selectStockNumByBookId(bookId);

        TbStockLog stockLog = createStockLog(bookId, quantity, beforeStock, afterStock,
                operatorId, operatorName, refBizType, refBizId, remark);
        tbStockLogMapper.insert(stockLog);

        log.info("【库存增加】成功，bookId={}, 增加数量={}, 操作前={}, 操作后={}",
                bookId, quantity, beforeStock, afterStock);

        return StockOperationResult.success(beforeStock, afterStock, quantity);
    }

    @Override
    public void checkAndSendStockWarning(Long bookId, String bookName) {
        try {
            TbInventory inventory = inventoryMapper.selectTbInventoryByBookId(bookId);
            if (inventory != null && inventory.getWarningNum() != null
                    && inventory.getStockNum() <= inventory.getWarningNum()) {
                noticeService.sendStockWarningNotice(
                        bookId, bookName, inventory.getStockNum(), inventory.getWarningNum());
                log.info("【库存预警】教材《{}》库存{}本低于预警阈值{}本，已发送通知",
                        bookName, inventory.getStockNum(), inventory.getWarningNum());
            }
        } catch (Exception e) {
            log.warn("【库存预警】检查库存预警失败：{}", e.getMessage());
        }
    }

    @Override
    public TbInventory getStockInfo(Long bookId) {
        return inventoryMapper.selectTbInventoryByBookId(bookId);
    }

    private StockOperationResult addStockWithVersion(TbInventory inventory, Integer quantity,
            Long operatorId, String operatorName,
            String refBizType, String refBizId, String remark) {

        int beforeStock = inventory.getStockNum();
        int currentVersion = inventory.getVersion() != null ? inventory.getVersion() : 0;
        int rowsAffected = inventoryMapper.addStockWithVersion(
                inventory.getBookId(), quantity, currentVersion);

        if (rowsAffected <= 0) {
            return StockOperationResult.failure("并发冲突：该教材库存已被其他操作修改，请刷新后重试");
        }

        int afterStock = inventoryMapper.selectStockNumByBookId(inventory.getBookId());

        TbStockLog stockLog = createStockLog(inventory.getBookId(), quantity, beforeStock, afterStock,
                operatorId, operatorName, refBizType, refBizId, remark);
        tbStockLogMapper.insert(stockLog);

        log.info("【库存增加】成功，bookId={}, 增加数量={}, 操作前={}, 操作后={}",
                inventory.getBookId(), quantity, beforeStock, afterStock);

        return StockOperationResult.success(beforeStock, afterStock, quantity);
    }

    private TbStockLog createStockLog(Long bookId, Integer changeNum, Integer beforeStock, Integer afterStock,
            Long operatorId, String operatorName, String refBizType, String refBizId, String remark) {

        TbBook book = tbBookMapper.selectTbBookByBookId(bookId);
        TbStockLog stockLog = new TbStockLog();
        stockLog.setBookId(bookId);
        stockLog.setIsbn(book != null ? book.getIsbn() : "");
        stockLog.setBookName(book != null ? book.getBookName() : "");
        stockLog.setBizType(changeNum > 0 ? "1" : "2");
        stockLog.setChangeNum(changeNum);
        stockLog.setBeforeStock(beforeStock);
        stockLog.setAfterStock(afterStock);
        stockLog.setOperatorId(operatorId);
        stockLog.setOperatorName(operatorName);
        stockLog.setRefBizType(refBizType);
        stockLog.setRefBizId(refBizId);
        if (remark != null && refBizType != null) {
            stockLog.setRemark("[" + refBizType + "]" + remark);
        } else {
            stockLog.setRemark(remark);
        }
        return stockLog;
    }

}
