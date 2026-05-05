package com.ruoyi.textbook.controller;

import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.textbook.domain.TbPurchase;
import com.ruoyi.textbook.service.ISupplierService;
import com.ruoyi.textbook.service.ITbSupplierService;
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

    @Autowired
    private ITbSupplierService tbSupplierService;

    @PreAuthorize("@ss.hasRole('supplier')")
    @GetMapping("/dashboard")
    public AjaxResult getDashboard() {
        Map<String, Object> dashboardData = supplierService.getSupplierDashboard();
        return AjaxResult.success(dashboardData);
    }

    @PreAuthorize("@ss.hasRole('supplier')")
    @GetMapping("/purchase/list")
    public TableDataInfo listSupplierPurchases(TbPurchase purchase) {
        startPage();
        List<TbPurchase> list = supplierService.listSupplierPurchases(purchase);
        return getDataTable(list);
    }

    @PreAuthorize("@ss.hasRole('supplier')")
    @PutMapping("/purchase/accept/{purchaseId}")
    public AjaxResult acceptOrder(@PathVariable Long purchaseId) {
        supplierService.acceptOrder(purchaseId);
        return AjaxResult.success("已接单");
    }

    @PreAuthorize("@ss.hasRole('supplier')")
    @GetMapping("/purchase/detail/{purchaseId}")
    public AjaxResult getSupplierPurchaseDetail(@PathVariable Long purchaseId) {
        TbPurchase purchase = supplierService.getSupplierPurchaseDetail(purchaseId);
        if (purchase == null) {
            throw new ServiceException("采购单不存在或无权查看");
        }
        return AjaxResult.success(purchase);
    }

    @PreAuthorize("@ss.hasRole('supplier')")
    @PostMapping("/purchase/shipment")
    public AjaxResult confirmShipment(@RequestBody Map<String, Object> shipmentData) {
        if (shipmentData.get("purchaseId") == null) {
            throw new ServiceException("采购单ID不能为空");
        }
        Long purchaseId;
        try {
            purchaseId = Long.valueOf(shipmentData.get("purchaseId").toString());
        } catch (NumberFormatException e) {
            throw new ServiceException("采购单ID格式错误");
        }
        String logisticsCompany = (String) shipmentData.get("logisticsCompany");
        String logisticsNo = (String) shipmentData.get("logisticsNo");
        String remark = (String) shipmentData.get("remark");
        if (logisticsCompany == null || logisticsCompany.trim().isEmpty()) {
            throw new ServiceException("物流公司不能为空");
        }
        if (logisticsNo == null || logisticsNo.trim().isEmpty()) {
            throw new ServiceException("物流单号不能为空");
        }
        supplierService.confirmShipment(purchaseId, logisticsCompany, logisticsNo, remark);
        return AjaxResult.success("发货确认成功");
    }

    @PreAuthorize("@ss.hasRole('supplier')")
    @GetMapping("/notice/list")
    public TableDataInfo listSupplierNotices() {
        startPage();
        List<Map<String, Object>> list = supplierService.listSupplierNotices();
        return getDataTable(list);
    }

    @PreAuthorize("@ss.hasRole('supplier')")
    @GetMapping("/notice/detail/{noticeId}")
    public AjaxResult getSupplierNoticeDetail(@PathVariable Long noticeId) {
        Map<String, Object> notice = supplierService.getSupplierNoticeDetail(noticeId);
        if (notice == null) {
            throw new ServiceException("通知不存在或无权查看");
        }
        return AjaxResult.success(notice);
    }

    @PreAuthorize("@ss.hasRole('supplier')")
    @PutMapping("/notice/read/{noticeId}")
    public AjaxResult markNoticeAsRead(@PathVariable Long noticeId) {
        supplierService.markNoticeAsRead(noticeId);
        return AjaxResult.success("标记已读成功");
    }

    @PreAuthorize("@ss.hasRole('supplier')")
    @PutMapping("/notice/read/all")
    public AjaxResult markAllNoticesAsRead() {
        supplierService.markAllNoticesAsRead();
        return AjaxResult.success("全部标记已读成功");
    }
}
