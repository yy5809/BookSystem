package com.ruoyi.textbook.util;

import com.itextpdf.text.*;
import com.itextpdf.text.pdf.BaseFont;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfWriter;
import com.ruoyi.textbook.domain.BookClaimForm;
import com.ruoyi.textbook.domain.BookClaimFormDetail;

import java.io.OutputStream;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.List;

public class ClaimFormPdfUtil {

    private static Font titleFont;
    private static Font headerFont;
    private static Font normalFont;
    private static Font smallFont;

    static {
        try {
            BaseFont bfChinese = BaseFont.createFont("STSong-Light", "UniGB-UCS2-H", BaseFont.NOT_EMBEDDED);
            titleFont = new Font(bfChinese, 18, Font.BOLD);
            headerFont = new Font(bfChinese, 10, Font.BOLD);
            normalFont = new Font(bfChinese, 9, Font.NORMAL);
            smallFont = new Font(bfChinese, 8, Font.NORMAL);
        } catch (Exception e) {
            titleFont = new Font(Font.FontFamily.HELVETICA, 18, Font.BOLD);
            headerFont = new Font(Font.FontFamily.HELVETICA, 10, Font.BOLD);
            normalFont = new Font(Font.FontFamily.HELVETICA, 9, Font.NORMAL);
            smallFont = new Font(Font.FontFamily.HELVETICA, 8, Font.NORMAL);
        }
    }

