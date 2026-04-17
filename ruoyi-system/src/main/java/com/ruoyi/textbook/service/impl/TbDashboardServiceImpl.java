package com.ruoyi.textbook.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.textbook.domain.*;
import com.ruoyi.textbook.mapper.*;
import com.ruoyi.textbook.service.ITbDashboardService;

@Service
public class TbDashboardServiceImpl implements ITbDashboardService {

    @Autowired
    private TbInventoryMapper inventoryMapper;
    @Autowired
    private TbPurchaseMapper purchaseMapper;
    @Autowired
    private TbPendingMapper pendingMapper;
    @Autowired
    private TbStockLogMapper stockLogMapper;

    @Override
    public TbDashboardVO getDashboardData() {
        TbDashboardVO vo = new TbDashboardVO();

        List<TbInventory> allInventory = inventoryMapper.selectTbInventoryList(new TbInventory());
        vo.setTotalBooks(allInventory.size());

        int totalStock = 0, shortageCount = 0, warningCount = 0;
        for (TbInventory inv : allInventory) {
            totalStock += inv.getStockNum() != null ? inv.getStockNum() : 0;
            if (inv.getStockNum() != null) {
                if (inv.getStockNum() <= 0) shortageCount++;
                else if (inv.getWarningNum() != null && inv.getStockNum() <= inv.getWarningNum()) warningCount++;
            }
        }
        vo.setTotalStock(totalStock);
        vo.setShortageCount(shortageCount);
        vo.setWarningCount(warningCount);

        TbPurchase purchaseQuery = new TbPurchase();
        List<TbPurchase> allPurchases = purchaseMapper.selectTbPurchaseList(purchaseQuery);
        int auditCount = 0, receiveCount = 0;
        List<TbPurchase> auditList = new java.util.ArrayList<>();
        List<TbPurchase> receiveList = new java.util.ArrayList<>();
        for (TbPurchase p : allPurchases) {
            if ("0".equals(p.getAuditStatus())) { auditCount++; if (auditList.size() < 5) auditList.add(p); }
            if ("1".equals(p.getAuditStatus()) && !"1".equals(p.getReceiveStatus())) { receiveCount++; if (receiveList.size() < 5) receiveList.add(p); }
        }
        vo.setPendingAudit(auditCount);
        vo.setPendingReceive(receiveCount);
        vo.setAuditList(auditList);
        vo.setReceiveList(receiveList);

        TbPending pendingQuery = new TbPending();
        pendingQuery.setStatus("1");
        List<TbPending> inboundList = pendingMapper.selectTbPendingList(pendingQuery).subList(0, Math.min(5, pendingMapper.selectTbPendingList(pendingQuery).size()));
        vo.setPendingInbound(inboundList.size());
        vo.setInboundList(inboundList);

        List<TbInventory> shortageList = new java.util.ArrayList<>();
        for (TbInventory inv : allInventory) {
            if (inv.getStockNum() != null && inv.getWarningNum() != null && inv.getStockNum() <= inv.getWarningNum()) {
                shortageList.add(inv);
                if (shortageList.size() >= 5) break;
            }
        }
        vo.setShortageList(shortageList);

        TbStockLog logQuery = new TbStockLog();
        List<TbStockLog> logs = stockLogMapper.selectList(logQuery);
        vo.setRecentLogs(logs.size() > 10 ? logs.subList(0, 10) : logs);

        return vo;
    }
}
