package com.ruoyi.textbook.controller;

import java.util.List;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import com.ruoyi.common.annotation.DataScope;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.textbook.domain.TbPurchase;
import com.ruoyi.textbook.domain.dto.AuditRequest;
import com.ruoyi.textbook.service.ITbBuyService;

import javax.validation.Valid;

@RestController
@RequestMapping("/textbook/purchase")
public class TbPurchaseController extends BaseController {

    @Autowired
    private ITbBuyService tbBuyService;

    @PreAuthorize("@ss.hasPermi('textbook:purchase:list')")
    @DataScope(userAlias = "user_id")
    @GetMapping("/list")
    public TableDataInfo list(TbPurchase query) {
        startPage();
        return getDataTable(tbBuyService.list(query));
    }

    @PreAuthorize("@ss.hasPermi('textbook:purchase:add')")
    @Log(title = "购书单批量提交", businessType = BusinessType.INSERT)
    @PostMapping("/batchSubmit")
    public AjaxResult batchSubmit(@RequestBody List<TbPurchase> buys) {
        return toAjax(tbBuyService.batchSubmit(buys));
    }

    @PreAuthorize("@ss.hasPermi('textbook:purchase:query')")
    @GetMapping("/detail/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long buyId) {
        return AjaxResult.success(tbBuyService.getById(buyId));
    }

    @PreAuthorize("@ss.hasPermi('textbook:purchase:add')")
    @Log(title = "购书单", businessType = BusinessType.INSERT)
    @PostMapping("/submit")
    public AjaxResult submit(@Valid @RequestBody TbPurchase buy) {
        return toAjax(tbBuyService.submit(buy));
    }

    @PreAuthorize("@ss.hasPermi('textbook:purchase:audit') and @ss.hasAnyRoles('admin,warehouse')")
    @Log(title = "购书单审核", businessType = BusinessType.UPDATE)
    @PutMapping("/audit")
    public AjaxResult audit(@Valid @RequestBody AuditRequest request) {
        return toAjax(tbBuyService.audit(
            request.getBuyId(),
            request.getStatus(),
            request.getRejectReason()));
    }

    @PreAuthorize("@ss.hasAnyRoles('admin,warehouse')")
    @Log(title = "确认下单通知供应商", businessType = BusinessType.UPDATE)
    @PutMapping("/confirmOrder/{id}")
    public AjaxResult confirmOrder(@PathVariable("id") Long buyId, @RequestParam Long supplierId) {
        return toAjax(tbBuyService.confirmOrder(buyId, supplierId));
    }

    @PreAuthorize("@ss.hasAnyRoles('admin,warehouse')")
    @Log(title = "确认到货", businessType = BusinessType.UPDATE)
    @PutMapping("/confirmArrived/{id}")
    public AjaxResult confirmArrived(@PathVariable("id") Long buyId) {
        return toAjax(tbBuyService.confirmArrived(buyId));
    }

    @PreAuthorize("@ss.hasAnyRoles('admin,warehouse')")
    @Log(title = "验收入库", businessType = BusinessType.UPDATE)
    @PutMapping("/confirmInbound/{id}")
    public AjaxResult confirmInbound(@PathVariable("id") Long buyId) {
        return toAjax(tbBuyService.confirmInbound(buyId));
    }

    @PreAuthorize("@ss.hasPermi('textbook:purchase:add')")
    @Log(title = "取消购书单", businessType = BusinessType.UPDATE)
    @PutMapping("/cancel/{id}")
    public AjaxResult cancel(@PathVariable("id") Long buyId) {
        return toAjax(tbBuyService.cancelOrder(buyId));
    }

    @PreAuthorize("@ss.hasPermi('textbook:purchase:receive') and @ss.hasAnyRoles('admin,warehouse')")
    @Log(title = "领书确认", businessType = BusinessType.UPDATE)
    @PutMapping("/receive/{id}")
    public AjaxResult receive(@PathVariable("id") Long buyId) {
        return toAjax(tbBuyService.confirmReceive(buyId));
    }

    @PreAuthorize("@ss.hasPermi('textbook:purchase:remove')")
    @Log(title = "购书单", businessType = BusinessType.DELETE)
    @DeleteMapping("/remove/{id}")
    public AjaxResult remove(@PathVariable("id") Long buyId) {
        return toAjax(tbBuyService.deleteWithCheck(buyId));
    }
}