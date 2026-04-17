package com.ruoyi.system.textbook.mapper;

import java.util.List;
import com.ruoyi.system.textbook.domain.BookStockFlow;

public interface BookStockFlowMapper {
    public List<BookStockFlow> selectBookStockFlowList(BookStockFlow bookStockFlow);

    public BookStockFlow selectBookStockFlowById(Long flowId);

    public int insertBookStockFlow(BookStockFlow bookStockFlow);
}
