# 教材管理系统 API 接口文档

## 一、接口概述

本文档详细描述了教材采购与库存管理系统（若依框架 v3.9.0 + Spring Boot 2.x + Vue2 + ElementUI + MySQL + Redis）的所有 RESTful API 接口。系统包含教材管理、购书管理、个人领书申请、库存管理、入库管理、出库管理、缺书管理、待购教材管理、供应商管理、领书通知管理、领书单管理、库存流水、通知中心、库存盘点、仪表盘等核心模块。

**基础路径**: `http://localhost:8080`

**认证方式**: 本系统使用若依框架的权限认证机制，所有接口需要在请求头中携带 `Authorization` 令牌。

---

## 二、通用说明

### 2.1 请求格式

| 内容 | 说明 |
|------|------|
| 请求方法 | GET（查询）、POST（新增）、PUT（修改/更新）、DELETE（删除） |
| Content-Type | application/json（除文件导出/导入接口外） |
| 字符编码 | UTF-8 |

### 2.2 分页查询参数

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| pageNum | Integer | 否 | 当前页码，默认1 |
| pageSize | Integer | 否 | 每页数量，默认10 |

### 2.3 响应格式

**成功响应**:
```json
{
  "code": 200,
  "msg": "操作成功",
  "data": {}
}
```

**分页响应（TableDataInfo）**:
```json
{
  "code": 200,
  "msg": "操作成功",
  "rows": [],
  "total": 100
}
```

**错误响应**:
```json
{
  "code": 500,
  "msg": "错误信息",
  "data": null
}
```

### 2.4 状态码说明

| 状态码 | 说明 |
|--------|------|
| 200 | 请求成功 |
| 401 | 未授权/登录过期 |
| 403 | 权限不足 |
| 500 | 服务器内部错误 |

---

## 三、教材管理模块（TbBookController）

**接口路径前缀**: `/textbook/book`

### 3.1 查询教材列表

**请求方式**: `GET /textbook/book/list`

**权限标识**: `textbook:book:list`

**请求参数**:

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| bookName | String | 否 | 教材名称（模糊查询） |
| isbn | String | 否 | ISBN编号 |
| author | String | 否 | 作者 |
| publisher | String | 否 | 出版社 |
| category | String | 否 | 分类 |
| textbookType | String | 否 | 教材类型（1=必修,2=选修,3=参考） |
| status | String | 否 | 状态（0=正常,1=停用） |
| pageNum | Integer | 否 | 页码 |
| pageSize | Integer | 否 | 每页数量 |

**响应示例**:
```json
{
  "code": 200,
  "msg": "查询成功",
  "rows": [
    {
      "bookId": 1,
      "bookName": "Java程序设计教程",
      "isbn": "9787302123456",
      "author": "张三",
      "publisher": "清华大学出版社",
      "publishDate": "2022-03-01",
      "edition": "第4版",
      "printTimes": null,
      "format": null,
      "binding": null,
      "price": 59.00,
      "wordCount": null,
      "pageCount": null,
      "courseName": "Java程序设计",
      "major": "软件工程",
      "grade": "本科大二",
      "textbookType": "1",
      "category": "计算机",
      "description": "经典Java入门教材",
      "coverImage": null,
      "status": "0"
    }
  ],
  "total": 10
}
```

### 3.2 获取教材详情

**请求方式**: `GET /textbook/book/{bookId}`

**权限标识**: `textbook:book:query`

**路径参数**:

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| bookId | Long | 是 | 教材ID |

**响应示例**:
```json
{
  "code": 200,
  "msg": "查询成功",
  "data": {
    "bookId": 1,
    "bookName": "Java程序设计教程",
    "isbn": "9787302123456",
    "author": "张三",
    "publisher": "清华大学出版社",
    "publishDate": "2022-03-01",
    "edition": "第4版",
    "printTimes": null,
    "format": null,
    "binding": null,
    "price": 59.00,
    "wordCount": null,
    "pageCount": null,
    "courseName": "Java程序设计",
    "major": "软件工程",
    "grade": "本科大二",
    "textbookType": "1",
    "category": "计算机",
    "description": "经典Java入门教材",
    "coverImage": null,
    "status": "0",
    "delFlag": "0"
  }
}
```

### 3.3 新增教材

**请求方式**: `POST /textbook/book`

**权限标识**: `textbook:book:add`

**角色限制**: admin, warehouse_manager

**请求体**:
```json
{
  "bookName": "Python数据分析实战",
  "isbn": "9787302123463",
  "author": "李四",
  "publisher": "清华大学出版社",
  "publishDate": "2023-02-01",
  "edition": "第2版",
  "price": 45.00,
  "courseName": "Python数据分析",
  "major": "大数据技术",
  "grade": "研究生",
  "textbookType": "1",
  "category": "计算机"
}
```

**响应示例**:
```json
{
  "code": 200,
  "msg": "新增成功"
}
```

### 3.4 修改教材

**请求方式**: `PUT /textbook/book`

**权限标识**: `textbook:book:edit`

**角色限制**: admin, warehouse_manager

**请求体**: 同新增接口，需包含 bookId 字段

### 3.5 删除教材

**请求方式**: `DELETE /textbook/book/{bookId}`

**权限标识**: `textbook:book:remove`

**角色限制**: admin, warehouse_manager

**路径参数**:

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| bookId | Long | 是 | 教材ID |

**响应示例**:
```json
{
  "code": 200,
  "msg": "删除成功"
}
```

### 3.6 导出教材列表

**请求方式**: `POST /textbook/book/export`

**权限标识**: `textbook:book:export`

**请求参数**: 同查询列表接口参数

**响应**: Excel文件下载

---

## 四、教材信息模块（TbInfoController）

**接口路径前缀**: `/textbook/info`

> 注：此模块为教材信息的另一套CRUD接口，与TbBookController功能类似但路径不同。

### 4.1 查询教材信息列表

**请求方式**: `GET /textbook/info/list`

**权限标识**: `textbook:info:list`

**请求参数**: 同教材管理模块查询参数

### 4.2 获取教材信息详情

**请求方式**: `GET /textbook/info/info/{bookId}`

**权限标识**: `textbook:info:query`

### 4.3 新增教材信息

**请求方式**: `POST /textbook/info/add`

**权限标识**: `textbook:info:add`

**角色限制**: admin, warehouse_manager

### 4.4 修改教材信息

**请求方式**: `PUT /textbook/info/edit`

**权限标识**: `textbook:info:edit`

**角色限制**: admin, warehouse_manager

### 4.5 删除教材信息

**请求方式**: `DELETE /textbook/info/remove/{bookId}`

**权限标识**: `textbook:info:remove`

**角色限制**: admin, warehouse_manager

### 4.6 导出教材信息

**请求方式**: `POST /textbook/info/export`

**权限标识**: `textbook:info:export`

---

## 五、购书管理模块（TbPurchaseController）

**接口路径前缀**: `/textbook/purchase`

### 5.1 查询购书单列表

**请求方式**: `GET /textbook/purchase/list`

**权限标识**: `textbook:purchase:list`

**数据权限**: @DataScope 数据范围过滤

**请求参数**:

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| purchaseNo | String | 否 | 申请单号 |
| userName | String | 否 | 申请人姓名 |
| auditStatus | String | 否 | 审核状态（0=待审核,1=已通过,2=已驳回,3=已领书,4=已取消） |
| receiveStatus | String | 否 | 领书状态（0=未领,1=已领） |
| submitTime | String | 否 | 申请时间 |
| pageNum | Integer | 否 | 页码 |
| pageSize | Integer | 否 | 每页数量 |

