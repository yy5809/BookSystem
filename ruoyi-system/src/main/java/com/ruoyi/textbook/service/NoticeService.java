package com.ruoyi.textbook.service;

import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.textbook.domain.TbPurchaseDetail;
import com.ruoyi.textbook.domain.TbSupplier;
import com.ruoyi.textbook.domain.notify.NotificationContext;
import com.ruoyi.textbook.domain.notify.RecipientType;
import com.ruoyi.textbook.enums.NoticeBizTypeEnum;
import com.ruoyi.textbook.mapper.TbSupplierMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class NoticeService {

    private static final Logger log = LoggerFactory.getLogger(NoticeService.class);

    @Autowired
    private AsyncNoticeService asyncNoticeService;

    @Autowired
    private TbSupplierMapper tbSupplierMapper;

    @Autowired
    private NotificationTemplateService templateService;

    public void send(NotificationContext context) {
        try {
            doSend(context);
        } catch (Exception e) {
            log.warn("通知发送失败: templateCode={}, bizId={}, error={}",
                    context.getTemplateCode(), context.getBizId(), e.getMessage());
        }
    }

    public void sendOrThrow(NotificationContext context) {
        doSend(context);
    }

    public void sendSafe(NotificationContext context) {
        if (context.getRecipientId() == null && context.getRoleKey() == null) {
            return;
        }
        send(context);
    }

    public void sendOrderApproveNotice(Long userId, String bookName, String status, String reason, Long orderId) {
        send(buildUserCtx("1".equals(status) ? "order_approve_pass" : "order_approve_reject",
                userId, NoticeBizTypeEnum.ORDER_APPROVE.getCode(), orderId,
                mapOf("bookName", bookName, "status", status, "reason", reason != null ? reason : "",
                        "title", "您申请的教材《" + bookName + "》审核已" + ("1".equals(status) ? "通过" : "驳回"),
                        "content", buildOrderApproveContent(bookName, status, reason))));
    }

    public void sendLackNotice(Long bookId, String bookName, String isbn, Integer lackNum,
            Integer currentStock, Long lackId) {
        send(buildRoleCtx("lack_notice", "warehouse", NoticeBizTypeEnum.LACK.getCode(), lackId,
                mapOf("bookName", bookName, "isbn", isbn != null ? isbn : "",
                        "lackNum", String.valueOf(lackNum), "currentStock", String.valueOf(currentStock),
                        "title", "【缺书预警】教材《" + bookName + "》库存不足",
                        "content", buildLackContent(bookName, isbn, lackNum, currentStock))));
    }

    public void sendInboundNotice(Long bookId, String bookName, Long inboundId) {
        send(buildRoleCtx("inbound_complete", "warehouse", NoticeBizTypeEnum.INBOUND.getCode(), inboundId,
                mapOf("bookName", bookName,
                        "title", "【新书到货】《" + bookName + "》已成功入库",
                        "content", "【新书到货】\n《" + bookName + "》已成功入库，库存已更新。\n\n相关待处理事项已自动更新，请查看。")));
    }

    public void sendSupplierInboundNotice(Long supplierId, String bookName, Integer quantity, String inboundNo) {
        TbSupplier supplier = tbSupplierMapper.selectBySupplierId(supplierId);
        Long userId = (supplier != null && supplier.getUserId() != null) ? supplier.getUserId() : supplierId;
        send(buildUserCtx("supplier_inbound", userId, NoticeBizTypeEnum.ORDER_APPROVE.getCode(), supplierId,
                mapOf("bookName", bookName, "quantity", String.valueOf(quantity), "inboundNo", inboundNo,
                        "title", "【进书确认】您的供货已完成入库",
                        "content", "【进书确认】\n您的供货《" + bookName + "》" + quantity
                                + "本已完成入库。\n入库单号：" + inboundNo + "\n\n感谢您的配合！")));
    }

    public void sendStockWarningNotice(Long bookId, String bookName, Integer currentStock, Integer warningThreshold) {
        send(buildRoleCtx("stock_warning", "warehouse", NoticeBizTypeEnum.STOCK_WARNING.getCode(), bookId,
                mapOf("bookName", bookName, "currentStock", String.valueOf(currentStock),
                        "warningThreshold", String.valueOf(warningThreshold),
                        "title", "【库存预警】《" + bookName + "》库存低于预警阈值",
                        "content", "【库存预警】\n《" + bookName + "》库存低于预警阈值！\n当前库存：" + currentStock
                                + "本\n预警阈值：" + warningThreshold + "本\n\n请及时安排采购补货。")));
    }

    public void sendPurchaseCreateNotice(Long purchaseId, String purchaseNo, int itemCount) {
        send(buildRoleCtx("purchase_create", "warehouse", NoticeBizTypeEnum.PURCHASE_CREATE.getCode(), purchaseId,
                mapOf("purchaseNo", purchaseNo, "itemCount", String.valueOf(itemCount),
                        "title", "【新采购单】采购单号：" + purchaseNo,
                        "content", "【新采购单】\n采购单号：" + purchaseNo + "\n包含教材：" + itemCount
                                + "种\n\n请及时审核并安排采购流程。")));
    }

    public void sendNoticeToRole(String roleKey, String title, String content, String bizType, Long bizId) {
        send(NotificationContext.builder("generic", bizType, bizId)
                .recipientType(RecipientType.ROLE)
                .roleKey(roleKey)
                .param("title", title)
                .param("content", content)
                .build());
    }

    public void sendNoticeToUser(Long userId, String title, String content, String bizType, Long bizId) {
        send(NotificationContext.builder("generic", bizType, bizId)
                .recipientType(RecipientType.USER)
                .recipientId(userId)
                .param("title", title)
                .param("content", content)
                .build());
    }

    public void sendNoticeToUserOrThrow(Long userId, String title, String content, String bizType, Long bizId) {
        sendOrThrow(NotificationContext.builder("generic", bizType, bizId)
                .recipientType(RecipientType.USER)
                .recipientId(userId)
                .param("title", title)
                .param("content", content)
                .build());
    }

    public void sendClaimFormOutboundNotice(Long formId, String className, String bookNames, Integer qty) {
        send(buildRoleCtx("claim_outbound", "warehouse", NoticeBizTypeEnum.CLAIM_OUTBOUND.getCode(), formId,
                mapOf("className", className, "bookNames", bookNames, "qty", String.valueOf(qty),
                        "title", "【班级领书出库】班级：" + className,
                        "content", "【班级领书出库】\n班级：" + className + "\n教材：" + bookNames
                                + "\n数量：" + qty + "本\n\n领书单已确认出库，请核对库存。")));
    }

    public void sendNoticePublishNotice(Long noticeId, String semester, Integer classCount) {
        send(buildRoleCtx("notice_publish", "warehouse", NoticeBizTypeEnum.NOTICE_PUBLISH.getCode(), noticeId,
                mapOf("semester", semester, "classCount", String.valueOf(classCount),
                        "title", "【领书通知发布】学期：" + semester,
                        "content", "【领书通知发布】\n学期：" + semester + "\n涉及班级：" + classCount
                                + "个\n\n请通知各班委按时领取。")));
    }

    public void sendShipmentNotice(Long purchaseId, String purchaseNo, String logisticsCompany,
            String logisticsNo, String feedbackInfo, List<TbPurchaseDetail> details) {
        StringBuilder content = new StringBuilder();
        content.append("【供应商发货通知】\n");
        content.append("采购单号：").append(purchaseNo).append("\n");
        content.append("物流公司：").append(logisticsCompany).append("\n");
        content.append("物流单号：").append(logisticsNo).append("\n");
        if (feedbackInfo != null && !feedbackInfo.isEmpty()) {
            content.append(feedbackInfo).append("\n");
        }
        if (details != null && !details.isEmpty()) {
            content.append("\n━━━━━ 发货明细 ━━━━━\n");
            int idx = 1;
            for (TbPurchaseDetail d : details) {
                content.append(idx++).append(". 《").append(d.getBookName()).append("》");
                if (d.getIsbn() != null && !d.getIsbn().isEmpty()) {
                    content.append(" [ISBN:").append(d.getIsbn()).append("]");
                }
                if (d.getAuthor() != null && !d.getAuthor().isEmpty()) {
                    content.append(" 作者:").append(d.getAuthor());
                }
                if (d.getPublisher() != null && !d.getPublisher().isEmpty()) {
                    content.append(" 出版社:").append(d.getPublisher());
                }
                content.append(" ×").append(d.getQuantity()).append("本");
                String fb = d.getSupplierFeedback();
                if ("2".equals(fb)) content.append(" [缺货]");
                else if ("3".equals(fb)) content.append(" [信息有误]");
                content.append("\n");
            }
        }
        content.append("\n请及时确认到货并安排入库。");
        String title = "【供应商发货】采购单号：" + purchaseNo;
        send(buildRoleCtx("shipment_confirm", "warehouse", NoticeBizTypeEnum.SHIPMENT.getCode(), purchaseId,
                mapOf("purchaseNo", purchaseNo, "logisticsCompany", logisticsCompany, "logisticsNo", logisticsNo,
                        "title", title, "content", content.toString())));
    }

    public List<Map<String, Object>> getSupplierNotices(Long supplierId) {
        return asyncNoticeService.getSupplierNotices(supplierId);
    }

    public Map<String, Object> getSupplierNoticeDetail(Long noticeId, Long supplierId) {
        return asyncNoticeService.getSupplierNoticeDetail(noticeId, supplierId);
    }

    public void markNoticeAsRead(Long noticeId, Long supplierId) {
        asyncNoticeService.markNoticeAsRead(noticeId, supplierId);
    }

    public void markAllNoticesAsRead(Long supplierId) {
        asyncNoticeService.markAllNoticesAsRead(supplierId);
    }

    public int countUnreadNoticesBySupplierId(Long supplierId) {
        return asyncNoticeService.countUnreadNoticesBySupplierId(supplierId);
    }

    private static Map<String, Object> mapOf(Object... keyValues) {
        Map<String, Object> map = new HashMap<>();
        for (int i = 0; i < keyValues.length; i += 2) {
            map.put((String) keyValues[i], keyValues[i + 1]);
        }
        return map;
    }

    private NotificationContext buildUserCtx(String templateCode, Long userId, String bizType, Long bizId,
            Map<String, Object> params) {
        return NotificationContext.builder(templateCode, bizType, bizId)
                .recipientType(RecipientType.USER)
                .recipientId(userId)
                .params(params)
                .build();
    }

    private NotificationContext buildRoleCtx(String templateCode, String roleKey, String bizType, Long bizId,
            Map<String, Object> params) {
        return NotificationContext.builder(templateCode, bizType, bizId)
                .recipientType(RecipientType.ROLE)
                .roleKey(roleKey)
                .params(params)
                .build();
    }

    private String buildOrderApproveContent(String bookName, String status, String reason) {
        String result = "您申请的教材《" + bookName + "》已" + ("1".equals(status) ? "通过" : "驳回");
        if (!"1".equals(status) && reason != null && !reason.isEmpty()) {
            result += "，原因：" + reason;
        }
        if ("1".equals(status)) {
            result += "，请前往书库领取";
        }
        return result;
    }

    private String buildLackContent(String bookName, String isbn, Integer lackNum, Integer currentStock) {
        StringBuilder sb = new StringBuilder();
        sb.append("【缺书预警】\n");
        sb.append("教材：《").append(bookName).append("》\n");
        if (isbn != null && !isbn.isEmpty()) {
            sb.append("ISBN：").append(isbn).append("\n");
        }
        sb.append("当前库存：").append(currentStock).append("本\n");
        sb.append("需采购数量：").append(lackNum).append("本\n");
        sb.append("\n请及时处理采购事宜！");
        return sb.toString();
    }

    private void doSend(NotificationContext context) {
        String title = templateService.renderTitle(context.getTemplateCode(), context.getTemplateParams());
        String content = templateService.renderContent(context.getTemplateCode(), context.getTemplateParams());
        String bizType = context.getBizType() != null
                ? context.getBizType()
                : templateService.resolveBizType(context.getTemplateCode());

        if (RecipientType.ROLE.equals(context.getRecipientType()) && context.getRoleKey() != null) {
            asyncNoticeService.sendNoticeToRoleAsync(context.getRoleKey(), title, content, bizType, context.getBizId());
        } else if (context.getRecipientId() != null) {
            asyncNoticeService.sendNoticeToUserAsync(context.getRecipientId(), title, content, bizType,
                    context.getBizId(), SecurityUtils.getUsername());
        } else {
            log.warn("通知发送跳过，接收者信息不完整: templateCode={}, bizId={}",
                    context.getTemplateCode(), context.getBizId());
        }
    }
}
