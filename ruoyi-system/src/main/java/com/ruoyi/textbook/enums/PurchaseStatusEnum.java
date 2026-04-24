package com.ruoyi.textbook.enums;

import java.util.Arrays;
import java.util.List;

public enum PurchaseStatusEnum {
    PENDING("0", "待审核", Arrays.asList("1", "2")),
    APPROVED("1", "已通过", Arrays.asList("3", "2", "6")),
    REJECTED("2", "已驳回", Arrays.asList("0")),
    RECEIVED("3", "已领书", Arrays.asList()),
    ARRIVED("4", "已到货", Arrays.asList("5")),
    INBOUND("5", "已入库", Arrays.asList()),
    SHIPPED("6", "已发货", Arrays.asList("4"));

    private final String code;
    private final String desc;
    private final List<String> allowedTransitions;

    PurchaseStatusEnum(String code, String desc, List<String> allowedTransitions) {
        this.code = code;
        this.desc = desc;
        this.allowedTransitions = allowedTransitions;
    }

    public String getCode() {
        return code;
    }

    public String getDesc() {
        return desc;
    }

    public boolean canTransitionTo(String targetStatus) {
        return allowedTransitions.contains(targetStatus);
    }

    public static PurchaseStatusEnum fromCode(String code) {
        for (PurchaseStatusEnum status : values()) {
            if (status.code.equals(code)) {
                return status;
            }
        }
        return null;
    }

    public static boolean isValid(String code) {
        return fromCode(code) != null;
    }

    public static boolean canTransition(String from, String to) {
        PurchaseStatusEnum fromStatus = fromCode(from);
        if (fromStatus == null) {
            return false;
        }
        return fromStatus.canTransitionTo(to);
    }

    public static String getDescByCode(String code) {
        PurchaseStatusEnum status = fromCode(code);
        return status != null ? status.getDesc() : "未知状态";
    }

    public static String getTransitionErrorMsg(String from, String to) {
        PurchaseStatusEnum fromStatus = fromCode(from);
        PurchaseStatusEnum toStatus = fromCode(to);
        if (fromStatus == null) {
            return "无效的源状态: " + from;
        }
        if (toStatus == null) {
            return "无效的目标状态: " + to;
        }
        return String.format("状态从%s(%s)不能转换到%s(%s)", fromStatus.getDesc(), from, toStatus.getDesc(), to);
    }
}