**响应示例**:
```json
{
  "code": 200,
  "msg": "查询成功",
  "rows": [
    {
      "buyId": 1,
      "purchaseNo": "BUY202403010001",
      "userId": 101,
      "userName": "张明远",
      "userType": "1",
      "deptName": "计算机科学与技术学院",
      "bookId": 1,
      "bookName": "Java程序设计教程",
      "buyNum": 3,
      "submitTime": "2026-04-07 00:06:21",
      "status": "1",
      "receiveStatus": "1",
      "fundingSource": "自费",
      "supplierId": null,
      "logisticsNo": null,
      "logisticsCompany": null,
      "invoiceNo": null,
      "details": []
    }
  ],
  "total": 5
}
```

### 5.2 获取购书单详情

**请求方式**: `GET /textbook/purchase/detail/{id}`

**权限标识**: `textbook:purchase:query`

**路径参数**:

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| id | Long | 是 | 购书单ID（buyId） |

**响应示例**:
```json
{
  "code": 200,
  "msg": "查询成功",
  "data": {
    "buyId": 1,
    "purchaseNo": "BUY202403010001",
    "userId": 101,
    "userName": "张明远",
    "userType": "1",
    "deptName": "计算机科学与技术学院",
    "bookId": 1,
    "bookName": "Java程序设计教程",
    "isbn": "9787302123456",
    "buyNum": 3,
    "submitTime": "2026-04-07 00:06:21",
    "status": "1",
    "auditUserId": null,
    "auditTime": null,
    "rejectReason": null,
    "auditOpinion": null,
    "receiveStatus": "1",
    "receiveTime": null,
    "fundingSource": "自费",
    "supplierId": null,
    "logisticsNo": null,
    "logisticsCompany": null,
    "invoiceNo": null,
    "details": [
      {
        "detailId": 1,
        "purchaseId": 1,
        "bookId": 1,
        "bookName": "Java程序设计教程",
        "isbn": "9787302123456",
        "quantity": 3,
        "unitPrice": 59.00,
        "totalPrice": 177.00
      }
    ]
  }
}
```

### 5.3 提交购书单

**请求方式**: `POST /textbook/purchase/submit`

**权限标识**: `textbook:purchase:add`

**请求体**:
```json
{
  "bookId": 1,
  "buyNum": 3,
  "fundingSource": "自费"
}
```

**响应示例**:
```json
{
  "code": 200,
  "msg": "提交成功"
}
```

### 5.4 批量提交购书单

**请求方式**: `POST /textbook/purchase/batchSubmit`

**权限标识**: `textbook:purchase:add`

**请求体**:
```json
[
  {
    "bookId": 1,
    "buyNum": 2,
    "fundingSource": "科研经费"
  },
  {
    "bookId": 2,
    "buyNum": 3,
    "fundingSource": "院系经费"
  }
]
```

**响应示例**:
```json
{
  "code": 200,
  "msg": "批量提交成功"
}
```

### 5.5 审核购书单

**请求方式**: `PUT /textbook/purchase/audit`

**权限标识**: `textbook:purchase:audit`

**请求体**:
```json
{
  "buyId": 1,
  "status": "1",
  "rejectReason": null,
  "auditOpinion": "审核通过"
}
```

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| buyId | Long | 是 | 购书单ID |
| status | String | 是 | 审核状态（1=通过,2=驳回） |
| rejectReason | String | 否 | 驳回原因（status=2时必填） |
| auditOpinion | String | 否 | 审核意见 |

**响应示例**:
```json
{
  "code": 200,
  "msg": "审核成功"
}
```

### 5.6 取消购书单

**请求方式**: `PUT /textbook/purchase/cancel/{id}`

**权限标识**: `textbook:purchase:add`

**路径参数**:

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| id | Long | 是 | 购书单ID |

**业务规则**:
- 只能取消自己的订单
- 只能取消待审核（auditStatus=0）的订单

**响应示例**:
```json
{
  "code": 200,
  "msg": "取消成功"
}
```

### 5.7 确认领书

**请求方式**: `PUT /textbook/purchase/receive/{id}`

**权限标识**: `textbook:purchase:add`

**路径参数**:

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| id | Long | 是 | 购书单ID |

**响应示例**:
```json
{
  "code": 200,
  "msg": "领书确认成功"
}
```

### 5.8 删除购书单

**请求方式**: `DELETE /textbook/purchase/remove/{id}`

**权限标识**: `textbook:purchase:remove`

**路径参数**:

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| id | Long | 是 | 购书单ID |

**业务规则**:
- 已入库的采购单禁止删除
- 已到货的采购单禁止删除，需先完成入库
- 已完成领书的订单禁止删除
- 已审核通过的订单禁止删除

**响应示例**:
```json
{
  "code": 200,
  "msg": "删除成功"
}
```

---

## 六、购书单-教师端模块（TbBuyController）

**接口路径前缀**: `/textbook/buy`

### 6.1 查询购书单列表

**请求方式**: `GET /textbook/buy/list`

**权限标识**: `textbook:buy:list`

### 6.2 获取购书单详情

**请求方式**: `GET /textbook/buy/detail/{id}`

**权限标识**: `textbook:buy:query`

### 6.3 提交购书单

**请求方式**: `POST /textbook/buy/submit`

**权限标识**: `textbook:buy:add`

### 6.4 审核购书单

**请求方式**: `PUT /textbook/buy/audit`

**权限标识**: `textbook:buy:audit`

### 6.5 确认领书

**请求方式**: `PUT /textbook/buy/receive/{id}`

**权限标识**: `textbook:buy:receive`

### 6.6 删除购书单

**请求方式**: `DELETE /textbook/buy/remove/{id}`

**权限标识**: `textbook:buy:remove`

### 6.7 导入购书单（Excel）

**请求方式**: `POST /textbook/buy/import`

**权限标识**: `textbook:buy:import`

**防重复提交**: @RepeatSubmit

**Content-Type**: multipart/form-data

**请求参数**:

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| file | File | 是 | Excel文件 |

**响应示例**:
```json
{
  "code": 200,
  "msg": "导入成功",
  "data": {
    "success": 10,
    "fail": 2
  }
}
```

### 6.8 下载导入模板

**请求方式**: `GET /textbook/buy/import/template`

**权限标识**: `textbook:buy:import`

**响应**: Excel文件下载

---

## 七、个人领书申请模块（BookPersonalApplyController）

**接口路径前缀**: `/textbook/personalApply`

### 7.1 查询个人领书申请列表

**请求方式**: `GET /textbook/personalApply/list`

**权限标识**: `textbook:personalApply:list`

**数据权限**: @DataScope 数据范围过滤

**请求参数**:

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| applyNo | String | 否 | 申请编号 |
| teacherName | String | 否 | 教师姓名 |
| bookName | String | 否 | 教材名称 |
| status | String | 否 | 状态 |
| pageNum | Integer | 否 | 页码 |
| pageSize | Integer | 否 | 每页数量 |

**响应示例**:
```json
{
  "code": 200,
  "msg": "查询成功",
  "rows": [
    {
      "applyId": 1,
      "applyNo": "APPLY20240301001",
      "teacherId": 100,
      "teacherName": "张老师",
      "textbookId": 1,
      "isbn": "9787302123456",
      "bookName": "Java程序设计教程",
      "applyQty": 5,
      "purpose": "教学用书",
      "status": "0",
      "auditOpinion": null,
      "auditBy": null,
      "auditTime": null,
      "issueTime": null,
      "remark": null
    }
  ],
  "total": 10
}
```

