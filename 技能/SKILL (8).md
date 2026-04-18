---
name: data-fix
description: 教材采购与库存管理系统数据修复技能。用于诊断和修复系统中的脏数据、数据不一致问题。涵盖库存与流水不一致、采购单状态异常、领书单数量不一致、缺书单重复、逻辑删除数据泄露等常见数据问题的检测和修复。提供可执行的SQL修复脚本和数据校验查询。
---

# 教材采购与库存管理系统 — 数据修复技能

## 一、数据修复原则

### 1.1 安全原则

| 原则 | 说明 |
|------|------|
| 先备份后修复 | 修复前必须备份相关表数据 |
| 最小影响 | 只修复有问题的数据，不影响正常数据 |
| 可追溯 | 记录修复SQL、修复时间、影响行数 |
| 先校验后修复 | 先用SELECT确认问题范围，再用UPDATE修复 |
| 测试环境验证 | 生产环境修复前先在测试环境验证 |

### 1.2 修复流程

```
1. 发现问题 → 定位问题数据
2. SELECT查询确认问题范围和影响行数
3. 备份相关表数据
4. 编写修复SQL
5. 在测试环境执行并验证
6. 生产环境执行（低峰期）
7. 执行后校验
8. 记录修复日志
```

---

## 二、数据校验查询

### 2.1 库存与流水一致性校验

```sql
-- 校验：教材当前库存是否等于流水汇总
SELECT
    t.isbn,
    t.book_name,
    t.stock AS current_stock,
    COALESCE(f.flow_sum, 0) AS flow_sum,
    t.stock - COALESCE(f.flow_sum, 0) AS diff,
    CASE
        WHEN t.stock = COALESCE(f.flow_sum, 0) THEN '✅ 一致'
        ELSE '❌ 不一致'
    END AS check_result
FROM book_textbook t
LEFT JOIN (
    SELECT isbn, SUM(change_qty) AS flow_sum
    FROM book_stock_flow
    GROUP BY isbn
) f ON t.isbn = f.isbn
WHERE t.del_flag = '0'
HAVING diff != 0;
```

### 2.2 领书单数量一致性校验

```sql
-- 校验：领书单应发总数是否等于明细合计
SELECT
    f.form_no,
    f.class_name,
    f.planned_qty AS form_planned,
    COALESCE(d.detail_sum, 0) AS detail_sum,
    f.planned_qty - COALESCE(d.detail_sum, 0) AS diff,
    CASE
        WHEN f.planned_qty = COALESCE(d.detail_sum, 0) THEN '✅ 一致'
        ELSE '❌ 不一致'
    END AS check_result
FROM book_claim_form f
LEFT JOIN (
    SELECT form_id, SUM(planned_qty) AS detail_sum
    FROM book_claim_form_detail
    GROUP BY form_id
) d ON f.form_id = d.form_id
WHERE f.del_flag = '0'
HAVING diff != 0;
```

### 2.3 采购单明细一致性校验

```sql
-- 校验：采购单总数是否等于明细合计
SELECT
    o.order_no,
    o.total_qty AS order_total,
    COALESCE(d.detail_sum, 0) AS detail_sum,
    o.total_qty - COALESCE(d.detail_sum, 0) AS diff
FROM book_purchase_order o
LEFT JOIN (
    SELECT order_id, SUM(purchase_qty) AS detail_sum
    FROM book_purchase_order_detail
    GROUP BY order_id
) d ON o.order_id = d.order_id
WHERE o.del_flag = '0'
HAVING diff != 0;
```

### 2.4 缺书单重复ISBN校验

```sql
-- 校验：同一ISBN是否有重复的未处理缺书单
SELECT
    isbn,
    book_name,
    COUNT(*) AS duplicate_count,
    SUM(shortage_qty) AS total_qty
FROM book_shortage
WHERE del_flag = '0' AND status = '0'
GROUP BY isbn, book_name
HAVING duplicate_count > 1;
```

### 2.5 逻辑删除数据泄露校验

