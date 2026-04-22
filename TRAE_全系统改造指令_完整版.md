# 教材采购与库存管理系统 — TRAE 全系统改造指令

> 本文档整合了所有业务需求、角色权限、页面规格、流程逻辑、校验规则，
> 可直接复制给 TRAE 进行全系统改造开发。
> 系统基于 RuoYi-Vue 3.9.0，技术栈：SpringBoot 2.x + Vue2 + ElementUI + MySQL + Redis。

---

# 第一部分：系统概览

## 1.1 系统名称
教材采购与库存管理系统

## 1.2 角色定义

| 角色 | role_key | role_id | data_scope | 说明 |
|---|---|---|---|---|
| 超级管理员 | admin | 1 | 1（全部数据） | 拥有所有权限 |
| 库管员 | warehouse | 7 | 1（全部数据） | 教材管理核心角色 |
| 教师 | teacher | 3 | 5（仅本人数据） | 提交领书申请、查看教材、登记缺书 |
| 供应商 | supplier | 8 | 2（自定义数据权限） | 查看采购单、确认发货、接收通知 |

## 1.3 核心业务流程

### 流程1：班级领书（主线）
```
教务处给库管员 Excel 教材统计表
    ↓
库管员导入系统 → 生成采购单
    ↓
供应商备货发货 → 库管员确认到货 → 确认入库
    ↓
系统自动：增加库存 + 生成流水 + 通知供应商
    ↓
库管员发布领书通知 → 系统自动生成领书单（每班一张）
    ↓
领书通知仅系统内展示，不推送消息（班委无系统账号）
    ↓
班委到仓库领书 → 在纸质领书单上签名（线下）
    ↓
库管员在系统中确认出库 → 自动扣减库存 + 生成流水
```

### 流程2：个人领书（辅线）
```
教师提交领书申请
    ↓
库管员审核
    ├─ 库存充足 → 审核通过 → 通知教师 → 确认出库 → 扣库存 + 生成流水
    └─ 库存不足 → 审核驳回（可选同时登记缺书）→ 通知教师
```

### 流程3：缺书与采购
```
教材缺货 → 教师/库管员登记缺书 → 系统通知库管员
    ↓
库管员一键转采购单（或Excel批量导入）
    ↓
待采购 → 采购中 → 供应商发货 → 已到货 → 确认入库
    ↓
系统自动：增加库存 + 生成流水 + 更新缺书单"已完成" + 通知登记人
```

### 流程4：审核驳回+登记缺书（路径B）
```
库管员驳回个人领书申请
    ↓
驳回弹窗中勾选"同时登记缺书"
    ↓
@Transactional 事务执行：
  1. 更新申请状态为"已驳回"
  2. 创建缺书单（source='审核转入'）
  3. 通知教师（驳回原因 + 已登记缺书）
    ↓
后续：缺书单转采购单 → 采购入库 → 通知教师重新申请
```

## 1.4 采购单状态流转（严格顺序，不允许跳转）
```
待采购(0) → 采购中(1) → 已到货(2) → 已入库(3)
```
已到货/已入库的采购单禁止编辑和删除。

## 1.5 库存铁律
- 库存增加的唯一途径：入库确认（textbook_in）
- 库存减少的唯一途径：出库确认（textbook_out）
- **绝对禁止**任何接口直接 UPDATE textbook_stock.stock_num
- 每次库存变动必须同时 INSERT textbook_stock_flow 流水记录
- textbook_stock_flow 表不允许 UPDATE 和 DELETE
- 库存更新必须使用乐观锁：WHERE version = #{version}

---

# 第二部分：数据库改造

## 2.1 textbook_info 表新增字段

```sql
ALTER TABLE textbook_info ADD COLUMN `info_status` char(1) DEFAULT '1' COMMENT '信息完整度 0待完善 1已完善';
ALTER TABLE textbook_info ADD COLUMN `info_source` char(1) DEFAULT '0' COMMENT '来源 0手动录入 1教师领书快速新增 2缺书快速新增 3导入自动新增';
```

## 2.2 新增数据字典

