package com.ruoyi.textbook.enums;

public enum UserTypeEnum {
    TEACHER("1", "教师"),
    WAREHOUSE("2", "库管员"),
    SUPPLIER("3", "供应商");

    private final String code;
    private final String desc;

    UserTypeEnum(String code, String desc) {
        this.code = code;
        this.desc = desc;
    }

    public String getCode() { return code; }
    public String getDesc() { return desc; }

    public static UserTypeEnum fromCode(String code) {
        for (UserTypeEnum type : values()) {
            if (type.code.equals(code)) return type;
        }
        return null;
    }

    public static UserTypeEnum fromRoleKey(String roleKey) {
        switch (roleKey) {
            case "warehouse": return WAREHOUSE;
            case "supplier": return SUPPLIER;
            default: return TEACHER;
        }
    }

    public static String getDescByCode(String code) {
        UserTypeEnum type = fromCode(code);
        return type != null ? type.getDesc() : "未知类型";
    }
}
