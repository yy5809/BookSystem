package com.ruoyi.textbook.service;

import java.util.List;
import com.ruoyi.textbook.domain.TbSupplier;
import com.ruoyi.textbook.domain.vo.SupplierVO;

public interface ITbSupplierService {
    List<TbSupplier> selectTbSupplierList(TbSupplier tbSupplier);
    List<SupplierVO> selectSupplierVOList(TbSupplier tbSupplier);
    SupplierVO selectSupplierVOById(Long supplierId);
    TbSupplier selectTbSupplierById(Long supplierId);
    TbSupplier selectSupplierByUserId(Long userId);
    int insertTbSupplier(TbSupplier tbSupplier);
    int updateTbSupplier(TbSupplier tbSupplier);
    int deleteTbSupplierByIds(Long[] supplierIds);
    int deleteTbSupplierById(Long supplierId);
}