### 7.2 查询我的领书申请

**请求方式**: `GET /textbook/personalApply/myList`

**权限标识**: `textbook:myApply:list`

**业务说明**: 当前登录用户查看自己提交的领书申请

### 7.3 获取领书申请详情

**请求方式**: `GET /textbook/personalApply/{applyId}`

**权限标识**: `textbook:personalApply:query`

### 7.4 新增领书申请

**请求方式**: `POST /textbook/personalApply`

**权限标识**: `textbook:personalApply:add`

**请求体**:
```json
{
  "textbookId": 1,
  "applyQty": 5,
  "purpose": "教学用书",
  "remark": "本学期教学需要"
}
```

### 7.5 取消领书申请

**请求方式**: `PUT /textbook/personalApply/cancel/{applyId}`

**权限标识**: `textbook:personalApply:cancel`

**业务规则**: 只能取消待审核的申请

### 7.6 审核领书申请

**请求方式**: `PUT /textbook/personalApply/audit`

**权限标识**: `textbook:personalApply:audit`

**请求体**:
```json
{
  "applyId": 1,
  "status": "1",
  "auditOpinion": "审核通过"
}
```

### 7.7 确认发放

**请求方式**: `PUT /textbook/personalApply/issue/{applyId}`

**权限标识**: `textbook:personalApply:issue`

**业务说明**: 库管员确认发放教材，扣减库存

### 7.8 删除领书申请

**请求方式**: `DELETE /textbook/personalApply/{applyIds}`

**权限标识**: `textbook:personalApply:remove`

---

## 八、库存管理模块（TbInventoryController）

**接口路径前缀**: `/textbook/inventory`

### 8.1 查询库存列表

**请求方式**: `GET /textbook/inventory/list`

**权限标识**: `textbook:inventory:list`

**请求参数**:

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| bookName | String | 否 | 教材名称 |
| isbn | String | 否 | ISBN |
| stockStatus | String | 否 | 库存状态（normal=正常,warning=预警,shortage=短缺） |
| pageNum | Integer | 否 | 页码 |
| pageSize | Integer | 否 | 每页数量 |

**响应示例**:
```json
{
  "code": 200,
  "msg": "查询成功",
  "rows": [
    {
      "stockId": 1,
      "bookId": 1,
      "bookName": "Java程序设计教程",
      "isbn": "9787302123456",
      "author": "张三",
      "publisher": "清华大学出版社",
      "major": "软件工程",
      "stockNum": 156,
      "storageAddr": "A区01架02层",
      "warningNum": 10,
      "totalPurchase": 200,
      "totalIssued": 44,
      "stockStatus": "normal",
      "version": 0
    }
  ],
  "total": 10
}
```

### 8.2 获取库存详情

**请求方式**: `GET /textbook/inventory/{inventoryId}`

**权限标识**: `textbook:inventory:query`

**路径参数**:

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| inventoryId | Long | 是 | 库存ID |

### 8.3 获取库存预警列表

**请求方式**: `GET /textbook/inventory/warning`

**权限标识**: `textbook:inventory:warning`

**响应示例**:
```json
{
  "code": 200,
  "msg": "查询成功",
  "rows": [
    {
      "stockId": 3,
      "bookId": 3,
      "bookName": "高等数学（上册）",
      "stockNum": 12,
      "warningNum": 20,
      "stockStatus": "shortage"
    },
    {
      "stockId": 6,
      "bookId": 6,
      "bookName": "计算机网络原理",
      "stockNum": 67,
      "warningNum": 25,
      "stockStatus": "warning"
    }
  ],
  "total": 3
}
```

### 8.4 根据教材ID查询库存

**请求方式**: `GET /textbook/inventory/byBook/{bookId}`

**权限标识**: `textbook:inventory:query`

**路径参数**:

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| bookId | Long | 是 | 教材ID |

### 8.5 导出库存列表

**请求方式**: `POST /textbook/inventory/export`

**权限标识**: `textbook:inventory:export`

**导出限制**: @MaxExportRows(10000) 最多导出10000条

**请求参数**: 同查询列表接口参数

**响应**: Excel文件下载

---

## 九、库存编辑模块（TbStockController）

**接口路径前缀**: `/textbook/stock`

> 注：此模块提供库存编辑功能，主要用于修改预警阈值等。

### 9.1 查询库存列表

**请求方式**: `GET /textbook/stock/list`

**权限标识**: `textbook:stock:list`

### 9.2 获取库存详情

**请求方式**: `GET /textbook/stock/{stockId}`

**权限标识**: `textbook:stock:query`

### 9.3 修改库存信息

**请求方式**: `PUT /textbook/stock`

**权限标识**: `textbook:stock:edit`

**角色限制**: admin, warehouse_manager

**请求体**:
```json
{
  "stockId": 1,
  "warningNum": 20,
  "storageAddr": "A区01架02层"
}
```

### 9.4 导出库存

**请求方式**: `GET /textbook/stock/export`

**权限标识**: `textbook:stock:export`

**响应**: Excel文件下载

---

## 十、入库管理模块（TbInboundController）

**接口路径前缀**: `/textbook/inbound`

### 10.1 查询入库列表

**请求方式**: `GET /textbook/inbound/list`

**权限标识**: `textbook:inbound:list`

**请求参数**:

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| inboundNo | String | 否 | 入库单号 |
| bookName | String | 否 | 教材名称 |
| supplier | String | 否 | 供应商 |
| inTime | String | 否 | 入库时间 |
| pageNum | Integer | 否 | 页码 |
| pageSize | Integer | 否 | 每页数量 |

**响应示例**:
```json
{
  "code": 200,
  "msg": "查询成功",
  "rows": [
    {
      "inId": 1,
      "inboundNo": "IN202403010001",
      "pendingId": null,
      "bookId": 1,
      "bookName": "Java程序设计教程",
      "isbn": "9787302123456",
      "inNum": 50,
      "inTime": "2026-04-12 00:06:21",
      "operatorId": 100,
      "operatorName": "管理员",
      "supplier": "高等教育出版社",
      "supplierId": null,
      "unitPrice": 52.00,
      "totalPrice": 2600.00,
      "purchaseId": null,
      "remark": "春季采购第一批次入库"
    }
  ],
  "total": 5
}
```

### 10.2 获取入库详情

**请求方式**: `GET /textbook/inbound/{inboundId}`

**权限标识**: `textbook:inbound:query`

**路径参数**:

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| inboundId | Long | 是 | 入库ID |

### 10.3 新增进库记录

**请求方式**: `POST /textbook/inbound`

**权限标识**: `textbook:inbound:add`

**角色限制**: admin, warehouse_manager

**请求体**:
```json
{
  "bookId": 1,
  "inNum": 50,
  "supplier": "高等教育出版社",
  "supplierPhone": "010-12345678",
  "unitPrice": 52.00,
  "remark": "春季采购入库"
}
```

### 10.4 修改入库记录

**请求方式**: `PUT /textbook/inbound`

**权限标识**: `textbook:inbound:edit`

**角色限制**: admin, warehouse_manager

**业务说明**: 此接口已禁用，调用将返回错误提示

### 10.5 删除入库记录

**请求方式**: `DELETE /textbook/inbound/{inboundIds}`

**权限标识**: `textbook:inbound:remove`

**角色限制**: admin, warehouse_manager

**路径参数**:

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| inboundIds | Long[] | 是 | 入库ID数组 |

