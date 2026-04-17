# 教材管理系统 API 接口文档

## 一、接口概述

本文档详细描述了教材采购与库存管理系统（若依框架 v3.9.0 + Spring Boot 2.x + Vue2 + ElementUI + MySQL + Redis）的所有 RESTful API 接口。系统包含教材管理、购书管理、库存管理、入库管理、出库管理、缺书管理、供应商管理、领书通知管理、领书单管理等核心模块。

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
  "rows": [],
  "total": 0
}
```

**分页响应（TableDataInfo）**:
```json
{
  "code": 200,
  "msg": "操作成功",
  "rows": [],
  "total": 100,
  "pageNum": 1,
  "pageSize": 10
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
      "price": 59.00,
      "courseName": "Java程序设计",
      "major": "软件工程",
      "grade": "本科大二",
      "textbookType": "1",
      "category": "计算机",
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

**请求体**: 同新增接口，需包含 bookId 字段

### 3.5 删除教材

**请求方式**: `DELETE /textbook/book/{bookId}`

**权限标识**: `textbook:book:remove`

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

## 四、购书管理模块（TbPurchaseController）

**接口路径前缀**: `/textbook/purchase`

### 4.1 查询购书单列表

**请求方式**: `GET /textbook/purchase/list`

**权限标识**: `textbook:purchase:list`

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
      "auditStatus": "1",
      "receiveStatus": "1",
      "fundingSource": "自费",
      "purchaseStatus": "3"
    }
  ],
  "total": 5
}
```

### 4.2 获取购书单详情

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
    "auditStatus": "1",
    "auditUserId": null,
    "auditTime": null,
    "rejectReason": null,
    "auditOpinion": null,
    "receiveStatus": "1",
    "receiveTime": null,
    "fundingSource": "自费"
  }
}
```

### 4.3 提交购书单

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

### 4.4 批量提交购书单

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

### 4.5 审核购书单

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

### 4.6 取消购书单

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

### 4.7 确认领书

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

### 4.8 删除购书单

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

### 4.9 导入购书单（教师端）

**请求方式**: `POST /textbook/buy/import`

**权限标识**: `textbook:buy:import`

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

### 4.10 下载导入模板

**请求方式**: `GET /textbook/buy/import/template`

**权限标识**: `textbook:buy:import`

**响应**: Excel文件下载

---

## 五、库存管理模块（TbInventoryController）

**接口路径前缀**: `/textbook/inventory`

### 5.1 查询库存列表

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

### 5.2 获取库存详情

**请求方式**: `GET /textbook/inventory/{stockId}`

**权限标识**: `textbook:inventory:query`

**路径参数**:

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| stockId | Long | 是 | 库存ID |

**响应示例**:
```json
{
  "code": 200,
  "msg": "查询成功",
  "data": {
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
}
```

### 5.3 获取库存预警列表

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

### 5.4 根据教材ID查询库存

**请求方式**: `GET /textbook/inventory/byBook/{bookId}`

**权限标识**: `textbook:inventory:query`

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
    "stockId": 1,
    "bookId": 1,
    "stockNum": 156,
    "stockStatus": "normal"
  }
}
```

### 5.5 导出库存列表

**请求方式**: `POST /textbook/inventory/export`

**权限标识**: `textbook:inventory:export`

**请求参数**: 同查询列表接口参数

**响应**: Excel文件下载

---

## 六、入库管理模块（TbInboundController）

**接口路径前缀**: `/textbook/inbound`

### 6.1 查询入库列表

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
      "bookId": 1,
      "bookName": "Java程序设计教程",
      "isbn": "9787302123456",
      "inNum": 50,
      "inTime": "2026-04-12 00:06:21",
      "operatorId": 100,
      "operatorName": "管理员",
      "supplier": "高等教育出版社",
      "unitPrice": 52.00,
      "totalPrice": 2600.00,
      "remark": "春季采购第一批次入库"
    }
  ],
  "total": 5
}
```

### 6.2 获取入库详情

