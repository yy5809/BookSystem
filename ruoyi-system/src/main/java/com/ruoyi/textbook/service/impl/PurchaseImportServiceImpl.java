package com.ruoyi.textbook.service.impl;

import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.DateUtils;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.textbook.domain.TbBook;
import com.ruoyi.textbook.domain.TbPurchase;
import com.ruoyi.textbook.domain.TbPurchaseDetail;
import com.ruoyi.textbook.domain.TbShortage;
import com.ruoyi.textbook.domain.dto.TbPurchaseImportDTO;
import com.ruoyi.textbook.mapper.TbBookMapper;
import com.ruoyi.textbook.mapper.TbPurchaseMapper;
import com.ruoyi.textbook.mapper.TbShortageMapper;
import com.ruoyi.textbook.service.IPurchaseImportService;
import com.ruoyi.textbook.service.NoticeService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;

@Service
public class PurchaseImportServiceImpl implements IPurchaseImportService {

    private static final Logger log = LoggerFactory.getLogger(PurchaseImportServiceImpl.class);

    @Autowired
    private TbBookMapper tbBookMapper;

    @Autowired
    private TbPurchaseMapper tbPurchaseMapper;

    @Autowired
    private TbShortageMapper tbShortageMapper;

    @Autowired
    private NoticeService noticeService;

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Map<String, Object> importFromExcel(List<TbPurchaseImportDTO> dataList, Long operatorId, String operatorName, String fileHash) {
        log.info("【Excel导入】开始处理, 总行数={}, 操作人={}", dataList.size(), operatorName);

        if (fileHash != null && !fileHash.isEmpty()) {
            TbPurchase existing = tbPurchaseMapper.selectByFileHash(fileHash);
            if (existing != null) {
                throw new ServiceException("该文件已导入过，采购单号：" + existing.getPurchaseNo() + "，请勿重复导入");
            }
        }

        List<TbPurchaseImportDTO> successList = new ArrayList<>();
        List<TbPurchaseImportDTO> failList = new ArrayList<>();

        for (int i = 0; i < dataList.size(); i++) {
            TbPurchaseImportDTO dto = dataList.get(i);
            dto.setRowIndex(i + 2);

            try {
                validateRow(dto);
                successList.add(dto);
            } catch (Exception e) {
                dto.setErrorMsg(e.getMessage());
                failList.add(dto);
                log.warn("【Excel导入】第{}行校验失败: {}", dto.getRowIndex(), e.getMessage());
            }
        }

        if (successList.isEmpty()) {
            return buildResult(dataList.size(), 0, failList, "所有数据行校验失败");
        }

        TbPurchase purchase = new TbPurchase();
        String purchaseNo = "CG" + DateUtils.dateTimeNow("yyyyMMddHHmmss") + String.format("%03d", System.currentTimeMillis() % 1000);
        purchase.setPurchaseNo(purchaseNo);
        purchase.setAuditStatus("0");
        purchase.setFileHash(fileHash);
        purchase.setCreateBy(operatorName);
        purchase.setCreateTime(DateUtils.getNowDate());
        purchase.setUpdateTime(DateUtils.getNowDate());

        int result = tbPurchaseMapper.insertTbPurchase(purchase);
        if (result <= 0) {
            throw new ServiceException("创建采购主单失败");
        }

        log.info("【Excel导入】采购主单已创建: {}", purchaseNo);

        for (TbPurchaseImportDTO dto : successList) {
            try {
                TbBook book = tbBookMapper.selectTbBookByIsbn(dto.getIsbn());
                if (book == null) {
                    dto.setErrorMsg("ISBN对应的教材不存在于系统中");
                    failList.add(dto);
                    continue;
                }

                TbPurchaseDetail detail = new TbPurchaseDetail();
                detail.setPurchaseId(purchase.getBuyId());
                detail.setBookId(book.getBookId());
                detail.setBookName(book.getBookName());
                detail.setIsbn(dto.getIsbn());
                detail.setQuantity(dto.getQuantity());
                detail.setCreateTime(DateUtils.getNowDate());

                tbPurchaseMapper.insertTbPurchaseDetail(detail);

                TbShortage shortage = findMatchingShortage(dto.getIsbn(), dto.getQuantity());
                if (shortage != null) {
                    shortage.setHandleStatus("1");
                    shortage.setSourceId(purchase.getBuyId());
                    shortage.setRemark("已纳入采购单" + purchaseNo);
                    tbShortageMapper.updateTbShortage(shortage);
                    log.info("【Excel导入】缺书单已关联, lackId={}, ISBN={}", shortage.getLackId(), dto.getIsbn());
                }

            } catch (Exception e) {
                dto.setErrorMsg("处理异常：" + e.getMessage());
                failList.add(dto);
                log.error("【Excel导入】第{}行处理异常: {}", dto.getRowIndex(), e.getMessage());
            }
        }

        log.info("【Excel导入】完成! 成功={}, 失败={}, 采购单号={}", successList.size() - failList.size() + getOriginalFailCount(failList, dataList.size()), failList.size(), purchaseNo);

        int actualSuccess = successList.size() - countNewFailures(failList, successList.size());
        if (actualSuccess > 0) {
            try {
                noticeService.sendPurchaseCreateNotice(purchase.getBuyId(), purchaseNo, actualSuccess);
            } catch (Exception e) {
                log.warn("【Excel导入】发送采购单创建通知失败: {}", e.getMessage());
            }
        }

        return buildResult(dataList.size(), actualSuccess, failList, purchaseNo);
    }

