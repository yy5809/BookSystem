package com.ruoyi.textbook.service.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.ruoyi.common.core.domain.entity.SysRole;
import com.ruoyi.common.core.domain.entity.SysUser;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.system.mapper.SysRoleMapper;
import com.ruoyi.system.mapper.SysUserMapper;
import com.ruoyi.system.mapper.SysUserRoleMapper;
import com.ruoyi.system.domain.SysUserRole;
import com.ruoyi.textbook.domain.TbSupplier;
import com.ruoyi.textbook.mapper.TbSupplierMapper;
import com.ruoyi.textbook.service.ISupplierAccountService;

@Service
public class SupplierAccountServiceImpl implements ISupplierAccountService {

    private final TbSupplierMapper supplierMapper;
    private final SysUserMapper userMapper;
    private final SysRoleMapper roleMapper;
    private final SysUserRoleMapper userRoleMapper;

    public SupplierAccountServiceImpl(TbSupplierMapper supplierMapper,
                                       SysUserMapper userMapper,
                                       SysRoleMapper roleMapper,
                                       SysUserRoleMapper userRoleMapper) {
        this.supplierMapper = supplierMapper;
        this.userMapper = userMapper;
        this.roleMapper = roleMapper;
        this.userRoleMapper = userRoleMapper;
    }

    @Override
    public List<Map<String, Object>> selectSupplierAccountList(TbSupplier supplier) {
        return supplierMapper.selectSupplierAccountList(supplier);
    }

    @Override
    public TbSupplier selectSupplierById(Long supplierId) {
        return supplierMapper.selectBySupplierId(supplierId);
    }

    @Override
    public boolean checkSupplierCodeUnique(TbSupplier supplier) {
        Long supplierId = supplier.getSupplierId() == null ? -1L : supplier.getSupplierId();
        TbSupplier existing = supplierMapper.selectBySupplierId(supplierId);
        // 按 supplier_code 查重：遍历列表中的记录是否有相同编码的不同ID
        // 简化实现：检查 sys_user 中是否已存在同 userName
        SysUser dupUser = userMapper.selectUserByUserName(supplier.getSupplierCode());
        if (dupUser != null && existing != null) {
            return existing.getUserId() != null && existing.getUserId().equals(dupUser.getUserId());
        }
        return dupUser == null;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int insertSupplierAccount(TbSupplier supplier, String password, String operName) {
        SysUser existUser = userMapper.selectUserByUserName(supplier.getSupplierCode());
        if (existUser != null) {
            throw new ServiceException("供应商编码'" + supplier.getSupplierCode() + "'已存在，请更换编码");
        }

        SysUser user = new SysUser();
        user.setUserName(supplier.getSupplierCode());
        user.setNickName(supplier.getSupplierName());
        user.setPassword(SecurityUtils.encryptPassword(password));
        user.setStatus("0");
        user.setCreateBy(operName);
        userMapper.insertUser(user);

        bindSupplierRole(user.getUserId());

        supplier.setUserId(user.getUserId());
        supplier.setDelFlag("0");
        return supplierMapper.insertTbSupplier(supplier);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int updateSupplierAccount(TbSupplier supplier, String operName) {
        TbSupplier existing = supplierMapper.selectBySupplierId(supplier.getSupplierId());
        if (existing == null) {
            throw new ServiceException("供应商不存在");
        }

        SysUser user = new SysUser();
        if (existing.getUserId() != null) {
            user.setUserId(existing.getUserId());
        } else if (supplier.getUserId() != null) {
            user.setUserId(supplier.getUserId());
        } else {
            throw new ServiceException("供应商未关联系统用户，无法执行更新操作");
        }
        user.setNickName(supplier.getSupplierName());
        user.setUserName(supplier.getSupplierCode());
        user.setUpdateBy(operName);
        userMapper.updateUser(user);

        return supplierMapper.updateTbSupplier(supplier);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int deleteSupplierAccountByIds(Long[] supplierIds) {
        int rows = 0;
        for (Long supplierId : supplierIds) {
            TbSupplier supplier = supplierMapper.selectBySupplierId(supplierId);
            if (supplier != null) {
                if (supplier.getUserId() != null) {
                    userRoleMapper.deleteUserRoleByUserId(supplier.getUserId());
                    userMapper.deleteUserById(supplier.getUserId());
                }
                rows += supplierMapper.deleteTbSupplierById(supplierId);
            }
        }
        return rows;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int resetSupplierPwd(Long userId, String password, String operName) {
        SysUser user = new SysUser();
        user.setUserId(userId);
        user.setPassword(SecurityUtils.encryptPassword(password));
        user.setUpdateBy(operName);
        return userMapper.updateUser(user);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int changeSupplierStatus(Long userId, String status, String operName) {
        SysUser user = new SysUser();
        user.setUserId(userId);
        user.setStatus(status);
        user.setUpdateBy(operName);
        return userMapper.updateUser(user);
    }

    private void bindSupplierRole(Long userId) {
        SysRole role = roleMapper.selectRoleByRoleKey("supplier");
        if (role == null) {
            throw new ServiceException("系统中不存在 supplier 角色，请先创建该角色");
        }
        List<SysUserRole> list = new ArrayList<>(1);
        SysUserRole ur = new SysUserRole();
        ur.setUserId(userId);
        ur.setRoleId(role.getRoleId());
        list.add(ur);
        userRoleMapper.batchUserRole(list);
    }
}