```sql
-- 教材信息状态
INSERT INTO sys_dict_type VALUES (100, '教材信息状态', 'textbook_info_status', '0', 'admin', now(), '', null, '教材信息完整度');
INSERT INTO sys_dict_data VALUES (200, 1, '待完善', '0', 'textbook_info_status', '', 'warning', 'N', '0', 'admin', now(), '', null, '');
INSERT INTO sys_dict_data VALUES (201, 2, '已完善', '1', 'textbook_info_status', '', 'success', 'N', '0', 'admin', now(), '', null, '');

-- 教材信息来源
INSERT INTO sys_dict_type VALUES (101, '教材信息来源', 'textbook_info_source', '0', 'admin', now(), '', null, '教材信息创建来源');
INSERT INTO sys_dict_data VALUES (202, 1, '手动录入', '0', 'textbook_info_source', '', '', 'N', '0', 'admin', now(), '', null, '');
INSERT INTO sys_dict_data VALUES (203, 2, '教师快速新增', '1', 'textbook_info_source', '', '', 'N', '0', 'admin', now(), '', null, '');
INSERT INTO sys_dict_data VALUES (204, 3, '缺书快速新增', '2', 'textbook_info_source', '', '', 'N', '0', 'admin', now(), '', null, '');
INSERT INTO sys_dict_data VALUES (205, 4, '导入自动新增', '3', 'textbook_info_source', '', '', 'N', '0', 'admin', now(), '', null, '');
```

## 2.3 修复角色-菜单关联

```sql
-- ========== 修复教师角色（role_id=3）==========
DELETE FROM sys_role_menu WHERE role_id = 3;
INSERT INTO sys_role_menu VALUES (3, 2086);  -- 教材管理目录
INSERT INTO sys_role_menu VALUES (3, 2175);  -- 教师首页
INSERT INTO sys_role_menu VALUES (3, 2176);  -- 教材信息查询
INSERT INTO sys_role_menu VALUES (3, 2177);  -- 教材信息查询 query
INSERT INTO sys_role_menu VALUES (3, 2178);  -- 我的领书申请
INSERT INTO sys_role_menu VALUES (3, 2179);  -- 我的领书申请 view
INSERT INTO sys_role_menu VALUES (3, 2180);  -- 我的领书申请 submit
INSERT INTO sys_role_menu VALUES (3, 2181);  -- 我的领书申请 cancel
INSERT INTO sys_role_menu VALUES (3, 2182);  -- 缺书登记
INSERT INTO sys_role_menu VALUES (3, 2183);  -- 缺书登记 register
INSERT INTO sys_role_menu VALUES (3, 2184);  -- 通知中心
INSERT INTO sys_role_menu VALUES (3, 2185);  -- 通知中心 view
INSERT INTO sys_role_menu VALUES (3, 2186);  -- 通知中心 read

-- ========== 修复库管员角色（role_id=7）==========
DELETE FROM sys_role_menu WHERE role_id = 7;
INSERT INTO sys_role_menu VALUES (7, 2086);  -- 教材管理目录
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
INSERT INTO sys_role_menu VALUES (7, 2116);
INSERT INTO sys_role_menu VALUES (7, 2117);
INSERT INTO sys_role_menu VALUES (7, 2118);
INSERT INTO sys_role_menu VALUES (7, 2119);
INSERT INTO sys_role_menu VALUES (7, 2120);
INSERT INTO sys_role_menu VALUES (7, 2121);
-- 领书单管理 + 按钮
INSERT INTO sys_role_menu VALUES (7, 2122);
INSERT INTO sys_role_menu VALUES (7, 2123);
INSERT INTO sys_role_menu VALUES (7, 2124);
INSERT INTO sys_role_menu VALUES (7, 2125);
INSERT INTO sys_role_menu VALUES (7, 2126);
INSERT INTO sys_role_menu VALUES (7, 2127);
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
INSERT INTO sys_role_menu VALUES (7, 2098);
INSERT INTO sys_role_menu VALUES (7, 2099);
INSERT INTO sys_role_menu VALUES (7, 2100);
INSERT INTO sys_role_menu VALUES (7, 2101);
INSERT INTO sys_role_menu VALUES (7, 2102);
INSERT INTO sys_role_menu VALUES (7, 2103);
INSERT INTO sys_role_menu VALUES (7, 2104);
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
-- 库管员首页
INSERT INTO sys_role_menu VALUES (7, 2200);
```

---

# 第三部分：后端接口改造

## 3.1 新增接口清单

| 接口 | 方法 | 路径 | 权限 | 说明 |
|---|---|---|---|---|
| 快速新增教材 | POST | /textbook/book/quickAdd | textbook:book:quickAdd | 业务流程中内联新增 |
| 补充完善教材 | PUT | /textbook/book/completeInfo | textbook:book:edit | 库管员补全待完善教材 |
| 教材搜索 | GET | /textbook/book/searchList | textbook:book:query | 远程搜索下拉框用 |

