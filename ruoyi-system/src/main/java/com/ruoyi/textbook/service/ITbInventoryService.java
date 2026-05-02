package com.ruoyi.textbook.service;

import java.util.List;
import com.ruoyi.textbook.domain.TbInventory;

/**
 * 教材库存Service接口
 * 
 * @author ruoyi
 */
public interface ITbInventoryService 
{
    /**
     * 查询教材库存
     */
    public TbInventory selectTbInventoryByInventoryId(Long inventoryId);

    /**
     * 根据教材ID查询库存
     */
    public TbInventory selectTbInventoryByBookId(Long bookId);

    /**
     * 查询教材库存列表
     */
    public List<TbInventory> selectTbInventoryList(TbInventory tbInventory);

    /**
     * 查询库存预警列表
     */
    public List<TbInventory> selectWarningList();

    /**
     * 新增教材库存
     */
    public int insertTbInventory(TbInventory tbInventory);

    /**
     * 修改教材库存
     */
    public int updateTbInventory(TbInventory tbInventory);

    /**
     * 校验教材是否存在
     */
    public boolean validateBookExists(Long bookId);

    /**
     * 批量删除教材库存
     */
    public int deleteTbInventoryByInventoryIds(Long[] inventoryIds);

    /**
     * 删除教材库存信息
     */
    public int deleteTbInventoryByInventoryId(Long inventoryId);
}
