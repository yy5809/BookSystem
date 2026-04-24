package com.ruoyi.web.service.impl;

import com.alibaba.fastjson2.JSONObject;
import com.ruoyi.framework.websocket.NoticeWebSocket;
import com.ruoyi.textbook.service.INoticePushService;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.UUID;

@Service
public class NoticePushServiceImpl implements INoticePushService {

    private static final Logger log = LoggerFactory.getLogger(NoticePushServiceImpl.class);

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
