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
}