## 3.2 快速新增教材（quickAdd）

```java
@Transactional
public TextbookInfo quickAdd(TextbookInfo info) {
    // 1. ISBN 非空、格式合法（10或13位）
    // 2. 书名非空
    // 3. ISBN 唯一性校验
    // 4. 设置 info_status='0'（待完善）、info_source=传入值
    // 5. INSERT textbook_info
    // 6. 自动 INSERT textbook_stock（stock_num=0, warning_num=30, stock_status='shortage', version=0）
    // 7. 返回新创建的教材信息
}
```

## 3.3 补充完善教材（completeInfo）

```java
public void completeInfo(TextbookInfo info) {
    // 1. 根据 book_id 查询教材
    // 2. 如果 info_status 已经是 '1'，抛异常
    // 3. 更新教材信息
    // 4. 设置 info_status='1'
}
```

## 3.4 修改 Excel 导入采购单

原逻辑：ISBN 不存在 → 该行失败 → 跳过

新逻辑：
```java
TextbookInfo existBook = textbookInfoMapper.selectByIsbn(isbn);
if (existBook == null) {
    // 自动创建教材（仅填ISBN+书名）
    TextbookInfo newBook = new TextbookInfo();
    newBook.setIsbn(isbn);
    newBook.setBookName(row.getBookName());
    newBook.setInfoStatus("0");
    newBook.setInfoSource("3"); // 导入自动新增
    textbookInfoMapper.insertTextbookInfo(newBook);

    // 自动创建库存
    TextbookStock stock = new TextbookStock();
    stock.setBookId(newBook.getBookId());
    stock.setStockNum(0);
    stock.setWarningNum(30);
    stock.setStockStatus("shortage");
    stock.setVersion(0);
    textbookStockMapper.insertTextbookStock(stock);

    existBook = newBook;
    autoCreatedCount++;
    // 不跳过，继续正常创建采购明细
}
```

导入结果返回值增加：
```json
{
  "total": 50,
  "success": 50,
  "fail": 0,
  "autoCreated": 3,
  "autoCreatedRows": [
    {"rowNum": 5, "isbn": "9787123...", "bookName": "人工智能导论"}
  ]
}
```

## 3.5 修改入库确认逻辑

入库时如果关联教材 info_status='0'，自动更新为 '1'：
```java
// 在入库确认的 @Transactional 方法中增加
if ("0".equals(bookInfo.getInfoStatus())) {
    bookInfo.setInfoStatus("1");
    textbookInfoMapper.updateTextbookInfo(bookInfo);
}
```

## 3.6 修改审核驳回逻辑

驳回个人领书申请时支持同时登记缺书：
```java
@Transactional
public void auditPersonalApply(Long applyId, String result, String opinion,
                                Boolean registerShortage, String urgency, Integer shortageQty) {
    if ("reject".equals(result)) {
        // 1. 更新申请状态为"已驳回"
        // 2. 如果 registerShortage=true：
        //    INSERT textbook_lack（source='2'审核转入, source_id=applyId）
        // 3. INSERT sys_notice 通知教师
    } else {
        // 审核通过，通知教师
    }
}
```

## 3.7 事务要求

以下操作必须加 @Transactional，要么全成功要么全回滚：

| 操作 | 包含步骤 |
|---|---|
| 入库确认 | 更新库存 + 生成流水 + 更新采购单状态 + 更新缺书单 + 通知供应商 + 更新教材info_status |
| 出库确认（班级） | 更新库存 + 生成流水 + 更新领书单 + 更新领书通知状态 |
| 出库确认（个人） | 更新库存 + 生成流水 + 更新申请状态 + 通知教师 |
| 审核驳回+登记缺书 | 更新申请 + 创建缺书单 + 通知教师 |
| Excel导入采购单 | 创建主单 + 创建明细 + 自动创建教材 + 关联缺书单 |
| 发布领书通知 | 创建通知 + 生成领书单 + 生成领书单明细 |

---

# 第四部分：前端页面改造

## 4.1 各角色可见菜单

