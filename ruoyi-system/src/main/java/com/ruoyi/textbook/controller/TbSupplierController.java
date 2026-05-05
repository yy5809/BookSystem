package com.ruoyi.textbook.controller;

import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.annotation.RepeatSubmit;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.textbook.domain.TbPurchase;
import com.ruoyi.textbook.domain.TbSupplier;
import com.ruoyi.textbook.domain.vo.SupplierVO;
import com.ruoyi.textbook.service.ITbPurchaseService;
import com.ruoyi.textbook.service.ITbSupplierService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/textbook/tbSupplier")
public class TbSupplierController extends BaseController {

    private static final Logger log = LoggerFactory.getLogger(TbSupplierController.class);

    @Autowired
    private ITbSupplierService tbSupplierService;

    @Autowired
    private ITbPurchaseService tbPurchaseService;

    @PreAuthorize("@ss.hasPermi('textbook:supplier:list')")
    @GetMapping("/list")
    public TableDataInfo list(TbSupplier tbSupplier) {
        startPage();
        List<SupplierVO> list = tbSupplierService.selectSupplierVOList(tbSupplier);
        return getDataTable(list);
    }

    @PreAuthorize("@ss.hasPermi('textbook:supplier:query')")
    @GetMapping("/{supplierId:\\d+}")
    public AjaxResult getInfo(@PathVariable Long supplierId) {
        return AjaxResult.success(tbSupplierService.selectSupplierVOById(supplierId));
    }

    @PreAuthorize("@ss.hasPermi('textbook:supplier:add') and @ss.hasAnyRoles('admin,warehouse')")
    @Log(title = "供应商", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody TbSupplier tbSupplier) {
        return toAjax(tbSupplierService.insertTbSupplier(tbSupplier));
    }

    @PreAuthorize("@ss.hasPermi('textbook:supplier:edit') and @ss.hasAnyRoles('admin,warehouse')")
    @Log(title = "供应商", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody TbSupplier tbSupplier) {
        return toAjax(tbSupplierService.updateTbSupplier(tbSupplier));
    }

    @PreAuthorize("@ss.hasPermi('textbook:supplier:remove') and @ss.hasAnyRoles('admin,warehouse')")
    @Log(title = "供应商", businessType = BusinessType.DELETE)
    @DeleteMapping("/{supplierIds}")
    public AjaxResult remove(@PathVariable Long[] supplierIds) {
        return toAjax(tbSupplierService.deleteTbSupplierByIds(supplierIds));
    }

    @PreAuthorize("@ss.hasAnyRoles('admin,warehouse')")
    @GetMapping("/options")
    public AjaxResult options() {
        TbSupplier query = new TbSupplier();
        query.setStatus("0");
        List<TbSupplier> all = tbSupplierService.selectTbSupplierList(query);
        return AjaxResult.success(all);
    }

    @PreAuthorize("@ss.hasPermi('textbook:supplierPurchase:list')")
    @GetMapping("/purchase/list")
    public TableDataInfo myPurchaseList(TbPurchase query) {
        Long currentUserId = SecurityUtils.getUserId();
        TbSupplier supplier = tbSupplierService.selectSupplierByUserId(currentUserId);

        if (supplier == null) {
            log.warn("当前用户未关联供应商账号, userId={}", currentUserId);
            return getDataTable(java.util.Collections.emptyList());
        }

        query.setSupplierId(supplier.getSupplierId());
        startPage();
        List<TbPurchase> list = tbPurchaseService.list(query);
        return getDataTable(list);
    }

    @RepeatSubmit
    @PreAuthorize("@ss.hasPermi('textbook:supplierPurchase:ship')")
    @Log(title = "供应商确认发货", businessType = BusinessType.UPDATE)
    @PutMapping("/purchase/ship/{purchaseId}")
    public AjaxResult confirmShip(@PathVariable Long purchaseId,
                                  @RequestParam(required = false) String logisticsNo,
                                  @RequestParam(required = false) String logisticsCompany) {
        Long currentUserId = SecurityUtils.getUserId();
        String username = SecurityUtils.getUsername();

        log.info("【供应商发货】用户={}, 确认采购单发货, purchaseId={}, 物流单号={}", username, purchaseId, logisticsNo);

        int result = tbPurchaseService.confirmShipBySupplier(
                purchaseId,
                currentUserId,
                username,
                logisticsNo,
                logisticsCompany
        );

        if (result > 0) {
            log.info("【供应商发货】成功! purchaseId={}", purchaseId);
            return AjaxResult.success("发货确认成功");
        } else {
            return AjaxResult.error("发货确认失败，请检查采购单状态");
        }
    }
}
