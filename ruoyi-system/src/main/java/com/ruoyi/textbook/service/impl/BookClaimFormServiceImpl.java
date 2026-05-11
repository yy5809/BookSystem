package com.ruoyi.textbook.service.impl;

import java.util.Date;
import java.util.List;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.DateUtils;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.common.utils.uuid.IdUtils;
import com.ruoyi.textbook.domain.*;
import com.ruoyi.textbook.domain.dto.StockOperationResult;
import com.ruoyi.textbook.mapper.*;
import com.ruoyi.textbook.service.IBookClaimFormService;
import com.ruoyi.textbook.service.IStockOperationService;
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
    private IStockOperationService stockOperationService;

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

            StockOperationResult result = stockOperationService.deductStock(
                    detail.getTextbookId(),
                    actualIssueQty,
                    operatorId,
                    operatorName,
                    "CLAIM_FORM",
                    String.valueOf(formId),
                    "班级领书出库，领书单号：" + form.getFormNo() + "，班级：" + form.getClassName());
            if (!result.isSuccess()) {
                throw new ServiceException("教材《" + detail.getBookName() + "》" + result.getErrorMessage());
            }

            detail.setIssuedQty(detail.getIssuedQty() + actualIssueQty);
            bookClaimFormDetailMapper.updateBookClaimFormDetail(detail);

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

        String bookNames = details.stream()
                .map(BookClaimFormDetail::getBookName)
                .reduce((a, b) -> a + "、" + b)
                .orElse("");
        noticeService.sendClaimFormOutboundNotice(formId, form.getClassName(), bookNames, totalIssuedQtyParam);

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

}
