package com.ruoyi.textbook.service.impl;

import java.util.List;
import java.util.stream.Collectors;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.textbook.domain.TbSupplier;
import com.ruoyi.textbook.domain.vo.SupplierVO;
import com.ruoyi.textbook.mapper.TbSupplierMapper;
import com.ruoyi.textbook.service.ITbSupplierService;
import org.springframework.transaction.annotation.Transactional;

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
    public List<SupplierVO> selectSupplierVOList(TbSupplier tbSupplier) {
        List<TbSupplier> suppliers = tbSupplierMapper.selectTbSupplierList(tbSupplier);
        List<SupplierVO> voList = new java.util.ArrayList<>();
        if (suppliers != null) {
            for (TbSupplier supplier : suppliers) {
                voList.add(toSupplierVO(supplier));
            }
        }
        return voList;
    }

    private SupplierVO toSupplierVO(TbSupplier supplier) {
        if (supplier == null) return null;
        SupplierVO vo = new SupplierVO();
        vo.setSupplierId(supplier.getSupplierId());
        vo.setSupplierCode(supplier.getSupplierCode());
        vo.setSupplierName(supplier.getSupplierName());
        vo.setContactPerson(supplier.getContactPerson());
        vo.setContactPhone(supplier.getContactPhone());
        vo.setContactEmail(supplier.getContactEmail());
        vo.setAddress(supplier.getAddress());
        vo.setDiscountRate(supplier.getDiscountRate());
        vo.setPaymentTerms(supplier.getPaymentTerms());
        vo.setStatus(supplier.getStatus());
        return vo;
    }

    @Override
    public SupplierVO selectSupplierVOById(Long supplierId) {
        return toSupplierVO(tbSupplierMapper.selectBySupplierId(supplierId));
    }

    @Override
    public TbSupplier selectTbSupplierById(Long supplierId) {
        return tbSupplierMapper.selectBySupplierId(supplierId);
    }

    @Override
    public TbSupplier selectSupplierByUserId(Long userId) {
        return tbSupplierMapper.selectByUserId(userId);
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
    @Transactional(rollbackFor = Exception.class)
    public int deleteTbSupplierByIds(Long[] supplierIds) {
        return tbSupplierMapper.deleteTbSupplierByIds(supplierIds);
    }

    @Override
    public int deleteTbSupplierById(Long supplierId) {
        return tbSupplierMapper.deleteTbSupplierById(supplierId);
    }
}
