package com.ruoyi.textbook.domain.notify;

import java.util.HashMap;
import java.util.Map;

public class NotificationContext {

    private final String templateCode;
    private final Map<String, Object> templateParams;
    private final String recipientType;
    private final Long recipientId;
    private final String roleKey;
    private final String bizType;
    private final Long bizId;

    private NotificationContext(Builder builder) {
        this.templateCode = builder.templateCode;
        this.templateParams = builder.templateParams;
        this.recipientType = builder.recipientType;
        this.recipientId = builder.recipientId;
        this.roleKey = builder.roleKey;
        this.bizType = builder.bizType;
        this.bizId = builder.bizId;
    }

    public String getTemplateCode() { return templateCode; }
    public Map<String, Object> getTemplateParams() { return templateParams; }
    public String getRecipientType() { return recipientType; }
    public Long getRecipientId() { return recipientId; }
    public String getRoleKey() { return roleKey; }
    public String getBizType() { return bizType; }
    public Long getBizId() { return bizId; }

    public static Builder builder() {
        return new Builder();
    }

    public static Builder builder(String templateCode, String bizType, Long bizId) {
        return new Builder().templateCode(templateCode).bizType(bizType).bizId(bizId);
    }

    public static class Builder {
        private String templateCode;
        private final Map<String, Object> templateParams = new HashMap<>();
        private String recipientType = RecipientType.USER;
        private Long recipientId;
        private String roleKey;
        private String bizType;
        private Long bizId;

        public Builder templateCode(String templateCode) { this.templateCode = templateCode; return this; }
        public Builder param(String key, Object value) { this.templateParams.put(key, value); return this; }
        public Builder params(Map<String, Object> params) { this.templateParams.putAll(params); return this; }
        public Builder recipientType(String recipientType) { this.recipientType = recipientType; return this; }
        public Builder recipientId(Long recipientId) { this.recipientId = recipientId; return this; }
        public Builder roleKey(String roleKey) { this.roleKey = roleKey; return this; }
        public Builder bizType(String bizType) { this.bizType = bizType; return this; }
        public Builder bizId(Long bizId) { this.bizId = bizId; return this; }

        public NotificationContext build() {
            return new NotificationContext(this);
        }
    }
}
