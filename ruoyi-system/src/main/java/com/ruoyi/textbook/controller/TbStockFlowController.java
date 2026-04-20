package com.ruoyi.textbook.controller;

import java.util.List;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.textbook.domain.TbStockLog;
import com.ruoyi.textbook.service.ITbStockLogService;

@RestController
@RequestMapping("/textbook/stock/flow")
public class TbStockFlowController extends BaseController {

    @Autowired
    private ITbStockLogService tbStockLogService;

    @PreAuthorize("@ss.hasPermi('textbook:stock:flow:list')")
    @GetMapping("/list")
    public TableDataInfo list(TbStockLog query) {
        startPage();
        return getDataTable(tbStockLogService.selectList(query));
    }

    @PreAuthorize("@ss.hasPermi('textbook:stock:flow:query')")
    @GetMapping("/info/{flowId}")
    public AjaxResult getInfo(@PathVariable Long flowId) {
        return AjaxResult.success(tbStockLogService.selectListByBookId(flowId));
    }

    @PreAuthorize("@ss.hasPermi('textbook:stock:flow:query')")
    @GetMapping("/byBook/{bookId}")
    public TableDataInfo getByBookId(@PathVariable Long bookId) {
        startPage();
        return getDataTable(tbStockLogService.selectListByBookId(bookId));
    }
}
