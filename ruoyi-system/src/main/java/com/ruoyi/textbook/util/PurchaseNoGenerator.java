package com.ruoyi.textbook.util;

import com.ruoyi.common.utils.DateUtils;
import com.ruoyi.common.utils.uuid.IdUtils;

import java.util.concurrent.atomic.AtomicInteger;

public class PurchaseNoGenerator {

    private static final AtomicInteger sequence = new AtomicInteger(0);

    public static String generate() {
        int seq = sequence.incrementAndGet() % 1000;
        return "CG" + DateUtils.dateTimeNow("yyyyMMddHHmmss") + String.format("%03d", seq);
    }

    public static String generateWithUUID() {
        return "CG" + DateUtils.dateTimeNow("yyyyMMddHHmmss") + IdUtils.fastSimpleUUID().substring(0, 6);
    }

    public static String generateSimple() {
        int seq = sequence.incrementAndGet() % 10000;
        return "CG" + DateUtils.dateTimeNow("yyyyMMdd") + String.format("%04d", seq);
    }

    private static void reset() {
        sequence.set(0);
    }
}