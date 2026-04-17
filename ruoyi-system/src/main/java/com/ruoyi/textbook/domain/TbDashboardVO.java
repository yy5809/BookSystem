package com.ruoyi.textbook.domain;

import java.util.List;

public class TbDashboardVO {
    private int totalBooks;
    private int totalStock;
    private int pendingAudit;
    private int pendingReceive;
    private int shortageCount;
    private int warningCount;
    private int pendingInbound;
    private List<TbPurchase> auditList;
    private List<TbPurchase> receiveList;
    private List<TbPending> inboundList;
    private List<TbInventory> shortageList;
    private List<TbStockLog> recentLogs;

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
    public List<TbPurchase> getAuditList() { return auditList; }
    public void setAuditList(List<TbPurchase> auditList) { this.auditList = auditList; }
    public List<TbPurchase> getReceiveList() { return receiveList; }
    public void setReceiveList(List<TbPurchase> receiveList) { this.receiveList = receiveList; }
    public List<TbPending> getInboundList() { return inboundList; }
    public void setInboundList(List<TbPending> inboundList) { this.inboundList = inboundList; }
    public List<TbInventory> getShortageList() { return shortageList; }
    public void setShortageList(List<TbInventory> shortageList) { this.shortageList = shortageList; }
    public List<TbStockLog> getRecentLogs() { return recentLogs; }
    public void setRecentLogs(List<TbStockLog> recentLogs) { this.recentLogs = recentLogs; }
}
