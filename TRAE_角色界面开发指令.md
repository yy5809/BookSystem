# 教材采购系统 — SQL 配置审查 + TRAE 角色界面开发指令

> 基于现有数据库 ry-vue.sql 实际内容审查，指出问题并给出修复方案，最后附可直接复制给 TRAE 的角色界面指令。

---

## 第一部分：SQL 配置审查结果

### 1.1 现有角色配置（sys_role）

| role_id | role_name | role_key | data_scope | 状态 |
|---|---|---|---|---|
| 1 | 超级管理员 | admin | 1（全部数据） | ✅ 正常 |
| 2 | 普通角色 | common | 2（自定数据权限） | ⚠️ 若依默认，可删除 |
| 3 | 教师 | teacher | 5（仅本人数据） | ✅ 正常 |
| 7 | 库管员 | warehouse | 1（全部数据） | ✅ 正常 |
| 8 | 供应商 | supplier | 1（全部数据） | ⚠️ 应改为仅自身数据 |

### 1.2 现有用户-角色关联（sys_user_role）

| user_id | role_id | 说明 |
|---|---|---|
| 1 | 1 | admin → 超级管理员 ✅ |
| 100 | 7 | 用户100 → 库管员 ✅ |
| 101 | 3 | 用户101 → 教师 ✅ |
| 102 | 7 | 用户102 → 库管员 ✅ |
| 110 | 3 | 用户110 → 教师 ✅ |
| 111 | 7 | 用户111 → 库管员 ✅ |
| 112 | 8 | 用户112 → 供应商 ✅ |

### 1.3 现有菜单-角色关联（sys_role_menu）— ⚠️ 问题所在

#### 角色3（教师）分配的菜单：

```
2020 - 缺书新增按钮
2035 - 缺书管理菜单（旧版，parent=2031）
2038 - 库存查询按钮（旧版）
2051 - 缺书新增按钮（旧版）
2080 - 出库管理菜单（旧版，parent=2086）
2086 - 教材管理目录
2087 - 库存查询菜单（旧版）
2093 - 我的订单（旧版）
2112 - 通知查询按钮
2117 - 领书通知查询按钮
2129 - Book Info（教材信息管理）
2130 - query 按钮
2147 - Class Claim Notice（领书通知管理）
2148 - query 按钮
2156 - 个人领书管理
2157 - query 按钮
2158 - submit 按钮
2159 - cancel 按钮
2162 - Shortage（缺书管理）
2164 - register 按钮
2175 - 教师首页
2176 - 教材信息查询
2177 - query 按钮
2178 - My Applications（我的领书申请）
2182 - 缺书登记
2183 - register 按钮
2184 - 通知中心
2185 - view 按钮
2186 - read 按钮
```

**问题：**
- ❌ 混入了旧版菜单（2035、2038、2051、2080、2087、2093），这些是早期的菜单，已废弃
- ❌ 缺少 2160（audit 按钮）— 虽然教师不需要审核，但不应出现在教师菜单中
- ❌ 缺少 2161（issue 按钮）— 同上
- ⚠️ 教师不应该看到 2129（Book Info 管理页面），应该只看到 2176（教材信息查询只读页面）
- ⚠️ 教师不应该看到 2147（领书通知管理），这是库管员的功能

#### 角色7（库管员）分配的菜单：

```
2038~2054 - 全部是旧版按钮（parent=2031~2037 的旧目录体系）
```

**严重问题：**
- ❌ 库管员**只分配了旧版按钮**，完全没有分配新版的菜单（2128 系列和 2086 系列下的菜单）
- ❌ 缺少：教材信息管理(2129)、采购管理(2136)、入库管理(2144)、领书通知(2147)、领书单(2152)、个人领书(2156)、缺书(2162)、库存(2167)、供应商(2170)、库存盘点(2105)、通知管理(2111)
- ❌ 库管员登录后**看不到任何业务菜单**

#### 角色8（供应商）分配的菜单：

```
（无任何 sys_role_menu 记录）
```

**严重问题：**
- ❌ 供应商**完全没有分配菜单**，登录后看不到任何内容
- ❌ 缺少：我的采购单(2187)、通知中心(2190)

### 1.4 其他问题

