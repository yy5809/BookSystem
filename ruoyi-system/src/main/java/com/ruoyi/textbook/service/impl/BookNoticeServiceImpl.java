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

    @Override
    public BookNotice selectBookNoticeById(Long noticeId) {
        return bookNoticeMapper.selectBookNoticeById(noticeId);
    }

    @Override
    public List<BookNotice> selectBookNoticeList(BookNotice bookNotice) {
        return bookNoticeMapper.selectBookNoticeList(bookNotice);
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
        
        // 处理领书明细
        if (result > 0 && bookNotice.getDetails() != null && !bookNotice.getDetails().isEmpty()) {
            for (BookClaimFormDetail detail : bookNotice.getDetails()) {
                // 校验库存
                TbInventory inventory = tbInventoryMapper.selectTbInventoryByBookId(detail.getTextbookId());
                if (inventory == null) {
                    throw new ServiceException("教材《" + detail.getBookName() + "》库存记录不存在");
                }
                if (inventory.getStockNum() < detail.getPlannedQty()) {
                    throw new ServiceException("教材《" + detail.getBookName() + "》库存不足，当前库存：" + inventory.getStockNum() + "，需求：" + detail.getPlannedQty());
                }
                
                // 保存领书明细（暂时保存到临时表或关联到通知）
                // 这里简化处理，实际应该有专门的表来存储通知的领书明细
            }
        }
        
        return result;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int updateBookNotice(BookNotice bookNotice) {
        bookNotice.setUpdateTime(DateUtils.getNowDate());
        int result = bookNoticeMapper.updateBookNotice(bookNotice);
        
        // 处理领书明细
        if (result > 0 && bookNotice.getDetails() != null && !bookNotice.getDetails().isEmpty()) {
            for (BookClaimFormDetail detail : bookNotice.getDetails()) {
                // 校验库存
                TbInventory inventory = tbInventoryMapper.selectTbInventoryByBookId(detail.getTextbookId());
                if (inventory == null) {
                    throw new ServiceException("教材《" + detail.getBookName() + "》库存记录不存在");
                }
                if (inventory.getStockNum() < detail.getPlannedQty()) {
                    throw new ServiceException("教材《" + detail.getBookName() + "》库存不足，当前库存：" + inventory.getStockNum() + "，需求：" + detail.getPlannedQty());
                }
            }
        }
        
        return result;
    }

    @Override
    public int deleteBookNoticeByIds(Long[] noticeIds) {
        return bookNoticeMapper.deleteBookNoticeByIds(noticeIds);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public synchronized int publishNotice(Long noticeId) {
        BookNotice notice = bookNoticeMapper.selectBookNoticeById(noticeId);
        if (notice == null) {
            throw new ServiceException("领书通知不存在");
        }
        if (!"0".equals(notice.getStatus())) {
            throw new ServiceException("只有草稿状态的通知才能发布");
        }

        // 按教材汇总需求量后校验库存（防止同一教材被多个班级重复需求导致库存超额分配）
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
                    throw new ServiceException("教材《" + bookNameMap.get(entry.getKey()) + "》库存记录不存在");
                }
                if (inventory.getStockNum() < entry.getValue()) {
                    throw new ServiceException("教材《" + bookNameMap.get(entry.getKey()) + "》库存不足，当前库存：" + inventory.getStockNum() + "，总需求：" + entry.getValue());
                }
            }
        }
        
        // 生成领书单（按班级分组）
        List<BookClaimForm> forms = generateClaimFormsByClass(notice);
        if (forms == null || forms.isEmpty()) {
            throw new ServiceException("请先添加领书明细后再发布");
        }
        
        notice.setStatus("1");
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
