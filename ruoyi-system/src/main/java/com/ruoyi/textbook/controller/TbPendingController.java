package com.ruoyi.textbook.controller;

import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.textbook.domain.TbPending;
import com.ruoyi.textbook.service.ITbPendingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletResponse;
import java.util.List;

@RestController
@RequestMapping("/textbook/pending")
public class TbPendingController extends BaseController
{
    @Autowired
    private ITbPendingService tbPendingService;

    @PreAuthorize("@ss.hasPermi('textbook:pending:list')")
    @GetMapping("/list")
    public TableDataInfo list(TbPending tbPending)
    {
        startPage();
        List<TbPending> list = tbPendingService.selectTbPendingList(tbPending);
        return getDataTable(list);
    }

    @PreAuthorize("@ss.hasPermi('textbook:pending:export')")
    @PostMapping("/export")
    public void export(HttpServletResponse response, TbPending tbPending)
    {
        List<TbPending> list = tbPendingService.selectTbPendingList(tbPending);
        ExcelUtil<TbPending> util = new ExcelUtil<TbPending>(TbPending.class);
        util.exportExcel(response, list, "待购教材信息数据");
    }

    @PreAuthorize("@ss.hasPermi('textbook:pending:query')")
    @GetMapping(value = "/{pendingId}")
    public AjaxResult getInfo(@PathVariable("pendingId") Long pendingId)
    {
        return AjaxResult.success(tbPendingService.selectTbPendingById(pendingId));
    }

    @PreAuthorize("@ss.hasPermi('textbook:pending:add') and @ss.hasAnyRoles('admin,warehouse_manager')")
    @PostMapping
    public AjaxResult add(@RequestBody TbPending tbPending)
    {
        return toAjax(tbPendingService.insertTbPending(tbPending));
    }

    @PreAuthorize("@ss.hasPermi('textbook:pending:edit') and @ss.hasAnyRoles('admin,warehouse_manager')")
    @PutMapping
    public AjaxResult edit(@RequestBody TbPending tbPending)
    {
        return toAjax(tbPendingService.updateTbPending(tbPending));
    }

    @PreAuthorize("@ss.hasPermi('textbook:pending:remove') and @ss.hasAnyRoles('admin,warehouse_manager')")
    @DeleteMapping("/{pendingIds}")
    public AjaxResult remove(@PathVariable Long[] pendingIds)
    {
        return toAjax(tbPendingService.deleteTbPendingByIds(pendingIds));
    }

    @PreAuthorize("@ss.hasPermi('textbook:pending:edit') and @ss.hasAnyRoles('admin,warehouse_manager')")
    @PutMapping("/process/{pendingId}")
    public AjaxResult process(@PathVariable Long pendingId)
    {
        return toAjax(tbPendingService.updatePendingStatus(pendingId, "1"));
    }

    @PreAuthorize("@ss.hasPermi('textbook:pending:updateStatus') and @ss.hasAnyRoles('admin,warehouse_manager')")
    @PutMapping("/updateStatus/{pendingId}")
    public AjaxResult updateStatus(@PathVariable Long pendingId, @RequestParam String status)
    {
        return toAjax(tbPendingService.updatePendingStatus(pendingId, status));
    }

    @PreAuthorize("@ss.hasPermi('textbook:pending:edit') and @ss.hasAnyRoles('admin,warehouse_manager')")
    @Log(title = "待购确认入库", businessType = BusinessType.UPDATE)
    @PutMapping("/inbound/{pendingId}")
    public AjaxResult confirmInbound(@PathVariable Long pendingId) {
        return toAjax(tbPendingService.confirmInbound(pendingId));
    }

    @PreAuthorize("@ss.hasPermi('textbook:pending:query')")
    @GetMapping("/byBook/{bookId}")
    public AjaxResult getByBookId(@PathVariable Long bookId)
    {
        return AjaxResult.success(tbPendingService.selectTbPendingListByBookId(bookId));
    }
}
