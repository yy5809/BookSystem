package com.ruoyi.textbook.service;

import java.util.List;
import java.util.Map;
import com.ruoyi.textbook.domain.TbSupplier;

public interface ISupplierAccountService {

    List<Map<String, Object>> selectSupplierAccountList(TbSupplier supplier);

    TbSupplier selectSupplierById(Long supplierId);

    boolean checkSupplierCodeUnique(TbSupplier supplier);

    int insertSupplierAccount(TbSupplier supplier, String password, String operName);

    int updateSupplierAccount(TbSupplier supplier, String operName);

    int deleteSupplierAccountByIds(Long[] supplierIds);

    int resetSupplierPwd(Long userId, String password, String operName);

    int changeSupplierStatus(Long userId, String status, String operName);
}
