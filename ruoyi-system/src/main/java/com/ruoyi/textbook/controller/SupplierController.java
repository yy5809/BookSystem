package com.ruoyi.textbook.controller;

import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.textbook.domain.TbPurchase;
import com.ruoyi.textbook.domain.TbPurchaseDetail;
import com.ruoyi.textbook.domain.TbSupplier;
import com.ruoyi.textbook.service.ISupplierService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/textbook/supplier")
public class SupplierController extends BaseController {

    @Autowired
    private ISupplierService supplierService;

    // 供应商工作台数据
    @PreAuthorize("@ss.hasRole('supplier')")
    @GetMapping("/dashboard")
    public AjaxResult getDashboard() {
        Map<String, Object> dashboardData = supplierService.getSupplierDashboard();
        return AjaxResult.success(dashboardData);
    }

    // 供应商采购单列表
    @PreAuthorize("@ss.hasRole('supplier')")
    @GetMapping("/purchase/list")
    public TableDataInfo listSupplierPurchases(TbPurchase purchase) {
        startPage();
        List<TbPurchase> list = supplierService.listSupplierPurchases(purchase);
        return getDataTable(list);
    }

    // 供应商采购单详情
    @PreAuthorize("@ss.hasRole('supplier')")
    @GetMapping("/purchase/detail/{purchaseId}")
    public AjaxResult getSupplierPurchaseDetail(@PathVariable Long purchaseId) {
        TbPurchase purchase = supplierService.getSupplierPurchaseDetail(purchaseId);
        return AjaxResult.success(purchase);
    }

    // 供应商确认发货
    @PreAuthorize("@ss.hasRole('supplier')")
    @PostMapping("/purchase/shipment")
    public AjaxResult confirmShipment(@RequestBody Map<String, Object> shipmentData) {
        Long purchaseId = Long.valueOf(shipmentData.get("purchaseId").toString());
        String logisticsCompany = (String) shipmentData.get("logisticsCompany");
        String logisticsNo = (String) shipmentData.get("logisticsNo");
        String remark = (String) shipmentData.get("remark");
        supplierService.confirmShipment(purchaseId, logisticsCompany, logisticsNo, remark);
        return AjaxResult.success("发货确认成功");
    }

    // 供应商通知列表
    @PreAuthorize("@ss.hasRole('supplier')")
    @GetMapping("/notice/list")
    public TableDataInfo listSupplierNotices() {
        startPage();
        List<Map<String, Object>> list = supplierService.listSupplierNotices();
        return getDataTable(list);
    }

    // 供应商通知详情
    @PreAuthorize("@ss.hasRole('supplier')")
    @GetMapping("/notice/detail/{noticeId}")
    public AjaxResult getSupplierNoticeDetail(@PathVariable Long noticeId) {
        Map<String, Object> notice = supplierService.getSupplierNoticeDetail(noticeId);
        return AjaxResult.success(notice);
    }

    // 标记通知为已读
    @PreAuthorize("@ss.hasRole('supplier')")
    @PutMapping("/notice/read/{noticeId}")
    public AjaxResult markNoticeAsRead(@PathVariable Long noticeId) {
        supplierService.markNoticeAsRead(noticeId);
        return AjaxResult.success("标记已读成功");
    }

    // 全部标记为已读
    @PreAuthorize("@ss.hasRole('supplier')")
    @PutMapping("/notice/read/all")
    public AjaxResult markAllNoticesAsRead() {
        supplierService.markAllNoticesAsRead();
        return AjaxResult.success("全部标记已读成功");
    }
}