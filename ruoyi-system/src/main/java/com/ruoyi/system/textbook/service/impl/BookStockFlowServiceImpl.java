package com.ruoyi.textbook.service.impl;

import java.util.List;
import com.ruoyi.textbook.domain.BookStockFlow;
import com.ruoyi.textbook.mapper.BookStockFlowMapper;
import com.ruoyi.textbook.service.IBookStockFlowService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class BookStockFlowServiceImpl implements IBookStockFlowService {

    @Autowired
    private BookStockFlowMapper bookStockFlowMapper;

    @Override
    public List<BookStockFlow> selectBookStockFlowList(BookStockFlow bookStockFlow) {
        return bookStockFlowMapper.selectBookStockFlowList(bookStockFlow);
    }

    @Override
    public BookStockFlow selectBookStockFlowById(Long flowId) {
        return bookStockFlowMapper.selectBookStockFlowById(flowId);
    }
}
