# 教材管理系统 - RESTful API 文档

**版本**: v4.0
**更新日期**: 2026-04-16
**Base URL**: `http://localhost:8080`
**认证方式**: JWT Bearer Token
**数据格式**: JSON (UTF-8)
**文档状态**: ✅ 生产就绪

---

## 📌 v4.0 更新日志 (2026-04-16)

### 🆕 新增模块：领书通知与领书单管理（14个新API端点）

基于设计文档《教材采购系统_完整流程设计.md》§5.1-§5.5 实现的完整领书流程模块。

#### 🆕 新增API端点 (14个)

| 方法 | 路径 | 功能 | 模块 |
|------|------|------|------|
| GET | `/textbook/notice/list` | 领书通知列表查询 | 📢 **领书通知管理** |
| GET | `/textbook/notice/{noticeId}` | 领书通知详情 | 📢 **领书通知管理** |
| POST | `/textbook/notice` | 新建领书通知 | 📢 **领书通知管理** |
| PUT | `/textbook/notice` | 编辑领书通知 | 📢 **领书通知管理** |
| PUT | `/textbook/notice/publish/{noticeId}` | 发布领书通知 | 📢 **领书通知管理** |
| DELETE | `/textbook/notice/{noticeIds}` | 删除领书通知 | 📢 **领书通知管理** |
| GET | `/textbook/notice/claimForms/{noticeId}` | 查看关联领书单 | 📢 **领书通知管理** |
| GET | `/textbook/claimForm/list` | 领书单列表查询 | 📋 **领书单管理** |
| GET | `/textbook/claimForm/{formId}` | 领书单详情(含明细) | 📋 **领书单管理** |
| POST | `/textbook/claimForm` | 新建领书单 | 📋 **领书单管理** |
| PUT | `/textbook/claimForm` | 编辑领书单 | 📋 **领书单管理** |
| PUT | `/textbook/claimForm/confirmOutbound` | 确认出库（支持分批） | 📋 **领书单管理** |
| DELETE | `/textbook/claimForm/{formIds}` | 删除领书单 | 📋 **领书单管理** |
| GET | `/textbook/claimForm/details/{formId}` | 领书单明细查询 | 📋 **领书单管理** |

#### 📊 v4.0 核心业务特性

| 特性 | 说明 |
|------|------|
| **领书通知状态机** | 0=草稿 → 1=已发布 → 2=领取中 → 3=已完成（自动级联）|
| **领书单状态机** | 0=待领取 → 1=部分出库 → 2=已出库 |
| **分批出库支持** | 实发数量可小于应发数量，支持多次领取直到完成 |
| **自动进度追踪** | 出库后自动更新通知的 `issuedClasses / totalClasses` 进度 |
| **乐观锁并发控制** | 库存操作使用 `WHERE stock_num = #{expected}` 防止超发 |
| **事务原子性保证** | `@Transactional(rollbackFor = Exception.class)` 全流程回滚 |
| **打印功能集成** | 前端 ClaimFormPrint 组件支持 A4 三联单格式打印 |

#### 🔐 v4.0 新增权限标识

| 权限标识 | 说明 |
|---------|------|
| `textbook:notice:list` | 领书通知列表 |
| `textbook:notice:query` | 领书通知详情 |
| `textbook:notice:add` | 新建领书通知 |
| `textbook:notice:edit` | 编辑领书通知 |
| `textbook:notice:publish` | 发布领书通知 |
| `textbook:notice:remove` | 删除领书通知 |
| `textbook:claimForm:list` | 领书单列表 |
| `textbook:claimForm:query` | 领书单详情 |
| `textbook:claimForm:add` | 新建领书单 |
| `textbook:claimForm:edit` | 编辑领书单 |
| `textbook:claimForm:outbound` | 确认出库 |
| `textbook:claimForm:remove` | 删除领书单 |

---

## 📌 v3.0 更新日志 (2026-04-15)

### ⭐ 重大变更

#### 🔒 安全加固（14项关键规则审计）

| # | 规则 | 状态 | 说明 |
|---|------|------|------|
| 1 | 库存只能通过入库/出库变更 | ✅ 新增 | edit()接口拦截直接改库存，remove()拦截有库存删除 |
| 2 | 出库/入库必须加事务 | ✅ 已有 | @Transactional(rollbackFor) |
| 3 | Excel按列下标读取 | ✅ 已有 | sort=0..5固定列索引 |
| 4 | 单行失败不阻断整批 | ✅ 已有 | 逐行try-catch收集错误 |
| 5 | 导入不修改库存 | ✅ 已有 | 仅生成采购单 |
| 6 | ISBN不存在时跳过 | ✅ 已有 | 标记失败原因继续处理 |
| 7 | 学院/专业字典校验 | ✅ 已有 | tb_college/tb_major枚举校验 |
| **8** | **防重复导入(MD5)** | **✅ 新增** | **文件MD5指纹+file_hash持久化** |
| **9** | **已入库禁止编辑删除** | **✅ 新增** | **双层状态校验(审核+领书)** |
| 10 | 并发乐观锁 | ✅ 已有 | WHERE stock_num = expectedStock |
| 11 | 供应商数据权限隔离 | ✅ 已有 | myPurchaseList按supplierId过滤 |
| **12** | **教师数据权限隔离** | **✅ 新增** | **list接口自动注入userId过滤** |
| 13 | 通知与业务ID关联 | ✅ 已有 | sys_notice扩展biz_id/biz_type |
| **14** | **缺书单ISBN合并** | **✅ 新增** | **batchConvertToPurchase聚合逻辑** |

#### 🆕 新增API端点

| 方法 | 路径 | 功能 | 模块 |
|------|------|------|------|
| POST | `/textbook/buy/import` | Excel导入采购单（MD5防重复） | 购书管理 |
| GET | `/textbook/buy/import/template` | 下载导入模板 | 购书管理 |
| POST | `/textbook/shortage/convertToPurchase` | 缺书批量转采购（ISBN聚合） | 缺货管理 |
| GET | `/textbook/notice/list` | 通知列表 | 通知管理 |
| GET | `/textbook/notice/unreadCount` | 未读通知数 | 通知管理 |
| PUT | `/textbook/notice/markRead/{id}` | 标记已读 | 通知管理 |
| PUT | `/textbook/notice/batchMarkRead` | 批量标记已读 | 通知管理 |
| GET | `/textbook/supplier/myPurchaseList` | 供应商查看自身采购单 | 供应商管理 |
| PUT | `/textbook/supplier/confirmShip/{id}` | 供应商确认发货 | 供应商管理 |

#### 📝 修改的API端点

| 方法 | 路径 | 变更内容 |
|------|------|---------|
| GET | `/textbook/buy/list` | 教师角色自动过滤仅本人数据（Fix #12）|
| DELETE | `/textbook/buy/remove/{id}` | 增加已审核/已领书状态拦截（Fix #9）|
| DELETE | `/textbook/purchase/remove/{id}` | 同上（Fix #9）|
| PUT | `/textbook/inventory` | 拦截库存数量直接修改（Fix #1）|

---

## 📖 目录

