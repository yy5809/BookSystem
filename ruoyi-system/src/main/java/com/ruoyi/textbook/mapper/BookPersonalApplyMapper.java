package com.ruoyi.textbook.mapper;

import java.util.List;
import java.util.Date;
import org.apache.ibatis.annotations.Param;
import com.ruoyi.textbook.domain.BookPersonalApply;

public interface BookPersonalApplyMapper {
    public BookPersonalApply selectBookPersonalApplyById(Long applyId);
    public List<BookPersonalApply> selectBookPersonalApplyList(BookPersonalApply bookPersonalApply);
    public List<BookPersonalApply> selectMyApplyList(BookPersonalApply bookPersonalApply);
    /**
     * 批量查询个人领书申请（解决N+1问题）
     */
    public List<BookPersonalApply> selectBookPersonalApplyByIds(List<Long> applyIds);
    public int insertBookPersonalApply(BookPersonalApply bookPersonalApply);
    public int updateBookPersonalApply(BookPersonalApply bookPersonalApply);
    public int restoreToApproved(@Param("applyId") Long applyId, @Param("auditOpinion") String auditOpinion, @Param("updateBy") String updateBy, @Param("updateTime") Date updateTime);
    public int deleteBookPersonalApplyByIds(Long[] applyIds);
    public int deleteBookPersonalApplyById(Long applyId);
}
