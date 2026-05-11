package com.ruoyi.textbook.service.impl;

import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.DateUtils;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.common.utils.StringUtils;
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
import com.ruoyi.textbook.domain.TbStockLog;
import com.ruoyi.textbook.domain.TbSupplier;
import com.ruoyi.textbook.domain.BookNotice;
import com.ruoyi.textbook.domain.BookClaimForm;
import com.ruoyi.textbook.domain.BookClaimFormDetail;
import com.ruoyi.textbook.domain.dto.TbPurchaseImportDTO;
import com.ruoyi.textbook.domain.dto.StockOperationResult;
import com.ruoyi.textbook.enums.NoticeBizTypeEnum;
import com.ruoyi.textbook.mapper.TbBookMapper;
import com.ruoyi.textbook.mapper.TbInventoryMapper;
import com.ruoyi.textbook.mapper.TbOutboundMapper;
import com.ruoyi.textbook.mapper.TbPurchaseMapper;
import com.ruoyi.textbook.mapper.TbShortageMapper;
import com.ruoyi.textbook.mapper.TbStockLogMapper;
import com.ruoyi.textbook.mapper.TbSupplierMapper;
import com.ruoyi.textbook.mapper.BookNoticeMapper;
import com.ruoyi.textbook.mapper.BookClaimFormMapper;
import com.ruoyi.textbook.mapper.BookClaimFormDetailMapper;
import com.ruoyi.textbook.service.ITbBuyService;
import com.ruoyi.textbook.service.IStockOperationService;
import com.ruoyi.textbook.service.ITbStockLogService;
import com.ruoyi.textbook.service.NoticeService;
import com.ruoyi.textbook.enums.AuditStatusEnum;
import com.ruoyi.textbook.enums.ReceiveStatusEnum;
import com.ruoyi.textbook.enums.PurchaseStatusEnum;
import com.ruoyi.textbook.constants.TextbookConstants;
import com.ruoyi.textbook.util.PurchaseNoGenerator;

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

    @Autowired
    private TbStockLogMapper tbStockLogMapper;

    @Autowired
    private TbSupplierMapper tbSupplierMapper;

    @Autowired
    private BookNoticeMapper bookNoticeMapper;

    @Autowired
    private BookClaimFormMapper bookClaimFormMapper;

    @Autowired
    private BookClaimFormDetailMapper bookClaimFormDetailMapper;

    @Autowired
    private ITbStockLogService tbStockLogService;

    @Autowired
    private IStockOperationService stockOperationService;

    @Autowired
    private PurchaseStateService purchaseStateService;

    @Override
    public TbPurchase getById(Long buyId) {
        TbPurchase purchase = tbPurchaseMapper.selectTbPurchaseById(buyId);
        if (purchase != null) {
            purchase.setDetails(tbPurchaseMapper.selectTbPurchaseDetailListByPurchaseId(buyId));
        }
        return purchase;
    }

    @Override
    public List<TbPurchase> list(TbPurchase tbPurchase) {
        return tbPurchaseMapper.selectTbPurchaseList(tbPurchase);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int submit(TbPurchase buy) {
        String purchaseNo = PurchaseNoGenerator.generateWithUUID();
        buy.setPurchaseNo(purchaseNo);
        purchaseStateService.initAsApprovedWithWaitPurchase(buy);
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
        TbPurchase buy;
        if (AuditStatusEnum.APPROVED.getCode().equals(status)) {
            buy = purchaseStateService.auditApprove(buyId);
        } else if (AuditStatusEnum.REJECTED.getCode().equals(status)) {
            buy = purchaseStateService.auditReject(buyId, rejectReason);
        } else {
            throw new ServiceException("无效的审核状态，只能为通过或驳回");
        }

        buy.setAuditUserId(SecurityUtils.getUserId());
        buy.setAuditTime(LocalDateTime.now());

        List<TbPurchaseDetail> details = tbPurchaseMapper.selectTbPurchaseDetailListByPurchaseId(buyId);

        if (AuditStatusEnum.APPROVED.getCode().equals(status)) {
            noticeService.sendOrderApproveNotice(
                buy.getUserId(),
                details.stream().map(TbPurchaseDetail::getBookName).collect(Collectors.joining("、")),
                "1",
                "审核通过，请选择供应商并确认下单",
                buyId
            );
        } else {
            List<TbPurchaseDetail> rejectDetails = tbPurchaseMapper.selectTbPurchaseDetailListByPurchaseId(buyId);
            noticeService.sendOrderApproveNotice(
                buy.getUserId(),
                rejectDetails.stream().map(TbPurchaseDetail::getBookName).collect(Collectors.joining("、")),
                "2",
                rejectReason,
                buyId
            );
        }

        return tbPurchaseMapper.updateTbPurchase(buy);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int confirmOrder(Long buyId, Long supplierId) {
        if (supplierId == null) {
            throw new ServiceException("请选择供应商");
        }
        TbSupplier supplier = tbSupplierMapper.selectBySupplierId(supplierId);
        if (supplier == null) {
            throw new ServiceException("供应商不存在");
        }

        TbPurchase buy = purchaseStateService.transitionToPurchasing(buyId);
        buy.setSupplierId(supplierId);
        int result = tbPurchaseMapper.updateTbPurchase(buy);

        if (result > 0 && supplier.getUserId() != null) {
            List<TbPurchaseDetail> details = tbPurchaseMapper.selectTbPurchaseDetailListByPurchaseId(buyId);
            String bookNames = details.stream()
                    .map(TbPurchaseDetail::getBookName)
                    .collect(Collectors.joining("、"));
            noticeService.sendNoticeToUser(
                    supplier.getUserId(),
                    "新采购需求通知",
                    "您有新的采购需求！\n采购单号：" + buy.getPurchaseNo()
                            + "\n教材：" + bookNames
                            + "\n数量：" + details.stream().mapToInt(d -> d.getQuantity() != null ? d.getQuantity() : 0).sum() + " 本"
                            + "\n\n请登录系统确认接单并发货。",
                    NoticeBizTypeEnum.PURCHASE_CREATE.getCode(),
                    buyId);
            log.info("【确认下单】已通知供应商 {}, userId={}, 采购单号={}", supplier.getSupplierName(), supplier.getUserId(), buy.getPurchaseNo());
        }
        return result;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int confirmArrived(Long buyId) {
        TbPurchase buy = purchaseStateService.transitionToArrived(buyId);
        buy.setReceiveTime(LocalDateTime.now());
        int result = tbPurchaseMapper.updateTbPurchase(buy);

        List<TbShortage> relatedShortages = tbShortageMapper.selectTbShortageListByPurchaseId(buyId);
        if (relatedShortages != null) {
            for (TbShortage shortage : relatedShortages) {
                if ("1".equals(shortage.getHandleStatus())) {
                    shortage.setHandleStatus("2");
                    shortage.setUpdateTime(DateUtils.getNowDate());
                    tbShortageMapper.updateTbShortage(shortage);
                }
            }
        }

        try {
            autoGenerateClaimNotices(buyId, buy.getPurchaseNo());
        } catch (Exception e) {
            log.warn("【入库完成】自动生成班级领书计划失败: {}", e.getMessage());
        }

        return result;
    }

    private void autoGenerateClaimNotices(Long buyId, String purchaseNo) {
        List<TbPurchaseDetail> details = tbPurchaseMapper.selectTbPurchaseDetailListByPurchaseId(buyId);
        if (details == null || details.isEmpty()) return;

        List<TbPurchaseDetail> classifiableDetails = new ArrayList<>();
        for (TbPurchaseDetail d : details) {
            if (StringUtils.isNotEmpty(d.getCollege()) && StringUtils.isNotEmpty(d.getGrade())) {
                classifiableDetails.add(d);
            }
        }
        if (classifiableDetails.isEmpty()) return;

        java.util.Map<String, List<TbPurchaseDetail>> groupMap = new java.util.LinkedHashMap<>();
        for (TbPurchaseDetail d : classifiableDetails) {
            String key = (d.getCollege() != null ? d.getCollege() : "")
                    + "|" + (d.getMajor() != null ? d.getMajor() : "")
                    + "|" + (d.getGrade() != null ? d.getGrade() : "");
            groupMap.computeIfAbsent(key, k -> new ArrayList<>()).add(d);
        }

        String semester = generateSemester();
        String noticeNo = "TZ" + DateUtils.dateTimeNow("yyyyMMddHHmmss");
        BookNotice notice = new BookNotice();
        notice.setNoticeNo(noticeNo);
        notice.setSemester(semester);
        notice.setPickupLocation("库房");
        notice.setStatus("0");
        notice.setTotalClasses(groupMap.size());
        notice.setIssuedClasses(0);
        notice.setCreateBy(SecurityUtils.getLoginUser().getUser().getNickName());
        notice.setCreateTime(DateUtils.getNowDate());
        bookNoticeMapper.insertBookNotice(notice);

        String formNoPrefix = "LS" + DateUtils.dateTimeNow("yyyyMMddHHmmss");
        int formIndex = 0;
        for (java.util.Map.Entry<String, List<TbPurchaseDetail>> entry : groupMap.entrySet()) {
            TbPurchaseDetail first = entry.getValue().get(0);
            BookClaimForm form = new BookClaimForm();
            form.setNoticeId(notice.getNoticeId());
            form.setFormNo(formNoPrefix + String.format("%03d", ++formIndex));
            form.setGradeLevel(first.getGrade());
            String gradeYearPrefix = toGradeYearPrefix(first.getGrade());
            form.setClassName(gradeYearPrefix != null ? gradeYearPrefix + (StringUtils.isNotEmpty(first.getMajor()) ? first.getMajor() : "") : (first.getGrade() + (StringUtils.isNotEmpty(first.getMajor()) ? first.getMajor() : "")));
            form.setStatus("0");
            form.setPlannedQty(0);
            form.setIssuedQty(0);
            form.setCreateTime(DateUtils.getNowDate());
            bookClaimFormMapper.insertBookClaimForm(form);

            int plannedQty = 0;
            for (TbPurchaseDetail d : entry.getValue()) {
                BookClaimFormDetail detail = new BookClaimFormDetail();
                detail.setFormId(form.getFormId());
                detail.setTextbookId(d.getBookId());
                detail.setIsbn(d.getIsbn());
                detail.setBookName(d.getBookName());
                detail.setAuthor(d.getAuthor());
                detail.setPublisher(d.getPublisher());
                detail.setPlannedQty(d.getQuantity());
                detail.setIssuedQty(0);
                detail.setPrice(d.getUnitPrice());
                detail.setCreateTime(DateUtils.getNowDate());
                bookClaimFormDetailMapper.insertBookClaimFormDetail(detail);
                plannedQty += d.getQuantity() != null ? d.getQuantity() : 0;
            }
            form.setPlannedQty(plannedQty);
            bookClaimFormMapper.updateBookClaimForm(form);
        }

        log.info("【入库完成】已自动生成班级领书计划, purchaseId={}, noticeNo={}, 班级数={}", buyId, noticeNo, groupMap.size());
    }

    private static String toGradeYearPrefix(String gradeLevel) {
        if (gradeLevel == null) return null;
        if ("通用".equals(gradeLevel)) return "通用";
        java.util.Calendar cal = java.util.Calendar.getInstance();
        int year = cal.get(java.util.Calendar.YEAR);
        int month = cal.get(java.util.Calendar.MONTH) + 1;
        int freshmanYear = (month >= 9) ? year : year - 1;
        switch (gradeLevel) {
            case "大一": return (freshmanYear % 100) + "级";
            case "大二": return ((freshmanYear - 1) % 100) + "级";
            case "大三": return ((freshmanYear - 2) % 100) + "级";
            case "大四": return ((freshmanYear - 3) % 100) + "级";
            default: return gradeLevel;
        }
    }

    private String generateSemester() {
        java.util.Calendar cal = java.util.Calendar.getInstance();
        int year = cal.get(java.util.Calendar.YEAR);
        int month = cal.get(java.util.Calendar.MONTH) + 1;
        if (month >= 9) return year + "-" + (year + 1) + "-1";
        else if (month >= 2) return (year - 1) + "-" + year + "-2";
        else return (year - 1) + "-" + year + "-1";
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int confirmInbound(Long buyId) {
        TbPurchase buy = purchaseStateService.requirePurchase(buyId);

        String currentPurchaseStatus = buy.getPurchaseStatus();
        if (!PurchaseStatusEnum.ARRIVED.getCode().equals(currentPurchaseStatus)) {
            throw new ServiceException("只有已到货的采购单才能验收入库，当前状态：" + PurchaseStatusEnum.getDescByCode(currentPurchaseStatus));
        }

        List<TbPurchaseDetail> details = tbPurchaseMapper.selectTbPurchaseDetailListByPurchaseId(buyId);
        SysUser currentUser = sysUserMapper.selectUserById(SecurityUtils.getUserId());
        String operatorName = currentUser != null ? currentUser.getNickName() : SecurityUtils.getUsername();
        for (TbPurchaseDetail detail : details) {
            int qty = detail.getQuantity() != null ? detail.getQuantity() : 0;

            StockOperationResult stockResult = stockOperationService.addStock(
                    detail.getBookId(),
                    qty,
                    SecurityUtils.getUserId(),
                    operatorName,
                    "PURCHASE_INBOUND",
                    buy.getPurchaseNo(),
                    "采购验收入库，单号：" + buy.getPurchaseNo()
            );
            if (!stockResult.isSuccess()) {
                throw new ServiceException("教材「" + detail.getBookName() + "」入库失败：" + stockResult.getErrorMessage());
            }

            noticeService.sendInboundNotice(
                    detail.getBookId(), detail.getBookName(), buyId);
        }

        TbPurchase inboundPurchase = purchaseStateService.transitionToInbound(buyId);
        int result = tbPurchaseMapper.updateTbPurchase(inboundPurchase);

        List<TbShortage> relatedShortages = tbShortageMapper.selectTbShortageListByPurchaseId(buyId);
        if (relatedShortages != null) {
            for (TbShortage shortage : relatedShortages) {
                if ("1".equals(shortage.getHandleStatus()) || "2".equals(shortage.getHandleStatus())) {
                    shortage.setHandleStatus("3");
                    shortage.setHandleTime(new Date());
                    shortage.setUpdateTime(DateUtils.getNowDate());
                    shortage.setRemark("已通过采购单" + buy.getPurchaseNo() + "入库补齐");
                    tbShortageMapper.updateTbShortage(shortage);

                    if (shortage.getRegisterId() != null) {
                        noticeService.sendNoticeToUser(
                                shortage.getRegisterId(),
                                "缺书到货通知",
                                "您登记的缺书《" + shortage.getBookName() + "》已全部到货入库，请前往领取。",
                                NoticeBizTypeEnum.LACK.getCode(),
                                shortage.getLackId());
                        log.info("【入库完成】已通知缺书登记人领书, registerId={}, lackId={}", shortage.getRegisterId(), shortage.getLackId());
                    }
                }
            }
        }

        return result;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int confirmReceive(Long buyId) {
        TbPurchase buy = purchaseStateService.requirePurchase(buyId);
        purchaseStateService.validateCanReceive(buy);

        List<TbPurchaseDetail> details = tbPurchaseMapper.selectTbPurchaseDetailListByPurchaseId(buyId);
        for (TbPurchaseDetail detail : details) {
            StockOperationResult stockResult = stockOperationService.deductStock(
                    detail.getBookId(),
                    detail.getQuantity(),
                    SecurityUtils.getUserId(),
                    SecurityUtils.getLoginUser().getUser().getNickName(),
                    "PURCHASE_RECEIVE",
                    String.valueOf(buyId),
                    "采购单领书，单号：" + buy.getPurchaseNo()
            );
            if (!stockResult.isSuccess()) {
                throw new ServiceException("教材「" + detail.getBookName() + "」" + stockResult.getErrorMessage());
            }

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

        TbPurchase receivedPurchase = purchaseStateService.transitionToReceived(buyId);
        receivedPurchase.setReceiveTime(LocalDateTime.now());
        return tbPurchaseMapper.updateTbPurchase(receivedPurchase);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int delete(Long[] buyIds) {
        for (Long buyId : buyIds) {
            TbPurchase existing = tbPurchaseMapper.selectTbPurchaseById(buyId);
            purchaseStateService.validateCanDelete(existing);
        }
        for (Long buyId : buyIds) {
            List<TbShortage> relatedShortages = tbShortageMapper.selectTbShortageListByPurchaseId(buyId);
            if (relatedShortages != null) {
                for (TbShortage shortage : relatedShortages) {
                    if ("1".equals(shortage.getHandleStatus())) {
                        shortage.setHandleStatus("0");
                        shortage.setPurchaseId(null);
                        shortage.setRemark("关联采购单已删除，状态回退为未处理");
                        tbShortageMapper.updateTbShortage(shortage);
                        log.info("【采购单删除】缺书单状态回退, lackId={}", shortage.getLackId());
                    }
                }
            }
        }
        return tbPurchaseMapper.deleteTbPurchaseByIds(buyIds);
    }

    @Override
    public int deleteWithCheck(Long buyId) {
        TbPurchase order = purchaseStateService.requirePurchase(buyId);
        purchaseStateService.validateCanDeleteWithCheck(order);
        return delete(new Long[]{buyId});
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

        List<Long> orderIds = allOrders.stream().map(TbPurchase::getBuyId).collect(Collectors.toList());
        List<TbPurchaseDetail> allDetails = batchSelectDetailsByPurchaseIds(orderIds);

        for (TbPurchase order : allOrders) {
            String status = order.getStatus();
            if (AuditStatusEnum.PENDING.getCode().equals(status)) pendingCount++;
            else if (AuditStatusEnum.APPROVED.getCode().equals(status)) approvedCount++;
            else if ("3".equals(status)) receivedCount++;
            else if (AuditStatusEnum.REJECTED.getCode().equals(status)) rejectedCount++;
        }

        for (TbPurchaseDetail d : allDetails) {
            totalBooks += d.getQuantity() != null ? d.getQuantity() : 0;
            if (d.getTotalPrice() != null) totalAmount = totalAmount.add(d.getTotalPrice());
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
    @Transactional(rollbackFor = Exception.class)
    public int cancelOrder(Long buyId) {
        TbPurchase buy = purchaseStateService.cancelToRejected(buyId);
        return tbPurchaseMapper.updateTbPurchase(buy);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
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

            String purchaseNo = PurchaseNoGenerator.generateWithUUID();

            TbPurchase purchase = new TbPurchase();
            purchase.setPurchaseNo(purchaseNo);
            purchase.setUserId(currentUserId);
            purchase.setUserName(currentUser.getNickName());
        purchase.setUserType(getUserTypeByRoles(currentUser));
        purchase.setDeptName(currentUser.getDept() != null ? currentUser.getDept().getDeptName() : "");
        purchaseStateService.initAsApprovedWithWaitPurchase(purchase);
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
                        try {
                            book = new TbBook();
                            book.setIsbn(dto.getIsbn().trim());
                            book.setBookName(dto.getBookName() != null ? dto.getBookName().trim() : "待完善-" + dto.getIsbn().trim());
                            book.setInfoStatus("0");
                            book.setInfoSource("3");
                            book.setStatus("0");
                            book.setCreateBy(SecurityUtils.getUsername());
                            book.setCreateTime(DateUtils.getNowDate());
                            tbBookMapper.insertTbBook(book);

                            TbInventory stock = new TbInventory();
                            stock.setBookId(book.getBookId());
                            stock.setStockNum(0);
                            stock.setWarningNum(10);
                            stock.setCreateTime(DateUtils.getNowDate());
                            try {
                                tbInventoryMapper.insertTbInventory(stock);
                            } catch (org.springframework.dao.DuplicateKeyException dke) {
                                log.info("【旧导入】库存记录并发冲突，跳过, bookId={}", book.getBookId());
                            }
                            log.info("【旧导入】自动创建教材, ISBN={}, bookId={}", dto.getIsbn(), book.getBookId());
                        } catch (org.springframework.dao.DuplicateKeyException dke) {
                            book = tbBookMapper.selectTbBookByIsbn(dto.getIsbn().trim());
                            if (book == null) {
                                rowError.append("教材创建失败，请重试；"); hasError = true;
                            }
                        }
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
                    errorInfo.put("errorMsg", rowError.toString().replaceAll("；$", ""));
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
