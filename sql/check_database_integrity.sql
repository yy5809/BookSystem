-- ============================================================
-- 教材采购系统 - 数据库完整性检查脚本
-- 执行时间: 2026-04-16
-- 说明: 检查所有表结构、索引、外键、数据一致性
-- ============================================================

SET NAMES utf8mb4;

SELECT '========================================' AS '';
SELECT '📊 教材采购系统 - 数据库完整性检查报告' AS '';
SELECT '⏰ 检查时间: ' + NOW() AS '';
SELECT '========================================' AS '';

-- ----------------------------
-- 1. 检查核心表是否存在
-- ----------------------------
SELECT '✅ 1. 表存在性检查' AS step;

SELECT
    CASE WHEN COUNT(*) = 3 THEN '✅ 所有核心表已存在'
         ELSE CONCAT('❌ 缺少 ', 3 - COUNT(*), ' 张表')
    END AS result
FROM information_schema.tables
WHERE table_schema = DATABASE()
AND table_name IN ('book_notice', 'book_claim_form', 'book_claim_form_detail');

-- ----------------------------
-- 2. 检查表字段完整性
-- ----------------------------
SELECT '' AS '';
SELECT '✅ 2. 字段完整性检查' AS step;

-- book_notice表
SELECT
    CASE WHEN COUNT(*) >= 15 THEN '✅ book_notice 表字段完整'
         ELSE CONCAT('⚠️ book_notice 表缺少部分字段 (', COUNT(*), '/15)')
    END AS check_result
FROM information_schema.columns
WHERE table_schema = DATABASE()
AND table_name = 'book_notice';

-- book_claim_form表
SELECT
    CASE WHEN COUNT(*) >= 17 THEN '✅ book_claim_form 表字段完整'
         ELSE CONCAT('⚠️ book_claim_form 表缺少部分字段 (', COUNT(*), '/17)')
    END AS check_result
FROM information_schema.columns
WHERE table_schema = DATABASE()
AND table_name = 'book_claim_form';

-- book_claim_form_detail表
SELECT
    CASE WHEN COUNT(*) >= 10 THEN '✅ book_claim_form_detail 表字段完整'
         ELSE CONCAT('⚠️ book_claim_form_detail 表缺少部分字段 (', COUNT(*), '/10)')
    END AS check_result
FROM information_schema.columns
WHERE table_schema = DATABASE()
AND table_name = 'book_claim_form_detail';

-- ----------------------------
-- 3. 检查索引配置
-- ----------------------------
SELECT '' AS '';
SELECT '✅ 3. 索引配置检查' AS step;

SELECT
    TABLE_NAME,
    INDEX_NAME,
    COLUMN_NAME,
    SEQ_IN_INDEX
FROM information_schema.statistics
WHERE table_schema = DATABASE()
AND table_name IN ('book_notice', 'book_claim_form', 'book_claim_form_detail')
ORDER BY TABLE_NAME, INDEX_NAME, SEQ_IN_INDEX;

-- ----------------------------
-- 4. 检查主键和唯一约束
-- ----------------------------
SELECT '' AS '';
SELECT '✅ 4. 约束检查' AS step;

SELECT
    CONSTRAINT_NAME,
    TABLE_NAME,
    CONSTRAINT_TYPE
FROM information_schema.table_constraints
WHERE table_schema = DATABASE()
AND table_name IN ('book_notice', 'book_claim_form', 'book_claim_form_detail')
ORDER BY TABLE_NAME, CONSTRAINT_TYPE;

-- ----------------------------
-- 5. 检查菜单权限是否已添加
-- ----------------------------
SELECT '' AS '';
SELECT '✅ 5. 菜单权限检查' AS step;

SELECT
    CASE WHEN COUNT(*) >= 12 THEN '✅ 领书通知/领书单权限已完整配置'
         ELSE CONCAT('⚠️ 权限配置不完整 (', COUNT(*), '/12)')
    END AS result
FROM sys_menu
WHERE perms LIKE 'textbook:notice:%' OR perms LIKE 'textbook:claimForm:%';

