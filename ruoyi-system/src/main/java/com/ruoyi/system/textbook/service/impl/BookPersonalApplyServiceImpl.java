package com.ruoyi.system.textbook.service.impl;

import java.util.Date;
import java.util.List;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.DateUtils;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.system.textbook.domain.BookPersonalApply;
import com.ruoyi.system.textbook.mapper.BookPersonalApplyMapper;
import com.ruoyi.system.textbook.service.IBookPersonalApplyService;
import com.ruoyi.system.textbook.service.IStockOperationService;
import com.ruoyi.textbook.domain.TbShortage;
import com.ruoyi.textbook.mapper.TbShortageMapper;
import com.ruoyi.textbook.service.NoticeService;
import com.ruoyi.common.core.domain.entity.SysUser;
import com.ruoyi.system.mapper.SysUserMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class BookPersonalApplyServiceImpl implements IBookPersonalApplyService {

    @Autowired
    private BookPersonalApplyMapper bookPersonalApplyMapper;

    @Autowired
    private IStockOperationService stockOperationService;

    @Autowired
    private NoticeService noticeService;

    @Autowired
    private TbShortageMapper tbShortageMapper;

    @Autowired
    private SysUserMapper sysUserMapper;

    @Override
    public BookPersonalApply selectBookPersonalApplyById(Long applyId) {
        return bookPersonalApplyMapper.selectBookPersonalApplyById(applyId);
    }

    @Override
    public List<BookPersonalApply> selectBookPersonalApplyList(BookPersonalApply bookPersonalApply) {
        return bookPersonalApplyMapper.selectBookPersonalApplyList(bookPersonalApply);
    }

    @Override
    public List<BookPersonalApply> selectMyApplyList(BookPersonalApply bookPersonalApply) {
        if (bookPersonalApply.getTeacherId() == null) {
            bookPersonalApply.setTeacherId(SecurityUtils.getUserId());
        }
        return bookPersonalApplyMapper.selectMyApplyList(bookPersonalApply);
    }

    @Override
    public int insertBookPersonalApply(BookPersonalApply bookPersonalApply) {
        String applyNo = "SQ" + com.ruoyi.common.utils.DateUtils.dateTimeNow("yyyyMMddHHmmss")
                + com.ruoyi.common.utils.uuid.IdUtils.fastSimpleUUID().substring(0, 6);
        bookPersonalApply.setApplyNo(applyNo);
        bookPersonalApply.setStatus("0");
        bookPersonalApply.setCreateBy(SecurityUtils.getUsername());
        return bookPersonalApplyMapper.insertBookPersonalApply(bookPersonalApply);
    }

    @Override
    public int updateBookPersonalApply(BookPersonalApply bookPersonalApply) {
        bookPersonalApply.setUpdateBy(SecurityUtils.getUsername());
        return bookPersonalApplyMapper.updateBookPersonalApply(bookPersonalApply);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int deleteBookPersonalApplyByIds(Long[] applyIds) {
        for (Long applyId : applyIds) {
            BookPersonalApply existing = bookPersonalApplyMapper.selectBookPersonalApplyById(applyId);
            if (existing != null && !"0".equals(existing.getStatus())) {
                throw new ServiceException("申请单[" + existing.getApplyNo() + "]状态不是待审核，无法删除");
            }
        }
        return bookPersonalApplyMapper.deleteBookPersonalApplyByIds(applyIds);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int auditApply(BookPersonalApply bookPersonalApply) {
        BookPersonalApply existingApply = bookPersonalApplyMapper.selectBookPersonalApplyById(bookPersonalApply.getApplyId());
        if (existingApply == null) {
            throw new ServiceException("申请记录不存在");
        }

        if (!"0".equals(existingApply.getStatus())) {
            throw new ServiceException("该申请已审核，无法重复操作");
        }

        bookPersonalApply.setAuditBy(SecurityUtils.getUsername());
        bookPersonalApply.setAuditTime(new Date());

        if ("1".equals(bookPersonalApply.getStatus())) {
            int currentStock = stockOperationService.getCurrentStock(existingApply.getTextbookId());
            if (currentStock < existingApply.getApplyQty()) {
                throw new ServiceException("库存不足，无法通过审核（当前库存：" + currentStock + "，需求：" + existingApply.getApplyQty() + "）");
            }
            stockOperationService.deductStock(
                    existingApply.getTextbookId(),
                    existingApply.getApplyQty(),
                    "3",
                    existingApply.getApplyNo(),
                    SecurityUtils.getUsername()
            );

            bookPersonalApply.setStatus("3");
            bookPersonalApply.setIssueTime(new Date());
        }

        int result = bookPersonalApplyMapper.updateBookPersonalApply(bookPersonalApply);

        if (result > 0) {
            String status = bookPersonalApply.getStatus();
            String bookName = existingApply.getBookName();
            String auditOpinion = bookPersonalApply.getAuditOpinion();
            Long teacherId = existingApply.getTeacherId();

            if ("3".equals(status)) {
                noticeService.sendNoticeToUser(teacherId, "个人领书申请审核通过", "您的《" + bookName + "》领书申请已审核通过并完成出库，请前往书库领取。", "personal_apply_audit", bookPersonalApply.getApplyId());
            } else if ("2".equals(status)) {
                Long shortageId = null;
                if (Boolean.TRUE.equals(bookPersonalApply.getRegisterShortage())) {
                    shortageId = createShortageFromReject(existingApply, bookPersonalApply);
                }

                StringBuilder notifyContent = new StringBuilder();
                notifyContent.append("您的《").append(bookName).append("》领书申请已被驳回");
                if (auditOpinion != null && !auditOpinion.isEmpty()) {
                    notifyContent.append("，原因：").append(auditOpinion);
                }
                if (shortageId != null) {
                    String urgencyLabel = "普通";
                    if ("1".equals(bookPersonalApply.getShortageUrgency())) urgencyLabel = "紧急";
                    else if ("2".equals(bookPersonalApply.getShortageUrgency())) urgencyLabel = "特急";
                    notifyContent.append("。已为您登记缺书（").append(urgencyLabel).append("），到货后将通知您重新申请。");
                }
                noticeService.sendNoticeToUser(teacherId, "个人领书申请审核驳回", notifyContent.toString(), "personal_apply_audit", bookPersonalApply.getApplyId());
            }
        }

        return result;
    }

    private Long createShortageFromReject(BookPersonalApply apply, BookPersonalApply auditData) {
        TbShortage shortage = new TbShortage();
        shortage.setBookId(apply.getTextbookId());
        shortage.setBookName(apply.getBookName());
        shortage.setIsbn(apply.getIsbn());
        shortage.setLackNum(auditData.getShortageQty() != null ? auditData.getShortageQty() : apply.getApplyQty());
        shortage.setUrgency(auditData.getShortageUrgency() != null ? auditData.getShortageUrgency() : "0");
        shortage.setRegisterId(SecurityUtils.getUserId());
        SysUser currentUser = sysUserMapper.selectUserById(SecurityUtils.getUserId());
        if (currentUser != null) {
            shortage.setRegisterName(currentUser.getNickName());
        }
        shortage.setHandleStatus("0");
        shortage.setSource("1");
        shortage.setSourceId(apply.getApplyId());
        shortage.setRemark(auditData.getShortageRemark() != null ? auditData.getShortageRemark() : "由教师领书申请驳回转入，申请人：" + apply.getTeacherName());
        shortage.setCreateTime(DateUtils.getNowDate());
        shortage.setUpdateTime(DateUtils.getNowDate());
        tbShortageMapper.insertTbShortage(shortage);

        try {
            noticeService.sendLackNotice(
                    shortage.getBookId(),
                    shortage.getBookName(),
                    shortage.getIsbn(),
                    shortage.getLackNum(),
                    0,
                    shortage.getLackId()
            );
        } catch (Exception e) {
        }

        return shortage.getLackId();
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int issueApply(Long applyId) {
        BookPersonalApply existingApply = bookPersonalApplyMapper.selectBookPersonalApplyById(applyId);
        if (existingApply == null) {
            throw new ServiceException("申请记录不存在");
        }

        if (!"1".equals(existingApply.getStatus())) {
            throw new ServiceException("只有审核通过的申请才能出库");
        }

        stockOperationService.deductStock(existingApply.getTextbookId(), existingApply.getApplyQty(), "3", existingApply.getApplyNo(), SecurityUtils.getUsername());

        BookPersonalApply apply = new BookPersonalApply();
        apply.setApplyId(applyId);
        apply.setStatus("3");
        apply.setIssueTime(new Date());
        apply.setUpdateBy(SecurityUtils.getUsername());

        int result = bookPersonalApplyMapper.updateBookPersonalApply(apply);

        if (result > 0) {
            noticeService.sendNoticeToUser(existingApply.getTeacherId(), "个人领书出库完成", "您的《" + existingApply.getBookName() + "》领书申请已完成出库，感谢您的使用。", "personal_apply_issue", applyId);
        }

        return result;
    }
}
