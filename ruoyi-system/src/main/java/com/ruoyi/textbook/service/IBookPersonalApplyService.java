package com.ruoyi.textbook.service;

import java.util.List;
import com.ruoyi.textbook.domain.BookPersonalApply;

public interface IBookPersonalApplyService {
    public BookPersonalApply selectBookPersonalApplyById(Long applyId);
    public List<BookPersonalApply> selectBookPersonalApplyList(BookPersonalApply bookPersonalApply);
    public List<BookPersonalApply> selectMyApplyList(BookPersonalApply bookPersonalApply);
    public int insertBookPersonalApply(BookPersonalApply bookPersonalApply);
    public int updateBookPersonalApply(BookPersonalApply bookPersonalApply);
    public int deleteBookPersonalApplyByIds(Long[] applyIds);
    public int auditApply(BookPersonalApply bookPersonalApply);
    public int issueApply(Long applyId, Integer receivedQty, String location, String remark);
    public int cancelApply(Long applyId, Long currentUserId);

    /**
     * 教师一键缺书登记（由已驳回的领书申请创建缺书记录）
     */
    public int registerShortageFromApply(Long applyId);
}
