package com.ruoyi.textbook.mapper;

import com.ruoyi.textbook.domain.TbInventory;
import java.util.List;

public interface TbInventoryMapper
{
    public TbInventory selectTbInventoryById(Long inventoryId);

    public TbInventory selectTbInventoryByBookId(Long bookId);

    public List<TbInventory> selectTbInventoryList(TbInventory tbInventory);

    public int insertTbInventory(TbInventory tbInventory);

    public int updateTbInventory(TbInventory tbInventory);

    public int deleteTbInventoryById(Long inventoryId);

    public int deleteTbInventoryByIds(Long[] inventoryIds);

    public int selectStockNumByBookId(Long bookId);

    public int selectVersionByBookId(Long bookId);

    public int deductStockWithVersion(Long bookId, int qty, int version);

    public int addStockWithVersion(Long bookId, int qty, int version);

    public List<TbInventory> selectWarningList();
}