### 10.6 处理入库

**请求方式**: `POST /textbook/inbound/process`

**权限标识**: `textbook:inbound:process`

**角色限制**: admin, warehouse_manager

**请求体**:
```json
{
  "bookId": 1,
  "inNum": 50,
  "supplier": "高等教育出版社",
  "unitPrice": 52.00,
  "remark": "采购入库"
}
```

**业务说明**: 此接口会执行入库操作，扣减关联的待采购数量，增加库存，记录库存流水

### 10.7 导出入库列表

**请求方式**: `POST /textbook/inbound/export`

**权限标识**: `textbook:inbound:export`

**响应**: Excel文件下载

---

## 十一、出库管理模块（TbOutboundController）

**接口路径前缀**: `/textbook/outbound`

### 11.1 查询出库列表

**请求方式**: `GET /textbook/outbound/list`

**权限标识**: `textbook:outbound:list`

**请求参数**:

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| outboundNo | String | 否 | 出库单号 |
| bookName | String | 否 | 教材名称 |
| userName | String | 否 | 领书人 |
| outTime | String | 否 | 出库时间 |
| pageNum | Integer | 否 | 页码 |
| pageSize | Integer | 否 | 每页数量 |

**响应示例**:
```json
{
  "code": 200,
  "msg": "查询成功",
  "rows": [
    {
      "outId": 1,
      "outboundNo": "OUT202403060001",
      "buyId": 1,
      "purchaseNo": "BUY202403010001",
      "bookId": 1,
      "bookName": "Java程序设计教程",
      "isbn": "9787302123456",
      "outNum": 3,
      "outTime": "2026-04-12 00:06:21",
      "receiveId": 101,
      "userName": "张明远",
      "deptName": "计算机科学与技术学院",
      "operatorId": 100,
      "operatorName": "管理员"
    }
  ],
  "total": 2
}
```

### 11.2 获取出库详情

**请求方式**: `GET /textbook/outbound/{outboundId}`

**权限标识**: `textbook:outbound:query`

### 11.3 新增出库记录

**请求方式**: `POST /textbook/outbound`

**权限标识**: `textbook:outbound:add`

**角色限制**: admin, warehouse_manager

**业务说明**: 此接口已禁用，调用将返回错误提示。出库操作请使用处理出库接口。

### 11.4 修改出库记录

**请求方式**: `PUT /textbook/outbound`

**权限标识**: `textbook:outbound:edit`

**角色限制**: admin, warehouse_manager

**业务说明**: 此接口已禁用，调用将返回错误提示

### 11.5 删除出库记录

**请求方式**: `DELETE /textbook/outbound/{outboundIds}`

**权限标识**: `textbook:outbound:remove`

**角色限制**: admin, warehouse_manager

### 11.6 处理出库

**请求方式**: `POST /textbook/outbound/process/{purchaseId}`

**权限标识**: `textbook:outbound:process`

**角色限制**: admin, warehouse_manager

**路径参数**:

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| purchaseId | Long | 是 | 采购单ID |

**请求参数**:

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| operatorId | Long | 是 | 操作人ID |
| operatorName | String | 是 | 操作人姓名 |

**业务说明**: 根据采购单执行出库操作，扣减库存，生成出库记录和库存流水

### 11.7 根据采购单ID查询出库记录

**请求方式**: `GET /textbook/outbound/byPurchase/{purchaseId}`

**权限标识**: `textbook:outbound:query`

### 11.8 导出出库列表

**请求方式**: `POST /textbook/outbound/export`

**权限标识**: `textbook:outbound:export`

---

## 十二、缺书管理模块（TbShortageController）

**接口路径前缀**: `/textbook/shortage`

### 12.1 查询缺书列表

**请求方式**: `GET /textbook/shortage/list`

**权限标识**: `textbook:shortage:list`

**请求参数**:

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| bookName | String | 否 | 教材名称 |
| isbn | String | 否 | ISBN |
| urgency | String | 否 | 紧急程度（0=普通,1=紧急,2=特急） |
| handleStatus | String | 否 | 处理状态（0=未处理,1=已纳入采购,2=已到货,3=已完成） |
| source | String | 否 | 来源（1=领书缺货,2=库存预警） |
| pageNum | Integer | 否 | 页码 |
| pageSize | Integer | 否 | 每页数量 |

**响应示例**:
```json
{
  "code": 200,
  "msg": "查询成功",
  "rows": [
    {
      "lackId": 1,
      "bookId": 3,
      "bookName": "高等数学（上册）",
      "isbn": "9787040123456",
      "lackNum": 18,
      "urgency": "1",
      "registerId": 100,
      "registerName": "管理员",
      "handleStatus": "1",
      "handleTime": "2026-04-12 00:06:21",
      "registerTime": "2026-04-09 00:06:21",
      "source": "1",
      "sourceId": 102,
      "purchaseId": null
    }
  ],
  "total": 3
}
```

### 12.2 获取缺书详情

**请求方式**: `GET /textbook/shortage/{shortageId}`

**权限标识**: `textbook:shortage:query`

### 12.3 新增缺书登记

**请求方式**: `POST /textbook/shortage`

**权限标识**: `textbook:shortage:add`

**角色限制**: admin, warehouse_manager, teacher

**请求体**:
```json
{
  "bookId": 3,
  "lackNum": 10,
  "urgency": "0",
  "remark": "库存不足"
}
```

### 12.4 修改缺书登记

**请求方式**: `PUT /textbook/shortage`

**权限标识**: `textbook:shortage:edit`

**角色限制**: admin, warehouse_manager

### 12.5 删除缺书登记

**请求方式**: `DELETE /textbook/shortage/{shortageIds}`

**权限标识**: `textbook:shortage:remove`

**角色限制**: admin, warehouse_manager

### 12.6 处理缺书

**请求方式**: `PUT /textbook/shortage/process/{shortageId}`

**权限标识**: `textbook:shortage:process`

**角色限制**: admin, warehouse_manager

**路径参数**:

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| shortageId | Long | 是 | 缺书ID |

**请求参数**:

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| status | String | 是 | 处理状态（0=未处理,1=已纳入采购,2=已到货,3=已完成） |

### 12.7 根据教材ID查询缺书记录

**请求方式**: `GET /textbook/shortage/byBook/{bookId}`

**权限标识**: `textbook:shortage:query`

### 12.8 批量转采购（ISBN聚合）

**请求方式**: `POST /textbook/shortage/convertToPurchase`

**权限标识**: `textbook:shortage:process`

**角色限制**: admin, warehouse_manager

**请求体**:
```json
[1, 2, 3]
```

**业务说明**: 将多个缺书记录按ISBN聚合，生成采购单

**响应示例**:
```json
{
  "code": 200,
  "msg": "成功将3条缺书记录转换为2个采购单",
  "data": {
    "success": true,
    "msg": "成功将3条缺书记录转换为2个采购单",
    "purchaseIds": [1, 2]
  }
}
```

### 12.9 导出缺书列表

**请求方式**: `POST /textbook/shortage/export`

**权限标识**: `textbook:shortage:export`

---

## 十三、待购教材管理模块（TbPendingController）

**接口路径前缀**: `/textbook/pending`

### 13.1 查询待购教材列表

**请求方式**: `GET /textbook/pending/list`

**权限标识**: `textbook:pending:list`

**请求参数**:

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| pendingNo | String | 否 | 采购单号 |
| bookName | String | 否 | 教材名称 |
| status | String | 否 | 状态（0=待采购,1=采购中,2=已到货,3=已入库） |
| pageNum | Integer | 否 | 页码 |
| pageSize | Integer | 否 | 每页数量 |

