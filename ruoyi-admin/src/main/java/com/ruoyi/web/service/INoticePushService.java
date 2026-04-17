package com.ruoyi.textbook.service;

import java.util.Map;

public interface INoticePushService {
    void pushPersonalApplyAudit(Long teacherId, String applyNo, String status, String opinion);

    void pushIssueComplete(Long teacherId, String applyNo, String bookName);

    void pushInboundNotice(Long supplierId, String purchaseNo, String bookName);

    void pushShortageToManager(String isbn, int qty);
}
