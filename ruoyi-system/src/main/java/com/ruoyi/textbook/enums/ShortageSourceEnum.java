package com.ruoyi.textbook.enums;

public enum ShortageSourceEnum {
    CLAIM_OUTBOUND("1", "领书缺货"),
    STOCK_WARNING("2", "库存预警"),
    PERSONAL_APPLY("3", "个人申请");

    private final String code;
    private final String desc;

    ShortageSourceEnum(String code, String desc) {
        this.code = code;
        this.desc = desc;
    }

    public String getCode() { return code; }
    public String getDesc() { return desc; }

    public static ShortageSourceEnum fromCode(String code) {
        for (ShortageSourceEnum source : values()) {
            if (source.code.equals(code)) return source;
        }
        return null;
    }
}
