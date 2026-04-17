package com.ruoyi.textbook.service;

import java.util.List;
import com.ruoyi.textbook.domain.BookClaimForm;
import com.ruoyi.textbook.domain.BookClaimFormDetail;

public interface IBookClaimFormService {
    public BookClaimForm selectBookClaimFormById(Long formId);

    public List<BookClaimForm> selectBookClaimFormList(BookClaimForm bookClaimForm);

    public List<BookClaimForm> selectBookClaimFormsByNoticeId(Long noticeId);

    public int insertBookClaimForm(BookClaimForm bookClaimForm);

    public int updateBookClaimForm(BookClaimForm bookClaimForm);

    public int deleteBookClaimFormByIds(Long[] formIds);

    public int confirmOutbound(Long formId, Long operatorId, String operatorName,
                              Integer issuedQty, String receiverName);

    public List<BookClaimFormDetail> selectDetailsByFormId(Long formId);
}