-- 显示具体权限列表
SELECT menu_id, menu_name, parent_id, perms, menu_type
FROM sys_menu
WHERE perms LIKE 'textbook:notice:%' OR perms LIKE 'textbook:claimForm:%'
ORDER BY parent_id, order_num;

-- ----------------------------
-- 6. 检查数据字典是否已添加
-- ----------------------------
SELECT '' AS '';
SELECT '✅ 6. 数据字典检查' AS step;

SELECT
    dict_type,
    dict_name,
    status
FROM sys_dict_type
WHERE dict_type IN (
    'tb_semester',
    'tb_college',
    'tb_major_cs',
    'tb_urgency_level',
    'tb_notice_status',
    'tb_claim_form_status'
)
ORDER BY dict_type;

-- ----------------------------
-- 7. 检查角色权限分配
-- ----------------------------
SELECT '' AS '';
SELECT '✅ 7. 角色权限分配检查' AS step;

SELECT
    r.role_id,
    r.role_name,
    COUNT(m.menu_id) AS permission_count
FROM sys_role r
LEFT JOIN sys_role_menu rm ON r.role_id = rm.role_id
LEFT JOIN sys_menu m ON rm.menu_id = m.menu_id AND (m.perms LIKE 'textbook:notice:%' OR m.perms LIKE 'textbook:claimForm:%')
GROUP BY r.role_id, r.role_name
HAVING permission_count > 0;

-- ----------------------------
-- 8. 检查现有教材管理模块表状态
-- ----------------------------
SELECT '' AS '';
SELECT '✅ 8. 教材管理核心表状态' AS step;

SELECT
    TABLE_NAME,
    TABLE_ROWS,
    AUTO_INCREMENT,
    CREATE_TIME,
    UPDATE_TIME
FROM information_schema.tables
WHERE table_schema = DATABASE()
AND table_name IN (
    'tb_book',
    'tb_inventory',
    'tb_purchase',
    'tb_purchase_detail',
    'tb_inbound',
    'tb_outbound',
    'tb_shortage',
    'tb_stock_log',
    'tb_supplier'
)
ORDER BY TABLE_NAME;

-- ----------------------------
-- 9. 数据一致性检查（可选）
-- ----------------------------
SELECT '' AS '';
SELECT '✅ 9. 数据一致性检查' AS step;

-- 检查库存流水与库存数量的一致性
SELECT
    i.book_id,
    b.book_name,
    i.stock_num AS current_stock,
    COALESCE(SUM(CASE WHEN sl.biz_type = '1' THEN sl.change_num ELSE 0 END), 0) AS total_inbound,
    COALESCE(SUM(CASE WHEN sl.biz_type IN ('2', '3') THEN ABS(sl.change_num) ELSE 0 END), 0) AS total_outbound,
    (i.stock_num -
     COALESCE(SUM(CASE WHEN sl.biz_type = '1' THEN sl.change_num ELSE 0 END), 0) +
     COALESCE(SUM(CASE WHEN sl.biz_type IN ('2', '3') THEN ABS(sl.change_num) ELSE 0 END), 0)
    ) AS diff
FROM tb_inventory i
LEFT JOIN tb_book b ON i.book_id = b.book_id
LEFT JOIN tb_stock_log sl ON i.book_id = sl.book_id
GROUP BY i.book_id, b.book_name, i.stock_num
HAVING diff != 0 OR diff IS NULL
LIMIT 20;

-- ----------------------------
-- 最终总结
-- ----------------------------
SELECT '' AS '';
SELECT '========================================' AS '';
SELECT '🎯 检查完成！请查看上方结果' AS final_result;
SELECT '========================================' AS '';

SELECT
    (SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name IN ('book_notice', 'book_claim_form', 'book_claim_form_detail')) AS new_tables_count,
    (SELECT COUNT(*) FROM sys_menu WHERE perms LIKE 'textbook:notice:%' OR perms LIKE 'textbook:claimForm:%') AS permissions_count,
    (SELECT COUNT(*) FROM sys_dict_type WHERE dict_type LIKE 'tb_%') AS dictionaries_count;
