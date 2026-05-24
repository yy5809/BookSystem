package com.ruoyi.textbook.service.impl;

import java.util.Date;
import java.util.List;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.DateUtils;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.textbook.domain.BookPersonalApply;
import com.ruoyi.textbook.domain.TbShortage;
import com.ruoyi.textbook.mapper.BookPersonalApplyMapper;
import com.ruoyi.textbook.mapper.TbShortageMapper;
import com.ruoyi.textbook.service.IBookPersonalApplyService;
import com.ruoyi.textbook.service.IStockOperationService;
import com.ruoyi.textbook.service.NoticeService;
import com.ruoyi.common.core.domain.entity.SysUser;
import com.ruoyi.system.mapper.SysUserMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@Service
public class BookPersonalApplyServiceImpl implements IBookPersonalApplyService {

    private static final Logger log = LoggerFactory.getLogger(BookPersonalApplyServiceImpl.class);

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
        bookPersonalApply.setTeacherId(SecurityUtils.getUserId());
        return bookPersonalApplyMapper.selectMyApplyList(bookPersonalApply);
    }

    @Override
    public int insertBookPersonalApply(BookPersonalApply bookPersonalApply) {
        if (bookPersonalApply.getTextbookId() == null) {
            throw new ServiceException("请选择教材");
        }
        if (bookPersonalApply.getApplyQty() == null || bookPersonalApply.getApplyQty() <= 0) {
            throw new ServiceException("申请数量必须为正整数");
        }
        if (bookPersonalApply.getApplyQty() > 9999) {
            throw new ServiceException("单次申请数量不能超过9999");
        }
        String applyNo = "SQ" + DateUtils.dateTimeNow("yyyyMMddHHmmss")
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

        bookPersonalApply.setAuditBy(SecurityUtils.getLoginUser().getUser().getNickName());
        bookPersonalApply.setAuditTime(new Date());

        if ("1".equals(bookPersonalApply.getStatus())) {
            int currentStock = stockOperationService.getCurrentStock(existingApply.getTextbookId());
            if (currentStock < existingApply.getApplyQty()) {
                throw new ServiceException("库存不足，无法通过审核（当前库存：" + currentStock + "，需求：" + existingApply.getApplyQty() + "）。请驳回并建议教师重新申请。");
            }
            if (currentStock < existingApply.getApplyQty() * 2) {
                log.warn("【审核通过】库存紧张，教材ID={}，当前库存={}，需求={}", existingApply.getTextbookId(), currentStock, existingApply.getApplyQty());
            }
            log.info("【审核通过】库存校验通过，教材ID={}，当前库存={}，需求={}（注意：实际出库时将再次校验库存）", existingApply.getTextbookId(), currentStock, existingApply.getApplyQty());
        }

        int result = bookPersonalApplyMapper.updateBookPersonalApply(bookPersonalApply);

        if (result > 0) {
            String status = bookPersonalApply.getStatus();
            String bookName = existingApply.getBookName();
            String auditOpinion = bookPersonalApply.getAuditOpinion();
            Long teacherId = existingApply.getTeacherId();

            if ("1".equals(status)) {
                noticeService.sendNoticeToUser(teacherId, "个人领书申请审核通过", "您的《" + bookName + "》领书申请已审核通过，请等待出库通知。", "1", bookPersonalApply.getApplyId());
            } else if ("3".equals(status)) {
                noticeService.sendNoticeToUser(teacherId, "个人领书出库完成", "您的《" + bookName + "》领书申请已完成出库，请前往领取。", "1", bookPersonalApply.getApplyId());
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
                noticeService.sendNoticeToUser(teacherId, "个人领书申请审核驳回", notifyContent.toString(), "1", bookPersonalApply.getApplyId());
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
        shortage.setRegisterId(apply.getTeacherId());
        shortage.setRegisterName(apply.getTeacherName());
        shortage.setHandleStatus("0");
        shortage.setSource("3");
        shortage.setSourceId(apply.getApplyId());
        shortage.setRemark(auditData.getShortageRemark() != null ? auditData.getShortageRemark() : "由教师领书申请驳回转入，申请人：" + apply.getTeacherName());
        shortage.setCreateTime(DateUtils.getNowDate());
        shortage.setUpdateTime(DateUtils.getNowDate());
        tbShortageMapper.insertTbShortage(shortage);

        noticeService.sendLackNotice(
                shortage.getBookId(),
                shortage.getBookName(),
                shortage.getIsbn(),
                shortage.getLackNum(),
                0,
                shortage.getLackId()
        );

        return shortage.getLackId();
    }

    @Override
    public int registerShortageFromApply(Long applyId) {
        BookPersonalApply apply = bookPersonalApplyMapper.selectBookPersonalApplyById(applyId);
        if (apply == null) {
            throw new ServiceException("申请记录不存在");
        }

        if (!"2".equals(apply.getStatus())) {
            throw new ServiceException("只有已驳回的申请才能进行缺书登记，当前状态：" + apply.getStatus());
        }

        Long currentUserId = SecurityUtils.getUserId();
        if (!currentUserId.equals(apply.getTeacherId())) {
            throw new ServiceException("无权为他人创建缺书登记");
        }

        Integer shortageQty = apply.getApplyQty();
        if (shortageQty == null || shortageQty <= 0) {
            throw new ServiceException("申请数量无效");
        }

        TbShortage shortage = new TbShortage();
        shortage.setBookId(apply.getTextbookId());
        shortage.setBookName(apply.getBookName());
        shortage.setIsbn(apply.getIsbn());
        shortage.setLackNum(shortageQty);
        shortage.setUrgency("0");
        shortage.setRegisterId(apply.getTeacherId());
        shortage.setRegisterName(apply.getTeacherName());
        shortage.setHandleStatus("0");
        shortage.setSource("1");
        shortage.setSourceId(applyId);
        shortage.setRemark("教师自助缺书登记，申请人：" + apply.getTeacherName());
        shortage.setCreateTime(DateUtils.getNowDate());
        shortage.setUpdateTime(DateUtils.getNowDate());
        tbShortageMapper.insertTbShortage(shortage);

        noticeService.sendLackNotice(
                shortage.getBookId(),
                shortage.getBookName(),
                shortage.getIsbn(),
                shortage.getLackNum(),
                0,
                shortage.getLackId()
        );

        log.info("【教师自助缺书登记】教师一键缺书登记成功, applyId={}, teacherId={}, lackId={}, bookName={}",
                applyId, apply.getTeacherId(), shortage.getLackId(), apply.getBookName());

        BookPersonalApply updateApply = new BookPersonalApply();
        updateApply.setApplyId(applyId);
        updateApply.setStatus("5");
        updateApply.setUpdateBy(SecurityUtils.getLoginUser().getUser().getNickName());
        bookPersonalApplyMapper.updateBookPersonalApply(updateApply);

        return 1;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int issueApply(Long applyId, Integer receivedQty, String location, String remark) {
        BookPersonalApply existingApply = bookPersonalApplyMapper.selectBookPersonalApplyById(applyId);
        if (existingApply == null) {
            throw new ServiceException("申请记录不存在");
        }

        String status = existingApply.getStatus();
        String ss = existingApply.getShortageStatus();
        log.info("【确认领书】applyId={}, status={}, shortageStatus={}", applyId, status, ss);

        if (!"1".equals(status)) {
            if ("3".equals(ss)) {
                int restored = bookPersonalApplyMapper.restoreToApproved(applyId,
                        "缺书已补货入库，确认领书时自动恢复",
                        SecurityUtils.getUsername(), DateUtils.getNowDate());
                if (restored == 0) {
                    throw new ServiceException("状态恢复失败，请刷新后重试");
                }
                log.info("【确认领书】缺书status=3已入库，自动恢复申请状态, applyId={}", applyId);
            } else {
                String tip = ss != null ? "已驳回(缺书进度" + ss + ")" : status;
                throw new ServiceException("只有审核通过的申请才能确认领书，当前状态：" + tip);
            }
        }

        int qty = receivedQty != null && receivedQty > 0 ? receivedQty : existingApply.getApplyQty();
        if (qty > existingApply.getApplyQty()) {
            throw new ServiceException("实发数量不能超过申请数量");
        }

        try {
            stockOperationService.deductStock(existingApply.getTextbookId(), qty, "2", existingApply.getApplyNo(),
                    SecurityUtils.getLoginUser().getUser().getNickName());
        } catch (ServiceException e) {
            if (e.getMessage().contains("库存不足") || e.getMessage().contains("并发冲突")) {
                throw new ServiceException("领书确认失败：" + e.getMessage() + "。请刷新后重试。");
            }
            throw e;
        }

        BookPersonalApply apply = new BookPersonalApply();
        apply.setApplyId(applyId);
        apply.setStatus("3");
        apply.setIssueTime(new Date());
        apply.setReceivedTime(new Date());
        apply.setReceiveOperator(SecurityUtils.getLoginUser().getUser().getNickName());
        apply.setReceiveLocation(location);
        apply.setUpdateBy(SecurityUtils.getUsername());

        int result = bookPersonalApplyMapper.updateBookPersonalApply(apply);

        if (result > 0) {
            String notifyContent = "您的《" + existingApply.getBookName() + "》已领取，实发" + qty + "本";
            if (location != null && !location.isEmpty()) {
                notifyContent += "，领取地点：" + location;
            }
            noticeService.sendNoticeToUser(existingApply.getTeacherId(), "领书确认通知", notifyContent, "1", applyId);
        }

        return result;
    }

    @Override
    public int cancelApply(Long applyId, Long currentUserId) {
        BookPersonalApply existingApply = bookPersonalApplyMapper.selectBookPersonalApplyById(applyId);
        if (existingApply == null) {
            throw new ServiceException("申请记录不存在");
        }
        if (!currentUserId.equals(existingApply.getTeacherId())) {
            throw new ServiceException("无权取消他人的申请记录");
        }
        if (!"0".equals(existingApply.getStatus())) {
            throw new ServiceException("只有待审核状态的申请才能取消");
        }
        BookPersonalApply apply = new BookPersonalApply();
        apply.setApplyId(applyId);
        apply.setStatus("4");
        apply.setAuditOpinion("申请人主动取消");
        apply.setUpdateBy(SecurityUtils.getUsername());
        return bookPersonalApplyMapper.updateBookPersonalApply(apply);
    }
}
