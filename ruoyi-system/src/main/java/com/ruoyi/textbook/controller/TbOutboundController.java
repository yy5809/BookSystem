package com.ruoyi.textbook.controller;

import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.textbook.domain.TbOutbound;
import com.ruoyi.textbook.service.ITbOutboundService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletResponse;
import java.util.List;

@RestController
@RequestMapping("/textbook/outbound")
public class TbOutboundController extends BaseController
{
    @Autowired
    private ITbOutboundService tbOutboundService;

    @PreAuthorize("@ss.hasPermi('textbook:outbound:list')")
    @GetMapping("/list")
    public TableDataInfo list(TbOutbound tbOutbound)
    {
        startPage();
        List<TbOutbound> list = tbOutboundService.selectTbOutboundList(tbOutbound);
        return getDataTable(list);
    }

    @PreAuthorize("@ss.hasPermi('textbook:outbound:export')")
    @PostMapping("/export")
    public void export(HttpServletResponse response, TbOutbound tbOutbound)
    {
        List<TbOutbound> list = tbOutboundService.selectTbOutboundList(tbOutbound);
        ExcelUtil<TbOutbound> util = new ExcelUtil<TbOutbound>(TbOutbound.class);
        util.exportExcel(response, list, "出库信息数据");
    }

    @PreAuthorize("@ss.hasPermi('textbook:outbound:query')")
    @GetMapping(value = "/{outboundId}")
    public AjaxResult getInfo(@PathVariable("outboundId") Long outboundId)
    {
        return AjaxResult.success(tbOutboundService.selectTbOutboundById(outboundId));
    }

    /**
     * 新增出库信息（已禁用，出库记录只能通过业务流程生成）
     */
    @PreAuthorize("@ss.hasPermi('textbook:outbound:add') and @ss.hasAnyRole('admin','warehouse_manager')")
    @PostMapping
    public AjaxResult add(@RequestBody TbOutbound tbOutbound)
    {
        return AjaxResult.error("出库记录只能通过业务流程生成");
    }

    /**
     * 修改出库信息（已禁用，出库记录一旦生成无法修改）
     */
    @PreAuthorize("@ss.hasPermi('textbook:outbound:edit') and @ss.hasAnyRole('admin','warehouse_manager')")
    @PutMapping
    public AjaxResult edit(@RequestBody TbOutbound tbOutbound)
    {
        return AjaxResult.error("出库记录一旦生成无法修改");
    }

    @PreAuthorize("@ss.hasPermi('textbook:outbound:remove') and @ss.hasAnyRole('admin','warehouse_manager')")
    @DeleteMapping("/{outboundIds}")
    public AjaxResult remove(@PathVariable Long[] outboundIds)
    {
        return toAjax(tbOutboundService.deleteTbOutboundByIds(outboundIds));
    }

    @PreAuthorize("@ss.hasPermi('textbook:outbound:process') and @ss.hasAnyRole('admin','warehouse_manager')")
    @PostMapping("/process/{purchaseId}")
    public AjaxResult process(@PathVariable Long purchaseId)
    {
        Long operatorId = SecurityUtils.getUserId();
        String operatorName = SecurityUtils.getUsername();
        return toAjax(tbOutboundService.processOutbound(purchaseId, operatorId, operatorName));
    }

    @PreAuthorize("@ss.hasPermi('textbook:outbound:query')")
    @GetMapping("/byPurchase/{purchaseId}")
    public AjaxResult getByPurchaseId(@PathVariable Long purchaseId)
    {
        return AjaxResult.success(tbOutboundService.selectTbOutboundListByPurchaseId(purchaseId));
    }
}
