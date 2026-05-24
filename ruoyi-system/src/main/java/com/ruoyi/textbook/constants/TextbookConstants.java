package com.ruoyi.textbook.constants;

public class TextbookConstants {

    public static final String FUNDING_SOURCE_SELF = "自费";

    public static final String FUNDING_SOURCE_PUBLIC = "公费";

    public static final String FUNDING_SOURCE_SCHOOL = "学校经费";

    public static final int MAX_PURCHASE_QUANTITY = 100;

    public static final int MIN_PURCHASE_QUANTITY = 1;

    public static final int MAX_REJECT_REASON_LENGTH = 500;

    public static final int MAX_BATCH_SIZE = 50;

    public static final String SUPPLIER_FEEDBACK_SHORTAGE = "2";

    public static final String SUPPLIER_FEEDBACK_INFO_ERROR = "3";

    public static final String BINDING_SOURCE_PURCHASE = "1";

    public static final String STATUS_RECEIVED = "3";

    private TextbookConstants() {
        throw new UnsupportedOperationException("常量类不允许实例化");
    }
}
