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
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.textbook.domain.TbBook;
import com.ruoyi.textbook.service.ITbBookService;

@RestController
@RequestMapping("/textbook/info")
public class TbInfoController extends BaseController {

    @Autowired
    private ITbBookService tbBookService;

    @PreAuthorize("@ss.hasPermi('textbook:info:list')")
    @GetMapping("/list")
    public TableDataInfo list(TbBook tbBook) {
        startPage();
        List<TbBook> list = tbBookService.selectTbBookList(tbBook);
        return getDataTable(list);
    }

    @PreAuthorize("@ss.hasPermi('textbook:info:export')")
    @Log(title = "教材信息", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public AjaxResult export(TbBook tbBook) {
        List<TbBook> list = tbBookService.selectTbBookList(tbBook);
        ExcelUtil<TbBook> util = new ExcelUtil<TbBook>(TbBook.class);
        return util.exportExcel(list, "教材信息数据");
    }

    @PreAuthorize("@ss.hasPermi('textbook:info:query')")
    @GetMapping("/info/{bookId}")
    public AjaxResult getInfo(@PathVariable Long bookId) {
        return AjaxResult.success(tbBookService.selectTbBookByBookId(bookId));
    }

    @PreAuthorize("@ss.hasPermi('textbook:info:add')")
    @Log(title = "教材信息", businessType = BusinessType.INSERT)
    @PostMapping("/add")
    public AjaxResult add(@RequestBody TbBook tbBook) {
        return toAjax(tbBookService.insertTbBook(tbBook));
    }

    @PreAuthorize("@ss.hasPermi('textbook:info:edit')")
    @Log(title = "教材信息", businessType = BusinessType.UPDATE)
    @PutMapping("/edit")
    public AjaxResult edit(@RequestBody TbBook tbBook) {
        return toAjax(tbBookService.updateTbBook(tbBook));
    }

    @PreAuthorize("@ss.hasPermi('textbook:info:remove')")
    @Log(title = "教材信息", businessType = BusinessType.DELETE)
    @DeleteMapping("/remove/{bookId}")
    public AjaxResult remove(@PathVariable Long bookId) {
        return toAjax(tbBookService.deleteTbBookByBookId(bookId));
    }
}