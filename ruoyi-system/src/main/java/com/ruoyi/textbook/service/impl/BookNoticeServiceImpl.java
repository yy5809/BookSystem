package com.ruoyi.textbook.service.impl;

import java.util.Date;
import java.util.List;
import com.ruoyi.common.utils.DateUtils;
import com.ruoyi.common.utils.uuid.IdUtils;
import com.ruoyi.textbook.domain.BookNotice;
import com.ruoyi.textbook.domain.BookClaimForm;
import com.ruoyi.textbook.mapper.BookNoticeMapper;
import com.ruoyi.textbook.mapper.BookClaimFormMapper;
import com.ruoyi.textbook.service.IBookNoticeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class BookNoticeServiceImpl implements IBookNoticeService {

    @Autowired
    private BookNoticeMapper bookNoticeMapper;

    @Autowired
    private BookClaimFormMapper bookClaimFormMapper;

    @Override
    public BookNotice selectBookNoticeById(Long noticeId) {
        return bookNoticeMapper.selectBookNoticeById(noticeId);
    }

    @Override
    public List<BookNotice> selectBookNoticeList(BookNotice bookNotice) {
        return bookNoticeMapper.selectBookNoticeList(bookNotice);
    }

    @Override
    public int insertBookNotice(BookNotice bookNotice) {
        String noticeNo = "LS" + DateUtils.dateTimeNow("yyyyMMdd") + String.format("%03d", System.currentTimeMillis() % 1000);
        bookNotice.setNoticeNo(noticeNo);
        bookNotice.setStatus("0");
        bookNotice.setTotalClasses(0);
        bookNotice.setIssuedClasses(0);
        bookNotice.setCreateTime(DateUtils.getNowDate());
        return bookNoticeMapper.insertBookNotice(bookNotice);
    }

    @Override
    public int updateBookNotice(BookNotice bookNotice) {
        bookNotice.setUpdateTime(DateUtils.getNowDate());
        return bookNoticeMapper.updateBookNotice(bookNotice);
    }

    @Override
    public int deleteBookNoticeByIds(Long[] noticeIds) {
        return bookNoticeMapper.deleteBookNoticeByIds(noticeIds);
    }

    @Override
    public int publishNotice(Long noticeId) {
        BookNotice notice = bookNoticeMapper.selectBookNoticeById(noticeId);
        if (notice == null) {
            throw new RuntimeException("领书通知不存在");
        }
        if (!"0".equals(notice.getStatus())) {
            throw new RuntimeException("只有草稿状态的通知才能发布");
        }
        List<BookClaimForm> forms = bookClaimFormMapper.selectBookClaimFormsByNoticeId(noticeId);
        if (forms == null || forms.isEmpty()) {
            throw new RuntimeException("请先添加领书明细后再发布");
        }
        notice.setStatus("1");
        notice.setTotalClasses(forms.size());
        notice.setUpdateTime(DateUtils.getNowDate());
        return bookNoticeMapper.updateBookNotice(notice);
    }

    @Override
    public List<BookClaimForm> generateClaimForms(Long noticeId) {
        BookNotice notice = bookNoticeMapper.selectBookNoticeById(noticeId);
        if (notice == null) {
            throw new RuntimeException("领书通知不存在");
        }
        return bookClaimFormMapper.selectBookClaimFormsByNoticeId(noticeId);
    }
}