**响应示例**:
```json
{
  "code": 200,
  "msg": "查询成功",
  "rows": [
    {
      "pendingId": 1,
      "pendingNo": "PEND20240301001",
      "lackId": null,
      "bookId": 3,
      "bookName": "高等数学（上册）",
      "isbn": "9787040123456",
      "purchaseNum": 50,
      "status": "0",
      "supplier": "高等教育出版社",
      "supplierPhone": "010-12345678",
      "expectedDate": "2026-04-20",
      "actualDate": null,
      "purchaseUserId": 101,
      "purchaserName": "库管员"
    }
  ],
  "total": 5
}
```

### 13.2 获取待购教材详情

**请求方式**: `GET /textbook/pending/{pendingId}`

**权限标识**: `textbook:pending:query`

### 13.3 新增待购教材

**请求方式**: `POST /textbook/pending`

**权限标识**: `textbook:pending:add`

**角色限制**: admin, warehouse_manager

**请求体**:
```json
{
  "bookId": 3,
  "purchaseNum": 50,
  "supplier": "高等教育出版社",
  "supplierPhone": "010-12345678",
  "expectedDate": "2026-04-20",
  "remark": "紧急采购"
}
```

### 13.4 修改待购教材

**请求方式**: `PUT /textbook/pending`

**权限标识**: `textbook:pending:edit`

**角色限制**: admin, warehouse_manager

### 13.5 删除待购教材

**请求方式**: `DELETE /textbook/pending/{pendingIds}`

**权限标识**: `textbook:pending:remove`

**角色限制**: admin, warehouse_manager

### 13.6 处理待购教材

**请求方式**: `PUT /textbook/pending/process/{pendingId}`

**权限标识**: `textbook:pending:edit`

**角色限制**: admin, warehouse_manager

**业务说明**: 更新待购教材处理状态

### 13.7 更新待购状态

**请求方式**: `PUT /textbook/pending/updateStatus/{pendingId}`

**权限标识**: `textbook:pending:updateStatus`

**角色限制**: admin, warehouse_manager

**业务说明**: 更新待购教材状态（0=待采购,1=采购中,2=已到货,3=已入库）

### 13.8 确认入库

**请求方式**: `PUT /textbook/pending/inbound/{pendingId}`

**权限标识**: `textbook:pending:edit`

**角色限制**: admin, warehouse_manager

**业务说明**: 确认待购教材已入库，更新状态为已入库，增加库存

### 13.9 根据教材ID查询待购记录

**请求方式**: `GET /textbook/pending/byBook/{bookId}`

**权限标识**: `textbook:pending:query`

### 13.10 导出待购教材列表

**请求方式**: `POST /textbook/pending/export`

**权限标识**: `textbook:pending:export`

---

## 十四、供应商管理模块（TbSupplierController）

**接口路径前缀**: `/textbook/tbSupplier`

> 注：供应商CRUD管理接口路径为 `/textbook/tbSupplier`，供应商角色专用接口见第十五节 SupplierController。

### 14.1 查询供应商列表

**请求方式**: `GET /textbook/tbSupplier/list`

**权限标识**: `textbook:supplier:list`

**请求参数**:

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| supplierName | String | 否 | 供应商名称 |
| contactPerson | String | 否 | 联系人 |
| status | String | 否 | 状态（0=正常,1=停用） |
| pageNum | Integer | 否 | 页码 |
| pageSize | Integer | 否 | 每页数量 |

**响应示例**:
```json
{
  "code": 200,
  "msg": "查询成功",
  "rows": [
    {
      "supplierId": 1,
      "supplierCode": "SUP001",
      "supplierName": "高等教育出版社",
      "contactPerson": "张三",
      "contactPhone": "010-12345678",
      "contactEmail": "contact@hep.com",
      "address": "北京市海淀区",
      "discountRate": 0.95,
      "paymentTerms": "月结30天",
      "bankName": "中国工商银行",
      "bankAccount": "6222021234567890",
      "taxNumber": "110000000000000",
      "status": "0",
      "userId": null
    }
  ],
  "total": 5
}
```

### 14.2 获取供应商详情

**请求方式**: `GET /textbook/tbSupplier/{supplierId}`

**权限标识**: `textbook:supplier:query`

### 14.3 新增供应商

**请求方式**: `POST /textbook/tbSupplier`

**权限标识**: `textbook:supplier:add`

**角色限制**: admin, warehouse_manager

**请求体**:
```json
{
  "supplierCode": "SUP001",
  "supplierName": "高等教育出版社",
  "contactPerson": "张三",
  "contactPhone": "010-12345678",
  "contactEmail": "contact@hep.com",
  "address": "北京市海淀区",
  "discountRate": 0.95,
  "paymentTerms": "月结30天",
  "bankName": "中国工商银行",
  "bankAccount": "6222021234567890",
  "taxNumber": "110000000000000"
}
```

### 14.4 修改供应商

**请求方式**: `PUT /textbook/tbSupplier`

**权限标识**: `textbook:supplier:edit`

**角色限制**: admin, warehouse_manager

### 14.5 删除供应商

**请求方式**: `DELETE /textbook/tbSupplier/{supplierIds}`

**权限标识**: `textbook:supplier:remove`

**角色限制**: admin, warehouse_manager

### 14.6 获取供应商下拉选项

**请求方式**: `GET /textbook/tbSupplier/options`

**权限标识**: 无（公开接口）

**业务说明**: 获取所有状态为正常的供应商列表，用于下拉选择

### 14.7 供应商查询自有采购单

**请求方式**: `GET /textbook/tbSupplier/purchase/list`

**权限标识**: `textbook:supplier:purchase:list`

**业务说明**: 供应商用户查询属于自己的采购订单列表

**请求参数**:

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| auditStatus | String | 否 | 审核状态 |
| purchaseStatus | String | 否 | 采购状态 |
| pageNum | Integer | 否 | 页码 |
| pageSize | Integer | 否 | 每页数量 |

### 14.8 供应商确认发货

**请求方式**: `PUT /textbook/tbSupplier/purchase/ship/{purchaseId}`

**权限标识**: `textbook:supplier:ship`

**防重复提交**: @RepeatSubmit

**路径参数**:

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| purchaseId | Long | 是 | 采购单ID |

**请求参数**:

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| logisticsNo | String | 否 | 物流单号 |
| logisticsCompany | String | 否 | 物流公司 |

**响应示例**:
```json
{
  "code": 200,
  "msg": "发货确认成功"
}
```

---

## 十五、供应商角色模块（SupplierController）

**接口路径前缀**: `/textbook/supplier`

> 注：此模块为供应商角色专用接口，通过角色限制仅 supplier 角色可访问。

### 15.1 供应商仪表盘

**请求方式**: `GET /textbook/supplier/dashboard`

**角色限制**: supplier

**响应示例**:
```json
{
  "code": 200,
  "msg": "查询成功",
  "data": {
    "unreadNoticeCount": 3,
    "pendingShipmentCount": 5
  }
}
```

### 15.2 供应商采购单列表

**请求方式**: `GET /textbook/supplier/purchase/list`

**角色限制**: supplier

**业务说明**: 供应商查看属于自己的采购订单列表

### 15.3 供应商采购单详情

**请求方式**: `GET /textbook/supplier/purchase/detail/{purchaseId}`

**角色限制**: supplier

### 15.4 供应商确认发货