| 问题 | 说明 | 严重程度 |
|---|---|---|
| 供应商 data_scope='1' | 供应商应该是仅自身数据，不是全部数据 | ⚠️ 中 |
| 旧版菜单未清理 | menu_id 2001~2037、2076~2082 是旧版菜单，与新版 2128~2192 重复 | ⚠️ 中 |
| 菜单 2086 下 order_num 混乱 | 教师页面(101~105)和供应商页面(201~202)的 order_num 可能导致排序错乱 | ⚠️ 低 |
| textbook_buy 表 user_type | 有 '1教师 2学生' 字段，但已确认不需要学生角色 | ℹ️ 低 |

---

## 第二部分：需要执行的 SQL 修复

### 2.1 修复供应商数据权限

```sql
UPDATE sys_role SET data_scope = '2' WHERE role_id = 8;
```

### 2.2 清理教师角色（role_id=3）的旧版菜单，补充正确菜单

```sql
-- 先删除教师角色所有现有菜单关联
DELETE FROM sys_role_menu WHERE role_id = 3;

-- 重新插入正确的菜单关联
-- 教材管理目录
INSERT INTO sys_role_menu VALUES (3, 2086);
-- 教师首页
INSERT INTO sys_role_menu VALUES (3, 2175);
-- 教材信息查询 + 按钮
INSERT INTO sys_role_menu VALUES (3, 2176);
INSERT INTO sys_role_menu VALUES (3, 2177);
-- 我的领书申请 + 按钮
INSERT INTO sys_role_menu VALUES (3, 2178);
INSERT INTO sys_role_menu VALUES (3, 2179);
INSERT INTO sys_role_menu VALUES (3, 2180);
INSERT INTO sys_role_menu VALUES (3, 2181);
-- 缺书登记 + 按钮
INSERT INTO sys_role_menu VALUES (3, 2182);
INSERT INTO sys_role_menu VALUES (3, 2183);
-- 通知中心 + 按钮
INSERT INTO sys_role_menu VALUES (3, 2184);
INSERT INTO sys_role_menu VALUES (3, 2185);
INSERT INTO sys_role_menu VALUES (3, 2186);
```

### 2.3 修复库管员角色（role_id=7）的菜单关联

```sql
-- 先删除库管员角色所有现有菜单关联
DELETE FROM sys_role_menu WHERE role_id = 7;

-- 重新插入正确的菜单关联
-- 教材管理目录
INSERT INTO sys_role_menu VALUES (7, 2086);

-- 教材信息管理 + 按钮
INSERT INTO sys_role_menu VALUES (7, 2129);
INSERT INTO sys_role_menu VALUES (7, 2130);
INSERT INTO sys_role_menu VALUES (7, 2131);
INSERT INTO sys_role_menu VALUES (7, 2132);
INSERT INTO sys_role_menu VALUES (7, 2133);
INSERT INTO sys_role_menu VALUES (7, 2134);
INSERT INTO sys_role_menu VALUES (7, 2135);

-- 采购管理 + 按钮
INSERT INTO sys_role_menu VALUES (7, 2136);
INSERT INTO sys_role_menu VALUES (7, 2137);
INSERT INTO sys_role_menu VALUES (7, 2138);
INSERT INTO sys_role_menu VALUES (7, 2139);
INSERT INTO sys_role_menu VALUES (7, 2140);
INSERT INTO sys_role_menu VALUES (7, 2141);
INSERT INTO sys_role_menu VALUES (7, 2142);
INSERT INTO sys_role_menu VALUES (7, 2143);

-- 入库管理 + 按钮
INSERT INTO sys_role_menu VALUES (7, 2144);
INSERT INTO sys_role_menu VALUES (7, 2145);
INSERT INTO sys_role_menu VALUES (7, 2146);

-- 领书通知管理 + 按钮
INSERT INTO sys_role_menu VALUES (7, 2147);
INSERT INTO sys_role_menu VALUES (7, 2148);
INSERT INTO sys_role_menu VALUES (7, 2149);
INSERT INTO sys_role_menu VALUES (7, 2150);
INSERT INTO sys_role_menu VALUES (7, 2151);

-- 领书单管理 + 按钮
INSERT INTO sys_role_menu VALUES (7, 2152);
INSERT INTO sys_role_menu VALUES (7, 2153);
INSERT INTO sys_role_menu VALUES (7, 2154);
INSERT INTO sys_role_menu VALUES (7, 2155);

-- 个人领书管理 + 按钮
INSERT INTO sys_role_menu VALUES (7, 2156);
INSERT INTO sys_role_menu VALUES (7, 2157);
INSERT INTO sys_role_menu VALUES (7, 2158);
INSERT INTO sys_role_menu VALUES (7, 2159);
INSERT INTO sys_role_menu VALUES (7, 2160);
INSERT INTO sys_role_menu VALUES (7, 2161);

-- 缺书管理 + 按钮
INSERT INTO sys_role_menu VALUES (7, 2162);
INSERT INTO sys_role_menu VALUES (7, 2163);
INSERT INTO sys_role_menu VALUES (7, 2164);
INSERT INTO sys_role_menu VALUES (7, 2165);
INSERT INTO sys_role_menu VALUES (7, 2166);

-- 库存查询 + 按钮
INSERT INTO sys_role_menu VALUES (7, 2167);
INSERT INTO sys_role_menu VALUES (7, 2168);
INSERT INTO sys_role_menu VALUES (7, 2169);

-- 供应商管理 + 按钮
INSERT INTO sys_role_menu VALUES (7, 2170);
INSERT INTO sys_role_menu VALUES (7, 2171);
INSERT INTO sys_role_menu VALUES (7, 2172);
INSERT INTO sys_role_menu VALUES (7, 2173);
INSERT INTO sys_role_menu VALUES (7, 2174);

-- 库存盘点 + 按钮
INSERT INTO sys_role_menu VALUES (7, 2105);
INSERT INTO sys_role_menu VALUES (7, 2106);
INSERT INTO sys_role_menu VALUES (7, 2107);
INSERT INTO sys_role_menu VALUES (7, 2108);
INSERT INTO sys_role_menu VALUES (7, 2109);
INSERT INTO sys_role_menu VALUES (7, 2110);

-- 通知管理 + 按钮
INSERT INTO sys_role_menu VALUES (7, 2111);
INSERT INTO sys_role_menu VALUES (7, 2112);
INSERT INTO sys_role_menu VALUES (7, 2113);
INSERT INTO sys_role_menu VALUES (7, 2114);
INSERT INTO sys_role_menu VALUES (7, 2115);
```

