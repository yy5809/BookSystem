package com.ruoyi.textbook.service.impl;

import com.ruoyi.common.utils.DateUtils;
import com.ruoyi.common.utils.uuid.IdUtils;
import com.ruoyi.textbook.domain.TbInbound;
import com.ruoyi.textbook.domain.TbInventory;
import com.ruoyi.textbook.domain.TbPending;
import com.ruoyi.textbook.mapper.TbInboundMapper;
import com.ruoyi.textbook.mapper.TbInventoryMapper;
import com.ruoyi.textbook.mapper.TbPendingMapper;
import com.ruoyi.textbook.service.ITbPendingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.ruoyi.common.utils.SecurityUtils;
import java.util.List;

/**
 * 待购教材信息Service实现
 * 
 * @author ruoyi
 */
@Service
public class TbPendingServiceImpl implements ITbPendingService
{
    @Autowired
    private TbPendingMapper tbPendingMapper;
    @Autowired
    private TbInventoryMapper tbInventoryMapper;
    @Autowired
    private TbInboundMapper tbInboundMapper;

    /**
     * 查询待购教材信息
     * 
     * @param pendingId 待购ID
     * @return 待购教材信息
     */
    @Override
    public TbPending selectTbPendingById(Long pendingId)
    {
        return tbPendingMapper.selectTbPendingById(pendingId);
    }

    /**
     * 查询待购教材信息列表
     * 
     * @param tbPending 待购教材信息
     * @return 待购教材信息集合
     */
    @Override
    public List<TbPending> selectTbPendingList(TbPending tbPending)
    {
        return tbPendingMapper.selectTbPendingList(tbPending);
    }

    /**
     * 新增待购教材信息
     * 
     * @param tbPending 待购教材信息
     * @return 结果
     */
    @Override
    public int insertTbPending(TbPending tbPending)
    {
        // 生成待购单号
        String pendingNo = "PEN" + DateUtils.dateTimeNow("yyyyMMddHHmmss") + IdUtils.fastSimpleUUID().substring(0, 6);
        tbPending.setPendingNo(pendingNo);
        tbPending.setStatus("0"); // 待采购
        tbPending.setCreateTime(DateUtils.getNowDate());
        tbPending.setUpdateTime(DateUtils.getNowDate());
        return tbPendingMapper.insertTbPending(tbPending);
    }

    /**
     * 修改待购教材信息
     * 
     * @param tbPending 待购教材信息
     * @return 结果
     */
    @Override
    public int updateTbPending(TbPending tbPending)
    {
        tbPending.setUpdateTime(DateUtils.getNowDate());
        return tbPendingMapper.updateTbPending(tbPending);
    }

    /**
     * 删除待购教材信息
     * 
     * @param pendingId 待购ID
     * @return 结果
     */
    @Override
    public int deleteTbPendingById(Long pendingId)
    {
        return tbPendingMapper.deleteTbPendingById(pendingId);
    }

    /**
     * 批量删除待购教材信息
     * 
     * @param pendingIds 需要删除的待购ID
     * @return 结果
     */
    @Override
    public int deleteTbPendingByIds(Long[] pendingIds)
    {
        return tbPendingMapper.deleteTbPendingByIds(pendingIds);
    }

    /**
     * 根据教材ID查询待购教材信息
     * 
     * @param bookId 教材ID
     * @return 待购教材信息集合
     */
    @Override
    public List<TbPending> selectTbPendingListByBookId(Long bookId)
    {
        return tbPendingMapper.selectTbPendingListByBookId(bookId);
    }

    /**
     * 更新待购单状态
     * 
     * @param pendingId 待购ID
     * @param status 状态
     * @return 结果
     */
    @Override
    public int updatePendingStatus(Long pendingId, String status)
    {
        TbPending pending = tbPendingMapper.selectTbPendingById(pendingId);
        if (pending == null) {
            return 0;
        }

        pending.setStatus(status);
        pending.setUpdateTime(DateUtils.getNowDate());
        return tbPendingMapper.updateTbPending(pending);
    }

    @Override
    @Transactional
    public int confirmInbound(Long pendingId) {
        TbPending pending = tbPendingMapper.selectTbPendingById(pendingId);
        if (pending == null) return 0;
        if ("3".equals(pending.getStatus())) {
            throw new RuntimeException("该待购单已入库，不可重复操作");
        }
        if (!"2".equals(pending.getStatus())) {
            throw new RuntimeException("待购单状态不是已到货，无法入库");
        }

        TbInventory stock = tbInventoryMapper.selectTbInventoryByBookId(pending.getBookId());
        int newStockNum = pending.getPurchaseNum();
        if (stock != null) {
            newStockNum += stock.getStockNum();
            stock.setStockNum(newStockNum);
            tbInventoryMapper.updateTbInventory(stock);
        } else {
            TbInventory newStock = new TbInventory();
            newStock.setBookId(pending.getBookId());
            newStock.setStockNum(pending.getPurchaseNum());
            newStock.setWarningNum(5);
            tbInventoryMapper.insertTbInventory(newStock);
        }

        TbInbound inbound = new TbInbound();
        inbound.setBookId(pending.getBookId());
        inbound.setInboundNo("IN" + DateUtils.dateTimeNow("yyyyMMddHHmmss"));
        inbound.setInNum(pending.getPurchaseNum());
        inbound.setOperatorId(SecurityUtils.getUserId());
        tbInboundMapper.insertTbInbound(inbound);

        pending.setStatus("3");
        pending.setActualDate(DateUtils.getNowDate());
        pending.setUpdateTime(DateUtils.getNowDate());
        tbPendingMapper.updateTbPending(pending);
        return 1;
    }
}