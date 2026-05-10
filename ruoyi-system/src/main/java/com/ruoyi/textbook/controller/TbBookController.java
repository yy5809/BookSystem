package com.ruoyi.textbook.controller;

import java.util.List;
import java.util.Map;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.stream.Collectors;
import javax.servlet.http.HttpServletResponse;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.annotation.RateLimiter;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.textbook.domain.TbBook;
import com.ruoyi.textbook.domain.TbInventory;
import com.ruoyi.textbook.domain.dto.TbBookImportDTO;
import com.ruoyi.textbook.service.ITbBookService;
import com.ruoyi.textbook.service.ITbInventoryService;
import com.ruoyi.textbook.util.BookImportUtil;
import com.ruoyi.common.utils.SecurityUtils;

/**
 * 教材基础信息Controller
 */
@RestController
@RequestMapping("/textbook/book")
public class TbBookController extends BaseController {

    @Autowired
    private ITbBookService tbBookService;

    @Autowired
    private com.ruoyi.common.core.redis.RedisCache redisCache;

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
    public void export(HttpServletResponse response, TbBook tbBook) {
        List<TbBook> list = tbBookService.selectTbBookList(tbBook);
        ExcelUtil<TbBook> util = new ExcelUtil<TbBook>(TbBook.class);
        util.exportExcel(response, list, "教材基础信息数据");
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
        tbBook.setCreateBy(getUsername());
        return toAjax(tbBookService.insertTbBook(tbBook));
    }

    @PreAuthorize("@ss.hasPermi('textbook:book:edit') and @ss.hasAnyRoles('admin,warehouse')")
    @Log(title = "教材信息", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody TbBook tbBook) {
        tbBook.setUpdateBy(getUsername());
        return toAjax(tbBookService.updateTbBook(tbBook));
    }

    @PreAuthorize("@ss.hasPermi('textbook:book:remove') and @ss.hasAnyRoles('admin,warehouse')")
    @Log(title = "教材信息", businessType = BusinessType.DELETE)
    @DeleteMapping("/{bookId}")
    public AjaxResult remove(@PathVariable Long bookId) {
        TbInventory inv = tbBookService.checkStockBeforeDelete(bookId);
        if (inv != null && inv.getStockNum() != null && inv.getStockNum() > 0) {
            return error("该教材库存为 " + inv.getStockNum() + " 本，无法删除。请先清空库存后再操作");
        }
        return toAjax(tbBookService.deleteTbBookByBookId(bookId));
    }

    @PreAuthorize("@ss.hasPermi('textbook:book:quickAdd') and @ss.hasAnyRoles('admin,warehouse,teacher')")
    @Log(title = "教材快速新增", businessType = BusinessType.INSERT)
    @PostMapping("/quickAdd")
    public AjaxResult quickAdd(@RequestBody TbBook tbBook) {
        TbBook result = tbBookService.quickAdd(tbBook);
        return AjaxResult.success(result);
    }

    @PreAuthorize("@ss.hasPermi('textbook:book:edit') and @ss.hasAnyRoles('admin,warehouse')")
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

    @PreAuthorize("@ss.hasPermi('textbook:book:import')")
    @GetMapping("/import/template")
    public void downloadTemplate(HttpServletResponse response) throws Exception {
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setCharacterEncoding("utf-8");
        response.setHeader("Content-Disposition", "attachment;filename=教材信息导入模板.xlsx");
        BookImportUtil.generateTemplate(response.getOutputStream());
    }

    @PreAuthorize("@ss.hasPermi('textbook:book:import') and @ss.hasAnyRoles('admin,warehouse')")
    @GetMapping("/import/preview")
    public AjaxResult previewImport(@RequestParam("fileHash") String fileHash) {
        Object cache = redisCache.getCacheObject("book_import:" + fileHash);
        if (cache == null) {
            return error("预览数据已过期，请重新上传文件");
        }
        @SuppressWarnings("unchecked")
        java.util.Map<String, Object> result = (java.util.Map<String, Object>) cache;
        return AjaxResult.success(result);
    }

