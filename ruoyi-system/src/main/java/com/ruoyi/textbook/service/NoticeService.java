package com.ruoyi.textbook.service;

import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.textbook.enums.NoticeBizTypeEnum;
import com.ruoyi.textbook.mapper.TbSupplierMapper;
import com.ruoyi.textbook.domain.TbSupplier;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class NoticeService {

    @Autowired
    private AsyncNoticeService asyncNoticeService;

    @Autowired
    private TbSupplierMapper tbSupplierMapper;

    public void sendOrderApproveNotice(Long userId, String bookName, String status, String reason, Long orderId) {
        String content = "你的《" + bookName + "》领书单已" + ("1".equals(status) ? "通过" : "驳回");
        if (!"1".equals(status) && reason != null && !reason.isEmpty()) {
            content += "，原因：" + reason;
        }
        if ("1".equals(status)) {
            content += "，请前往书库领取";
        }
        asyncNoticeService.sendNoticeToUserAsync(userId, "领书单审核通知", content, "1", orderId, SecurityUtils.getUsername());
    }

    public void sendLackNotice(Long bookId, String bookName, String isbn, Integer lackNum, Integer currentStock, Long lackId) {
        StringBuilder content = new StringBuilder();
        content.append("【缺书预警】\n");
        content.append("教材：《").append(bookName).append("》\n");
        if (isbn != null && !isbn.isEmpty()) {
            content.append("ISBN：").append(isbn).append("\n");
        }
        content.append("当前库存：").append(currentStock).append("本\n");
        content.append("需采购数量：").append(lackNum).append("本\n");
        content.append("\n请及时处理采购事宜！");
        asyncNoticeService.sendNoticeToRoleAsync("warehouse", "教材缺货通知", content.toString(),
                NoticeBizTypeEnum.LACK.getCode(), lackId);
    }

    public void sendInboundNotice(Long bookId, String bookName, Long inboundId) {
        String content = "【新书到货】\n《" + bookName + "》已成功入库，库存已更新。\n\n相关待处理事项已自动更新，请查看。";
        asyncNoticeService.sendNoticeToRoleAsync("warehouse", "教材入库通知", content,
                NoticeBizTypeEnum.INBOUND.getCode(), inboundId);
    }

    public void sendSupplierInboundNotice(Long supplierId, String bookName, Integer quantity, String inboundNo) {
        TbSupplier supplier = tbSupplierMapper.selectBySupplierId(supplierId);
        Long userId = (supplier != null && supplier.getUserId() != null) ? supplier.getUserId() : supplierId;
        String content = "【进书确认】\n您的供货《" + bookName + "》" + quantity + "本已完成入库。\n入库单号：" + inboundNo + "\n\n感谢您的配合！";
        asyncNoticeService.sendNoticeToUserAsync(userId, "供应商进货确认通知", content,
                NoticeBizTypeEnum.ORDER_APPROVE.getCode(), supplierId, SecurityUtils.getUsername());
    }

    public void sendStockWarningNotice(Long bookId, String bookName, Integer currentStock, Integer warningThreshold) {
        String content = "【库存预警】\n《" + bookName + "》库存低于预警阈值！\n当前库存：" + currentStock + "本\n预警阈值：" + warningThreshold + "本\n\n请及时安排采购补货。";
        asyncNoticeService.sendNoticeToRoleAsync("warehouse", "库存预警通知", content,
                NoticeBizTypeEnum.STOCK_WARNING.getCode(), bookId);
    }

    public void sendPurchaseCreateNotice(Long purchaseId, String purchaseNo, int itemCount) {
        String content = "【新采购单】\n采购单号：" + purchaseNo + "\n包含教材：" + itemCount + "种\n\n请及时审核并安排采购流程。";
        asyncNoticeService.sendNoticeToRoleAsync("warehouse", "新采购单生成通知", content,
                NoticeBizTypeEnum.PURCHASE_CREATE.getCode(), purchaseId);
    }

    public void sendNoticeToRole(String roleKey, String title, String content, String bizType, Long bizId) {
        asyncNoticeService.sendNoticeToRoleAsync(roleKey, title, content, bizType, bizId);
    }

    public void sendNoticeToUser(Long userId, String title, String content, String bizType, Long bizId) {
        asyncNoticeService.sendNoticeToUserAsync(userId, title, content, bizType, bizId, SecurityUtils.getUsername());
    }

    public void sendClaimFormOutboundNotice(Long formId, String className, String bookNames, Integer qty) {
        String content = "【班级领书出库】\n班级：" + className + "\n教材：" + bookNames + "\n数量：" + qty + "本\n\n领书单已确认出库，请核对库存。";
        asyncNoticeService.sendNoticeToRoleAsync("warehouse", "班级领书出库通知", content,
                NoticeBizTypeEnum.CLAIM_OUTBOUND.getCode(), formId);
    }

    public void sendNoticePublishNotice(Long noticeId, String semester, Integer classCount) {
        String content = "【领书通知发布】\n学期：" + semester + "\n涉及班级：" + classCount + "个\n\n请通知各班委按时领取。";
        asyncNoticeService.sendNoticeToRoleAsync("warehouse", "领书通知已发布", content,
                NoticeBizTypeEnum.NOTICE_PUBLISH.getCode(), noticeId);
    }

    public void sendShipmentNotice(Long purchaseId, String purchaseNo, String logisticsCompany, String logisticsNo) {
        String content = "【供应商发货】\n采购单号：" + purchaseNo + "\n物流公司：" + logisticsCompany + "\n物流单号：" + logisticsNo + "\n\n请及时确认到货。";
        asyncNoticeService.sendNoticeToRoleAsync("warehouse", "供应商发货通知", content,
                NoticeBizTypeEnum.SHIPMENT.getCode(), purchaseId);
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
}
