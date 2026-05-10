package com.ruoyi.textbook.controller;

import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletResponse;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
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
import com.ruoyi.common.utils.StringUtils;

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
    public AjaxResult add(@RequestBody Map<String, Object> params) {
        String password = (String) params.get("password");
        if (StringUtils.isEmpty(password)) {
            return error("密码不能为空");
        }
        SysUser user = new SysUser();
        user.setUserName((String) params.get("userName"));
        user.setNickName((String) params.get("nickName"));
        user.setPassword(password);
        if (params.get("deptId") != null) {
            user.setDeptId(Long.valueOf(params.get("deptId").toString()));
        }
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
    public AjaxResult resetPwd(@RequestBody Map<String, String> params) {
        Long userId = Long.valueOf(params.get("userId"));
        String password = params.get("password");
        SysUser user = new SysUser();
        user.setUserId(userId);
        user.setPassword(password);
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

    @PreAuthorize("@ss.hasPermi('textbook:teacher:import')")
    @PostMapping("/importTemplate")
    public void importTemplate(HttpServletResponse response) throws Exception {
        XSSFWorkbook workbook = new XSSFWorkbook();
        CellStyle headerStyle = workbook.createCellStyle();
        Font headerFont = workbook.createFont();
        headerFont.setBold(true);
        headerStyle.setFont(headerFont);
        headerStyle.setFillForegroundColor(IndexedColors.LIGHT_CORNFLOWER_BLUE.getIndex());
        headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        headerStyle.setBorderBottom(BorderStyle.THIN);
        headerStyle.setBorderTop(BorderStyle.THIN);
        headerStyle.setBorderLeft(BorderStyle.THIN);
        headerStyle.setBorderRight(BorderStyle.THIN);

        Sheet sheet1 = workbook.createSheet("教师导入");
        String[] headers = {"姓名", "职工号", "密码", "所属部门"};
        Row headerRow = sheet1.createRow(0);
        for (int i = 0; i < headers.length; i++) {
            Cell cell = headerRow.createCell(i);
            cell.setCellValue(headers[i]);
            cell.setCellStyle(headerStyle);
        }
        int[] widths = {15, 20, 15, 25};
        for (int i = 0; i < widths.length; i++) {
            sheet1.setColumnWidth(i, widths[i] * 256);
        }

        Sheet sheet2 = workbook.createSheet("填写须知");
        String[] instructions = {
                "【教师账号导入模板 — 填写须知】",
                "",
                "一、基本要求",
                "  · 请严格按照模板格式填写，不要修改表头顺序和名称",
                "  · 建议使用 .xlsx 格式，文件大小不超过10MB",
                "",
                "二、列说明",
                "  · 姓名（必填）：教师的真实姓名，长度不超过30个字符",
                "  · 职工号（必填）：教师的唯一工号/账号，用于登录系统，长度不超过30个字符",
                "  ·       职工号不可与系统中已有账号重复，重复将跳过该行",
                "  · 密码（必填）：教师登录系统的初始密码，长度5-20位",
                "  ·       不能包含非法字符：<  >  \"  '  \\  |",
                "  · 所属部门（必填）：教师归属的学院/部门，必须从以下8个学院中选择：",
                "  ·       环境科学与工程学院、智能制造学院、土木工程学院、",
                "  ·       管理学院、艺术学院、语言文化学院、公共教学部、",
                "  ·       马克思主义学院",
                "",
                "三、注意事项",
                "  · 密码将在导入后自动加密存储，Excel中的明文密码不会留存",
                "  · 教师首次登录后建议修改密码",
                "  · 导入结果会显示成功/失败明细，失败行会附带原因说明",
                "  · 导入成功后教师即可使用职工号和密码登录系统"
        };
        for (int i = 0; i < instructions.length; i++) {
            Row row = sheet2.createRow(i);
            row.createCell(0).setCellValue(instructions[i]);
        }
        sheet2.setColumnWidth(0, 120 * 256);

        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setCharacterEncoding("UTF-8");
        String fileName = "教师导入模板.xlsx";
        response.setHeader("Content-Disposition",
                "attachment; filename=" + java.net.URLEncoder.encode(fileName, "UTF-8"));
        workbook.write(response.getOutputStream());
        workbook.close();
    }
}
