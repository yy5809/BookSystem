package com.ruoyi.textbook.mapper;

import java.util.List;
import com.ruoyi.textbook.domain.BookPersonalApply;

public interface BookPersonalApplyMapper {
    public BookPersonalApply selectBookPersonalApplyById(Long applyId);
    public List<BookPersonalApply> selectBookPersonalApplyList(BookPersonalApply bookPersonalApply);
    public List<BookPersonalApply> selectMyApplyList(BookPersonalApply bookPersonalApply);
    public int insertBookPersonalApply(BookPersonalApply bookPersonalApply);
    public int updateBookPersonalApply(BookPersonalApply bookPersonalApply);
    public int deleteBookPersonalApplyByIds(Long[] applyIds);
    public int deleteBookPersonalApplyById(Long applyId);
}
