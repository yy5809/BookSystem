package com.ruoyi.textbook.service;

import com.ruoyi.textbook.domain.dto.TbPurchaseImportDTO;
import java.util.List;
import java.util.Map;

public interface IPurchaseImportService {
    Map<String, Object> importFromExcel(List<TbPurchaseImportDTO> dataList, Long operatorId, String operatorName, String fileHash);
}
