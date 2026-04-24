package com.ruoyi.textbook.service.impl;

import java.util.Date;
import java.util.List;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.DateUtils;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.common.utils.uuid.IdUtils;
import com.ruoyi.textbook.domain.*;
import com.ruoyi.textbook.mapper.*;
import com.ruoyi.textbook.service.IBookClaimFormService;
import com.ruoyi.textbook.service.ITbStockLogService;
import com.ruoyi.textbook.service.NoticeService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class BookClaimFormServiceImpl implements IBookClaimFormService {

    private static final Logger log = LoggerFactory.getLogger(BookClaimFormServiceImpl.class);

    @Autowired
    private BookClaimFormMapper bookClaimFormMapper;

    @Autowired
    private BookClaimFormDetailMapper bookClaimFormDetailMapper;

    @Autowired
    private TbInventoryMapper tbInventoryMapper;

    @Autowired
    private TbStockLogMapper tbStockLogMapper;

    @Autowired
    private ITbStockLogService stockLogService;

    @Autowired
    private BookNoticeMapper bookNoticeMapper;

    @Autowired
    private NoticeService noticeService;

    @Override
    public BookClaimForm selectBookClaimFormById(Long formId) {
        return bookClaimFormMapper.selectBookClaimFormById(formId);
    }

    @Override
    public List<BookClaimForm> selectBookClaimFormList(BookClaimForm bookClaimForm) {
        return bookClaimFormMapper.selectBookClaimFormList(bookClaimForm);
    }

    @Override
    public List<BookClaimForm> selectBookClaimFormsByNoticeId(Long noticeId) {
        return bookClaimFormMapper.selectBookClaimFormsByNoticeId(noticeId);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int insertBookClaimForm(BookClaimForm bookClaimForm) {
        String formNo = "CF" + DateUtils.dateTimeNow("yyyyMMddHHmmss") + IdUtils.fastSimpleUUID().substring(0, 6);
        bookClaimForm.setFormNo(formNo);
        bookClaimForm.setStatus("0");
        bookClaimForm.setIssuedQty(0);
        bookClaimForm.setCreateTime(DateUtils.getNowDate());
        int result = bookClaimFormMapper.insertBookClaimForm(bookClaimForm);

        if (result > 0 && bookClaimForm.getDetails() != null && !bookClaimForm.getDetails().isEmpty()) {
            for (BookClaimFormDetail detail : bookClaimForm.getDetails()) {
                detail.setFormId(bookClaimForm.getFormId());
                detail.setIssuedQty(0);
                bookClaimFormDetailMapper.insertBookClaimFormDetail(detail);
            }
        }

        return result;
    }

    @Override
    public int updateBookClaimForm(BookClaimForm bookClaimForm) {
        bookClaimForm.setUpdateTime(DateUtils.getNowDate());
        return bookClaimFormMapper.updateBookClaimForm(bookClaimForm);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int deleteBookClaimFormByIds(Long[] formIds) {
        for (Long formId : formIds) {
            bookClaimFormDetailMapper.deleteBookClaimFormDetailByFormId(formId);
        }
        return bookClaimFormMapper.deleteBookClaimFormByIds(formIds);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int confirmOutbound(Long formId, Long operatorId, String operatorName,
                              Integer issuedQty, String receiverName) {
        log.info("【班级领书出库】开始处理, formId={}, 发货数量={}, 领书人={}", formId, issuedQty, receiverName);

        BookClaimForm form = bookClaimFormMapper.selectBookClaimFormById(formId);
        if (form == null) {
            throw new ServiceException("领书单不存在");
        }
        if ("2".equals(form.getStatus())) {
            throw new ServiceException("该领书单已全部出库，不允许重复出库");
        }

        List<BookClaimFormDetail> details = bookClaimFormDetailMapper.selectBookClaimFormDetailListByFormId(formId);
        if (details == null || details.isEmpty()) {
            throw new ServiceException("领书单没有明细信息");
        }

        int totalPlannedQty = details.stream().mapToInt(BookClaimFormDetail::getPlannedQty).sum();
        int totalIssuedQtyParam = (issuedQty != null ? issuedQty : totalPlannedQty);

        if (totalIssuedQtyParam <= 0) {
            throw new ServiceException("实发数量必须大于0");
        }
        if (form.getIssuedQty() + totalIssuedQtyParam > totalPlannedQty) {
            throw new ServiceException("累计实发数量不能超过应发总数，已发：" + form.getIssuedQty() + "，本次：" + totalIssuedQtyParam + "，应发：" + totalPlannedQty);
        }

        int remainingToIssue = totalIssuedQtyParam;
        int totalRemaining = 0;
        for (BookClaimFormDetail d : details) {
            int rem = d.getPlannedQty() - d.getIssuedQty();
            if (rem > 0) totalRemaining += rem;
        }
        if (totalRemaining <= 0) {
            throw new ServiceException("所有教材明细已出库完成，无需再次出库");
        }

        int actualTotalIssued = 0;
        int originalTotalRemaining = totalRemaining;

        for (int i = 0; i < details.size(); i++) {
            BookClaimFormDetail detail = details.get(i);
            TbInventory inventory = tbInventoryMapper.selectTbInventoryByBookId(detail.getTextbookId());
            if (inventory == null) {
                throw new ServiceException("教材《" + detail.getBookName() + "》库存记录不存在");
            }

            int remainingForThisDetail = detail.getPlannedQty() - detail.getIssuedQty();
            if (remainingForThisDetail <= 0) {
                continue;
            }

            int actualIssueQty;
            if (i == details.size() - 1 || originalTotalRemaining == remainingForThisDetail) {
                actualIssueQty = Math.min(remainingToIssue, remainingForThisDetail);
            } else {
                double proportion = (double) remainingForThisDetail / originalTotalRemaining;
                actualIssueQty = (int) Math.round(remainingToIssue * proportion);
                actualIssueQty = Math.min(actualIssueQty, remainingForThisDetail);
                actualIssueQty = Math.min(actualIssueQty, remainingToIssue);
            }

            if (actualIssueQty <= 0) {
                continue;
            }

            int currentStock = inventory.getStockNum();
            if (currentStock < actualIssueQty) {
                throw new ServiceException("教材《" + detail.getBookName() + "》库存不足，当前库存：" + currentStock + "，需求：" + actualIssueQty);
            }

            int currentVersion = inventory.getVersion() != null ? inventory.getVersion() : 0;
            int rowsAffected = tbInventoryMapper.deductStockWithVersion(
                    detail.getTextbookId(),
                    actualIssueQty,
                    currentVersion
            );
            if (rowsAffected <= 0) {
                throw new ServiceException("并发冲突：教材《" + detail.getBookName() + "》库存已被其他操作修改，请刷新后重试");
            }

            detail.setIssuedQty(detail.getIssuedQty() + actualIssueQty);
            bookClaimFormDetailMapper.updateBookClaimFormDetail(detail);

            TbStockLog stockLog = new TbStockLog();
            stockLog.setBookId(detail.getTextbookId());
            stockLog.setBizType("2");
            stockLog.setChangeNum(-actualIssueQty);
            stockLog.setBeforeStock(currentStock);
            int actualAfterStock = tbInventoryMapper.selectStockNumByBookId(detail.getTextbookId());
            stockLog.setAfterStock(actualAfterStock);
            stockLog.setOperatorId(operatorId);
            stockLog.setOperatorName(operatorName);
            stockLog.setRefBizType("CLAIM_FORM");
            stockLog.setRefBizId(formId);
            stockLog.setRemark("班级领书出库，领书单号：" + form.getFormNo() + "，班级：" + form.getClassName());
            stockLogService.insert(stockLog);

            checkStockWarning(detail.getTextbookId(), detail.getBookName());

            remainingToIssue -= actualIssueQty;
            actualTotalIssued += actualIssueQty;
        }

        int newTotalIssued = form.getIssuedQty() + actualTotalIssued;
        String newStatus;
        if (newTotalIssued >= form.getPlannedQty()) {
            newStatus = "2";
        } else {
            newStatus = "1";
        }

        form.setIssuedQty(newTotalIssued);
        form.setReceiverName(receiverName);
        form.setIssueTime(new Date());
        form.setStatus(newStatus);
        form.setUpdateBy(operatorName);
        form.setUpdateTime(DateUtils.getNowDate());
        bookClaimFormMapper.updateBookClaimForm(form);

        updateNoticeProgress(form.getNoticeId());

        try {
            String bookNames = details.stream()
                    .map(BookClaimFormDetail::getBookName)
                    .reduce((a, b) -> a + "、" + b)
                    .orElse("");
            noticeService.sendClaimFormOutboundNotice(formId, form.getClassName(), bookNames, totalIssuedQtyParam);
        } catch (Exception e) {
            log.warn("【班级领书出库】发送出库通知失败: {}", e.getMessage());
        }

        log.info("【班级领书出库】完成! 领书单号={}, 班级={}, 实发数量={}, 状态={}",
                form.getFormNo(), form.getClassName(), totalIssuedQtyParam, newStatus);
        return 1;
    }

    private void updateNoticeProgress(Long noticeId) {
        if (noticeId == null) return;

        List<BookClaimForm> forms = bookClaimFormMapper.selectBookClaimFormsByNoticeId(noticeId);
        int totalForms = forms.size();
        long completedForms = forms.stream()
                .filter(f -> "2".equals(f.getStatus()))
                .count();

        bookNoticeMapper.updateIssuedClasses(noticeId, (int) completedForms);
    }

    @Override
    public List<BookClaimFormDetail> selectDetailsByFormId(Long formId) {
        return bookClaimFormDetailMapper.selectBookClaimFormDetailListByFormId(formId);
    }

    private void checkStockWarning(Long bookId, String bookName) {
        try {
            TbInventory inv = tbInventoryMapper.selectTbInventoryByBookId(bookId);
            if (inv != null && inv.getWarningNum() != null && inv.getStockNum() <= inv.getWarningNum()) {
                noticeService.sendStockWarningNotice(bookId, bookName, inv.getStockNum(), inv.getWarningNum());
                log.info("【库存预警】教材《{}》库存{}本低于预警阈值{}本，已发送通知", bookName, inv.getStockNum(), inv.getWarningNum());
            }
        } catch (Exception e) {
            log.warn("【库存预警】检查库存预警失败: {}", e.getMessage());
        }
    }
}