```sql
-- 校验：是否有已删除的数据被关联查询出来
-- 检查采购明细引用了已删除的教材
SELECT
    od.detail_id,
    od.order_id,
    od.isbn,
    od.book_name,
    t.textbook_id,
    t.del_flag
FROM book_purchase_order_detail od
LEFT JOIN book_textbook t ON od.isbn = t.isbn
WHERE t.del_flag = '1';

-- 检查领书单引用了已删除的通知
SELECT
    f.form_id,
    f.form_no,
    f.notice_id,
    n.notice_id,
    n.del_flag
FROM book_claim_form f
LEFT JOIN book_notice n ON f.notice_id = n.notice_id
WHERE n.del_flag = '1';
```

### 2.6 孤儿数据校验

```sql
-- 校验：采购明细是否引用了不存在的采购单
SELECT d.detail_id, d.order_id
FROM book_purchase_order_detail d
LEFT JOIN book_purchase_order o ON d.order_id = o.order_id
WHERE o.order_id IS NULL;

-- 校验：领书单明细是否引用了不存在的领书单
SELECT d.detail_id, d.form_id
FROM book_claim_form_detail d
LEFT JOIN book_claim_form f ON d.form_id = f.form_id
WHERE f.form_id IS NULL;

-- 校验：库存流水是否引用了不存在的教材
SELECT f.flow_id, f.isbn
FROM book_stock_flow f
LEFT JOIN book_textbook t ON f.isbn = t.isbn
WHERE t.textbook_id IS NULL;
```

---

## 三、数据修复脚本

### 3.1 修复库存与流水不一致

```sql
-- ============================================
-- 修复编号：FIX-001
-- 问题描述：库存与流水汇总不一致
-- 修复策略：以流水汇总为准，修正库存
-- ============================================

-- 步骤1：备份
CREATE TABLE book_textbook_backup_20260417 AS SELECT * FROM book_textbook;

-- 步骤2：查看受影响的记录
SELECT t.isbn, t.book_name, t.stock AS old_stock,
       COALESCE(f.flow_sum, 0) AS correct_stock
FROM book_textbook t
LEFT JOIN (
    SELECT isbn, SUM(change_qty) AS flow_sum
    FROM book_stock_flow GROUP BY isbn
) f ON t.isbn = f.isbn
WHERE t.del_flag = '0' AND t.stock != COALESCE(f.flow_sum, 0);

-- 步骤3：执行修复（以流水为准）
UPDATE book_textbook t
JOIN (
    SELECT isbn, SUM(change_qty) AS flow_sum
    FROM book_stock_flow GROUP BY isbn
) f ON t.isbn = f.isbn
SET t.stock = f.flow_sum,
    t.update_time = NOW(),
    t.update_by = 'SYSTEM_FIX'
WHERE t.del_flag = '0' AND t.stock != f.flow_sum;

-- 步骤4：处理无流水记录的教材（库存应归零或保持）
-- 如果教材从未有过流水，库存应该为0
UPDATE book_textbook t
SET t.stock = 0,
    t.update_time = NOW(),
    t.update_by = 'SYSTEM_FIX'
WHERE t.del_flag = '0'
  AND t.stock != 0
  AND t.isbn NOT IN (SELECT DISTINCT isbn FROM book_stock_flow);

-- 步骤5：验证
SELECT t.isbn, t.book_name, t.stock,
       COALESCE(f.flow_sum, 0) AS flow_sum
FROM book_textbook t
LEFT JOIN (SELECT isbn, SUM(change_qty) AS flow_sum FROM book_stock_flow GROUP BY isbn) f ON t.isbn = f.isbn
WHERE t.del_flag = '0' AND t.stock != COALESCE(f.flow_sum, 0);
-- 预期结果：0行
```

### 3.2 修复领书单数量不一致

