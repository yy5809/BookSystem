package com.ruoyi.textbook.domain.notify;

public class NotificationTemplate {

    private final String code;
    private final String defaultTitle;
    private final String defaultContent;
    private final String defaultBizType;
    private final String defaultRecipientType;

    public NotificationTemplate(String code, String defaultTitle, String defaultContent,
            String defaultBizType, String defaultRecipientType) {
        this.code = code;
        this.defaultTitle = defaultTitle;
        this.defaultContent = defaultContent;
        this.defaultBizType = defaultBizType;
        this.defaultRecipientType = defaultRecipientType;
    }

    public String getCode() { return code; }
    public String getDefaultTitle() { return defaultTitle; }
    public String getDefaultContent() { return defaultContent; }
    public String getDefaultBizType() { return defaultBizType; }
    public String getDefaultRecipientType() { return defaultRecipientType; }
}
