package com.ruoyi.textbook.domain.vo;

import java.util.List;

public class DashboardStatsVO {
    private int totalBooks;
    private int totalStock;
    private int pendingAudit;
    private int pendingReceive;
    private int shortageCount;
    private int warningCount;
    private int pendingInbound;
    private List<PurchaseSummaryVO> auditList;
    private List<PurchaseSummaryVO> receiveList;
    private List<InventoryWarningVO> shortageList;
    private List<StockLogSummaryVO> recentLogs;

    public int getTotalBooks() { return totalBooks; }
    public void setTotalBooks(int totalBooks) { this.totalBooks = totalBooks; }
    public int getTotalStock() { return totalStock; }
    public void setTotalStock(int totalStock) { this.totalStock = totalStock; }
    public int getPendingAudit() { return pendingAudit; }
    public void setPendingAudit(int pendingAudit) { this.pendingAudit = pendingAudit; }
    public int getPendingReceive() { return pendingReceive; }
    public void setPendingReceive(int pendingReceive) { this.pendingReceive = pendingReceive; }
    public int getShortageCount() { return shortageCount; }
    public void setShortageCount(int shortageCount) { this.shortageCount = shortageCount; }
    public int getWarningCount() { return warningCount; }
    public void setWarningCount(int warningCount) { this.warningCount = warningCount; }
    public int getPendingInbound() { return pendingInbound; }
    public void setPendingInbound(int pendingInbound) { this.pendingInbound = pendingInbound; }
    public List<PurchaseSummaryVO> getAuditList() { return auditList; }
    public void setAuditList(List<PurchaseSummaryVO> auditList) { this.auditList = auditList; }
    public List<PurchaseSummaryVO> getReceiveList() { return receiveList; }
    public void setReceiveList(List<PurchaseSummaryVO> receiveList) { this.receiveList = receiveList; }
    public List<InventoryWarningVO> getShortageList() { return shortageList; }
    public void setShortageList(List<InventoryWarningVO> shortageList) { this.shortageList = shortageList; }
    public List<StockLogSummaryVO> getRecentLogs() { return recentLogs; }
    public void setRecentLogs(List<StockLogSummaryVO> recentLogs) { this.recentLogs = recentLogs; }
}
