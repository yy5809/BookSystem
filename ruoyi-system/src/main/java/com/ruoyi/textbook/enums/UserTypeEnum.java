package com.ruoyi.textbook.enums;

public enum UserTypeEnum {
    TEACHER("1", "教师"),
    STUDENT("2", "学生");

    private final String code;
    private final String desc;

    UserTypeEnum(String code, String desc) {
        this.code = code;
        this.desc = desc;
    }

    public String getCode() {
        return code;
    }

    public String getDesc() {
        return desc;
    }
}
