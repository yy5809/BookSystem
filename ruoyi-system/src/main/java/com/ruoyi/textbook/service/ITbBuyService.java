package com.ruoyi.textbook.service;

import com.ruoyi.textbook.domain.TbPurchase;
import com.ruoyi.textbook.domain.TbPurchaseDetail;
import com.ruoyi.textbook.domain.dto.TbPurchaseImportDTO;
import org.springframework.web.multipart.MultipartFile;
import java.util.List;
import java.util.Map;

public interface ITbBuyService {
    List<TbPurchase> list(TbPurchase query);
    TbPurchase getById(Long buyId);
    int submit(TbPurchase buy);
    int audit(Long buyId, String status, String rejectReason);
    int confirmOrder(Long buyId, Long supplierId);
    int confirmArrived(Long buyId);
    int submitVerification(Long buyId);
    int confirmVerify(Long buyId, String verifyResult, String verifyRemark, String qualityCheckResult, Integer actualQtyReceived, String invoiceNo);
    int returnToArrived(Long buyId, String remark);
    int verifyDetail(Long detailId, String verifyStatus, String verifyRemark);
    int receiveDetail(Long detailId, Integer receivedQty);
    int returnDetail(Long detailId, Integer returnQty, String returnReason);
    int correctDetailInfo(Long detailId, String infoCorrection);
    int registerShortageDetail(Long detailId, String remark);
    int batchVerifyDetails(List<Long> detailIds, String verifyStatus);
    int directInboundDetail(Long detailId);
    int confirmInbound(Long buyId);
    int confirmReceive(Long buyId);
    int delete(Long[] buyIds);
    int deleteWithCheck(Long buyId);
    List<TbPurchaseDetail> selectDetailsByPurchaseId(Long purchaseId);
    List<TbPurchaseDetail> batchSelectDetailsByPurchaseIds(List<Long> purchaseIds);
    Map<String, Object> getUserOrderStats(Long userId);
    int cancelOrder(Long buyId);
    int batchSubmit(List<TbPurchase> buys);

    /**
     * 从Excel导入采购单
     * @param file Excel文件
     * @return 导入结果（成功数量、失败信息等）
     */
    Map<String, Object> importFromExcel(MultipartFile file);

    int adjustDetail(Long buyId, List<TbPurchaseDetail> details);

    int archivePurchase(Long buyId);

    List<TbPurchase> listArchived(TbPurchase query);
}