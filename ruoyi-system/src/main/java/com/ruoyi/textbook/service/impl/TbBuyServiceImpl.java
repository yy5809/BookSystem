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
import com.ruoyi.textbook.domain.dto.TbPurchaseImportDTO;
import com.ruoyi.textbook.domain.dto.StockOperationResult;
import com.ruoyi.textbook.enums.NoticeBizTypeEnum;
import com.ruoyi.textbook.mapper.*;
import com.ruoyi.textbook.service.ITbBuyService;
import com.ruoyi.textbook.service.IStockOperationService;
import com.ruoyi.textbook.service.ITbStockLogService;
import com.ruoyi.textbook.service.NoticeService;
import com.ruoyi.textbook.enums.AuditStatusEnum;
import com.ruoyi.textbook.enums.ReceiveStatusEnum;
import com.ruoyi.textbook.enums.PurchaseStatusEnum;
import com.ruoyi.textbook.enums.ShortageStatusEnum;
import com.ruoyi.textbook.enums.ShortageSourceEnum;
import com.ruoyi.textbook.enums.PersonalApplyStatusEnum;
import com.ruoyi.textbook.enums.DetailVerifyStatusEnum;
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
    private com.ruoyi.textbook.mapper.BookPersonalApplyMapper bookPersonalApplyMapper;

    @Autowired
    private com.ruoyi.textbook.mapper.TextbookClassBindingMapper textbookClassBindingMapper;

    @Autowired
    private ITbStockLogService tbStockLogService;

    @Autowired
    private IStockOperationService stockOperationService;

    @Autowired
    private PurchaseStateService purchaseStateService;

    @Autowired
    private com.ruoyi.common.core.redis.RedisCache redisCache;

    @Override
    public TbPurchase getById(Long buyId) {
        TbPurchase purchase = tbPurchaseMapper.selectTbPurchaseById(buyId);
        if (purchase != null) {
            purchase.setDetails(tbPurchaseMapper.selectTbPurchaseDetailListByPurchaseId(buyId));
            if (StringUtils.isEmpty(purchase.getDeptName()) && purchase.getUserId() != null) {
                SysUser user = sysUserMapper.selectUserById(purchase.getUserId());
                if (user != null && user.getDept() != null) {
                    purchase.setDeptName(user.getDept().getDeptName());
                }
            }
        }
        return purchase;
    }

    @Override
    public List<TbPurchase> list(TbPurchase tbPurchase) {
        List<TbPurchase> list = tbPurchaseMapper.selectTbPurchaseList(tbPurchase);
        for (TbPurchase p : list) {
            if (p.getReceiveTime() == null && "5".equals(p.getPurchaseStatus()) && p.getVerifyTime() != null) {
                p.setReceiveTime(p.getVerifyTime());
            }
            if (StringUtils.isEmpty(p.getDeptName()) && p.getUserId() != null) {
                SysUser user = sysUserMapper.selectUserById(p.getUserId());
                if (user != null && user.getDept() != null) {
                    p.setDeptName(user.getDept().getDeptName());
                }
            }
        }
        return list;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int submit(TbPurchase buy) {
        String purchaseNo = PurchaseNoGenerator.generateWithUUID();
        buy.setPurchaseNo(purchaseNo);
        purchaseStateService.initAsApprovedWithWaitPurchase(buy);
        buy.setSubmitTime(LocalDateTime.now());
        buy.setCreateTime(DateUtils.getNowDate());
        if (buy.getDetails() != null) {
            int totalQty = buy.getDetails().stream()
                .mapToInt(d -> d.getQuantity() != null ? d.getQuantity() : 0)
                .sum();
            buy.setBuyNum(totalQty);
        }
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
            noticeService.sendOrderApproveNotice(
                buy.getUserId(),
                details.stream().map(TbPurchaseDetail::getBookName).collect(Collectors.joining("、")),
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
                if (ShortageStatusEnum.IN_PURCHASE.getCode().equals(shortage.getHandleStatus())) {
                    shortage.setHandleStatus(ShortageStatusEnum.PARTIAL.getCode());
                    shortage.setUpdateTime(DateUtils.getNowDate());
                    tbShortageMapper.updateTbShortage(shortage);
                }
            }
        }

        return result;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int submitVerification(Long buyId) {
        TbPurchase buy = purchaseStateService.requirePurchase(buyId);
        if (!PurchaseStatusEnum.ARRIVED.getCode().equals(buy.getPurchaseStatus())) {
            throw new ServiceException("只有已到货的采购单才能提交核准，当前状态：" + PurchaseStatusEnum.getDescByCode(buy.getPurchaseStatus()));
        }
        List<TbPurchaseDetail> details = tbPurchaseMapper.selectTbPurchaseDetailListByPurchaseId(buyId);
        StringBuilder issues = new StringBuilder();
        for (TbPurchaseDetail d : details) {
            if (TextbookConstants.SUPPLIER_FEEDBACK_SHORTAGE.equals(d.getSupplierFeedback())) {
                if (issues.length() > 0) issues.append("、");
                issues.append("《").append(d.getBookName()).append("》缺货");
            } else if (TextbookConstants.SUPPLIER_FEEDBACK_INFO_ERROR.equals(d.getSupplierFeedback())) {
                if (issues.length() > 0) issues.append("、");
                issues.append("《").append(d.getBookName()).append("》信息有误");
            }
        }
        if (issues.length() > 0) {
            log.warn("【提交核准】采购单{}存在供应商标记异常明细：{}，已提交核准但异常明细将跳过入库", buy.getPurchaseNo(), issues);
        }
        TbPurchase verifying = purchaseStateService.transitionToVerifying(buyId);
        return tbPurchaseMapper.updateTbPurchase(verifying);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int confirmVerify(Long buyId, String verifyResult, String verifyRemark, String qualityCheckResult, Integer actualQtyReceived, String invoiceNo) {
        TbPurchase buy = purchaseStateService.requirePurchase(buyId);
        String currentStatus = buy.getPurchaseStatus();
        if (!PurchaseStatusEnum.VERIFYING.getCode().equals(currentStatus)) {
            throw new ServiceException("只有核准中状态的采购单才能进行核准操作，当前状态：" + PurchaseStatusEnum.getDescByCode(currentStatus));
        }
        if ("pass".equals(verifyResult) || "partial".equals(verifyResult)) {
            List<TbPurchaseDetail> details = tbPurchaseMapper.selectTbPurchaseDetailListByPurchaseId(buyId);
            StringBuilder issues = new StringBuilder();
            boolean anyDetailProcessed = false;
            for (TbPurchaseDetail d : details) {
                if (TextbookConstants.SUPPLIER_FEEDBACK_SHORTAGE.equals(d.getSupplierFeedback())) {
                    if (issues.length() > 0) issues.append("、");
                    issues.append("《").append(d.getBookName()).append("》缺货");
                } else if (TextbookConstants.SUPPLIER_FEEDBACK_INFO_ERROR.equals(d.getSupplierFeedback())) {
                    if (issues.length() > 0) issues.append("、");
                    issues.append("《").append(d.getBookName()).append("》信息有误");
                }
                if (d.getVerifyStatus() != null && !"0".equals(d.getVerifyStatus())) {
                    anyDetailProcessed = true;
                }
            }
            if (anyDetailProcessed) {
                throw new ServiceException("部分教材明细已被单独核准处理，整单核准不可用。请通过明细逐条操作完成剩余流程。");
            }
            if (issues.length() > 0) {
                log.warn("【核准确认】采购单{}存在供应商标记异常明细：{}，核准记录已保存但异常明细将跳过入库", buy.getPurchaseNo(), issues);
            }
            for (TbPurchaseDetail d : details) {
                if ("0".equals(d.getVerifyStatus())) {
                    d.setVerifyStatus("1");
                    tbPurchaseMapper.updateTbPurchaseDetail(d);
                }
            }
        }
        Long userId = SecurityUtils.getUserId();
        buy.setVerifyUserId(userId);
        buy.setVerifyTime(java.time.LocalDateTime.now());
        buy.setVerifyResult(verifyResult);
        buy.setVerifyRemark(verifyRemark);
        buy.setQualityCheckResult(qualityCheckResult);
        buy.setActualQtyReceived(actualQtyReceived);
        buy.setInvoiceNo(invoiceNo);
        return tbPurchaseMapper.updateTbPurchase(buy);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int returnToArrived(Long buyId, String remark) {
        TbPurchase buy = purchaseStateService.requirePurchase(buyId);
        String currentStatus = buy.getPurchaseStatus();
        if (!PurchaseStatusEnum.VERIFYING.getCode().equals(currentStatus)) {
            throw new ServiceException("只有核准中状态的采购单才能退回，当前状态：" + PurchaseStatusEnum.getDescByCode(currentStatus));
        }
        buy.setPurchaseStatus(PurchaseStatusEnum.ARRIVED.getCode());
        buy.setVerifyRemark(remark);
        return tbPurchaseMapper.updateTbPurchase(buy);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int verifyDetail(Long detailId, String verifyStatus, String verifyRemark) {
        TbPurchaseDetail detail = tbPurchaseMapper.getPurchaseDetailById(detailId);
        if (detail == null) throw new ServiceException("采购明细不存在");
        assertDetailInVerificationPhase(detail);
        if (!"0".equals(detail.getVerifyStatus())) throw new ServiceException("该明细已处理，无法重复核准");
        detail.setVerifyStatus(verifyStatus);
        if (verifyRemark != null) detail.setSupplierRemark(verifyRemark);
        return tbPurchaseMapper.updateTbPurchaseDetail(detail);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int receiveDetail(Long detailId, Integer receivedQty) {
        TbPurchaseDetail detail = tbPurchaseMapper.getPurchaseDetailById(detailId);
        if (detail == null) throw new ServiceException("采购明细不存在");
        assertDetailInVerificationPhase(detail);
        if (!"1".equals(detail.getVerifyStatus())) throw new ServiceException("仅核准通过的明细才能收货");
        detail.setVerifyStatus("2");
        detail.setReceivedQty(receivedQty != null ? receivedQty : detail.getQuantity());
        return tbPurchaseMapper.updateTbPurchaseDetail(detail);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int returnDetail(Long detailId, Integer returnQty, String returnReason) {
        TbPurchaseDetail detail = tbPurchaseMapper.getPurchaseDetailById(detailId);
        if (detail == null) throw new ServiceException("采购明细不存在");
        assertDetailInVerificationPhase(detail);
        if (!"1".equals(detail.getVerifyStatus())) throw new ServiceException("仅核准通过的明细才能退货");
        detail.setVerifyStatus("3");
        detail.setReturnQty(returnQty != null ? returnQty : detail.getQuantity());
        detail.setReturnReason(returnReason);
        return tbPurchaseMapper.updateTbPurchaseDetail(detail);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int correctDetailInfo(Long detailId, String infoCorrection) {
        TbPurchaseDetail detail = tbPurchaseMapper.getPurchaseDetailById(detailId);
        if (detail == null) throw new ServiceException("采购明细不存在");
        assertDetailInVerificationPhase(detail);
        if (!"0".equals(detail.getVerifyStatus())) throw new ServiceException("该明细已处理，无法修正信息");
        detail.setVerifyStatus("4");
        detail.setInfoCorrection(infoCorrection);
        return tbPurchaseMapper.updateTbPurchaseDetail(detail);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int registerShortageDetail(Long detailId, String remark) {
        TbPurchaseDetail detail = tbPurchaseMapper.getPurchaseDetailById(detailId);
        if (detail == null) throw new ServiceException("采购明细不存在");
        assertDetailInVerificationPhase(detail);
        if (!"0".equals(detail.getVerifyStatus())) throw new ServiceException("该明细已处理，无法登记缺货");
        detail.setVerifyStatus("5");
        detail.setSupplierRemark(remark);
        return tbPurchaseMapper.updateTbPurchaseDetail(detail);
    }

    private void assertDetailInVerificationPhase(TbPurchaseDetail detail) {
        TbPurchase purchase = tbPurchaseMapper.selectTbPurchaseById(detail.getPurchaseId());
        if (purchase == null) throw new ServiceException("关联采购单不存在");
        String ps = purchase.getPurchaseStatus();
        if (!PurchaseStatusEnum.ARRIVED.getCode().equals(ps)
                && !PurchaseStatusEnum.VERIFYING.getCode().equals(ps)) {
            throw new ServiceException("采购单当前状态为「" + PurchaseStatusEnum.getDescByCode(ps)
                    + "」，不允许对明细执行核准操作。仅已到货或核准中状态可操作。");
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int batchVerifyDetails(List<Long> detailIds, String verifyStatus) {
        int count = 0;
        for (Long detailId : detailIds) {
            TbPurchaseDetail detail = tbPurchaseMapper.getPurchaseDetailById(detailId);
            if (detail == null) continue;
            if (!"0".equals(detail.getVerifyStatus())) continue;
            detail.setVerifyStatus(verifyStatus);
            tbPurchaseMapper.updateTbPurchaseDetail(detail);
            count++;
        }
        return count;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int directInboundDetail(Long detailId) {
        TbPurchaseDetail detail = tbPurchaseMapper.getPurchaseDetailById(detailId);
        if (detail == null) throw new ServiceException("采购明细不存在");
        assertDetailInVerificationPhase(detail);
        if (!"1".equals(detail.getVerifyStatus())) throw new ServiceException("仅核准通过的明细才能直接入库");
        TbPurchase purchase = tbPurchaseMapper.selectTbPurchaseById(detail.getPurchaseId());
        Long currentUserId = SecurityUtils.getUserId();
        SysUser currentUser = sysUserMapper.selectUserById(currentUserId);
        String operatorName = currentUser != null ? currentUser.getNickName() : SecurityUtils.getUsername();
        int qty = detail.getQuantity() != null ? detail.getQuantity() : 0;

        StockOperationResult stockResult = stockOperationService.addStock(
                detail.getBookId(), qty, currentUserId, operatorName,
                "PURCHASE_INBOUND", purchase.getPurchaseNo(),
                "单条核准入库，单号：" + purchase.getPurchaseNo());
        if (!stockResult.isSuccess()) {
            throw new ServiceException("教材「" + detail.getBookName() + "」入库失败：" + stockResult.getErrorMessage());
        }

        if (StringUtils.isNotEmpty(detail.getCollege()) && StringUtils.isNotEmpty(detail.getMajor())) {
            String gradeYearPrefix = toGradeYearPrefix(detail.getGrade());
            com.ruoyi.textbook.domain.TextbookClassBinding binding =
                    new com.ruoyi.textbook.domain.TextbookClassBinding();
            binding.setSemester(generateSemester());
            binding.setCollege(detail.getCollege());
            binding.setMajor(detail.getMajor());
            binding.setClassName(gradeYearPrefix != null ? gradeYearPrefix + detail.getMajor() : detail.getMajor());
            binding.setBookId(detail.getBookId());
            binding.setIsbn(detail.getIsbn());
            binding.setBookName(detail.getBookName());
            binding.setPlannedQty(qty);
            binding.setSource(TextbookConstants.BINDING_SOURCE_PURCHASE);
            binding.setPendingId(detail.getPurchaseId());
            binding.setCreateBy(operatorName);
            textbookClassBindingMapper.upsertBinding(binding);
        }

        noticeService.sendInboundNotice(detail.getBookId(), detail.getBookName(), detail.getPurchaseId());

        detail.setVerifyStatus("6");
        detail.setReceivedQty(qty);
        tbPurchaseMapper.updateTbPurchaseDetail(detail);

        List<TbPurchaseDetail> allDetails = tbPurchaseMapper.selectTbPurchaseDetailListByPurchaseId(detail.getPurchaseId());
        boolean allDone = true;
        for (TbPurchaseDetail d : allDetails) {
            if (TextbookConstants.SUPPLIER_FEEDBACK_SHORTAGE.equals(d.getSupplierFeedback())
                    || TextbookConstants.SUPPLIER_FEEDBACK_INFO_ERROR.equals(d.getSupplierFeedback())) {
                continue;
            }
            if (!"6".equals(d.getVerifyStatus())) { allDone = false; break; }
        }
        if (allDone) {
            TbPurchase inboundPurchase = purchaseStateService.transitionToInbound(detail.getPurchaseId());
            tbPurchaseMapper.updateTbPurchase(inboundPurchase);
            log.info("【单条入库】所有正常明细已入库，采购单{}自动转为已入库", purchase.getPurchaseNo());
        } else {
            log.info("【单条入库】明细「{}」已入库，采购单{}尚有未处理明细，保持核准中状态", detail.getBookName(), purchase.getPurchaseNo());
        }

        return 1;
    }

    private final String toGradeYearPrefix(String gradeLevel) {
        if (gradeLevel == null) return null;
        String normalized = com.ruoyi.textbook.util.GradeConverter.normalizeGradeLevel(gradeLevel, getCurrentAcademicYear());
        if (normalized == null) return null;
        Integer enrollmentYear = com.ruoyi.textbook.util.GradeConverter.parseEnrollmentYear(normalized);
        if (enrollmentYear != null && enrollmentYear > getCurrentAcademicYear()) return null;
        return normalized;
    }

    private final String generateSemester() {
        java.time.LocalDate now = java.time.LocalDate.now();
        int year = now.getYear();
        int month = now.getMonthValue();
        if (month >= 9) return year + "-" + (year + 1) + "-1";
        else if (month >= 2) return (year - 1) + "-" + year + "-2";
        else return (year - 1) + "-" + year + "-1";
    }

    private int getCurrentAcademicYear() {
        int dateBased = com.ruoyi.textbook.util.GradeConverter.currentAcademicYear();
        try {
            String configValue = redisCache.getCacheObject("sys_config:textbook.current_academic_year");
            if (configValue != null && !configValue.isEmpty()) {
                int configYear = Integer.parseInt(configValue);
                if (configYear <= dateBased) return configYear;
                log.warn("Redis学年配置={}超过当前日期计算={}, 降级使用日期值", configYear, dateBased);
            }
        } catch (Exception e) {
            log.warn("读取当前学年配置失败", e);
        }
        return dateBased;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int confirmInbound(Long buyId) {
        TbPurchase buy = purchaseStateService.requirePurchase(buyId);

        String currentPurchaseStatus = buy.getPurchaseStatus();
        if (!PurchaseStatusEnum.VERIFYING.getCode().equals(currentPurchaseStatus)) {
            throw new ServiceException("只有核准通过的采购单才能验收入库，当前状态：" + PurchaseStatusEnum.getDescByCode(currentPurchaseStatus) + "。请先执行核准验收操作。");
        }
        if (buy.getVerifyResult() == null) {
            throw new ServiceException("该采购单尚未完成核准验收，请先执行「核准验收」操作后再确认入库。");
        }

        List<TbPurchaseDetail> details = tbPurchaseMapper.selectTbPurchaseDetailListByPurchaseId(buyId);
        Long currentUserId = SecurityUtils.getUserId();
        SysUser currentUser = sysUserMapper.selectUserById(currentUserId);
        String operatorName = currentUser != null ? currentUser.getNickName() : SecurityUtils.getUsername();
        int inboundCount = 0, skipCount = 0;
        for (TbPurchaseDetail detail : details) {
            int qty = detail.getQuantity() != null ? detail.getQuantity() : 0;

            if (TextbookConstants.SUPPLIER_FEEDBACK_SHORTAGE.equals(detail.getSupplierFeedback())
                    || TextbookConstants.SUPPLIER_FEEDBACK_INFO_ERROR.equals(detail.getSupplierFeedback())) {
                skipCount++;
                log.info("【入库】跳过明细 detailId={}, 书名={}, 供应商反馈={}", detail.getDetailId(), detail.getBookName(), detail.getSupplierFeedback());
                continue;
            }

            StockOperationResult stockResult = stockOperationService.addStock(
                    detail.getBookId(),
                    qty,
                    currentUserId,
                    operatorName,
                    "PURCHASE_INBOUND",
                    buy.getPurchaseNo(),
                    "采购验收入库，单号：" + buy.getPurchaseNo()
            );
            if (!stockResult.isSuccess()) {
                throw new ServiceException("教材「" + detail.getBookName() + "」入库失败：" + stockResult.getErrorMessage());
            }

            if (StringUtils.isNotEmpty(detail.getCollege()) && StringUtils.isNotEmpty(detail.getMajor())) {
                String gradeYearPrefix = toGradeYearPrefix(detail.getGrade());
                com.ruoyi.textbook.domain.TextbookClassBinding binding =
                        new com.ruoyi.textbook.domain.TextbookClassBinding();
                binding.setSemester(generateSemester());
                binding.setCollege(detail.getCollege());
                binding.setMajor(detail.getMajor());
                binding.setClassName(gradeYearPrefix != null ? gradeYearPrefix + detail.getMajor() : detail.getMajor());
                binding.setBookId(detail.getBookId());
                binding.setIsbn(detail.getIsbn());
                binding.setBookName(detail.getBookName());
                binding.setPlannedQty(qty);
                binding.setSource(TextbookConstants.BINDING_SOURCE_PURCHASE);
                binding.setPendingId(buyId);
                binding.setCreateBy(operatorName);
                textbookClassBindingMapper.upsertBinding(binding);
            }

            noticeService.sendInboundNotice(
                    detail.getBookId(), detail.getBookName(), buyId);
            inboundCount++;
        }

        if (skipCount > 0) {
            log.info("【入库完成】共{}条明细，实际入库{}条，跳过{}条（供应商标记缺货/信息有误）",
                    details.size(), inboundCount, skipCount);
        }

        if (inboundCount == 0) {
            throw new ServiceException("所有教材明细均被供应商标记为缺货或信息有误，无法入库，请联系供应商核实");
        }

        TbPurchase inboundPurchase = purchaseStateService.transitionToInbound(buyId);
        if (buy.getReceiveTime() == null) {
            inboundPurchase.setReceiveTime(LocalDateTime.now());
        }
        int result = tbPurchaseMapper.updateTbPurchase(inboundPurchase);

        List<TbShortage> relatedShortages = tbShortageMapper.selectTbShortageListByPurchaseId(buyId);
        if (relatedShortages != null) {
            for (TbShortage shortage : relatedShortages) {
                if (ShortageStatusEnum.IN_PURCHASE.getCode().equals(shortage.getHandleStatus())
                        || ShortageStatusEnum.PARTIAL.getCode().equals(shortage.getHandleStatus())) {
                    shortage.setHandleStatus(ShortageStatusEnum.COMPLETED.getCode());
                    shortage.setHandleTime(DateUtils.getNowDate());
                    shortage.setUpdateTime(DateUtils.getNowDate());
                    shortage.setRemark("已通过采购单" + buy.getPurchaseNo() + "入库补齐");
                    tbShortageMapper.updateTbShortage(shortage);

                    boolean personalApplyRestored = false;
                    if ((ShortageSourceEnum.CLAIM_OUTBOUND.getCode().equals(shortage.getSource())
                            || ShortageSourceEnum.PERSONAL_APPLY.getCode().equals(shortage.getSource()))
                            && shortage.getSourceId() != null) {
                        com.ruoyi.textbook.domain.BookPersonalApply personalApply =
                                bookPersonalApplyMapper.selectBookPersonalApplyById(shortage.getSourceId());
                        if (personalApply != null && PersonalApplyStatusEnum.REJECTED.getCode().equals(personalApply.getStatus())) {
                            com.ruoyi.textbook.domain.BookPersonalApply updateApply =
                                    new com.ruoyi.textbook.domain.BookPersonalApply();
                            updateApply.setApplyId(personalApply.getApplyId());
                            updateApply.setStatus(PersonalApplyStatusEnum.APPROVED.getCode());
                            updateApply.setAuditOpinion("缺书已补货入库，恢复为可出库状态");
                            updateApply.setUpdateBy(operatorName);
                            updateApply.setUpdateTime(DateUtils.getNowDate());
                            bookPersonalApplyMapper.updateBookPersonalApply(updateApply);
                            personalApplyRestored = true;

                            if (personalApply.getTeacherId() != null) {
                                String teacherName = personalApply.getTeacherName() != null ? personalApply.getTeacherName() : "教师";
                                noticeService.sendNoticeToUser(
                                        personalApply.getTeacherId(),
                                        "缺书补货到库通知",
                                        teacherName + "，您申请的《" + personalApply.getBookName()  + "》已补货入库，管理员将尽快为您办理出库。",
                                        NoticeBizTypeEnum.LACK.getCode(),
                                        personalApply.getApplyId());
                                log.info("【入库完成】已通知教师领书, teacherId={}, applyId={}", personalApply.getTeacherId(), personalApply.getApplyId());
                            }
                        }
                    }

                    if (!personalApplyRestored && shortage.getRegisterId() != null) {
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

        Long currentUserId = SecurityUtils.getUserId();
        SysUser currentUser = sysUserMapper.selectUserById(currentUserId);
        String operatorName = currentUser != null ? currentUser.getNickName() : SecurityUtils.getUsername();

        List<TbPurchaseDetail> details = tbPurchaseMapper.selectTbPurchaseDetailListByPurchaseId(buyId);
        for (TbPurchaseDetail detail : details) {
            StockOperationResult stockResult = stockOperationService.deductStock(
                    detail.getBookId(),
                    detail.getQuantity(),
                    currentUserId,
                    operatorName,
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
            out.setOperatorId(currentUserId);
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
                    if (ShortageStatusEnum.IN_PURCHASE.getCode().equals(shortage.getHandleStatus())) {
                        shortage.setHandleStatus(ShortageStatusEnum.PENDING.getCode());
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
            return Collections.emptyList();
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
        long totalBooks = 0;

        List<Long> orderIds = allOrders.stream().map(TbPurchase::getBuyId).collect(Collectors.toList());
        List<TbPurchaseDetail> allDetails = batchSelectDetailsByPurchaseIds(orderIds);

        for (TbPurchase order : allOrders) {
            String status = order.getStatus();
            if (AuditStatusEnum.PENDING.getCode().equals(status)) pendingCount++;
            else if (AuditStatusEnum.APPROVED.getCode().equals(status)) approvedCount++;
            else if (TextbookConstants.STATUS_RECEIVED.equals(status)) receivedCount++;
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

            if (!detailList.isEmpty()) {
                tbPurchaseMapper.insertTbPurchaseDetailBatch(detailList);
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

    private final SysDictData validateDictValue(String dictType, String dictLabel) {
        if (StringUtils.isEmpty(dictType) || StringUtils.isEmpty(dictLabel)) return null;
        SysDictData query = new SysDictData();
        query.setDictType(dictType);
        query.setDictLabel(dictLabel);
        query.setStatus("0");
        List<SysDictData> dictList = dictDataMapper.selectDictDataList(query);
        return (dictList != null && !dictList.isEmpty()) ? dictList.get(0) : null;
    }

    private final String calculateFileMD5(MultipartFile file) throws Exception {
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

    private final String getUserTypeByRoles(SysUser user) {
        if (user.getRoles() != null) {
            for (SysRole role : user.getRoles()) {
                if ("teacher".equals(role.getRoleKey())) return "1";
                if ("warehouseman".equals(role.getRoleKey())) return "2";
            }
        }
        return "1";
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int adjustDetail(Long buyId, List<TbPurchaseDetail> details) {
        TbPurchase purchase = tbPurchaseMapper.selectTbPurchaseById(buyId);
        if (purchase == null) throw new ServiceException("采购单不存在");
        String ps = purchase.getPurchaseStatus();
        if (PurchaseStatusEnum.ARRIVED.getCode().equals(ps) || PurchaseStatusEnum.INBOUND.getCode().equals(ps)) {
            throw new ServiceException("已到货或已入库的采购单不允许调整明细");
        }
        tbPurchaseMapper.deleteTbPurchaseDetailByPurchaseId(buyId);
        if (details != null && !details.isEmpty()) {
            for (TbPurchaseDetail d : details) {
                d.setPurchaseId(buyId);
                tbPurchaseMapper.insertTbPurchaseDetail(d);
            }
        } else {
            log.warn("【采购单调整明细】明细列表为空，已清空采购单{}的所有明细", buyId);
        }
        log.info("【采购单调整明细】buyId={}, 明细数={}", buyId, details != null ? details.size() : 0);
        return 1;
    }

    @Override
    public int archivePurchase(Long buyId) {
        TbPurchase purchase = tbPurchaseMapper.selectTbPurchaseById(buyId);
        if (purchase == null) throw new ServiceException("采购单不存在");
        purchase.setArchived("1");
        return tbPurchaseMapper.updateTbPurchase(purchase);
    }

    @Override
    public List<TbPurchase> listArchived(TbPurchase query) {
        if (query == null) query = new TbPurchase();
        query.setArchived("1");
        List<TbPurchase> list = tbPurchaseMapper.selectTbPurchaseList(query);
        for (TbPurchase p : list) {
            if (p.getReceiveTime() == null && "5".equals(p.getPurchaseStatus()) && p.getVerifyTime() != null) {
                p.setReceiveTime(p.getVerifyTime());
            }
            if (StringUtils.isEmpty(p.getDeptName()) && p.getUserId() != null) {
                SysUser user = sysUserMapper.selectUserById(p.getUserId());
                if (user != null && user.getDept() != null) {
                    p.setDeptName(user.getDept().getDeptName());
                }
            }
        }
        return list;
    }
}
