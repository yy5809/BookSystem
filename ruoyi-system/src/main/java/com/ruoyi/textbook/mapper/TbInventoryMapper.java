package com.ruoyi.textbook.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import com.ruoyi.textbook.domain.TbInventory;
import java.util.List;

@Mapper
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

    public int deductStockWithVersion(@Param("bookId") Long bookId, @Param("qty") int qty, @Param("version") int version);

    public int addStockWithVersion(@Param("bookId") Long bookId, @Param("qty") int qty, @Param("version") int version);

    public List<TbInventory> selectWarningList();
}