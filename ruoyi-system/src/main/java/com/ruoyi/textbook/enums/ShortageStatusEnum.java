package com.ruoyi.textbook.enums;

import java.util.Arrays;
import java.util.List;

public enum ShortageStatusEnum {
    PENDING("0", "未处理", Arrays.asList("1", "4")),
    IN_PURCHASE("1", "已纳入采购", Arrays.asList("2", "3", "4")),
    PARTIAL("2", "部分补齐", Arrays.asList("3", "4")),
    COMPLETED("3", "已补齐", Arrays.asList()),
    CANCELLED("4", "已取消", Arrays.asList());

    private final String code;
    private final String desc;
    private final List<String> allowedTransitions;

    ShortageStatusEnum(String code, String desc, List<String> allowedTransitions) {
        this.code = code;
        this.desc = desc;
        this.allowedTransitions = allowedTransitions;
    }

    public String getCode() { return code; }
    public String getDesc() { return desc; }

    public boolean canTransitionTo(String targetStatus) {
        return allowedTransitions.contains(targetStatus);
    }

    public static ShortageStatusEnum fromCode(String code) {
        for (ShortageStatusEnum status : values()) {
            if (status.code.equals(code)) {
                return status;
            }
        }
        return null;
    }

    public static boolean canTransition(String from, String to) {
        ShortageStatusEnum fromStatus = fromCode(from);
        if (fromStatus == null) return false;
        return fromStatus.canTransitionTo(to);
    }

    public static String getDescByCode(String code) {
        ShortageStatusEnum status = fromCode(code);
        return status != null ? status.getDesc() : "未知状态";
    }
}
