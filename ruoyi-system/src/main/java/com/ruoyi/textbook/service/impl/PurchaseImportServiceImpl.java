package com.ruoyi.textbook.service.impl;

import com.ruoyi.common.core.domain.entity.SysDictData;
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
import com.ruoyi.system.mapper.SysDictDataMapper;
import com.ruoyi.textbook.service.IPurchaseImportService;
import com.ruoyi.textbook.service.NoticeService;
import com.ruoyi.textbook.util.PurchaseNoGenerator;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;
import java.util.concurrent.atomic.AtomicInteger;

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
    private SysDictDataMapper dictDataMapper;

    @Autowired
    private NoticeService noticeService;

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Map<String, Object> importFromExcel(List<TbPurchaseImportDTO> dataList, Long operatorId, String operatorName, String fileHash) {
        log.info("【Excel导入】开始处理, 总行数={}, 操作人={}, 文件哈希={}", dataList.size(), operatorName, fileHash);

        // 防重复导入校验
        if (fileHash != null && !fileHash.isEmpty()) {
            log.info("【Excel导入】检查文件是否重复导入");
            TbPurchase existing = tbPurchaseMapper.selectByFileHash(fileHash);
            if (existing != null) {
                log.warn("【Excel导入】文件重复导入，采购单号：{}", existing.getPurchaseNo());
                throw new ServiceException("该文件已导入过，采购单号：" + existing.getPurchaseNo() + "，请勿重复导入");
            }
        }

        List<TbPurchaseImportDTO> successList = new ArrayList<>();
        List<TbPurchaseImportDTO> failList = new ArrayList<>();

        // 数据校验阶段
        log.info("【Excel导入】开始数据校验阶段");
        for (int i = 0; i < dataList.size(); i++) {
            TbPurchaseImportDTO dto = dataList.get(i);
            dto.setRowIndex(i + 2);

            try {
                validateRow(dto);
                successList.add(dto);
                if (i % 100 == 0) {
                    log.info("【Excel导入】校验进度: {}/{}", i + 1, dataList.size());
                }
            } catch (Exception e) {
                dto.setErrorMsg(e.getMessage());
                failList.add(dto);
                log.warn("【Excel导入】第{}行校验失败: {}", dto.getRowIndex(), e.getMessage());
            }
        }

        log.info("【Excel导入】数据校验完成，成功={}, 失败={}", successList.size(), failList.size());

        if (successList.isEmpty()) {
            log.warn("【Excel导入】所有数据行校验失败");
            return buildResult(dataList.size(), 0, failList, "所有数据行校验失败");
        }

        // 创建采购主单
        log.info("【Excel导入】开始创建采购主单");
        TbPurchase purchase = new TbPurchase();
        String purchaseNo = PurchaseNoGenerator.generateWithUUID();
        purchase.setPurchaseNo(purchaseNo);
        purchase.setStatus("0"); // 待审核
        purchase.setFileHash(fileHash);
        purchase.setCreateBy(operatorName);
        purchase.setCreateTime(DateUtils.getNowDate());
        purchase.setUpdateTime(DateUtils.getNowDate());

        int result = tbPurchaseMapper.insertTbPurchase(purchase);
        if (result <= 0) {
            log.error("【Excel导入】创建采购主单失败");
            throw new ServiceException("创建采购主单失败");
        }

        log.info("【Excel导入】采购主单已创建: {}", purchaseNo);

        // 处理采购明细
        log.info("【Excel导入】开始处理采购明细");
        int detailSuccessCount = 0;
        for (int i = 0; i < successList.size(); i++) {
            TbPurchaseImportDTO dto = successList.get(i);
            try {
                // 检查教材是否存在
                TbBook book = tbBookMapper.selectTbBookByIsbn(dto.getIsbn());
                if (book == null) {
                    dto.setErrorMsg("ISBN对应的教材不存在于系统中");
                    failList.add(dto);
                    log.warn("【Excel导入】第{}行教材不存在: ISBN={}", dto.getRowIndex(), dto.getIsbn());
                    continue;
                }

                // 创建采购明细
                TbPurchaseDetail detail = new TbPurchaseDetail();
                detail.setPurchaseId(purchase.getBuyId());
                detail.setBookId(book.getBookId());
                detail.setBookName(book.getBookName());
                detail.setIsbn(dto.getIsbn());
                detail.setQuantity(dto.getQuantity());
                detail.setCreateTime(DateUtils.getNowDate());

                tbPurchaseMapper.insertTbPurchaseDetail(detail);
                detailSuccessCount++;

                // 关联缺书单
                TbShortage shortage = findMatchingShortage(dto.getIsbn(), dto.getQuantity());
                if (shortage != null) {
                    shortage.setHandleStatus("1");
                    shortage.setSourceId(purchase.getBuyId());
                    shortage.setRemark("已纳入采购单" + purchaseNo);
                    tbShortageMapper.updateTbShortage(shortage);
                    log.info("【Excel导入】缺书单已关联, lackId={}, ISBN={}", shortage.getLackId(), dto.getIsbn());
                }

                if (i % 50 == 0) {
                    log.info("【Excel导入】明细处理进度: {}/{}", i + 1, successList.size());
                }

            } catch (Exception e) {
                dto.setErrorMsg("处理异常：" + e.getMessage());
                failList.add(dto);
                log.error("【Excel导入】第{}行处理异常: {}", dto.getRowIndex(), e.getMessage(), e);
            }
        }

        log.info("【Excel导入】明细处理完成，成功={}, 失败={}", detailSuccessCount, successList.size() - detailSuccessCount);

        // 发送通知
        if (detailSuccessCount > 0) {
            try {
                noticeService.sendPurchaseCreateNotice(purchase.getBuyId(), purchaseNo, detailSuccessCount);
                log.info("【Excel导入】采购单创建通知发送成功");
            } catch (Exception e) {
                log.warn("【Excel导入】发送采购单创建通知失败: {}", e.getMessage(), e);
            }
        }

        // 构建结果
        log.info("【Excel导入】完成! 总记录数={}, 成功={}, 失败={}, 采购单号={}", dataList.size(), detailSuccessCount, failList.size(), purchaseNo);
        return buildResult(dataList.size(), detailSuccessCount, failList, purchaseNo);
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

        SysDictData collegeDict = validateDictValue("tb_college", dto.getCollege());
        if (collegeDict == null) {
            throw new ServiceException("申请学院[" + dto.getCollege() + "]不在系统字典中");
        }

        if (StringUtils.isEmpty(dto.getMajor())) {
            throw new ServiceException("申请专业不能为空");
        }

        SysDictData majorDict = validateDictValue("tb_major", dto.getMajor());
        if (majorDict == null) {
            throw new ServiceException("申请专业[" + dto.getMajor() + "]不在系统字典中");
        }
    }

    private SysDictData validateDictValue(String dictType, String dictLabel) {
        if (StringUtils.isEmpty(dictType) || StringUtils.isEmpty(dictLabel)) return null;
        SysDictData query = new SysDictData();
        query.setDictType(dictType);
        query.setDictLabel(dictLabel);
        query.setStatus("0");
        List<SysDictData> dictList = dictDataMapper.selectDictDataList(query);
        return (dictList != null && !dictList.isEmpty()) ? dictList.get(0) : null;
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
