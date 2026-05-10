package com.ruoyi.textbook.util;

import com.ruoyi.common.exception.ServiceException;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import com.ruoyi.textbook.domain.dto.TbPurchaseImportDTO;

import java.io.IOException;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.List;

import org.apache.poi.ss.usermodel.DataFormatter;

public class ExcelImportUtil {

    private static final Logger log = LoggerFactory.getLogger(ExcelImportUtil.class);

    private static final DataFormatter DATA_FORMATTER = new DataFormatter();

    public static final int COL_ISBN = 0;
    public static final int COL_BOOK_NAME = 1;
    public static final int COL_EDITION = 2;
    public static final int COL_AUTHOR = 3;
    public static final int COL_PUBLISHER = 4;
    public static final int COL_PRICE = 5;
    public static final int COL_TEXTBOOK_TYPE = 6;
    public static final int COL_COLLEGE = 7;
    public static final int COL_MAJOR = 8;
    public static final int COL_GRADE = 9;
    public static final int COL_QUANTITY = 10;
    public static final int COL_REMARK = 11;
    private static final int HEADER_ROW = 0;
    private static final int DATA_START_ROW = 1;

    public static List<TbPurchaseImportDTO> parsePurchaseExcel(org.springframework.web.multipart.MultipartFile file) throws IOException {
        List<TbPurchaseImportDTO> result = new ArrayList<>();
        try (Workbook workbook = WorkbookFactory.create(file.getInputStream())) {
            Sheet sheet = workbook.getSheetAt(0);

            if (sheet == null || sheet.getPhysicalNumberOfRows() <= DATA_START_ROW) {
                return result;
            }

            for (int i = DATA_START_ROW; i <= sheet.getLastRowNum(); i++) {
                Row row = sheet.getRow(i);
                if (row == null || isEmptyRow(row)) continue;

                try {
                    TbPurchaseImportDTO dto = new TbPurchaseImportDTO();
                    dto.setIsbn(getCellStringValue(row, COL_ISBN));
                    dto.setBookName(getCellStringValue(row, COL_BOOK_NAME));
                    dto.setEdition(getCellStringValue(row, COL_EDITION));
                    dto.setAuthor(getCellStringValue(row, COL_AUTHOR));
                    dto.setPublisher(getCellStringValue(row, COL_PUBLISHER));
                    dto.setPrice(parsePrice(row, COL_PRICE));
                    dto.setTextbookType(getCellStringValue(row, COL_TEXTBOOK_TYPE));
                    dto.setCollege(getCellStringValue(row, COL_COLLEGE));
                    dto.setMajor(getCellStringValue(row, COL_MAJOR));
                    dto.setGrade(getCellStringValue(row, COL_GRADE));
                    dto.setQuantity(parseQuantity(row, COL_QUANTITY));
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
        }
        return result;
    }

    public static void generateTemplate(OutputStream out) throws IOException {
        XSSFWorkbook workbook = new XSSFWorkbook();
        Sheet sheet = workbook.createSheet("采购单导入");

        CellStyle headerStyle = createHeaderStyle(workbook);
        Row headerRow = sheet.createRow(HEADER_ROW);

        String[] headers = {"ISBN", "教材名称", "版次", "作者", "出版社", "定价", "教材类型", "申请学院", "适用专业", "适用年级", "采购数量", "备注"};
        for (int i = 0; i < headers.length; i++) {
            Cell cell = headerRow.createCell(i);
            cell.setCellValue(headers[i]);
            cell.setCellStyle(headerStyle);
        }

        sheet.setColumnWidth(COL_ISBN, 18 * 256);
        sheet.setColumnWidth(COL_BOOK_NAME, 30 * 256);
        sheet.setColumnWidth(COL_EDITION, 10 * 256);
        sheet.setColumnWidth(COL_AUTHOR, 12 * 256);
        sheet.setColumnWidth(COL_PUBLISHER, 20 * 256);
        sheet.setColumnWidth(COL_PRICE, 10 * 256);
        sheet.setColumnWidth(COL_TEXTBOOK_TYPE, 12 * 256);
        sheet.setColumnWidth(COL_COLLEGE, 15 * 256);
        sheet.setColumnWidth(COL_MAJOR, 15 * 256);
        sheet.setColumnWidth(COL_GRADE, 15 * 256);
        sheet.setColumnWidth(COL_QUANTITY, 12 * 256);
        sheet.setColumnWidth(COL_REMARK, 25 * 256);

        Sheet conditionalSheet = workbook.createSheet("填写说明");
        String[] instructions = {
                "【采购单Excel导入说明】",
                "",
                "1. 请严格按照模板格式填写数据，不要修改表头顺序",
                "2. 列说明：",
                "   - ISBN（必填）：教材的10位或13位ISBN编号，系统根据ISBN自动匹配教材信息",
                "   - 教材名称（必填）：教材全称",
                "   - 版次（选填）：教材版次，如\"第3版\"",
                "   - 作者（选填）：教材作者，新教材建议填写以便完善信息",
                "   - 出版社（选填）：教材出版社，新教材建议填写以便完善信息",
                "   - 定价（选填）：教材单价，如 49.00",
                "   - 教材类型（选填）：如\"马工程教材\"、\"自编教材\"等",
                "   - 申请学院（必填）：从系统学院字典中选择",
                "   - 适用专业（必填）：填写本学院对应的专业简称",
                "   - 适用年级（选填）：大一/大二/大三/大四/全校",
                "   - 采购数量（必填）：正整数，范围1-9999",
                "   - 备注（选填）：补充说明信息",
                "",
                "3. 学院与专业对照表：",
                "   智能制造学院 → 机械、通信、计算机、电子、电气",
                "   环境科学与工程学院 → 园林、环工、给排、建能、人文",
                "   管理学院 → 财务、酒店、营销、人力、物流",
                "   语言文化学院 → 英语、汉语、日语、商务英语",
                "   艺术学院 → 视传、音乐学、环设",
                "   土木工程学院 → 工管、造价、土木",
                "   公共教学部 → （无需填写专业）",
                "   马克思主义学院 → （无需填写专业）",
                "",
                "4. 文件要求：",
                "   - 格式：.xlsx 或 .xls",
                "   - 大小：不超过10MB",
                "   - 行数：不超过1000行（不含表头）",
                "",
                "5. 校验规则：",
                "   - 申请学院和申请专业必须与系统字典匹配，否则校验失败",
                "   - 新ISBN会自动创建教材（信息状态为待完善），不影响导入",
                "   - 单行校验失败不会阻断整批导入，失败的行会在结果中标注原因",
                "   - 同一文件重复导入会被拦截（基于文件MD5）",
                "",
                "6. 导入流程：",
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
                return DATA_FORMATTER.formatCellValue(cell);
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
            if (d <= 0 || d > 9999) {
                throw new ServiceException("采购数量必须在1-9999之间: " + value);
            }
            return (int) Math.round(d);
        } catch (NumberFormatException e) {
            throw new ServiceException("采购数量格式错误: " + value);
        }
    }

    private static java.math.BigDecimal parsePrice(Row row, int columnIndex) {
        String value = getCellStringValue(row, columnIndex);
        if (value == null || value.trim().isEmpty()) return null;
        try {
            return new java.math.BigDecimal(value);
        } catch (NumberFormatException e) {
            throw new ServiceException("定价格式错误: " + value);
        }
    }

    private static boolean isEmptyRow(Row row) {
        for (int i = 0; i < 12; i++) {
            Cell cell = row.getCell(i);
            if (cell != null && cell.getCellType() != CellType.BLANK) {
                String value = getCellStringValue(row, i);
                if (value != null && !value.trim().isEmpty()) return false;
            }
        }
        return true;
    }
}
