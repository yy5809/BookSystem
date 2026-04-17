package com.ruoyi.textbook.enums;

public enum ReceiveStatusEnum {
    NOT_RECEIVED("0", "未领"),
    RECEIVED("1", "已领");

    private final String code;
    private final String desc;

    ReceiveStatusEnum(String code, String desc) {
        this.code = code;
        this.desc = desc;
    }

    public String getCode() {
        return code;
    }

    public String getDesc() {
        return desc;
    }

    public static boolean isValid(String code) {
        for (ReceiveStatusEnum status : values()) {
            if (status.code.equals(code)) {
                return true;
            }
        }
        return false;
    }
}
