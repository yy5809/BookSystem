package com.ruoyi.textbook.mapper;

import java.util.List;
import com.ruoyi.textbook.domain.BookClaimFormDetail;

public interface BookClaimFormDetailMapper {
    public BookClaimFormDetail selectBookClaimFormDetailById(Long detailId);

    public List<BookClaimFormDetail> selectBookClaimFormDetailListByFormId(Long formId);

    public int insertBookClaimFormDetail(BookClaimFormDetail detail);

    public int updateBookClaimFormDetail(BookClaimFormDetail detail);

    public int deleteBookClaimFormDetailByFormId(Long formId);

    public int batchInsert(List<BookClaimFormDetail> details);
}