    @PreAuthorize("@ss.hasPermi('textbook:book:import') and @ss.hasAnyRoles('admin,warehouse')")
    @Log(title = "教材信息导入", businessType = BusinessType.IMPORT)
    @RateLimiter(count = 5, time = 60)
    @PostMapping("/import/preview")
    public AjaxResult uploadAndPreview(@RequestParam("file") MultipartFile file) throws Exception {
        String originalFilename = file.getOriginalFilename();
        if (originalFilename == null || !originalFilename.endsWith(".xlsx")) {
            return error("仅支持 .xlsx 格式的Excel文件");
        }
        if (file.getSize() > 10 * 1024 * 1024) {
            return error("文件大小不能超过10MB");
        }
        List<TbBookImportDTO> dtos = BookImportUtil.parseBookExcel(file);
        if (dtos.isEmpty()) {
            return error("Excel文件中没有有效数据");
        }
        List<TbBookImportDTO> successList = new ArrayList<>();
        List<TbBookImportDTO> failList = new ArrayList<>();
        int rowIdx = 1;
        for (TbBookImportDTO dto : dtos) {
            dto.setRowIndex(++rowIdx);
            String err = validateBookRow(dto);
            if (err == null) {
                successList.add(dto);
            } else {
                dto.setErrorMsg(err);
                failList.add(dto);
            }
        }
        String fileHash = String.valueOf(originalFilename.hashCode()) + "_" + System.currentTimeMillis();
        java.util.Map<String, Object> result = new HashMap<>();
        result.put("fileHash", fileHash);
        result.put("fileName", originalFilename);
        result.put("totalRows", dtos.size());
        result.put("successCount", successList.size());
        result.put("failCount", failList.size());
        result.put("successList", successList);
        result.put("failList", failList);
        redisCache.setCacheObject("book_import:" + fileHash, result, 30, java.util.concurrent.TimeUnit.MINUTES);
        return AjaxResult.success(result);
    }

    @PreAuthorize("@ss.hasPermi('textbook:book:import') and @ss.hasAnyRoles('admin,warehouse')")
    @Log(title = "教材信息导入确认", businessType = BusinessType.IMPORT)
    @PostMapping("/import/confirm")
    public AjaxResult confirmImport(@RequestBody Map<String, String> params) {
        String fileHash = params.get("fileHash");
        if (fileHash == null) {
            return error("参数错误");
        }
        Object cache = redisCache.getCacheObject("book_import:" + fileHash);
        if (cache == null) {
            return error("预览数据已过期，请重新上传文件");
        }
        @SuppressWarnings("unchecked")
        java.util.Map<String, Object> result = (java.util.Map<String, Object>) cache;
        @SuppressWarnings("unchecked")
        List<TbBookImportDTO> successList = (List<TbBookImportDTO>) result.get("successList");
        if (successList == null || successList.isEmpty()) {
            return error("没有可导入的有效数据");
        }
        int successCount = 0;
        int failCount = 0;
        for (TbBookImportDTO dto : successList) {
            try {
                TbBook book = new TbBook();
                book.setIsbn(dto.getIsbn());
                book.setBookName(dto.getBookName());
                book.setAuthor(dto.getAuthor());
                book.setPublisher(dto.getPublisher());
                book.setEdition(dto.getEdition());
                book.setPrice(dto.getPrice() != null && !dto.getPrice().isEmpty()
                    ? new java.math.BigDecimal(dto.getPrice()) : java.math.BigDecimal.ZERO);
                book.setTextbookType(dto.getTextbookType());
                book.setCourseName(dto.getCourseName());
                book.setMajor(dto.getMajor() != null ? dto.getMajor() : "未知");
                book.setGrade(dto.getGrade() != null ? dto.getGrade() : "未知");
                book.setInfoStatus("0");
                book.setInfoSource("0");
                book.setStatus("0");
                book.setCreateBy(SecurityUtils.getUsername());
                book.setCreateTime(new java.util.Date());
                tbBookService.insertTbBook(book);
                successCount++;
            } catch (Exception e) {
                failCount++;
            }
        }
        redisCache.deleteObject("book_import:" + fileHash);
        return success("导入完成：成功" + successCount + "条，失败" + failCount + "条");
    }

    private String validateBookRow(TbBookImportDTO dto) {
        if (dto.getIsbn() == null || dto.getIsbn().trim().isEmpty()) return "ISBN不能为空";
        if (!dto.getIsbn().matches("^\\d{10}$|^\\d{13}$")) return "ISBN格式错误，必须为10位或13位数字";
        if (dto.getBookName() == null || dto.getBookName().trim().isEmpty()) return "教材名称不能为空";
        if (dto.getAuthor() == null || dto.getAuthor().trim().isEmpty()) return "作者不能为空";
        if (dto.getPublisher() == null || dto.getPublisher().trim().isEmpty()) return "出版社不能为空";
        if (dto.getTextbookType() == null || dto.getTextbookType().trim().isEmpty()) return "教材类型不能为空";
        return null;
    }
}
