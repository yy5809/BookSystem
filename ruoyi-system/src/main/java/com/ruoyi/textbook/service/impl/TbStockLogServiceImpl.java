package com.ruoyi.textbook.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.textbook.domain.TbStockLog;
import com.ruoyi.textbook.mapper.TbStockLogMapper;
import com.ruoyi.textbook.service.ITbStockLogService;

@Service
public class TbStockLogServiceImpl implements ITbStockLogService {

    @Autowired
    private TbStockLogMapper tbStockLogMapper;

    @Override
    public List<TbStockLog> selectList(TbStockLog tbStockLog) {
        return tbStockLogMapper.selectList(tbStockLog);
    }

    @Override
    public List<TbStockLog> selectListByBookId(Long bookId) {
        return tbStockLogMapper.selectListByBookId(bookId);
    }

    @Override
    public int insert(TbStockLog tbStockLog) {
        return tbStockLogMapper.insert(tbStockLog);
    }

    @Override
    public int batchInsert(List<TbStockLog> logList) {
        if (logList == null || logList.isEmpty()) {
            return 0;
        }
        return tbStockLogMapper.batchInsert(logList);
    }
}
