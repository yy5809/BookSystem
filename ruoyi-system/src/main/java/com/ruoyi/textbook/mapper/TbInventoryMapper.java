package com.ruoyi.textbook.mapper;

import com.ruoyi.textbook.domain.TbInventory;
import java.util.List;

/**
 * 库存信息Mapper接口
 * 
 * @author ruoyi
 */
public interface TbInventoryMapper
{
    /**
     * 查询库存信息
     * 
     * @param inventoryId 库存ID
     * @return 库存信息
     */
    public TbInventory selectTbInventoryById(Long inventoryId);

    /**
     * 根据教材ID查询库存信息
     * 
     * @param bookId 教材ID
     * @return 库存信息
     */
    public TbInventory selectTbInventoryByBookId(Long bookId);

    /**
     * 查询库存信息列表
     * 
     * @param tbInventory 库存信息
     * @return 库存信息集合
     */
    public List<TbInventory> selectTbInventoryList(TbInventory tbInventory);

    /**
     * 新增库存信息
     * 
     * @param tbInventory 库存信息
     * @return 结果
     */
    public int insertTbInventory(TbInventory tbInventory);

    /**
     * 修改库存信息
     * 
     * @param tbInventory 库存信息
     * @return 结果
     */
    public int updateTbInventory(TbInventory tbInventory);

    /**
     * 删除库存信息
     * 
     * @param inventoryId 库存ID
     * @return 结果
     */
    public int deleteTbInventoryById(Long inventoryId);

    /**
     * 批量删除库存信息
     * 
     * @param inventoryIds 需要删除的库存ID
     * @return 结果
     */
    public int deleteTbInventoryByIds(Long[] inventoryIds);

    /**
     * 更新库存数量
     *
     * @param bookId 教材ID
     * @param quantity 数量变化（正数为增加，负数为减少）
     * @return 结果
     */
    public int updateInventoryQuantity(Long bookId, Integer quantity);

    /**
     * 乐观锁更新库存数量（带版本检查，防止并发冲突）
     *
     * @param bookId 教材ID
     * @param expectedStock 预期当前库存（用于乐观锁校验）
     * @param changeNum 变化数量（正数为增加，负数为减少）
     * @return 影响行数（0表示并发冲突）
     */
    public int updateInventoryQuantityWithCheck(Long bookId, Integer expectedStock, Integer changeNum);
}