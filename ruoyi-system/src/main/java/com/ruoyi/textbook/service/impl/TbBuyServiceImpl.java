package com.ruoyi.textbook.service.impl;

import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.DateUtils;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.common.utils.uuid.IdUtils;
import com.ruoyi.common.core.domain.entity.SysUser;
import com.ruoyi.common.core.domain.entity.SysDictData;
import com.ruoyi.common.core.domain.entity.SysRole;
import com.ruoyi.system.mapper.SysDictDataMapper;
import com.ruoyi.system.mapper.SysUserMapper;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.textbook.domain.TbBook;
import com.ruoyi.textbook.domain.TbPurchase;
import com.ruoyi.textbook.domain.TbPurchaseDetail;
import com.ruoyi.textbook.domain.TbInventory;
import com.ruoyi.textbook.domain.TbShortage;
import com.ruoyi.textbook.domain.TbOutbound;
import com.ruoyi.textbook.domain.dto.TbPurchaseImportDTO;
import com.ruoyi.textbook.mapper.TbBookMapper;
import com.ruoyi.textbook.mapper.TbInventoryMapper;
import com.ruoyi.textbook.mapper.TbOutboundMapper;
import com.ruoyi.textbook.mapper.TbPurchaseMapper;
import com.ruoyi.textbook.mapper.TbShortageMapper;
import com.ruoyi.textbook.service.ITbBuyService;
import com.ruoyi.textbook.service.NoticeService;
import com.ruoyi.textbook.enums.AuditStatusEnum;
import com.ruoyi.textbook.enums.ReceiveStatusEnum;
import com.ruoyi.textbook.constants.TextbookConstants;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.InputStream;
import java.security.DigestInputStream;
import java.security.MessageDigest;
import java.util.*;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.stream.Collectors;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@Service
public class TbBuyServiceImpl implements ITbBuyService {

    private static final Logger log = LoggerFactory.getLogger(TbBuyServiceImpl.class);
    private static final int MAX_IMPORT_ROWS = 1000;

    @Autowired
    private TbPurchaseMapper tbPurchaseMapper;

    @Autowired
    private TbInventoryMapper tbInventoryMapper;

    @Autowired
    private TbShortageMapper tbShortageMapper;

    @Autowired
    private TbOutboundMapper tbOutboundMapper;

    @Autowired
    private TbBookMapper tbBookMapper;

    @Autowired
    private SysUserMapper sysUserMapper;

    @Autowired
    private SysDictDataMapper dictDataMapper;

    @Autowired
    private NoticeService noticeService;

    @Override
    public TbPurchase getById(Long buyId) {
        return tbPurchaseMapper.selectTbPurchaseById(buyId);
    }

