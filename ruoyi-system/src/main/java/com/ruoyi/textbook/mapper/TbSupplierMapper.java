package com.ruoyi.textbook.mapper;

import java.util.List;
import com.ruoyi.textbook.domain.TbSupplier;

/**
 * 供应商管理 数据层
 */
public interface TbSupplierMapper {

    public List<TbSupplier> selectTbSupplierList(TbSupplier tbSupplier);

    public TbSupplier selectTbSupplierById(Long supplierId);

    public TbSupplier selectSupplierByUserId(Long userId);

    public int insertTbSupplier(TbSupplier tbSupplier);

    public int updateTbSupplier(TbSupplier tbSupplier);

    public int deleteTbSupplierByIds(Long[] supplierIds);

    public int deleteTbSupplierById(Long supplierId);
}
