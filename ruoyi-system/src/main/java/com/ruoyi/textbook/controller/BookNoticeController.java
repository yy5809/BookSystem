package com.ruoyi.textbook.controller;

import java.util.List;
import java.util.Map;
import java.util.ArrayList;
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
    
    /**
     * 获取学院列表
     */
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
    @GetMapping("/major/list/{collegeId}")
    public AjaxResult getMajors(@PathVariable Long collegeId) {
        // 这里返回模拟的专业数据，实际项目中应该从数据库获取
        List<Map<String, Object>> majors = new ArrayList<>();
        if (collegeId == 1) {
            Map<String, Object> major1 = new java.util.HashMap<>();
            major1.put("id", 101);
            major1.put("name", "计算机科学与技术");
            majors.add(major1);
            Map<String, Object> major2 = new java.util.HashMap<>();
            major2.put("id", 102);
            major2.put("name", "软件工程");
            majors.add(major2);
            Map<String, Object> major3 = new java.util.HashMap<>();
            major3.put("id", 103);
            major3.put("name", "人工智能");
            majors.add(major3);
        } else if (collegeId == 2) {
            Map<String, Object> major1 = new java.util.HashMap<>();
            major1.put("id", 201);
            major1.put("name", "电子信息工程");
            majors.add(major1);
            Map<String, Object> major2 = new java.util.HashMap<>();
            major2.put("id", 202);
            major2.put("name", "通信工程");
            majors.add(major2);
        } else if (collegeId == 3) {
            Map<String, Object> major1 = new java.util.HashMap<>();
            major1.put("id", 301);
            major1.put("name", "机械设计制造及其自动化");
            majors.add(major1);
            Map<String, Object> major2 = new java.util.HashMap<>();
            major2.put("id", 302);
            major2.put("name", "机械电子工程");
            majors.add(major2);
        }
        return AjaxResult.success(majors);
    }
    
    /**
     * 获取班级列表
     */
    @GetMapping("/class/list/{majorId}")
    public AjaxResult getClasses(@PathVariable Long majorId) {
        // 这里返回模拟的班级数据，实际项目中应该从数据库获取
        List<Map<String, Object>> classes = new ArrayList<>();
        if (majorId == 101) {
            Map<String, Object> cls1 = new java.util.HashMap<>();
            cls1.put("id", 10101);
            cls1.put("name", "计科2301");
            classes.add(cls1);
            Map<String, Object> cls2 = new java.util.HashMap<>();
            cls2.put("id", 10102);
            cls2.put("name", "计科2302");
            classes.add(cls2);
            Map<String, Object> cls3 = new java.util.HashMap<>();
            cls3.put("id", 10103);
            cls3.put("name", "计科2303");
            classes.add(cls3);
        } else if (majorId == 102) {
            Map<String, Object> cls1 = new java.util.HashMap<>();
            cls1.put("id", 10201);
            cls1.put("name", "软工2301");
            classes.add(cls1);
            Map<String, Object> cls2 = new java.util.HashMap<>();
            cls2.put("id", 10202);
            cls2.put("name", "软工2302");
            classes.add(cls2);
        } else if (majorId == 103) {
            Map<String, Object> cls1 = new java.util.HashMap<>();
            cls1.put("id", 10301);
            cls1.put("name", "人工智能2301");
            classes.add(cls1);
        }
        return AjaxResult.success(classes);
    }
}
