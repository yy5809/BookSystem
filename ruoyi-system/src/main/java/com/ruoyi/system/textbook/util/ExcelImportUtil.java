package com.ruoyi.textbook.util;

import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import com.ruoyi.textbook.domain.dto.TbPurchaseImportDTO;

import java.io.IOException;
import java.io.OutputStream;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

public class ExcelImportUtil {

    private static final Logger log = LoggerFactory.getLogger(ExcelImportUtil.class);

    public static final int COL_ISBN = 0;
    public static final int COL_BOOK_NAME = 1;
    public static final int COL_QUANTITY = 2;
    public static final int COL_COLLEGE = 3;
    public static final int COL_MAJOR = 4;
    public static final int COL_CLASS = 5;
    public static final int COL_REMARK = 6;
    private static final int HEADER_ROW = 0;
    private static final int DATA_START_ROW = 1;

    public static List<TbPurchaseImportDTO> parsePurchaseExcel(org.springframework.web.multipart.MultipartFile file) throws IOException {
        List<TbPurchaseImportDTO> result = new ArrayList<>();
        Workbook workbook = WorkbookFactory.create(file.getInputStream());
        Sheet sheet = workbook.getSheetAt(0);

        if (sheet == null || sheet.getPhysicalNumberOfRows() <= DATA_START_ROW) {
            workbook.close();
            return result;
        }

        for (int i = DATA_START_ROW; i <= sheet.getLastRowNum(); i++) {
            Row row = sheet.getRow(i);
            if (row == null || isEmptyRow(row)) continue;

            try {
                TbPurchaseImportDTO dto = new TbPurchaseImportDTO();
                dto.setIsbn(getCellStringValue(row, COL_ISBN));
                dto.setBookName(getCellStringValue(row, COL_BOOK_NAME));
                dto.setQuantity(parseQuantity(row, COL_QUANTITY));
                dto.setCollege(getCellStringValue(row, COL_COLLEGE));
                dto.setMajor(getCellStringValue(row, COL_MAJOR));
                dto.setClassName(getCellStringValue(row, COL_CLASS));
                dto.setRemark(getCellStringValue(row, COL_REMARK));

                if (dto.getIsbn() != null && !dto.getIsbn().trim().isEmpty()) {
                    result.add(dto);
                }
            } catch (Exception e) {
                log.warn("解析第{}行数据异常: {}", i + 1, e.getMessage());
                TbPurchaseImportDTO errorDto = new TbPurchaseImportDTO();
                errorDto.setErrorMsg("行数据解析异常: " + e.getMessage());
                errorDto.setRowIndex(i + 1);
                result.add(errorDto);
            }
        }

        workbook.close();
        return result;
    }

