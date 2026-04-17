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

/**
 * 待购教材信息Controller
 * 
 * @author ruoyi
 */
@RestController
@RequestMapping("/textbook/pending")
public class TbPendingController extends BaseController
{
    @Autowired
    private ITbPendingService tbPendingService;

    /**
     * 查询待购教材信息列表
     */
    @PreAuthorize("@ss.hasPermi('textbook:pending:list')")
    @GetMapping("/list")
    public TableDataInfo list(TbPending tbPending)
    {
        startPage();
        List<TbPending> list = tbPendingService.selectTbPendingList(tbPending);
        return getDataTable(list);
    }

    /**
     * 导出待购教材信息列表
     */
    @PreAuthorize("@ss.hasPermi('textbook:pending:export')")
    @PostMapping("/export")
    public void export(HttpServletResponse response, TbPending tbPending)
    {
        List<TbPending> list = tbPendingService.selectTbPendingList(tbPending);
        ExcelUtil<TbPending> util = new ExcelUtil<TbPending>(TbPending.class);
        util.exportExcel(response, list, "待购教材信息数据");
    }

    /**
     * 获取待购教材信息详细信息
     */
    @PreAuthorize("@ss.hasPermi('textbook:pending:query')")
    @GetMapping(value = "/{pendingId}")
    public AjaxResult getInfo(@PathVariable("pendingId") Long pendingId)
    {
        return AjaxResult.success(tbPendingService.selectTbPendingById(pendingId));
    }

    /**
     * 新增待购教材信息
     */
    @PreAuthorize("@ss.hasPermi('textbook:pending:add') and @ss.hasAnyRole('admin','purchaser')")
    @PostMapping
    public AjaxResult add(@RequestBody TbPending tbPending)
    {
        return toAjax(tbPendingService.insertTbPending(tbPending));
    }

    /**
     * 修改待购教材信息
     */
    @PreAuthorize("@ss.hasPermi('textbook:pending:edit') and @ss.hasAnyRole('admin','purchaser')")
    @PutMapping
    public AjaxResult edit(@RequestBody TbPending tbPending)
    {
        return toAjax(tbPendingService.updateTbPending(tbPending));
    }

    /**
     * 删除待购教材信息
     */
    @PreAuthorize("@ss.hasPermi('textbook:pending:remove') and @ss.hasAnyRole('admin','purchaser')")
    @DeleteMapping("/{pendingIds}")
    public AjaxResult remove(@PathVariable Long[] pendingIds)
    {
        return toAjax(tbPendingService.deleteTbPendingByIds(pendingIds));
    }

    /**
     * 处理采购（开始采购）
     */
    @PreAuthorize("@ss.hasPermi('textbook:pending:edit') and @ss.hasAnyRole('admin','purchaser')")
    @PutMapping("/process/{pendingId}")
    public AjaxResult process(@PathVariable Long pendingId)
    {
        return toAjax(tbPendingService.updatePendingStatus(pendingId, "1"));
    }

    /**
     * 更新待购单状态
     */
    @PreAuthorize("@ss.hasPermi('textbook:pending:updateStatus') and @ss.hasAnyRole('admin','purchaser')")
    @PutMapping("/updateStatus/{pendingId}")
    public AjaxResult updateStatus(@PathVariable Long pendingId, @RequestParam String status)
    {
        return toAjax(tbPendingService.updatePendingStatus(pendingId, status));
    }

    /**
     * 确认入库（真正增加库存）
     */
    @PreAuthorize("@ss.hasPermi('textbook:pending:edit') and @ss.hasAnyRole('admin','purchaser')")
    @Log(title = "待购确认入库", businessType = BusinessType.UPDATE)
    @PutMapping("/inbound/{pendingId}")
    public AjaxResult confirmInbound(@PathVariable Long pendingId) {
        return toAjax(tbPendingService.confirmInbound(pendingId));
    }

    /**
     */
    @PreAuthorize("@ss.hasPermi('textbook:pending:query')")
    @GetMapping("/byBook/{bookId}")
    public AjaxResult getByBookId(@PathVariable Long bookId)
    {
        return AjaxResult.success(tbPendingService.selectTbPendingListByBookId(bookId));
    }
}