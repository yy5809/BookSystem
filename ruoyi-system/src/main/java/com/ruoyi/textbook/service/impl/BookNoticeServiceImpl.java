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
@SuppressWarnings("unchecked")
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

    @Autowired
    private com.ruoyi.textbook.mapper.TextbookClassBindingMapper textbookClassBindingMapper;

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
            log.info("【领书管理-保存草稿】通知编号={}, 学期={}, 明细数={}", noticeNo, bookNotice.getSemester(), noticeDetails.size());
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

        loadNoticeDetailsIfNeeded(notice);
        if (notice.getDetails() == null || notice.getDetails().isEmpty()) {
            throw new ServiceException("领书明细为空，请先加载采购绑定数据");
        }
        log.info("【发布】加载明细数={}, noticeId={}", notice.getDetails().size(), noticeId);

        List<String> warnings = new ArrayList<>();
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
        if (!warnings.isEmpty()) {
            log.warn("【领书通知发布】库存预警: {}", String.join("; ", warnings));
        }

        List<BookClaimForm> forms = generateClaimFormsByClass(notice);
        if (forms == null || forms.isEmpty()) {
            throw new ServiceException("领书单生成失败，明细数=" + notice.getDetails().size() + "，请检查班级分组是否正确");
        }

        int rowsAffected = bookNoticeMapper.updateNoticeStatusWithExpected(noticeId, "0", "1");
        if (rowsAffected <= 0) {
            throw new ServiceException("发布失败，通知状态可能已被其他操作修改，请刷新后重试");
        }
        log.info("【状态已更新】noticeId={}, status: 0→1, rowsAffected={}", noticeId, rowsAffected);
        notice.setStatus("1");

        notice.setTotalClasses(forms.size());
        notice.setUpdateTime(DateUtils.getNowDate());
        bookNoticeMapper.updateBookNotice(notice);

        noticeService.sendNoticePublishNotice(noticeId, notice.getSemester(), forms.size());

        log.info("【领书通知发布】通知编号={}, 学期={}, 班级数={}, 明细数={}", notice.getNoticeNo(), notice.getSemester(), forms.size(), notice.getDetails().size());
        return forms.size();
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
            String classKey = detail.getClassName() != null ? detail.getClassName() : "未命名班级";
            classMap.computeIfAbsent(classKey, k -> new ArrayList<>()).add(detail);
        }
        
        List<BookClaimForm> forms = new ArrayList<>();
        for (Map.Entry<String, List<BookClaimFormDetail>> entry : classMap.entrySet()) {
            List<BookClaimFormDetail> classDetails = entry.getValue();
            if (!classDetails.isEmpty()) {
                BookClaimFormDetail firstDetail = classDetails.get(0);
                
                BookClaimForm form = new BookClaimForm();
                form.setNoticeId(notice.getNoticeId());
                form.setCollegeId(0L);
                form.setMajorId(0L);
                form.setClassId(0L);
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
            log.info("【查询领书单】noticeId={}, 已有表单数={}", noticeId, existingForms.size());
            return existingForms;
        }
        
        loadNoticeDetailsIfNeeded(notice);
        log.info("【查询领书单】noticeId={}, 明细数={}, 将按班级生成", noticeId,
                notice.getDetails() != null ? notice.getDetails().size() : 0);
        List<BookClaimForm> generated = generateClaimFormsByClass(notice);
        log.info("【查询领书单】noticeId={}, 生成表单数={}", noticeId, generated.size());
        return generated;
    }

    private void loadNoticeDetailsIfNeeded(BookNotice notice) {
        if (notice.getDetails() != null && !notice.getDetails().isEmpty()) return;
        List<TextbookNoticeDetail> noticeDetails = textbookNoticeDetailMapper.selectByNoticeId(notice.getNoticeId());
        if (noticeDetails == null || noticeDetails.isEmpty()) return;
        List<BookClaimFormDetail> details = new ArrayList<>();
        for (TextbookNoticeDetail nd : noticeDetails) {
            BookClaimFormDetail d = new BookClaimFormDetail();
            d.setTextbookId(nd.getTextbookId());
            d.setIsbn(nd.getIsbn());
            d.setBookName(nd.getBookName());
            d.setPlannedQty(nd.getPlannedQty());
            d.setCollegeId(nd.getCollegeId());
            d.setMajorId(nd.getMajorId());
            d.setClassId(nd.getClassId());
            d.setClassName(nd.getClassName());
            d.setGradeLevel(nd.getGradeLevel());
            details.add(d);
        }
        notice.setDetails(details);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int cancelNotice(Long noticeId, String cancelReason, String cancelBy) {
        BookNotice notice = this.selectBookNoticeById(noticeId);
        if (notice == null) {
            throw new ServiceException("领书通知不存在");
        }
        if ("4".equals(notice.getStatus())) {
            throw new ServiceException("该通知已作废");
        }
        if ("0".equals(notice.getStatus())) {
            throw new ServiceException("草稿状态的通知无需作废，可直接删除");
        }

        List<BookClaimForm> forms = bookClaimFormMapper.selectBookClaimFormsByNoticeId(noticeId);
        if (forms != null && !forms.isEmpty()) {
            for (BookClaimForm form : forms) {
                if ("2".equals(form.getStatus()) || "1".equals(form.getStatus())) {
                    throw new ServiceException("存在已出库或部分出库的班级，无法作废通知");
                }
            }
            for (BookClaimForm form : forms) {
                form.setStatus("5");
                form.setCancelReason(cancelReason);
                bookClaimFormMapper.updateBookClaimForm(form);
            }
        }

        notice.setStatus("4");
        notice.setCancelReason(cancelReason);
        notice.setCancelBy(cancelBy);
        notice.setCancelTime(new Date());
        notice.setUpdateTime(DateUtils.getNowDate());
        int rows = bookNoticeMapper.updateBookNotice(notice);

        log.info("【领书通知作废】通知编号={}, 作废原因={}", notice.getNoticeNo(), cancelReason);
        return rows;
    }

    @Override
    public int extendPickupTime(Long noticeId, Date newEndTime) {
        BookNotice notice = bookNoticeMapper.selectBookNoticeById(noticeId);
        if (notice == null) {
            throw new ServiceException("领书通知不存在");
        }
        if (newEndTime.before(notice.getPickupStart())) {
            throw new ServiceException("领取结束时间不能早于开始时间");
        }
        notice.setPickupEnd(newEndTime);
        notice.setUpdateTime(DateUtils.getNowDate());
        notice.setRemark((notice.getRemark() == null ? "" : notice.getRemark() + "; ")
                + "领取时间已延长至" + DateUtils.parseDateToStr("yyyy-MM-dd HH:mm:ss", newEndTime));
        return bookNoticeMapper.updateBookNotice(notice);
    }

    @Override
    public java.util.List<java.util.Map<String, Object>> getBindingData(String semester) {
        java.util.List<com.ruoyi.textbook.domain.TextbookClassBinding> bindings =
                textbookClassBindingMapper.selectBySemester(semester);
        if (bindings == null || bindings.isEmpty()) return java.util.Collections.emptyList();

        java.util.Set<String> usedKeys = getUsedBindingKeys(semester);
        log.info("【加载绑定】学期={}, 总绑定数={}, 已占用={}", semester, bindings.size(), usedKeys.size());

        java.util.Map<String, java.util.Map<String, Object>> collegeMajorMap = new java.util.LinkedHashMap<>();
        for (com.ruoyi.textbook.domain.TextbookClassBinding b : bindings) {
            String bindingKey = b.getClassName() + "|" + b.getBookId();
            if (usedKeys.contains(bindingKey)) continue;

            String key = b.getCollege() + "|" + b.getMajor();
            collegeMajorMap.computeIfAbsent(key, k -> {
                java.util.Map<String, Object> cm = new java.util.LinkedHashMap<>();
                cm.put("college", b.getCollege());
                cm.put("major", b.getMajor());
                cm.put("classMap", new java.util.LinkedHashMap<String, java.util.List<java.util.Map<String, Object>>>());
                return cm;
            });

            java.util.Map<String, java.util.List<java.util.Map<String, Object>>> classMap =
                    (java.util.Map<String, java.util.List<java.util.Map<String, Object>>>) collegeMajorMap.get(key).get("classMap");

            classMap.computeIfAbsent(b.getClassName(), cn -> new java.util.ArrayList<>());
            java.util.Map<String, Object> book = new java.util.LinkedHashMap<>();
            book.put("bookId", b.getBookId());
            book.put("isbn", b.getIsbn());
            book.put("bookName", b.getBookName());
            book.put("plannedQty", b.getPlannedQty());
            classMap.get(b.getClassName()).add(book);
        }

        java.util.List<java.util.Map<String, Object>> result = new java.util.ArrayList<>();
        for (java.util.Map<String, Object> cm : collegeMajorMap.values()) {
            java.util.Map<String, java.util.List<java.util.Map<String, Object>>> classMap =
                    (java.util.Map<String, java.util.List<java.util.Map<String, Object>>>) cm.remove("classMap");
            java.util.List<java.util.Map<String, Object>> classList = new java.util.ArrayList<>();
            for (java.util.Map.Entry<String, java.util.List<java.util.Map<String, Object>>> e : classMap.entrySet()) {
                java.util.Map<String, Object> cls = new java.util.LinkedHashMap<>();
                cls.put("className", e.getKey());
                cls.put("books", e.getValue());
                classList.add(cls);
            }
            cm.put("classList", classList);
            result.add(cm);
        }
        return result;
    }

    private java.util.Set<String> getUsedBindingKeys(String semester) {
        java.util.Set<String> keys = new java.util.HashSet<>();
        com.ruoyi.textbook.domain.BookNotice query = new com.ruoyi.textbook.domain.BookNotice();
        query.setSemester(semester);
        java.util.List<com.ruoyi.textbook.domain.BookNotice> notices = bookNoticeMapper.selectBookNoticeList(query);
        for (com.ruoyi.textbook.domain.BookNotice n : notices) {
            if ("0".equals(n.getStatus())) continue;
            java.util.List<com.ruoyi.textbook.domain.TextbookNoticeDetail> details =
                    textbookNoticeDetailMapper.selectByNoticeId(n.getNoticeId());
            if (details != null) {
                for (com.ruoyi.textbook.domain.TextbookNoticeDetail d : details) {
                    keys.add(d.getClassName() + "|" + d.getTextbookId());
                }
            }
        }
        return keys;
    }
}
