package com.ruoyi.system.textbook.controller;

import java.io.IOException;
import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletResponse;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.common.utils.file.FileUtils;
import com.ruoyi.textbook.domain.dto.TbPurchaseImportDTO;
import com.ruoyi.textbook.service.IPurchaseImportService;
import com.ruoyi.system.textbook.util.ExcelImportUtil;

@RestController
@RequestMapping("/textbook/purchase/import")
public class PurchaseImportController extends BaseController {

    @Autowired
    private IPurchaseImportService purchaseImportService;

    @PreAuthorize("@ss.hasPermi('textbook:import:excel')")
    @Log(title = "采购单Excel导入", businessType = BusinessType.IMPORT)
    @PostMapping("/excel")
    public AjaxResult importExcel(@RequestParam("file") MultipartFile file) throws Exception {
        String originalFilename = file.getOriginalFilename();
        if (originalFilename == null || (!originalFilename.endsWith(".xlsx") && !originalFilename.endsWith(".xls"))) {
            return error("仅支持 .xlsx 或 .xls 格式的Excel文件");
        }

        if (file.getSize() > 10 * 1024 * 1024) {
            return error("文件大小不能超过10MB");
        }

        String fileHash = originalFilename + "_" + file.getSize() + "_" + System.currentTimeMillis();

        List<TbPurchaseImportDTO> dataList = ExcelImportUtil.parsePurchaseExcel(file);
        if (dataList == null || dataList.isEmpty()) {
            return error("Excel文件中没有有效数据或格式不正确");
        }

        if (dataList.size() > 1000) {
            return error("单次导入不能超过1000行数据");
        }

        Map<String, Object> result = purchaseImportService.importFromExcel(
                dataList,
                SecurityUtils.getUserId(),
                SecurityUtils.getUsername(),
                fileHash
        );

        result.put("fileName", originalFilename);
        return success(result);
    }

    @PreAuthorize("@ss.hasPermi('textbook:import:excel')")
    @GetMapping("/template")
    public void downloadTemplate(HttpServletResponse response) throws IOException {
        String fileName = "采购单导入模板.xlsx";
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        FileUtils.setAttachmentResponseHeader(response, fileName);
        ExcelImportUtil.generateTemplate(response.getOutputStream());
    }
}