    public static void generateTemplate(OutputStream out) throws IOException {
        XSSFWorkbook workbook = new XSSFWorkbook();
        Sheet sheet = workbook.createSheet("采购单导入");

        CellStyle headerStyle = createHeaderStyle(workbook);
        Row headerRow = sheet.createRow(HEADER_ROW);

        String[] headers = {"ISBN", "教材名称", "采购数量", "申请学院", "申请专业", "适用班级", "备注"};
        for (int i = 0; i < headers.length; i++) {
            Cell cell = headerRow.createCell(i);
            cell.setCellValue(headers[i]);
            cell.setCellStyle(headerStyle);
        }

        String[] exampleData = {"9787111111111", "Java程序设计", "50", "计算机学院", "软件工程", "计科2301、2302", "示例数据，请删除后填写实际内容"};
        Row exampleRow = sheet.createRow(DATA_START_ROW);
        for (int i = 0; i < exampleData.length; i++) {
            exampleRow.createCell(i).setCellValue(exampleData[i]);
        }

        sheet.setColumnWidth(COL_ISBN, 18 * 256);
        sheet.setColumnWidth(COL_BOOK_NAME, 30 * 256);
        sheet.setColumnWidth(COL_QUANTITY, 12 * 256);
        sheet.setColumnWidth(COL_COLLEGE, 15 * 256);
        sheet.setColumnWidth(COL_MAJOR, 15 * 256);
        sheet.setColumnWidth(COL_CLASS, 20 * 256);
        sheet.setColumnWidth(COL_REMARK, 25 * 256);

        Sheet conditionalSheet = workbook.createSheet("填写说明");
        String[] instructions = {
                "【采购单Excel导入说明】",
                "",
                "1. 请严格按照模板格式填写数据，不要修改表头顺序",
                "2. 列说明：",
                "   - ISBN（必填）：教材的10位或13位ISBN编号，必须与系统中已存在的教材一致",
                "   - 教材名称（必填）：用于校验，系统会自动比对是否与ISBN对应",
                "   - 采购数量（必填）：正整数，范围1-9999",
                "   - 申请学院（必填）：如 计算机学院、数学学院等",
                "   - 申请专业（必填）：如 软件工程、计算机科学与技术等",
                "   - 适用班级（选填）：如 计科2301、2302，多个班级用顿号分隔",
                "   - 备注（选填）：补充说明信息",
                "",
                "3. 文件要求：",
                "   - 格式：.xlsx 或 .xls",
                "   - 大小：不超过10MB",
                "   - 行数：不超过1000行（不含表头）",
                "",
                "4. 校验规则：",
                "   - ISBN必须在系统中存在，否则该行会标记为失败",
                "   - 单行校验失败不会阻断整批导入，失败的行会在结果中标注原因",
                "   - 同一文件重复导入会被拦截（基于文件MD5）",
                "",
                "5. 导入流程：",
                "   上传 → 前端校验(格式/大小/行数) → 后端逐行校验 → 预览结果 → 确认导入 → 生成采购单"
        };

        for (int i = 0; i < instructions.length; i++) {
            Row row = conditionalSheet.createRow(i);
            row.createCell(0).setCellValue(instructions[i]);
        }
        conditionalSheet.setColumnWidth(0, 100 * 256);

        workbook.write(out);
        workbook.close();
    }

    private static CellStyle createHeaderStyle(Workbook workbook) {
        CellStyle style = workbook.createCellStyle();
        Font font = workbook.createFont();
        font.setBold(true);
        style.setFont(font);
        style.setFillForegroundColor(IndexedColors.LIGHT_CORNFLOWER_BLUE.getIndex());
        style.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        style.setBorderBottom(BorderStyle.THIN);
        style.setBorderTop(BorderStyle.THIN);
        style.setBorderLeft(BorderStyle.THIN);
        style.setBorderRight(BorderStyle.THIN);
        return style;
    }

    private static String getCellStringValue(Row row, int columnIndex) {
        Cell cell = row.getCell(columnIndex);
        if (cell == null) return null;

        switch (cell.getCellType()) {
            case STRING: return cell.getStringCellValue().trim();
            case NUMERIC:
                if (DateUtil.isCellDateFormatted(cell)) {
                    return cell.getDateCellValue().toString();
                }
                BigDecimal val = BigDecimal.valueOf(cell.getNumericCellValue());
                return val.stripTrailingZeros().toPlainString();
            case BOOLEAN: return String.valueOf(cell.getBooleanCellValue());
            case FORMULA: try { return cell.getStringCellValue(); } catch (Exception e) { return null; }
            default: return null;
        }
    }

    private static Integer parseQuantity(Row row, int columnIndex) {
        String value = getCellStringValue(row, columnIndex);
        if (value == null || value.trim().isEmpty()) return null;
        try {
            double d = Double.parseDouble(value);
            return (int) d;
        } catch (NumberFormatException e) {
            throw new RuntimeException("采购数量格式错误: " + value);
        }
    }

    private static boolean isEmptyRow(Row row) {
        for (int i = 0; i < 7; i++) {
            Cell cell = row.getCell(i);
            if (cell != null && cell.getCellType() != CellType.BLANK) {
                String value = getCellStringValue(row, i);
                if (value != null && !value.trim().isEmpty()) return false;
            }
        }
        return true;
    }
}