    @Override
    public List<TbPurchase> list(TbPurchase tbPurchase) {
        return tbPurchaseMapper.selectTbPurchaseList(tbPurchase);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int submit(TbPurchase buy) {
        String purchaseNo = "PUR" + DateUtils.dateTimeNow("yyyyMMddHHmmss") + IdUtils.fastSimpleUUID().substring(0, 6);
        buy.setPurchaseNo(purchaseNo);
        buy.setAuditStatus(AuditStatusEnum.PENDING.getCode());
        buy.setReceiveStatus(ReceiveStatusEnum.NOT_RECEIVED.getCode());
        buy.setSubmitTime(LocalDateTime.now());
        buy.setCreateTime(DateUtils.getNowDate());
        int result = tbPurchaseMapper.insertTbPurchase(buy);

        if (buy.getDetails() != null) {
            for (TbPurchaseDetail detail : buy.getDetails()) {
                detail.setPurchaseId(buy.getBuyId());
                tbPurchaseMapper.insertTbPurchaseDetail(detail);
            }
        }
        return result;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int audit(Long buyId, String status, String rejectReason) {
        TbPurchase buy = tbPurchaseMapper.selectTbPurchaseById(buyId);
        if (buy == null) return 0;

        buy.setAuditStatus(status);
        if (StringUtils.isNotEmpty(rejectReason)) {
            buy.setRejectReason(rejectReason);
        }
        buy.setAuditUserId(SecurityUtils.getUserId());
        buy.setAuditTime(LocalDateTime.now());

        List<TbPurchaseDetail> details = tbPurchaseMapper.selectTbPurchaseDetailListByPurchaseId(buyId);

        if (AuditStatusEnum.APPROVED.getCode().equals(status)) {
            StringBuilder shortageInfo = new StringBuilder();
            boolean hasShortage = false;

            for (TbPurchaseDetail detail : details) {
                TbInventory stock = tbInventoryMapper.selectTbInventoryByBookId(detail.getBookId());
                if (stock == null || stock.getStockNum() < detail.getQuantity()) {
                    hasShortage = true;
                    int lackNum = (stock == null) ? detail.getQuantity() : detail.getQuantity() - stock.getStockNum();
                    int currentStock = (stock == null) ? 0 : stock.getStockNum();

                    shortageInfo.append(String.format("《%s》：需%d本，库存仅%d本，缺%d本；",
                            detail.getBookName(), detail.getQuantity(), currentStock, lackNum));

                    TbShortage lack = new TbShortage();
                    lack.setBookId(detail.getBookId());
                    lack.setBookName(detail.getBookName());
                    lack.setIsbn(detail.getIsbn());
                    lack.setLackNum(lackNum);
                    lack.setHandleStatus("0");
                    lack.setSource("1");
                    lack.setSourceId(buyId);
                    lack.setCreateTime(DateUtils.getNowDate());
                    tbShortageMapper.insertTbShortage(lack);

                    noticeService.sendLackNotice(
                        detail.getBookId(),
                        detail.getBookName(),
                        detail.getIsbn(),
                        lackNum,
                        currentStock,
                        lack.getLackId()
                    );
                }
            }

            if (hasShortage) {
                buy.setAuditStatus(AuditStatusEnum.REJECTED.getCode());
                buy.setRejectReason("部分教材库存不足，无法通过审核。详情：" + shortageInfo.toString());
                tbPurchaseMapper.updateTbPurchase(buy);

                noticeService.sendOrderApproveNotice(
                    buy.getUserId(),
                    details.stream().map(TbPurchaseDetail::getBookName).collect(Collectors.joining("、")),
                    "2",
                    buy.getRejectReason(),
                    buyId
                );

                throw new ServiceException("部分教材库存不足，已自动驳回并登记缺书单。\n" + shortageInfo.toString());
            }

            noticeService.sendOrderApproveNotice(
                buy.getUserId(),
                details.stream().map(TbPurchaseDetail::getBookName).collect(Collectors.joining("、")),
                "1",
                "审核通过，请前往书库领取",
                buyId
            );
        } else if (AuditStatusEnum.REJECTED.getCode().equals(status)) {
            buy.setRejectReason(rejectReason);

            List<TbPurchaseDetail> rejectDetails = tbPurchaseMapper.selectTbPurchaseDetailListByPurchaseId(buyId);
            noticeService.sendOrderApproveNotice(
                buy.getUserId(),
                rejectDetails.stream().map(TbPurchaseDetail::getBookName).collect(Collectors.joining("、")),
                "2",
                rejectReason,
                buyId
            );
        }

        int result = tbPurchaseMapper.updateTbPurchase(buy);

        if (AuditStatusEnum.APPROVED.getCode().equals(status)) {
            List<TbPurchaseDetail> approveDetails = tbPurchaseMapper.selectTbPurchaseDetailListByPurchaseId(buyId);
            noticeService.sendOrderApproveNotice(
                buy.getUserId(),
                approveDetails.stream().map(TbPurchaseDetail::getBookName).collect(Collectors.joining("、")),
                "1",
                "审核通过，请前往书库领取",
                buyId
            );
        }

        return result;
    }

    @Override
    @Transactional
    public int confirmReceive(Long buyId) {
        TbPurchase buy = tbPurchaseMapper.selectTbPurchaseById(buyId);
        if (buy == null) throw new ServiceException("购书单不存在");
        if (!AuditStatusEnum.APPROVED.getCode().equals(buy.getAuditStatus())) throw new ServiceException("购书单未审核通过");
        if (ReceiveStatusEnum.RECEIVED.getCode().equals(buy.getReceiveStatus())) throw new ServiceException("该购书单已领书");

        List<TbPurchaseDetail> details = tbPurchaseMapper.selectTbPurchaseDetailListByPurchaseId(buyId);
        for (TbPurchaseDetail detail : details) {
            TbInventory stock = tbInventoryMapper.selectTbInventoryByBookId(detail.getBookId());
            if (stock == null || stock.getStockNum() < detail.getQuantity()) {
                throw new ServiceException("教材「" + detail.getBookName() + "」库存不足，无法出库");
            }
            int rows = tbInventoryMapper.updateInventoryQuantity(detail.getBookId(), -detail.getQuantity());
            if (rows == 0) throw new ServiceException("库存扣减失败");

            TbOutbound out = new TbOutbound();
            out.setBuyId(buyId);
            out.setPurchaseNo(buy.getPurchaseNo());
            out.setBookId(detail.getBookId());
            out.setBookName(detail.getBookName());
            out.setIsbn(detail.getIsbn());
            out.setOutNum(detail.getQuantity());
            out.setReceiveId(buy.getUserId());
            out.setOperatorId(SecurityUtils.getUserId());
            tbOutboundMapper.insertTbOutbound(out);
        }

        buy.setReceiveStatus(ReceiveStatusEnum.RECEIVED.getCode());
        buy.setReceiveTime(LocalDateTime.now());
        return tbPurchaseMapper.updateTbPurchase(buy);
    }

    @Override
    public int delete(Long[] buyIds) {
        return tbPurchaseMapper.deleteTbPurchaseByIds(buyIds);
    }

    @Override
    public List<TbPurchaseDetail> selectDetailsByPurchaseId(Long purchaseId) {
        return tbPurchaseMapper.selectTbPurchaseDetailListByPurchaseId(purchaseId);
    }

    @Override
    public List<TbPurchaseDetail> batchSelectDetailsByPurchaseIds(List<Long> purchaseIds) {
        if (purchaseIds == null || purchaseIds.isEmpty()) {
            return java.util.Collections.emptyList();
        }
        return tbPurchaseMapper.selectTbPurchaseDetailListByPurchaseIds(purchaseIds);
    }

    @Override
    public Map<String, Object> getUserOrderStats(Long userId) {
        Map<String, Object> stats = new HashMap<>();
        TbPurchase query = new TbPurchase();
        query.setUserId(userId);
        List<TbPurchase> allOrders = tbPurchaseMapper.selectTbPurchaseList(query);
        int pendingCount = 0, approvedCount = 0, rejectedCount = 0, receivedCount = 0;
        java.math.BigDecimal totalAmount = java.math.BigDecimal.ZERO;
        int totalBooks = 0;
        for (TbPurchase order : allOrders) {
            String status = order.getAuditStatus();
            if (AuditStatusEnum.PENDING.getCode().equals(status)) pendingCount++;
            else if (AuditStatusEnum.APPROVED.getCode().equals(status)) { approvedCount++; if (ReceiveStatusEnum.RECEIVED.getCode().equals(order.getReceiveStatus())) receivedCount++; }
            else if (AuditStatusEnum.REJECTED.getCode().equals(status)) rejectedCount++;
            List<TbPurchaseDetail> details = tbPurchaseMapper.selectTbPurchaseDetailListByPurchaseId(order.getBuyId());
            for (TbPurchaseDetail d : details) {
                totalBooks += d.getQuantity() != null ? d.getQuantity() : 0;
                if (d.getTotalPrice() != null) totalAmount = totalAmount.add(d.getTotalPrice());
            }
        }
        stats.put("totalOrders", allOrders.size());
        stats.put("pendingCount", pendingCount);
        stats.put("approvedCount", approvedCount);
        stats.put("rejectedCount", rejectedCount);
        stats.put("receivedCount", receivedCount);
        stats.put("totalBooks", totalBooks);
        stats.put("totalAmount", totalAmount);
        return stats;
    }

    @Override
    @Transactional
    public int cancelOrder(Long buyId) {
        TbPurchase buy = tbPurchaseMapper.selectTbPurchaseById(buyId);
        if (buy == null) throw new ServiceException("订单不存在");
        if (!AuditStatusEnum.PENDING.getCode().equals(buy.getAuditStatus())) throw new ServiceException("只能取消待审核的订单");
        buy.setAuditStatus(AuditStatusEnum.REJECTED.getCode());
        buy.setRejectReason("用户自行取消");
        return tbPurchaseMapper.updateTbPurchase(buy);
    }

    @Override
    @Transactional
    public int batchSubmit(List<TbPurchase> buys) {
        if (buys == null || buys.isEmpty()) { return 0; }
        if (buys.size() > TextbookConstants.MAX_BATCH_SIZE) {
            throw new ServiceException("批量提交数量超过限制，单次最多" + TextbookConstants.MAX_BATCH_SIZE + "条");
        }
        int count = 0;
        for (TbPurchase buy : buys) { count += this.submit(buy); }
        return count;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Map<String, Object> importFromExcel(MultipartFile file) {
        long startTime = System.currentTimeMillis();
        Map<String, Object> result = new HashMap<>();
        List<Map<String, Object>> errorList = new ArrayList<>();
        AtomicInteger successCount = new AtomicInteger(0);
        AtomicInteger failCount = new AtomicInteger(0);

        try {
            String originalFilename = file.getOriginalFilename();
            log.info("【采购单导入】开始处理文件: {}, 用户: {}", originalFilename, SecurityUtils.getUsername());

            ExcelUtil<TbPurchaseImportDTO> util = new ExcelUtil<>(TbPurchaseImportDTO.class);
            InputStream inputStream = file.getInputStream();
            List<TbPurchaseImportDTO> importList = util.importExcel(inputStream);

            if (importList == null || importList.isEmpty()) {
                result.put("msg", "Excel文件中没有数据");
                result.put("successCount", 0);
                result.put("failCount", 0);
                result.put("errorList", errorList);
                return result;
            }

            String fileMd5 = calculateFileMD5(file);
            log.info("【采购单导入】文件MD5: {}, 文件名: {}", fileMd5, originalFilename);

            TbPurchase existingPurchase = tbPurchaseMapper.selectByFileHash(fileMd5);
            if (existingPurchase != null) {
                throw new ServiceException(
                    "该文件已导入过（MD5: " + fileMd5.substring(0, 8) + "...），" +
                    "采购单号：" + existingPurchase.getPurchaseNo() + "，" +
                    "请勿重复导入相同文件。如需重新导入请先删除原采购单。");
            }

            if (importList.size() > MAX_IMPORT_ROWS) {
                throw new ServiceException("导入数据超过上限，单次最多" + MAX_IMPORT_ROWS + "行（当前" + importList.size() + "行）");
            }

            Long currentUserId = SecurityUtils.getUserId();
            SysUser currentUser = sysUserMapper.selectUserById(currentUserId);
            if (currentUser == null) { throw new ServiceException("获取当前用户信息失败"); }

            String seqNum = String.format("%03d", System.currentTimeMillis() % 1000);
            String purchaseNo = "CG" + LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss")) + seqNum;

            TbPurchase purchase = new TbPurchase();
            purchase.setPurchaseNo(purchaseNo);
            purchase.setUserId(currentUserId);
            purchase.setUserName(currentUser.getNickName());
            purchase.setUserType(getUserTypeByRoles(currentUser));
            purchase.setDeptName(currentUser.getDept() != null ? currentUser.getDept().getDeptName() : "");
            purchase.setAuditStatus(AuditStatusEnum.PENDING.getCode());
            purchase.setReceiveStatus(ReceiveStatusEnum.NOT_RECEIVED.getCode());
            purchase.setSubmitTime(LocalDateTime.now());
            purchase.setFundingSource(TextbookConstants.FUNDING_SOURCE_SCHOOL);
            purchase.setFileHash(fileMd5);

            int rows = tbPurchaseMapper.insertTbPurchase(purchase);
            if (rows <= 0) { throw new ServiceException("创建采购主单失败"); }
            log.info("【采购单导入】创建采购主单成功, ID={}, 单号={}", purchase.getBuyId(), purchaseNo);

            List<TbPurchaseDetail> detailList = new ArrayList<>();
            int dataRowIndex = 2;

            for (int i = 0; i < importList.size(); i++) {
                TbPurchaseImportDTO dto = importList.get(i);
                dto.setRowIndex(dataRowIndex);

                if (!dto.isValidRow()) {
                    dataRowIndex++; continue;
                }

                StringBuilder rowError = new StringBuilder();
                boolean hasError = false;

                if (StringUtils.isEmpty(dto.getIsbn())) {
                    rowError.append("ISBN不能为空；"); hasError = true;
                } else if (!dto.getIsbn().matches("^\\d{10}$|^\\d{13}$")) {
                    rowError.append("ISBN格式错误（必须为10或13位数字）；"); hasError = true;
                } else {
                    TbBook book = tbBookMapper.selectTbBookByIsbn(dto.getIsbn().trim());
                    if (book == null) {
                        rowError.append("系统中不存在该ISBN对应的教材[").append(dto.getIsbn()).append("]；"); hasError = true;
                    }
                }

                if (StringUtils.isNotEmpty(dto.getBookName()) && dto.getBookName().length() > 200) {
                    rowError.append("教材名称超长（≤200字）；"); hasError = true;
                }

                if (dto.getQuantity() == null || dto.getQuantity() < 1 || dto.getQuantity() > 9999) {
                    rowError.append("采购数量无效（1-9999的整数）；"); hasError = true;
                }

                if (StringUtils.isEmpty(dto.getCollege())) {
                    rowError.append("申请学院不能为空；"); hasError = true;
                } else {
                    SysDictData collegeDict = validateDictValue("tb_college", dto.getCollege());
                    if (collegeDict == null) {
                        rowError.append("申请学院[").append(dto.getCollege()).append("]不在系统字典中；"); hasError = true;
                    }
                }

                if (StringUtils.isEmpty(dto.getMajor())) {
                    rowError.append("申请专业不能为空；"); hasError = true;
                } else {
                    SysDictData majorDict = validateDictValue("tb_major", dto.getMajor());
                    if (majorDict == null) {
                        rowError.append("申请专业[").append(dto.getMajor()).append("]不在系统字典中；"); hasError = true;
                    }
                }

                if (hasError) {
                    failCount.incrementAndGet();
                    Map<String, Object> errorInfo = new HashMap<>();
                    errorInfo.put("rowIndex", dataRowIndex);
                    errorInfo.put("isbn", dto.getIsbn());
                    errorInfo.put("bookName", dto.getBookName());
                    errorInfo.put("quantity", dto.getQuantity());
                    errorInfo.put("college", dto.getCollege());
                    errorInfo.put("major", dto.getMajor());
                    errorInfo.put("errorReason", rowError.toString().replaceAll("；$", ""));
                    errorList.add(errorInfo);
                    log.warn("第{}行校验失败: {}", dataRowIndex, rowError);
                } else {
                    TbBook book = tbBookMapper.selectTbBookByIsbn(dto.getIsbn().trim());
                    TbPurchaseDetail detail = new TbPurchaseDetail();
                    detail.setPurchaseId(purchase.getBuyId());
                    detail.setBookId(book != null ? book.getBookId() : null);
                    detail.setBookName(book != null ? book.getBookName() : dto.getBookName());
                    detail.setIsbn(dto.getIsbn().trim());
                    detail.setQuantity(dto.getQuantity());
                    detail.setUnitPrice(book != null ? book.getPrice() : null);
                    detail.setTotalPrice(null);
                    detail.setRemark(dto.getRemark());
                    detailList.add(detail);
                    successCount.incrementAndGet();
                }
                dataRowIndex++;
            }

            for (TbPurchaseDetail detail : detailList) {
                tbPurchaseMapper.insertTbPurchaseDetail(detail);
            }

            long costTime = System.currentTimeMillis() - startTime;
            log.info("【采购单导入】完成! 单号={}, 成功={}条, 失败={}条, 耗时={}ms", purchaseNo, successCount.get(), failCount.get(), costTime);

            result.put("purchaseNo", purchaseNo);
            result.put("purchaseId", purchase.getBuyId());

            if (successCount.get() > 0) {
                noticeService.sendPurchaseCreateNotice(purchase.getBuyId(), purchaseNo, successCount.get());
            }

        } catch (ServiceException e) {
            log.error("【采购单导入】业务异常: {}", e.getMessage()); throw e;
        } catch (Exception e) {
            log.error("【采购单导入】系统异常", e); throw new ServiceException("导入失败：" + e.getMessage());
        }

        result.put("totalRows", successCount.get() + failCount.get());
        result.put("successCount", successCount.get());
        result.put("failCount", failCount.get());
        result.put("errorList", errorList);
        result.put("msg", String.format("导入完成！成功%d条，失败%d条，共%d条数据", successCount.get(), failCount.get(), successCount.get() + failCount.get()));
        return result;
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

    private static String calculateFileMD5(MultipartFile file) throws Exception {
        MessageDigest md = MessageDigest.getInstance("MD5");
        try (InputStream is = file.getInputStream(); DigestInputStream dis = new DigestInputStream(is, md)) {
            byte[] buffer = new byte[8192];
            while (dis.read(buffer) != -1) { }
        }
        byte[] digest = md.digest();
        StringBuilder sb = new StringBuilder();
        for (byte b : digest) { sb.append(String.format("%02x", b & 0xff)); }
        return sb.toString();
    }

    private String getUserTypeByRoles(SysUser user) {
        if (user.getRoles() != null) {
            for (com.ruoyi.common.core.domain.entity.SysRole role : user.getRoles()) {
                if ("teacher".equals(role.getRoleKey()) || "3".equals(role.getRoleKey())) return "1";
                if ("warehouseman".equals(role.getRoleKey()) || "2".equals(role.getRoleKey())) return "2";
            }
        }
        return "1";
    }
}