**请求方式**: `GET /textbook/inbound/{inboundId}`

**权限标识**: `textbook:inbound:query`

**路径参数**:

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| inboundId | Long | 是 | 入库ID |

### 6.3 新增进库记录

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

### 6.4 修改入库记录

**请求方式**: `PUT /textbook/inbound`

**权限标识**: `textbook:inbound:edit`

**角色限制**: admin, warehouse_manager

**请求体**: 同新增接口，需包含 inId 字段

### 6.5 删除入库记录

**请求方式**: `DELETE /textbook/inbound/{inboundIds}`

**权限标识**: `textbook:inbound:remove`

**角色限制**: admin, warehouse_manager

**路径参数**:

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| inboundIds | Long[] | 是 | 入库ID数组 |

### 6.6 处理入库

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

**业务说明**: 此接口会执行入库操作，扣减关联的待采购数量，增加库存

### 6.7 导出入库列表

**请求方式**: `POST /textbook/inbound/export`

**权限标识**: `textbook:inbound:export`

**响应**: Excel文件下载

---

## 七、出库管理模块（TbOutboundController）

**接口路径前缀**: `/textbook/outbound`

### 7.1 查询出库列表

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

### 7.2 获取出库详情

**请求方式**: `GET /textbook/outbound/{outboundId}`

**权限标识**: `textbook:outbound:query`

### 7.3 新增出库记录

**请求方式**: `POST /textbook/outbound`

**权限标识**: `textbook:outbound:add`

**角色限制**: admin, warehouse_manager

**请求体**:
```json
{
  "buyId": 1,
  "bookId": 1,
  "outNum": 3,
  "receiveId": 101,
  "userName": "张明远",
  "deptName": "计算机科学与技术学院",
  "remark": "正常领书发放"
}
```

### 7.4 修改出库记录

**请求方式**: `PUT /textbook/outbound`

**权限标识**: `textbook:outbound:edit`

**角色限制**: admin, warehouse_manager

### 7.5 删除出库记录

**请求方式**: `DELETE /textbook/outbound/{outboundIds}`

**权限标识**: `textbook:outbound:remove`

**角色限制**: admin, warehouse_manager

### 7.6 处理出库

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

### 7.7 根据采购单ID查询出库记录

**请求方式**: `GET /textbook/outbound/byPurchase/{purchaseId}`

**权限标识**: `textbook:outbound:query`

### 7.8 导出出库列表

**请求方式**: `POST /textbook/outbound/export`

**权限标识**: `textbook:outbound:export`

---

## 八、缺书管理模块（TbShortageController）

**接口路径前缀**: `/textbook/shortage`

### 8.1 查询缺书列表

**请求方式**: `GET /textbook/shortage/list`

**权限标识**: `textbook:shortage:list`

**请求参数**:

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| bookName | String | 否 | 教材名称 |
| isbn | String | 否 | ISBN |
| urgency | String | 否 | 紧急程度（0=普通,1=紧急） |
| handleStatus | String | 否 | 处理状态（0=待采购,1=已采购） |
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
      "sourceId": 102
    }
  ],
  "total": 3
}
```

### 8.2 获取缺书详情

**请求方式**: `GET /textbook/shortage/{shortageId}`

**权限标识**: `textbook:shortage:query`

### 8.3 新增缺书登记

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

### 8.4 修改缺书登记

**请求方式**: `PUT /textbook/shortage`

**权限标识**: `textbook:shortage:edit`

**角色限制**: admin, warehouse_manager

### 8.5 删除缺书登记

**请求方式**: `DELETE /textbook/shortage/{shortageIds}`

**权限标识**: `textbook:shortage:remove`

**角色限制**: admin, warehouse_manager

### 8.6 处理缺书

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
| status | String | 是 | 处理状态（0=待采购,1=已采购） |

### 8.7 根据教材ID查询缺书记录

**请求方式**: `GET /textbook/shortage/byBook/{bookId}`

**权限标识**: `textbook:shortage:query`

### 8.8 批量转采购（ISBN聚合）

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

### 8.9 导出缺书列表

**请求方式**: `POST /textbook/shortage/export`

**权限标识**: `textbook:shortage:export`

---

## 九、供应商管理模块（TbSupplierController）

**接口路径前缀**: `/textbook/supplier`

### 9.1 查询供应商列表

**请求方式**: `GET /textbook/supplier/list`

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
      "status": "0"
    }
  ],
  "total": 5
}
```

