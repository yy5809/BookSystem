package com.ruoyi.web.service.impl;

import com.alibaba.fastjson2.JSONObject;
import com.ruoyi.framework.websocket.NoticeWebSocket;
import com.ruoyi.web.service.INoticePushService;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.UUID;

@Service
public class NoticePushServiceImpl implements INoticePushService {

    private static final Logger log = LoggerFactory.getLogger(NoticePushServiceImpl.class);

    @Override
    public void pushPersonalApplyAudit(Long teacherId, String applyNo, String status, String opinion) {
        JSONObject notice = buildNotice(
                "1".equals(status) ? "领书申请审核通过" : "领书申请审核驳回",
                "1".equals(status) ? "success" : "danger",
                "personal_apply_audit",
                String.format("您的领书申请 %s 已%s。%s", applyNo,
                        "1".equals(status) ? "通过" : "被驳回",
                        opinion != null ? "原因：" + opinion : "")
        );
        notice.put("applyNo", applyNo);
        notice.put("status", status);
        NoticeWebSocket.sendToUser(teacherId, notice);
    }

    @Override
    public void pushIssueComplete(Long teacherId, String applyNo, String bookName) {
        JSONObject notice = buildNotice("教材出库完成", "primary", "issue_complete",
                String.format("您申请的教材《%s》已出库，请到书库领取。申请编号: %s", bookName, applyNo));
        notice.put("applyNo", applyNo);
        notice.put("bookName", bookName);
        NoticeWebSocket.sendToUser(teacherId, notice);
    }

    @Override
    public void pushInboundNotice(Long supplierId, String purchaseNo, String bookName) {
        JSONObject notice = buildNotice("教材入库通知", "success", "inbound_notice",
                String.format("采购单 %s 中的教材《%s》已完成入库。", purchaseNo, bookName));
        notice.put("purchaseNo", purchaseNo);
        NoticeWebSocket.sendToUser(supplierId, notice);
    }

    @Override
    public void pushShortageToManager(String isbn, int qty) {
        JSONObject notice = buildNotice("缺书登记提醒", "warning", "shortage_register",
                String.format("有新的缺书登记：ISBN=%s, 数量=%d本，请及时处理。", isbn, qty));
        notice.put("isbn", isbn);
        notice.put("qty", qty);
        NoticeWebSocket.sendToRole("warehouse_manager", notice);
    }

    @Override
    public void pushToUser(Long userId, String title, String content, String bizType, Long bizId) {
        JSONObject notice = buildNotice(title, "primary", bizType, content);
        notice.put("bizId", bizId);
        NoticeWebSocket.sendToUser(userId, notice);
    }

    @Override
    public void pushToRole(String roleKey, String title, String content, String bizType, Long bizId) {
        JSONObject notice = buildNotice(title, "primary", bizType, content);
        notice.put("bizId", bizId);
        NoticeWebSocket.sendToRole(roleKey, notice);
    }

    private JSONObject buildNotice(String title, String type, String bizType, String content) {
        JSONObject notice = new JSONObject();
        notice.put("noticeId", UUID.randomUUID().toString());
        notice.put("noticeTitle", title);
        notice.put("noticeType", type);
        notice.put("businessType", bizType);
        notice.put("noticeContent", content);
        notice.put("createTime", new Date().toString());
        notice.put("readStatus", "0");
        return notice;
    }
}
