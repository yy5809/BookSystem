package com.ruoyi.textbook.controller;

import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.textbook.domain.TbShortage;
import com.ruoyi.textbook.service.ITbShortageService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletResponse;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/textbook/shortage")
public class TbShortageController extends BaseController
{
    @Autowired
    private ITbShortageService tbShortageService;

    @PreAuthorize("@ss.hasPermi('textbook:shortage:list')")
    @GetMapping("/list")
    public TableDataInfo list(TbShortage tbShortage)
    {
        if (SecurityUtils.hasRole("teacher")) {
            tbShortage.setRegisterId(SecurityUtils.getUserId());
        } else {
            tbShortage.setDelFlag("0");
        }
        startPage();
        List<TbShortage> list = tbShortageService.selectTbShortageList(tbShortage);
        return getDataTable(list);
    }

    @PreAuthorize("@ss.hasPermi('textbook:shortage:export')")
    @Log(title = "缺书登记", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, TbShortage tbShortage)
    {
        if (SecurityUtils.hasRole("teacher")) {
            tbShortage.setRegisterId(SecurityUtils.getUserId());
        } else {
            tbShortage.setDelFlag("0");
        }
        List<TbShortage> list = tbShortageService.selectTbShortageList(tbShortage);
        ExcelUtil<TbShortage> util = new ExcelUtil<TbShortage>(TbShortage.class);
        util.exportExcel(response, list, "缺书登记信息数据");
    }

    @PreAuthorize("@ss.hasPermi('textbook:shortage:query')")
    @GetMapping(value = "/{shortageId}")
    public AjaxResult getInfo(@PathVariable("shortageId") Long shortageId)
    {
        TbShortage shortage = tbShortageService.selectTbShortageById(shortageId);
        if (shortage != null && SecurityUtils.hasRole("teacher")
                && !SecurityUtils.getUserId().equals(shortage.getRegisterId())) {
            return AjaxResult.error("无权查看他人的缺书登记");
        }
        return AjaxResult.success(shortage);
    }

    @PreAuthorize("@ss.hasPermi('textbook:shortage:add')")
    @Log(title = "缺书登记", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody TbShortage tbShortage)
    {
        tbShortage.setRegisterId(SecurityUtils.getUserId());
        tbShortage.setRegisterName(SecurityUtils.getLoginUser().getUser().getNickName());
        tbShortage.setCreateBy(getUsername());
        return toAjax(tbShortageService.insertTbShortage(tbShortage));
    }

    @PreAuthorize("@ss.hasPermi('textbook:shortage:edit') or @ss.hasPermi('textbook:shortage:add')")
    @Log(title = "缺书登记", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody TbShortage tbShortage)
    {
        if (SecurityUtils.hasRole("teacher")) {
            TbShortage existing = tbShortageService.selectTbShortageById(tbShortage.getLackId());
            if (existing == null || !SecurityUtils.getUserId().equals(existing.getRegisterId())) {
                return error("无权修改他人的缺书登记");
            }
            tbShortage.setRegisterId(SecurityUtils.getUserId());
            tbShortage.setUpdateBy(getUsername());
            return toAjax(tbShortageService.updateTbShortage(tbShortage));
        }
        tbShortage.setUpdateBy(getUsername());
        return toAjax(tbShortageService.updateTbShortage(tbShortage));
    }

    @PreAuthorize("@ss.hasPermi('textbook:shortage:remove')")
    @Log(title = "缺书登记", businessType = BusinessType.DELETE)
    @DeleteMapping("/{shortageIds}")
    public AjaxResult remove(@PathVariable Long[] shortageIds)
    {
        return toAjax(tbShortageService.deleteTbShortageByIds(shortageIds));
    }

    @PreAuthorize("@ss.hasPermi('textbook:shortage:process')")
    @Log(title = "处理缺书", businessType = BusinessType.UPDATE)
    @PutMapping("/process/{shortageId}")
    public AjaxResult process(@PathVariable Long shortageId, @RequestParam String status,
                              @RequestParam(required = false) Long supplierId,
                              @RequestParam(required = false) Integer purchaseQty)
    {
        return toAjax(tbShortageService.processShortage(shortageId, status, supplierId, purchaseQty));
    }

    @PreAuthorize("@ss.hasPermi('textbook:shortage:query')")
    @GetMapping("/byBook/{bookId}")
    public AjaxResult getByBookId(@PathVariable Long bookId)
    {
        return AjaxResult.success(tbShortageService.selectTbShortageByBookId(bookId));
    }

    @PreAuthorize("@ss.hasPermi('textbook:shortage:process')")
    @Log(title = "缺书批量转采购", businessType = BusinessType.UPDATE)
    @PostMapping("/convertToPurchase")
    public AjaxResult convertToPurchase(@RequestBody Long[] shortageIds)
    {
        Map<String, Object> result = tbShortageService.batchConvertToPurchase(shortageIds);
        if (result.containsKey("success") && Boolean.FALSE.equals(result.get("success"))) {
            return AjaxResult.error((String) result.get("msg"));
        }
        return AjaxResult.success((String) result.get("msg"), result);
    }

    @PreAuthorize("@ss.hasPermi('textbook:shortage:edit') or @ss.hasPermi('textbook:shortage:add')")
    @Log(title = "取消缺书登记", businessType = BusinessType.UPDATE)
    @PutMapping("/cancel/{shortageId}")
    public AjaxResult cancel(@PathVariable Long shortageId)
    {
        return toAjax(tbShortageService.cancelShortage(shortageId));
    }

    @PreAuthorize("@ss.hasPermi('textbook:shortage:process')")
    @Log(title = "通知登记人领书", businessType = BusinessType.OTHER)
    @PutMapping("/notifyRegister/{shortageId}")
    public AjaxResult notifyRegister(@PathVariable Long shortageId)
    {
        return toAjax(tbShortageService.notifyRegister(shortageId));
    }
}
