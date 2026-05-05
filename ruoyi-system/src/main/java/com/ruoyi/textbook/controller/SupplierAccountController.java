package com.ruoyi.textbook.controller;

import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletResponse;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
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
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.textbook.domain.TbSupplier;
import com.ruoyi.textbook.service.ISupplierAccountService;

@RestController
@RequestMapping("/textbook/supplierAccount")
public class SupplierAccountController extends BaseController {

    @Autowired
    private ISupplierAccountService supplierAccountService;

    @PreAuthorize("@ss.hasPermi('textbook:supplier:list')")
    @GetMapping("/list")
    public TableDataInfo list(TbSupplier supplier) {
        startPage();
        List<Map<String, Object>> list = supplierAccountService.selectSupplierAccountList(supplier);
        return getDataTable(list);
    }

    @PreAuthorize("@ss.hasPermi('textbook:supplier:query')")
    @GetMapping("/{supplierId}")
    public AjaxResult getInfo(@PathVariable Long supplierId) {
        return success(supplierAccountService.selectSupplierById(supplierId));
    }

    @PreAuthorize("@ss.hasPermi('textbook:supplier:add') and @ss.hasAnyRoles('admin,warehouse')")
    @Log(title = "供应商管理", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody Map<String, Object> params) {
        TbSupplier supplier = buildSupplier(params);
        String password = (String) params.get("password");
        supplier.setCreateBy(getUsername());
        return toAjax(supplierAccountService.insertSupplierAccount(supplier, password));
    }

    @PreAuthorize("@ss.hasPermi('textbook:supplier:edit') and @ss.hasAnyRoles('admin,warehouse')")
    @Log(title = "供应商管理", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody Map<String, Object> params) {
        TbSupplier supplier = buildSupplier(params);
        Object idObj = params.get("supplierId");
        if (idObj == null || idObj.toString().trim().isEmpty()) {
            return error("供应商ID不能为空");
        }
        supplier.setSupplierId(Long.valueOf(idObj.toString()));
        supplier.setUpdateBy(getUsername());
        return toAjax(supplierAccountService.updateSupplierAccount(supplier));
    }

    @PreAuthorize("@ss.hasPermi('textbook:supplier:remove') and @ss.hasAnyRoles('admin,warehouse')")
    @Log(title = "供应商管理", businessType = BusinessType.DELETE)
    @DeleteMapping("/{supplierIds}")
    public AjaxResult remove(@PathVariable Long[] supplierIds) {
        return toAjax(supplierAccountService.deleteSupplierAccountByIds(supplierIds));
    }

    @PreAuthorize("@ss.hasPermi('textbook:supplier:edit') and @ss.hasAnyRoles('admin,warehouse')")
    @Log(title = "供应商管理", businessType = BusinessType.UPDATE)
    @PutMapping("/resetPwd")
    public AjaxResult resetPwd(@RequestBody Map<String, String> params) {
        Object userIdObj = params.get("userId");
        if (userIdObj == null || userIdObj.toString().trim().isEmpty()) {
            return error("用户ID不能为空");
        }
        Long userId = Long.valueOf(userIdObj.toString());
        String password = params.get("password");
        if (password == null || password.trim().isEmpty()) {
            return error("密码不能为空");
        }
        return toAjax(supplierAccountService.resetSupplierPwd(userId, password, getUsername()));
    }

    @PreAuthorize("@ss.hasPermi('textbook:supplier:edit') and @ss.hasAnyRoles('admin,warehouse')")
    @Log(title = "供应商管理", businessType = BusinessType.UPDATE)
    @PutMapping("/changeStatus")
    public AjaxResult changeStatus(@RequestBody Map<String, String> params) {
        Object userIdObj = params.get("userId");
        if (userIdObj == null || userIdObj.toString().trim().isEmpty()) {
            return error("用户ID不能为空");
        }
        Long userId = Long.valueOf(userIdObj.toString());
        String status = params.get("status");
        return toAjax(supplierAccountService.changeSupplierStatus(userId, status, getUsername()));
    }

