package com.ruoyi.textbook.service.impl;

import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.DateUtils;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.common.utils.uuid.IdUtils;
import com.ruoyi.textbook.domain.TbPurchase;
import com.ruoyi.textbook.domain.TbPurchaseDetail;
import com.ruoyi.textbook.domain.TbInventory;
import com.ruoyi.textbook.domain.TbShortage;
import com.ruoyi.textbook.domain.TbSupplier;
import com.ruoyi.textbook.mapper.TbPurchaseMapper;
import com.ruoyi.textbook.mapper.TbInventoryMapper;
import com.ruoyi.textbook.mapper.TbShortageMapper;
import com.ruoyi.textbook.mapper.TbSupplierMapper;
import com.ruoyi.textbook.service.ITbPurchaseService;
import com.ruoyi.textbook.service.NoticeService;
import com.ruoyi.textbook.enums.PurchaseStatusEnum;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class TbPurchaseServiceImpl implements ITbPurchaseService
{
    private static final Logger log = LoggerFactory.getLogger(TbPurchaseServiceImpl.class);

    @Autowired
    private TbPurchaseMapper tbPurchaseMapper;

    @Autowired
    private TbInventoryMapper tbInventoryMapper;

    @Autowired
    private TbShortageMapper tbShortageMapper;

    @Autowired
    private NoticeService noticeService;

    @Autowired
    private TbSupplierMapper tbSupplierMapper;

    @Autowired
    private PurchaseStateService purchaseStateService;

    @Override
    public TbPurchase selectTbPurchaseById(Long purchaseId)
    {
        return tbPurchaseMapper.selectTbPurchaseById(purchaseId);
    }

    @Override
    public List<TbPurchase> list(TbPurchase tbPurchase) {
        return tbPurchaseMapper.selectTbPurchaseList(tbPurchase);
    }

    @Override
    public List<TbPurchase> selectTbPurchaseList(TbPurchase tbPurchase)
    {
        return tbPurchaseMapper.selectTbPurchaseList(tbPurchase);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int insertTbPurchase(TbPurchase tbPurchase, List<TbPurchaseDetail> details)
    {
        String purchaseNo = "CG" + DateUtils.dateTimeNow("yyyyMMddHHmmss")
                + IdUtils.fastSimpleUUID().substring(0, 6).toUpperCase();
        tbPurchase.setPurchaseNo(purchaseNo);
        purchaseStateService.initAsPending(tbPurchase);
        tbPurchase.setCreateTime(DateUtils.getNowDate());
        tbPurchase.setUpdateTime(DateUtils.getNowDate());

        int result = tbPurchaseMapper.insertTbPurchase(tbPurchase);

        if (result > 0 && details != null && !details.isEmpty()) {
            for (TbPurchaseDetail detail : details) {
                detail.setPurchaseId(tbPurchase.getBuyId());
                tbPurchaseMapper.insertTbPurchaseDetail(detail);
            }
        }

        return result;
    }

    @Override
    public int updateTbPurchase(TbPurchase tbPurchase)
    {
        TbPurchase existing = tbPurchaseMapper.selectTbPurchaseById(tbPurchase.getBuyId());
        purchaseStateService.validateCanModify(existing);
        tbPurchase.setUpdateTime(DateUtils.getNowDate());
        return tbPurchaseMapper.updateTbPurchase(tbPurchase);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int deleteTbPurchaseById(Long purchaseId)
    {
        TbPurchase existing = tbPurchaseMapper.selectTbPurchaseById(purchaseId);
        if (existing != null && ("1".equals(existing.getStatus())
                || "3".equals(existing.getStatus())
                || "4".equals(existing.getStatus())
                || "5".equals(existing.getStatus())
                || "6".equals(existing.getStatus()))) {
            throw new ServiceException("采购单[" + existing.getPurchaseNo() + "]已审核/已领书/已到货/已入库/已发货，禁止删除");
        }

        revertShortageStatusOnPurchaseDelete(purchaseId);

        return tbPurchaseMapper.deleteTbPurchaseById(purchaseId);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int deleteTbPurchaseByIds(Long[] purchaseIds)
    {
        for (Long purchaseId : purchaseIds) {
            TbPurchase existing = tbPurchaseMapper.selectTbPurchaseById(purchaseId);
            if (existing != null && ("1".equals(existing.getStatus())
                    || "3".equals(existing.getStatus())
                    || "4".equals(existing.getStatus())
                    || "5".equals(existing.getStatus())
                    || "6".equals(existing.getStatus()))) {
                throw new ServiceException("采购单[" + existing.getPurchaseNo() + "]已审核/已领书/已到货/已入库/已发货，禁止删除");
            }
            revertShortageStatusOnPurchaseDelete(purchaseId);
        }
        return tbPurchaseMapper.deleteTbPurchaseByIds(purchaseIds);
    }

    private void revertShortageStatusOnPurchaseDelete(Long purchaseId) {
        List<TbShortage> shortageList = tbShortageMapper.selectTbShortageListByPurchaseId(purchaseId);
        if (shortageList != null) {
            for (TbShortage shortage : shortageList) {
                if ("1".equals(shortage.getHandleStatus())) {
                    shortage.setHandleStatus("0");
                    shortage.setPurchaseId(null);
                    shortage.setUpdateTime(DateUtils.getNowDate());
                    tbShortageMapper.updateTbShortage(shortage);
                }
            }
        }
    }

    @Override
    public List<TbPurchaseDetail> selectTbPurchaseDetailListByPurchaseId(Long purchaseId)
    {
        return tbPurchaseMapper.selectTbPurchaseDetailListByPurchaseId(purchaseId);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int auditTbPurchase(Long purchaseId, String status)
    {
        TbPurchase purchase;
        if ("1".equals(status)) {
            purchase = purchaseStateService.auditApprove(purchaseId);
        } else if ("2".equals(status)) {
            purchase = purchaseStateService.auditReject(purchaseId, null);
        } else {
            throw new ServiceException("审核状态只能为1(通过)或2(驳回)");
        }

        purchase.setUpdateTime(DateUtils.getNowDate());
        int result = tbPurchaseMapper.updateTbPurchase(purchase);

        if ("1".equals(status) && purchase.getUserId() != null) {
            List<TbPurchaseDetail> details = tbPurchaseMapper.selectTbPurchaseDetailListByPurchaseId(purchaseId);
            StringBuilder bookNames = new StringBuilder();
            if (details != null) {
                for (TbPurchaseDetail d : details) {
                    if (bookNames.length() > 0) bookNames.append("、");
                    bookNames.append(d.getBookName());
                }
            }
            noticeService.sendOrderApproveNotice(
                    purchase.getUserId(),
                    bookNames.toString(),
                    "1",
                    "您的购书申请已审核通过",
                    purchaseId
            );
        } else if ("2".equals(status) && purchase.getUserId() != null) {
            noticeService.sendOrderApproveNotice(
                    purchase.getUserId(),
                    purchase.getRejectReason() != null ? purchase.getRejectReason() : "",
                    "2",
                    "您的购书申请已被驳回",
                    purchaseId
            );
        }

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
                    shortage.setRegisterId(SecurityUtils.getUserId());
                    shortage.setSource("1");
                    shortage.setSourceId(purchaseId);
                    shortage.setUpdateTime(DateUtils.getNowDate());
                    tbShortageMapper.insertTbShortage(shortage);

                    noticeService.sendLackNotice(
                            detail.getBookId(),
                            detail.getBookName(),
                            detail.getIsbn(),
                            shortageQuantity,
                            0,
                            shortage.getLackId()
                    );
                }
            }
        }

        return result;
    }

    @Override
    public int invoiceTbPurchase(Long purchaseId, String invoiceNo)
    {
        TbPurchase purchase = purchaseStateService.transitionToInbound(purchaseId);
        purchase.setInvoiceNo(invoiceNo);
        purchase.setUpdateTime(DateUtils.getNowDate());
        return tbPurchaseMapper.updateTbPurchase(purchase);
    }

    @Override
    public int confirmShipBySupplier(Long purchaseId, Long supplierUserId, String supplierName, String logisticsNo, String logisticsCompany) {
        TbPurchase purchase = tbPurchaseMapper.selectTbPurchaseById(purchaseId);
        if (purchase == null) {
            throw new ServiceException("采购单不存在");
        }

        if (purchase.getSupplierId() == null) {
            throw new ServiceException("采购单尚未分配供应商，无法确认发货");
        }
        TbSupplier supplier = tbSupplierMapper.selectByUserId(supplierUserId);
        if (supplier == null) {
            throw new ServiceException("当前用户不是供应商，无权操作");
        }
        if (!purchase.getSupplierId().equals(supplier.getSupplierId())) {
            throw new ServiceException("无权操作此采购单，您不是该采购单的供应商");
        }

        TbPurchase shippedPurchase = purchaseStateService.transitionToShipped(purchaseId);
        shippedPurchase.setLogisticsNo(logisticsNo);
        shippedPurchase.setLogisticsCompany(logisticsCompany);
        shippedPurchase.setRemark("供应商确认发货：" + logisticsCompany + "，物流单号：" + logisticsNo);
        shippedPurchase.setUpdateTime(DateUtils.getNowDate());
        return tbPurchaseMapper.updateTbPurchase(shippedPurchase);
    }
}
