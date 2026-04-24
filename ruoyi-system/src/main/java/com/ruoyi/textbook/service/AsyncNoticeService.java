package com.ruoyi.textbook.service;

import com.ruoyi.system.domain.SysNotice;
import com.ruoyi.system.mapper.SysUserMapper;
import com.ruoyi.system.service.ISysNoticeService;
import com.ruoyi.textbook.enums.UserTypeEnum;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class AsyncNoticeService {

    private static final Logger log = LoggerFactory.getLogger(AsyncNoticeService.class);

    @Autowired
    private ISysNoticeService sysNoticeService;

    @Autowired
    private SysUserMapper sysUserMapper;

    @Autowired(required = false)
    private INoticePushService noticePushService;

    @Async
    public void sendNoticeToRoleAsync(String roleKey, String title, String content, String bizType, Long bizId) {
        try {
            String userType = UserTypeEnum.fromRoleKey(roleKey).getCode();
            List<Long> userIds = sysUserMapper.selectUserIdsByRoleKey(roleKey);
            if (userIds != null && !userIds.isEmpty()) {
                for (Long userId : userIds) {
                    SysNotice notice = buildNotice(title, content, bizType, bizId, userId, userType);
                    sysNoticeService.insertNotice(notice);
                }
            }
            pushToRoleViaWebSocket(roleKey, title, content, bizType, bizId);
        } catch (Exception e) {
            log.error("【异步通知】发送角色通知失败, roleKey={}, title={}", roleKey, title, e);
        }
    }

    @Async
    public void sendNoticeToUserAsync(Long userId, String title, String content, String bizType, Long bizId, String createBy) {
        try {
            String userType = determineUserType(userId);
            SysNotice notice = buildNotice(title, content, bizType, bizId, userId, userType);
            notice.setCreateBy(createBy);
            sysNoticeService.insertNotice(notice);
            pushToUserViaWebSocket(userId, title, content, bizType, bizId);
        } catch (Exception e) {
            log.error("【异步通知】发送用户通知失败, userId={}, title={}", userId, title, e);
        }
    }

    private SysNotice buildNotice(String title, String content, String bizType, Long bizId, Long targetUserId, String userType) {
        SysNotice notice = new SysNotice();
        notice.setNoticeTitle(title);
        notice.setNoticeType("1");
        notice.setStatus("0");
        notice.setBizId(bizId);
        notice.setBizType(bizType);
        notice.setReadStatus("0");
        notice.setTargetUserId(targetUserId);
        notice.setUserType(userType);
        notice.setNoticeContent(content);
        return notice;
    }

    private String determineUserType(Long userId) {
        if (userId == null) return UserTypeEnum.TEACHER.getCode();
        try {
            if (sysUserMapper != null) {
                List<Long> warehouseIds = sysUserMapper.selectUserIdsByRoleKey("warehouse");
                if (warehouseIds != null && warehouseIds.contains(userId)) {
                    return UserTypeEnum.WAREHOUSE.getCode();
                }
                List<Long> supplierIds = sysUserMapper.selectUserIdsByRoleKey("supplier");
                if (supplierIds != null && supplierIds.contains(userId)) {
                    return UserTypeEnum.SUPPLIER.getCode();
                }
            }
        } catch (Exception e) {
            log.warn("判断用户类型失败(userId={}): {}", userId, e.getMessage());
        }
        return UserTypeEnum.TEACHER.getCode();
    }

    private void pushToUserViaWebSocket(Long userId, String title, String content, String bizType, Long bizId) {
        if (noticePushService == null) return;
        try {
            noticePushService.pushToUser(userId, title, content, bizType, bizId);
        } catch (Exception e) {
            log.warn("WebSocket推送失败(userId={}): {}", userId, e.getMessage());
        }
    }

    private void pushToRoleViaWebSocket(String roleKey, String title, String content, String bizType, Long bizId) {
        if (noticePushService == null) return;
        try {
            noticePushService.pushToRole(roleKey, title, content, bizType, bizId);
        } catch (Exception e) {
            log.warn("WebSocket推送失败(roleKey={}): {}", roleKey, e.getMessage());
        }
    }

    public List<Map<String, Object>> getSupplierNotices(Long supplierId) {
        return sysNoticeService.selectSupplierNotices(supplierId);
    }

    public Map<String, Object> getSupplierNoticeDetail(Long noticeId, Long supplierId) {
        return sysNoticeService.selectSupplierNoticeDetail(noticeId, supplierId);
    }

    public void markNoticeAsRead(Long noticeId, Long supplierId) {
        sysNoticeService.updateNoticeReadStatus(noticeId, supplierId);
    }

    public void markAllNoticesAsRead(Long supplierId) {
        sysNoticeService.updateAllNoticeReadStatus(supplierId);
    }

    public int countUnreadNoticesBySupplierId(Long supplierId) {
        return sysNoticeService.countUnreadNoticesBySupplierId(supplierId);
    }
}