    @PreAuthorize("@ss.hasPermi('textbook:supplier:export') and @ss.hasAnyRoles('admin,warehouse')")
    @PostMapping("/export")
    public void export(HttpServletResponse response, TbSupplier supplier) {
        List<Map<String, Object>> list = supplierAccountService.selectSupplierAccountList(supplier);
        try {
            XSSFWorkbook workbook = new XSSFWorkbook();
            Sheet sheet = workbook.createSheet("供应商数据");
            CellStyle headerStyle = workbook.createCellStyle();
            Font font = workbook.createFont();
            font.setBold(true);
            headerStyle.setFont(font);

            String[] headers = {"供应商编码", "供应商名称", "登录账号", "联系人", "联系电话", "邮箱", "地址", "折扣率(%)", "付款账期", "状态"};
            Row headerRow = sheet.createRow(0);
            for (int i = 0; i < headers.length; i++) {
                Cell cell = headerRow.createCell(i);
                cell.setCellValue(headers[i]);
                cell.setCellStyle(headerStyle);
            }

            for (int i = 0; i < list.size(); i++) {
                Map<String, Object> row = list.get(i);
                Row dataRow = sheet.createRow(i + 1);
                dataRow.createCell(0).setCellValue(objToStr(row.get("supplierCode")));
                dataRow.createCell(1).setCellValue(objToStr(row.get("supplierName")));
                dataRow.createCell(2).setCellValue(objToStr(row.get("userName")));
                dataRow.createCell(3).setCellValue(objToStr(row.get("contactPerson")));
                dataRow.createCell(4).setCellValue(objToStr(row.get("contactPhone")));
                dataRow.createCell(5).setCellValue(objToStr(row.get("contactEmail")));
                dataRow.createCell(6).setCellValue(objToStr(row.get("address")));
                dataRow.createCell(7).setCellValue(objToStr(row.get("discountRate")));
                dataRow.createCell(8).setCellValue(objToStr(row.get("paymentTerms")));
                dataRow.createCell(9).setCellValue("0".equals(objToStr(row.get("status"))) ? "正常" : "停用");
            }
            int[] widths = {18, 30, 20, 12, 15, 22, 30, 12, 14, 10};
            for (int i = 0; i < widths.length; i++) {
                sheet.setColumnWidth(i, widths[i] * 256);
            }

            response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
            response.setCharacterEncoding("UTF-8");
            response.setHeader("Content-Disposition",
                    "attachment; filename=" + java.net.URLEncoder.encode("供应商数据.xlsx", "UTF-8"));
            workbook.write(response.getOutputStream());
            workbook.close();
        } catch (Exception e) {
            throw new RuntimeException("导出失败: " + e.getMessage());
        }
    }

    private TbSupplier buildSupplier(Map<String, Object> params) {
        TbSupplier s = new TbSupplier();
        s.setSupplierCode((String) params.get("supplierCode"));
        s.setSupplierName((String) params.get("supplierName"));
        s.setContactPerson((String) params.get("contactPerson"));
        s.setContactPhone((String) params.get("contactPhone"));
        s.setContactEmail((String) params.get("contactEmail"));
        s.setAddress((String) params.get("address"));
        s.setBankName((String) params.get("bankName"));
        s.setBankAccount((String) params.get("bankAccount"));
        s.setTaxNumber((String) params.get("taxNumber"));
        s.setPaymentTerms((String) params.get("paymentTerms"));
        s.setStatus((String) params.get("status"));
        if (params.get("discountRate") != null) {
            String rateStr = params.get("discountRate").toString().trim();
            if (!rateStr.isEmpty()) {
                try {
                    s.setDiscountRate(new java.math.BigDecimal(rateStr));
                } catch (NumberFormatException e) {
                    throw new ServiceException("折扣率格式不正确: " + rateStr);
                }
            }
        }
        if (params.get("userId") != null) {
            String idStr = params.get("userId").toString().trim();
            if (!idStr.isEmpty()) {
                s.setUserId(Long.valueOf(idStr));
            }
        }
        return s;
    }

    private String objToStr(Object obj) {
        return obj == null ? "" : obj.toString();
    }
}
