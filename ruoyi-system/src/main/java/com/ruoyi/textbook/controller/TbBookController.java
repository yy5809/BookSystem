package com.ruoyi.textbook.controller;

import java.util.List;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.textbook.domain.TbBook;
import com.ruoyi.textbook.service.ITbBookService;

/**
 * 教材基础信息Controller
 */
@RestController
@RequestMapping("/textbook/book")
public class TbBookController extends BaseController {

    @Autowired
    private ITbBookService tbBookService;

    /**
     * 查询教材基础信息列表
     */
    @PreAuthorize("@ss.hasPermi('textbook:book:list')")
    @GetMapping("/list")
    public TableDataInfo list(TbBook tbBook) {
        startPage();
        List<TbBook> list = tbBookService.selectTbBookList(tbBook);
        return getDataTable(list);
    }

    /**
     * 导出教材基础信息列表
     */
    @PreAuthorize("@ss.hasPermi('textbook:book:export')")
    @Log(title = "教材基础信息", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public AjaxResult export(TbBook tbBook) {
        List<TbBook> list = tbBookService.selectTbBookList(tbBook);
        ExcelUtil<TbBook> util = new ExcelUtil<TbBook>(TbBook.class);
        return util.exportExcel(list, "教材基础信息数据");
    }

    /**
     * 获取教材基础信息详细信息
     */
    @PreAuthorize("@ss.hasPermi('textbook:book:query')")
    @GetMapping("/{bookId}")
    public AjaxResult getInfo(@PathVariable("bookId") Long bookId) {
        return AjaxResult.success(tbBookService.selectTbBookByBookId(bookId));
    }

    /**
     * 新增教材基础信息
     */
    @PreAuthorize("@ss.hasPermi('textbook:book:add') and @ss.hasAnyRoles('admin,warehouse')")
    @Log(title = "教材信息", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody TbBook tbBook) {
        return toAjax(tbBookService.insertTbBook(tbBook));
    }

    @PreAuthorize("@ss.hasPermi('textbook:book:edit') and @ss.hasAnyRoles('admin,warehouse')")
    @Log(title = "教材信息", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody TbBook tbBook) {
        return toAjax(tbBookService.updateTbBook(tbBook));
    }

    @PreAuthorize("@ss.hasPermi('textbook:book:remove') and @ss.hasAnyRoles('admin,warehouse')")
    @Log(title = "教材信息", businessType = BusinessType.DELETE)
    @DeleteMapping("/{bookId}")
    public AjaxResult remove(@PathVariable Long bookId) {
        return toAjax(tbBookService.deleteTbBookByBookId(bookId));
    }

    @PreAuthorize("@ss.hasPermi('textbook:book:quickAdd')")
    @Log(title = "教材快速新增", businessType = BusinessType.INSERT)
    @PostMapping("/quickAdd")
    public AjaxResult quickAdd(@RequestBody TbBook tbBook) {
        TbBook result = tbBookService.quickAdd(tbBook);
        return AjaxResult.success(result);
    }

    @PreAuthorize("@ss.hasPermi('textbook:book:edit')")
    @Log(title = "补充完善教材信息", businessType = BusinessType.UPDATE)
    @PutMapping("/completeInfo")
    public AjaxResult completeInfo(@RequestBody TbBook tbBook) {
        tbBookService.completeInfo(tbBook);
        return AjaxResult.success();
    }

    @PreAuthorize("@ss.hasPermi('textbook:book:query')")
    @GetMapping("/searchList")
    public AjaxResult searchList(@RequestParam String query) {
        return AjaxResult.success(tbBookService.searchBookList(query));
    }

    @PreAuthorize("@ss.hasPermi('textbook:book:query')")
    @GetMapping("/countIncomplete")
    public AjaxResult countIncomplete() {
        return AjaxResult.success(tbBookService.countIncompleteBook());
    }
}
