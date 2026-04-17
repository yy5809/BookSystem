package com.ruoyi.textbook.domain.dto;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Pattern;
import javax.validation.constraints.Size;

public class AuditRequest {

    @NotNull(message = "购书单ID不能为空")
    private Long buyId;

    @NotBlank(message = "审核状态不能为空")
    @Pattern(regexp = "^[12]$", message = "审核状态只能是1(通过)或2(驳回)")
    private String status;

    @Size(max = 500, message = "驳回原因不能超过500个字符")
    private String rejectReason;

    public Long getBuyId() {
        return buyId;
    }

    public void setBuyId(Long buyId) {
        this.buyId = buyId;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getRejectReason() {
        return rejectReason;
    }

    public void setRejectReason(String rejectReason) {
        this.rejectReason = rejectReason;
    }
}
