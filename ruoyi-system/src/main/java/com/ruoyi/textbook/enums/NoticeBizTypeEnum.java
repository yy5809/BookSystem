package com.ruoyi.textbook.enums;

public enum NoticeBizTypeEnum {
    PURCHASE_CREATE("2", "采购单创建"),
    INBOUND("3", "入库通知"),
    LACK("4", "缺货通知"),
    ORDER_APPROVE("5", "订单审核"),
    STOCK_WARNING("6", "库存预警"),
    CLAIM_OUTBOUND("7", "领书出库"),
    NOTICE_PUBLISH("8", "领书通知发布"),
    SHIPMENT("9", "发货通知");

    private final String code;
    private final String desc;

    NoticeBizTypeEnum(String code, String desc) {
        this.code = code;
        this.desc = desc;
    }

    public String getCode() { return code; }
    public String getDesc() { return desc; }

    public static NoticeBizTypeEnum fromCode(String code) {
        for (NoticeBizTypeEnum type : values()) {
            if (type.code.equals(code)) return type;
        }
        return null;
    }

    public static String getDescByCode(String code) {
        NoticeBizTypeEnum type = fromCode(code);
        return type != null ? type.getDesc() : "未知类型";
    }
}
