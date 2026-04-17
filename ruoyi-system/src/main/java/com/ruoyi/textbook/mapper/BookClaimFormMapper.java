package com.ruoyi.textbook.mapper;

import java.util.List;
import com.ruoyi.textbook.domain.BookClaimForm;
import org.apache.ibatis.annotations.Param;

public interface BookClaimFormMapper {
    public BookClaimForm selectBookClaimFormById(Long formId);

    public List<BookClaimForm> selectBookClaimFormList(BookClaimForm bookClaimForm);

    public List<BookClaimForm> selectBookClaimFormsByNoticeId(Long noticeId);

    public int insertBookClaimForm(BookClaimForm bookClaimForm);

    public int updateBookClaimForm(BookClaimForm bookClaimForm);

    public int deleteBookClaimFormById(Long formId);

    public int deleteBookClaimFormByIds(Long[] formIds);

    public int updateFormStatus(@Param("formId") Long formId, @Param("status") String status);
}
