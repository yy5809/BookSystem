package com.ruoyi.textbook.service;

import com.ruoyi.textbook.domain.TbPurchase;
import com.ruoyi.textbook.domain.TbPurchaseDetail;
import java.util.List;

/**
 * 购书信息Service接口
 * 
 * @author ruoyi
 */
public interface ITbPurchaseService
{
    TbPurchase selectTbPurchaseById(Long purchaseId);
    List<TbPurchase> list(TbPurchase tbPurchase);
    List<TbPurchase> selectTbPurchaseList(TbPurchase tbPurchase);
    int insertTbPurchase(TbPurchase tbPurchase, List<TbPurchaseDetail> details);
    int updateTbPurchase(TbPurchase tbPurchase);
    int deleteTbPurchaseById(Long purchaseId);
    int deleteTbPurchaseByIds(Long[] purchaseIds);
    List<TbPurchaseDetail> selectTbPurchaseDetailListByPurchaseId(Long purchaseId);
    int auditTbPurchase(Long purchaseId, String status);
    int invoiceTbPurchase(Long purchaseId, String invoiceNo);

    int confirmShipBySupplier(Long purchaseId, Long supplierUserId, String supplierName, String logisticsNo, String logisticsCompany);
}