**请求方式**: `POST /textbook/supplier/purchase/shipment`

**角色限制**: supplier

**请求体**:
```json
{
  "purchaseId": 1,
  "logisticsCompany": "顺丰速运",
  "logisticsNo": "SF1234567890",
  "remark": "已发货"
}
```

### 15.5 供应商通知列表

**请求方式**: `GET /textbook/supplier/notice/list`

**角色限制**: supplier

### 15.6 供应商通知详情

**请求方式**: `GET /textbook/supplier/notice/detail/{noticeId}`

**角色限制**: supplier

### 15.7 标记通知已读

**请求方式**: `PUT /textbook/supplier/notice/read/{noticeId}`

**角色限制**: supplier

### 15.8 全部通知标记已读

**请求方式**: `PUT /textbook/supplier/notice/read/all`

**角色限制**: supplier

---

## 十六、供应商角色管理（SupplierRoleController）

**接口路径前缀**: `/textbook/supplier/role`

### 16.1 创建供应商角色

**请求方式**: `POST /textbook/supplier/role/create`

**角色限制**: admin

**业务说明**: 为供应商用户创建角色关联

---

## 十七、领书通知管理模块（BookNoticeController）

**接口路径前缀**: `/textbook/notice`

### 17.1 查询领书通知列表

**请求方式**: `GET /textbook/notice/list`

**权限标识**: `textbook:notice:list`

**请求参数**:

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| noticeNo | String | 否 | 通知编号 |
| semester | String | 否 | 学期 |
| status | String | 否 | 状态（0=草稿,1=已发布,2=领取中,3=已完成） |
| pageNum | Integer | 否 | 页码 |
| pageSize | Integer | 否 | 每页数量 |

**响应示例**:
```json
{
  "code": 200,
  "msg": "查询成功",
  "rows": [
    {
      "noticeId": 1,
      "noticeNo": "NOTICE202401001",
      "semester": "2024春季",
      "pickupStart": "2024-03-01 09:00:00",
      "pickupEnd": "2024-03-15 17:00:00",
      "pickupLocation": "图书馆一层教材科",
      "status": "1",
      "totalClasses": 20,
      "issuedClasses": 5,
      "remark": "请各班班长按时领取",
      "details": []
    }
  ],
  "total": 1
}
```

### 17.2 获取领书通知详情

**请求方式**: `GET /textbook/notice/{noticeId}`

**权限标识**: `textbook:notice:query`

### 17.3 新增领书通知

**请求方式**: `POST /textbook/notice`

**权限标识**: `textbook:notice:add`

**角色限制**: admin, warehouse

**请求体**:
```json
{
  "semester": "2024春季",
  "pickupStart": "2024-03-01 09:00:00",
  "pickupEnd": "2024-03-15 17:00:00",
  "pickupLocation": "图书馆一层教材科",
  "remark": "请各班班长按时领取",
  "details": [
    {
      "collegeId": 1,
      "majorId": 1,
      "classId": 1,
      "className": "计算机21级1班",
      "textbookId": 1,
      "isbn": "9787302123456",
      "bookName": "Java程序设计教程",
      "author": "张三",
      "publisher": "清华大学出版社",
      "price": 59.00,
      "plannedQty": 15
    }
  ]
}
```

### 17.4 修改领书通知

**请求方式**: `PUT /textbook/notice`

**权限标识**: `textbook:notice:edit`

**角色限制**: admin, warehouse

**业务规则**:
- 已发布的通知不可修改
- 已完成的通知不可修改

### 17.5 发布领书通知

**请求方式**: `PUT /textbook/notice/publish/{noticeId}`

**权限标识**: `textbook:notice:publish`

**角色限制**: admin, warehouse

**路径参数**:

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| noticeId | Long | 是 | 通知ID |

**业务说明**: 发布通知后，状态变为"已发布"，可开始领取

### 17.6 删除领书通知

**请求方式**: `DELETE /textbook/notice/{noticeIds}`

**权限标识**: `textbook:notice:remove`

**角色限制**: admin, warehouse

**业务规则**: 已发布的通知不可删除

### 17.7 获取通知关联的领书单

**请求方式**: `GET /textbook/notice/claimForms/{noticeId}`

**权限标识**: `textbook:notice:query`

**路径参数**:

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| noticeId | Long | 是 | 通知ID |

**业务说明**: 根据通知获取对应的领书单列表

### 17.8 获取学院列表

**请求方式**: `GET /textbook/notice/college/list`

**权限标识**: `textbook:notice:list`

**业务说明**: 获取学院列表，用于通知创建时选择学院

### 17.9 获取专业列表

**请求方式**: `GET /textbook/notice/major/list/{collegeId}`

**权限标识**: `textbook:notice:list`

**路径参数**:

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| collegeId | Long | 是 | 学院ID |

### 17.10 获取班级列表

**请求方式**: `GET /textbook/notice/class/list/{majorId}`

**权限标识**: `textbook:notice:list`

**路径参数**:

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| majorId | Long | 是 | 专业ID |

---

## 十八、通知中心模块（TbNoticeController）

**接口路径前缀**: `/textbook/notification`

> 注：此模块为通用通知中心，支持业务通知的发送、阅读标记等功能。

### 18.1 查询通知列表

**请求方式**: `GET /textbook/notification/list`

**权限标识**: `textbook:notice:list`

**请求参数**:

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| title | String | 否 | 通知标题 |
| bizType | String | 否 | 业务类型（领书单/采购单/入库单/缺书登记/供应商通知/库存预警） |
| isRead | String | 否 | 阅读状态（0=未读,1=已读） |
| pageNum | Integer | 否 | 页码 |
| pageSize | Integer | 否 | 每页数量 |

### 18.2 查询全部通知

**请求方式**: `GET /textbook/notification/list/all`

**权限标识**: `textbook:notice:list`

### 18.3 获取未读通知数量

**请求方式**: `GET /textbook/notification/unread/count`

**权限标识**: `textbook:notice:list`

### 18.4 获取通知详情

**请求方式**: `GET /textbook/notification/{noticeId}`

**权限标识**: `textbook:notice:query`

### 18.5 标记通知已读

**请求方式**: `PUT /textbook/notification/read/{noticeId}`

**权限标识**: `textbook:notice:list`

### 18.6 批量标记已读

**请求方式**: `PUT /textbook/notification/read/batch`

**权限标识**: `textbook:notice:list`

**请求体**:
```json
[1, 2, 3]
```

### 18.7 全部标记已读

**请求方式**: `PUT /textbook/notification/read/all`

**权限标识**: `textbook:notice:list`

### 18.8 新增通知

**请求方式**: `POST /textbook/notification`

**权限标识**: `textbook:notice:add`

**角色限制**: admin, warehouse_manager

### 18.9 修改通知

**请求方式**: `PUT /textbook/notification`

**权限标识**: `textbook:notice:edit`

**角色限制**: admin, warehouse_manager

### 18.10 删除通知

**请求方式**: `DELETE /textbook/notification/{noticeIds}`

**权限标识**: `textbook:notice:remove`

**角色限制**: admin, warehouse_manager

---

## 十九、领书单管理模块（BookClaimFormController）

**接口路径前缀**: `/textbook/claimForm`

### 19.1 查询领书单列表

**请求方式**: `GET /textbook/claimForm/list`

**权限标识**: `textbook:claimForm:list`

