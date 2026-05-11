package com.ruoyi.textbook.service.impl;

import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.textbook.domain.TbPurchase;
import com.ruoyi.textbook.domain.TbPurchaseDetail;
import com.ruoyi.textbook.domain.TbSupplier;
import com.ruoyi.textbook.enums.PurchaseStatusEnum;
import com.ruoyi.textbook.mapper.TbPurchaseMapper;
import com.ruoyi.textbook.mapper.TbSupplierMapper;
import com.ruoyi.textbook.service.ISupplierService;
import com.ruoyi.textbook.service.NoticeService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class SupplierServiceImpl implements ISupplierService {

    private static final Logger log = LoggerFactory.getLogger(SupplierServiceImpl.class);

    @Autowired
    private TbPurchaseMapper tbPurchaseMapper;

    @Autowired
    private TbSupplierMapper tbSupplierMapper;

    @Autowired
    private NoticeService noticeService;

    @Autowired
    private PurchaseStateService purchaseStateService;

    @Override
    public Map<String, Object> getSupplierDashboard() {
        Map<String, Object> dashboardData = new HashMap<>();
        
        // 获取当前供应商
        TbSupplier supplier = getCurrentSupplier();
        if (supplier == null) {
            dashboardData.put("unreadNoticeCount", 0);
            dashboardData.put("pendingShipmentCount", 0);
            return dashboardData;
        }
        
        // 计算未读通知数
        int unreadNoticeCount = noticeService.countUnreadNoticesBySupplierId(supplier.getUserId());
        dashboardData.put("unreadNoticeCount", unreadNoticeCount);
        
        // 计算待确认发货的采购单数
        int pendingShipmentCount = tbPurchaseMapper.countPendingShipmentBySupplierId(supplier.getSupplierId());
        dashboardData.put("pendingShipmentCount", pendingShipmentCount);
        
        return dashboardData;
    }

    @Override
    public List<TbPurchase> listSupplierPurchases(TbPurchase purchase) {
        TbSupplier supplier = getCurrentSupplier();
        if (supplier == null) {
            return new ArrayList<>();
        }
        
        purchase.setSupplierId(supplier.getSupplierId());
        List<TbPurchase> purchaseList = tbPurchaseMapper.selectSupplierPurchases(purchase);

        if (!purchaseList.isEmpty()) {
            List<Long> purchaseIds = new java.util.ArrayList<>();
            for (TbPurchase p : purchaseList) {
                purchaseIds.add(p.getBuyId());
            }
            List<TbPurchaseDetail> allDetails = tbPurchaseMapper.selectTbPurchaseDetailListByPurchaseIds(purchaseIds);
            java.util.Map<Long, List<TbPurchaseDetail>> detailMap = new java.util.HashMap<>();
            for (TbPurchaseDetail detail : allDetails) {
                detailMap.computeIfAbsent(detail.getPurchaseId(), k -> new java.util.ArrayList<>()).add(detail);
            }
            for (TbPurchase p : purchaseList) {
                p.setDetails(detailMap.getOrDefault(p.getBuyId(), java.util.Collections.emptyList()));
            }
        }

        return purchaseList;
    }

    @Override
    public TbPurchase getSupplierPurchaseDetail(Long purchaseId) {
        TbSupplier supplier = getCurrentSupplier();
        if (supplier == null) {
            return null;
        }
        
        TbPurchase purchase = tbPurchaseMapper.selectTbPurchaseById(purchaseId);
        if (purchase != null && supplier.getSupplierId().equals(purchase.getSupplierId())) {
            List<TbPurchaseDetail> details = tbPurchaseMapper.selectTbPurchaseDetailListByPurchaseId(purchaseId);
            purchase.setDetails(details);
        }
        
        return purchase;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void acceptOrder(Long purchaseId) {
        TbSupplier supplier = getCurrentSupplier();
        if (supplier == null) throw new ServiceException("供应商信息不存在");

        TbPurchase purchase = tbPurchaseMapper.selectTbPurchaseById(purchaseId);
        if (purchase == null || !supplier.getSupplierId().equals(purchase.getSupplierId())) {
            throw new ServiceException("采购单不存在或无权操作");
        }

        TbPurchase acceptedPurchase = purchaseStateService.transitionToAccepted(purchaseId);
        tbPurchaseMapper.updateTbPurchase(acceptedPurchase);
        log.info("【供应商接单】supplierId={}, purchaseId={}, purchaseNo={}", supplier.getSupplierId(), purchaseId, purchase.getPurchaseNo());
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void confirmShipment(Long purchaseId, String logisticsCompany, String logisticsNo, String remark) {
        TbSupplier supplier = getCurrentSupplier();
        if (supplier == null) {
            throw new ServiceException("供应商信息不存在");
        }
        
        TbPurchase purchase = tbPurchaseMapper.selectTbPurchaseById(purchaseId);
        if (purchase == null || !supplier.getSupplierId().equals(purchase.getSupplierId())) {
            throw new ServiceException("采购单不存在或无权操作");
        }

        TbPurchase shippedPurchase = purchaseStateService.transitionToShipped(purchaseId);
        shippedPurchase.setLogisticsCompany(logisticsCompany);
        shippedPurchase.setLogisticsNo(logisticsNo);
        tbPurchaseMapper.updateTbPurchase(shippedPurchase);
        
        // 发送通知给库管员
        noticeService.sendShipmentNotice(purchaseId, purchase.getPurchaseNo(), logisticsCompany, logisticsNo);
    }

    @Override
    public List<Map<String, Object>> listSupplierNotices() {
        TbSupplier supplier = getCurrentSupplier();
        if (supplier == null) {
            return new ArrayList<>();
        }
        
        return noticeService.getSupplierNotices(supplier.getUserId());
    }

    @Override
    public Map<String, Object> getSupplierNoticeDetail(Long noticeId) {
        TbSupplier supplier = getCurrentSupplier();
        if (supplier == null) {
            return null;
        }
        
        return noticeService.getSupplierNoticeDetail(noticeId, supplier.getUserId());
    }

    @Override
    public void markNoticeAsRead(Long noticeId) {
        TbSupplier supplier = getCurrentSupplier();
        if (supplier == null) {
            return;
        }
        
        noticeService.markNoticeAsRead(noticeId, supplier.getUserId());
    }

    @Override
    public void markAllNoticesAsRead() {
        TbSupplier supplier = getCurrentSupplier();
        if (supplier == null) {
            return;
        }
        
        noticeService.markAllNoticesAsRead(supplier.getUserId());
    }

    @Override
    public TbSupplier getSupplierByUserId(Long userId) {
        return tbSupplierMapper.selectByUserId(userId);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void markDetail(Long purchaseId, Long detailId, String feedback, String remark) {
        TbSupplier supplier = getCurrentSupplier();
        if (supplier == null) throw new ServiceException("供应商信息不存在");

        TbPurchase purchase = tbPurchaseMapper.selectTbPurchaseById(purchaseId);
        if (purchase == null || !supplier.getSupplierId().equals(purchase.getSupplierId())) {
            throw new ServiceException("采购单不存在或无权操作");
        }

        List<TbPurchaseDetail> details = tbPurchaseMapper.selectTbPurchaseDetailListByPurchaseId(purchaseId);
        TbPurchaseDetail target = null;
        for (TbPurchaseDetail d : details) {
            if (d.getDetailId().equals(detailId)) {
                target = d;
                break;
            }
        }
        if (target == null) throw new ServiceException("采购明细不存在");

        target.setSupplierFeedback(feedback);
        target.setSupplierRemark(remark);
        tbPurchaseMapper.updateTbPurchaseDetail(target);
        log.info("【供应商标记明细】purchaseId={}, detailId={}, feedback={}", purchaseId, detailId, feedback);

        boolean hasShortage = false;
        for (TbPurchaseDetail d : details) {
            if ("2".equals(d.getSupplierFeedback()) || "3".equals(d.getSupplierFeedback())) {
                hasShortage = true;
                break;
            }
        }
        if (hasShortage) {
            noticeService.sendNoticeToRole("warehouse", "采购单明细需要处理",
                    "采购单" + purchase.getPurchaseNo() + "有明细被标记为缺货或信息有误，请及时处理。",
                    "2", purchaseId);
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void rejectOrder(Long purchaseId, String reason) {
        TbSupplier supplier = getCurrentSupplier();
        if (supplier == null) throw new ServiceException("供应商信息不存在");

        TbPurchase purchase = tbPurchaseMapper.selectTbPurchaseById(purchaseId);
        if (purchase == null || !supplier.getSupplierId().equals(purchase.getSupplierId())) {
            throw new ServiceException("采购单不存在或无权操作");
        }

        purchase.setPurchaseStatus(PurchaseStatusEnum.WAIT_PURCHASE.getCode());
        purchase.setRemark((purchase.getRemark() == null ? "" : purchase.getRemark() + "; ") + "供应商退回原因：" + reason);
        tbPurchaseMapper.updateTbPurchase(purchase);

        noticeService.sendNoticeToRole("warehouse", "供应商退回采购单",
                "供应商" + supplier.getSupplierName() + "已退回采购单" + purchase.getPurchaseNo() + "，原因：" + reason,
                "2", purchaseId);
        log.info("【供应商退回采购单】purchaseId={}, reason={}", purchaseId, reason);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void updateShipment(Long purchaseId, String logisticsCompany, String logisticsNo) {
        TbSupplier supplier = getCurrentSupplier();
        if (supplier == null) throw new ServiceException("供应商信息不存在");

        TbPurchase purchase = tbPurchaseMapper.selectTbPurchaseById(purchaseId);
        if (purchase == null || !supplier.getSupplierId().equals(purchase.getSupplierId())) {
            throw new ServiceException("采购单不存在或无权操作");
        }
        String status = purchase.getPurchaseStatus();
        if (!PurchaseStatusEnum.SHIPPED.getCode().equals(status) && !PurchaseStatusEnum.ARRIVED.getCode().equals(status)) {
            throw new ServiceException("只有已发货状态的采购单才能修改物流信息");
        }

        purchase.setLogisticsCompany(logisticsCompany);
        purchase.setLogisticsNo(logisticsNo);
        tbPurchaseMapper.updateTbPurchase(purchase);
        log.info("【供应商修改物流】purchaseId={}", purchaseId);
    }

    @Override
    public List<TbPurchase> listHistoryOrders(TbPurchase purchase) {
        TbSupplier supplier = getCurrentSupplier();
        if (supplier == null) return new ArrayList<>();
        purchase.setSupplierId(supplier.getSupplierId());
        return tbPurchaseMapper.selectSupplierPurchases(purchase);
    }

    private TbSupplier getCurrentSupplier() {
        Long userId = SecurityUtils.getUserId();
        return tbSupplierMapper.selectByUserId(userId);
    }
}
