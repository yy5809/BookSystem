package com.ruoyi.textbook.util;

import com.ruoyi.common.utils.DateUtils;
import com.ruoyi.common.utils.uuid.IdUtils;

import java.util.concurrent.atomic.AtomicInteger;

public class PurchaseNoGenerator {

    private static final AtomicInteger sequence = new AtomicInteger(0);

    /**
     * @deprecated 使用静态AtomicInteger生成序号，JVM重启后计数器归零，多实例部署时可能产生重复单号。
     * 请使用 {@link #generateWithUUID()} 替代
     */
    @Deprecated
    public static String generate() {
        int seq = sequence.incrementAndGet() % 1000;
        return "CG" + DateUtils.dateTimeNow("yyyyMMddHHmmss") + String.format("%03d", seq);
    }

    /**
     * 生成基于UUID的采购单号（推荐使用）
     * 格式：CG + yyyyMMddHHmmss + UUID前6位
     */
    public static String generateWithUUID() {
        return "CG" + DateUtils.dateTimeNow("yyyyMMddHHmmss") + IdUtils.fastSimpleUUID().substring(0, 6);
    }

    /**
     * @deprecated 使用静态AtomicInteger生成序号，JVM重启后计数器归零，多实例部署时可能产生重复单号。
     * 请使用 {@link #generateWithUUID()} 替代
     */
    @Deprecated
    public static String generateSimple() {
        int seq = sequence.incrementAndGet() % 10000;
        return "CG" + DateUtils.dateTimeNow("yyyyMMdd") + String.format("%04d", seq);
    }

    private static void reset() {
        sequence.set(0);
    }
}