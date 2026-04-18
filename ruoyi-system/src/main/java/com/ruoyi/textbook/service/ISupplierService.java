package com.ruoyi.textbook.service;

import com.ruoyi.textbook.domain.TbPurchase;
import com.ruoyi.textbook.domain.TbSupplier;

import java.util.List;
import java.util.Map;

public interface ISupplierService {

    // 获取供应商工作台数据
    Map<String, Object> getSupplierDashboard();

    // 获取供应商采购单列表
    List<TbPurchase> listSupplierPurchases(TbPurchase purchase);

    // 获取供应商采购单详情
    TbPurchase getSupplierPurchaseDetail(Long purchaseId);

    // 供应商确认发货
    void confirmShipment(Long purchaseId, String logisticsCompany, String logisticsNo, String remark);

    // 获取供应商通知列表
    List<Map<String, Object>> listSupplierNotices();

    // 获取供应商通知详情
    Map<String, Object> getSupplierNoticeDetail(Long noticeId);

    // 标记通知为已读
    void markNoticeAsRead(Long noticeId);

    // 全部标记为已读
    void markAllNoticesAsRead();

    // 根据用户ID获取供应商信息
    TbSupplier getSupplierByUserId(Long userId);
}
