package com.ruoyi.textbook.enums;

public enum DetailVerifyStatusEnum {
    PENDING("0", "待核准"),
    APPROVED("1", "核准通过"),
    RECEIVED("2", "已收货"),
    RETURNED("3", "已退货"),
    INFO_CORRECTED("4", "信息已修正"),
    SHORTAGE("5", "缺货登记"),
    INBOUND("6", "已入库");

    private final String code;
    private final String desc;

    DetailVerifyStatusEnum(String code, String desc) { this.code = code; this.desc = desc; }
    public String getCode() { return code; }
    public String getDesc() { return desc; }

    public static DetailVerifyStatusEnum fromCode(String code) {
        for (DetailVerifyStatusEnum s : values()) if (s.code.equals(code)) return s;
        return null;
    }
    public static String getDescByCode(String code) {
        DetailVerifyStatusEnum s = fromCode(code);
        return s != null ? s.getDesc() : "未知";
    }
}