### 2.4 为供应商角色（role_id=8）添加菜单关联

```sql
-- 教材管理目录
INSERT INTO sys_role_menu VALUES (8, 2086);
-- 我的采购单 + 按钮
INSERT INTO sys_role_menu VALUES (8, 2187);
INSERT INTO sys_role_menu VALUES (8, 2188);
INSERT INTO sys_role_menu VALUES (8, 2189);
-- 通知中心 + 按钮
INSERT INTO sys_role_menu VALUES (8, 2190);
INSERT INTO sys_role_menu VALUES (8, 2191);
INSERT INTO sys_role_menu VALUES (8, 2192);
```

### 2.5 （可选）清理旧版废弃菜单

```sql
-- 以下菜单是旧版，已被 2128+ 系列替代，可以隐藏或删除
UPDATE sys_menu SET status = '1' WHERE menu_id IN (2001, 2002, 2003, 2004, 2005, 2006, 2031, 2032, 2033, 2034, 2035, 2036, 2037, 2076, 2077, 2078, 2079, 2080, 2081, 2082, 2093, 2094, 2095, 2096, 2097);
-- 同时删除旧版按钮的 role_menu 关联（role_id=1 的可以保留，admin 无影响）
DELETE FROM sys_role_menu WHERE menu_id IN (2007, 2008, 2009, 2010, 2011, 2012, 2013, 2014, 2015, 2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024, 2025, 2026, 2027, 2028, 2029, 2030) AND role_id IN (3, 7, 8);
```

---

## 第三部分：TRAE 角色界面开发指令

> 以下内容可直接复制给 TRAE。执行完上面的 SQL 修复后，角色菜单隔离才能正确生效。

### 3.1 教材信息管理（textbook/book/index）

**适用角色：** 库管员（admin, warehouseman）

