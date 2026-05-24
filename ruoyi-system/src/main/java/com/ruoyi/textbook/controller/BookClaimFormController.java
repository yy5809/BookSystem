package com.ruoyi.textbook.controller;

import java.util.List;
import java.util.Map;
import java.util.HashMap;
import javax.servlet.http.HttpServletResponse;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.annotation.RateLimiter;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.common.utils.file.FileUtils;
import com.ruoyi.textbook.domain.BookClaimForm;
import com.ruoyi.textbook.domain.BookClaimFormDetail;
import com.ruoyi.textbook.service.IBookClaimFormService;
import com.ruoyi.textbook.util.ClaimFormPdfUtil;
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

    @PreAuthorize("@ss.hasPermi('textbook:claimForm:add') and @ss.hasAnyRoles('admin,warehouse')")
    @Log(title = "领书单", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody BookClaimForm bookClaimForm) {
        bookClaimForm.setCreateBy(getUsername());
        return toAjax(bookClaimFormService.insertBookClaimForm(bookClaimForm));
    }

    @PreAuthorize("@ss.hasPermi('textbook:claimForm:edit') and @ss.hasAnyRoles('admin,warehouse')")
    @Log(title = "领书单", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody BookClaimForm bookClaimForm) {
        bookClaimForm.setUpdateBy(getUsername());
        return toAjax(bookClaimFormService.updateBookClaimForm(bookClaimForm));
    }

    @PreAuthorize("@ss.hasPermi('textbook:claimForm:outbound') and @ss.hasAnyRoles('admin,warehouse')")
    @Log(title = "确认出库", businessType = BusinessType.UPDATE)
    @RateLimiter(count = 10, time = 60)
    @PutMapping("/confirmOutbound")
    public AjaxResult confirmOutbound(@RequestBody BookClaimForm bookClaimForm) {
        if (bookClaimForm.getFormId() == null) {
            return AjaxResult.error("领书单ID不能为空");
        }
        if (bookClaimForm.getIssuedQty() == null) {
            return AjaxResult.error("出库数量不能为空");
        }
        try {
            Long operatorId = SecurityUtils.getUserId();
            String operatorName = SecurityUtils.getLoginUser().getUser().getNickName();
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

    @PreAuthorize("@ss.hasPermi('textbook:claimForm:remove') and @ss.hasAnyRoles('admin,warehouse')")
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

    @PreAuthorize("@ss.hasPermi('textbook:claimForm:query')")
    @GetMapping(value = "/pdf/{formId}")
    public void exportPdf(@PathVariable("formId") Long formId, HttpServletResponse response) {
        try {
            BookClaimForm form = bookClaimFormService.selectBookClaimFormById(formId);
            if (form == null) {
                response.setContentType("text/plain;charset=UTF-8");
                response.setStatus(404);
                response.getWriter().write("领书单不存在");
                return;
            }
            List<BookClaimFormDetail> details = bookClaimFormService.selectDetailsByFormId(formId);
            String fileName = "领书单_" + form.getFormNo() + ".pdf";
            response.setContentType("application/pdf");
            FileUtils.setAttachmentResponseHeader(response, fileName);
            ClaimFormPdfUtil.generatePdf(form, details, response.getOutputStream());
        } catch (Exception e) {
            try {
                if (!response.isCommitted()) {
                    response.reset();
                }
                response.setContentType("text/plain;charset=UTF-8");
                response.setStatus(500);
                response.getWriter().write("PDF生成失败: " + e.getMessage());
            } catch (Exception ignored) {
            }
        }
    }

    @PreAuthorize("@ss.hasPermi('textbook:claimForm:edit') and @ss.hasAnyRoles('admin,warehouse')")
    @Log(title = "撤回领书单", businessType = BusinessType.UPDATE)
    @PutMapping("/withdraw/{formId}")
    public AjaxResult withdrawForm(@PathVariable Long formId) {
        try {
            return toAjax(bookClaimFormService.withdrawForm(formId));
        } catch (Exception e) {
            return AjaxResult.error(e.getMessage());
        }
    }

    @PreAuthorize("@ss.hasPermi('textbook:claimForm:edit') and @ss.hasAnyRoles('admin,warehouse')")
    @Log(title = "关闭领书单", businessType = BusinessType.UPDATE)
    @PutMapping("/close")
    public AjaxResult closeForm(@RequestParam Long formId, @RequestParam String closeReason) {
        try {
            return toAjax(bookClaimFormService.closeForm(formId, closeReason));
        } catch (Exception e) {
            return AjaxResult.error(e.getMessage());
        }
    }

    @PreAuthorize("@ss.hasPermi('textbook:claimForm:outbound') and @ss.hasAnyRoles('admin,warehouse')")
    @Log(title = "补发出库", businessType = BusinessType.UPDATE)
    @PutMapping("/reissue")
    public AjaxResult reissue(@RequestParam Long formId, @RequestParam(required = false) Integer reissueQty) {
        try {
            Long operatorId = SecurityUtils.getUserId();
            String operatorName = SecurityUtils.getLoginUser().getUser().getNickName();
            return toAjax(bookClaimFormService.reissue(formId, operatorId, operatorName, reissueQty));
        } catch (Exception e) {
            return AjaxResult.error(e.getMessage());
        }
    }

    @PreAuthorize("@ss.hasPermi('textbook:claimForm:list')")
    @GetMapping("/pendingReissue")
    public AjaxResult pendingReissueList() {
        return AjaxResult.success(bookClaimFormService.selectPendingReissueList());
    }

    @PreAuthorize("@ss.hasPermi('textbook:claimForm:outbound') and @ss.hasAnyRoles('admin,warehouse')")
    @Log(title = "部分出库", businessType = BusinessType.UPDATE)
    @PostMapping("/partialIssue")
    public AjaxResult partialIssue(@RequestBody Map<String, Object> data) {
        Long formId = Long.valueOf(data.get("formId").toString());
        Integer issuedQty = data.get("issuedQty") != null ? Integer.valueOf(data.get("issuedQty").toString()) : 0;
        String receiverName = (String) data.get("receiverName");
        try {
            Long operatorId = SecurityUtils.getUserId();
            String operatorName = SecurityUtils.getLoginUser().getUser().getNickName();
            return toAjax(bookClaimFormService.confirmOutbound(formId, operatorId, operatorName, issuedQty, receiverName));
        } catch (Exception e) {
            return AjaxResult.error(e.getMessage());
        }
    }

    @PreAuthorize("@ss.hasPermi('textbook:claimForm:outbound') and @ss.hasAnyRoles('admin,warehouse')")
    @Log(title = "退库操作", businessType = BusinessType.UPDATE)
    @PostMapping("/return")
    public AjaxResult returnToStock(@RequestBody Map<String, Object> data) {
        return AjaxResult.error("退库功能需在Service层完善后开放");
    }

    @PreAuthorize("@ss.hasPermi('textbook:claimForm:query')")
    @GetMapping("/checkDuplicate")
    public AjaxResult checkDuplicate(@RequestParam Long noticeId, @RequestParam String className) {
        BookClaimForm query = new BookClaimForm();
        query.setNoticeId(noticeId);
        query.setClassName(className);
        List<BookClaimForm> forms = bookClaimFormService.selectBookClaimFormList(query);
        boolean exists = forms != null && !forms.isEmpty();
        Map<String, Object> result = new HashMap<>();
        result.put("duplicate", exists);
        if (exists) {
            result.put("existingForms", forms);
        }
        return AjaxResult.success(result);
    }
}