    public static void generatePdf(BookClaimForm form, List<BookClaimFormDetail> details, OutputStream out) throws Exception {
        Document document = new Document(PageSize.A4, 50, 50, 50, 50);
        PdfWriter.getInstance(document, out);
        document.open();

        Paragraph title = new Paragraph("\u6559\u6750\u9886\u4e66\u5355", titleFont);
        title.setAlignment(Element.ALIGN_CENTER);
        title.setSpacingAfter(20);
        document.add(title);

        PdfPTable infoTable = new PdfPTable(4);
        infoTable.setWidthPercentage(100);
        infoTable.setWidths(new float[]{1.2f, 2f, 1.2f, 2f});

        addInfoCell(infoTable, "\u9886\u4e66\u5355\u53f7\uff1a", form.getFormNo());
        addInfoCell(infoTable, "\u73ed\u7ea7\uff1a", form.getClassName());
        addInfoCell(infoTable, "\u72b6\u6001\uff1a", getStatusText(form.getStatus()));
        addInfoCell(infoTable, "\u9886\u4e66\u4eba\uff1a", form.getReceiverName() != null ? form.getReceiverName() : "");
        if (form.getCollegeId() != null && form.getCollegeId() > 0) {
            addInfoCell(infoTable, "\u5b66\u9662\uff1a", form.getCollegeId().toString());
        } else {
            addInfoCell(infoTable, "\u5b66\u9662\uff1a", "-");
        }
        if (form.getMajorId() != null && form.getMajorId() > 0) {
            addInfoCell(infoTable, "\u4e13\u4e1a\uff1a", form.getMajorId().toString());
        } else {
            addInfoCell(infoTable, "\u4e13\u4e1a\uff1a", "-");
        }
        addInfoCell(infoTable, "\u5e94\u53d1\u603b\u6570\uff1a", form.getPlannedQty() != null ? form.getPlannedQty() + " \u672c" : "");
        addInfoCell(infoTable, "\u5b9e\u53d1\u603b\u6570\uff1a", form.getIssuedQty() != null ? form.getIssuedQty() + " \u672c" : "");
        addInfoCell(infoTable, "\u51fa\u5e93\u65f6\u95f4\uff1a", form.getIssueTime() != null ? new SimpleDateFormat("yyyy-MM-dd HH:mm").format(form.getIssueTime()) : "");
        addInfoCell(infoTable, "\u5907\u6ce8\uff1a", form.getRemark() != null ? form.getRemark() : "");

        document.add(infoTable);
        document.add(Chunk.NEWLINE);

        PdfPTable detailTable = new PdfPTable(8);
        detailTable.setWidthPercentage(100);
        detailTable.setWidths(new float[]{0.6f, 1.5f, 2.5f, 1f, 1.2f, 0.7f, 0.8f, 0.8f});

        String[] headers = {"\u5e8f\u53f7", "ISBN", "\u6559\u6750\u540d\u79f0", "\u4f5c\u8005", "\u51fa\u7248\u793e", "\u5b9a\u4ef7", "\u5e94\u53d1", "\u5b9e\u53d1"};
        for (String h : headers) {
            PdfPCell cell = new PdfPCell(new Phrase(h, headerFont));
            cell.setHorizontalAlignment(Element.ALIGN_CENTER);
            cell.setBackgroundColor(BaseColor.LIGHT_GRAY);
            cell.setPadding(5);
            detailTable.addCell(cell);
        }

        BigDecimal totalPrice = BigDecimal.ZERO;
        int idx = 1;
        for (BookClaimFormDetail d : details) {
            addDetailCell(detailTable, String.valueOf(idx++), Element.ALIGN_CENTER);
            addDetailCell(detailTable, d.getIsbn() != null ? d.getIsbn() : "", Element.ALIGN_CENTER);
            addDetailCell(detailTable, d.getBookName() != null ? d.getBookName() : "", Element.ALIGN_LEFT);
            addDetailCell(detailTable, d.getAuthor() != null ? d.getAuthor() : "", Element.ALIGN_CENTER);
            addDetailCell(detailTable, d.getPublisher() != null ? d.getPublisher() : "", Element.ALIGN_CENTER);
            addDetailCell(detailTable, d.getPrice() != null ? "¥" + d.getPrice().toString() : "", Element.ALIGN_RIGHT);
            addDetailCell(detailTable, d.getPlannedQty() != null ? d.getPlannedQty().toString() : "0", Element.ALIGN_CENTER);
            addDetailCell(detailTable, d.getIssuedQty() != null ? d.getIssuedQty().toString() : "0", Element.ALIGN_CENTER);
            if (d.getPrice() != null && d.getIssuedQty() != null) {
                totalPrice = totalPrice.add(d.getPrice().multiply(new BigDecimal(d.getIssuedQty())));
            }
        }

        document.add(detailTable);
        document.add(Chunk.NEWLINE);

        Paragraph total = new Paragraph("\u5408\u8ba1\u91d1\u989d\uff1a\u00a5" + totalPrice.setScale(2, BigDecimal.ROUND_HALF_UP).toString(), normalFont);
        total.setAlignment(Element.ALIGN_RIGHT);
        document.add(total);

        document.add(Chunk.NEWLINE);
        document.add(Chunk.NEWLINE);

        PdfPTable signTable = new PdfPTable(3);
        signTable.setWidthPercentage(100);
        signTable.setWidths(new float[]{1f, 1f, 1f});

        addSignCell(signTable, "\u9886\u4e66\u4eba\u7b7e\u5b57\uff1a");
        addSignCell(signTable, "\u5e93\u7ba1\u5458\u7b7e\u5b57\uff1a");
        addSignCell(signTable, "\u65e5\u671f\uff1a");

        document.add(signTable);

        Paragraph footer = new Paragraph("\u672c\u5355\u4e00\u5f0f\u4e24\u4efd\uff0c\u9886\u4e66\u4eba\u4e00\u4efd\uff0c\u4ed3\u5e93\u7559\u5b58\u4e00\u4efd", smallFont);
        footer.setAlignment(Element.ALIGN_CENTER);
        footer.setSpacingBefore(20);
        document.add(footer);

        document.close();
    }

    private static void addInfoCell(PdfPTable table, String label, String value) {
        PdfPCell labelCell = new PdfPCell(new Phrase(label, normalFont));
        labelCell.setBorder(Rectangle.NO_BORDER);
        labelCell.setPadding(4);
        table.addCell(labelCell);

        PdfPCell valueCell = new PdfPCell(new Phrase(value, normalFont));
        valueCell.setBorder(Rectangle.NO_BORDER);
        valueCell.setPadding(4);
        table.addCell(valueCell);
    }

    private static void addDetailCell(PdfPTable table, String text, int align) {
        PdfPCell cell = new PdfPCell(new Phrase(text, normalFont));
        cell.setHorizontalAlignment(align);
        cell.setPadding(4);
        table.addCell(cell);
    }

    private static void addSignCell(PdfPTable table, String text) {
        PdfPCell cell = new PdfPCell(new Phrase(text, normalFont));
        cell.setBorder(Rectangle.NO_BORDER);
        cell.setPadding(8);
        cell.setFixedHeight(40);
        table.addCell(cell);
    }

    private static String getStatusText(String status) {
        if ("0".equals(status)) return "\u5f85\u9886\u53d6";
        if ("1".equals(status)) return "\u90e8\u5206\u51fa\u5e93";
        if ("2".equals(status)) return "\u5df2\u51fa\u5e93";
        return status != null ? status : "";
    }
}
