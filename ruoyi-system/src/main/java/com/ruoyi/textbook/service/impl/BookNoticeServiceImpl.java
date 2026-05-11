package com.ruoyi.textbook.service.impl;

import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.util.ArrayList;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.DateUtils;
import com.ruoyi.common.utils.uuid.IdUtils;
import com.ruoyi.textbook.domain.BookNotice;
import com.ruoyi.textbook.domain.BookClaimForm;
import com.ruoyi.textbook.domain.BookClaimFormDetail;
import com.ruoyi.textbook.domain.TbInventory;
import com.ruoyi.textbook.mapper.BookNoticeMapper;
import com.ruoyi.textbook.mapper.BookClaimFormMapper;
import com.ruoyi.textbook.mapper.BookClaimFormDetailMapper;
import com.ruoyi.textbook.mapper.TbInventoryMapper;
import com.ruoyi.textbook.mapper.TextbookNoticeDetailMapper;
import com.ruoyi.textbook.domain.TextbookNoticeDetail;
import com.ruoyi.textbook.service.IBookNoticeService;
import com.ruoyi.textbook.service.NoticeService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class BookNoticeServiceImpl implements IBookNoticeService {

    private static final Logger log = LoggerFactory.getLogger(BookNoticeServiceImpl.class);

    @Autowired
    private BookNoticeMapper bookNoticeMapper;

    @Autowired
    private BookClaimFormMapper bookClaimFormMapper;

    @Autowired
    private BookClaimFormDetailMapper bookClaimFormDetailMapper;

    @Autowired
    private TbInventoryMapper tbInventoryMapper;

    @Autowired
    private NoticeService noticeService;

    @Autowired
    private TextbookNoticeDetailMapper textbookNoticeDetailMapper;

    @Override
    public BookNotice selectBookNoticeById(Long noticeId) {
        BookNotice notice = bookNoticeMapper.selectBookNoticeById(noticeId);
        if (notice != null) {
            List<TextbookNoticeDetail> details = textbookNoticeDetailMapper.selectByNoticeId(noticeId);
            if (details != null && !details.isEmpty()) {
                List<BookClaimFormDetail> claimFormDetails = new ArrayList<>();
                for (TextbookNoticeDetail d : details) {
                    BookClaimFormDetail cfd = new BookClaimFormDetail();
                    cfd.setTextbookId(d.getTextbookId());
                    cfd.setIsbn(d.getIsbn());
                    cfd.setBookName(d.getBookName());
                    cfd.setPlannedQty(d.getPlannedQty());
                    cfd.setCollegeId(d.getCollegeId());
                    cfd.setMajorId(d.getMajorId());
                    cfd.setClassId(d.getClassId());
                    cfd.setClassName(d.getClassName());
                    cfd.setGradeLevel(d.getGradeLevel());
                    claimFormDetails.add(cfd);
                }
                notice.setDetails(claimFormDetails);
            }
        }
        return notice;
    }

    @Override
    public List<BookNotice> selectBookNoticeList(BookNotice bookNotice) {
        return bookNoticeMapper.selectBookNoticeList(bookNotice);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int saveAndGenerate(BookNotice bookNotice) {
        String noticeNo = "LS" + DateUtils.dateTimeNow("yyyyMMddHHmmss")
                + IdUtils.fastSimpleUUID().substring(0, 6).toUpperCase();
        bookNotice.setNoticeNo(noticeNo);
        bookNotice.setStatus("1");
        bookNotice.setTotalClasses(0);
        bookNotice.setIssuedClasses(0);
        bookNotice.setCreateTime(DateUtils.getNowDate());
        int result = bookNoticeMapper.insertBookNotice(bookNotice);

        if (result > 0 && bookNotice.getDetails() != null && !bookNotice.getDetails().isEmpty()) {
            List<BookClaimForm> forms = generateClaimFormsByClass(bookNotice);
            if (forms.isEmpty()) {
                throw new ServiceException("生成领书单失败，请检查领书明细");
            }
            bookNotice.setTotalClasses(forms.size());
            bookNoticeMapper.updateBookNotice(bookNotice);
            log.info("【领书管理-保存并生成】通知编号={}, 学期={}, 班级数={}", noticeNo, bookNotice.getSemester(), forms.size());
        }
        return result;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int insertBookNotice(BookNotice bookNotice) {
        String noticeNo = "LS" + DateUtils.dateTimeNow("yyyyMMddHHmmss")
                + IdUtils.fastSimpleUUID().substring(0, 6).toUpperCase();
        bookNotice.setNoticeNo(noticeNo);
        bookNotice.setStatus("0");
        bookNotice.setTotalClasses(0);
        bookNotice.setIssuedClasses(0);
        bookNotice.setCreateTime(DateUtils.getNowDate());
        int result = bookNoticeMapper.insertBookNotice(bookNotice);
        
        if (result > 0 && bookNotice.getDetails() != null && !bookNotice.getDetails().isEmpty()) {
            List<TextbookNoticeDetail> noticeDetails = new ArrayList<>();
            for (BookClaimFormDetail detail : bookNotice.getDetails()) {
                TextbookNoticeDetail nd = new TextbookNoticeDetail();
                nd.setNoticeId(bookNotice.getNoticeId());
                nd.setTextbookId(detail.getTextbookId());
                nd.setIsbn(detail.getIsbn());
                nd.setBookName(detail.getBookName());
                nd.setPlannedQty(detail.getPlannedQty());
                nd.setCollegeId(detail.getCollegeId());
                nd.setMajorId(detail.getMajorId());
                nd.setClassId(detail.getClassId());
                nd.setClassName(detail.getClassName());
                nd.setGradeLevel(detail.getGradeLevel());
                nd.setCreateBy(bookNotice.getCreateBy());
                noticeDetails.add(nd);
            }
            textbookNoticeDetailMapper.batchInsert(noticeDetails);
        }
        
        return result;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int updateBookNotice(BookNotice bookNotice) {
        bookNotice.setUpdateTime(DateUtils.getNowDate());
        int result = bookNoticeMapper.updateBookNotice(bookNotice);

        if (result > 0 && bookNotice.getDetails() != null && !bookNotice.getDetails().isEmpty()) {
            textbookNoticeDetailMapper.deleteByNoticeId(bookNotice.getNoticeId());
            List<TextbookNoticeDetail> noticeDetails = new ArrayList<>();
            for (BookClaimFormDetail detail : bookNotice.getDetails()) {
                TextbookNoticeDetail nd = new TextbookNoticeDetail();
                nd.setNoticeId(bookNotice.getNoticeId());
                nd.setTextbookId(detail.getTextbookId());
                nd.setIsbn(detail.getIsbn());
                nd.setBookName(detail.getBookName());
                nd.setPlannedQty(detail.getPlannedQty());
                nd.setCollegeId(detail.getCollegeId());
                nd.setMajorId(detail.getMajorId());
                nd.setClassId(detail.getClassId());
                nd.setClassName(detail.getClassName());
                nd.setGradeLevel(detail.getGradeLevel());
                nd.setCreateBy(bookNotice.getUpdateBy());
                noticeDetails.add(nd);
            }
            textbookNoticeDetailMapper.batchInsert(noticeDetails);
        }

        return result;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int deleteBookNoticeByIds(Long[] noticeIds) {
        int rows = bookNoticeMapper.deleteBookNoticeByIds(noticeIds);
        textbookNoticeDetailMapper.deleteByNoticeIds(noticeIds);
        return rows;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int publishNotice(Long noticeId) {
        BookNotice notice = this.selectBookNoticeById(noticeId);
        if (notice == null) {
            throw new ServiceException("领书通知不存在");
        }
        if (!"0".equals(notice.getStatus())) {
            throw new ServiceException("只有草稿状态的通知才能发布");
        }

        List<String> warnings = new ArrayList<>();
        if (notice.getDetails() != null && !notice.getDetails().isEmpty()) {
            Map<Long, Integer> bookDemandMap = new HashMap<>();
            Map<Long, String> bookNameMap = new HashMap<>();
            for (BookClaimFormDetail detail : notice.getDetails()) {
                bookDemandMap.merge(detail.getTextbookId(), detail.getPlannedQty(), Integer::sum);
                bookNameMap.putIfAbsent(detail.getTextbookId(), detail.getBookName());
            }
            for (Map.Entry<Long, Integer> entry : bookDemandMap.entrySet()) {
                TbInventory inventory = tbInventoryMapper.selectTbInventoryByBookId(entry.getKey());
                if (inventory == null) {
                    warnings.add("教材《" + bookNameMap.get(entry.getKey()) + "》库存记录不存在");
                } else if (inventory.getStockNum() < entry.getValue()) {
                    warnings.add("教材《" + bookNameMap.get(entry.getKey()) + "》库存不足，当前库存：" + inventory.getStockNum() + "，总需求：" + entry.getValue());
                }
            }
        }

        if (!warnings.isEmpty()) {
            log.warn("【领书通知发布】库存预警: {}", String.join("; ", warnings));
            throw new ServiceException("库存不足，无法发布领书通知：" + String.join("; ", warnings));
        }

        List<BookClaimForm> forms = generateClaimFormsByClass(notice);
        if (forms == null || forms.isEmpty()) {
            throw new ServiceException("请先添加领书明细后再发布");
        }

        int rowsAffected = bookNoticeMapper.updateNoticeStatusWithExpected(noticeId, "0", "1");
        if (rowsAffected <= 0) {
            throw new ServiceException("发布失败，通知状态可能已被其他操作修改，请刷新后重试");
        }

        notice.setTotalClasses(forms.size());
        notice.setUpdateTime(DateUtils.getNowDate());
        bookNoticeMapper.updateBookNotice(notice);

        noticeService.sendNoticePublishNotice(noticeId, notice.getSemester(), forms.size());

        log.info("【领书通知发布】通知编号={}, 学期={}, 班级数={}", notice.getNoticeNo(), notice.getSemester(), forms.size());
        return 1;
    }
    
    // 按班级生成领书单
    private List<BookClaimForm> generateClaimFormsByClass(BookNotice notice) {
        // 先检查是否已存在领书单
        List<BookClaimForm> existingForms = bookClaimFormMapper.selectBookClaimFormsByNoticeId(notice.getNoticeId());
        if (existingForms != null && !existingForms.isEmpty()) {
            return existingForms;
        }
        
        // 从领书通知中获取领书明细
        if (notice.getDetails() == null || notice.getDetails().isEmpty()) {
            return new ArrayList<>();
        }
        
        // 按班级分组
        Map<String, List<BookClaimFormDetail>> classMap = new HashMap<>();
        for (BookClaimFormDetail detail : notice.getDetails()) {
            String classKey = detail.getCollegeId() + "-" + detail.getMajorId() + "-" + detail.getClassId();
            if (!classMap.containsKey(classKey)) {
                classMap.put(classKey, new ArrayList<>());
            }
            classMap.get(classKey).add(detail);
        }
        
        // 为每个班级生成领书单
        List<BookClaimForm> forms = new ArrayList<>();
        for (Map.Entry<String, List<BookClaimFormDetail>> entry : classMap.entrySet()) {
            List<BookClaimFormDetail> classDetails = entry.getValue();
            if (!classDetails.isEmpty()) {
                BookClaimFormDetail firstDetail = classDetails.get(0);
                
                // 创建领书单
                BookClaimForm form = new BookClaimForm();
                form.setNoticeId(notice.getNoticeId());
                form.setCollegeId(firstDetail.getCollegeId());
                form.setMajorId(firstDetail.getMajorId());
                form.setClassId(firstDetail.getClassId());
                form.setClassName(firstDetail.getClassName());
                form.setGradeLevel(firstDetail.getGradeLevel());
                form.setStatus("0");
                form.setIssuedQty(0);
                
                // 计算应发总数
                int plannedQty = 0;
                for (BookClaimFormDetail detail : classDetails) {
                    plannedQty += detail.getPlannedQty();
                }
                form.setPlannedQty(plannedQty);
                
                // 生成领书单号
                String formNo = "CF" + DateUtils.dateTimeNow("yyyyMMddHHmmss") + IdUtils.fastSimpleUUID().substring(0, 6);
                form.setFormNo(formNo);
                form.setCreateTime(DateUtils.getNowDate());
                
                // 保存领书单
                bookClaimFormMapper.insertBookClaimForm(form);
                
                // 保存领书单明细
                for (BookClaimFormDetail detail : classDetails) {
                    detail.setFormId(form.getFormId());
                    detail.setIssuedQty(0);
                    bookClaimFormDetailMapper.insertBookClaimFormDetail(detail);
                }
                
                forms.add(form);
            }
        }
        
        return forms;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public List<BookClaimForm> generateClaimForms(Long noticeId) {
        BookNotice notice = bookNoticeMapper.selectBookNoticeById(noticeId);
        if (notice == null) {
            throw new ServiceException("领书通知不存在");
        }

        List<BookClaimForm> existingForms = bookClaimFormMapper.selectBookClaimFormsByNoticeId(noticeId);
        if (existingForms != null && !existingForms.isEmpty()) {
            return existingForms;
        }
        
        // 生成领书单
        return generateClaimFormsByClass(notice);
    }
}
