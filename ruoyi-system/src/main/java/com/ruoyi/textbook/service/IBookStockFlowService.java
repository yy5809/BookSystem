package com.ruoyi.textbook.service;

import java.util.List;
import com.ruoyi.textbook.domain.BookStockFlow;

public interface IBookStockFlowService {
    public List<BookStockFlow> selectBookStockFlowList(BookStockFlow bookStockFlow);
    public BookStockFlow selectBookStockFlowById(Long flowId);
}
