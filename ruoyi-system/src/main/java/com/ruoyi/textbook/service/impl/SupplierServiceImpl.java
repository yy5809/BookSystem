package com.ruoyi.textbook.service.impl;

import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.textbook.domain.TbPurchase;
import com.ruoyi.textbook.domain.TbPurchaseDetail;
import com.ruoyi.textbook.domain.TbSupplier;
import com.ruoyi.textbook.mapper.TbPurchaseMapper;
import com.ruoyi.textbook.mapper.TbSupplierMapper;
import com.ruoyi.textbook.service.ISupplierService;
import com.ruoyi.textbook.service.NoticeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class SupplierServiceImpl implements ISupplierService {

    @Autowired
    private TbPurchaseMapper tbPurchaseMapper;

    @Autowired
    private TbSupplierMapper tbSupplierMapper;

    @Autowired
    private NoticeService noticeService;

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
        int unreadNoticeCount = noticeService.countUnreadNoticesBySupplierId(supplier.getSupplierId());
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
        
        // 加载采购明细
        for (TbPurchase p : purchaseList) {
            List<TbPurchaseDetail> details = tbPurchaseMapper.selectTbPurchaseDetailListByPurchaseId(p.getBuyId());
            p.setDetails(details);
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
    public void confirmShipment(Long purchaseId, String logisticsCompany, String logisticsNo, String remark) {
        TbSupplier supplier = getCurrentSupplier();
        if (supplier == null) {
            throw new RuntimeException("供应商信息不存在");
        }
        
        TbPurchase purchase = tbPurchaseMapper.selectTbPurchaseById(purchaseId);
        if (purchase == null || !supplier.getSupplierId().equals(purchase.getSupplierId())) {
            throw new RuntimeException("采购单不存在或无权操作");
        }
        
        if (!"1".equals(purchase.getStatus())) {
            throw new RuntimeException("采购单状态不是采购中，无法确认发货");
        }
        
        // 更新采购单状态和物流信息
        purchase.setStatus("2"); // 已发货
        purchase.setLogisticsCompany(logisticsCompany);
        purchase.setLogisticsNo(logisticsNo);
        tbPurchaseMapper.updateTbPurchase(purchase);
        
        // 发送通知给库管员
        noticeService.sendShipmentNotice(purchaseId, purchase.getPurchaseNo(), logisticsCompany, logisticsNo);
    }

    @Override
    public List<Map<String, Object>> listSupplierNotices() {
        TbSupplier supplier = getCurrentSupplier();
        if (supplier == null) {
            return new ArrayList<>();
        }
        
        return noticeService.getSupplierNotices(supplier.getSupplierId());
    }

    @Override
    public Map<String, Object> getSupplierNoticeDetail(Long noticeId) {
        TbSupplier supplier = getCurrentSupplier();
        if (supplier == null) {
            return null;
        }
        
        return noticeService.getSupplierNoticeDetail(noticeId, supplier.getSupplierId());
    }

    @Override
    public void markNoticeAsRead(Long noticeId) {
        TbSupplier supplier = getCurrentSupplier();
        if (supplier == null) {
            return;
        }
        
        noticeService.markNoticeAsRead(noticeId, supplier.getSupplierId());
    }

    @Override
    public void markAllNoticesAsRead() {
        TbSupplier supplier = getCurrentSupplier();
        if (supplier == null) {
            return;
        }
        
        noticeService.markAllNoticesAsRead(supplier.getSupplierId());
    }

    @Override
    public TbSupplier getSupplierByUserId(Long userId) {
        return tbSupplierMapper.selectByUserId(userId);
    }

    // 获取当前供应商
    private TbSupplier getCurrentSupplier() {
        Long userId = SecurityUtils.getUserId();
        return tbSupplierMapper.selectByUserId(userId);
    }
}
