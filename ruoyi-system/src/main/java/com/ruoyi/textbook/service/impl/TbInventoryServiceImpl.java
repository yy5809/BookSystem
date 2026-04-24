package com.ruoyi.textbook.service.impl;

import java.util.List;
import com.ruoyi.common.utils.DateUtils;
import com.ruoyi.common.utils.SecurityUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.textbook.mapper.TbInventoryMapper;
import com.ruoyi.textbook.mapper.TbBookMapper;
import com.ruoyi.textbook.domain.TbInventory;
import com.ruoyi.textbook.domain.TbBook;
import com.ruoyi.textbook.service.ITbInventoryService;
import com.ruoyi.textbook.domain.BookStockFlow;
import com.ruoyi.textbook.mapper.BookStockFlowMapper;

/**
 * 教材库存Service业务层处理
 * 
 * @author ruoyi
 */
@Service
public class TbInventoryServiceImpl implements ITbInventoryService 
{
    @Autowired
    private TbInventoryMapper tbInventoryMapper;

    @Autowired
    private TbBookMapper tbBookMapper;

    @Autowired
    private BookStockFlowMapper stockFlowMapper;

    /**
     * 查询教材库存
     */
    @Override
    public TbInventory selectTbInventoryByInventoryId(Long inventoryId)
    {
        return tbInventoryMapper.selectTbInventoryById(inventoryId);
    }

    /**
     * 根据教材ID查询库存
     */
    @Override
    public TbInventory selectTbInventoryByBookId(Long bookId)
    {
        return tbInventoryMapper.selectTbInventoryByBookId(bookId);
    }

    /**
     * 查询教材库存列表
     */
    @Override
    public List<TbInventory> selectTbInventoryList(TbInventory tbInventory)
    {
        return tbInventoryMapper.selectTbInventoryList(tbInventory);
    }

    /**
     * 查询库存预警列表
     */
    @Override
    public List<TbInventory> selectWarningList()
    {
        TbInventory query = new TbInventory();
        List<TbInventory> allInventory = tbInventoryMapper.selectTbInventoryList(query);
        List<TbInventory> warningList = new java.util.ArrayList<>();
        for (TbInventory item : allInventory) {
            if (item.getStockNum() <= 0) {
                item.setStockStatus("shortage");
                warningList.add(item);
            } else if (item.getWarningNum() != null && item.getStockNum() <= item.getWarningNum()) {
                item.setStockStatus("warning");
                warningList.add(item);
            }
        }
        return warningList;
    }

    /**
     * 新增教材库存（带关联校验）
     */
    @Override
    public int insertTbInventory(TbInventory tbInventory)
    {
        if (tbInventory.getBookId() != null && !validateBookExists(tbInventory.getBookId())) {
            throw new ServiceException("教材信息不存在，bookId=" + tbInventory.getBookId());
        }
        tbInventory.setCreateTime(DateUtils.getNowDate());
        return tbInventoryMapper.insertTbInventory(tbInventory);
    }

    /**
     * 修改教材库存
     */
    @Override
    public int updateTbInventory(TbInventory tbInventory)
    {
        tbInventory.setUpdateTime(DateUtils.getNowDate());
        return tbInventoryMapper.updateTbInventory(tbInventory);
    }

    /**
     * 增加库存数量（带校验）
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public int increaseStock(Long bookId, Integer quantity)
    {
        if (bookId == null || quantity == null || quantity <= 0) {
            throw new ServiceException("参数无效：bookId和quantity必须大于0");
        }
        if (!validateBookExists(bookId)) {
            throw new ServiceException("教材信息不存在，无法入库，bookId=" + bookId);
        }
        TbInventory inventory = tbInventoryMapper.selectTbInventoryByBookId(bookId);
        if (inventory == null) {
            throw new ServiceException("库存记录不存在，bookId=" + bookId);
        }
        int beforeStock = inventory.getStockNum();
        int currentVersion = inventory.getVersion() != null ? inventory.getVersion() : 0;
        int rowsAffected = tbInventoryMapper.addStockWithVersion(
                bookId,
                quantity,
                currentVersion
        );
        if (rowsAffected <= 0) {
            throw new ServiceException("并发冲突：该教材库存已被其他操作修改，请刷新后重试");
        }
        int afterStock = beforeStock + quantity;
        String businessNo = "STOCK_INCR_" + DateUtils.dateTimeNow("yyyyMMddHHmmss") + "_" + bookId;
        recordStockFlow(bookId, quantity, beforeStock, afterStock, "2", businessNo);
        return rowsAffected;
    }

    /**
     * 减少库存数量（带校验）
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public int decreaseStock(Long bookId, Integer quantity)
    {
        if (bookId == null || quantity == null || quantity <= 0) {
            throw new ServiceException("参数无效：bookId和quantity必须大于0");
        }
        TbInventory stock = tbInventoryMapper.selectTbInventoryByBookId(bookId);
        if (stock == null) {
            throw new ServiceException("库存记录不存在，bookId=" + bookId);
        }
        if (stock.getStockNum() < quantity) {
            throw new ServiceException("库存不足：当前库存" + stock.getStockNum() + "本，需要扣减" + quantity + "本");
        }
        int beforeStock = stock.getStockNum();
        int currentVersion = stock.getVersion() != null ? stock.getVersion() : 0;
        int rowsAffected = tbInventoryMapper.deductStockWithVersion(
                bookId,
                quantity,
                currentVersion
        );
        if (rowsAffected <= 0) {
            throw new ServiceException("并发冲突：该教材库存已被其他操作修改，请刷新后重试");
        }
        int afterStock = beforeStock - quantity;
        String businessNo = "STOCK_DECR_" + DateUtils.dateTimeNow("yyyyMMddHHmmss") + "_" + bookId;
        recordStockFlow(bookId, -quantity, beforeStock, afterStock, "3", businessNo);
        return rowsAffected;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int safeDecreaseStock(Long bookId, Integer quantity)
    {
        return decreaseStock(bookId, quantity);
    }

    /**
     * 校验教材是否存在
     */
    @Override
    public boolean validateBookExists(Long bookId)
    {
        if (bookId == null) return false;
        TbBook book = tbBookMapper.selectTbBookByBookId(bookId);
        return book != null;
    }

    /**
     * 批量删除教材库存
     */
    @Override
    public int deleteTbInventoryByInventoryIds(Long[] inventoryIds)
    {
        return tbInventoryMapper.deleteTbInventoryByIds(inventoryIds);
    }

    /**
     * 删除教材库存信息
     */
    @Override
    public int deleteTbInventoryByInventoryId(Long inventoryId)
    {
        return tbInventoryMapper.deleteTbInventoryById(inventoryId);
    }

    private void recordStockFlow(Long bookId, int changeQty, int stockBefore, int stockAfter,
                                  String businessType, String businessNo) {
        BookStockFlow flow = new BookStockFlow();
        flow.setTextbookId(bookId);
        flow.setBusinessType(businessType);
        flow.setBusinessNo(businessNo);
        flow.setChangeQty(changeQty);
        flow.setStockBefore(stockBefore);
        flow.setStockAfter(stockAfter);
        flow.setOperator(SecurityUtils.getUsername());
        flow.setOperateTime(new java.util.Date());
        stockFlowMapper.insertBookStockFlow(flow);
    }
}
