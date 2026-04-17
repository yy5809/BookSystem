package com.ruoyi.textbook.controller;

import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.exception.ServiceException;
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
    @GetMapping(value = "/{stockId}")
    public AjaxResult getInfo(@PathVariable("stockId") Long stockId) {
        return AjaxResult.success(tbInventoryService.selectTbInventoryByInventoryId(stockId));
    }

    @PreAuthorize("@ss.hasPermi('textbook:inventory:add')")
    @PostMapping
    public AjaxResult add(@RequestBody TbInventory tbInventory) {
        if (tbInventory.getStockNum() != null && tbInventory.getStockNum() < 0) {
            return AjaxResult.error("初始库存不能为负数");
        }
        return toAjax(tbInventoryService.insertTbInventory(tbInventory));
    }

    @PreAuthorize("@ss.hasPermi('textbook:inventory:edit')")
    @PutMapping
    public AjaxResult edit(@RequestBody TbInventory tbInventory) {
        TbInventory existing = tbInventoryService.selectTbInventoryByInventoryId(tbInventory.getStockId());
        if (existing == null) {
            return AjaxResult.error("库存记录不存在");
        }
        Integer originalStock = existing.getStockNum();
        Integer newStock = tbInventory.getStockNum();
        if (newStock != null && !newStock.equals(originalStock)) {
            throw new ServiceException("安全限制：禁止直接修改库存数量！库存只能通过入库/出库操作变更。当前库存：" + originalStock);
        }
        return toAjax(tbInventoryService.updateTbInventory(tbInventory));
    }

    @PreAuthorize("@ss.hasPermi('textbook:inventory:remove')")
    @DeleteMapping("/{stockIds}")
    public AjaxResult remove(@PathVariable Long[] stockIds) {
        for (Long id : stockIds) {
            TbInventory inv = tbInventoryService.selectTbInventoryByInventoryId(id);
            if (inv != null && inv.getStockNum() != null && inv.getStockNum() > 0) {
                return AjaxResult.error("无法删除：教材《" + inv.getBookName() + "》当前库存为" + inv.getStockNum() + "，请先通过出库操作将库存清零");
            }
        }
        return toAjax(tbInventoryService.deleteTbInventoryByInventoryIds(stockIds));
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