**请求参数**:

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| noticeId | Long | 否 | 通知ID |
| formNo | String | 否 | 领书单号 |
| className | String | 否 | 班级名称 |
| status | String | 否 | 状态（0=待领取,1=部分出库,2=已出库） |
| pageNum | Integer | 否 | 页码 |
| pageSize | Integer | 否 | 每页数量 |

**响应示例**:
```json
{
  "code": 200,
  "msg": "查询成功",
  "rows": [
    {
      "formId": 1,
      "formNo": "CLAIM20240301001",
      "noticeId": 1,
      "collegeId": 1,
      "majorId": 1,
      "classId": 1,
      "className": "计算机21级1班",
      "status": "0",
      "plannedQty": 30,
      "issuedQty": 0,
      "receiverName": null,
      "issueTime": null,
      "remark": null
    }
  ],
  "total": 10
}
```

### 19.2 获取领书单详情

**请求方式**: `GET /textbook/claimForm/{formId}`

**权限标识**: `textbook:claimForm:query`

**响应示例**:
```json
{
  "code": 200,
  "msg": "查询成功",
  "data": {
    "formId": 1,
    "formNo": "CLAIM20240301001",
    "noticeId": 1,
    "collegeId": 1,
    "majorId": 1,
    "classId": 1,
    "className": "计算机21级1班",
    "status": "0",
    "plannedQty": 30,
    "issuedQty": 0,
    "receiverName": null,
    "remark": null,
    "details": [
      {
        "detailId": 1,
        "formId": 1,
        "textbookId": 1,
        "isbn": "9787302123456",
        "bookName": "Java程序设计教程",
        "author": "张三",
        "publisher": "清华大学出版社",
        "price": 59.00,
        "plannedQty": 15,
        "issuedQty": 0,
        "collegeId": 1,
        "majorId": 1,
        "classId": 1,
        "className": "计算机21级1班"
      }
    ]
  }
}
```

### 19.3 新增领书单

**请求方式**: `POST /textbook/claimForm`

**权限标识**: `textbook:claimForm:add`

**请求体**:
```json
{
  "noticeId": 1,
  "collegeId": 1,
  "majorId": 1,
  "classId": 1,
  "className": "计算机21级1班",
  "remark": "第一批领书",
  "details": [
    {
      "textbookId": 1,
      "isbn": "9787302123456",
      "bookName": "Java程序设计教程",
      "author": "张三",
      "publisher": "清华大学出版社",
      "price": 59.00,
      "plannedQty": 15,
      "collegeId": 1,
      "majorId": 1,
      "classId": 1,
      "className": "计算机21级1班"
    }
  ]
}
```

### 19.4 修改领书单

**请求方式**: `PUT /textbook/claimForm`

**权限标识**: `textbook:claimForm:edit`

**业务规则**:
- 已出库的单据不可修改

### 19.5 确认出库

**请求方式**: `PUT /textbook/claimForm/confirmOutbound`

**权限标识**: `textbook:claimForm:outbound`

**请求体**:
```json
{
  "formId": 1,
  "issuedQty": 30,
  "receiverName": "张三",
  "details": [
    {
      "detailId": 1,
      "issuedQty": 15
    },
    {
      "detailId": 2,
      "issuedQty": 15
    }
  ]
}
```

**业务说明**: 确认出库，更新库存，生成出库记录和库存流水，支持分批出库

### 19.6 删除领书单

**请求方式**: `DELETE /textbook/claimForm/{formIds}`

**权限标识**: `textbook:claimForm:remove`

**业务规则**: 已出库的单据不可删除

### 19.7 获取领书单明细

**请求方式**: `GET /textbook/claimForm/details/{formId}`

**权限标识**: `textbook:claimForm:query`

**路径参数**:

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| formId | Long | 是 | 领书单ID |

---

## 二十、库存流水模块（TbStockLogController）

**接口路径前缀**: `/textbook/stockLog`

### 20.1 查询库存流水列表

**请求方式**: `GET /textbook/stockLog/list`

**权限标识**: `textbook:inventory:query`

**请求参数**:

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| bookName | String | 否 | 教材名称 |
| bizType | String | 否 | 业务类型（in=入库,out=出库,adj=调整） |
| refBizType | String | 否 | 关联业务类型 |
| beginTime | String | 否 | 开始时间 |
| endTime | String | 否 | 结束时间 |
| pageNum | Integer | 否 | 页码 |
| pageSize | Integer | 否 | 每页数量 |

**响应示例**:
```json
{
  "code": 200,
  "msg": "查询成功",
  "rows": [
    {
      "logId": 1,
      "bookId": 1,
      "isbn": "9787302123456",
      "bookName": "Java程序设计教程",
      "bizType": "in",
      "changeNum": 50,
      "beforeStock": 106,
      "afterStock": 156,
      "operatorId": 102,
      "operatorName": "采购员小赵",
      "refBizType": "inbound",
      "refBizId": 1,
      "remark": "采购入库IN202403010001",
      "createTime": "2026-04-12 00:06:21"
    }
  ],
  "total": 8
}
```

### 20.2 根据教材ID查询库存流水

**请求方式**: `GET /textbook/stockLog/byBook/{bookId}`

**权限标识**: `textbook:inventory:query`

---

## 二十一、库存流水模块-库存流水（BookStockFlowController）

**接口路径前缀**: `/textbook/stockFlow`

> 注：此为库存流水的另一套接口，对应 textbook_stock_flow 表。

### 21.1 查询库存流水列表

**请求方式**: `GET /textbook/stockFlow/list`

**权限标识**: `textbook:stockFlow:list`

**请求参数**:

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| isbn | String | 否 | ISBN |
| businessType | String | 否 | 业务类型 |
| businessNo | String | 否 | 关联单号 |
| beginTime | String | 否 | 开始时间 |
| endTime | String | 否 | 结束时间 |
| pageNum | Integer | 否 | 页码 |
| pageSize | Integer | 否 | 每页数量 |

### 21.2 获取库存流水详情

**请求方式**: `GET /textbook/stockFlow/{flowId}`

**权限标识**: `textbook:stockFlow:list`

---

## 二十二、库存流水模块-库存流水查询（TbStockFlowController）

**接口路径前缀**: `/textbook/stock/flow`

> 注：此为库存流水的第三套接口。

### 22.1 查询库存流水列表

**请求方式**: `GET /textbook/stock/flow/list`

**权限标识**: `textbook:stock:flow:list`

### 22.2 获取库存流水详情

**请求方式**: `GET /textbook/stock/flow/info/{flowId}`

**权限标识**: `textbook:stock:flow:query`

### 22.3 根据教材ID查询库存流水

**请求方式**: `GET /textbook/stock/flow/byBook/{bookId}`

**权限标识**: `textbook:stock:flow:query`

---

## 二十三、采购单Excel导入模块（PurchaseImportController）

**接口路径前缀**: `/textbook/purchase/import`

### 23.1 导入采购单Excel

**请求方式**: `POST /textbook/purchase/import/excel`

**权限标识**: `textbook:import:excel`

**Content-Type**: multipart/form-data

**请求参数**:

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| file | File | 是 | Excel文件 |

**Excel列定义**:

| 列序号 | 列名 | 说明 |
|--------|------|------|
| 1 | ISBN | 教材ISBN编号 |
| 2 | 教材名称 | 教材名称 |
| 3 | 采购数量 | 采购数量 |
| 4 | 申请学院 | 申请学院 |
| 5 | 申请专业 | 申请专业 |
| 6 | 适用班级 | 适用班级 |
| 7 | 备注 | 备注 |