1. [API 概述](#1-api-概述)
2. [认证与授权](#2-认证与授权)
3. [通用规范](#3-通用规范)
4. [教材管理 API](#4-教材管理-api)
5. [购书管理 API](#5-购书管理-api) ⚡️ **v3.0更新**
6. [库存管理 API](#6-库存管理-api) ⚡️ **v3.0更新**
7. [入库管理 API](#7-入库管理-api) ⚡️ **v3.0更新**
8. [出库管理 API](#8-出库管理-api) ⚡️ **v3.0更新**
9. [缺货管理 API](#9-缺货管理-api) ⚡️ **v3.0更新**
10. [采购与供应商 API](#10-采购与供应商-api) ⚡️ **v3.0更新**
11. [通知管理 API](#11-通知管理-api) 🆕 **v3.0新增**
12. [📢 领书通知管理 API](#12-领书通知管理-api) 🆕 **v4.0新增**
13. [📋 领书单管理 API](#13-领书单管理-api) 🆕 **v4.0新增**
14. [统计分析 API](#14-统计分析-api)
15. [错误码说明](#15-错误码说明) ⚡️ **v4.0更新**

---

## 1. API 概述

### 1.1 基础信息

| 项目 | 说明 |
|------|------|
| **协议** | HTTP/HTTPS |
| **Base URL** | `http://your-server:8080` |
| **API前缀** | 所有接口无需额外前缀（Spring MVC直接映射）|
| **字符编码** | UTF-8 |
| **内容类型** | application/json |
| **认证头** | `Authorization: Bearer {token}` |

### 1.2 接口分类

系统提供 **20个业务模块** 的RESTful API：

```
教材管理系统 API
├── 📚 教材管理 (TbBookController)
├── 🛒 购书申请 (TbBuyController)          ⚡️ v3.0: 教师权限隔离 + Excel导入 + 防重复
├── 📋 购书单管理 (TbPurchaseController)    ⚡️ v3.0: 删除保护
├── 📦 库存管理 (TbInventoryController)     ⚡️ v3.0: 禁止直接改库存
├── 📥 入库管理 (TbInboundController)       ⚡️ v3.0: 流水记录 + 缺书联动
├── 📤 出库管理 (TbOutboundController)      ⚡️ v3.0: 乐观锁 + 流水记录
├── ⚠️ 缺货管理 (TbShortageController)      ⚡️ v3.0: ISBN聚合转采购
├── 🏭 供应商管理 (TbSupplierController)    ⚡️ v3.0: 数据隔离 + 发货确认
├── 🔔 通知管理 (TbNoticeController)        🆕 v3.0: 全新模块
├── 📢 领书通知管理 (BookNoticeController)   🆕 v4.0: 全新模块
├── 📋 领书单管理 (BookClaimFormController) 🆕 v4.0: 全新模块（含确认出库）
├── 📊 统计分析 (TbDashboardController)
├── 📝 待办事项 (TbPendingController)
├── 📈 库存流水 (TbStockFlowController)
├── 📜 库存日志 (TbStockLogController)
├── 🔍 库存盘点 (TbInventoryCheckController)
├── ℹ️ 系统信息 (TbInfoController)
└── 🎯 库存操作 (TbStockController)
```

---

## 2. 认证与授权

### 2.1 权限注解说明

**v4.0 角色权限对照表**:

| 权限标识 | admin | teacher | warehouseman | supplier |
|---------|:-----:|:-------:|:------------:|:--------:|
| `textbook:inventory:list` | ✅ | ✅(只读) | ✅ | ❌ |
| `textbook:inventory:edit` | ✅ | ❌ | ✅(禁止改库存数) | ❌ |
| `textbook:purchase:add` | ✅ | ✅ | ✅ | ❌ |
| `textbook:purchase:audit` | ✅ | ❌ | ✅ | ❌ |
| `textbook:purchase:remove` | ✅ | ❌ | ✅(已完成不可删) | ❌ |
| `textbook:buy:list` | ✅ | ✅(自动过滤本人) | ✅ | ❌ |
| `textbook:buy:import` | ✅ | ❌ | ✅ | ❌ |
| `textbook:inbound:add` | ✅ | ❌ | ✅ | ❌ |
| `textbook:outbound:add` | ✅ | ❌ | ✅ | ❌ |
| `textbook:supplier:list` | ✅ | ❌ | ✅ | ❌ |
| `textbook:shortage:process` | ✅ | ❌ | ✅ | ❌ |
| `textbook:notice:list` | ✅ | ✅(自己的) | ✅ | ❌ |
| `textbook:notification:list` | ✅ | ✅(自己的) | ✅ | ❌ |
| **`textbook:notice:list`** | **✅** | **❌** | **✅** | **❌** |
| **`textbook:notice:publish`** | **✅** | **❌** | **✅** | **❌** |
| **`textbook:claimForm:list`** | **✅** | **❌** | **✅** | **❌** |
| **`textbook:claimForm:outbound`** | **✅** | **❌** | **✅** | **❌** |

> 💡 **v4.0 说明**: 领书通知和领书单模块仅对 admin 和 warehouseman 角色开放，teacher 和 supplier 无权访问。

---

## 3. 通用规范

### 3.1 统一响应格式

所有API接口均采用统一的JSON响应格式：

#### 成功响应 (HTTP 200)

```json
{
  "code": 200,
  "msg": "操作成功",
  "data": { ... }
}
```

**字段说明**:

| 字段 | 类型 | 必填 | 说明 |
|------|------|:----:|------|
| code | Integer | ✅ | 状态码，200表示成功 |
| msg | String | ✅ | 响应消息 |
| data | Object/Array | ❌ | 响应数据体（查询类接口返回）|

**特殊data结构**:

**列表查询响应**:
```json
{
  "code": 200,
  "msg": "查询成功",
  "total": 100,        // 总记录数（用于分页）
  "rows": [ ... ]      // 当前页数据数组
}
```

**分页请求参数**:
```json
{
  "pageNum": 1,        // 页码（从1开始）
  "pageSize": 10       // 每页条数
}
```

**无数据体响应**（新增/修改/删除操作）:
```json
{
  "code": 200,
  "msg": "操作成功"
  // 无data字段
}
```

---

#### 错误响应 (HTTP 500 / 401 / 403)

```json
{
  "code": 500,
  "msg": "操作失败",
  "data": null
}
```

**常见错误码**:

| HTTP状态码 | code值 | 说明 | 触发场景 |
|-----------|--------|------|---------|
| 200 | 200 | 成功 | 操作正常完成 |
| 401 | 401 | 未认证 | Token缺失或过期 |
| 403 | 403 | 无权限 | @PreAuthorize校验失败 |
| 500 | 500 | 业务异常 | 参数错误、规则校验失败等 |
| 500 | 601 | 验证码错误 | 图形验证码不正确 |

---

### 3.2 分页参数

所有列表查询接口支持统一分页：

**请求参数 (Query)**:

| 参数 | 类型 | 必填 | 默认值 | 说明 |
|------|------|:----:|:-----:|------|
| pageNum | Integer | ❌ | 1 | 页码（≥1）|
| pageSize | Integer | ❌ | 10 | 每页条数（1-100）|

**使用示例**:
```
GET /textbook/book/list?pageNum=2&pageSize=20
```

**响应结构**:
```json
{
  "code": 200,
  "msg": "查询成功",
  "total": 156,           // 总记录数
  "rows": [               // 当前页数据（最多20条）
    { ... },
    { ... }
  ]
}
```

**分页计算公式**:
```
总页数 = ceil(total / pageSize)
当前页起始 = (pageNum - 1) * pageSize + 1
当前页结束 = pageNum * pageSize
```

---

### 3.3 时间格式

系统统一使用 **ISO 8601** 格式的时间字符串：

**标准格式**: `yyyy-MM-dd HH:mm:ss`

**示例**:
```json
{
  "createTime": "2026-04-16 10:30:00",
  "updateTime": "2026-04-16 14:25:00",
  "submitTime": "2026-04-15 09:00:00"
}
```

**时间范围查询** (Query参数):

| 参数名 | 格式 | 示例 | 说明 |
|--------|------|------|------|
| beginTime | yyyy-MM-dd HH:mm:ss | 2026-04-01 00:00:00 | 起始时间（包含）|
| endTime | yyyy-MM-dd HH:mm:ss | 2026-04-30 23:59:59 | 结束时间（包含）|

**使用示例**:
```
GET /textbook/buy/list?beginTime=2026-04-01+00:00:00&endTime=2026-04-30+23:59:59
```

> ⚠️ **注意**: URL中的空格需编码为 `+` 或 `%20`

---

## 4. 教材管理 API

**模块路径**: `/textbook/book`
**Controller**: `TbBookController.java`
**权限前缀**: `textbook:book`

### 4.1 查询教材列表

#### GET /textbook/book/list

查询教材信息列表（支持分页、筛选、排序）。

**请求参数** (Query):

| 参数 | 类型 | 必填 | 说明 |
|------|------|:----:|------|
| pageNum | Integer | ❌ | 页码（默认1）|
| pageSize | Integer | ❌ | 每页条数（默认10）|
| bookName | String | ❌ | 教材名称（模糊搜索）|
| isbn | String | ❌ | ISBN号（精确/模糊）|
| author | String | ❌ | 作者（模糊搜索）|
| publisher | String | ❌ | 出版社（模糊搜索）|
| status | String | ❌ | 状态（0=正常, 1=停用）|

**成功响应** (200):
```json
{
  "code": 200,
  "msg": "查询成功",
  "total": 156,
  "rows": [
    {
      "bookId": 1,
      "bookName": "Java程序设计",
      "isbn": "9787111641242",
      "author": "张三",
      "publisher": "机械工业出版社",
      "price": 59.00,
      "stockNum": 100,
      "status": "0",
      "createTime": "2026-04-01 10:00:00"
    },
    {
      "bookId": 2,
      "bookName": "Python编程从入门到实践",
      "isbn": "9787302515834",
      "author": "李四",
      "publisher": "清华大学出版社",
      "price": 79.00,
      "stockNum": 50,
      "status": "0",
      "createTime": "2026-04-02 14:30:00"
    }
  ]
}
```

**权限要求**: `textbook:book:list`

---

### 4.2 查询教材详情

#### GET /textbook/book/{bookId}

根据ID查询教材详细信息。

**路径参数**:

| 参数 | 类型 | 必填 | 说明 |
|------|------|:----:|------|
| bookId | Long | ✅ | 教材ID |

**成功响应** (200):
```json
{
  "code": 200,
  "msg": "操作成功",
  "data": {
    "bookId": 1,
    "bookName": "Java程序设计",
    "isbn": "9787111641242",
    "author": "张三",
    "publisher": "机械工业出版社",
    "price": 59.00,
    "category": "计算机科学",
    "edition": "第3版",
    "publishDate": "2025-03",
    "description": "经典Java入门教材，适合初学者",
    "coverImage": "/profile/upload/2026/04/16/book_001.jpg",
    "stockNum": 100,
    "warningThreshold": 10,
    "status": "0",
    "remark": "",
    "createBy": "admin",
    "createTime": "2026-04-01 10:00:00",
    "updateBy": null,
    "updateTime": null
  }
}
```

**权限要求**: `textbook:book:query`

---

### 4.3 新增教材

#### POST /textbook/book

创建新的教材记录。

**请求体** (JSON):

```json
{
  "bookName": "数据结构与算法",
  "isbn": "9787121385335",
  "author": "王五",
  "publisher": "电子工业出版社",
  "price": 49.50,
  "category": "计算机科学",
  "edition": "第2版",
  "publishDate": "2024-09",
  "description": "数据结构经典教材",
  "warningThreshold": 15
}
```

**字段说明**:

| 字段 | 类型 | 必填 | 说明 |
|------|------|:----:|------|
| bookName | String | ✅ | 教材名称（≤200字符）|
| isbn | String | ✅ | ISBN号（10位或13位，唯一）|
| author | String | ❌ | 作者（≤100字符）|
| publisher | String | ❌ | 出版社（≤100字符）|
| price | BigDecimal | ❌ | 定价（≥0）|
| category | String | ❌ | 分类 |
| edition | String | ❌ | 版次 |
| publishDate | String | ❌ | 出版日期（yyyy-MM）|
| description | String | ❌ | 简介（≤500字符）|
| warningThreshold | Integer | ❌ | 预警阈值（默认10）|

**成功响应** (200): `{ "code": 200, "msg": "新增成功" }`

**错误响应** (500):
```json
// ISBN重复
{ "code": 500, "msg": "教材ISBN已存在" }

// 必填字段为空
{ "code": 500, "msg": "教材名称不能为空" }
```

**权限要求**: `textbook:book:add`

---

### 4.4 修改教材

#### PUT /textbook/book

更新教材信息。

**请求体** (JSON):

```json
{
  "bookId": 1,
  "bookName": "Java程序设计（第4版）",
  "isbn": "9787111641242",
  "price": 65.00,
  "warningThreshold": 20
}
```

> ⚠️ **注意**: bookId为必填项，用于定位要修改的记录。

**成功响应** (200): `{ "code": 200, "msg": "修改成功" }`

**权限要求**: `textbook:book:edit`

---

### 4.5 删除教材

#### DELETE /textbook/book/{bookIds}

批量删除教材记录（逻辑删除）。

**路径参数**:

| 参数 | 类型 | 必填 | 说明 |
|------|------|:----:|------|
| bookIds | Long[] | ✅ | 教材ID数组（逗号分隔或JSON数组）|

**请求示例**:
```
DELETE /textbook/book/1,2,3
DELETE /textbook/book/[1,2,3]
```

**成功响应** (200): `{ "code": 200, "msg": "删除成功" }`

**业务规则**:
- 执行逻辑删除（设置 `del_flag = "2"`），非物理删除
- 如果有关联的库存记录或购书单，建议先处理关联数据

**权限要求**: `textbook:book:remove`

---

## 5. 购书管理 API ⚡️ v3.0更新

**模块路径**: `/textbook/buy`, `/textbook/purchase`
**Controller**: `TbBuyController.java`, `TbPurchaseController.java`
**权限前缀**: `textbook:buy`, `textbook:purchase`

### 5.1 查询购书单列表 ⚡️ Fix #12

#### GET /textbook/buy/list

查询购书信息列表（支持分页、筛选、排序）。

**请求参数** (Query): 同 v2.0

**⚡️ v3.0 变更 — 教师数据权限隔离**:

当当前登录用户角色为 `teacher` 或 roleKey 为 `3` 时：
- 如果前端未传 `userId` 参数 → 后端**自动注入**当前登录用户的 `userId`
- 教师只能查询到**自己提交**的购书单
- admin / warehouseman 不受影响，可查看全部数据

**请求示例**:
```
GET /textbook/buy/list?pageNum=1&pageSize=10
# teacher角色 → 自动追加 &userId=当前用户ID
# warehouseman角色 → 返回全部数据
```

**成功响应** (200): 同 v2.0 格式

**权限要求**: `textbook:buy:list`

---

### 5.2 提交购书申请

#### POST /textbook/buy

教师提交教材购书申请。

**请求体** (JSON):

```json
{
  "bookId": 1,
  "bookName": "Java程序设计",
  "isbn": "9787111641242",
  "buyNum": 3,
  "deptName": "计算机学院",
  "fundingSource": "学校经费",
  "remark": "软件工程专业2024级使用"
}
```

**字段说明**:

| 字段 | 类型 | 必填 | 说明 |
|------|------|:----:|------|
| bookId | Long | ✅ | 教材ID |
| bookName | String | ✅ | 教材名称 |
| isbn | String | ✅ | ISBN号 |
| buyNum | Integer | ✅ | 申请数量（≥1）|
| deptName | String | ❌ | 所属部门/学院 |
| fundingSource | String | ❌ | 经费来源 |
| remark | String | ❌ | 备注 |

**成功响应** (200):
```json
{
  "code": 200,
  "msg": "提交成功",
  "data": {
    "buyId": 10086,
    "purchaseNo": "BUY202604161030001"
  }
}
```

**业务规则**:
- 系统自动生成购书单号：BUY + 时间戳 + 序号
- 自动注入当前登录用户ID作为userId
- 初始状态为"待审核"(auditStatus="0")
- 🆕 **v3.0增强**: teacher角色只能看到自己提交的订单

**权限要求**: `textbook:buy:add`

---

### 5.3 审核购书单

#### PUT /textbook/buy/audit

库管员审核教师的购书申请（通过或驳回）。

**请求体** (JSON):

```json
{
  "buyId": 10086,
  "status": "1",
  "rejectReason": ""
}
```

**字段说明**:

| 字段 | 类型 | 必填 | 说明 |
|------|------|:----:|------|
| buyId | Long | ✅ | 购书单ID |
| status | String | ✅ | 审核结果："1"=通过, "2"=驳回 |
| rejectReason | String | 条件必填 | 驳回原因（status="2"时必填，≤500字符）|

**成功响应** (200):
```json
// 审核通过
{ "code": 200, "msg": "审核通过" }

// 审核驳回
{ "code": 200, "msg": "已驳回" }
```

**业务规则**:
- 只有库管员(admin/warehouseman)可执行此操作
- 审核通过后：状态变为"已审核"(auditStatus="1")
- 审核驳回后：
  - 状态变为"已驳回"(auditStatus="2")
  - 如果库存不足，自动创建缺书记录(textbook_lack表)
  - 教师收到"审核驳回"通知（含驳回原因）
- 🆕 **v3.0增强**: 已审核的订单不可删除（Fix #9）

**权限要求**: `textbook:buy:audit`

---

### 5.4 确认领书

#### PUT /textbook/buy/receive

教师确认领取教材（或库管员代为确认）。

**请求体** (JSON):

```json
{
  "buyId": 10086
}
```

**字段说明**:

| 字段 | 类型 | 必填 | 说明 |
|------|------|:----:|------|
| buyId | Long | ✅ | 购书单ID |

**前置条件**: 订单必须处于"已审核通过"状态(auditStatus="1")

**成功响应** (200):
```json
{
  "code": 200,
  "msg": "领书确认成功",
  "data": {
    "buyId": 10086,
    "receiveStatus": "1",
    "receiveTime": "2026-04-16 14:30:00"
  }
}
```

**业务流程**:
1. 校验订单存在且状态为"已审核"
2. 调用出库服务(TbOutboundService)执行出库操作
   - 创建出库记录(tb_outbound)
   - 更新库存(乐观锁扣减)
   - 生成流水日志(tb_stock_log) 🆕 v3.0
3. 更新订单状态(receiveStatus="1", receiveTime=当前时间)
4. 发送通知给申请人 🆕 v3.0

**权限要求**:
- teacher: 只能确认自己的订单
- warehouseman/admin: 可确认任意订单

---

### 5.5 删除购书单 ⚡️ Fix #9

#### DELETE /textbook/buy/remove/{id}

删除购书单。

**路径参数**:

| 参数 | 类型 | 必填 | 说明 |
|------|------|:----:|------|
| buyId | Long | ✅ | 购书单ID |

**⚡️ v3.0 变更 — 状态安全校验**:

删除操作前会进行**双重状态检查**：

| 当前状态 | 能否删除 | 拦截提示 |
|----------|:--------:|----------|
| 待审核(auditStatus=0) | ✅ 可以 | — |
| 已驳回(auditStatus=2) | ✅ 可以 | — |
| **已通过(auditStatus=1)** | ❌ **禁止** | "该购书单已审核通过，禁止删除。如需取消请联系库管员驳回。" |
| **已通过+已领书(auditStatus=1, receiveStatus=1)** | ❌ **禁止** | "该购书单已完成领书，禁止删除。已完成领书的单据不可删除以保证数据完整性。" |
| 订单不存在 | ❌ | "购书单不存在" |

**成功响应** (200): `{ "code": 200, "msg": "操作成功" }`

**错误响应** (500):
```json
{ "code": 500, "msg": "该购书单已完成领书，禁止删除" }
{ "code": 500, "msg": "该购书单已审核通过，禁止删除" }
```

**权限要求**: `textbook:buy:remove`

> **同理适用于**: `DELETE /textbook/purchase/remove/{id}` — TbPurchaseController 中实现了相同的双重状态检查。

---

### 5.6 取消订单

#### PUT /textbook/buy/cancel

取消待审核的购书申请（仅限"待审核"状态）。

**请求体** (JSON):

```json
{
  "buyId": 10086,
  "cancelReason": "课程调整，不需要该教材"
}
```

**字段说明**:

| 字段 | 类型 | 必填 | 说明 |
|------|------|:----:|------|
| buyId | Long | ✅ | 购书单ID |
| cancelReason | String | ❌ | 取消原因 |

**业务规则**:
- 只有"待审核"(auditStatus="0")的订单可取消
- 已审核通过或已驳回的订单不可取消
- 取消后订单状态标记为特殊状态

**成功响应** (200): `{ "code": 200, "msg": "取消成功" }`

**错误响应** (500):
```json
{ "code": 500, "msg": "已审核通过的订单不可取消" }
```

**权限要求**: 
- teacher: 只能取消自己的订单
- warehouseman/admin: 可取消任意待审订单

---

### 5.7 批量提交

#### POST /textbook/buy/batch

一次性提交多个购书申请（适用于一次为多门课程选教材）。

**请求体** (JSON Array):

```json
[
  {
    "bookId": 1,
    "isbn": "9787111641242",
    "buyNum": 3,
    "deptName": "计算机学院"
  },
  {
    "bookId": 2,
    "isbn": "9787302515834",
    "buyNum": 5,
    "deptName": "计算机学院"
  },
  {
    "bookId": 4,
    "isbn": "9787121385335",
    "buyNum": 2,
    "deptName": "计算机学院"
  }
]
```

**成功响应** (200):
```json
{
  "code": 200,
  "msg": "批量提交成功，共3条申请",
  "data": {
    "successCount": 3,
    "failCount": 0,
    "purchaseNos": ["BUY202604161040001", "BUY202604161040002", "BUY202604161040003"]
  }
}
```

**业务规则**:
- 每个元素独立校验，单条失败不影响其他条目
- 全部成功或全部失败取决于具体实现策略
- 系统自动生成多个独立的购书单号

**权限要求**: `textbook:buy:add`

---

### 5.8 我的统计

#### GET /textbook/buy/myStats

查询当前登录用户的购书统计数据。

**请求参数**: 无（使用当前登录用户身份）

**成功响应** (200):
```json
{
  "code": 200,
  "msg": "操作成功",
  "data": {
    "totalOrders": 25,           // 总订单数
    "pendingReview": 3,          // 待审核
    "approved": 18,              // 已通过
    "rejected": 2,               // 已驳回
    "received": 20,              // 已领书
    "totalBooks": 67,            // 总申请本数
    "thisMonthOrders": 5,        // 本月新增
    "recentOrders": [            // 最近5条订单
      {
        "buyId": 10100,
        "bookName": "Java程序设计",
        "buyNum": 3,
        "status": "已领书",
        "submitTime": "2026-04-15 10:30:00"
      }
    ]
  }
}
```

**数据范围**:
- **teacher角色**: 返回自己的统计数据
- **warehouseman/admin角色**: 可选择查看全局或个人统计（通过参数控制）

**权限要求**: 登录即可

---

### 5.9 Excel导入采购单 🆕 Fix #8

#### POST /textbook/buy/import

上传Excel文件批量生成采购单（带MD5防重复机制）。

**请求参数** (multipart/form-data):

| 参数 | 类型 | 必填 | 说明 |
|------|------|:----:|------|
| file | MultipartFile | ✅ | Excel文件（.xlsx或.xls）|

**文件约束**:
- 格式：`.xlsx` 或 `.xls`
- 大小：≤ **10MB**
- 最大行数：≤ **1000行**（不含表头）

**🔒 防重复机制 (Fix #8)**:
```
上传文件 → calculateFileMD5(file) → selectByFileHash(md5)查重
  ├── 未命中 → 正常导入 + 将md5存入file_hash字段
  └── 命中 → 抛异常："该文件已导入过（MD5: xxx），采购单号：xxx"
```

**Excel模板固定列定义**（按列下标读取，不按表头匹配）:

| 列索引(sort) | 列名 | 必填 | 校验规则 |
|-------------|------|:----:|----------|
| 0 | ISBN | ✅ | 10位或13位纯数字 |
| 1 | 教材名称 | ❌ | ≤200字符 |
| 2 | 采购数量 | ✅ | 1-9999整数 |
| 3 | 申请学院 | ✅ | 必须在tb_college字典中存在 |
| 4 | 申请专业 | ✅ | 必须在tb_major字典中存在 |
| 5 | 备注 | ❌ | 自由文本 |

**逐行校验规则**:
- 单行校验失败 **不阻断整批导入** → 该行标记为失败，继续处理下一行
- ISBN不存在于系统中 → 跳过该行，标记失败原因
- 学院/专业不在字典中 → 标记失败原因
- 所有行均校验失败 → 返回空结果（不创建采购主单）
- 至少一行成功 → 创建采购主单 + 成功明细

**成功响应** (200):
```json
{
  "code": 200,
  "msg": "导入完成！成功25条，失败3条，共28条数据",
  "data": {
    "totalRows": 28,
    "successCount": 25,
    "failCount": 3,
    "purchaseNo": "CG20260415143000123",
    "purchaseId": 10086,
    "errorList": [
      {
        "rowIndex": 3,
        "isbn": "9780000000000",
        "bookName": null,
        "quantity": null,
        "college": null,
        "major": null,
        "errorReason": "系统中不存在该ISBN对应的教材[9780000000000]；"
      },
      {
        "rowIndex": 7,
        "isbn": "9787111641242",
        "bookName": "Java程序设计",
        "quantity": 5,
        "college": "计算机科学学院",
        "major": "软件工程",
        "errorReason": "申请学院[计算机科学学院]不在系统字典中；"
      }
    ]
  }
}
```

**错误响应** (500):
```json
// 文件为空
{ "code": 500, "msg": "请选择要导入的Excel文件" }

// 文件格式不支持
{ "code": 500, "msg": "仅支持 .xlsx 或 .xls 格式的Excel文件" }

// 文件过大
{ "code": 500, "msg": "文件大小超过限制（最大10MB）" }

// 重复导入！
{ "code": 500, "msg": "该文件已导入过（MD5: a1b2c3d4...），采购单号：CG20260415093000xxx，请勿重复导入相同文件" }

// Excel无数据
{ "code": 500, "msg": "Excel文件中没有数据" }

// 超过行数上限
{ "code": 500, "msg": "导入数据超过上限，单次最多1000行（当前1200行）" }
```

**权限要求**:
- `textbook:buy:import`
- `@RepeatSubmit` 防重复提交
- 角色：admin, warehouseman

---

### 5.10 下载导入模板

#### GET /textbook/buy/import/template

下载标准Excel导入模板（含下拉框和批注）。

**响应**:
- Content-Type: `application/vnd.openxmlformats-officedocument.spreadsheetml.sheet`
- Body: Excel模板二进制流
- Header: `Content-Disposition: attachment; filename=教材采购单导入模板.xlsx`

**模板结构**:
| A列(ISBN) | B列(教材名称) | C列(采购数量) | D列(申请学院) | E列(申请专业) | F列(备注) |
|-----------|--------------|--------------|---------------|--------------|-----------|
| *(必填)* | | *(必填)* | *(必填)* | *(必填)* | |
| 9787111641242 | Java程序设计 | 5 | 计算机学院 | 软件工程 | 示例 |

**权限要求**: `textbook:buy:import`

---

## 6. 库存管理 API ⚡️ v3.0更新

**模块路径**: `/textbook/inventory`
**Controller**: `TbInventoryController.java`
**权限前缀**: `textbook:inventory`

### 6.1 ~ 6.2 查询库存列表 / 库存预警列表

#### GET /textbook/inventory/list

查询教材库存列表（支持分页、筛选）。

**请求参数** (Query):

| 参数 | 类型 | 必填 | 说明 |
|------|------|:----:|------|
| pageNum | Integer | ❌ | 页码 |
| pageSize | Integer | ❌ | 每页条数 |
| bookName | String | ❌ | 教材名称（模糊）|
| isbn | String | ❌ | ISBN号 |
| status | String | ❌ | 状态 |

**成功响应** (200):
```json
{
  "code": 200,
  "total": 50,
  "rows": [
    {
      "inventoryId": 1,
      "bookId": 1,
      "bookName": "Java程序设计",
      "isbn": "9787111641242",
      "stockNum": 100,
      "warningThreshold": 10,
      "status": "0",
      "lastInboundTime": "2026-04-10 09:00:00",
      "lastOutboundTime": "2026-04-15 14:30:00"
    }
  ]
}
```

**权限要求**: `textbook:inventory:list` (admin/warehouseman完整权限, teacher只读)

---

#### GET /textbook/inventory/warning

查询库存预警列表（库存低于预警阈值的教材）。

**请求参数** (Query): 同上，可额外筛选

**成功响应** (200):
```json
{
  "code": 200,
  "msg": "查询成功",
  "total": 5,
  "rows": [
    {
      "inventoryId": 3,
      "bookName": "Python编程从入门到实践",
      "isbn": "9787302515834",
      "stockNum": 8,              // 当前库存
      "warningThreshold": 15,     // 预警线
      "shortage": 7               // 缺口（预警线 - 当前库存）
    }
  ],
  "summary": {
    "totalItems": 50,             // 总教材种类
    "warningCount": 5,            // 预警数量
    "normalCount": 45,            // 正常数量
    "warningRate": "10%"          // 预警率
  }
}
```

**业务规则**:
- 自动筛选 `stockNum < warningThreshold` 的记录
- 计算每个预警项的缺口数量
- 提供汇总统计信息

**权限要求**: `textbook:inventory:list`

---

### 6.3 修改库存 ⚡️ Fix #1

#### PUT /textbook/inventory

修改库存记录信息。

**请求体** (JSON):

```json
{
  "inventoryId": 1,
  "bookId": 1,
  "stockNum": 85,
  "warningThreshold": 10,
  "remark": "调整备注"
}
```

**⚡️ v3.0 变更 — 库存数量安全保护 (Fix #1)**:

后端 `edit()` 方法会对比新旧库存值：

| 场景 | 行为 | 提示 |
|------|------|------|
| 只修改其他字段（如预警阈值、备注） | ✅ 允许 | — |
| **修改 stockNum 且值不同** | ❌ **拒绝** | `"安全限制：禁止直接修改库存数量！库存只能通过入库/出库变更。当前库存：XX"` |
| stockNum 保持不变（传了但没改） | ✅ 允许 | — |

**设计原则**: 库存数量的变更必须经过入库(TbInbound)/出库(TbOutbound)流程，确保每笔变动都有流水记录。

**正确做法**:
- 增加库存 → 使用「入库管理」→ 处理入库
- 减少库存 → 使用「出库管理」→ 处理出库
- 盘点差异 → 通过盘点流程修正

**成功响应** (200):
```json
{ "code": 200, "msg": "修改成功" }
```

**错误响应** (500):
```json
{ "code": 500, "msg": "安全限制：禁止直接修改库存数量！库存只能通过入库/出库变更。当前库存：100" }
```

**权限要求**: `textbook:inventory:edit`

---

### 6.4 删除库存 ⚡️ Fix #1

#### DELETE /textbook/inventory/{inventoryIds}

删除库存记录。

**⚡️ v3.0 变更 — 有库存时禁止删除**:

如果该教材 `stockNum > 0`，则**拒绝删除**：
```json
{ "code": 500, "msg": "该教材仍有库存（当前XX本），请先通过出库操作将库存清零后再删除" }
```

只有当 `stockNum = 0` 时才允许删除。

**权限要求**: `textbook:inventory:remove`

---

## 7. 入库管理 API ⚡️ v3.0更新

**模块路径**: `/textbook/inbound`
**Controller**: `TbInboundController.java`
**权限前缀**: `textbook:inbound`

### 7.1 处理入库 ⚡️ 增强

#### POST /textbook/inbound/process

登记采购到货，执行入库操作。

**v3.0 增强功能** (`processInbound()`):

```
入库处理流程:
1. 生成入库单号（INB+时间戳+序号）
2. 循环处理每个明细项：
   ├── 创建入库记录（tb_inbound表）
   ├── 更新库存（乐观锁：WHERE stock_num = expectedStock）
   │   └── 冲突检测 → 抛出"并发冲突，请重试"
   ├── 生成库存流水日志（tb_stock_log表）
   │   ├── operation_type = "1" (采购入库)
   │   ├── before_stock / after_stock 记录
   │   └── operator_id 记录操作人
   └── 【增强】检查是否有等待此教材的缺书单
       ├── 有缺书 → 自动更新缺书记录状态
       │   ├── 入库量 >= 缺书量 → 标记"已解决"(handleStatus="2")
       │   └── 入库量 < 缺书量 → 标记"部分满足"，更新lack_num
       ├── 【增强】重新开放被驳回的待采购订单
       │   └── audit_status 从 "2" 回退到 "0"
       └── 【增强】发送双通道通知
           ├── 全局通知（所有相关教师）
           └── 供应商通知（确认入库完成）
3. 事务保证：全部操作原子性
```

**成功响应** (200):
```json
{
  "code": 200,
  "msg": "入库成功",
  "data": {
    "inboundId": 1001,
    "inboundNo": "INB202604150930001",
    "processedItems": 2,
    "shortageResolved": 1,
    "notificationsSent": 3
  }
}
```

**权限要求**: `textbook:inbound:add`

---

## 8. 出库管理 API ⚡️ v3.0update

**模块路径**: `/textbook/outbound`
**Controller**: `TbOutboundController.java`
**权限前缀**: `textbook:outbound`

### 8.1 处理出库 ⚡️ 增强

#### POST /textbook/outbound/process

库管员发放教材给教师（通常由"确认领书"自动触发）。

**v3.0 增强功能** (`processOutbound()`):

```
出库处理流程:
1. 查询购书单及其明细
2. 循环处理每个明细项：
   ├── 查询当前库存
   ├── 校验库存是否充足
   ├── 创建出库记录（tb_outbound表）
   ├── 更新库存（乐观锁扣减）
   │   └── SQL: UPDATE SET stock_num = stock_num - #{num}
   │       WHERE book_id = ? AND stock_num = #{expected}
   │   └── 影响行数=0 → 并发冲突！"库存已被其他人修改，请刷新后重试"
   ├── 生成库存流水日志（tb_stock_log表）
   │   ├── operation_type = "3" (个人领书出库)
   │   └── 关联 buy_id, receive_id
   └── 【增强】发送通知给申请人
       └── "您申请的《XXX》已出库，请及时领取"
3. 更新购书单状态 receiveStatus = "已出库"
4. 事务保证：全部操作原子性
```

**并发安全**:
- 使用乐观锁防止超卖（两个库管员同时确认出库导致库存变负）
- 冲突时返回明确错误信息

**权限要求**: `textbook:outbound:add`

---

## 9. 缺货管理 API ⚡️ v3.0更新

**模块路径**: `/textbook/shortage`
**Controller**: `TbShortageController.java`
**权限前缀**: `textbook:shortage`

### 9.1 ~ 9.2 查询缺书列表 / 处理缺书记录

#### GET /textbook/shortage/list

查询缺书登记列表（支持分页、筛选）。

**请求参数** (Query):

| 参数 | 类型 | 必填 | 说明 |
|------|------|:----:|------|
| pageNum | Integer | ❌ | 页码 |
| pageSize | Integer | ❌ | 每页条数 |
| handleStatus | String | ❌ | 处理状态：0=未处理, 1=已纳入采购, 2=已解决 |
| isbn | String | ❌ | ISBN号（精确搜索）|
| beginTime | String | ❌ | 开始时间 |
| endTime | String | ❌ | 结束时间 |

**成功响应** (200):
```json
{
  "code": 200,
  "total": 12,
  "rows": [
    {
      "lackId": 1,
      "bookId": 2,
      "isbn": "9787302515834",
      "bookName": "Python编程从入门到实践",
      "lackNum": 5,
      "sourceType": "1",           // 来源：1=购书驳回, 2=手动登记
      "sourceBuyId": 10086,        // 关联的购书单ID
      "userId": 1001,              // 登记人/申请人
      "userName": "张老师",
      "handleStatus": "0",         // 未处理
      "purchaseId": null,          // 已转入的采购单ID
      "remark": "库存不足自动登记",
      "createTime": "2026-04-15 14:30:00"
    }
  ]
}
```

**权限要求**: `textbook:shortage:list`

---

#### POST /textbook/shortage/handout

手动处理缺书记录（标记为已解决或转入采购）。

**请求体** (JSON):

```json
{
  "lackId": 1,
  "action": "resolve",            // 或 "purchase"
  "remark": "已通过其他渠道补齐"
}
```

**字段说明**:

| 字段 | 类型 | 必填 | 说明 |
|------|------|:----:|------|
| lackId | Long | ✅ | 缺书记录ID |
| action | String | ✅ | 操作类型："resolve"=手动解决, "purchase"=转采购 |
| remark | String | ❌ | 处理备注 |

**成功响应** (200):
```json
// 手动解决
{ "code": 200, "msg": "缺书记录已标记为已解决" }

// 转采购
{
  "code": 200,
  "msg": "已转为采购单",
  "data": { "purchaseId": 10090, "purchaseNo": "CG202604161500001" }
}
```

**业务规则**:
- "resolve" → 设置 handleStatus="2" (已解决)
- "purchase" → 调用 batchConvertToPurchase() 生成采购单 🆕 v3.0 Fix #14
- 已处理的记录不可重复操作

**权限要求**: `textbook:shortage:process`

---

### 9.3 缺书批量转采购（ISBN聚合）🆕 Fix #14

#### POST /textbook/shortage/convertToPurchase

将选中的多条缺书记录**按ISBN聚合**后转为一个采购单。

**请求体** (JSON Array):

```json
[1, 2, 3, 5, 8]
```

> 缺书记录ID数组

**业务逻辑** (`batchConvertToPurchase()`):

```
输入: N条缺书记录ID
  ↓
过滤:
  ├── 不存在的ID → 跳过，计入skippedCount
  └── 已处理的(handleStatus="1") → 跳过
  ↓
按ISBN分组 (Collectors.groupingBy(isbn))
  ├── ISBN-A: 3条缺书记录 → lackNum求和 = 5+3+2 = 10
  ├── ISBN-B: 1条缺书记录 → lackNum = 8
  └── ISBN-C: 2条缺书记录 → lackNum求和 = 15+10 = 25
  ↓
生成1个采购主单 (CG+时间戳+序号)
  ├── purchase_no = CG20260415143000xxx
  ├── funding_source = school
  └── user_type = 2 (库管员操作)
  ↓
生成M个聚合明细 (M = 不同ISBN的数量)
  ├── 明细1: ISBN-A, quantity=10, remark="由3条缺书记录聚合生成"
  ├── 明细2: ISBN-B, quantity=8
  └── 明细3: ISBN-C, quantity=25, remark="由2条缺书记录聚合生成"
  ↓
批量更新N条缺书记录:
  ├── handle_status = "1" (已纳入采购)
  ├── purchase_id = 新采购单ID
  └── update_time = NOW()
  ↓
@Transactional 保证原子性
```

**成功响应** (200):
```json
{
  "code": 200,
  "msg": "成功将8条缺书记录转为采购单（CG20260415143000123），共3种教材（其中2种按ISBN合并）",
  "data": {
    "success": true,
    "purchaseNo": "CG20260415143000123",
    "purchaseId": 10088,
    "convertedCount": 8,
    "detailCount": 3,
    "aggregatedCount": 2,
    "skippedCount": 1
  }
}
```

**字段说明**:

| 字段 | 说明 |
|------|------|
| convertedCount | 实际参与转换的缺书记录数（过滤掉不存在/已处理后）|
| detailCount | 生成的采购明细数（= 不同ISBN的种类数）|
| aggregatedCount | 发生了ISBN聚合的教材种类数（≥2条同ISBN才算聚合）|
| skippedCount | 被跳过的记录数（不存在或已处理）|

**错误响应** (500):
```json
// 空数组
{ "code": 500, "msg": "请选择要转换的缺书记录", "data": { "success": false } }

// 全部跳过
{ "code": 500, "msg": "所选缺书记录均为空或已处理，无需转换", "data": { "skippedCount": 5 } }
```

**权限要求**:
- `textbook:shortage:process`
- `@ss.hasAnyRole('admin','issuer','purchaser')`

---

## 10. 采购与供应商 API ⚡️ v3.0更新

### 10.1 供应商 CRUD

#### GET /textbook/supplier/list

查询供应商列表（支持分页）。

**请求参数** (Query):

| 参数 | 类型 | 必填 | 说明 |
|------|------|:----:|------|
| pageNum | Integer | ❌ | 页码 |
| pageSize | Integer | ❌ | 每页条数 |
| supplierName | String | ❌ | 供应商名称（模糊搜索）|
| status | String | ❌ | 状态：0=正常, 1=停用 |

**成功响应** (200):
```json
{
  "code": 200,
  "total": 8,
  "rows": [
    {
      "supplierId": 1,
      "supplierName": "机械工业出版社发行部",
      "contactPerson": "王经理",
      "phone": "010-12345678",
      "address": "北京市西城区百万庄大街22号",
      "userId": 1005,              // 🆕 v3.0: 关联登录账号
      "shipStatus": "0",           // 🆕 v3.0: 发货状态
      "status": "0",
      "createTime": "2026-01-10 09:00:00"
    }
  ]
}
```

**权限要求**:
- admin/warehouseman: `textbook:supplier:list` (查看全部)
- supplier: 只能查看自己的信息（受限）

---

#### POST /textbook/supplier

新增供应商记录。

**请求体** (JSON):

```json
{
  "supplierName": "清华大学出版社",
  "contactPerson": "李经理",
  "phone": "010-62770181",
  "address": "北京市海淀区双清路学研大厦",
  "remark": "计算机类教材主要供应商"
}
```

**成功响应** (200): `{ "code": 200, "msg": "新增成功" }`

**业务规则**: 
- 🆕 **v3.0增强**: 可选关联系统用户账号(userId)，允许供应商登录系统

**权限要求**: `textbook:supplier:add` (仅admin/warehouseman)

---

### 10.2 供应商专属API 🆕

**模块路径**: `/textbook/supplier`
**Controller**: `TbSupplierController.java`

#### GET /textbook/supplier/myPurchaseList

供应商查看**发给自己的**采购单列表（数据隔离）。

**请求参数** (Query):

| 参数 | 类型 | 必填 | 说明 |
|------|------|:----:|------|
| status | String | ❌ | 采购状态过滤 |
| pageNum | Integer | ❌ | 页码 |
| pageSize | Integer | ❌ | 每页条数 |

**数据隔离原理**:
```
后端根据当前登录用户的supplier_id过滤：
SELECT * FROM textbook_buy WHERE supplier_id = 当前供应商ID
→ 供应商A看不到供应商B的采购单
```

**权限要求**: `textbook:supplier:list` + supplier角色

---

#### PUT /textbook/supplier/confirmShip/{id}

供应商确认发货。

**路径参数**:

| 参数 | 类型 | 必填 | 说明 |
|------|------|:----:|------|
| id | Long | ✅ | 采购单ID |

**请求体** (JSON):

```json
{
  "logisticsCompany": "顺丰速运",
  "logisticsNo": "SF1234567890",
  "shipTime": "2026-04-15 10:30:00",
  "remark": "预计3日内送达"
}
```

**业务逻辑**:
1. 校验采购单存在且属于当前供应商
2. 更新物流信息
3. 更新采购单状态为"已发货"
4. 通知库管员"供应商已确认发货"

**权限要求**: supplier角色专用

---

### 10.3 待采购清单

#### GET /textbook/purchase/pending

查询待处理的采购清单（状态为"待采购"或"采购中"的采购单）。

**请求参数** (Query):

| 参数 | 类型 | 必填 | 说明 |
|------|------|:----:|------|
| pageNum | Integer | ❌ | 页码 |
| pageSize | Integer | ❌ | 每页条数 |
| status | String | ❌ | 采购状态：0=待采购, 1=采购中, 2=已到货, 3=已完成 |
| supplierId | Long | ❌ | 供应商ID筛选 |
| beginTime | String | ❌ | 开始时间 |
| endTime | String | ❌ | 结束时间 |

**成功响应** (200):
```json
{
  "code": 200,
  "total": 6,
  "rows": [
    {
      "purchaseId": 10088,
      "purchaseNo": "CG20260415143000123",
      "supplierId": 2,
      "supplierName": "机械工业出版社",
      "totalAmount": 295.00,         // 总金额
      "itemCount": 5,               // 明细条数
      "status": "1",                // 采购中
      "fundingSource": "学校经费",
      "createTime": "2026-04-15 14:30:00",
      "details": [                  // 采购明细
        {
          "detailId": 1001,
          "bookName": "Java程序设计",
          "isbn": "9787111641242",
          "quantity": 3,
          "unitPrice": 59.00,
          "subtotal": 177.00
        }
      ]
    }
  ],
  "summary": {
    "pendingCount": 2,             // 待采购数量
    "processingCount": 4,           // 采购中数量
    "totalPendingAmount": 1250.00   // 待处理总金额
  }
}
```

**权限要求**: `textbook:purchase:list`

---

## 11. 通知管理 API 🆕 v3.0新增

**模块路径**: `/textbook/notice`
**Controller**: `TbNoticeController.java`
**权限前缀**: `textbook:notice`

### 11.1 通知数据模型

通知基于 `sys_notice` 表扩展，新增字段：

| 字段 | 类型 | 说明 |
|------|------|------|
| notice_id | BIGINT | 通知ID |
| notice_title | VARCHAR(50) | 通知标题 |
| notice_type | CHAR(1) | 类型：1=购书审核,2=缺书通知,3=到货通知,4=采购通知,5=系统通知,6=供应商通知,7=领书单出库,8=领书通知发布 |
| notice_content | VARCHAR(2000) | 通知内容 |
| target_user_id | BIGINT | 目标用户ID（null=全员通知）|
| user_type | CHAR(1) | 接收人类型：1=教师,2=库管员,3=供应商 |
| biz_id | BIGINT | 关联业务ID（如buyId/formId）|
| biz_type | VARCHAR(20) | 业务类型（如"textbook_buy"/"book_claim_form"）|
| read_status | CHAR(1) | 阅读状态：0=未读，1=已读 |
| create_time | DATETIME | 创建时间 |

---

### 11.2 查询通知列表

#### GET /textbook/notice/list

查询当前用户的通知列表。

**请求参数** (Query):

| 参数 | 类型 | 必填 | 说明 |
|------|------|:----:|------|
| noticeType | String | ❌ | 通知类型过滤(1-8) |
| readStatus | String | ❌ | 阅读状态过滤(0/1) |
| pageNum | Integer | ❌ | 页码 |
| pageSize | Integer | ❌ | 每页条数 |

**数据权限**:
- teacher: 只能看到发给自己的通知（target_user_id = 当前用户）
- admin / warehouseman: 可查看全部通知
- supplier: 只能看到供应商类型的通知

**成功响应** (200):
```json
{
  "code": 200,
  "total": 15,
  "rows": [
    {
      "noticeId": 101,
      "noticeTitle": "您的购书申请已通过审核",
      "noticeType": "1",
      "noticeTypeDesc": "审核通知",
      "noticeContent": "您申请的《Java程序设计》x3本已通过审核...",
      "targetUserId": 1001,
      "readStatus": "0",
      "bizId": 12345,
      "bizType": "textbook_buy",
      "createTime": "2026-04-15 14:30:00"
    }
  ]
}
```

**权限要求**: `textbook:notice:list`

---

### 11.3 获取未读通知数

#### GET /textbook/notice/unreadCount

获取当前用户的未读通知数量（用于前端角标显示）。

**请求参数**: 无（使用当前登录用户身份）

**成功响应** (200):
```json
{
  "code": 200,
  "msg": "操作成功",
  "data": 5
}
```

**权限要求**: 登录即可

---

### 11.4 标记单条已读

#### PUT /textbook/notice/markRead/{noticeId}

将指定通知标记为已读。

**路径参数**:

| 参数 | 类型 | 必填 | 说明 |
|------|------|:----:|------|
| noticeId | Long | ✅ | 通知ID |

**成功响应** (200): `{ "code": 200, "msg": "操作成功" }`

**权限要求**: `textbook:notice:edit`

---

### 11.5 批量标记已读

#### PUT /textbook/notice/batchMarkRead

批量将多条通知标记为已读。

**请求体** (JSON Array):

```json
[101, 102, 103, 105]
```

> 通知ID数组

**成功响应** (200): `{ "code": 200, "msg": "成功标记4条通知为已读" }`

**权限要求**: `textbook:notice:edit`

---

## 12. 📢 领书通知管理 API 🆕 v4.0新增

**模块路径**: `/textbook/notice`
**Controller**: `BookNoticeController.java`
**权限前缀**: `textbook:notice`
**数据库表**: `book_notice`

### 12.1 数据模型 BookNotice

| 字段 | 类型 | 必填 | 说明 |
|------|------|:----:|------|
| noticeId | Long | 自增主键 | 通知ID |
| noticeNo | String | 自动生成 | 通知编号（LS+日期+序号，如 LS20260416001）|
| semester | String | ✅ | 学期（如 "2025-2026学年第二学期"）|
| pickupStart | DateTime | ✅ | 领取开始时间 |
| pickupEnd | DateTime | ✅ | 领取结束时间 |
| pickupLocation | String | ✅ | 领取地点（如 "图书馆一楼教材仓库"）|
| status | String | 默认"0" | 状态：0=草稿, 1=已发布, 2=领取中, 3=已完成 |
| totalClasses | Integer | 自动计算 | 班级总数（关联领书单数）|
| issuedClasses | Integer | 自动计算 | 已出库班级数 |
| createBy | String | 自动 | 创建者 |
| createTime | DateTime | 自动 | 创建时间 |
| updateBy | String | 自动 | 更新者 |
| updateTime | DateTime | 自动 | 更新时间 |
| delFlag | String | 默认"0" | 删除标志（0=正常, 2=删除）|
| remark | String | ❌ | 备注 |

---

### 12.2 查询领书通知列表

#### GET /textbook/notice/list

查询领书通知列表（支持分页、筛选）。

**请求参数** (Query):

| 参数 | 类型 | 必填 | 说明 |
|------|------|:----:|------|
| semester | String | ❌ | 学期筛选 |
| status | String | ❌ | 状态筛选(0/1/2/3) |
| pageNum | Integer | ❌ | 页码（默认1）|
| pageSize | Integer | ❌ | 每页条数（默认10）|

**成功响应** (200):
```json
{
  "code": 200,
  "total": 5,
  "rows": [
    {
      "noticeId": 1,
      "noticeNo": "LS20260416001",
      "semester": "2025-2026学年第二学期",
      "pickupStart": "2026-04-20 09:00:00",
      "pickupEnd": "2026-05-10 17:00:00",
      "pickupLocation": "图书馆一楼教材仓库",
      "status": "2",
      "totalClasses": 12,
      "issuedClasses": 8,
      "createBy": "admin",
      "createTime": "2026-04-16 10:00:00",
      "remark": null
    }
  ]
}
```

**权限要求**: `textbook:notice:list`

---

### 12.3 查询领书通知详情

#### GET /textbook/notice/{noticeId}

根据ID查询领书通知详情。

**路径参数**:

| 参数 | 类型 | 必填 | 说明 |
|------|------|:----:|------|
| noticeId | Long | ✅ | 通知ID |

**成功响应** (200):
```json
{
  "code": 200,
  "data": {
    "noticeId": 1,
    "noticeNo": "LS20260416001",
    "semester": "2025-2026学年第二学期",
    "pickupStart": "2026-04-20 09:00:00",
    "pickupEnd": "2026-05-10 17:00:00",
    "pickupLocation": "图书馆一楼教材仓库",
    "status": "2",
    "totalClasses": 12,
    "issuedClasses": 8,
    "remark": "春季学期教材领取"
  }
}
```

**权限要求**: `textbook:notice:query`

---

### 12.4 新建领书通知

#### POST /textbook/notice

创建新的领书通知（草稿状态）。

**请求体** (JSON):

```json
{
  "semester": "2025-2026学年第二学期",
  "pickupStart": "2026-04-20 09:00:00",
  "pickupEnd": "2026-05-10 17:00:00",
  "pickupLocation": "图书馆一楼教材仓库",
  "remark": "春季学期教材领取"
}
```

**业务规则**:
- 创建时 `status` 默认为 `"0"`（草稿）
- `noticeNo` 在**发布时**自动生成，创建时不生成
- `totalClasses` 和 `issuedClasses` 在关联领书单后自动计算

**成功响应** (200):
```json
{ "code": 200, "msg": "操作成功" }
```

**权限要求**: `textbook:notice:add`

---

### 12.5 编辑领书通知

#### PUT /textbook/notice

编辑领书通知信息。

**请求体** (JSON):

```json
{
  "noticeId": 1,
  "semester": "2025-2026学年第二学期",
  "pickupStart": "2026-04-21 09:00:00",
  "pickupEnd": "2026-05-11 17:00:00",
  "pickupLocation": "图书馆二楼教材仓库",
  "status": "0",
  "remark": "调整后的领取时间和地点"
}
```

**业务规则**:
- 仅允许编辑 **草稿状态(status="0")** 的通知
- 已发布/领取中/完成的通知不可编辑基本信息（可通过级联逻辑自动推进状态）

**成功响应** (200):
```json
{ "code": 200, "msg": "操作成功" }
```

**权限要求**: `textbook:notice:edit`

---

### 12.6 发布领书通知

#### PUT /textbook/notice/publish/{noticeId}

将草稿状态的领书通知正式发布。

**路径参数**:

| 参数 | 类型 | 必填 | 说明 |
|------|------|:----:|------|
| noticeId | Long | ✅ | 通知ID |

**业务逻辑** (`publishNotice()`):
```
1. 校验通知存在且 status = "0"（草稿）
2. 校验该通知下已有关联的领书单（至少1条）
3. 自动生成通知编号：LS + yyyyMMdd + 3位序号
   例：LS20260416001
4. 更新 status = "1"（已发布）
5. 统计 totalClasses = 关联领书单总数
6. @Log 记录操作日志
7. 发送通知（bizType=8: 领书通知发布）
```

**成功响应** (200):
```json
{
  "code": 200,
  "msg": "发布成功",
  "data": {
    "noticeNo": "LS20260416001",
    "totalClasses": 12
  }
}
```

**错误响应** (500):
```json
// 通知不存在
{ "code": 500, "msg": "领书通知不存在" }

// 不是草稿状态
{ "code": 500, "msg": "只有草稿状态的通知才能发布" }

// 没有关联领书单
{ "code": 500, "msg": "请先为该通知添加领书单后再发布" }
```

**权限要求**: `textbook:notice:publish`

---

### 12.7 删除领书通知

#### DELETE /textbook/notice/{noticeIds}

批量删除领书通知（逻辑删除）。

**路径参数**:

| 参数 | 类型 | 必填 | 说明 |
|------|------|:----:|------|
| noticeIds | Long[] | ✅ | 通知ID数组（逗号分隔或数组）|

**业务规则**:
- 执行**逻辑删除**（设置 `del_flag = "2"`），非物理删除
- 仅允许删除 **草稿状态(status="0")** 的通知
- 已发布的通知建议先取消发布或联系管理员

**请求示例**:
```
DELETE /textbook/notice/1,2,3
DELETE /textbook/notice/[1,2,3]
```

**成功响应** (200):
```json
{ "code": 200, "msg": "操作成功" }
```

**权限要求**: `textbook:notice:remove`

---

### 12.8 查看关联领书单

#### GET /textbook/notice/claimForms/{noticeId}

查看某条领书通知下关联的所有领书单。

**路径参数**:

| 参数 | 类型 | 必填 | 说明 |
|------|------|:----:|------|
| noticeId | Long | ✅ | 通知ID |

**成功响应** (200):
```json
{
  "code": 200,
  "data": [
    {
      "formId": 101,
      "formNo": "CF20260416A1B2C3",
      "noticeId": 1,
      "collegeId": 1,
      "majorId": 1,
      "classId": 1,
      "className": "软件工程2301班",
      "status": "2",
      "plannedQty": 45,
      "issuedQty": 45,
      "receiverName": "张三",
      "issueTime": "2026-04-22 10:30:00"
    },
    {
      "formId": 102,
      "formNo": "CF20260416D4E5F6",
      "noticeId": 1,
      "className": "计算机科学2301班",
      "status": "1",
      "plannedQty": 38,
      "issuedQty": 20,
      "receiverName": null,
      "issueTime": null
    }
  ]
}
```

**权限要求**: `textbook:notice:query`

---

## 13. 📋 领书单管理 API 🆕 v4.0新增

**模块路径**: `/textbook/claimForm`
**Controller**: `BookClaimFormController.java`
**权限前缀**: `textbook:claimForm`
**数据库表**: `book_claim_form`, `book_claim_form_detail`

### 13.1 数据模型 BookClaimForm

| 字段 | 类型 | 必填 | 说明 |
|------|------|:----:|------|
| formId | Long | 自增主键 | 领书单ID |
| formNo | String | 自动生成 | 领书单号（CF+UUID前6位，如 CF20260416A1B2C3）|
| noticeId | Long | ✅ | 关联的通知ID（外键→book_notice.notice_id）|
| collegeId | Long | ✅ | 学院ID |
| majorId | Long | ✅ | 专业ID |
| classId | Long | ✅ | 班级ID |
| className | String | ✅ | 班级名称 |
| status | String | 默认"0" | 状态：0=待领取, 1=部分出库, 2=已出库 |
| plannedQty | Integer | ✅ | 应发总数（所有明细计划数量之和）|
| issuedQty | Integer | 默认0 | 实发总数（所有明细实发数量之和）|
| receiverName | String | ❌ | 领书人姓名 |
| issueTime | DateTime | 自动 | 出库时间 |
| createBy | String | 自动 | 创建者 |
| createTime | DateTime | 自动 | 创建时间 |
| updateBy | String | 自动 | 更新者 |
| updateTime | DateTime | 自动 | 更新时间 |
| delFlag | String | 默认"0" | 删除标志（0=正常, 2=删除）|
| remark | String | ❌ | 备注 |
| details | List | 内嵌 | 明细列表（查询详情时返回）|

### 13.2 数据模型 BookClaimFormDetail

| 字段 | 类型 | 必填 | 说明 |
|------|------|:----:|------|
| detailId | Long | 自增主键 | 明细ID |
| formId | Long | ✅ | 关联的领书单ID（外键→book_claim_form.form_id）|
| textbookId | Long | ✅ | 教材ID（外键→tb_book.book_id）|
| isbn | String | ✅ | ISBN |
| bookName | String | ✅ | 教材名称 |
| author | String | ❌ | 作者 |
| publisher | String | ❌ | 出版社 |
| price | Decimal(10,2) | ❌ | 定价 |
| plannedQty | Integer | ✅ | 应发数量 |
| issuedQty | Integer | 默认0 | 实发数量 |

---

### 13.3 查询领书单列表

#### GET /textbook/claimForm/list

查询领书单列表（支持分页、多条件筛选）。

**请求参数** (Query):

| 参数 | 类型 | 必填 | 说明 |
|------|------|:----:|------|
| noticeId | Long | ❌ | 通知ID筛选 |
| className | String | ❌ | 班级名称模糊搜索 |
| status | String | ❌ | 状态筛选(0/1/2) |
| collegeId | Long | ❌ | 学院ID筛选 |
| pageNum | Integer | ❌ | 页码（默认1）|
| pageSize | Integer | ❌ | 每页条数（默认10）|

**成功响应** (200):
```json
{
  "code": 200,
  "total": 12,
  "rows": [
    {
      "formId": 101,
      "formNo": "CF20260416A1B2C3",
      "noticeId": 1,
      "className": "软件工程2301班",
      "status": "2",
      "plannedQty": 45,
      "issuedQty": 45,
      "receiverName": "张三",
      "issueTime": "2026-04-22 10:30:00",
      "createTime": "2026-04-16 11:00:00"
    }
  ]
}
```

**权限要求**: `textbook:claimForm:list`

---

### 13.4 查询领书单详情（含明细）

#### GET /textbook/claimForm/{formId}

查询领书单详情，包含完整的明细列表。

**路径参数**:

| 参数 | 类型 | 必填 | 说明 |
|------|------|:----:|------|
| formId | Long | ✅ | 领书单ID |

**成功响应** (200):
```json
{
  "code": 200,
  "data": {
    "formId": 101,
    "formNo": "CF20260416A1B2C3",
    "noticeId": 1,
    "collegeId": 1,
    "majorId": 1,
    "classId": 1,
    "className": "软件工程2301班",
    "status": "2",
    "plannedQty": 45,
    "issuedQty": 45,
    "receiverName": "张三",
    "issueTime": "2026-04-22 10:30:00",
    "createTime": "2026-04-16 11:00:00",
    "details": [
      {
        "detailId": 1001,
        "formId": 101,
        "textbookId": 1,
        "isbn": "9787111641242",
        "bookName": "Java程序设计",
        "author": "张三",
        "publisher": "机械工业出版社",
        "price": 59.00,
        "plannedQty": 25,
        "issuedQty": 25
      },
      {
        "detailId": 1002,
        "formId": 101,
        "textbookId": 2,
        "isbn": "9787302519599",
        "bookName": "数据结构与算法",
        "author": "李四",
        "publisher": "清华大学出版社",
        "price": 49.50,
        "plannedQty": 20,
        "issuedQty": 20
      }
    ]
  }
}
```

**权限要求**: `textbook:claimForm:query`

---

### 13.5 新建领书单

#### POST /textbook/claimForm

创建新的领书单及其明细（一次性提交）。

**请求体** (JSON):

```json
{
  "noticeId": 1,
  "collegeId": 1,
  "majorId": 1,
  "classId": 1,
  "className": "软件工程2301班",
  "plannedQty": 45,
  "remark": "软件工程专业班级",
  "details": [
    {
      "textbookId": 1,
      "isbn": "9787111641242",
      "bookName": "Java程序设计",
      "author": "张三",
      "publisher": "机械工业出版社",
      "price": 59.00,
      "plannedQty": 25
    },
    {
      "textbookId": 2,
      "isbn": "9787302519599",
      "bookName": "数据结构与算法",
      "author": "李四",
      "publisher": "清华大学出版社",
      "price": 49.50,
      "plannedQty": 20
    }
  ]
}
```

**业务规则**:
- `formNo` 由后端自动生成（CF+UUID前6位大写）
- `status` 默认为 `"0"`（待领取）
- `plannedQty` 为所有明细 `plannedQty` 之和
- `issuedQty` 初始为 0
- 明细和主单在同一个事务中保存

**成功响应** (200):
```json
{ "code": 200, "msg": "操作成功" }
```

**权限要求**: `textbook:claimForm:add`

---

### 13.6 编辑领书单

#### PUT /textbook/claimForm

编辑领书单信息及明细。

**请求体** (JSON):

```json
{
  "formId": 101,
  "className": "软件工程2301班（修订）",
  "remark": "更新备注",
  "details": [
    {
      "detailId": 1001,
      "formId": 101,
      "textbookId": 1,
      "isbn": "9787111641242",
      "bookName": "Java程序设计（第3版）",
      "plannedQty": 30,
      "issuedQty": 25
    }
  ]
}
```

**业务规则**:
- 仅允许编辑 **待领取(status="0")** 的领书单
- 已部分出库或已出库的单据不允许修改明细（防止数据不一致）

**成功响应** (200):
```json
{ "code": 200, "msg": "操作成功" }
```

**权限要求**: `textbook:claimForm:edit`

---

### 13.7 确认出库（核心接口）⭐

#### PUT /textbook/claimForm/confirmOutbound

确认领书单出库操作（**支持分批出库**）。

**请求体** (JSON):

```json
{
  "formId": 101,
  "issuedQty": 25,
  "receiverName": "张三"
}
```

**参数说明**:

| 参数 | 类型 | 必填 | 说明 |
|------|------|:----:|------|
| formId | Long | ✅ | 领书单ID |
| issuedQty | Integer | ✅ | 本次实发总数（可 ≤ plannedQty 支持分批）|
| receiverName | String | ✅ | 领书人姓名 |

**业务逻辑** (`confirmOutbound()`):
```
确认出库流程:
1. 查询领书单及所有明细
2. 校验状态为"待领取"或"部分出库"(status=0或1)
3. 校验本次实发数量 ≤ (应发总数 - 已实发总数)
4. 循环处理每个明细（按比例分配实发数量）:
   ├── 查询当前库存（tb_inventory）
   ├── 校验库存 ≥ 本次实发数量
   ├── 更新库存（乐观锁：WHERE stock_num = expectedStock）
   │   └── 冲突 → 抛异常"库存已被其他人修改，请刷新后重试"
   ├── 生成库存流水日志（tb_stock_log）
   │   ├── biz_type = "2" (班级领书出库)
   │   ├── before_stock / after_stock
   │   └── operator_id = 当前登录用户
   └── 更新明细 issuedQty
5. 更新领书单:
   ├── issuedQty += 本次实发数量
   ├── receiverName = 领书人姓名
   ├── issueTime = 当前时间
   └── 判断新状态:
       ├── issuedQty == 0 → status = "0" (待领取)
       ├── 0 < issuedQty < plannedQty → status = "1" (部分出库)
       └── issuedQty >= plannedQty → status = "2" (已出库)
6. 调用 updateNoticeProgress() 级联更新通知状态:
   ├── 统计该通知下所有领书单的完成情况
   ├── 更新 notice.issued_classes
   └── 判断通知状态:
       ├── 有任何领书单处于"部分出库" → status = "2" (领取中)
       └── 全部"已出库" → status = "3" (已完成)
7. @Transactional 保证全流程原子性
```

**成功响应** (200):
```json
{
  "code": 200,
  "msg": "操作成功",
  "data": {
    "formId": 101,
    "issuedQty": 25,
    "remainingQty": 20,
    "status": "1",
    "noticeProgress": {
      "noticeId": 1,
      "totalClasses": 12,
      "issuedClasses": 9,
      "noticeStatus": "2"
    }
  }
}
```

**字段说明**:

| 字段 | 说明 |
|------|------|
| remainingQty | 剩余待发数量（plannedQty - issuedQty）|
| status | 出库后的领书单新状态 |
| noticeProgress | 通知级联更新的进度信息 |

**错误响应** (500):
```json
// 领书单不存在
{ "code": 500, "msg": "领书单不存在" }

// 状态不允许出库（已是已出库状态）
{ "code": 500, "msg": "该领书单已全部出库，无需重复操作" }

// 实发数量超过剩余数量
{ "code": 500, "msg": "本次实发数量不能超过剩余待发数量（剩余XX本）" }

// 库存不足
{ "code": 500, "msg": "教材[XXX]库存不足（当前库存XX本，需要XX本）" }

// 并发冲突
{ "code": 500, "msg": "库存已被其他人修改，请刷新后重试" }

// 领书人为空
{ "code": 500, "msg": "请填写领书人姓名" }
```

**权限要求**: `textbook:claimForm:outbound`

> 💡 **分批出库场景示例**:
> - 第1次出库：issuedQty=20（部分出库，status=1）
> - 第2次出库：issuedQty=25（全部完成，status=2，通知自动推进到"领取中"或"已完成")

---

### 13.8 删除领书单

#### DELETE /textbook/claimForm/{formIds}

批量删除领书单（逻辑删除）。

**路径参数**:

| 参数 | 类型 | 必填 | 说明 |
|------|------|:----:|------|
| formIds | Long[] | ✅ | 领书单ID数组（逗号分隔或数组）|

**业务规则**:
- 执行**逻辑删除**（设置 `del_flag = "2"`），非物理删除
- 同时**级联删除**关联的所有明细（`book_claim_form_detail`）
- 仅允许删除 **待领取(status="0")** 的领书单
- 已出库的领书单禁止删除（保证数据完整性）

**请求示例**:
```
DELETE /textbook/claimForm/101,102
DELETE /textbook/claimForm/[101,102]
```

**成功响应** (200):
```json
{ "code": 200, "msg": "操作成功" }
```

**错误响应** (500):
```json
{ "code": 500, "msg": "该领书单已出库，禁止删除" }
```

**权限要求**: `textbook:claimForm:remove`

---

### 13.9 查询领书单明细

#### GET /textbook/claimForm/details/{formId}

查询指定领书单的所有明细记录。

**路径参数**:

| 参数 | 类型 | 必填 | 说明 |
|------|------|:----:|------|
| formId | Long | ✅ | 领书单ID |

**成功响应** (200):
```json
{
  "code": 200,
  "data": [
    {
      "detailId": 1001,
      "formId": 101,
      "textbookId": 1,
      "isbn": "9787111641242",
      "bookName": "Java程序设计",
      "author": "张三",
      "publisher": "机械工业出版社",
      "price": 59.00,
      "plannedQty": 25,
      "issuedQty": 25
    },
    {
      "detailId": 1002,
      "formId": 101,
      "textbookId": 2,
      "isbn": "9787302519599",
      "bookName": "数据结构与算法",
      "author": "李四",
      "publisher": "清华大学出版社",
      "price": 49.50,
      "plannedQty": 20,
      "issuedQty": 20
    }
  ]
}
```

**权限要求**: `textbook:claimForm:query`

---

## 14. 统计分析 API

#### GET /textbook/dashboard/overview

获取系统运营数据概览（仪表盘数据）。

**请求参数** (Query):

| 参数 | 类型 | 必填 | 说明 |
|------|------|:----:|------|
| timeRange | String | ❌ | 时间范围：today/week/month/year/all（默认month）|

**成功响应** (200):
```json
{
  "code": 200,
  "data": {
    "summary": {
      "totalBooks": 156,           // 教材种类总数
      "totalInventory": 12580,     // 库存总量（本数）
      "totalOrders": 892,          // 总订单数
      "totalPurchases": 45,        // 采购单数
      "activeSuppliers": 8,        // 活跃供应商数
      "registeredTeachers": 120    // 注册教师数
    },
    "trend": {
      "orderTrend": [              // 近7天订单趋势
        { "date": "04-10", "count": 12 },
        { "date": "04-11", "count": 15 },
        { "date": "04-12", "count": 8 },
        { "date": "04-13", "count": 20 },
        { "date": "04-14", "count": 18 },
        { "date": "04-15", "count": 25 },
        { "date": "04-16", "count": 14 }
      ],
      "inboundTrend": [            // 近7天入库趋势
        { "date": "04-10", "quantity": 100 },
        { "date": "04-11", "quantity": 0 },
        { "date": "04-12", "quantity": 250 }
      ],
      "outboundTrend": [           // 近7天出库趋势
        { "date": "04-15", "quantity": 85 }
      ]
    },
    "alerts": {
      "warningBooks": 5,          // 预警教材数量
      "pendingReviews": 12,        // 待审核订单
      "pendingInbound": 3,         // 待入库采购单
      "unresolvedShortages": 8     // 未解决缺书
    },
    "topBooks": [                  // 热门教材TOP5
      { "bookName": "Java程序设计", "orderCount": 45, "percentage": "28%" },
      { "bookName": "Python编程", "orderCount": 32, "percentage": "20%" }
    ],
    "deptStats": [                 // 学院统计
      { "deptName": "计算机学院", "orderCount": 156, "amount": 12580.00 },
      { "deptName": "软件学院", "orderCount": 98, "amount": 7840.00 }
    ]
  }
}
```

**权限要求**: 
- admin: 查看全局统计数据
- warehouseman: 查看业务全局数据
- teacher: 仅查看个人相关统计
- supplier: 查看供应商相关统计

---

## 15. 错误码说明 ⚡️ v4.0更新

### 15.1 HTTP 状态码

系统使用标准HTTP状态码表示请求结果：

| 状态码 | 含义 | 说明 | 触发场景 |
|:------:|------|------|---------|
| **200** | OK | 请求成功 | 正常的业务操作 |
| **201** | Created | 资源创建成功 | 新增操作（可选使用）|
| **400** | Bad Request | 请求参数错误 | 缺少必填参数、参数格式错误 |
| **401** | Unauthorized | 未认证 | Token缺失或过期 |
| **403** | Forbidden | 无权限 | @PreAuthorize校验失败 |
| **404** | Not Found | 资源不存在 | ID对应的记录不存在 |
| **405** | Method Not Allowed | 方法不允许 | GET请求访问POST接口等 |
| **500** | Internal Server Error | 服务器内部错误 | 业务逻辑异常、数据库错误等 |

**状态码使用规范**:
- 成功操作统一返回 `200` (不强制使用201)
- 参数校验失败返回 `500` + 错误消息（RuoYi框架约定）
- 认证/授权失败由Spring Security自动处理
- 业务规则违反返回 `500` + 具体错误提示

---

### 15.2 业务错误码

除了HTTP状态码，系统还定义了业务层面的错误码（包含在响应体的code字段中）:

| code值 | 含义 | 说明 |
|:------:|------|------|
| **200** | 成功 | 操作正常完成 |
| **401** | 未认证 | Token无效或已过期 |
| **403** | 无权限 | 当前角色无权执行该操作 |
| **500** | 业务异常 | 具体原因见msg字段 |
| **601** | 验证码错误 | 图形验证码输入错误 |

**常见业务错误示例**:

```json
// 参数缺失
{ "code": 500, "msg": "教材名称不能为空" }

// 数据不存在
{ "code": 500, "msg": "购书单不存在" }

// 业务规则违反
{ "code": 500, "msg": "该购书单已审核通过，禁止删除" }

// 安全限制触发 🆕 v3.0
{ "code": 500, "msg": "安全限制：禁止直接修改库存数量！当前库存：100" }
```

### 15.3 常见错误消息

#### 安全限制类（v3.0保留）

| 错误消息 | 触发场景 | 解决方案 |
|---------|---------|---------|
| "安全限制：禁止直接修改库存数量！库存只能通过入库/出库变更" | 编辑库存时修改了stockNum | 通过入库/出库流程变更库存 |
| "该教材仍有库存（当前XX本），请先通过出库操作将库存清零后再删除" | 删除有库存的教材记录 | 先出库清零再删除 |
| "该购书单已完成领书，禁止删除" | 删除已完成的订单 | 已完成单据不可删除 |
| "该购书单已审核通过，禁止删除" | 删除已审核通过的订单 | 联系库管员驳回后再操作 |

#### 导入类（v3.0保留）

| 错误消息 | 触发场景 | 解决方案 |
|---------|---------|---------|
| "该文件已导入过（MD5: xxx），采购单号：xxx" | 重复上传同一文件 | 先删除原采购单，或使用不同文件 |
| "导入数据超过上限，单次最多1000行" | Excel行数过多 | 分批导入 |
| "仅支持 .xlsx 或 .xls 格式的Excel文件" | 上传了非Excel文件 | 使用正确的Excel格式 |
| "文件大小超过限制（最大10MB）" | 文件过大 | 压缩或拆分文件 |
| "系统中不存在该ISBN对应的教材[xxx]" | 导入数据中有未知ISBN | 先在教材管理中添加该教材 |

#### 并发类（v3.0保留）

| 错误消息 | 触发场景 | 解决方案 |
|---------|---------|---------|
| "库存已被其他人修改，请刷新后重试" | 出库/入库时乐观锁冲突 | 刷新页面重试操作 |

#### 🆕 领书通知类（v4.0新增）

| 错误消息 | 触发场景 | 解决方案 |
|---------|---------|---------|
| "领书通知不存在" | 操作不存在的通知ID | 检查通知ID是否正确 |
| "只有草稿状态的通知才能发布" | 尝试发布非草稿通知 | 检查通知当前状态 |
| "请先为该通知添加领书单后再发布" | 发布没有领书单的通知 | 先创建并关联领书单 |

#### 🆕 领书单类（v4.0新增）

| 错误消息 | 触发场景 | 解决方案 |
|---------|---------|---------|
| "领书单不存在" | 操作不存在的领书单ID | 检查领书单ID是否正确 |
| "该领书单已全部出库，无需重复操作" | 对已完成的单据再次出库 | 检查领书单当前状态 |
| "本次实发数量不能超过剩余待发数量（剩余XX本）" | 实发数超过应发数 | 减少实发数量或使用分批出库 |
| "教材[XXX]库存不足（当前库存XX本，需要XX本）" | 库存不足以支撑出库 | 先入库补足库存再出库 |
| "请填写领书人姓名" | 出库时未填领书人 | 在请求中补充receiverName |
| "该领书单已出库，禁止删除" | 删除已出库的领书单 | 已出库单据不可删除 |

---

## 附录

### A. Postman 测试集合示例

提供标准的Postman Collection配置，方便开发者快速测试API。

**导入步骤**:
1. 打开Postman → 点击"Import"
2. 选择"Upload JSON File"
3. 导入本节提供的JSON配置
4. 在"Variables"标签页配置环境变量

**环境变量配置**:

| 变量名 | 示例值 | 说明 |
|--------|-------|------|
| `{{base_url}}` | http://localhost:8080 | API基础地址 |
| `{{token}}` | eyJhbGciOiJIUzI1NiJ9... | JWT认证Token |

**Collection结构**:

```
教材管理系统 API (v4.0)
├── 📁 1. 认证
│   └── POST /login - 用户登录
│
├── 📁 2. 教材管理
│   ├── GET /textbook/book/list - 教材列表
│   ├── GET /textbook/book/{id} - 教材详情
│   ├── POST /textbook/book - 新增教材
│   ├── PUT /textbook/book - 修改教材
│   └── DELETE /textbook/book/{ids} - 删除教材
│
├── 📁 3. 购书管理 ⚡️ v3.0增强
│   ├── GET /textbook/buy/list - 购书列表（含权限隔离）
│   ├── POST /textbook/buy - 提交申请
│   ├── PUT /textbook/buy/audit - 审核订单
│   ├── PUT /textbook/buy/receive - 确认领书
│   ├── DELETE /textbook/buy/remove/{id} - 删除（安全限制）
│   └── POST /textbook/buy/import - Excel导入🆕
│
├── 📁 4. 库存管理 ⚡️ v3.0增强
│   ├── GET /textbook/inventory/list - 库存列表
│   ├── PUT /textbook/inventory - 编辑（安全限制）
│   └── DELETE /textbook/inventory/{ids} - 删除（库存保护）
│
├── 📁 5. 入库出库管理 🆕 v3.0增强
│   ├── POST /textbook/inbound/process - 入库处理
│   └── POST /textbook/outbound/process - 出库处理
│
├── 📁 6. 缺货管理 ⚡️ v3.0增强
│   ├── GET /textbook/shortage/list - 缺书列表
│   └── POST /textbook/shortage/convertToPurchase - ISBN聚合🆕
│
├── 📁 7. 采购与供应商
│   ├── GET /textbook/supplier/list - 供应商列表
│   ├── GET /textbook/supplier/myPurchaseList - 我的采购单🆕
│   └── PUT /textbook/supplier/confirmShip/{id} - 确认发货🆕
│
├── 📁 8. 通知管理 🆕 v3.0新增
│   ├── GET /textbook/notice/list - 通知列表
│   ├── GET /textbook/notice/unreadCount - 未读数
│   └── PUT /textbook/notice/markRead/{id} - 标记已读
│
├── 📁 9. 领书通知管理 🆕 v4.0新增
│   ├── GET /textbook/notice/list - 领书通知列表
│   ├── POST /textbook/notice - 新建领书通知
│   ├── PUT /textbook/notice/publish/{id} - 发布通知
│   └── GET /textbook/notice/claimForms/{id} - 查看关联领书单
│
├── 📁 10. 领书单管理 🆕 v4.0新增
│   ├── GET /textbook/claimForm/list - 领书单列表
│   ├── POST /textbook/claimForm - 新建领书单
│   ├── PUT /textbook/claimForm/confirmOutbound - 确认出库
│   └── GET /textbook/claimForm/details/{id} - 明细查询
│
└── 📁 11. 统计分析
    └── GET /textbook/dashboard/overview - 数据概览
```

**Pre-request Script示例** (自动获取Token):

```javascript
// 登录并保存Token到环境变量
pm.sendRequest({
    url: pm.environment.get("base_url") + "/login",
    method: "POST",
    header: {
        "Content-Type": "application/json"
    },
    body: {
        mode: "raw",
        raw: JSON.stringify({
            "username": "admin",
            "password": "admin123"
        })
    }
}, function (err, res) {
    if (!err) {
        var token = res.json().token;
        pm.environment.set("token", token);
    }
});
```

**Authorization设置**:

在每个请求的"Authorization"标签中：
- Type: `Bearer Token`
- Token: `{{token}}`

**测试脚本示例** (验证响应):

```javascript
// 测试：验证状态码是否为200
pm.test("Status code is 200", function () {
    pm.response.to.have.status(200);
});

// 测试：验证响应体包含code字段
pm.test("Response has code field", function () {
    var jsonData = pm.response.json();
    pm.expect(jsonData).to.have.property('code');
    pm.expect(jsonData.code).to.eql(200);
});
```

### B. cURL 命令速查 ⚡️ v4.0更新

```bash
# 登录获取Token
TOKEN=$(curl -s -X POST http://localhost:8080/login \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"admin123"}' | jq -r '.token')

# ======== 原有命令（v3.0保留）========

# 查询教材列表
curl -X GET "http://localhost:8080/textbook/book/list?pageNum=1&pageSize=5" \
  -H "Authorization: Bearer $TOKEN" | jq .

# 提交购书申请
curl -X POST http://localhost:8080/textbook/buy \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"bookId":1,"bookName":"Java程序设计","buyNum":2}' | jq .

# 审核购书单
curl -X PUT http://localhost:8080/textbook/buy/audit \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"buyId":12345,"status":"1"}' | jq .

# Excel导入采购单
curl -X POST http://localhost:8080/textbook/buy/import \
  -H "Authorization: Bearer $TOKEN" \
  -F "file=@/path/to/purchase_import.xlsx"

# 下载导入模板
curl -X GET http://localhost:8080/textbook/buy/import/template \
  -H "Authorization: Bearer $TOKEN" \
  --output template.xlsx

# 缺书批量转采购（ISBN聚合）
curl -X POST http://localhost:8080/textbook/shortage/convertToPurchase \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '[1, 2, 3, 5]' | jq .

# ======== 🆕 v4.0 新增：领书通知管理 ========

# 查询领书通知列表
curl -X GET "http://localhost:8080/textbook/notice/list?pageNum=1&pageSize=10" \
  -H "Authorization: Bearer $TOKEN" | jq .

# 查询领书通知详情
curl -X GET "http://localhost:8080/textbook/notice/1" \
  -H "Authorization: Bearer $TOKEN" | jq .

# 新建领书通知（草稿）
curl -X POST http://localhost:8080/textbook/notice \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "semester": "2025-2026学年第二学期",
    "pickupStart": "2026-04-20 09:00:00",
    "pickupEnd": "2026-05-10 17:00:00",
    "pickupLocation": "图书馆一楼教材仓库",
    "remark": "春季学期教材领取"
  }' | jq .

# 发布领书通知
curl -X PUT "http://localhost:8080/textbook/notice/publish/1" \
  -H "Authorization: Bearer $TOKEN" | jq .

# 查看通知关联的领书单
curl -X GET "http://localhost:8080/textbook/notice/claimForms/1" \
  -H "Authorization: Bearer $TOKEN" | jq .

# 删除领书通知
curl -X DELETE "http://localhost:8080/textbook/notice/1" \
  -H "Authorization: Bearer $TOKEN" | jq .

# ======== 🆕 v4.0 新增：领书单管理 ========

# 查询领书单列表
curl -X GET "http://localhost:8080/textbook/claimForm/list?pageNum=1&pageSize=10" \
  -H "Authorization: Bearer $TOKEN" | jq .

# 查询领书单详情（含明细）
curl -X GET "http://localhost:8080/textbook/claimForm/101" \
  -H "Authorization: Bearer $TOKEN" | jq .

# 新建领书单（含明细）
curl -X POST http://localhost:8080/textbook/claimForm \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "noticeId": 1,
    "collegeId": 1,
    "majorId": 1,
    "classId": 1,
    "className": "软件工程2301班",
    "plannedQty": 45,
    "details": [
      {
        "textbookId": 1,
        "isbn": "9787111641242",
        "bookName": "Java程序设计",
        "price": 59.00,
        "plannedQty": 25
      },
      {
        "textbookId": 2,
        "isbn": "9787302519599",
        "bookName": "数据结构与算法",
        "price": 49.50,
        "plannedQty": 20
      }
    ]
  }' | jq .

# 确认出库（分批出库示例）
curl -X PUT "http://localhost:8080/textbook/claimForm/confirmOutbound" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "formId": 101,
    "issuedQty": 25,
    "receiverName": "张三"
  }' | jq .

# 第二次出库（完成剩余部分）
curl -X PUT "http://localhost:8080/textbook/claimForm/confirmOutbound" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "formId": 101,
    "issuedQty": 20,
    "receiverName": "张三"
  }' | jq .

# 查询领书单明细
curl -X GET "http://localhost:8080/textbook/claimForm/details/101" \
  -H "Authorization: Bearer $TOKEN" | jq .

# 删除领书单
curl -X DELETE "http://localhost:8080/textbook/claimForm/101" \
  -H "Authorization: Bearer $TOKEN" | jq .
```

### C. Swagger UI（如启用）

系统集成了 **Knife4j** (Swagger增强版)，提供在线API文档和测试界面。

**访问地址**:
- 本地环境: http://localhost:8080/swagger-ui.html
- 或者: http://localhost:8080/doc.html (Knife4j增强UI)

**功能特性**:

1. **API文档浏览**
   - 按模块分组显示所有RESTful接口
   - 显示请求参数、响应格式、数据模型
   - 支持接口搜索和过滤

2. **在线调试**
   - 直接在页面中填写参数并发送请求
   - 自动携带认证Token
   - 查看实时响应结果

3. **认证配置**
   
   点击页面右上角 🔒 图标 → 输入以下信息:
   ```
   Type: Bearer Token
   Token: <登录获取的JWT>
   ```

4. **主要API分组**

| 分组名称 | Controller | 接口数量 | 说明 |
|---------|-----------|:-------:|------|
| 教材管理 | TbBookController | 5 | 教材CRUD |
| 购书管理 | TbBuyController | 10 | 申请/审核/领书/导入 |
| 库存管理 | TbInventoryController | 4 | 库存查询/编辑(受限) |
| 入库管理 | TbInboundController | 1 | 入库处理 |
| 出库管理 | TbOutboundController | 1 | 出库处理 |
| 缺货管理 | TbShortageController | 3 | 缺书列表/处理/聚合转采购 |
| 采购管理 | TbPurchaseController | 3 | 采购单CRUD |
| 供应商管理 | TbSupplierController | 4 | CRUD + 数据隔离 + 发货确认 |
| 通知管理 | TbNoticeController | 5 | 通知CRUD + 已读未读 |
| 领书通知管理 | BookNoticeController | 7 | 🆕 v4.0 领书通知完整流程 |
| 领书单管理 | BookClaimFormController | 9 | 🆕 v4.0 领书单完整流程 |

**注意事项**:
- Swagger仅在开发/测试环境启用，生产环境建议关闭（安全考虑）
- 可通过配置文件控制: `swagger.enabled=true/false`
- 某些内部接口可能不在Swagger中展示（使用了`@ApiIgnore`注解）

**配置示例** (application-dev.yml):
```yaml
swagger:
  enabled: true                    # 是否开启swagger
  title: 教材管理系统API文档         # 标题
  description: RuoYi-Vue教材管理系统 RESTful APIs  # 描述
  version: 4.0                     # 版本号
  contact:
    name: 系统管理员
    email: admin@example.com
```

---

## 文档修订历史

| 版本 | 日期 | 修订内容 | 作者 |
|------|------|---------|------|
| **v4.0** | **2026-04-16** | **重大更新**：新增领书通知管理API(7个端点)、领书单管理API(7个端点)，含完整的数据模型定义、状态机说明、分批出库逻辑、级联进度更新、乐观锁并发控制等核心业务特性；更新权限对照表、错误码分类（新增领书通知/领书单类）、cURL命令速查（新增14个示例）；总API端点数从v3.0的48个增至62个 | AI Assistant |
| **v3.0** | **2026-04-15** | **重大更新**：14项安全审计修复(#1/#8/#9/#12/#14)，新增Excel导入MD5防重复、缺书ISBN聚合、通知管理API、供应商发货确认、库存安全保护、教师数据隔离、已完成单据删除保护 | AI Assistant |
| v2.0 | 2026-04-15 | 角色体系重构v4.0，删除学生/发行员/采购员角色，新增库管员/供应商角色 | AI Assistant |
| v1.0 | 2026-04-13 | 初稿，覆盖全部16个模块的主要API | AI Assistant |

---

*本文档基于 RuoYi-Vue 教材管理系统最新代码版本自动生成*
*如有疑问请参考[《教材管理系统设计文档.md》(v4.0)](./教材管理系统设计文档.md)或[《教材采购系统_完整流程设计.md》（权威设计规范）](./教材采购系统_完整流程设计.md)*