    private void validateRow(TbPurchaseImportDTO dto) {
        if (!isValidRow(dto)) {
            return;
        }

        if (StringUtils.isEmpty(dto.getIsbn())) {
            throw new ServiceException("ISBN不能为空");
        }

        if (!dto.getIsbn().matches("^\\d{10}$|^\\d{13}$")) {
            throw new ServiceException("ISBN格式错误，必须为10位或13位数字");
        }

        if (dto.getQuantity() == null || dto.getQuantity() < 1 || dto.getQuantity() > 9999) {
            throw new ServiceException("采购数量必须在1-9999之间");
        }

        if (StringUtils.isEmpty(dto.getCollege())) {
            throw new ServiceException("申请学院不能为空");
        }

        if (StringUtils.isEmpty(dto.getMajor())) {
            throw new ServiceException("申请专业不能为空");
        }
    }

    private boolean isValidRow(TbPurchaseImportDTO dto) {
        return dto != null && (dto.getIsbn() != null || dto.getBookName() != null);
    }

    private TbShortage findMatchingShortage(String isbn, Integer quantity) {
        List<TbShortage> shortages = tbShortageMapper.selectTbShortageListByIsbn(isbn);
        if (shortages != null && !shortages.isEmpty()) {
            for (TbShortage s : shortages) {
                if ("0".equals(s.getHandleStatus())) {
                    return s;
                }
            }
        }
        return null;
    }

    private Map<String, Object> buildResult(int totalRows, int successCount, List<TbPurchaseImportDTO> failList, String message) {
        Map<String, Object> result = new HashMap<>();
        result.put("totalRows", totalRows);
        result.put("successCount", successCount);
        result.put("failCount", failList.size());
        result.put("failList", failList);
        result.put("message", message);
        return result;
    }

    private int countNewFailures(List<TbPurchaseImportDTO> failList, int originalSuccessSize) {
        int newFailures = 0;
        for (TbPurchaseImportDTO dto : failList) {
            if (dto.getErrorMsg() != null && !dto.getErrorMsg().startsWith("ISBN") &&
                !dto.getErrorMsg().startsWith("采购数量") && !dto.getErrorMsg().startsWith("申请")) {
                newFailures++;
            }
        }
        return newFailures;
    }

    private int getOriginalFailCount(List<TbPurchaseImportDTO> failList, int totalSize) {
        int count = 0;
        for (TbPurchaseImportDTO dto : failList) {
            if (dto.getErrorMsg() != null && (dto.getErrorMsg().contains("不能为空") ||
                dto.getErrorMsg().contains("格式错误") || dto.getErrorMsg().contains("必须在"))) {
                count++;
            }
        }
        return count;
    }
}
