package com.ruoyi.textbook.controller;

import java.util.List;
import javax.servlet.http.HttpServletResponse;
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
import com.ruoyi.common.utils.file.FileUtils;
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
        Long userId = SecurityUtils.getUserId();
        String userName = SecurityUtils.getLoginUser().getUser().getNickName();
        for (TbPurchase buy : buys) {
            buy.setUserId(userId);
            buy.setUserName(userName);
            buy.setCreateBy(getUsername());
        }
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
        buy.setUserId(SecurityUtils.getUserId());
        buy.setUserName(SecurityUtils.getLoginUser().getUser().getNickName());
        buy.setCreateBy(getUsername());
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

    @PreAuthorize("@ss.hasPermi('textbook:purchase:receive')")
    @Log(title = "确认下单通知供应商", businessType = BusinessType.UPDATE)
    @PutMapping("/confirmOrder/{id}")
    public AjaxResult confirmOrder(@PathVariable("id") Long buyId, @RequestParam Long supplierId) {
        return toAjax(tbBuyService.confirmOrder(buyId, supplierId));
    }

    @PreAuthorize("@ss.hasPermi('textbook:purchase:receive')")
    @Log(title = "确认到货", businessType = BusinessType.UPDATE)
    @PutMapping("/confirmArrived/{id}")
    public AjaxResult confirmArrived(@PathVariable("id") Long buyId) {
        return toAjax(tbBuyService.confirmArrived(buyId));
    }

    @PreAuthorize("@ss.hasPermi('textbook:purchase:receive')")
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

    @PreAuthorize("@ss.hasPermi('textbook:purchase:edit') and @ss.hasAnyRoles('admin,warehouse')")
    @Log(title = "调整采购单明细", businessType = BusinessType.UPDATE)
    @PutMapping("/adjustDetail/{id}")
    public AjaxResult adjustDetail(@PathVariable("id") Long buyId, @RequestBody List<TbPurchaseDetail> details) {
        return toAjax(tbBuyService.adjustDetail(buyId, details));
    }

    @PreAuthorize("@ss.hasPermi('textbook:purchase:edit') and @ss.hasAnyRoles('admin,warehouse')")
    @Log(title = "归档采购单", businessType = BusinessType.UPDATE)
    @PutMapping("/archive/{id}")
    public AjaxResult archive(@PathVariable("id") Long buyId) {
        return toAjax(tbBuyService.archivePurchase(buyId));
    }

    @PreAuthorize("@ss.hasPermi('textbook:purchase:list')")
    @GetMapping("/archivedList")
    public TableDataInfo archivedList(TbPurchase query) {
        startPage();
        return getDataTable(tbBuyService.listArchived(query));
    }

    @PreAuthorize("@ss.hasPermi('textbook:purchase:query')")
    @GetMapping("/detailList/{id}")
    public AjaxResult getDetailList(@PathVariable("id") Long buyId) {
        return AjaxResult.success(tbBuyService.selectDetailsByPurchaseId(buyId));
    }

    @PreAuthorize("@ss.hasPermi('textbook:purchase:import')")
    @GetMapping("/template")
    public void downloadTemplate(HttpServletResponse response) {
        try {
            response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
            FileUtils.setAttachmentResponseHeader(response, "采购单导入模板.xlsx");
        } catch (Exception ignored) {
        }
    }
}