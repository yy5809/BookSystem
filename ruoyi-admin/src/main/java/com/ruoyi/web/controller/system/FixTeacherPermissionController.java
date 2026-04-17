package com.ruoyi.web.controller.system;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.enums.BusinessType;

/**
 * 修复教师角色权限控制器
 */
@RestController
@RequestMapping("/system/fix")
public class FixTeacherPermissionController {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    /**
     * 修复教师角色权限（仅超级管理员可操作）
     */
    @PreAuthorize("@ss.hasRole('admin')")
    @Log(title = "修复教师权限", businessType = BusinessType.UPDATE)
    @GetMapping("/teacherPermission")
    public AjaxResult fixTeacherPermission() {
        try {
            // 1. 获取所有角色ID（包括teacher和teacher_student）
            List<Long> roleIds = jdbcTemplate.queryForList(
                "SELECT role_id FROM sys_role WHERE role_key IN ('teacher', 'teacher_student')", Long.class);

            if (roleIds.isEmpty()) {
                return AjaxResult.error("未找到教师角色");
            }

            // 2. 获取库存管理和出库管理菜单ID
            List<Long> menuIds = jdbcTemplate.queryForList(
                "SELECT menu_id FROM sys_menu WHERE menu_name IN ('库存管理', '出库管理')", Long.class);

            if (menuIds.isEmpty()) {
                return AjaxResult.error("未找到库存管理或出库管理菜单");
            }

            // 3. 移除教师角色的库存管理和出库管理权限
            for (Long roleId : roleIds) {
                for (Long menuId : menuIds) {
                    jdbcTemplate.update(
                        "DELETE FROM sys_role_menu WHERE role_id = ? AND menu_id = ?",
                        roleId, menuId);
                }
            }

            return AjaxResult.success("教师角色权限修复成功！");
        } catch (Exception e) {
            return AjaxResult.error("修复失败：" + e.getMessage());
        }
    }
}
