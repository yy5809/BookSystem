package com.ruoyi.textbook.controller;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.textbook.domain.TbInventoryCheck;
import com.ruoyi.textbook.service.ITbInventoryCheckService;

@RestController
@RequestMapping("/textbook/inventoryCheck")
public class TbInventoryCheckController extends BaseController {

    @Autowired
    private ITbInventoryCheckService inventoryCheckService;

    @PreAuthorize("@ss.hasPermi('textbook:inventoryCheck:list')")
    @GetMapping("/list")
    public TableDataInfo list(TbInventoryCheck query) {
        startPage();
        List<TbInventoryCheck> list = inventoryCheckService.selectTbInventoryCheckList(query);
        return getDataTable(list);
    }

    @PreAuthorize("@ss.hasPermi('textbook:inventoryCheck:query')")
    @GetMapping("/{checkId:\\d+}")
    public AjaxResult getInfo(@PathVariable Long checkId) {
        AjaxResult ajax = AjaxResult.success();
        ajax.put("check", inventoryCheckService.selectTbInventoryCheckById(checkId));
        ajax.put("details", inventoryCheckService.selectCheckDetailByCheckId(checkId));
        return ajax;
    }

    @PreAuthorize("@ss.hasPermi('textbook:inventoryCheck:add') and @ss.hasAnyRoles('admin,warehouse')")
    @Log(title = "创建盘点任务", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody TbInventoryCheck check) {
        check.setWarehousemanId(SecurityUtils.getUserId());
        check.setWarehousemanName(SecurityUtils.getUsername());
        return toAjax(inventoryCheckService.createCheckTask(check));
    }

    @PreAuthorize("@ss.hasPermi('textbook:inventoryCheck:edit') and @ss.hasAnyRoles('admin,warehouse')")
    @Log(title = "开始盘点", businessType = BusinessType.UPDATE)
    @PutMapping("/start/{checkId}")
    public AjaxResult startCheck(@PathVariable Long checkId) {
        return toAjax(inventoryCheckService.startCheck(checkId));
    }

    @PreAuthorize("@ss.hasPermi('textbook:inventoryCheck:edit') and @ss.hasAnyRoles('admin,warehouse')")
    @Log(title = "完成盘点", businessType = BusinessType.UPDATE)
    @PutMapping("/complete/{checkId}")
    public AjaxResult completeCheck(@PathVariable Long checkId) {
        return toAjax(inventoryCheckService.completeCheck(checkId));
    }

    @PreAuthorize("@ss.hasPermi('textbook:inventoryCheck:remove') and @ss.hasAnyRoles('admin,warehouse')")
    @Log(title = "取消盘点", businessType = BusinessType.DELETE)
    @DeleteMapping("/{checkIds:\\d+}")
    public AjaxResult remove(@PathVariable Long[] checkIds) {
        return toAjax(inventoryCheckService.deleteTbInventoryCheckByIds(checkIds));
    }

    @PreAuthorize("@ss.hasPermi('textbook:inventoryCheck:query')")
    @GetMapping("/stats")
    public AjaxResult stats() {
        return AjaxResult.success(inventoryCheckService.getCheckStats());
    }
}
