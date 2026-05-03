package com.ruoyi.textbook.service.impl;

import java.util.ArrayList;
import java.util.List;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.ruoyi.common.core.domain.entity.SysDept;
import com.ruoyi.common.core.domain.entity.SysRole;
import com.ruoyi.common.core.domain.entity.SysUser;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.common.utils.bean.BeanValidators;
import com.ruoyi.system.mapper.SysDeptMapper;
import com.ruoyi.system.mapper.SysRoleMapper;
import com.ruoyi.system.mapper.SysUserMapper;
import com.ruoyi.system.mapper.SysUserRoleMapper;
import com.ruoyi.system.domain.SysUserRole;
import com.ruoyi.textbook.domain.dto.TeacherImportDTO;
import com.ruoyi.textbook.service.ITeacherManageService;
import javax.validation.Validator;

@Service
public class TeacherManageServiceImpl implements ITeacherManageService {

    private final SysUserMapper userMapper;
    private final SysDeptMapper deptMapper;
    private final SysRoleMapper roleMapper;
    private final SysUserRoleMapper userRoleMapper;

    @javax.annotation.Resource
    protected Validator validator;

    public TeacherManageServiceImpl(SysUserMapper userMapper,
                                     SysDeptMapper deptMapper,
                                     SysRoleMapper roleMapper,
                                     SysUserRoleMapper userRoleMapper) {
        this.userMapper = userMapper;
        this.deptMapper = deptMapper;
        this.roleMapper = roleMapper;
        this.userRoleMapper = userRoleMapper;
    }

    @Override
    public List<SysUser> selectTeacherList(SysUser user) {
        user.getParams().put("roleKey", "teacher");
        return userMapper.selectTeacherList(user);
    }

    @Override
    public SysUser selectTeacherById(Long userId) {
        return userMapper.selectUserById(userId);
    }

    @Override
    public boolean checkUserNameUnique(SysUser user) {
        Long userId = user.getUserId() == null ? -1L : user.getUserId();
        SysUser info = userMapper.selectUserByUserName(user.getUserName());
        if (info != null && info.getUserId().longValue() != userId.longValue()) {
            return false;
        }
        return true;
    }

    @Override
    @Transactional
    public int insertTeacher(SysUser user) {
        user.setPassword(SecurityUtils.encryptPassword(user.getPassword()));
        int rows = userMapper.insertUser(user);
        bindTeacherRole(user.getUserId());
        return rows;
    }

    @Override
    @Transactional
    public int updateTeacher(SysUser user) {
        Long userId = user.getUserId();
        userRoleMapper.deleteUserRoleByUserId(userId);
        bindTeacherRole(userId);
        return userMapper.updateUser(user);
    }

    @Override
    @Transactional
    public int deleteTeacherByIds(Long[] userIds) {
        for (Long userId : userIds) {
            userRoleMapper.deleteUserRoleByUserId(userId);
        }
        return userMapper.deleteUserByIds(userIds);
    }

    @Override
    @Transactional
    public int resetTeacherPwd(SysUser user) {
        user.setPassword(SecurityUtils.encryptPassword(user.getPassword()));
        return userMapper.updateUser(user);
    }

    @Override
    @Transactional
    public int changeTeacherStatus(SysUser user) {
        return userMapper.updateUser(user);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public String importTeacher(List<TeacherImportDTO> teacherList, String operName) {
        if (teacherList == null || teacherList.isEmpty()) {
            throw new ServiceException("导入教师数据不能为空！");
        }
        int successNum = 0;
        int failureNum = 0;
        StringBuilder successMsg = new StringBuilder();
        StringBuilder failureMsg = new StringBuilder();

        for (TeacherImportDTO dto : teacherList) {
            try {
                BeanValidators.validateWithException(validator, dto);

                SysDept dept = deptMapper.selectDeptByName(dto.getDeptName());
                if (dept == null) {
                    failureNum++;
                    failureMsg.append("<br/>").append(failureNum).append("、职工号 ")
                            .append(dto.getUserName()).append(" 导入失败：部门\"").append(dto.getDeptName()).append("\"不存在");
                    continue;
                }

                SysUser existUser = userMapper.selectUserByUserName(dto.getUserName());
                if (existUser != null) {
                    failureNum++;
                    failureMsg.append("<br/>").append(failureNum).append("、职工号 ")
                            .append(dto.getUserName()).append(" 已存在，已跳过");
                    continue;
                }

                SysUser user = new SysUser();
                user.setUserName(dto.getUserName());
                user.setNickName(dto.getNickName());
                user.setPassword(SecurityUtils.encryptPassword(dto.getPassword()));
                user.setDeptId(dept.getDeptId());
                user.setStatus("0");
                user.setCreateBy(operName);
                userMapper.insertUser(user);

                bindTeacherRole(user.getUserId());

                successNum++;
                successMsg.append("<br/>").append(successNum).append("、职工号 ")
                        .append(dto.getUserName()).append(" 导入成功");
            } catch (Exception e) {
                failureNum++;
                String msg = "<br/>" + failureNum + "、职工号 " + dto.getUserName() + " 导入失败：";
                failureMsg.append(msg).append(e.getMessage());
            }
        }

        if (failureNum > 0) {
            successMsg.insert(0, "导入完成！共成功导入 " + successNum + " 条。");
            successMsg.append("<br/><br/>以下 ").append(failureNum).append(" 条导入失败：");
            successMsg.append(failureMsg);
            return successMsg.toString();
        } else {
            successMsg.insert(0, "恭喜您，数据已全部导入成功！共 " + successNum + " 条。");
            return successMsg.toString();
        }
    }

    private void bindTeacherRole(Long userId) {
        SysRole role = roleMapper.selectRoleByRoleKey("teacher");
        if (role == null) {
            throw new ServiceException("系统中不存在 teacher 角色，请先创建该角色");
        }
        List<SysUserRole> list = new ArrayList<>(1);
        SysUserRole ur = new SysUserRole();
        ur.setUserId(userId);
        ur.setRoleId(role.getRoleId());
        list.add(ur);
        userRoleMapper.batchUserRole(list);
    }
}
