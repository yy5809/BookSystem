package com.ruoyi.textbook.controller;

import java.util.List;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.textbook.domain.BookPersonalApply;
import com.ruoyi.textbook.service.IBookPersonalApplyService;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.common.utils.poi.ExcelUtil;

@RestController
@RequestMapping("/textbook/personalApply")
public class BookPersonalApplyController extends BaseController {

    @Autowired
    private IBookPersonalApplyService bookPersonalApplyService;

    @PreAuthorize("@ss.hasPermi('textbook:personalApply:list')")
    @GetMapping("/list")
    public TableDataInfo list(BookPersonalApply bookPersonalApply) {
        startPage();
        List<BookPersonalApply> list = bookPersonalApplyService.selectBookPersonalApplyList(bookPersonalApply);
        return getDataTable(list);
    }

    @PreAuthorize("@ss.hasPermi('textbook:myApply:list')")
    @GetMapping("/myList")
    public TableDataInfo myList(BookPersonalApply bookPersonalApply) {
        startPage();
        bookPersonalApply.setTeacherId(SecurityUtils.getUserId());
        List<BookPersonalApply> list = bookPersonalApplyService.selectMyApplyList(bookPersonalApply);
        return getDataTable(list);
    }

    @PreAuthorize("@ss.hasPermi('textbook:personalApply:query')")
    @GetMapping(value = "/{applyId}")
    public AjaxResult getInfo(@PathVariable("applyId") Long applyId) {
        return success(bookPersonalApplyService.selectBookPersonalApplyById(applyId));
    }

    @PreAuthorize("@ss.hasPermi('textbook:personalApply:add')")
    @Log(title = "Personal Apply", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody BookPersonalApply bookPersonalApply) {
        bookPersonalApply.setTeacherId(SecurityUtils.getUserId());
        bookPersonalApply.setTeacherName(SecurityUtils.getUsername());
        return toAjax(bookPersonalApplyService.insertBookPersonalApply(bookPersonalApply));
    }

    @PreAuthorize("@ss.hasPermi('textbook:personalApply:cancel')")
    @Log(title = "Personal Apply", businessType = BusinessType.UPDATE)
    @PutMapping("/cancel/{applyId}")
    public AjaxResult cancel(@PathVariable Long applyId) {
        BookPersonalApply apply = new BookPersonalApply();
        apply.setApplyId(applyId);
        apply.setStatus("2");
        apply.setAuditOpinion("Cancelled by applicant");
        return toAjax(bookPersonalApplyService.updateBookPersonalApply(apply));
    }

    @PreAuthorize("@ss.hasPermi('textbook:personalApply:audit')")
    @Log(title = "Personal Apply Audit", businessType = BusinessType.UPDATE)
    @PutMapping("/audit")
    public AjaxResult audit(@RequestBody BookPersonalApply bookPersonalApply) {
        if (!"1".equals(bookPersonalApply.getStatus()) && !"2".equals(bookPersonalApply.getStatus())) {
            return error("Invalid status");
        }
        return toAjax(bookPersonalApplyService.auditApply(bookPersonalApply));
    }

    @PreAuthorize("@ss.hasPermi('textbook:personalApply:issue')")
    @Log(title = "Personal Apply Issue", businessType = BusinessType.UPDATE)
    @PutMapping("/issue/{applyId}")
    public AjaxResult issue(@PathVariable Long applyId) {
        return toAjax(bookPersonalApplyService.issueApply(applyId));
    }

    @PreAuthorize("@ss.hasPermi('textbook:personalApply:remove')")
    @Log(title = "Personal Apply", businessType = BusinessType.DELETE)
    @DeleteMapping("/{applyIds}")
    public AjaxResult remove(@PathVariable Long[] applyIds) {
        return toAjax(bookPersonalApplyService.deleteBookPersonalApplyByIds(applyIds));
    }
}