**响应示例**:
```json
{
  "code": 200,
  "msg": "导入成功",
  "data": {
    "success": 10,
    "fail": 2,
    "failList": [
      {
        "rowIndex": 3,
        "isbn": "9787302123456",
        "bookName": "Java程序设计教程",
        "errorMsg": "数量不能为空"
      }
    ]
  }
}
```

### 23.2 下载导入模板

**请求方式**: `GET /textbook/purchase/import/template`

**权限标识**: `textbook:import:excel`

**响应**: Excel文件下载

---

## 二十四、库存盘点模块（TbInventoryCheckController）

**接口路径前缀**: `/textbook/inventoryCheck`

### 24.1 查询盘点列表

**请求方式**: `GET /textbook/inventoryCheck/list`

**权限标识**: `textbook:inventoryCheck:list`

### 24.2 获取盘点详情

**请求方式**: `GET /textbook/inventoryCheck/{checkId}`

**权限标识**: `textbook:inventoryCheck:query`

### 24.3 新增盘点记录

**请求方式**: `POST /textbook/inventoryCheck`

**权限标识**: `textbook:inventoryCheck:add`

**角色限制**: admin, warehouse_manager

**请求体**:
```json
{
  "checkType": "1",
  "planStartTime": "2026-04-20 09:00:00",
  "planEndTime": "2026-04-20 17:00:00",
  "remark": "月度盘点"
}
```

### 24.4 开始盘点

**请求方式**: `PUT /textbook/inventoryCheck/start/{checkId}`

**权限标识**: `textbook:inventoryCheck:edit`

**角色限制**: admin, warehouse_manager

### 24.5 完成盘点

**请求方式**: `PUT /textbook/inventoryCheck/complete/{checkId}`

**权限标识**: `textbook:inventoryCheck:edit`

**角色限制**: admin, warehouse_manager

### 24.6 删除盘点记录

**请求方式**: `DELETE /textbook/inventoryCheck/{checkIds}`

**权限标识**: `textbook:inventoryCheck:remove`

**角色限制**: admin, warehouse_manager

### 24.7 盘点统计

**请求方式**: `GET /textbook/inventoryCheck/stats`

**权限标识**: `textbook:inventoryCheck:query`

---

## 二十五、仪表盘模块（TbDashboardController）

**接口路径前缀**: `/textbook/dashboard`

### 25.1 获取仪表盘统计数据

**请求方式**: `GET /textbook/dashboard/stats`

**权限标识**: `textbook:dashboard:view`

**响应示例**:
```json
{
  "code": 200,
  "msg": "查询成功",
  "data": {
    "totalBooks": 10,
    "totalStock": 876,
    "pendingAudit": 3,
    "pendingReceive": 5,
    "shortageCount": 3,
    "warningCount": 1,
    "pendingInbound": 2,
    "auditList": [],
    "receiveList": [],
    "shortageList": [],
    "recentLogs": []
  }
}
```

---

## 二十六、数据字典

### 26.1 审核状态（audit_status / status）

| 值 | 说明 |
|----|------|
| 0 | 待审核 |
| 1 | 已通过 |
| 2 | 已驳回 |
| 3 | 已领书 |
| 4 | 已取消 |

### 26.2 领书状态（receive_status）

| 值 | 说明 |
|----|------|
| 0 | 未领 |
| 1 | 已领 |

### 26.3 库存状态（stock_status）

| 值 | 说明 |
|----|------|
| normal | 正常 |
| warning | 预警 |
| shortage | 短缺 |

### 26.4 通知状态（status）

| 值 | 说明 |
|----|------|
| 0 | 草稿 |
| 1 | 已发布 |
| 2 | 领取中 |
| 3 | 已完成 |

### 26.5 领书单状态（status）

| 值 | 说明 |
|----|------|
| 0 | 待领取 |
| 1 | 部分出库 |
| 2 | 已出库 |

### 26.6 缺书来源（source）

| 值 | 说明 |
|----|------|
| 1 | 领书缺货 |
| 2 | 库存预警 |

### 26.7 紧急程度（urgency）

| 值 | 说明 |
|----|------|
| 0 | 普通 |
| 1 | 紧急 |
| 2 | 特急 |

### 26.8 缺书处理状态（handle_status）

| 值 | 说明 |
|----|------|
| 0 | 未处理 |
| 1 | 已纳入采购 |
| 2 | 已到货 |
| 3 | 已完成 |

### 26.9 教材类型（textbook_type）

| 值 | 说明 |
|----|------|
| 1 | 必修 |
| 2 | 选修 |
| 3 | 参考 |

### 26.10 身份类型（user_type）

| 值 | 说明 |
|----|------|
| 1 | 教师 |
| 2 | 学生 |

### 26.11 待购状态（pending_status）

| 值 | 说明 |
|----|------|
| 0 | 待采购 |
| 1 | 采购中 |
| 2 | 已到货 |
| 3 | 已入库 |

### 26.12 个人领书申请状态（tb_personal_apply_status）

| 值 | 说明 |
|----|------|
| 0 | 待审核 |
| 1 | 已通过 |
| 2 | 已驳回 |
| 3 | 已发放 |
| 4 | 已取消 |

### 26.13 采购状态（tb_purchase_status）

| 值 | 说明 |
|----|------|
| 0 | 待采购 |
| 1 | 采购中 |
| 2 | 已到货 |
| 3 | 已入库 |

### 26.14 库存流水业务类型（biz_type）

| 值 | 说明 |
|----|------|
| in | 入库 |
| out | 出库 |
| adj | 调整 |

### 26.15 库存流水关联业务类型（ref_biz_type）

| 值 | 说明 |
|----|------|
| buy | 购书 |
| inbound | 入库 |
| outbound | 出库 |
| pending | 待采购 |
| lack | 缺书 |

---

## 二十七、错误码说明

| 错误码 | 说明 |
|--------|------|
| 200 | 操作成功 |
| 401 | 用户未登录或登录已过期 |
| 403 | 没有访问权限 |
| 500 | 服务器内部错误 |

**常见业务错误提示**:
- "订单不存在" - 购书单已被删除
- "只能取消自己的订单" - 非本人操作
- "只能取消待审核的订单" - 订单状态不允许取消
- "该订单已完成领书，禁止删除" - 已完成订单不可删除
- "库存不足" - 出库时库存不够
- "通知不存在" - 领书通知已被删除
- "只能修改草稿状态的通知" - 通知状态不允许修改
- "入库记录不允许修改" - 入库记录修改接口已禁用
- "出库记录不允许手动新增" - 出库新增接口已禁用，请使用处理出库接口

---

## 二十八、接口变更记录

| 版本 | 日期 | 变更说明 |
|------|------|----------|
| v1.0 | 2026-04-12 | 初始版本，包含教材管理、购书管理、库存管理基础功能 |
| v2.0 | 2026-04-12 | 新增入库、出库、缺书管理模块 |
| v3.0 | 2026-04-12 | 新增供应商管理、领书通知、领书单模块（分批出库支持） |
| v4.0 | 2026-04-21 | 新增个人领书申请、待购教材管理、通知中心、库存盘点、仪表盘、采购Excel导入模块；修正供应商接口路径；补充缺书处理状态（4级）、待购状态（4级）；补充TbPurchase新增字段（supplierId/logisticsNo/logisticsCompany/invoiceNo/details）；补充BookNotice details字段；补充BookClaimFormDetail班级字段；补充TbSupplier userId字段；补充TbInbound purchaseId/supplierId/operatorName字段；补充TbStockLog isbn/bookName字段；标记入库修改/出库新增修改接口已禁用 |
