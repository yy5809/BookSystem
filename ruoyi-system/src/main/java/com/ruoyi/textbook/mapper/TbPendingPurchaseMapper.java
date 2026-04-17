package com.ruoyi.textbook.mapper;

import java.util.List;
import com.ruoyi.textbook.domain.TbPendingPurchase;

/**
 * 待购教材Mapper接口
 * 
 * @author ruoyi
 */
public interface TbPendingPurchaseMapper 
{
    /**
     * 查询待购教材
     */
    public TbPendingPurchase selectTbPendingPurchaseByPendingId(Long pendingId);

    /**
     * 查询待购教材列表
     */
    public List<TbPendingPurchase> selectTbPendingPurchaseList(TbPendingPurchase tbPendingPurchase);

    /**
     * 新增待购教材
     */
    public int insertTbPendingPurchase(TbPendingPurchase tbPendingPurchase);

    /**
     * 修改待购教材
     */
    public int updateTbPendingPurchase(TbPendingPurchase tbPendingPurchase);

    /**
     * 删除待购教材
     */
    public int deleteTbPendingPurchaseByPendingId(Long pendingId);

    /**
     * 批量删除待购教材
     */
    public int deleteTbPendingPurchaseByPendingIds(Long[] pendingIds);
}
