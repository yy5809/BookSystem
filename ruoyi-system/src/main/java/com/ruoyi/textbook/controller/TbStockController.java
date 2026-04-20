package com.ruoyi.textbook.controller;

import java.util.List;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.textbook.domain.TbInventory;
import com.ruoyi.textbook.service.ITbInventoryService;

@RestController
@RequestMapping("/textbook/stock")
public class TbStockController extends BaseController {

    @Autowired
    private ITbInventoryService tbInventoryService;

    @PreAuthorize("@ss.hasPermi('textbook:stock:list')")
    @GetMapping("/list")
    public TableDataInfo list(TbInventory query) {
        startPage();
        List<TbInventory> list = tbInventoryService.selectTbInventoryList(query);
        return getDataTable(list);
    }

    @PreAuthorize("@ss.hasPermi('textbook:stock:export')")
    @Log(title = "库存", businessType = BusinessType.EXPORT)
    @GetMapping("/export")
    public AjaxResult export(TbInventory query) {
        List<TbInventory> list = tbInventoryService.selectTbInventoryList(query);
        ExcelUtil<TbInventory> util = new ExcelUtil<TbInventory>(TbInventory.class);
        return util.exportExcel(list, "库存数据");
    }

    @PreAuthorize("@ss.hasPermi('textbook:stock:query')")
    @GetMapping("/{stockId}")
    public AjaxResult getInfo(@PathVariable Long stockId) {
        return AjaxResult.success(tbInventoryService.selectTbInventoryByInventoryId(stockId));
    }

    @PreAuthorize("@ss.hasPermi('textbook:stock:edit') and @ss.hasAnyRoles('admin,warehouse_manager')")
    @Log(title = "库存-修改预警阈值和存放地址", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody TbInventory stock) {
        stock.setStockNum(null);
        stock.setTotalPurchase(null);
        stock.setTotalIssued(null);
        stock.setVersion(null);
        return toAjax(tbInventoryService.updateTbInventory(stock));
    }
}