```sql
-- ============================================
-- 修复编号：FIX-002
-- 问题描述：领书单应发总数与明细合计不一致
-- 修复策略：以明细合计为准，修正主表
-- ============================================

-- 步骤1：备份
CREATE TABLE book_claim_form_backup_20260417 AS SELECT * FROM book_claim_form;

-- 步骤2：执行修复
UPDATE book_claim_form f
JOIN (
    SELECT form_id, SUM(planned_qty) AS detail_sum
    FROM book_claim_form_detail
    GROUP BY form_id
) d ON f.form_id = d.form_id
SET f.planned_qty = d.detail_sum,
    f.update_time = NOW(),
    f.update_by = 'SYSTEM_FIX'
WHERE f.del_flag = '0' AND f.planned_qty != d.detail_sum;

-- 步骤3：修复实发数量
UPDATE book_claim_form f
JOIN (
    SELECT form_id, SUM(issued_qty) AS detail_sum
    FROM book_claim_form_detail
    GROUP BY form_id
) d ON f.form_id = d.form_id
SET f.issued_qty = d.detail_sum,
    f.update_time = NOW(),
    f.update_by = 'SYSTEM_FIX'
WHERE f.del_flag = '0' AND f.issued_qty != d.detail_sum;

-- 步骤4：修复状态（实发>=应发应为已出库）
UPDATE book_claim_form
SET status = '2',
    update_time = NOW(),
    update_by = 'SYSTEM_FIX'
WHERE del_flag = '0'
  AND status = '1'
  AND issued_qty >= planned_qty;

-- 步骤5：验证
-- 预期：0行不一致
```

### 3.3 修复缺书单重复ISBN

```sql
-- ============================================
-- 修复编号：FIX-003
-- 问题描述：同一ISBN有多条未处理缺书单
-- 修复策略：合并为一条，累加数量
-- ============================================

-- 步骤1：备份
CREATE TABLE book_shortage_backup_20260417 AS SELECT * FROM book_shortage;

-- 步骤2：查看重复记录
SELECT isbn, book_name, GROUP_CONCAT(shortage_id) AS ids,
       GROUP_CONCAT(shortage_qty) AS qtys, SUM(shortage_qty) AS total_qty
FROM book_shortage
WHERE del_flag = '0' AND status = '0'
GROUP BY isbn, book_name
HAVING COUNT(*) > 1;

-- 步骤3：合并（保留最早的一条，删除其余）
-- 对每个重复的ISBN：
-- 3a. 更新保留记录的数量
UPDATE book_shortage t1
JOIN (
    SELECT isbn, MIN(shortage_id) AS keep_id, SUM(shortage_qty) AS total_qty,
           MAX(urgency) AS max_urgency
    FROM book_shortage
    WHERE del_flag = '0' AND status = '0'
    GROUP BY isbn
    HAVING COUNT(*) > 1
) t2 ON t1.isbn = t2.isbn AND t1.shortage_id = t2.keep_id
SET t1.shortage_qty = t2.total_qty,
    t1.urgency = t2.max_urgency,
    t1.update_time = NOW();

-- 3b. 删除其余重复记录（逻辑删除）
UPDATE book_shortage t1
JOIN (
    SELECT isbn, MIN(shortage_id) AS keep_id
    FROM book_shortage
    WHERE del_flag = '0' AND status = '0'
    GROUP BY isbn
    HAVING COUNT(*) > 1
) t2 ON t1.isbn = t2.isbn AND t1.shortage_id != t2.keep_id
SET t1.del_flag = '1',
    t1.update_time = NOW();
```

### 3.4 修复采购单状态异常

```sql
-- ============================================
-- 修复编号：FIX-004
-- 问题描述：采购单状态跳转（如待采购直接变为已入库）
-- 修复策略：根据业务数据推断正确状态
-- ============================================

-- 步骤1：查看状态异常的采购单
SELECT order_id, order_no, status, create_time, update_time
FROM book_purchase_order
WHERE del_flag = '0'
ORDER BY create_time;

-- 步骤2：修复 - 已入库但无入库流水的，回退到已到货
UPDATE book_purchase_order o
SET o.status = '2',
    o.update_time = NOW(),
    o.update_by = 'SYSTEM_FIX'
WHERE o.del_flag = '0'
  AND o.status = '3'
  AND o.order_no NOT IN (
      SELECT DISTINCT business_no FROM book_stock_flow
      WHERE business_type = '1'
  );

-- 步骤3：修复 - 已到货但无到货记录的，回退到采购中
-- （需根据实际业务日志判断）

-- 步骤4：验证
SELECT order_id, order_no, status,
    (SELECT COUNT(*) FROM book_stock_flow WHERE business_no = o.order_no AND business_type = '1') AS inbound_count
FROM book_purchase_order o
WHERE o.del_flag = '0' AND o.status = '3';
-- 预期：所有已入库的采购单都有入库流水
```

