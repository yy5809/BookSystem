package com.ruoyi.textbook.controller;

import java.util.List;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.system.textbook.domain.BookStockFlow;
import com.ruoyi.system.textbook.service.IBookStockFlowService;

@RestController
@RequestMapping("/textbook/stockFlow")
public class BookStockFlowController extends BaseController {

    @Autowired
    private IBookStockFlowService bookStockFlowService;

    @PreAuthorize("@ss.hasPermi('textbook:stockFlow:list')")
    @GetMapping("/list")
    public TableDataInfo list(BookStockFlow bookStockFlow) {
        startPage();
        List<BookStockFlow> list = bookStockFlowService.selectBookStockFlowList(bookStockFlow);
        return getDataTable(list);
    }

    @PreAuthorize("@ss.hasPermi('textbook:stockFlow:list')")
    @GetMapping(value = "/{flowId}")
    public AjaxResult getInfo(@PathVariable("flowId") Long flowId) {
        return success(bookStockFlowService.selectBookStockFlowById(flowId));
    }
}