### 9.2 获取供应商详情

**请求方式**: `GET /textbook/supplier/{supplierId}`

**权限标识**: `textbook:supplier:query`

### 9.3 新增供应商

**请求方式**: `POST /textbook/supplier`

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

### 9.4 修改供应商

**请求方式**: `PUT /textbook/supplier`

**权限标识**: `textbook:supplier:edit`

**角色限制**: admin, warehouse_manager

### 9.5 删除供应商

**请求方式**: `DELETE /textbook/supplier/{supplierIds}`

**权限标识**: `textbook:supplier:remove`

**角色限制**: admin, warehouse_manager

### 9.6 获取供应商下拉选项

**请求方式**: `GET /textbook/supplier/options`

**业务说明**: 获取所有状态为正常的供应商列表，用于下拉选择

### 9.7 供应商查询自有采购单

**请求方式**: `GET /textbook/supplier/purchase/list`

**权限标识**: `textbook:supplier:purchase:list`

**业务说明**: 供应商用户查询属于自己的采购订单列表

**请求参数**:

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| auditStatus | String | 否 | 审核状态 |
| purchaseStatus | String | 否 | 采购状态 |
| pageNum | Integer | 否 | 页码 |
| pageSize | Integer | 否 | 每页数量 |

### 9.8 供应商确认发货

**请求方式**: `PUT /textbook/supplier/purchase/ship/{purchaseId}`

**权限标识**: `textbook:supplier:ship`

**业务说明**: 供应商确认发货，更新采购单状态

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

## 十、领书通知管理模块（BookNoticeController）

**接口路径前缀**: `/textbook/notice`

### 10.1 查询领书通知列表

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
      "remark": "请各班班长按时领取"
    }
  ],
  "total": 1
}
```

### 10.2 获取领书通知详情

**请求方式**: `GET /textbook/notice/{noticeId}`

**权限标识**: `textbook:notice:query`

### 10.3 新增领书通知

**请求方式**: `POST /textbook/notice`

**权限标识**: `textbook:notice:add`

**请求体**:
```json
{
  "semester": "2024春季",
  "pickupStart": "2024-03-01 09:00:00",
  "pickupEnd": "2024-03-15 17:00:00",
  "pickupLocation": "图书馆一层教材科",
  "remark": "请各班班长按时领取"
}
```

### 10.4 修改领书通知

**请求方式**: `PUT /textbook/notice`

**权限标识**: `textbook:notice:edit`

**业务规则**:
- 已发布的通知不可修改
- 已完成的通知不可修改

### 10.5 发布领书通知

**请求方式**: `PUT /textbook/notice/publish/{noticeId}`

**权限标识**: `textbook:notice:publish`

**路径参数**:

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| noticeId | Long | 是 | 通知ID |

**业务说明**: 发布通知后，状态变为"已发布"，可开始领取

### 10.6 删除领书通知

**请求方式**: `DELETE /textbook/notice/{noticeIds}`

**权限标识**: `textbook:notice:remove`

**业务规则**: 已发布的通知不可删除

### 10.7 获取通知关联的领书单

**请求方式**: `GET /textbook/notice/claimForms/{noticeId}`

**权限标识**: `textbook:notice:query`

**路径参数**:

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| noticeId | Long | 是 | 通知ID |

**业务说明**: 根据通知生成或获取对应的领书单列表

---

## 十一、领书单管理模块（BookClaimFormController）

**接口路径前缀**: `/textbook/claimForm`

### 11.1 查询领书单列表

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

### 11.2 获取领书单详情

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
        "issuedQty": 0
      },
      {
        "detailId": 2,
        "formId": 1,
        "textbookId": 2,
        "isbn": "9787302123463",
        "bookName": "Python数据分析实战",
        "author": "李四",
        "publisher": "清华大学出版社",
        "price": 45.00,
        "plannedQty": 15,
        "issuedQty": 0
      }
    ]
  }
}
```

