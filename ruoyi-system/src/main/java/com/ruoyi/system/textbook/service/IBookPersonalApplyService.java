package com.ruoyi.system.textbook.service;

import java.util.List;
import com.ruoyi.system.textbook.domain.BookPersonalApply;

public interface IBookPersonalApplyService {
    public BookPersonalApply selectBookPersonalApplyById(Long applyId);

    public List<BookPersonalApply> selectBookPersonalApplyList(BookPersonalApply bookPersonalApply);

    public List<BookPersonalApply> selectMyApplyList(BookPersonalApply bookPersonalApply);

    public int insertBookPersonalApply(BookPersonalApply bookPersonalApply);

    public int updateBookPersonalApply(BookPersonalApply bookPersonalApply);

    public int deleteBookPersonalApplyByIds(Long[] applyIds);

    public int auditApply(BookPersonalApply bookPersonalApply);

    public int issueApply(Long applyId);
}
