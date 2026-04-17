package com.ruoyi.textbook.service;

import com.ruoyi.textbook.domain.TbStockLog;
import java.util.List;

public interface ITbStockLogService {
    List<TbStockLog> selectList(TbStockLog tbStockLog);
    List<TbStockLog> selectListByBookId(Long bookId);
    int insert(TbStockLog tbStockLog);
    int batchInsert(List<TbStockLog> logList);
}
