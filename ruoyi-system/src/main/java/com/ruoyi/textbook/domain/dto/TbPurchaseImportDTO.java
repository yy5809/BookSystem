package com.ruoyi.textbook.domain.dto;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.ruoyi.common.annotation.Excel;
import javax.validation.constraints.Max;
import javax.validation.constraints.Min;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.Pattern;
import javax.validation.constraints.Size;

public class TbPurchaseImportDTO {

    @Excel(name = "ISBN", sort = 0, width = 20)
    @NotBlank(message = "ISBN不能为空")
    @Pattern(regexp = "^(\\d{10}|\\d{13})$", message = "ISBN格式错误，必须为10位或13位数字")
    private String isbn;

    @Excel(name = "教材名称", sort = 1, width = 30)
    @NotBlank(message = "教材名称不能为空")
    @Size(max = 200, message = "教材名称长度不能超过200")
    private String bookName;

    @Excel(name = "采购数量", sort = 2, width = 12)
    @NotBlank(message = "采购数量不能为空")
    @Min(value = 1, message = "采购数量必须大于0")
    @Max(value = 9999, message = "采购数量不能超过9999")
    private Integer quantity;

    @Excel(name = "申请学院", sort = 3, width = 15)
    @NotBlank(message = "申请学院不能为空")
    private String college;

    @Excel(name = "申请专业", sort = 4, width = 15)
    @NotBlank(message = "申请专业不能为空")
    private String major;

    @Excel(name = "适用班级", sort = 5, width = 20)
    private String className;

    @Excel(name = "备注", sort = 5, width = 30)
    private String remark;

    @JsonIgnore
    private int rowIndex;

    @JsonIgnore
    private String errorMsg;

    public String getIsbn() { return isbn; }
    public void setIsbn(String isbn) { this.isbn = isbn; }
    public String getBookName() { return bookName; }
    public void setBookName(String bookName) { this.bookName = bookName; }
    public Integer getQuantity() { return quantity; }
    public void setQuantity(Integer quantity) { this.quantity = quantity; }
    public String getCollege() { return college; }
    public void setCollege(String college) { this.college = college; }
    public String getMajor() { return major; }
    public void setMajor(String major) { this.major = major; }
    public String getClassName() { return className; }
    public void setClassName(String className) { this.className = className; }
    public String getRemark() { return remark; }
    public void setRemark(String remark) { this.remark = remark; }
    public int getRowIndex() { return rowIndex; }
    public void setRowIndex(int rowIndex) { this.rowIndex = rowIndex; }
    public String getErrorMsg() { return errorMsg; }
    public void setErrorMsg(String errorMsg) { this.errorMsg = errorMsg; }

    public boolean isValidRow() {
        return isbn != null && !isbn.trim().isEmpty()
            || bookName != null && !bookName.trim().isEmpty();
    }
}
