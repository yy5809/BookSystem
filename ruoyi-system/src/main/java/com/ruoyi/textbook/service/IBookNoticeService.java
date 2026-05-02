package com.ruoyi.textbook.service;

import java.util.List;
import com.ruoyi.textbook.domain.BookNotice;
import com.ruoyi.textbook.domain.BookClaimForm;

public interface IBookNoticeService {
    public BookNotice selectBookNoticeById(Long noticeId);

    public List<BookNotice> selectBookNoticeList(BookNotice bookNotice);

    public int insertBookNotice(BookNotice bookNotice);

    public int updateBookNotice(BookNotice bookNotice);

    public int deleteBookNoticeByIds(Long[] noticeIds);

    public int publishNotice(Long noticeId);

    /** 保存领书计划并自动生成领书单（合并 新建+发布 为一步） */
    public int saveAndGenerate(BookNotice bookNotice);

    public List<BookClaimForm> generateClaimForms(Long noticeId);
}