```
顶部搜索栏：
  ISBN（输入框） | 书名（输入框） | 作者（输入框） | 出版社（输入框） | [搜索] [重置]
  [新增] [导入] [导出]    ← v-hasPermi="['textbook:book:add']" 等

数据表格列：
  ISBN | 书名 | 作者 | 出版社 | 出版时间 | 版次 | 定价 | 适用课程 | 专业 | 年级 | 教材类型 | 当前库存 | 库存状态 | 操作

操作列：
  [编辑] [删除]    ← v-hasPermi="['textbook:book:edit']" 等

库存列样式：
  textbook_stock.stock_status='warning' → 橙色标签
  textbook_stock.stock_status='shortage' → 红色标签
  textbook_stock.stock_status='normal' → 绿色标签

新增/编辑弹窗：
  书名* | ISBN*（唯一校验） | 作者* | 出版社* | 出版时间 | 版次 | 定价*
  适用课程 | 专业* | 年级* | 教材类型（字典：textbook_type） | 描述

注意：库存字段不允许编辑，库存仅通过入库/出库流程变更
```

### 3.2 教材信息查询（textbook/bookQuery/index）

**适用角色：** 教师（teacher）

```
顶部搜索栏：
  ISBN | 书名 | 作者 | [搜索] [重置]
  无 [新增] [编辑] [删除] [导入] [导出] 按钮

数据表格列（只读）：
  ISBN | 书名 | 作者 | 出版社 | 出版时间 | 定价 | 适用课程 | 当前库存 | 库存状态

操作列：仅 [查看详情]（弹窗）

数据权限：全部教材可见，但不能增删改
```

### 3.3 采购管理（textbook/purchase/index）

**适用角色：** 库管员（admin, warehouseman）

```
顶部搜索栏：
  采购单号 | ISBN | 供应商（下拉） | 状态（下拉：0待采购/1采购中/2已到货/3已入库） | [搜索] [重置]
  [新增] [Excel导入]    ← v-hasPermi

数据表格列：
  采购单号(pending_no) | ISBN | 书名 | 采购数量 | 供应商 | 负责人 | 状态 | 创建时间 | 操作

状态标签：
  0 → 蓝色"待采购" | 1 → 橙色"采购中" | 2 → 绿色"已到货" | 3 → 灰色"已入库"

操作列（按 status 动态显示）：
  0：[编辑] [删除] [推进状态]
  1：[确认到货]
  2：[确认入库]
  3：[查看明细]

Excel导入弹窗：
  [下载导入模板] → 上传文件（.xlsx, ≤10MB, ≤1000行）→ 预览结果 → [确认导入]
  模板固定列：ISBN | 教材名称 | 采购数量 | 申请学院 | 申请专业 | 备注
  按列下标读取，逐行校验，单行失败不阻断
  导入逻辑：一个Excel → 一条textbook_pending + 多条textbook_purchase_detail
  @Transactional事务，绝不修改textbook_stock
```

### 3.4 入库管理（textbook/inbound/index）

**适用角色：** 库管员（admin, warehouseman）

```
数据表格列：
  入库单号(inbound_no) | ISBN | 书名 | 入库数量 | 供应商 | 入库时间 | 操作人 | 操作

操作列：
  未入库：[确认入库]
  已入库：无操作

确认入库弹窗：
  显示采购明细，每行可修改实入库数量
  [取消] [确认入库]

后端逻辑（@Transactional）：
  1. INSERT textbook_in
  2. UPDATE textbook_stock（乐观锁 version）
  3. INSERT textbook_stock_flow（business_type='1'）
  4. UPDATE textbook_pending SET status='3'
  5. 更新 textbook_lack.handle_status
  6. INSERT sys_notice（通知供应商）
```

### 3.5 领书通知管理（textbook/noticeManage/index）

**适用角色：** 库管员（admin, warehouseman）

```
顶部搜索栏：
  学期（下拉） | 状态（下拉：0草稿/1已发布/2领取中/3已完成） | [搜索] [重置]
  [发布领书通知]

数据表格列：
  通知编号(notice_no) | 学期 | 领取时间段 | 领取地点 | 班级总数 | 已出库班级数 | 状态 | 操作

操作列：
  草稿：[编辑] [删除] [发布]
  已发布/领取中：[打印领书单]
  已完成：[查看] [打印领书单]

发布弹窗：
  学期* | 领取开始时间* | 领取结束时间* | 领取地点
  明细表格（动态添加行）：学院 | 专业 | 班级 | 教材（下拉搜索） | 应发数量*
  系统校验 textbook_stock.stock_num >= 应发数量
  [保存草稿] [保存并发布]

发布逻辑：
  INSERT/UPDATE textbook_notice
  为每个班级生成 textbook_claim_form + textbook_claim_form_detail
  领书通知仅系统内展示，不推送消息
```

