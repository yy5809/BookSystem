package com.ruoyi.textbook.service.impl;

import com.ruoyi.common.utils.DateUtils;
import com.ruoyi.common.utils.uuid.IdUtils;
import com.ruoyi.textbook.domain.TbPurchase;
import com.ruoyi.textbook.domain.TbPurchaseDetail;
import com.ruoyi.textbook.domain.TbInventory;
import com.ruoyi.textbook.domain.TbShortage;
import com.ruoyi.textbook.mapper.TbPurchaseMapper;
import com.ruoyi.textbook.mapper.TbInventoryMapper;
import com.ruoyi.textbook.mapper.TbShortageMapper;
import com.ruoyi.textbook.service.ITbPurchaseService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * 购书信息Service实现
 * 
 * @author ruoyi
 */
@Service
public class TbPurchaseServiceImpl implements ITbPurchaseService
{
    @Autowired
    private TbPurchaseMapper tbPurchaseMapper;

    @Autowired
    private TbInventoryMapper tbInventoryMapper;

    @Autowired
    private TbShortageMapper tbShortageMapper;

    /**
     * 查询购书信息
     * 
     * @param purchaseId 购书ID
     * @return 购书信息
     */
    @Override
    public TbPurchase selectTbPurchaseById(Long purchaseId)
    {
        return tbPurchaseMapper.selectTbPurchaseById(purchaseId);
    }

    /**
     * 查询购书信息列表
     * 
     * @param tbPurchase 购书信息
     * @return 购书信息集合
     */
    @Override
    public List<TbPurchase> list(TbPurchase tbPurchase) {
        return tbPurchaseMapper.selectTbPurchaseList(tbPurchase);
    }

    @Override
    public List<TbPurchase> selectTbPurchaseList(TbPurchase tbPurchase)
    {
        return tbPurchaseMapper.selectTbPurchaseList(tbPurchase);
    }

    /**
     * 新增购书信息
     * 
     * @param tbPurchase 购书信息
     * @param details 购书明细
     * @return 结果
     */
    @Override
    @Transactional
    public int insertTbPurchase(TbPurchase tbPurchase, List<TbPurchaseDetail> details)
    {
        String purchaseNo = "CG" + DateUtils.dateTimeNow("yyyyMMddHHmmss") + String.format("%03d", System.currentTimeMillis() % 1000);
        tbPurchase.setPurchaseNo(purchaseNo);
        tbPurchase.setAuditStatus("0"); // 待审核
        tbPurchase.setCreateTime(DateUtils.getNowDate());
        tbPurchase.setUpdateTime(DateUtils.getNowDate());

        // 插入购书信息
        int result = tbPurchaseMapper.insertTbPurchase(tbPurchase);

        // 插入购书明细
        if (result > 0 && details != null && !details.isEmpty()) {
            for (TbPurchaseDetail detail : details) {
                detail.setPurchaseId(tbPurchase.getBuyId());
                tbPurchaseMapper.insertTbPurchaseDetail(detail);
            }
        }

        return result;
    }

    /**
     * 修改购书信息
     * 
     * @param tbPurchase 购书信息
     * @return 结果
     */
    @Override
    public int updateTbPurchase(TbPurchase tbPurchase)
    {
        tbPurchase.setUpdateTime(DateUtils.getNowDate());
        return tbPurchaseMapper.updateTbPurchase(tbPurchase);
    }

    /**
     * 删除购书信息
     * 
     * @param purchaseId 购书ID
     * @return 结果
     */
    @Override
    public int deleteTbPurchaseById(Long purchaseId)
    {
        return tbPurchaseMapper.deleteTbPurchaseById(purchaseId);
    }

    /**
     * 批量删除购书信息
     * 
     * @param purchaseIds 需要删除的购书ID
     * @return 结果
     */
    @Override
    public int deleteTbPurchaseByIds(Long[] purchaseIds)
    {
        return tbPurchaseMapper.deleteTbPurchaseByIds(purchaseIds);
    }

    /**
     * 查询购书明细列表
     * 
     * @param purchaseId 购书ID
     * @return 购书明细集合
     */
    @Override
    public List<TbPurchaseDetail> selectTbPurchaseDetailListByPurchaseId(Long purchaseId)
    {
        return tbPurchaseMapper.selectTbPurchaseDetailListByPurchaseId(purchaseId);
    }

    /**
     * 审核用书单
     * 
     * @param purchaseId 购书ID
     * @param status 审核状态
     * @return 结果
     */
    @Override
    @Transactional
    public int auditTbPurchase(Long purchaseId, String status)
    {
        TbPurchase purchase = tbPurchaseMapper.selectTbPurchaseById(purchaseId);
        if (purchase == null) {
            return 0;
        }

        purchase.setAuditStatus(status);
        purchase.setUpdateTime(DateUtils.getNowDate());
        int result = tbPurchaseMapper.updateTbPurchase(purchase);

        // 审核通过，检查库存
        if (result > 0 && "1".equals(status)) {
            List<TbPurchaseDetail> details = tbPurchaseMapper.selectTbPurchaseDetailListByPurchaseId(purchaseId);
            for (TbPurchaseDetail detail : details) {
                TbInventory inventory = tbInventoryMapper.selectTbInventoryByBookId(detail.getBookId());
                if (inventory == null || inventory.getStockNum() < detail.getQuantity()) {
                    int shortageQuantity = inventory == null ? detail.getQuantity() : detail.getQuantity() - inventory.getStockNum();
                    TbShortage shortage = new TbShortage();
                    shortage.setBookId(detail.getBookId());
                    shortage.setBookName(detail.getBookName());
                    shortage.setIsbn(detail.getIsbn());
                    shortage.setLackNum(shortageQuantity);
                    shortage.setHandleStatus("0");
                    shortage.setCreateTime(DateUtils.getNowDate());
                    shortage.setUpdateTime(DateUtils.getNowDate());
                    tbShortageMapper.insertTbShortage(shortage);
                }
            }
        }

        return result;
    }

    /**
     * 开具发票
     * 
     * @param purchaseId 购书ID
     * @param invoiceNo 发票编号
     * @return 结果
     */
    @Override
    public int invoiceTbPurchase(Long purchaseId, String invoiceNo)
    {
        TbPurchase purchase = tbPurchaseMapper.selectTbPurchaseById(purchaseId);
        if (purchase == null) {
            return 0;
        }

        purchase.setRejectReason(invoiceNo);
        purchase.setReceiveStatus("1"); // 已完成
        purchase.setUpdateTime(DateUtils.getNowDate());
        return tbPurchaseMapper.updateTbPurchase(purchase);
    }

    @Override
    public int confirmShipBySupplier(Long purchaseId, Long supplierUserId, String supplierName, String logisticsNo, String logisticsCompany) {
        TbPurchase purchase = tbPurchaseMapper.selectTbPurchaseById(purchaseId);
        if (purchase == null) {
            return 0;
        }

        purchase.setRemark("供应商确认发货：" + logisticsCompany + "，物流单号：" + logisticsNo);
        purchase.setUpdateTime(DateUtils.getNowDate());
        return tbPurchaseMapper.updateTbPurchase(purchase);
    }
}