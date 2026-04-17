package com.ruoyi.textbook.service.impl;

import java.util.List;
import com.ruoyi.common.utils.DateUtils;
import com.ruoyi.common.utils.uuid.IdUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.textbook.mapper.TbPendingPurchaseMapper;
import com.ruoyi.textbook.domain.TbPendingPurchase;
import com.ruoyi.textbook.service.ITbPendingPurchaseService;

/**
 * 待购教材Service业务层处理
 * 
 * @author ruoyi
 */
@Service
public class TbPendingPurchaseServiceImpl implements ITbPendingPurchaseService 
{
    @Autowired
    private TbPendingPurchaseMapper tbPendingPurchaseMapper;

    /**
     * 查询待购教材
     */
    @Override
    public TbPendingPurchase selectTbPendingPurchaseByPendingId(Long pendingId)
    {
        return tbPendingPurchaseMapper.selectTbPendingPurchaseByPendingId(pendingId);
    }

    /**
     * 查询待购教材列表
     */
    @Override
    public List<TbPendingPurchase> selectTbPendingPurchaseList(TbPendingPurchase tbPendingPurchase)
    {
        return tbPendingPurchaseMapper.selectTbPendingPurchaseList(tbPendingPurchase);
    }

    /**
     * 新增待购教材
     */
    @Override
    public int insertTbPendingPurchase(TbPendingPurchase tbPendingPurchase)
    {
        if (tbPendingPurchase.getPendingNo() == null || tbPendingPurchase.getPendingNo().isEmpty())
        {
            tbPendingPurchase.setPendingNo("PP" + DateUtils.dateTimeNow("yyyyMMddHHmmss") + IdUtils.randomInt(100, 999));
        }
        tbPendingPurchase.setCreateTime(DateUtils.getNowDate());
        return tbPendingPurchaseMapper.insertTbPendingPurchase(tbPendingPurchase);
    }

    /**
     * 修改待购教材
     */
    @Override
    public int updateTbPendingPurchase(TbPendingPurchase tbPendingPurchase)
    {
        tbPendingPurchase.setUpdateTime(DateUtils.getNowDate());
        return tbPendingPurchaseMapper.updateTbPendingPurchase(tbPendingPurchase);
    }

    /**
     * 批量删除待购教材
     */
    @Override
    public int deleteTbPendingPurchaseByPendingIds(Long[] pendingIds)
    {
        return tbPendingPurchaseMapper.deleteTbPendingPurchaseByPendingIds(pendingIds);
    }

    /**
     * 删除待购教材信息
     */
    @Override
    public int deleteTbPendingPurchaseByPendingId(Long pendingId)
    {
        return tbPendingPurchaseMapper.deleteTbPendingPurchaseByPendingId(pendingId);
    }
}
