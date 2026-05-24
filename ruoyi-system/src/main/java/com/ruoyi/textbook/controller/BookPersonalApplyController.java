package com.ruoyi.textbook.controller;

import java.util.List;
import java.util.Map;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import com.ruoyi.common.annotation.DataScope;
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

    @PreAuthorize("@ss.hasPermi('textbook:personalApply:list') and @ss.hasAnyRoles('admin,warehouse')")
    @DataScope(userAlias = "teacher_id")
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
        BookPersonalApply apply = bookPersonalApplyService.selectBookPersonalApplyById(applyId);
        if (apply == null) {
            return error("申请记录不存在");
        }
        Long currentUserId = SecurityUtils.getUserId();
        boolean isAdminOrWarehouse = SecurityUtils.hasRole("admin") || SecurityUtils.hasRole("warehouse");
        if (!currentUserId.equals(apply.getTeacherId()) && !isAdminOrWarehouse) {
            return error("无权查看他人的申请记录");
        }
        return success(apply);
    }

    @PreAuthorize("@ss.hasPermi('textbook:personalApply:add')")
    @Log(title = "Personal Apply", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody BookPersonalApply bookPersonalApply) {
        bookPersonalApply.setTeacherId(SecurityUtils.getUserId());
        bookPersonalApply.setTeacherName(SecurityUtils.getLoginUser().getUser().getNickName());
        bookPersonalApply.setCreateBy(getUsername());
        return toAjax(bookPersonalApplyService.insertBookPersonalApply(bookPersonalApply));
    }

    @PreAuthorize("@ss.hasPermi('textbook:personalApply:cancel')")
    @Log(title = "Personal Apply", businessType = BusinessType.UPDATE)
    @PutMapping("/cancel/{applyId}")
    public AjaxResult cancel(@PathVariable Long applyId) {
        Long currentUserId = SecurityUtils.getUserId();
        return toAjax(bookPersonalApplyService.cancelApply(applyId, currentUserId));
    }

    @PreAuthorize("@ss.hasPermi('textbook:personalApply:audit') and @ss.hasAnyRoles('admin,warehouse')")
    @Log(title = "Personal Apply Audit", businessType = BusinessType.UPDATE)
    @PutMapping("/audit")
    public AjaxResult audit(@RequestBody BookPersonalApply bookPersonalApply) {
        if (!"1".equals(bookPersonalApply.getStatus()) && !"2".equals(bookPersonalApply.getStatus())) {
            return error("Invalid status");
        }
        return toAjax(bookPersonalApplyService.auditApply(bookPersonalApply));
    }

    @PreAuthorize("@ss.hasPermi('textbook:personalApply:issue') and @ss.hasAnyRoles('admin,warehouse')")
    @Log(title = "确认教师领书", businessType = BusinessType.UPDATE)
    @PutMapping("/issue/{applyId}")
    public AjaxResult issue(@PathVariable Long applyId, @RequestBody Map<String, Object> data) {
        Integer receivedQty = data.get("receivedQty") != null ? ((Number) data.get("receivedQty")).intValue() : null;
        String location = (String) data.getOrDefault("location", "仓库");
        String remark = (String) data.get("remark");
        return toAjax(bookPersonalApplyService.issueApply(applyId, receivedQty, location, remark));
    }

    @PreAuthorize("@ss.hasPermi('textbook:myApply:add')")
    @Log(title = "Personal Apply Shortage Registration", businessType = BusinessType.INSERT)
    @PutMapping("/registerShortage/{applyId}")
    public AjaxResult registerShortage(@PathVariable Long applyId) {
        return toAjax(bookPersonalApplyService.registerShortageFromApply(applyId));
    }

    @PreAuthorize("@ss.hasPermi('textbook:personalApply:remove')")
    @Log(title = "Personal Apply", businessType = BusinessType.DELETE)
    @DeleteMapping("/{applyIds}")
    public AjaxResult remove(@PathVariable Long[] applyIds) {
        Long currentUserId = SecurityUtils.getUserId();
        boolean isAdminOrWarehouse = SecurityUtils.hasRole("admin") || SecurityUtils.hasRole("warehouse");
        if (!isAdminOrWarehouse) {
            for (Long applyId : applyIds) {
                BookPersonalApply apply = bookPersonalApplyService.selectBookPersonalApplyById(applyId);
                if (apply != null && !currentUserId.equals(apply.getTeacherId())) {
                    return error("无权删除他人的申请记录");
                }
            }
        }
        return toAjax(bookPersonalApplyService.deleteBookPersonalApplyByIds(applyIds));
    }

    @PreAuthorize("@ss.hasPermi('textbook:personalApply:edit') and @ss.hasAnyRoles('admin,warehouse')")
    @Log(title = "关闭个人领书申请", businessType = BusinessType.UPDATE)
    @PutMapping("/close/{applyId}")
    public AjaxResult close(@PathVariable Long applyId) {
        BookPersonalApply apply = bookPersonalApplyService.selectBookPersonalApplyById(applyId);
        if (apply == null) return error("申请记录不存在");
        apply.setStatus("4");
        apply.setUpdateBy(getUsername());
        return toAjax(bookPersonalApplyService.updateBookPersonalApply(apply));
    }

    @PreAuthorize("@ss.hasPermi('textbook:personalApply:list') and @ss.hasAnyRoles('admin,warehouse')")
    @GetMapping("/pendingAudit")
    public AjaxResult pendingAudit() {
        BookPersonalApply query = new BookPersonalApply();
        query.setStatus("0");
        List<BookPersonalApply> list = bookPersonalApplyService.selectBookPersonalApplyList(query);
        return AjaxResult.success(list != null ? list.size() : 0);
    }

    @PreAuthorize("@ss.hasPermi('textbook:personalApply:list') and @ss.hasAnyRoles('admin,warehouse')")
    @GetMapping("/pendingPickup")
    public AjaxResult pendingPickup() {
        BookPersonalApply query = new BookPersonalApply();
        query.setStatus("1");
        List<BookPersonalApply> list = bookPersonalApplyService.selectBookPersonalApplyList(query);
        return AjaxResult.success(list != null ? list.size() : 0);
    }
}