package com.ruoyi.textbook.enums;

public enum AuditStatusEnum {
    PENDING("0", "待审核"),
    APPROVED("1", "已通过"),
    REJECTED("2", "已驳回");

    private final String code;
    private final String desc;

    AuditStatusEnum(String code, String desc) {
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
        for (AuditStatusEnum status : values()) {
            if (status.code.equals(code)) {
                return true;
            }
        }
        return false;
    }

    @Override
    public String toString() {
        return code + "(" + desc + ")";
    }
}
