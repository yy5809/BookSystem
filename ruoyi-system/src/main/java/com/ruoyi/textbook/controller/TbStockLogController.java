package com.ruoyi.textbook.controller;

import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.textbook.domain.TbStockLog;
import com.ruoyi.textbook.service.ITbStockLogService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/textbook/stockLog")
public class TbStockLogController extends BaseController {

    @Autowired
    private ITbStockLogService tbStockLogService;

    @PreAuthorize("@ss.hasPermi('textbook:inventory:query')")
    @GetMapping("/list")
    public TableDataInfo list(TbStockLog tbStockLog) {
        startPage();
        return getDataTable(tbStockLogService.selectList(tbStockLog));
    }

    @PreAuthorize("@ss.hasPermi('textbook:inventory:query')")
    @GetMapping("/byBook/{bookId}")
    public TableDataInfo listByBookId(@PathVariable Long bookId) {
        startPage();
        return getDataTable(tbStockLogService.selectListByBookId(bookId));
    }
}
