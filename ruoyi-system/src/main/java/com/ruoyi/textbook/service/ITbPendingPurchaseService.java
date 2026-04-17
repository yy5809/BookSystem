package com.ruoyi.textbook.service;

import java.util.List;
import com.ruoyi.textbook.domain.TbPendingPurchase;

/**
 * 待购教材Service接口
 * 
 * @author ruoyi
 */
public interface ITbPendingPurchaseService 
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
     * 批量删除待购教材
     */
    public int deleteTbPendingPurchaseByPendingIds(Long[] pendingIds);

    /**
     * 删除待购教材信息
     */
    public int deleteTbPendingPurchaseByPendingId(Long pendingId);
}
