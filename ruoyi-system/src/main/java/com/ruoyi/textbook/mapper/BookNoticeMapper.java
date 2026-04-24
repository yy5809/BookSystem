package com.ruoyi.textbook.mapper;

import java.util.List;
import com.ruoyi.textbook.domain.BookNotice;
import org.apache.ibatis.annotations.Param;

public interface BookNoticeMapper {
    public BookNotice selectBookNoticeById(Long noticeId);

    public List<BookNotice> selectBookNoticeList(BookNotice bookNotice);

    public int insertBookNotice(BookNotice bookNotice);

    public int updateBookNotice(BookNotice bookNotice);

    public int deleteBookNoticeById(Long noticeId);

    public int deleteBookNoticeByIds(Long[] noticeIds);

    public int updateNoticeStatus(@Param("noticeId") Long noticeId, @Param("status") String status);

    public int updateNoticeStatusWithExpected(@Param("noticeId") Long noticeId, @Param("expectedStatus") String expectedStatus, @Param("newStatus") String newStatus);

    public int updateIssuedClasses(@Param("noticeId") Long noticeId, @Param("issuedClasses") Integer issuedClasses);
}