### 3.5 修复领书通知状态不一致

```sql
-- ============================================
-- 修复编号：FIX-005
-- 问题描述：领书通知状态与实际出库进度不一致
-- ============================================

-- 步骤1：查看不一致的通知
SELECT
    n.notice_id,
    n.notice_no,
    n.status AS notice_status,
    n.total_classes,
    n.issued_classes,
    (SELECT COUNT(*) FROM book_claim_form f WHERE f.notice_id = n.notice_id AND f.status = '2') AS actual_issued
FROM book_notice n
WHERE n.del_flag = '0'
  AND n.issued_classes != (SELECT COUNT(*) FROM book_claim_form f WHERE f.notice_id = n.notice_id AND f.status = '2');

-- 步骤2：修复
UPDATE book_notice n
SET n.issued_classes = (
    SELECT COUNT(*) FROM book_claim_form f
    WHERE f.notice_id = n.notice_id AND f.del_flag = '0' AND f.status = '2'
),
n.status = CASE
    WHEN (SELECT COUNT(*) FROM book_claim_form f WHERE f.notice_id = n.notice_id AND f.del_flag = '0' AND f.status = '2') >= n.total_classes
        THEN '3' -- 已完成
    WHEN (SELECT COUNT(*) FROM book_claim_form f WHERE f.notice_id = n.notice_id AND f.del_flag = '0' AND f.status IN ('1','2')) > 0
        THEN '2' -- 领取中
    ELSE '1' -- 已发布
END,
n.update_time = NOW(),
n.update_by = 'SYSTEM_FIX'
WHERE n.del_flag = '0';
```

### 3.6 清理孤儿数据

```sql
-- ============================================
-- 修复编号：FIX-006
-- 问题描述：明细表引用了不存在的父表记录
-- ============================================

-- 备份后清理孤儿采购明细
CREATE TABLE book_purchase_order_detail_backup_20260417 AS
SELECT * FROM book_purchase_order_detail
WHERE order_id NOT IN (SELECT order_id FROM book_purchase_order WHERE del_flag = '0');

DELETE FROM book_purchase_order_detail
WHERE order_id NOT IN (SELECT order_id FROM book_purchase_order WHERE del_flag = '0');

-- 清理孤儿领书单明细
DELETE FROM book_claim_form_detail
WHERE form_id NOT IN (SELECT form_id FROM book_claim_form WHERE del_flag = '0');

-- 清理无教材的流水（保留，作为历史记录，不删除）
-- 流水是审计数据，即使教材被删除也不应清理
```

---

## 四、数据修复记录模板

```sql
-- 数据修复记录表
CREATE TABLE IF NOT EXISTS data_fix_log (
    fix_id       BIGINT AUTO_INCREMENT PRIMARY KEY,
    fix_no       VARCHAR(30) NOT NULL COMMENT '修复编号',
    description  VARCHAR(500) NOT NULL COMMENT '问题描述',
    fix_sql      TEXT COMMENT '修复SQL',
    affected_rows INT DEFAULT 0 COMMENT '影响行数',
    operator     VARCHAR(64) DEFAULT '' COMMENT '执行人',
    fix_time     DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '修复时间',
    verified     CHAR(1) DEFAULT '0' COMMENT '是否验证（0未验证 1已验证）'
) ENGINE=InnoDB COMMENT='数据修复记录表';

-- 记录修复
INSERT INTO data_fix_log (fix_no, description, fix_sql, affected_rows, operator)
VALUES ('FIX-001', '库存与流水不一致修复',
    'UPDATE book_textbook t JOIN (...) f ON ... SET t.stock = f.flow_sum',
    5, 'admin');
```

---

## 五、预防措施

| 问题 | 预防措施 |
|------|---------|
| 库存与流水不一致 | Service层使用 `@Transactional` 保证原子性 |
| 领书单数量不一致 | 发布通知时正确计算汇总 |
| 缺书单重复 | 登记时先查询同ISBN未处理记录 |
| 采购单状态跳转 | 枚举 `canTransitionTo()` 校验 |
| 孤儿数据 | 删除父表记录时检查子表引用 |
| 逻辑删除泄露 | 所有查询加 `del_flag = '0'` |
