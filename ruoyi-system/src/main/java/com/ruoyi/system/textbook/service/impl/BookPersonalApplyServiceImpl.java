package com.ruoyi.textbook.service.impl;

import java.util.Date;
import java.util.List;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.textbook.domain.BookPersonalApply;
import com.ruoyi.textbook.mapper.BookPersonalApplyMapper;
import com.ruoyi.textbook.service.IBookPersonalApplyService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class BookPersonalApplyServiceImpl implements IBookPersonalApplyService {

    @Autowired
    private BookPersonalApplyMapper bookPersonalApplyMapper;

    @Override
    public BookPersonalApply selectBookPersonalApplyById(Long applyId) {
        return bookPersonalApplyMapper.selectBookPersonalApplyById(applyId);
    }

    @Override
    public List<BookPersonalApply> selectBookPersonalApplyList(BookPersonalApply bookPersonalApply) {
        return bookPersonalApplyMapper.selectBookPersonalApplyList(bookPersonalApply);
    }

    @Override
    public List<BookPersonalApply> selectMyApplyList(BookPersonalApply bookPersonalApply) {
        if (bookPersonalApply.getTeacherId() == null) {
            bookPersonalApply.setTeacherId(SecurityUtils.getUserId());
        }
        return bookPersonalApplyMapper.selectMyApplyList(bookPersonalApply);
    }

    @Override
    public int insertBookPersonalApply(BookPersonalApply bookPersonalApply) {
        String applyNo = "SQ" + System.currentTimeMillis();
        bookPersonalApply.setApplyNo(applyNo);
        bookPersonalApply.setStatus("0");
        bookPersonalApply.setCreateBy(SecurityUtils.getUsername());
        return bookPersonalApplyMapper.insertBookPersonalApply(bookPersonalApply);
    }

    @Override
    public int updateBookPersonalApply(BookPersonalApply bookPersonalApply) {
        bookPersonalApply.setUpdateBy(SecurityUtils.getUsername());
        return bookPersonalApplyMapper.updateBookPersonalApply(bookPersonalApply);
    }

    @Override
    public int deleteBookPersonalApplyByIds(Long[] applyIds) {
        return bookPersonalApplyMapper.deleteBookPersonalApplyByIds(applyIds);
    }

    @Override
    public int auditApply(BookPersonalApply bookPersonalApply) {
        bookPersonalApply.setAuditBy(SecurityUtils.getUsername());
        bookPersonalApply.setAuditTime(new Date());
        return bookPersonalApplyMapper.updateBookPersonalApply(bookPersonalApply);
    }

    @Override
    public int issueApply(Long applyId) {
        BookPersonalApply apply = new BookPersonalApply();
        apply.setApplyId(applyId);
        apply.setStatus("3");
        apply.setIssueTime(new Date());
        apply.setUpdateBy(SecurityUtils.getUsername());
        return bookPersonalApplyMapper.updateBookPersonalApply(apply);
    }
}