### 3.6 领书单管理（textbook/claimForm/index）

**适用角色：** 库管员（admin, warehouseman）

```
数据表格列：
  领书单号(form_no) | 班级名称 | 应发总数 | 实发总数 | 领书人 | 状态 | 操作

状态标签：
  0待领取 → 蓝色 | 1部分出库 → 橙色 | 2已出库 → 绿色

操作列：
  待领取/部分出库：[查看明细] [确认出库]
  已出库：[查看明细] [打印]

确认出库弹窗：
  教材明细列表：ISBN | 书名 | 应发 | 已出 | 本次出库（可修改）
  领书人姓名*
  [取消] [确认出库]

后端逻辑（@Transactional）：
  1. UPDATE textbook_stock（乐观锁扣减）
  2. INSERT textbook_out
  3. INSERT textbook_stock_flow（business_type='2'）
  4. UPDATE textbook_claim_form + detail
  5. 全部出库完 → 更新 textbook_notice.status='3'
```

### 3.7 个人领书管理（textbook/personalApply/index）

**适用角色：** 库管员（admin, warehouseman）

```
数据表格列：
  申请编号(apply_no) | 教师姓名 | ISBN | 书名 | 申请数量 | 用途 | 状态 | 审核意见 | 申请时间 | 操作

状态标签：
  0待审核 → 蓝色 | 1已通过 → 绿色 | 2已驳回 → 红色 | 3已出库 → 灰色 | 4已取消 → 灰色

操作列：
  待审核：[审核]
  已通过：[确认出库]
  其他：[查看]

审核弹窗：
  ○ 通过  ○ 驳回
  审核意见
  ☑ 同时登记缺书（驳回时可选）
    紧急程度 | 缺书数量
  [确认]

驳回+登记缺书（@Transactional）：
  1. UPDATE textbook_personal_apply SET status='2'
  2. INSERT textbook_lack（source='2'审核转入）
  3. INSERT sys_notice（通知教师）
```

### 3.8 我的领书申请（textbook/myApply/index）

**适用角色：** 教师（teacher）

```
顶部：[提交领书申请]

数据表格（WHERE teacher_id = 当前用户）：
  申请编号 | ISBN | 书名 | 申请数量 | 用途 | 状态 | 审核意见 | 申请时间 | 操作

操作列：
  0待审核：[取消申请]
  2已驳回：[查看原因] [重新申请]
  其他：[查看]

提交弹窗：
  选择教材（下拉搜索） | 申请数量* | 申请用途*
  [取消] [提交]
```

### 3.9 缺书管理（textbook/shortage/index）

**适用角色：** 库管员（admin, warehouseman）

```
[登记缺书] 按钮

数据表格列：
  ISBN | 书名 | 缺书数量 | 紧急程度 | 登记人 | 来源 | 处理状态 | 操作

操作列：
  未处理：[转采购单] [编辑] [删除]
  其他：[查看]
```

### 3.10 缺书登记（textbook/registerShortage/index）

**适用角色：** 教师（teacher）

```
[登记缺书] 按钮

数据表格（WHERE register_id = 当前用户）：
  ISBN | 书名 | 缺书数量 | 紧急程度 | 处理状态 | 登记时间 | 操作

操作列：仅 [查看]

登记弹窗：
  选择教材 | 缺书数量* | 紧急程度 | 备注
  [取消] [提交]

后端：INSERT textbook_lack + INSERT sys_notice（通知库管员）
```

### 3.11 库存查询（textbook/inventory/index）

**适用角色：** 库管员（admin, warehouseman）

```
数据表格（只读）：
  ISBN | 书名 | 当前库存 | 预警阈值 | 库存状态 | 累计采购 | 累计出库

库存状态样式：
  normal → 绿色 | warning → 橙色+行背景 | shortage → 红色+行背景

[查看流水] → 弹窗/子页面展示 textbook_stock_flow
[导出]
```

### 3.12 我的采购单（textbook/supplierPurchase/index）

**适用角色：** 供应商（supplier）

```
数据表格（WHERE supplier = 当前供应商名称）：
  采购单号 | ISBN | 书名 | 采购数量 | 负责人 | 状态 | 创建时间 | 操作

操作列：
  status=1：[确认发货]
  其他：[查看明细]

确认发货弹窗：
  物流单号 | 快递公司 | 发货备注
  [取消] [确认]
```