### 库管员（12个页面）
```
教材管理
  ├─ 库管员首页（2200，textbook/warehouseDashboard/index）
  ├─ 教材信息管理（2129，textbook/bookManage/index）
  ├─ 采购管理（2136，textbook/purchase/index）
  ├─ 入库管理（2144，textbook/inbound/index）
  ├─ 领书通知管理（2116，textbook/noticeManage/index）
  ├─ 领书单管理（2122，textbook/claimForm/index）
  ├─ 个人领书管理（2156，textbook/personalApply/index）
  ├─ 缺书管理（2162，textbook/shortage/index）
  ├─ 库存查询（2167，textbook/inventory/index）
  ├─ 供应商管理（2098，textbook/supplierManage/index）
  ├─ 库存盘点（2105，textbook/inventoryCheck/index）
  └─ 通知管理（2111，textbook/warehouseNotice/index）
```

### 教师（5个页面）
```
教材管理
  ├─ 教师首页（2175，textbook/dashboard/index）
  ├─ 教材信息查询（2176，textbook/bookQuery/index）— 只读，无增删改按钮
  ├─ 我的领书申请（2178，textbook/myApply/index）
  ├─ 缺书登记（2182，textbook/registerShortage/index）
  └─ 通知中心（2184，textbook/myNotice/index）
```

### 供应商（2个页面）
```
教材管理
  ├─ 我的采购单（2187，textbook/supplier/purchase/index）— 只读
  └─ 通知中心（2190，textbook/supplier/notice/index）
```

## 4.2 教材信息管理页面改造

**适用角色：** 库管员

新增/修改点：
1. 搜索栏增加"信息状态"下拉（全部/待完善/已完善）
2. 表格增加"信息状态"列：
   - `0` → `<el-tag type="warning">待完善</el-tag>` 橙色，整行背景浅黄
   - `1` → `<el-tag type="success">已完善</el-tag>` 绿色
3. 操作列：info_status='0' 时额外显示 [补充完善] 按钮
4. [补充完善] 弹窗：与编辑弹窗类似，顶部加提示"该教材信息不完整，请补充完善"
5. 新增/编辑弹窗中**不显示库存字段**，库存只能通过入库/出库变更

## 4.3 采购管理页面改造

**适用角色：** 库管员

### Excel导入弹窗改造
```
步骤一：[下载导入模板]
  模板固定列：ISBN | 教材名称 | 采购数量 | 申请学院 | 申请专业 | 备注

步骤二：上传文件（仅.xlsx，≤10MB，≤1000行）

步骤三：预览结果
  统计：总条数 / ✅成功 / ⚠️自动新增教材 / ❌失败
  预览表格增加"状态"列：
    正常行 → 绿色标签
    自动新增行 → 橙色标签 + 行背景浅黄
    失败行 → 红色标签 + 行背景浅红
  失败行显示行号+原因
  [确认导入（50条，含3本自动新增教材）]
```

### 导入校验规则
- 按固定列下标读取，不按表头匹配
- 跳过空行、表头行、无效行
- 逐行校验：ISBN非空+格式+系统存在（不存在则自动创建）、数量正整数1-9999、学院/专业字典校验
- 单行失败不阻断整批
- 一个Excel → 一条 textbook_pending + 多条 textbook_purchase_detail
- @Transactional 事务，绝不修改 textbook_stock
- 记录 file_hash 防重复导入

### 操作按钮动态显示
| 状态 | 显示按钮 |
|---|---|
| 待采购(0) | 编辑、删除、推进状态、查看明细 |
| 采购中(1) | 确认到货、查看明细 |
| 已到货(2) | 确认入库、查看明细 |
| 已入库(3) | 仅查看明细 |

## 4.4 入库管理页面改造

**适用角色：** 库管员

确认入库弹窗：
- 显示采购单明细列表
- 每行：ISBN、书名、采购数量、实入库数量（可修改，默认=采购数量）
- 支持部分入库
- 确认后执行 @Transactional 事务

## 4.5 领书通知管理页面改造

**适用角色：** 库管员

发布领书通知弹窗：
```
基本信息：学期* | 领取开始时间* | 领取结束时间* | 领取地点
明细表格（动态添加行）：
  学院（下拉）| 专业（下拉）| 班级（下拉）| 教材（下拉搜索）| 应发数量*
  系统校验 textbook_stock.stock_num >= 应发数量
  库存不足时：应发数量列红色，行背景浅红，但允许保存
[保存草稿] [保存并发布]

发布逻辑：
  INSERT/UPDATE textbook_notice
  为每个班级生成 textbook_claim_form（自动生成 form_no）
  为每条领书单生成 textbook_claim_form_detail
  领书通知仅系统内展示，不推送消息
```

## 4.6 领书单管理页面改造

