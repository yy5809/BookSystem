package com.ruoyi.textbook.controller;

import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.annotation.RateLimiter;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.textbook.domain.TbInbound;
import com.ruoyi.textbook.service.ITbInboundService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletResponse;
import java.util.List;

/**
 * 入库信息Controller
 * 
 * @author ruoyi
 */
@RestController
@RequestMapping("/textbook/inbound")
public class TbInboundController extends BaseController
{
    @Autowired
    private ITbInboundService tbInboundService;

    /**
     * 查询入库信息列表
     */
    @PreAuthorize("@ss.hasPermi('textbook:inbound:list')")
    @GetMapping("/list")
    public TableDataInfo list(TbInbound tbInbound)
    {
        startPage();
        List<TbInbound> list = tbInboundService.selectTbInboundList(tbInbound);
        return getDataTable(list);
    }

    /**
     * 导出入库信息列表
     */
    @PreAuthorize("@ss.hasPermi('textbook:inbound:export')")
    @PostMapping("/export")
    public void export(HttpServletResponse response, TbInbound tbInbound)
    {
        List<TbInbound> list = tbInboundService.selectTbInboundList(tbInbound);
        ExcelUtil<TbInbound> util = new ExcelUtil<TbInbound>(TbInbound.class);
        util.exportExcel(response, list, "入库信息数据");
    }

    /**
     * 获取入库信息详细信息
     */
    @PreAuthorize("@ss.hasPermi('textbook:inbound:query')")
    @GetMapping(value = "/{inboundId}")
    public AjaxResult getInfo(@PathVariable("inboundId") Long inboundId)
    {
        return AjaxResult.success(tbInboundService.selectTbInboundById(inboundId));
    }

    /**
     * 新增入库信息
     */
    @PreAuthorize("@ss.hasPermi('textbook:inbound:add') and @ss.hasAnyRoles('admin,warehouse')")
    @PostMapping
    public AjaxResult add(@RequestBody TbInbound tbInbound)
    {
        return toAjax(tbInboundService.insertTbInbound(tbInbound));
    }

    /**
     * 修改入库信息（已禁用，入库单一旦确认无法修改）
     */
    @PreAuthorize("@ss.hasPermi('textbook:inbound:edit') and @ss.hasAnyRoles('admin,warehouse')")
    @PutMapping
    public AjaxResult edit(@RequestBody TbInbound tbInbound)
    {
        return AjaxResult.error("入库单一旦确认无法修改");
    }

    /**
     * 删除入库信息
     */
    @PreAuthorize("@ss.hasPermi('textbook:inbound:remove') and @ss.hasAnyRoles('admin,warehouse')")
    @DeleteMapping("/{inboundIds}")
    public AjaxResult remove(@PathVariable Long[] inboundIds)
    {
        return toAjax(tbInboundService.deleteTbInboundByIds(inboundIds));
    }

    /**
     * 处理教材入库
     */
    @PreAuthorize("@ss.hasPermi('textbook:inbound:process') and @ss.hasAnyRoles('admin,warehouse')")
    @RateLimiter(count = 10, time = 60)
    @PostMapping("/process")
    public AjaxResult process(@RequestBody TbInbound tbInbound)
    {
        Long operatorId = SecurityUtils.getUserId();
        String operatorName = SecurityUtils.getUsername();
        return toAjax(tbInboundService.processInbound(tbInbound, operatorId, operatorName));
    }
}