package com.ruoyi.textbook.controller;

import java.util.List;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.textbook.domain.BookClaimForm;
import com.ruoyi.textbook.domain.BookClaimFormDetail;
import com.ruoyi.textbook.service.IBookClaimFormService;
import com.ruoyi.common.utils.SecurityUtils;

@RestController
@RequestMapping("/textbook/claimForm")
public class BookClaimFormController extends BaseController {

    @Autowired
    private IBookClaimFormService bookClaimFormService;

    @PreAuthorize("@ss.hasPermi('textbook:claimForm:list')")
    @GetMapping("/list")
    public TableDataInfo list(BookClaimForm bookClaimForm) {
        startPage();
        return getDataTable(bookClaimFormService.selectBookClaimFormList(bookClaimForm));
    }

    @PreAuthorize("@ss.hasPermi('textbook:claimForm:query')")
    @GetMapping(value = "/{formId}")
    public AjaxResult getInfo(@PathVariable("formId") Long formId) {
        BookClaimForm form = bookClaimFormService.selectBookClaimFormById(formId);
        if (form != null) {
            form.setDetails(bookClaimFormService.selectDetailsByFormId(formId));
        }
        return AjaxResult.success(form);
    }

    @PreAuthorize("@ss.hasPermi('textbook:claimForm:add')")
    @Log(title = "领书单", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody BookClaimForm bookClaimForm) {
        return toAjax(bookClaimFormService.insertBookClaimForm(bookClaimForm));
    }

    @PreAuthorize("@ss.hasPermi('textbook:claimForm:edit')")
    @Log(title = "领书单", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody BookClaimForm bookClaimForm) {
        return toAjax(bookClaimFormService.updateBookClaimForm(bookClaimForm));
    }

    @PreAuthorize("@ss.hasPermi('textbook:claimForm:outbound')")
    @Log(title = "确认出库", businessType = BusinessType.UPDATE)
    @PutMapping("/confirmOutbound")
    public AjaxResult confirmOutbound(@RequestBody BookClaimForm bookClaimForm) {
        try {
            Long operatorId = SecurityUtils.getUserId();
            String operatorName = SecurityUtils.getUsername();
            return toAjax(bookClaimFormService.confirmOutbound(
                    bookClaimForm.getFormId(),
                    operatorId,
                    operatorName,
                    bookClaimForm.getIssuedQty(),
                    bookClaimForm.getReceiverName()
            ));
        } catch (Exception e) {
            return AjaxResult.error(e.getMessage());
        }
    }

    @PreAuthorize("@ss.hasPermi('textbook:claimForm:remove')")
    @Log(title = "领书单", businessType = BusinessType.DELETE)
    @DeleteMapping("/{formIds}")
    public AjaxResult remove(@PathVariable Long[] formIds) {
        return toAjax(bookClaimFormService.deleteBookClaimFormByIds(formIds));
    }

    @PreAuthorize("@ss.hasPermi('textbook:claimForm:query')")
    @GetMapping(value = "/details/{formId}")
    public AjaxResult getDetails(@PathVariable("formId") Long formId) {
        List<BookClaimFormDetail> details = bookClaimFormService.selectDetailsByFormId(formId);
        return AjaxResult.success(details);
    }
}
