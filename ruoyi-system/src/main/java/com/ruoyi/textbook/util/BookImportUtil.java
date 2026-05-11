package com.ruoyi.textbook.util;

import java.io.IOException;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.List;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import com.ruoyi.textbook.domain.dto.TbBookImportDTO;

public class BookImportUtil {

    private static final Logger log = LoggerFactory.getLogger(BookImportUtil.class);

    private static final DataFormatter DATA_FORMATTER = new DataFormatter();
    private static final int HEADER_ROW = 0;
    private static final int DATA_START_ROW = 1;

    public static List<TbBookImportDTO> parseBookExcel(org.springframework.web.multipart.MultipartFile file) throws IOException {
        List<TbBookImportDTO> result = new ArrayList<>();
        try (Workbook workbook = WorkbookFactory.create(file.getInputStream())) {
            Sheet sheet = workbook.getSheetAt(0);
            if (sheet == null || sheet.getPhysicalNumberOfRows() <= DATA_START_ROW) {
                return result;
            }
            for (int i = DATA_START_ROW; i <= sheet.getLastRowNum(); i++) {
                Row row = sheet.getRow(i);
                if (row == null || isEmptyRow(row)) continue;
                try {
                    TbBookImportDTO dto = new TbBookImportDTO();
                    dto.setIsbn(getCellString(row, 0));
                    dto.setBookName(getCellString(row, 1));
                    dto.setAuthor(getCellString(row, 2));
                    dto.setPublisher(getCellString(row, 3));
                    dto.setEdition(getCellString(row, 4));
                    dto.setPrice(getCellString(row, 5));
                    dto.setTextbookType(getCellString(row, 6));
                    dto.setCourseName(getCellString(row, 7));
                    dto.setMajor(getCellString(row, 8));
                    dto.setGrade(getCellString(row, 9));
                    dto.setRowIndex(i + 1);
                    if (dto.getIsbn() != null && !dto.getIsbn().trim().isEmpty()) {
                        result.add(dto);
                    }
                } catch (Exception e) {
                    log.warn("解析第{}行数据异常: {}", i + 1, e.getMessage());
                    TbBookImportDTO errorDto = new TbBookImportDTO();
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
        Sheet sheet = workbook.createSheet("教材信息导入");
        CellStyle headerStyle = createHeaderStyle(workbook);

        String[] headers = {"ISBN", "教材名称", "作者", "出版社", "版次", "定价", "教材类型", "适用课程", "适用专业", "入学年份（级）"};
        Row headerRow = sheet.createRow(HEADER_ROW);
        for (int i = 0; i < headers.length; i++) {
            Cell cell = headerRow.createCell(i);
            cell.setCellValue(headers[i]);
            cell.setCellStyle(headerStyle);
        }

        int[] widths = {18, 30, 15, 20, 10, 10, 12, 15, 15, 10};
        for (int i = 0; i < widths.length; i++) {
            sheet.setColumnWidth(i, widths[i] * 256);
        }

        Sheet infoSheet = workbook.createSheet("填写说明");
        String[] instructions = {
            "【教材信息Excel导入说明】",
            "",
            "1. 请严格按照模板格式填写数据，不要修改表头顺序",
            "2. 列说明：",
            "   - ISBN（必填）：10位或13位数字，系统根据ISBN自动匹配已有教材",
            "   - 教材名称（必填）：教材全称",
            "   - 作者（必填）：教材作者",
            "   - 出版社（必填）：教材出版社",
            "   - 版次（选填）：如\"第3版\"、\"2023年版\"",
            "   - 定价（选填）：数字，单位元，如 49.00",
            "   - 教材类型（必填）：1=公共基础课 2=专业基础课 3=专业必修课 4=专业选修课 5=思想政治课",
            "   - 适用课程（选填）：关联的课程名称",
            "   - 适用专业（选填）：如\"计算机\"、\"机械\"",
            "   - 入学年份（级）（选填）：22级/23级/24级/25级/通用，填报学生入学年份对应的\"级\"",
            "",
            "3. 文件要求：",
            "   - 格式：.xlsx 或 .xls",
            "   - 大小：不超过10MB",
            "   - 行数：不超过1000行（不含表头）",
            "",
            "4. 导入流程：",
            "   下载模板 → 填写数据 → 上传文件 → 预览校验 → 确认导入"
        };
        for (int i = 0; i < instructions.length; i++) {
            Row row = infoSheet.createRow(i);
            row.createCell(0).setCellValue(instructions[i]);
        }
        infoSheet.setColumnWidth(0, 100 * 256);

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

    private static String getCellString(Row row, int col) {
        Cell cell = row.getCell(col);
        if (cell == null) return null;
        switch (cell.getCellType()) {
            case STRING: return cell.getStringCellValue().trim();
            case NUMERIC:
                if (DateUtil.isCellDateFormatted(cell)) return cell.getDateCellValue().toString();
                return DATA_FORMATTER.formatCellValue(cell);
            case BOOLEAN: return String.valueOf(cell.getBooleanCellValue());
            case FORMULA: try { return cell.getStringCellValue(); } catch (Exception e) { return null; }
            default: return null;
        }
    }

    private static boolean isEmptyRow(Row row) {
        for (int i = 0; i < 10; i++) {
            Cell cell = row.getCell(i);
            if (cell != null && cell.getCellType() != CellType.BLANK) {
                String v = getCellString(row, i);
                if (v != null && !v.trim().isEmpty()) return false;
            }
        }
        return true;
    }
}
