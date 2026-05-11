package com.ruoyi.textbook.service;

import com.ruoyi.textbook.domain.notify.NotificationContext;

public interface INotificationStrategy {
    void send(NotificationContext context, String title, String content);
}