**适用角色：** 库管员

确认出库弹窗：
```
显示该班级的教材明细（textbook_claim_form_detail）
每行：ISBN | 书名 | 应发数量 | 已出库数量 | 本次出库数量（可修改，默认=应发-已出）
领书人姓名输入框*
[取消] [确认出库]
```

支持部分出库（分多次出库）。
出库后全部完成 → 更新 textbook_notice.status='3'已完成。
领书单支持打印（含签名栏）。

## 4.7 个人领书管理页面改造（库管员视角）

**适用角色：** 库管员

审核弹窗（核心交互）：
```
申请信息（只读灰色背景）：
  教师姓名 | 教材名称 | ISBN | 申请数量 | 当前库存
  ⚠️ 库存不足时显示红色警告

审核操作：
  ○ 通过  ○ 驳回
  审核意见（文本域）

  ┌─ 驳回时显示（v-if="form.result === 'reject'"）─┐
  │ ☑ 同时登记缺书（默认勾选）                      │
  │ 紧急程度：○ 普通  ● 紧急  ○ 特急               │
  │ 缺书数量：[默认取申请数量，可修改]              │
  └───────────────────────────────────────────────┘

[取消] [确认审核]
```

## 4.8 我的领书申请页面改造（教师视角）

**适用角色：** 教师

提交领书申请弹窗改造：
```
教材选择：el-select filterable remote（远程搜索ISBN/书名）
搜索无结果时显示：[该教材不存在，点击快速新增]

快速新增表单（内联展开）：
  ISBN* | 书名* | 作者* | 出版社 | 定价 | 适用课程 | 专业 | 年级 | 教材类型
  ⚠️ 快速新增的教材信息不完整，库管员后续会补充完善
  [取消新增] [确认新增并继续]

确认新增后自动选中该教材，继续填写申请数量*、用途* → [提交]
```

## 4.9 缺书登记页面改造（教师视角）

**适用角色：** 教师

与 4.8 完全相同的快速新增逻辑，source 参数传 '2'。

## 4.10 通知中心页面改造

**适用角色：** 教师、供应商

```
[全部标记已读]
Tab：[全部] [未读] [已读]

通知卡片列表（来自 sys_notice）：
  未读：蓝色圆点 + 卡片左边框蓝色
  已读：灰色圆点 + 无边框颜色
  每条：通知类型标签 | 标题 | 内容摘要 | 时间 | [查看详情] [标记已读]

教师通知类型：领书审核结果、出库通知、缺书处理进度
供应商通知类型：入库通知（ISBN、书名、数量、入库时间、采购单号）
```

## 4.11 库管员首页改造

统计卡片增加"待完善教材"：
```
┌──────────────┐ ┌──────────────┐ ┌──────────────┐ ┌──────────────┐
│ 📋 待审核申请 │ │ 📦 待完善教材 │ │ 🔴 库存预警数 │ │ 📝 待处理缺书 │
│     1        │ │     3        │ │     12       │ │     5        │
│  点击查看 →  │ │  点击查看 →  │ │  点击查看 →  │ │  点击查看 →  │
└──────────────┘ └──────────────┘ └──────────────┘ └──────────────┘
```

点击"待完善教材"跳转到教材信息管理，自动筛选 info_status='0'。

---

# 第五部分：权限控制规范

## 5.1 前端权限

| 页面 | 角色 | 可见按钮 | 不可见按钮 |
|---|---|---|---|
| 教材信息管理 | 库管员 | 新增、编辑、删除、导入、导出、补充完善 | — |
| 教材信息查询 | 教师 | 仅查看详情 | 新增、编辑、删除、导入、导出 |
| 采购管理 | 库管员 | 新增、Excel导入、编辑、删除、状态操作 | — |
| 我的采购单 | 供应商 | 仅确认发货、查看明细 | 新增、编辑、删除、导入 |
| 个人领书管理 | 库管员 | 审核、确认出库 | 提交、取消 |
| 我的领书申请 | 教师 | 提交、取消（仅待审核） | 审核、确认出库 |

所有按钮使用 `v-hasPermi="['xxx:xxx:xxx']"` 指令控制。

## 5.2 后端权限

每个 Controller 接口必须有 `@PreAuthorize("@ss.hasPermi('xxx:xxx:xxx')")` 注解。

## 5.3 数据权限

