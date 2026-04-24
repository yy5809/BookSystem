package com.ruoyi.textbook.enums;

public enum InfoStatusEnum {
    INCOMPLETE("0", "待完善"),
    COMPLETE("1", "已完善");

    private final String code;
    private final String desc;

    InfoStatusEnum(String code, String desc) {
        this.code = code;
        this.desc = desc;
    }

    public String getCode() { return code; }
    public String getDesc() { return desc; }

    public static InfoStatusEnum fromCode(String code) {
        for (InfoStatusEnum status : values()) {
            if (status.code.equals(code)) return status;
        }
        return null;
    }

    public static String getDescByCode(String code) {
        InfoStatusEnum status = fromCode(code);
        return status != null ? status.getDesc() : "未知状态";
    }
}