### 11.3 新增领书单

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
      "plannedQty": 15
    }
  ]
}
```

### 11.4 修改领书单

**请求方式**: `PUT /textbook/claimForm`

**权限标识**: `textbook:claimForm:edit`

**业务规则**:
- 已出库的单据不可修改

### 11.5 确认出库

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

**业务说明**: 确认出库，更新库存，生成出库记录

### 11.6 删除领书单

**请求方式**: `DELETE /textbook/claimForm/{formIds}`

**权限标识**: `textbook:claimForm:remove`

**业务规则**: 已出库的单据不可删除

### 11.7 获取领书单明细

**请求方式**: `GET /textbook/claimForm/details/{formId}`

**权限标识**: `textbook:claimForm:query`

**路径参数**:

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| formId | Long | 是 | 领书单ID |

---

## 十二、库存流水模块

**接口路径前缀**: `/textbook/stockLog`

### 12.1 查询库存流水列表

**请求方式**: `GET /textbook/stockLog/list`

**权限标识**: `textbook:stockLog:list`

**请求参数**:

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| bookName | String | 否 | 教材名称 |
| bizType | String | 否 | 业务类型（in=入库,out=出库） |
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

### 12.2 根据教材ID查询库存流水

**请求方式**: `GET /textbook/stockLog/byBook/{bookId}`

**权限标识**: `textbook:stockLog:query`

---

## 十三、数据字典

### 13.1 审核状态（audit_status）

| 值 | 说明 |
|----|------|
| 0 | 待审核 |
| 1 | 已通过 |
| 2 | 已驳回 |
| 3 | 已领书 |
| 4 | 已取消 |

### 13.2 领书状态（receive_status）

| 值 | 说明 |
|----|------|
| 0 | 未领 |
| 1 | 已领 |

### 13.3 库存状态（stock_status）

| 值 | 说明 |
|----|------|
| normal | 正常 |
| warning | 预警 |
| shortage | 短缺 |

### 13.4 通知状态（status）

| 值 | 说明 |
|----|------|
| 0 | 草稿 |
| 1 | 已发布 |
| 2 | 领取中 |
| 3 | 已完成 |

### 13.5 领书单状态（status）

| 值 | 说明 |
|----|------|
| 0 | 待领取 |
| 1 | 部分出库 |
| 2 | 已出库 |

### 13.6 缺书来源（source）

| 值 | 说明 |
|----|------|
| 1 | 领书缺货 |
| 2 | 库存预警 |

### 13.7 紧急程度（urgency）

| 值 | 说明 |
|----|------|
| 0 | 普通 |
| 1 | 紧急 |

### 13.8 处理状态（handle_status）

| 值 | 说明 |
|----|------|
| 0 | 待采购 |
| 1 | 已采购 |

### 13.9 教材类型（textbook_type）

| 值 | 说明 |
|----|------|
| 1 | 必修 |
| 2 | 选修 |
| 3 | 参考 |

### 13.10 身份类型（user_type）

| 值 | 说明 |
|----|------|
| 1 | 教师 |
| 2 | 学生 |

---

## 十四、错误码说明

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

---

## 十五、接口变更记录

| 版本 | 日期 | 变更说明 |
|------|------|----------|
| v1.0 | 2026-04-12 | 初始版本，包含教材管理、购书管理、库存管理基础功能 |
| v2.0 | 2026-04-12 | 新增入库、出库、缺书管理模块 |
| v3.0 | 2026-04-12 | 新增供应商管理、领书通知、领书单模块（分批出库支持） |
