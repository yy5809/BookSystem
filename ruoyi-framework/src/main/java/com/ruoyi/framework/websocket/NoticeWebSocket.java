package com.ruoyi.framework.websocket;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;
import javax.websocket.*;
import javax.websocket.server.PathParam;
import javax.websocket.server.ServerEndpoint;
import java.io.IOException;
import java.util.Arrays;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import com.alibaba.fastjson2.JSON;
import com.alibaba.fastjson2.JSONObject;

@ServerEndpoint("/ws/notice/{userId}/{role}")
@Component
public class NoticeWebSocket {

    private static final Logger log = LoggerFactory.getLogger(NoticeWebSocket.class);

    private static ConcurrentHashMap<Long, Session> sessionMap = new ConcurrentHashMap<>();

    private static ConcurrentHashMap<Long, String> userRoleMap = new ConcurrentHashMap<>();

    @OnOpen
    public void onOpen(Session session, @PathParam("userId") Long userId, @PathParam("role") String role) {
        sessionMap.put(userId, session);
        if (role != null && !role.isEmpty()) {
            registerUserRole(userId, role);
        }
        log.info("[WebSocket] 用户 {} 已建立连接, 角色={}, 当前在线: {}", userId, role, sessionMap.size());
    }

    @OnClose
    public void onClose(@PathParam("userId") Long userId) {
        sessionMap.remove(userId);
        userRoleMap.remove(userId);
        log.info("[WebSocket] 用户 {} 断开连接, 当前在线: {}", userId, sessionMap.size());
    }

    @OnMessage
    public void onMessage(String message, @PathParam("userId") Long userId) {
        log.debug("[WebSocket] 收到用户 {} 的消息: {}", userId, message);
    }

    @OnError
    public void onError(Session session, Throwable error, @PathParam("userId") Long userId) {
        log.error("[WebSocket] 用户 {} 连接错误: {}", userId, error.getMessage());
        sessionMap.remove(userId);
    }

    public static void sendToUser(Long userId, JSONObject noticeData) {
        Session session = sessionMap.get(userId);
        if (session != null && session.isOpen()) {
            try {
                synchronized (session) {
                    session.getBasicRemote().sendText(noticeData.toJSONString());
                }
                log.info("[WebSocket] 通知已推送给用户 {}", userId);
            } catch (IOException e) {
                log.error("[WebSocket] 推送失败: {}", e.getMessage());
                sessionMap.remove(userId);
            }
        }
    }

    public static void sendToRole(String roleKey, JSONObject noticeData) {
        sessionMap.forEach((userId, session) -> {
            String userRole = userRoleMap.get(userId);
            if (userRole != null && matchRole(userRole, roleKey) && session.isOpen()) {
                try {
                    synchronized (session) {
                        session.getBasicRemote().sendText(noticeData.toJSONString());
                    }
                } catch (IOException e) {
                    log.error("[WebSocket] 推送失败: {}", e.getMessage());
                }
            }
        });
    }

    private static boolean matchRole(String userRole, String targetRole) {
        if (userRole.equals(targetRole)) return true;
        return Arrays.asList(userRole.split(",")).contains(targetRole);
    }

    public static void registerUserRole(Long userId, String roleKey) {
        userRoleMap.put(userId, roleKey);
    }

    public static int getOnlineCount() {
        return sessionMap.size();
    }
}