| 角色 | 实现方式 |
|---|---|
| admin | 不过滤 |
| warehouse | 不过滤，可看全部业务数据 |
| teacher | MyBatis 查询加 WHERE teacher_id = #{userId} 或 register_id = #{userId} |
| supplier | MyBatis 查询加 WHERE supplier = #{supplierName} |

---

# 第六部分：通知模块规范

## 6.1 通知触发点

| 业务节点 | 通知类型 | 推送对象 | 内容 |
|---|---|---|---|
| 审核通过 | 领书审核结果 | 教师 | 您申请的《xxx》已通过审核 |
| 审核驳回 | 领书审核结果 | 教师 | 您申请的《xxx》已被驳回，原因：xxx |
| 驳回+登记缺书 | 领书审核结果 | 教师 | 已驳回+已登记缺书 |
| 确认出库 | 出库通知 | 教师 | 《xxx》已出库，请到书库领取 |
| 教师登记缺书 | 缺书通知 | 库管员 | 有新缺书登记 |
| 导入完成 | 操作通知 | 库管员 | 导入完成，成功x条 |
| 入库完成 | 入库通知 | 供应商 | ISBN、书名、数量、入库时间、采购单号 |
| 缺书到货 | 缺书通知 | 登记人 | 缺书已到货，请重新申请 |

## 6.2 sys_notice 扩展字段

| 字段 | 类型 | 说明 |
|---|---|---|
| biz_id | bigint | 关联业务ID |
| biz_type | char(1) | 1领书单 2采购单 3入库单 4缺书登记 5供应商通知 6库存预警 |
| read_status | char(1) | 0未读 1已读 |
| target_user_id | bigint | 目标用户ID |
| user_type | char(1) | 1教师 2库管员 3供应商 |

---

# 第七部分：全局交互规范

## 7.1 弹窗规范
- `:close-on-click-modal="false"` 防误关
- 提交按钮 loading 防重复提交
- 宽度：小420px / 中500px / 大600px / 超大700-800px
- 按钮右下角：[取消] 左，[确认] 右

## 7.2 表格规范
- `stripe` + `border`
- 长文本 `show-overflow-tooltip`
- 空数据"暂无数据"
- `v-loading`

## 7.3 标签颜色统一

| 状态 | el-tag type | 颜色 |
|---|---|---|
| 正常/成功/已通过/已出库/已完成/已完善 | success | 绿色 |
| 预警/采购中/领取中/部分出库/紧急/待完善 | warning | 橙色 |
| 缺货/已驳回/特急 | danger | 红色 |
| 草稿/已入库/已取消/普通 | info | 灰色 |
| 待审核/待采购/已发布/已到货 | 默认 | 蓝色 |

## 7.4 确认弹窗
```javascript
删除：this.$confirm('确定要删除吗？', '提示', { type: 'warning' })
危险操作：this.$confirm('此操作不可撤销，确认执行？', '提示', { type: 'warning' })
```

## 7.5 消息提示
```javascript
成功：this.$message.success('操作成功')
失败：this.$message.error('操作失败：' + error.message)
警告：this.$message.warning('请填写完整信息')
```

---

# 第八部分：交付产物清单

请按以下顺序交付：

### 数据库
1. SQL 变更脚本（ALTER TABLE + 字典数据 + 角色菜单修复）

### 后端
2. TextbookInfo.java（新增 infoStatus、infoSource 字段）
3. ITextbookInfoService.java（新增 quickAdd、completeInfo、searchList 方法）
4. TextbookInfoServiceImpl.java（实现上述方法）
5. TextbookInfoController.java（新增 3 个接口）
6. TextbookInfoMapper.java（新增 selectByIsbn）
7. TextbookInfoMapper.xml（新增 selectByIsbn、修改列表查询增加 info_status）
8. TextbookPendingServiceImpl.java（修改 importPurchase，ISBN不存在时自动创建）
9. PersonalApplyServiceImpl.java（修改审核逻辑，驳回时支持同时登记缺书）
10. InboundServiceImpl.java（入库时自动更新教材 info_status）

### 前端
11. api/textbook/book.js（新增 quickAddBook、completeBookInfo、searchBookList）
12. 教材信息管理页面（增加信息状态列、补充完善功能）
13. 采购管理页面（修改 Excel 导入弹窗预览展示）
14. 我的领书申请页面（增加快速新增教材）
15. 缺书登记页面（增加快速新增教材）
16. 通知中心页面（教师版 + 供应商版）
17. 库管员首页（增加待完善教材统计卡片）

请现在开始实现，按顺序逐个文件交付。
