package com.ruoyi.textbook.service;

public interface INoticePushService {
    void pushToUser(Long userId, String title, String content, String bizType, Long bizId);

    void pushToRole(String roleKey, String title, String content, String bizType, Long bizId);
}
