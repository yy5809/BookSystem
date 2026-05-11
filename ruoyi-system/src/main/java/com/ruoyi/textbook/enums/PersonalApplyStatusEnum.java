package com.ruoyi.textbook.enums;

public enum PersonalApplyStatusEnum {
    PENDING("0", "待审核"),
    APPROVED("1", "已通过"),
    REJECTED("2", "已驳回"),
    ISSUED("3", "已出库"),
    CLOSED("4", "已关闭"),
    SHORTAGE_REGISTERED("5", "已转缺书");

    private final String code;
    private final String desc;

    PersonalApplyStatusEnum(String code, String desc) {
        this.code = code;
        this.desc = desc;
    }

    public String getCode() { return code; }
    public String getDesc() { return desc; }

    public static PersonalApplyStatusEnum fromCode(String code) {
        for (PersonalApplyStatusEnum status : values()) {
            if (status.code.equals(code)) return status;
        }
        return null;
    }

    public static String getDescByCode(String code) {
        PersonalApplyStatusEnum status = fromCode(code);
        return status != null ? status.getDesc() : "未知状态";
    }
}
