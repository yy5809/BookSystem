package com.ruoyi.textbook.controller;

import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.textbook.domain.TbOutbound;
import com.ruoyi.textbook.service.ITbOutboundService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletResponse;
import java.util.List;

/**
 * 出库信息Controller
 * 
 * @author ruoyi
 */
@RestController
@RequestMapping("/textbook/outbound")
public class TbOutboundController extends BaseController
{
    @Autowired
    private ITbOutboundService tbOutboundService;

    /**
     * 查询出库信息列表
     */
    @PreAuthorize("@ss.hasPermi('textbook:outbound:list')")
    @GetMapping("/list")
    public TableDataInfo list(TbOutbound tbOutbound)
    {
        startPage();
        List<TbOutbound> list = tbOutboundService.selectTbOutboundList(tbOutbound);
        return getDataTable(list);
    }

    /**
     * 导出出库信息列表
     */
    @PreAuthorize("@ss.hasPermi('textbook:outbound:export')")
    @PostMapping("/export")
    public void export(HttpServletResponse response, TbOutbound tbOutbound)
    {
        List<TbOutbound> list = tbOutboundService.selectTbOutboundList(tbOutbound);
        ExcelUtil<TbOutbound> util = new ExcelUtil<TbOutbound>(TbOutbound.class);
        util.exportExcel(response, list, "出库信息数据");
    }

    /**
     * 获取出库信息详细信息
     */
    @PreAuthorize("@ss.hasPermi('textbook:outbound:query')")
    @GetMapping(value = "/{outboundId}")
    public AjaxResult getInfo(@PathVariable("outboundId") Long outboundId)
    {
        return AjaxResult.success(tbOutboundService.selectTbOutboundById(outboundId));
    }

    /**
     * 新增出库信息
     */
    @PreAuthorize("@ss.hasPermi('textbook:outbound:add') and @ss.hasAnyRole('admin','issuer')")
    @PostMapping
    public AjaxResult add(@RequestBody TbOutbound tbOutbound)
    {
        return toAjax(tbOutboundService.insertTbOutbound(tbOutbound));
    }

    /**
     * 修改出库信息
     */
    @PreAuthorize("@ss.hasPermi('textbook:outbound:edit') and @ss.hasAnyRole('admin','issuer')")
    @PutMapping
    public AjaxResult edit(@RequestBody TbOutbound tbOutbound)
    {
        return toAjax(tbOutboundService.updateTbOutbound(tbOutbound));
    }

    /**
     * 删除出库信息
     */
    @PreAuthorize("@ss.hasPermi('textbook:outbound:remove') and @ss.hasAnyRole('admin','issuer')")
    @DeleteMapping("/{outboundIds}")
    public AjaxResult remove(@PathVariable Long[] outboundIds)
    {
        return toAjax(tbOutboundService.deleteTbOutboundByIds(outboundIds));
    }

    /**
     * 处理领书出库
     */
    @PreAuthorize("@ss.hasPermi('textbook:outbound:process') and @ss.hasAnyRole('admin','issuer')")
    @PostMapping("/process/{purchaseId}")
    public AjaxResult process(@PathVariable Long purchaseId, @RequestParam Long operatorId, @RequestParam String operatorName)
    {
        return toAjax(tbOutboundService.processOutbound(purchaseId, operatorId, operatorName));
    }

    /**
     * 根据购书ID查询出库信息
     */
    @PreAuthorize("@ss.hasPermi('textbook:outbound:query')")
    @GetMapping("/byPurchase/{purchaseId}")
    public AjaxResult getByPurchaseId(@PathVariable Long purchaseId)
    {
        return AjaxResult.success(tbOutboundService.selectTbOutboundListByPurchaseId(purchaseId));
    }
}