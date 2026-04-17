package com.ruoyi.textbook.domain;

import com.ruoyi.common.core.domain.BaseEntity;
import java.math.BigDecimal;
import java.util.Date;

/**
 * 库存盘点任务对象 tb_inventory_check
 */
public class TbInventoryCheck extends BaseEntity {
    private static final long serialVersionUID = 1L;

    private Long checkId;
    private String checkNo;
    private String checkType;
    private String checkStatus;
    private Long warehousemanId;
    private String warehousemanName;
    private Date planStartTime;
    private Date planEndTime;
    private Date actualStartTime;
    private Date actualEndTime;
    private Integer totalItems;
    private Integer checkedItems;
    private Integer diffItems;
    private BigDecimal totalDiffAmount;

    public Long getCheckId() { return checkId; }
    public void setCheckId(Long checkId) { this.checkId = checkId; }

    public String getCheckNo() { return checkNo; }
    public void setCheckNo(String checkNo) { this.checkNo = checkNo; }

    public String getCheckType() { return checkType; }
    public void setCheckType(String checkType) { this.checkType = checkType; }

    public String getCheckStatus() { return checkStatus; }
    public void setCheckStatus(String checkStatus) { this.checkStatus = checkStatus; }

    public Long getWarehousemanId() { return warehousemanId; }
    public void setWarehousemanId(Long warehousemanId) { this.warehousemanId = warehousemanId; }

    public String getWarehousemanName() { return warehousemanName; }
    public void setWarehousemanName(String warehousemanName) { this.warehousemanName = warehousemanName; }

    public Date getPlanStartTime() { return planStartTime; }
    public void setPlanStartTime(Date planStartTime) { this.planStartTime = planStartTime; }

    public Date getPlanEndTime() { return planEndTime; }
    public void setPlanEndTime(Date planEndTime) { this.planEndTime = planEndTime; }

    public Date getActualStartTime() { return actualStartTime; }
    public void setActualStartTime(Date actualStartTime) { this.actualStartTime = actualStartTime; }

    public Date getActualEndTime() { return actualEndTime; }
    public void setActualEndTime(Date actualEndTime) { this.actualEndTime = actualEndTime; }

    public Integer getTotalItems() { return totalItems; }
    public void setTotalItems(Integer totalItems) { this.totalItems = totalItems; }

    public Integer getCheckedItems() { return checkedItems; }
    public void setCheckedItems(Integer checkedItems) { this.checkedItems = checkedItems; }

    public Integer getDiffItems() { return diffItems; }
    public void setDiffItems(Integer diffItems) { this.diffItems = diffItems; }

    public BigDecimal getTotalDiffAmount() { return totalDiffAmount; }
    public void setTotalDiffAmount(BigDecimal totalDiffAmount) { this.totalDiffAmount = totalDiffAmount; }

    @Override
    public String toString() {
        return "TbInventoryCheck{" +
                "checkId=" + checkId +
                ", checkNo='" + checkNo + '\'' +
                ", checkType='" + checkType + '\'' +
                ", checkStatus='" + checkStatus + '\'' +
                '}';
    }
}
