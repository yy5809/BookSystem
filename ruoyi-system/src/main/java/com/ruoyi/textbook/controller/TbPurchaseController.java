package com.ruoyi.textbook.controller;

import java.util.List;
import java.util.Map;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import com.ruoyi.common.annotation.DataScope;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.textbook.domain.TbPurchase;
import com.ruoyi.textbook.domain.TbPurchaseDetail;
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

    @PreAuthorize("@ss.hasPermi('textbook:purchase:add')")
    @Log(title = "取消购书单", businessType = BusinessType.UPDATE)
    @PutMapping("/cancel/{id}")
    public AjaxResult cancel(@PathVariable("id") Long buyId) {
        TbPurchase order = tbBuyService.getById(buyId);
        if (order == null) { return AjaxResult.error("订单不存在"); }
        if (!order.getUserId().equals(SecurityUtils.getUserId())) {
            return AjaxResult.error("只能取消自己的订单");
        }
        if (!"0".equals(order.getStatus())) {
            return AjaxResult.error("只能取消待审核的订单");
        }
        return toAjax(tbBuyService.cancelOrder(buyId));
    }

    @PreAuthorize("@ss.hasPermi('textbook:purchase:add')")
    @Log(title = "领书确认", businessType = BusinessType.UPDATE)
    @PutMapping("/receive/{id}")
    public AjaxResult receive(@PathVariable("id") Long buyId) {
        return toAjax(tbBuyService.confirmReceive(buyId));
    }

    @PreAuthorize("@ss.hasPermi('textbook:purchase:remove')")
    @Log(title = "购书单", businessType = BusinessType.DELETE)
    @DeleteMapping("/remove/{id}")
    public AjaxResult remove(@PathVariable("id") Long buyId) {
        TbPurchase order = tbBuyService.getById(buyId);
        if (order == null) { return AjaxResult.error("订单不存在"); }
        if ("5".equals(order.getStatus())) {
            return AjaxResult.error("该采购单已入库，禁止删除。已入库的单据不可删除以保证数据完整性。");
        }
        if ("4".equals(order.getStatus())) {
            return AjaxResult.error("该采购单已到货，禁止删除。请先完成入库流程。");
        }
        if ("3".equals(order.getStatus())) {
            return AjaxResult.error("该订单已完成领书，禁止删除。已完成领书的单据不可删除以保证数据完整性。");
        }
        if ("1".equals(order.getStatus())) {
            return AjaxResult.error("该订单已审核通过，禁止删除。如需取消请联系库管员驳回。");
        }
        return toAjax(tbBuyService.delete(new Long[]{buyId}));
    }
}