package com.ruoyi.textbook.controller;

import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.textbook.annotation.MaxExportRows;
import com.ruoyi.textbook.domain.TbInventory;
import com.ruoyi.textbook.service.ITbInventoryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletResponse;
import java.util.List;

@RestController
@RequestMapping("/textbook/inventory")
public class TbInventoryController extends BaseController
{
    @Autowired
    private ITbInventoryService tbInventoryService;

    @PreAuthorize("@ss.hasPermi('textbook:inventory:list')")
    @GetMapping("/list")
    public TableDataInfo list(TbInventory tbInventory) {
        startPage();
        List<TbInventory> list = tbInventoryService.selectTbInventoryList(tbInventory);
        return getDataTable(list);
    }

    @PreAuthorize("@ss.hasPermi('textbook:inventory:export')")
    @MaxExportRows(value = 10000, message = "导出数据量超过限制")
    @PostMapping("/export")
    public void export(HttpServletResponse response, TbInventory tbInventory) {
        List<TbInventory> list = tbInventoryService.selectTbInventoryList(tbInventory);
        ExcelUtil<TbInventory> util = new ExcelUtil<>(TbInventory.class);
        util.exportExcel(response, list, "库存信息数据");
    }

    @PreAuthorize("@ss.hasPermi('textbook:inventory:query')")
    @GetMapping(value = "/{inventoryId}")
    public AjaxResult getInfo(@PathVariable("inventoryId") Long inventoryId) {
        return AjaxResult.success(tbInventoryService.selectTbInventoryByInventoryId(inventoryId));
    }

    @PreAuthorize("@ss.hasPermi('textbook:inventory:warning')")
    @GetMapping("/warning")
    public TableDataInfo getInventoryWarningList() {
        startPage();
        List<TbInventory> list = tbInventoryService.selectWarningList();
        return getDataTable(list);
    }

    @PreAuthorize("@ss.hasPermi('textbook:inventory:query')")
    @GetMapping("/byBook/{bookId}")
    public AjaxResult getByBookId(@PathVariable Long bookId) {
        return AjaxResult.success(tbInventoryService.selectTbInventoryByBookId(bookId));
    }
}
