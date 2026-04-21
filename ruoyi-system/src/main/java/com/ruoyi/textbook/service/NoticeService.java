package com.ruoyi.textbook.service;

import com.ruoyi.system.domain.SysNotice;
import com.ruoyi.system.mapper.SysUserMapper;
import com.ruoyi.system.service.ISysNoticeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class NoticeService {

    @Autowired
    private ISysNoticeService sysNoticeService;

    @Autowired
    private SysUserMapper sysUserMapper;

    public void sendOrderApproveNotice(Long userId, String bookName, String status, String reason, Long orderId) {
        SysNotice notice = new SysNotice();
        notice.setNoticeTitle("领书单审核通知");
        notice.setNoticeType("1");
        notice.setStatus("0");
        notice.setBizId(orderId);
        notice.setBizType("1");
        notice.setReadStatus("0");
        notice.setTargetUserId(userId);

        String content = "你的《" + bookName + "》领书单已" + ("1".equals(status) ? "通过" : "驳回");
        if (!"1".equals(status) && reason != null && !reason.isEmpty()) {
            content += "，原因：" + reason;
        }
        if ("1".equals(status)) {
            content += "，请前往书库领取";
        }
        notice.setNoticeContent(content);

        sysNoticeService.insertNotice(notice);
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

        List<Long> warehouseManagerIds = sysUserMapper.selectUserIdsByRoleKey("warehouse");
        if (warehouseManagerIds != null && !warehouseManagerIds.isEmpty()) {
            for (Long managerId : warehouseManagerIds) {
                SysNotice notice = new SysNotice();
                notice.setNoticeTitle("教材缺货通知");
                notice.setNoticeType("1");
                notice.setStatus("0");
                notice.setBizId(lackId);
                notice.setBizType("4");
                notice.setReadStatus("0");
                notice.setTargetUserId(managerId);
                notice.setNoticeContent(content.toString());
                sysNoticeService.insertNotice(notice);
            }
        }
    }

    public void sendInboundNotice(Long bookId, String bookName, Long inboundId) {
        String content = "【新书到货】\n《" + bookName + "》已成功入库，库存已更新。\n\n相关待处理事项已自动更新，请查看。";

        List<Long> warehouseManagerIds = sysUserMapper.selectUserIdsByRoleKey("warehouse");
        if (warehouseManagerIds != null && !warehouseManagerIds.isEmpty()) {
            for (Long managerId : warehouseManagerIds) {
                SysNotice notice = new SysNotice();
                notice.setNoticeTitle("教材入库通知");
                notice.setNoticeType("1");
                notice.setStatus("0");
                notice.setBizId(inboundId);
                notice.setBizType("3");
                notice.setReadStatus("0");
                notice.setTargetUserId(managerId);
                notice.setNoticeContent(content);
                sysNoticeService.insertNotice(notice);
            }
        }
    }

    public void sendSupplierInboundNotice(Long supplierId, String bookName, Integer quantity, String inboundNo) {
        SysNotice notice = new SysNotice();
        notice.setNoticeTitle("供应商进货确认通知");
        notice.setNoticeType("1");
        notice.setStatus("0");
        notice.setTargetUserId(supplierId);
        notice.setBizType("5");
        notice.setReadStatus("0");

        String content = "【进书确认】\n您的供货《" + bookName + "》" + quantity + "本已完成入库。\n入库单号：" + inboundNo + "\n\n感谢您的配合！";
        notice.setNoticeContent(content);

        sysNoticeService.insertNotice(notice);
    }

    public void sendStockWarningNotice(Long bookId, String bookName, Integer currentStock, Integer warningThreshold) {
        String content = "【库存预警】\n《" + bookName + "》库存低于预警阈值！\n当前库存：" + currentStock + "本\n预警阈值：" + warningThreshold + "本\n\n请及时安排采购补货。";

        List<Long> warehouseManagerIds = sysUserMapper.selectUserIdsByRoleKey("warehouse");
        if (warehouseManagerIds != null && !warehouseManagerIds.isEmpty()) {
            for (Long managerId : warehouseManagerIds) {
                SysNotice notice = new SysNotice();
                notice.setNoticeTitle("库存预警通知");
                notice.setNoticeType("1");
                notice.setStatus("0");
                notice.setBizId(bookId);
                notice.setBizType("6");
                notice.setReadStatus("0");
                notice.setTargetUserId(managerId);
                notice.setNoticeContent(content);
                sysNoticeService.insertNotice(notice);
            }
        }
    }

    public void sendPurchaseCreateNotice(Long purchaseId, String purchaseNo, int itemCount) {
        String content = "【新采购单】\n采购单号：" + purchaseNo + "\n包含教材：" + itemCount + "种\n\n请及时审核并安排采购流程。";

        List<Long> warehouseManagerIds = sysUserMapper.selectUserIdsByRoleKey("warehouse");
        if (warehouseManagerIds != null && !warehouseManagerIds.isEmpty()) {
            for (Long managerId : warehouseManagerIds) {
                SysNotice notice = new SysNotice();
                notice.setNoticeTitle("新采购单生成通知");
                notice.setNoticeType("1");
                notice.setStatus("0");
                notice.setBizId(purchaseId);
                notice.setBizType("2");
                notice.setReadStatus("0");
                notice.setTargetUserId(managerId);
                notice.setNoticeContent(content);
                sysNoticeService.insertNotice(notice);
            }
        }
    }

    public void sendNoticeToRole(String roleKey, String title, String content, String bizType, Long bizId) {
        List<Long> userIds = sysUserMapper.selectUserIdsByRoleKey(roleKey);
        if (userIds != null && !userIds.isEmpty()) {
            for (Long userId : userIds) {
                SysNotice notice = new SysNotice();
                notice.setNoticeTitle(title);
                notice.setNoticeType("1");
                notice.setStatus("0");
                notice.setBizId(bizId);
                notice.setBizType(bizType);
                notice.setReadStatus("0");
                notice.setTargetUserId(userId);
                notice.setNoticeContent(content);
                sysNoticeService.insertNotice(notice);
            }
        }
    }

    public void sendNoticeToUser(Long userId, String title, String content, String bizType, Long bizId) {
        SysNotice notice = new SysNotice();
        notice.setNoticeTitle(title);
        notice.setNoticeType("1");
        notice.setStatus("0");
        notice.setBizId(bizId);
        notice.setBizType(bizType);
        notice.setReadStatus("0");
        notice.setTargetUserId(userId);
        notice.setNoticeContent(content);

        sysNoticeService.insertNotice(notice);
    }

    public void sendClaimFormOutboundNotice(Long formId, String className, String bookNames, Integer qty) {
        SysNotice notice = new SysNotice();
        notice.setNoticeTitle("班级领书出库通知");
        notice.setNoticeType("1");
        notice.setStatus("0");
        notice.setBizId(formId);
        notice.setBizType("7");
        notice.setReadStatus("0");

        String content = "【班级领书出库】\n班级：" + className + "\n教材：" + bookNames + "\n数量：" + qty + "本\n\n领书单已确认出库，请核对库存。";
        notice.setNoticeContent(content);

        sysNoticeService.insertNotice(notice);
    }

    public void sendNoticePublishNotice(Long noticeId, String semester, Integer classCount) {
        String content = "【领书通知发布】\n学期：" + semester + "\n涉及班级：" + classCount + "个\n\n请通知各班委按时领取。";

        List<Long> warehouseManagerIds = sysUserMapper.selectUserIdsByRoleKey("warehouse");
        if (warehouseManagerIds != null && !warehouseManagerIds.isEmpty()) {
            for (Long managerId : warehouseManagerIds) {
                SysNotice notice = new SysNotice();
                notice.setNoticeTitle("领书通知已发布");
                notice.setNoticeType("1");
                notice.setStatus("0");
                notice.setBizId(noticeId);
                notice.setBizType("8");
                notice.setReadStatus("0");
                notice.setTargetUserId(managerId);
                notice.setNoticeContent(content);
                sysNoticeService.insertNotice(notice);
            }
        }
    }

    // 发送发货通知给库管员
    public void sendShipmentNotice(Long purchaseId, String purchaseNo, String logisticsCompany, String logisticsNo) {
        String content = "【供应商发货】\n采购单号：" + purchaseNo + "\n物流公司：" + logisticsCompany + "\n物流单号：" + logisticsNo + "\n\n请及时确认到货。";

        List<Long> warehouseManagerIds = sysUserMapper.selectUserIdsByRoleKey("warehouse");
        if (warehouseManagerIds != null && !warehouseManagerIds.isEmpty()) {
            for (Long managerId : warehouseManagerIds) {
                SysNotice notice = new SysNotice();
                notice.setNoticeTitle("供应商发货通知");
                notice.setNoticeType("1");
                notice.setStatus("0");
                notice.setBizId(purchaseId);
                notice.setBizType("9");
                notice.setReadStatus("0");
                notice.setTargetUserId(managerId);
                notice.setNoticeContent(content);
                sysNoticeService.insertNotice(notice);
            }
        }
    }

    // 获取供应商通知列表
    public List<Map<String, Object>> getSupplierNotices(Long supplierId) {
        return sysNoticeService.selectSupplierNotices(supplierId);
    }

    // 获取供应商通知详情
    public Map<String, Object> getSupplierNoticeDetail(Long noticeId, Long supplierId) {
        return sysNoticeService.selectSupplierNoticeDetail(noticeId, supplierId);
    }

    // 标记通知为已读
    public void markNoticeAsRead(Long noticeId, Long supplierId) {
        sysNoticeService.updateNoticeReadStatus(noticeId, supplierId);
    }

    // 全部标记为已读
    public void markAllNoticesAsRead(Long supplierId) {
        sysNoticeService.updateAllNoticeReadStatus(supplierId);
    }

    // 统计未读通知数
    public int countUnreadNoticesBySupplierId(Long supplierId) {
        return sysNoticeService.countUnreadNoticesBySupplierId(supplierId);
    }
}
