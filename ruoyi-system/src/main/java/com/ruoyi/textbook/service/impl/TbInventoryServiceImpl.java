package com.ruoyi.textbook.service.impl;

import java.util.List;
import com.ruoyi.common.utils.DateUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.textbook.mapper.TbInventoryMapper;
import com.ruoyi.textbook.mapper.TbBookMapper;
import com.ruoyi.textbook.domain.TbInventory;
import com.ruoyi.textbook.domain.TbBook;
import com.ruoyi.textbook.service.ITbInventoryService;

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
        List<TbInventory> warningList = tbInventoryMapper.selectWarningList();
        for (TbInventory item : warningList) {
            if (item.getStockNum() <= 0) {
                item.setStockStatus("shortage");
            } else {
                item.setStockStatus("warning");
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
}
