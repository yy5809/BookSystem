package com.ruoyi.textbook.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.textbook.domain.TbSupplier;
import com.ruoyi.textbook.mapper.TbSupplierMapper;
import com.ruoyi.textbook.service.ITbSupplierService;

/**
 * 供应商管理 服务层实现
 */
@Service
public class TbSupplierServiceImpl implements ITbSupplierService {

    @Autowired
    private TbSupplierMapper tbSupplierMapper;

    @Override
    public List<TbSupplier> selectTbSupplierList(TbSupplier tbSupplier) {
        return tbSupplierMapper.selectTbSupplierList(tbSupplier);
    }

    @Override
    public TbSupplier selectTbSupplierById(Long supplierId) {
        return tbSupplierMapper.selectTbSupplierById(supplierId);
    }

    @Override
    public TbSupplier selectSupplierByUserId(Long userId) {
        return tbSupplierMapper.selectSupplierByUserId(userId);
    }

    @Override
    public int insertTbSupplier(TbSupplier tbSupplier) {
        if (StringUtils.isNull(tbSupplier.getDiscountRate())) {
            tbSupplier.setDiscountRate(new java.math.BigDecimal("100.00"));
        }
        if (StringUtils.isEmpty(tbSupplier.getStatus())) {
            tbSupplier.setStatus("0");
        }
        return tbSupplierMapper.insertTbSupplier(tbSupplier);
    }

    @Override
    public int updateTbSupplier(TbSupplier tbSupplier) {
        return tbSupplierMapper.updateTbSupplier(tbSupplier);
    }

    @Override
    public int deleteTbSupplierByIds(Long[] supplierIds) {
        return tbSupplierMapper.deleteTbSupplierByIds(supplierIds);
    }

    @Override
    public int deleteTbSupplierById(Long supplierId) {
        return tbSupplierMapper.deleteTbSupplierById(supplierId);
    }
}
