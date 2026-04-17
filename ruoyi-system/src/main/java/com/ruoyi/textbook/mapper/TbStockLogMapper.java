package com.ruoyi.textbook.mapper;

import java.util.List;
import com.ruoyi.textbook.domain.TbStockLog;
import org.apache.ibatis.annotations.Param;

public interface TbStockLogMapper {
    List<TbStockLog> selectList(TbStockLog tbStockLog);
    List<TbStockLog> selectListByBookId(Long bookId);
    int insert(TbStockLog tbStockLog);
    int batchInsert(@Param("list") List<TbStockLog> logList);
}
