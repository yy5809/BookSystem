package com.ruoyi.textbook.controller;

import java.io.IOException;
import java.io.InputStream;
import java.security.MessageDigest;
import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletResponse;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.annotation.RateLimiter;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.common.utils.file.FileUtils;
import com.ruoyi.textbook.domain.dto.TbPurchaseImportDTO;
import com.ruoyi.textbook.service.IPurchaseImportService;
import com.ruoyi.textbook.util.ExcelImportUtil;

@RestController
@RequestMapping("/textbook/purchase/import")
public class PurchaseImportController extends BaseController {

    @Autowired
    private IPurchaseImportService purchaseImportService;

    private String calculateFileMD5(MultipartFile file) throws Exception {
        MessageDigest md = MessageDigest.getInstance("MD5");
        try (InputStream is = file.getInputStream()) {
            byte[] buffer = new byte[8192];
            int read;
            while ((read = is.read(buffer)) != -1) {
                md.update(buffer, 0, read);
            }
        }
        byte[] digest = md.digest();
        StringBuilder sb = new StringBuilder();
        for (byte b : digest) {
            sb.append(String.format("%02x", b));
        }
        return sb.toString();
    }

    @PreAuthorize("@ss.hasPermi('textbook:import:excel') and @ss.hasAnyRoles('admin,warehouse')")
    @Log(title = "采购单Excel导入", businessType = BusinessType.IMPORT)
    @RateLimiter(count = 5, time = 60)
    @PostMapping("/excel")
    public AjaxResult importExcel(@RequestParam("file") MultipartFile file) throws Exception {
        String originalFilename = file.getOriginalFilename();
        if (originalFilename == null || !originalFilename.endsWith(".xlsx")) {
            return error("仅支持 .xlsx 格式的Excel文件");
        }

        String contentType = file.getContentType();
        if (contentType != null && !contentType.equals("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")
                && !contentType.equals("application/octet-stream")) {
            return error("文件Content-Type不合法，仅支持Excel文件");
        }

        if (file.getSize() > 10 * 1024 * 1024) {
            return error("文件大小不能超过10MB");
        }

        String fileHash = calculateFileMD5(file);

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