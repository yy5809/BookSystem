package com.ruoyi.textbook.controller;

import java.util.List;
import java.util.Map;
import java.util.ArrayList;

import com.ruoyi.textbook.domain.BookClaimForm;
import com.ruoyi.textbook.domain.BookNotice;
import com.ruoyi.textbook.service.IBookNoticeService;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.common.core.domain.entity.SysDictData;
import com.ruoyi.system.mapper.SysDictDataMapper;

@RestController
@RequestMapping("/textbook/notice")
public class BookNoticeController extends BaseController {

    @Autowired
    private IBookNoticeService bookNoticeService;

    @Autowired
    private SysDictDataMapper dictDataMapper;

    @PreAuthorize("@ss.hasPermi('textbook:noticeManage:list')")
    @GetMapping("/list")
    public TableDataInfo list(BookNotice bookNotice) {
        startPage();
        return getDataTable(bookNoticeService.selectBookNoticeList(bookNotice));
    }

    @PreAuthorize("@ss.hasPermi('textbook:noticeManage:query')")
    @GetMapping(value = "/{noticeId}")
    public AjaxResult getInfo(@PathVariable("noticeId") Long noticeId) {
        return AjaxResult.success(bookNoticeService.selectBookNoticeById(noticeId));
    }

    @PreAuthorize("@ss.hasPermi('textbook:noticeManage:add') and @ss.hasAnyRoles('admin,warehouse')")
    @Log(title = "领书通知", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody BookNotice bookNotice) {
        return toAjax(bookNoticeService.insertBookNotice(bookNotice));
    }

    @PreAuthorize("@ss.hasPermi('textbook:noticeManage:edit') and @ss.hasAnyRoles('admin,warehouse')")
    @Log(title = "领书通知", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody BookNotice bookNotice) {
        return toAjax(bookNoticeService.updateBookNotice(bookNotice));
    }

    @PreAuthorize("@ss.hasPermi('textbook:noticeManage:publish') and @ss.hasAnyRoles('admin,warehouse')")
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

    @PreAuthorize("@ss.hasPermi('textbook:noticeManage:remove') and @ss.hasAnyRoles('admin,warehouse')")
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
    
    /**
     * 获取学院列表
     */
    @PreAuthorize("@ss.hasPermi('textbook:notice:list')")
    @GetMapping("/college/list")
    public AjaxResult getColleges() {
        // 从字典表获取学院数据
        List<Map<String, Object>> colleges = new ArrayList<>();
        SysDictData query = new SysDictData();
        query.setDictType("tb_college");
        query.setStatus("0");
        List<SysDictData> dictList = dictDataMapper.selectDictDataList(query);
        for (SysDictData dict : dictList) {
            Map<String, Object> college = new java.util.HashMap<>();
            college.put("id", dict.getDictCode());
            college.put("name", dict.getDictLabel());
            colleges.add(college);
        }
        return AjaxResult.success(colleges);
    }
    
    /**
     * 获取专业列表
     */
    @PreAuthorize("@ss.hasPermi('textbook:notice:list')")
    @GetMapping("/major/list/{collegeId}")
    public AjaxResult getMajors(@PathVariable Long collegeId) {
        // 从字典表获取专业数据
        List<Map<String, Object>> majors = new ArrayList<>();
        String dictType = "tb_major_" + collegeId;
        SysDictData query = new SysDictData();
        query.setDictType(dictType);
        query.setStatus("0");
        List<SysDictData> dictList = dictDataMapper.selectDictDataList(query);
        for (SysDictData dict : dictList) {
            Map<String, Object> major = new java.util.HashMap<>();
            major.put("id", dict.getDictCode());
            major.put("name", dict.getDictLabel());
            majors.add(major);
        }
        return AjaxResult.success(majors);
    }
    
    /**
     * 获取班级列表
     */
    @PreAuthorize("@ss.hasPermi('textbook:notice:list')")
    @GetMapping("/class/list/{majorId}")
    public AjaxResult getClasses(@PathVariable Long majorId) {
        // 从字典表获取班级数据
        List<Map<String, Object>> classes = new ArrayList<>();
        // 根据专业ID构建字典类型
        // 这里简化处理，实际项目中可能需要更复杂的映射关系
        String dictType = "tb_class_" + majorId;
        SysDictData query = new SysDictData();
        query.setDictType(dictType);
        query.setStatus("0");
        List<SysDictData> dictList = dictDataMapper.selectDictDataList(query);
        for (SysDictData dict : dictList) {
            Map<String, Object> cls = new java.util.HashMap<>();
            cls.put("id", dict.getDictCode());
            cls.put("name", dict.getDictLabel());
            classes.add(cls);
        }
        return AjaxResult.success(classes);
    }
}
