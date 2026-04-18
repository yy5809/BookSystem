package com.ruoyi.system.textbook.controller;

import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.domain.entity.SysRole;
import com.ruoyi.system.service.ISysRoleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * 供应商角色管理控制器
 */
@RestController
@RequestMapping("/textbook/supplier/role")
public class SupplierRoleController extends BaseController {

    @Autowired
    private ISysRoleService roleService;

    /**
     * 创建供应商角色
     */
    @PostMapping("/create")
    public AjaxResult createSupplierRole() {
        SysRole role = new SysRole();
        role.setRoleName("供应商");
        role.setRoleKey("supplier");
        role.setRoleSort(3);
        role.setStatus("0");
        role.setDelFlag("0");
        role.setCreateBy("admin");
        
        // 检查角色是否已存在
        SysRole checkRole = new SysRole();
        checkRole.setRoleKey("supplier");
        boolean isUnique = roleService.checkRoleKeyUnique(checkRole);
        if (!isUnique) {
            return AjaxResult.success("供应商角色已存在");
        }
        
        // 创建角色
        int result = roleService.insertRole(role);
        if (result > 0) {
            return AjaxResult.success("供应商角色创建成功");
        } else {
            return AjaxResult.error("供应商角色创建失败");
        }
    }
}
