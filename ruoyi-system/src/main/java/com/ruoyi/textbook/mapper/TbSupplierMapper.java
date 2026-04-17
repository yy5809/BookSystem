package com.ruoyi.textbook.mapper;

import com.ruoyi.textbook.domain.TbPurchase;
import com.ruoyi.textbook.domain.TbSupplier;

import java.util.List;

public interface TbSupplierMapper {

    // 根据用户ID获取供应商信息
    TbSupplier selectByUserId(Long userId);

    // 根据供应商ID获取供应商信息
    TbSupplier selectBySupplierId(Long supplierId);

    // 新增供应商
    int insertTbSupplier(TbSupplier supplier);

    // 更新供应商
    int updateTbSupplier(TbSupplier supplier);

    // 删除供应商
    int deleteTbSupplierById(Long supplierId);

    // 查询供应商列表
    List<TbSupplier> selectTbSupplierList(TbSupplier supplier);

    // 统计供应商待确认发货的采购单数
    int countPendingShipmentBySupplierId(Long supplierId);

    // 查询供应商的采购单列表
    List<TbPurchase> selectSupplierPurchases(TbPurchase purchase);
}
