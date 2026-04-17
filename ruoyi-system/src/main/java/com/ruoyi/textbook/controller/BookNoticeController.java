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
import com.ruoyi.textbook.domain.BookNotice;
import com.ruoyi.textbook.domain.BookClaimForm;
import com.ruoyi.textbook.service.IBookNoticeService;

@RestController
@RequestMapping("/textbook/notice")
public class BookNoticeController extends BaseController {

    @Autowired
    private IBookNoticeService bookNoticeService;

    @PreAuthorize("@ss.hasPermi('textbook:notice:list')")
    @GetMapping("/list")
    public TableDataInfo list(BookNotice bookNotice) {
        startPage();
        return getDataTable(bookNoticeService.selectBookNoticeList(bookNotice));
    }

    @PreAuthorize("@ss.hasPermi('textbook:notice:query')")
    @GetMapping(value = "/{noticeId}")
    public AjaxResult getInfo(@PathVariable("noticeId") Long noticeId) {
        return AjaxResult.success(bookNoticeService.selectBookNoticeById(noticeId));
    }

    @PreAuthorize("@ss.hasPermi('textbook:notice:add')")
    @Log(title = "领书通知", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody BookNotice bookNotice) {
        return toAjax(bookNoticeService.insertBookNotice(bookNotice));
    }

    @PreAuthorize("@ss.hasPermi('textbook:notice:edit')")
    @Log(title = "领书通知", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody BookNotice bookNotice) {
        return toAjax(bookNoticeService.updateBookNotice(bookNotice));
    }

    @PreAuthorize("@ss.hasPermi('textbook:notice:publish')")
    @Log(title = "发布领书通知", businessType = BusinessType.UPDATE)
    @PutMapping("/publish/{noticeId}")
    public AjaxResult publish(@PathVariable Long noticeId) {
        try {
            bookNoticeService.publishNotice(noticeId);
            return AjaxResult.success("发布成功");
        } catch (RuntimeException e) {
            return AjaxResult.error(e.getMessage());
        }
    }

    @PreAuthorize("@ss.hasPermi('textbook:notice:remove')")
    @Log(title = "领书通知", businessType = BusinessType.DELETE)
    @DeleteMapping("/{noticeIds}")
    public AjaxResult remove(@PathVariable Long[] noticeIds) {
        return toAjax(bookNoticeService.deleteBookNoticeByIds(noticeIds));
    }

    @PreAuthorize("@ss.hasPermi('textbook:notice:query')")
    @GetMapping(value = "/claimForms/{noticeId}")
    public AjaxResult getClaimForms(@PathVariable("noticeId") Long noticeId) {
        List<BookClaimForm> forms = bookNoticeService.generateClaimForms(noticeId);
        return AjaxResult.success(forms);
    }
}
