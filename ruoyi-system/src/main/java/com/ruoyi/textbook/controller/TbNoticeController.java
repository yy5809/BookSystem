package com.ruoyi.textbook.controller;

import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.system.domain.SysNotice;
import com.ruoyi.system.service.ISysNoticeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/textbook/notification")
public class TbNoticeController extends BaseController {

    @Autowired
    private ISysNoticeService noticeService;

    @PreAuthorize("@ss.hasPermi('textbook:notice:list')")
    @GetMapping("/list")
    public TableDataInfo list(SysNotice notice) {
        startPage();
        if (!SecurityUtils.hasRole("admin") && !SecurityUtils.hasRole("warehouse")) {
            notice.setTargetUserId(SecurityUtils.getUserId());
        }
        List<SysNotice> list = noticeService.selectNoticeList(notice);
        return getDataTable(list);
    }

    @PreAuthorize("@ss.hasPermi('textbook:notice:list')")
    @GetMapping("/list/all")
    public TableDataInfo listAll(SysNotice notice) {
        if (!SecurityUtils.hasRole("admin") && !SecurityUtils.hasRole("warehouse")) {
            notice.setTargetUserId(SecurityUtils.getUserId());
        }
        startPage();
        List<SysNotice> list = noticeService.selectNoticeList(notice);
        return getDataTable(list);
    }

    @PreAuthorize("@ss.hasPermi('textbook:notice:list')")
    @GetMapping("/unread/count")
    public AjaxResult getUnreadCount() {
        Long userId = SecurityUtils.getUserId();
        SysNotice query = new SysNotice();
        query.setTargetUserId(userId);
        query.setReadStatus("0");
        List<SysNotice> unreadList = noticeService.selectNoticeList(query);
        int count = unreadList != null ? unreadList.size() : 0;
        return AjaxResult.success(count);
    }

    @PreAuthorize("@ss.hasPermi('textbook:notice:query')")
    @GetMapping("/{noticeId}")
    public AjaxResult getInfo(@PathVariable Long noticeId) {
        SysNotice existing = noticeService.selectNoticeById(noticeId);
        if (existing != null && existing.getTargetUserId() != null
                && !existing.getTargetUserId().equals(SecurityUtils.getUserId())
                && !SecurityUtils.hasRole("admin") && !SecurityUtils.hasRole("warehouse")) {
            return AjaxResult.error("无权查看他人的通知");
        }
        return AjaxResult.success(existing);
    }

    @PreAuthorize("@ss.hasPermi('textbook:notice:list')")
    @Log(title = "通知公告", businessType = BusinessType.UPDATE)
    @PutMapping("/read/{noticeId}")
    public AjaxResult markAsRead(@PathVariable Long noticeId) {
        SysNotice existing = noticeService.selectNoticeById(noticeId);
        if (existing != null && existing.getTargetUserId() != null
                && !existing.getTargetUserId().equals(SecurityUtils.getUserId())) {
            return AjaxResult.error("无权操作他人的通知");
        }
        SysNotice notice = new SysNotice();
        notice.setNoticeId(noticeId);
        notice.setReadStatus("1");
        return toAjax(noticeService.updateNotice(notice));
    }

    @PreAuthorize("@ss.hasPermi('textbook:notice:list')")
    @Log(title = "通知公告", businessType = BusinessType.UPDATE)
    @PutMapping("/read/batch")
    public AjaxResult batchMarkAsRead(@RequestBody Long[] noticeIds) {
        Long userId = SecurityUtils.getUserId();
        boolean isAdminOrWarehouse = SecurityUtils.hasRole("admin") || SecurityUtils.hasRole("warehouse");
        int count = 0;
        for (Long noticeId : noticeIds) {
            if (!isAdminOrWarehouse) {
                SysNotice existing = noticeService.selectNoticeById(noticeId);
                if (existing != null && existing.getTargetUserId() != null
                        && !existing.getTargetUserId().equals(userId)) {
                    continue;
                }
            }
            SysNotice notice = new SysNotice();
            notice.setNoticeId(noticeId);
            notice.setReadStatus("1");
            count += noticeService.updateNotice(notice);
        }
        return AjaxResult.success("成功标记" + count + "条通知为已读");
    }

    @PreAuthorize("@ss.hasPermi('textbook:notice:list')")
    @Log(title = "通知公告", businessType = BusinessType.UPDATE)
    @PutMapping("/read/all")
    public AjaxResult markAllAsRead() {
        Long userId = SecurityUtils.getUserId();
        SysNotice query = new SysNotice();
        query.setTargetUserId(userId);
        query.setReadStatus("0");
        List<SysNotice> unreadList = noticeService.selectNoticeList(query);
        if (unreadList != null && !unreadList.isEmpty()) {
            int count = 0;
            for (SysNotice notice : unreadList) {
                notice.setReadStatus("1");
                count += noticeService.updateNotice(notice);
            }
            return AjaxResult.success("成功标记" + count + "条通知为已读");
        }
        return AjaxResult.success("没有未读通知");
    }

    @PreAuthorize("@ss.hasPermi('textbook:notice:add') and @ss.hasAnyRoles('admin,warehouse')")
    @Log(title = "通知公告", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody SysNotice notice) {
        notice.setCreateBy(SecurityUtils.getUsername());
        return toAjax(noticeService.insertNotice(notice));
    }

    @PreAuthorize("@ss.hasPermi('textbook:notice:edit') and @ss.hasAnyRoles('admin,warehouse')")
    @Log(title = "通知公告", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody SysNotice notice) {
        notice.setUpdateBy(SecurityUtils.getUsername());
        return toAjax(noticeService.updateNotice(notice));
    }

    @PreAuthorize("@ss.hasPermi('textbook:notice:remove') and @ss.hasAnyRoles('admin,warehouse')")
    @Log(title = "通知公告", businessType = BusinessType.DELETE)
    @DeleteMapping("/{noticeIds}")
    public AjaxResult remove(@PathVariable Long[] noticeIds) {
        return toAjax(noticeService.deleteNoticeByIds(noticeIds));
    }
}
