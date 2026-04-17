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

        List<BookClaimFormDetail> details = bookClaimFormDetailMapper.selectBookClaimFormDetailListByFormId(formId);
        if (details == null || details.isEmpty()) {
            throw new ServiceException("领书单没有明细信息");
        }

        for (BookClaimFormDetail detail : details) {
            TbInventory inventory = tbInventoryMapper.selectTbInventoryByBookId(detail.getTextbookId());
            if (inventory == null) {
                throw new ServiceException("教材《" + detail.getBookName() + "》库存记录不存在");
            }

            Integer currentStock = inventory.getStockNum();
            Integer actualIssueQty = Math.min(detail.getPlannedQty(), issuedQty != null ? issuedQty : detail.getPlannedQty());

            if (currentStock < actualIssueQty) {
                throw new ServiceException("教材《" + detail.getBookName() + "》库存不足，当前库存：" + currentStock + "，需求：" + actualIssueQty);
            }

            int rowsAffected = tbInventoryMapper.updateInventoryQuantityWithCheck(
                    detail.getTextbookId(),
                    currentStock,
                    -actualIssueQty
            );
            if (rowsAffected <= 0) {
                throw new ServiceException("并发冲突：教材《" + detail.getBookName() + "》库存已被其他操作修改，请刷新后重试");
            }

            detail.setIssuedQty(actualIssueQty);
            bookClaimFormDetailMapper.updateBookClaimFormDetail(detail);

            TbStockLog stockLog = new TbStockLog();
            stockLog.setBookId(detail.getTextbookId());
            stockLog.setBizType("2");
            stockLog.setChangeNum(-actualIssueQty);
            stockLog.setBeforeStock(currentStock);
            stockLog.setAfterStock(currentStock - actualIssueQty);
            stockLog.setOperatorId(operatorId);
            stockLog.setOperatorName(operatorName);
            stockLog.setRefBizType("CLAIM_FORM");
            stockLog.setRefBizId(formId);
            stockLog.setRemark("班级领书出库，领书单号：" + form.getFormNo() + "，班级：" + form.getClassName());
            stockLogService.insert(stockLog);
        }

        Integer totalIssued = form.getIssuedQty() + (issuedQty != null ? issuedQty : 0);
        String newStatus;
        if (totalIssued >= form.getPlannedQty()) {
            newStatus = "2";
        } else {
            newStatus = "1";
        }

        form.setIssuedQty(totalIssued);
        form.setReceiverName(receiverName);
        form.setIssueTime(new Date());
        form.setStatus(newStatus);
        form.setUpdateBy(operatorName);
        form.setUpdateTime(DateUtils.getNowDate());
        bookClaimFormMapper.updateBookClaimForm(form);

        updateNoticeProgress(form.getNoticeId());

        log.info("【班级领书出库】完成! 领书单号={}, 班级={}, 实发数量={}, 状态={}",
                form.getFormNo(), form.getClassName(), totalIssued, newStatus);
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

        if (completedForms >= totalForms && totalForms > 0) {
            bookNoticeMapper.updateNoticeStatus(noticeId, "3");
        } else if (completedForms > 0) {
            bookNoticeMapper.updateNoticeStatus(noticeId, "2");
        }
    }

    @Override
    public List<BookClaimFormDetail> selectDetailsByFormId(Long formId) {
        return bookClaimFormDetailMapper.selectBookClaimFormDetailListByFormId(formId);
    }
}