### 3.13 通知中心（textbook/myNotice/index 和 textbook/supplierNotice/index）

**适用角色：** 教师、供应商

```
[全部标记已读]
Tab：全部 | 未读 | 已读

通知卡片列表（来自 sys_notice）：
  未读/已读标记 | 标题 | 内容摘要 | 类型标签 | 时间

教师通知类型（user_type='1'）：
  领书审核结果 | 出库通知 | 缺书处理进度

供应商通知类型（user_type='3'）：
  入库通知（ISBN、书名、数量、入库时间、采购单号）

点击通知：标记已读
```

### 3.14 供应商管理（textbook/supplier/index）

**适用角色：** 库管员（admin, warehouseman）

```
[新增] [导出]

数据表格列：
  供应商编码 | 供应商名称 | 联系人 | 联系电话 | 折扣率 | 付款账期 | 状态 | 操作

操作列：[编辑] [删除]
```

---

## 第四部分：角色-菜单分配速查表

### 库管员（role_id=7）应分配的 menu_id

```
2086                          -- 教材管理目录
2129,2130,2131,2132,2133,2134,2135  -- 教材信息管理+按钮
2136,2137,2138,2139,2140,2141,2142,2143  -- 采购管理+按钮
2144,2145,2146                -- 入库管理+按钮
2147,2148,2149,2150,2151      -- 领书通知管理+按钮
2152,2153,2154,2155           -- 领书单管理+按钮
2156,2157,2158,2159,2160,2161 -- 个人领书管理+按钮
2162,2163,2164,2165,2166      -- 缺书管理+按钮
2167,2168,2169                -- 库存查询+按钮
2170,2171,2172,2173,2174      -- 供应商管理+按钮
2105,2106,2107,2108,2109,2110 -- 库存盘点+按钮
2111,2112,2113,2114,2115      -- 通知管理+按钮
```

### 教师（role_id=3）应分配的 menu_id

```
2086                          -- 教材管理目录
2175                          -- 教师首页
2176,2177                     -- 教材信息查询+按钮
2178,2179,2180,2181           -- 我的领书申请+按钮
2182,2183                     -- 缺书登记+按钮
2184,2185,2186                -- 通知中心+按钮
```

### 供应商（role_id=8）应分配的 menu_id

```
2086                          -- 教材管理目录
2187,2188,2189                -- 我的采购单+按钮
2190,2191,2192                -- 通知中心+按钮
```

---

## 第五部分：各角色登录后看到的界面对比

```
┌─────────────────────────────────────────────────────────────────┐
│                        超级管理员 (admin)                         │
├─────────────────────────────────────────────────────────────────┤
│  系统管理                                                        │
│    用户管理 | 角色管理 | 菜单管理 | 部门管理 | 字典管理 | ...     │
│  教材管理                                                        │
│    教材信息管理 | 采购管理 | 入库管理 | 领书通知 | 领书单         │
│    个人领书 | 缺书管理 | 库存查询 | 供应商 | 库存盘点 | 通知     │
│  系统监控 | 系统工具                                              │
├─────────────────────────────────────────────────────────────────┤
│                        库管员 (warehouse)                       │
├─────────────────────────────────────────────────────────────────┤
│  教材管理                                                        │
│    教材信息管理 | 采购管理 | 入库管理 | 领书通知 | 领书单         │
│    个人领书 | 缺书管理 | 库存查询 | 供应商 | 库存盘点 | 通知     │
│                                                                  │
│  特点：全部增删改查权限，全部业务数据可见                           │
├─────────────────────────────────────────────────────────────────┤
│                        教师 (teacher)                            │
├─────────────────────────────────────────────────────────────────┤
│  教材管理                                                        │
│    教师首页 | 教材信息查询(只读) | 我的领书申请                    │
│    缺书登记 | 通知中心                                            │
│                                                                  │
│  特点：只能查看教材，只能看本人数据，无管理权限                     │
├─────────────────────────────────────────────────────────────────┤
│                        供应商 (supplier)                         │
├─────────────────────────────────────────────────────────────────┤
│  教材管理                                                        │
│    我的采购单(只读) | 通知中心                                    │
│                                                                  │
│  特点：只能查看与自己相关的采购单，只能确认发货和查看通知           │
└─────────────────────────────────────────────────────────────────┘
```
