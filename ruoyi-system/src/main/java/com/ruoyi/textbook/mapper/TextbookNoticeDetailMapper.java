package com.ruoyi.textbook.mapper;

import java.util.List;
import com.ruoyi.textbook.domain.TextbookNoticeDetail;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface TextbookNoticeDetailMapper {
    List<TextbookNoticeDetail> selectByNoticeId(Long noticeId);
    int batchInsert(List<TextbookNoticeDetail> list);
    int deleteByNoticeId(Long noticeId);
    int deleteByNoticeIds(Long[] noticeIds);
}
