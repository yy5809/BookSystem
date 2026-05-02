package com.ruoyi.textbook.controller;

import java.util.List;
import javax.servlet.http.HttpServletResponse;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.domain.entity.SysUser;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.textbook.domain.dto.TeacherImportDTO;
import com.ruoyi.textbook.service.ITeacherManageService;

@RestController
@RequestMapping("/textbook/teacher")
public class TeacherManageController extends BaseController {

    @Autowired
    private ITeacherManageService teacherManageService;

    @PreAuthorize("@ss.hasPermi('textbook:teacher:list')")
    @GetMapping("/list")
    public TableDataInfo list(SysUser user) {
        startPage();
        List<SysUser> list = teacherManageService.selectTeacherList(user);
        return getDataTable(list);
    }

    @PreAuthorize("@ss.hasPermi('textbook:teacher:query')")
    @GetMapping("/{userId}")
    public AjaxResult getInfo(@PathVariable Long userId) {
        return success(teacherManageService.selectTeacherById(userId));
    }

    @PreAuthorize("@ss.hasPermi('textbook:teacher:add')")
    @Log(title = "教师管理", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody SysUser user) {
        if (!teacherManageService.checkUserNameUnique(user)) {
            return error("新增教师'" + user.getUserName() + "'失败，职工号已存在");
        }
        user.setCreateBy(getUsername());
        return toAjax(teacherManageService.insertTeacher(user));
    }

    @PreAuthorize("@ss.hasPermi('textbook:teacher:edit')")
    @Log(title = "教师管理", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody SysUser user) {
        if (!teacherManageService.checkUserNameUnique(user)) {
            return error("修改教师'" + user.getUserName() + "'失败，职工号已存在");
        }
        user.setUpdateBy(getUsername());
        return toAjax(teacherManageService.updateTeacher(user));
    }

    @PreAuthorize("@ss.hasPermi('textbook:teacher:remove')")
    @Log(title = "教师管理", businessType = BusinessType.DELETE)
    @DeleteMapping("/{userIds}")
    public AjaxResult remove(@PathVariable Long[] userIds) {
        return toAjax(teacherManageService.deleteTeacherByIds(userIds));
    }

    @PreAuthorize("@ss.hasPermi('textbook:teacher:resetPwd')")
    @Log(title = "教师管理", businessType = BusinessType.UPDATE)
    @PutMapping("/resetPwd")
    public AjaxResult resetPwd(@RequestBody SysUser user) {
        user.setUpdateBy(getUsername());
        return toAjax(teacherManageService.resetTeacherPwd(user));
    }

    @PreAuthorize("@ss.hasPermi('textbook:teacher:edit')")
    @Log(title = "教师管理", businessType = BusinessType.UPDATE)
    @PutMapping("/changeStatus")
    public AjaxResult changeStatus(@RequestBody SysUser user) {
        user.setUpdateBy(getUsername());
        return toAjax(teacherManageService.changeTeacherStatus(user));
    }

    @Log(title = "教师管理", businessType = BusinessType.IMPORT)
    @PreAuthorize("@ss.hasPermi('textbook:teacher:import')")
    @PostMapping("/importData")
    public AjaxResult importData(MultipartFile file) throws Exception {
        ExcelUtil<TeacherImportDTO> util = new ExcelUtil<>(TeacherImportDTO.class);
        List<TeacherImportDTO> teacherList = util.importExcel(file.getInputStream());
        String message = teacherManageService.importTeacher(teacherList, getUsername());
        return success(message);
    }

    @PostMapping("/importTemplate")
    public void importTemplate(HttpServletResponse response) {
        ExcelUtil<TeacherImportDTO> util = new ExcelUtil<>(TeacherImportDTO.class);
        util.importTemplateExcel(response, "教师数据");
    }
}
