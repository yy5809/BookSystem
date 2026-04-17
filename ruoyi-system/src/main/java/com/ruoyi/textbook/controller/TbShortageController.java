package com.ruoyi.textbook.controller;

import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.textbook.domain.TbShortage;
import com.ruoyi.textbook.service.ITbShortageService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletResponse;
import java.util.List;
import java.util.Map;

/**
 * 缺书登记信息Controller
 * 
 * @author ruoyi
 */
@RestController
@RequestMapping("/textbook/shortage")
public class TbShortageController extends BaseController
{
    @Autowired
    private ITbShortageService tbShortageService;

    /**
     * 查询缺书登记信息列表
     */
    @PreAuthorize("@ss.hasPermi('textbook:shortage:list')")
    @GetMapping("/list")
    public TableDataInfo list(TbShortage tbShortage)
    {
        startPage();
        List<TbShortage> list = tbShortageService.selectTbShortageList(tbShortage);
        return getDataTable(list);
    }

    /**
     * 导出缺书登记信息列表
     */
    @PreAuthorize("@ss.hasPermi('textbook:shortage:export')")
    @PostMapping("/export")
    public void export(HttpServletResponse response, TbShortage tbShortage)
    {
        List<TbShortage> list = tbShortageService.selectTbShortageList(tbShortage);
        ExcelUtil<TbShortage> util = new ExcelUtil<TbShortage>(TbShortage.class);
        util.exportExcel(response, list, "缺书登记信息数据");
    }

    /**
     * 获取缺书登记信息详细信息
     */
    @PreAuthorize("@ss.hasPermi('textbook:shortage:query')")
    @GetMapping(value = "/{shortageId}")
    public AjaxResult getInfo(@PathVariable("shortageId") Long shortageId)
    {
        return AjaxResult.success(tbShortageService.selectTbShortageById(shortageId));
    }

    /**
     * 新增缺书登记信息
     */
    @PreAuthorize("@ss.hasPermi('textbook:shortage:add') and @ss.hasAnyRole('admin','warehouse_manager','teacher')")
    @PostMapping
    public AjaxResult add(@RequestBody TbShortage tbShortage)
    {
        return toAjax(tbShortageService.insertTbShortage(tbShortage));
    }

    /**
     * 修改缺书登记信息
     */
    @PreAuthorize("@ss.hasPermi('textbook:shortage:edit') and @ss.hasAnyRole('admin','warehouse_manager')")
    @PutMapping
    public AjaxResult edit(@RequestBody TbShortage tbShortage)
    {
        return toAjax(tbShortageService.updateTbShortage(tbShortage));
    }

    /**
     * 删除缺书登记信息
     */
    @PreAuthorize("@ss.hasPermi('textbook:shortage:remove') and @ss.hasAnyRole('admin','warehouse_manager')")
    @DeleteMapping("/{shortageIds}")
    public AjaxResult remove(@PathVariable Long[] shortageIds)
    {
        return toAjax(tbShortageService.deleteTbShortageByIds(shortageIds));
    }

    /**
     * 处理缺书
     */
    @PreAuthorize("@ss.hasPermi('textbook:shortage:process') and @ss.hasAnyRole('admin','warehouse_manager')")
    @PutMapping("/process/{shortageId}")
    public AjaxResult process(@PathVariable Long shortageId, @RequestParam String status)
    {
        return toAjax(tbShortageService.processShortage(shortageId, status));
    }

    /**
     * 根据教材ID查询缺书登记信息
     */
    @PreAuthorize("@ss.hasPermi('textbook:shortage:query')")
    @GetMapping("/byBook/{bookId}")
    public AjaxResult getByBookId(@PathVariable Long bookId)
    {
        return AjaxResult.success(tbShortageService.selectTbShortageByBookId(bookId));
    }

    @PreAuthorize("@ss.hasPermi('textbook:shortage:process') and @ss.hasAnyRole('admin','warehouse_manager')")
    @Log(title = "缺书批量转采购(ISBN聚合)", businessType = BusinessType.UPDATE)
    @PostMapping("/convertToPurchase")
    public AjaxResult convertToPurchase(@RequestBody Long[] shortageIds)
    {
        Map<String, Object> result = tbShortageService.batchConvertToPurchase(shortageIds);
        if (result.containsKey("success") && Boolean.FALSE.equals(result.get("success"))) {
            return AjaxResult.error((String) result.get("msg"));
        }
        return AjaxResult.success((String) result.get("msg"), result);
    }
}