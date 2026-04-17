package com.ruoyi.system.textbook.service;

import java.util.List;
import com.ruoyi.system.textbook.domain.BookStockFlow;

public interface IBookStockFlowService {
    public List<BookStockFlow> selectBookStockFlowList(BookStockFlow bookStockFlow);

    public BookStockFlow selectBookStockFlowById(Long flowId);
}
