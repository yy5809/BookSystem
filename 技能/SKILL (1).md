---
name: api
description: 教材采购与库存管理系统RESTful API设计技能。用于设计和规范系统接口，遵循RuoYi-Vue 3.9.0框架的Controller规范，包括采购管理、入库管理、班级领书、个人领书、缺书管理、库存管理等全部业务接口。涵盖请求参数、响应格式、权限注解、接口文档规范。
---

# 教材采购与库存管理系统 — RESTful API设计技能

## 一、API设计规范

### 1.1 技术栈

- **框架**：SpringBoot 2.x + RuoYi-Vue 3.9.0
- **接口风格**：RESTful（部分遵循RuoYi约定）
- **权限控制**：`@PreAuthorize` 注解
- **参数校验**：`@Validated` + JSR-303 注解
- **响应格式**：RuoYi统一响应体 `AjaxResult` / `TableDataInfo`

### 1.2 URL规范

```
基础路径：/api/{模块名}

示例：
/api/textbook        教材信息
/api/purchase        采购管理
/api/warehouse       入库管理
/api/claim           班级领书
/api/personal        个人领书
/api/shortage        缺书管理
/api/stock           库存管理
/api/notice          通知管理
/api/supplier        供应商管理
```

### 1.3 HTTP方法规范

| 方法 | 用途 | 示例 |
|------|------|------|
| GET | 查询 | `GET /api/textbook/{id}` |
| POST | 新增/复杂操作 | `POST /api/purchase/import` |
| PUT | 修改 | `PUT /api/textbook` |
| DELETE | 删除 | `DELETE /api/textbook/{ids}` |

### 1.4 统一响应格式

```json
// 普通响应
{
    "code": 200,
    "msg": "操作成功",
    "data": { ... }
}

// 分页响应
{
    "code": 200,
    "msg": "查询成功",
    "total": 100,
    "rows": [ ... ]
}

// 错误响应
{
    "code": 500,
    "msg": "操作失败：库存不足"
}
```

### 1.5 RuoYi权限字符串规范

```
格式：module:operation

示例：
textbook:list      教材列表
textbook:query     教材查询
textbook:add       新增教材
textbook:edit      编辑教材
textbook:remove    删除教材
textbook:export    导出教材
textbook:import    导入教材
purchase:list      采购单列表
purchase:add       新增采购单
purchase:edit      编辑采购单
purchase:remove    删除采购单
claim:list         领书单列表
claim:issue        确认出库
personal:list      个人领书列表
personal:apply     提交申请
personal:cancel    取消申请
personal:audit     审核申请
shortage:list      缺书列表
shortage:add       登记缺书
stock:list         库存列表
stock:flow         库存流水
```

---

## 二、完整接口设计

### 2.1 教材信息管理（TextbookController）

```java
@RestController
@RequestMapping("/api/textbook")
public class TextbookController extends BaseController {

    /** 查询教材列表（分页） */
    @PreAuthorize("@ss.hasPermi('textbook:list')")
    @GetMapping("/list")
    public TableDataInfo list(TextbookQueryDTO query) {
        startPage();
        List<TextbookVO> list = textbookService.selectList(query);
        return getDataTable(list);
    }

    /** 查询教材详情 */
    @PreAuthorize("@ss.hasPermi('textbook:query')")
    @GetMapping("/{id}")
    public AjaxResult getInfo(@PathVariable Long id) {
        return success(textbookService.selectById(id));
    }

    /** 新增教材 */
    @PreAuthorize("@ss.hasPermi('textbook:add')")
    @Log(title = "教材管理", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@Validated @RequestBody TextbookDTO dto) {
        return toAjax(textbookService.insert(dto));
    }

    /** 修改教材（库存字段禁止修改） */
    @PreAuthorize("@ss.hasPermi('textbook:edit')")
    @Log(title = "教材管理", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@Validated @RequestBody TextbookDTO dto) {
        return toAjax(textbookService.update(dto));
    }

    /** 删除教材（逻辑删除） */
    @PreAuthorize("@ss.hasPermi('textbook:remove')")
    @Log(title = "教材管理", businessType = BusinessType.DELETE)
    @DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids) {
        return toAjax(textbookService.deleteByIds(ids));
    }

    /** 导出教材列表 */
    @PreAuthorize("@ss.hasPermi('textbook:export')")
    @Log(title = "教材管理", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, TextbookQueryDTO query) {
        List<TextbookVO> list = textbookService.selectList(query);
        ExcelUtil<TextbookVO> util = new ExcelUtil<>(TextbookVO.class);
        util.exportExcel(response, list, "教材信息");
    }

    /** 下载导入模板 */
    @PostMapping("/importTemplate")
    public void importTemplate(HttpServletResponse response) {
        ExcelUtil<TextbookImportDTO> util = new ExcelUtil<>(TextbookImportDTO.class);
        util.importTemplateExcel(response, "教材导入模板");
    }

    /** 导入教材信息 */
    @PreAuthorize("@ss.hasPermi('textbook:import')")
    @Log(title = "教材管理", businessType = BusinessType.IMPORT)
    @PostMapping("/importData")
    public AjaxResult importData(MultipartFile file, boolean updateSupport) {
        // ... 导入逻辑
    }
}
```

**请求参数示例：**

```json
// GET /api/textbook/list?isbn=9787111&bookName=Java&status=0&pageNum=1&pageSize=10

// POST /api/textbook（新增教材）
{
    "isbn": "9787111544937",
    "bookName": "Java核心技术",
    "author": "Cay S. Horstmann",
    "publisher": "机械工业出版社",
    "edition": "第11版",
    "publishDate": "2020-01-01",
    "price": 119.00,
    "alertThreshold": 10,
    "bookType": "0",
    "courseName": "Java程序设计"
}
```

---

### 2.2 采购管理（PurchaseController）

```java
@RestController
@RequestMapping("/api/purchase")
public class PurchaseController extends BaseController {

    /** 查询采购单列表 */
    @PreAuthorize("@ss.hasPermi('purchase:list')")
    @GetMapping("/list")
    public TableDataInfo list(PurchaseOrderQueryDTO query) {
        startPage();
        List<PurchaseOrderVO> list = purchaseService.selectList(query);
        return getDataTable(list);
    }

    /** 查询采购单详情（含明细） */
    @PreAuthorize("@ss.hasPermi('purchase:query')")
    @GetMapping("/{id}")
    public AjaxResult getInfo(@PathVariable Long id) {
        return success(purchaseService.selectDetailById(id));
    }

    /** 手动创建采购单 */
    @PreAuthorize("@ss.hasPermi('purchase:add')")
    @Log(title = "采购管理", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@Validated @RequestBody PurchaseOrderDTO dto) {
        return success(purchaseService.createOrder(dto));
    }

    /** Excel导入生成采购单（核心接口） */
    @PreAuthorize("@ss.hasPermi('purchase:import')")
    @Log(title = "采购管理", businessType = BusinessType.IMPORT)
    @PostMapping("/import")
    public AjaxResult importExcel(@RequestParam("file") MultipartFile file) {
        // 返回校验结果（成功数/失败数/失败原因），前端预览
        ImportResult result = purchaseService.importExcel(file);
        return success(result);
    }

    /** 确认导入（用户预览后确认） */
    @PreAuthorize("@ss.hasPermi('purchase:import')")
    @Log(title = "采购管理", businessType = BusinessType.INSERT)
    @PostMapping("/import/confirm")
    public AjaxResult confirmImport(@RequestBody ImportConfirmDTO dto) {
        return success(purchaseService.confirmImport(dto));
    }

    /** 修改采购单（已到货/已入库禁止修改） */
    @PreAuthorize("@ss.hasPermi('purchase:edit')")
    @Log(title = "采购管理", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@Validated @RequestBody PurchaseOrderDTO dto) {
        return toAjax(purchaseService.updateOrder(dto));
    }

    /** 删除采购单（已到货/已入库禁止删除） */
    @PreAuthorize("@ss.hasPermi('purchase:remove')")
    @Log(title = "采购管理", businessType = BusinessType.DELETE)
    @DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids) {
        return toAjax(purchaseService.deleteByIds(ids));
    }

    /** 更新采购单状态 */
    @PreAuthorize("@ss.hasPermi('purchase:edit')")
    @Log(title = "采购管理", businessType = BusinessType.UPDATE)
    @PutMapping("/status")
    public AjaxResult updateStatus(@RequestBody StatusUpdateDTO dto) {
        return toAjax(purchaseService.updateStatus(dto.getOrderId(), dto.getNewStatus()));
    }

    /** 供应商确认发货 */
    @PreAuthorize("@ss.hasRole('supplier')")
    @Log(title = "采购管理", businessType = BusinessType.UPDATE)
    @PutMapping("/ship/{id}")
    public AjaxResult confirmShip(@PathVariable Long id,
                                   @RequestParam(required = false) String trackingNo,
                                   @RequestParam(required = false) String expressCompany) {
        return toAjax(purchaseService.confirmShip(id, trackingNo, expressCompany));
    }

    /** 确认到货 */
    @PreAuthorize("@ss.hasPermi('purchase:edit')")
    @Log(title = "采购管理", businessType = BusinessType.UPDATE)
    @PutMapping("/receive/{id}")
    public AjaxResult confirmReceive(@PathVariable Long id) {
        return toAjax(purchaseService.confirmReceive(id));
    }

    /** 下载采购导入模板 */
    @PostMapping("/importTemplate")
    public void importTemplate(HttpServletResponse response) {
        ExcelUtil<PurchaseImportDTO> util = new ExcelUtil<>(PurchaseImportDTO.class);
        util.importTemplateExcel(response, "采购导入模板");
    }
}
```

**Excel导入响应示例：**

```json
{
    "code": 200,
    "msg": "校验完成，请确认导入",
    "data": {
        "totalCount": 100,
        "successCount": 95,
        "failCount": 5,
        "batchId": "batch_20260417_001",
        "errorList": [
            { "rowNum": 3, "isbn": "1234567890", "reason": "ISBN在系统中不存在" },
            { "rowNum": 15, "isbn": "9787111544937", "reason": "采购数量必须为正整数" },
            { "rowNum": 28, "isbn": "9787040123456", "reason": "申请学院[计算机学院]不在字典中" },
            { "rowNum": 67, "isbn": "9787302123456", "reason": "ISBN为空" },
            { "rowNum": 89, "isbn": "9787111123456", "reason": "该文件已导入过" }
        ]
    }
}
```

---

### 2.3 入库管理（WarehouseController）

```java
@RestController
@RequestMapping("/api/warehouse")
public class WarehouseController extends BaseController {

    /** 查询待入库的采购单列表 */
    @PreAuthorize("@ss.hasPermi('warehouse:list')")
    @GetMapping("/pending")
    public TableDataInfo pendingList(PurchaseOrderQueryDTO query) {
        query.setStatus("2"); // 已到货
        startPage();
        List<PurchaseOrderVO> list = purchaseService.selectList(query);
        return getDataTable(list);
    }

    /** 确认入库（核心接口 - 事务操作） */
    @PreAuthorize("@ss.hasPermi('warehouse:confirm')")
    @Log(title = "入库管理", businessType = BusinessType.UPDATE)
    @PostMapping("/confirm/{orderId}")
    public AjaxResult confirmInbound(@PathVariable Long orderId,
                                      @Validated @RequestBody InboundConfirmDTO dto) {
        // 事务：增加库存 + 生成流水 + 更新采购单状态 + 更新缺书单 + 发送通知
        warehouseService.confirmInbound(orderId, dto);
        return success();
    }
}
```

**入库确认请求参数：**

```json
{
    "orderId": 1,
    "details": [
        { "detailId": 1, "actualQty": 100, "remark": "数量正确" },
        { "detailId": 2, "actualQty": 48, "remark": "破损2本，实收48" }
    ]
}
```

---

### 2.4 班级领书管理（ClaimController）

```java
@RestController
@RequestMapping("/api/claim")
public class ClaimController extends BaseController {

    /** 查询领书通知列表 */
    @PreAuthorize("@ss.hasPermi('claim:list')")
    @GetMapping("/notice/list")
    public TableDataInfo noticeList(NoticeQueryDTO query) {
        startPage();
        List<NoticeVO> list = claimService.selectNoticeList(query);
        return getDataTable(list);
    }

    /** 创建/编辑领书通知（草稿） */
    @PreAuthorize("@ss.hasPermi('claim:add')")
    @Log(title = "领书管理", businessType = BusinessType.INSERT)
    @PostMapping("/notice")
    public AjaxResult createNotice(@Validated @RequestBody NoticeDTO dto) {
        return success(claimService.createNotice(dto));
    }

    /** 发布领书通知（校验库存 + 自动生成领书单） */
    @PreAuthorize("@ss.hasPermi('claim:publish')")
    @Log(title = "领书管理", businessType = BusinessType.UPDATE)
    @PutMapping("/notice/publish/{id}")
    public AjaxResult publishNotice(@PathVariable Long id) {
        return toAjax(claimService.publishNotice(id));
    }

    /** 查询领书通知下的领书单列表 */
    @PreAuthorize("@ss.hasPermi('claim:list')")
    @GetMapping("/form/list")
    public TableDataInfo formList(@RequestParam Long noticeId) {
        startPage();
        List<ClaimFormVO> list = claimService.selectFormListByNoticeId(noticeId);
        return getDataTable(list);
    }

    /** 确认出库（核心接口 - 事务操作） */
    @PreAuthorize("@ss.hasPermi('claim:issue')")
    @Log(title = "领书管理", businessType = BusinessType.UPDATE)
    @PostMapping("/form/issue")
    public AjaxResult confirmIssue(@Validated @RequestBody IssueConfirmDTO dto) {
        // 事务：扣减库存 + 生成流水 + 更新领书单状态 + 更新通知进度
        claimService.confirmIssue(dto);
        return success();
    }

    /** 打印领书单 */
    @PreAuthorize("@ss.hasPermi('claim:list')")
    @GetMapping("/form/print/{formId}")
    public void printForm(@PathVariable Long formId, HttpServletResponse response) {
        // 生成PDF或HTML打印页面
        claimService.printForm(formId, response);
    }
}
```

**发布领书通知请求参数：**

```json
{
    "semester": "2025-2026-2",
    "pickupStart": "2026-02-20 08:00:00",
    "pickupEnd": "2026-02-25 17:00:00",
    "pickupLocation": "图书馆一楼书库",
    "details": [
        {
            "classId": 1,
            "className": "计科2301",
            "collegeId": 1,
            "collegeName": "计算机学院",
            "majorId": 1,
            "majorName": "计算机科学与技术",
            "textbooks": [
                { "textbookId": 1, "isbn": "9787111544937", "qty": 50 },
                { "textbookId": 2, "isbn": "9787040123456", "qty": 50 }
            ]
        }
    ]
}
```

**确认出库请求参数：**

```json
{
    "formId": 1,
    "details": [
        { "detailId": 1, "issuedQty": 50 },
        { "detailId": 2, "issuedQty": 48 }
    ],
    "receiverName": "张三"
}
```

---

### 2.5 个人领书管理（PersonalApplyController）

```java
@RestController
@RequestMapping("/api/personal")
public class PersonalApplyController extends BaseController {

    /** 教师查询本人领书申请列表 */
    @PreAuthorize("@ss.hasPermi('personal:list')")
    @GetMapping("/list")
    public TableDataInfo list(PersonalApplyQueryDTO query) {
        // 强制过滤当前用户数据
        query.setTeacherId(SecurityUtils.getUserId());
        startPage();
        List<PersonalApplyVO> list = personalService.selectList(query);
        return getDataTable(list);
    }

    /** 教师提交领书申请 */
    @PreAuthorize("@ss.hasPermi('personal:apply')")
    @Log(title = "个人领书", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult apply(@Validated @RequestBody PersonalApplyDTO dto) {
        dto.setTeacherId(SecurityUtils.getUserId());
        return success(personalService.submitApply(dto));
    }

    /** 教师取消领书申请（仅待审核状态） */
    @PreAuthorize("@ss.hasPermi('personal:cancel')")
    @Log(title = "个人领书", businessType = BusinessType.UPDATE)
    @PutMapping("/cancel/{id}")
    public AjaxResult cancel(@PathVariable Long id) {
        return toAjax(personalService.cancelApply(id));
    }

    /** 库管员查询所有领书申请 */
    @PreAuthorize("@ss.hasPermi('personal:audit')")
    @GetMapping("/audit/list")
    public TableDataInfo auditList(PersonalApplyQueryDTO query) {
        startPage();
        List<PersonalApplyVO> list = personalService.selectAuditList(query);
        return getDataTable(list);
    }

    /** 库管员审核领书申请 */
    @PreAuthorize("@ss.hasPermi('personal:audit')")
    @Log(title = "个人领书", businessType = BusinessType.UPDATE)
    @PutMapping("/audit")
    public AjaxResult audit(@Validated @RequestBody AuditDTO dto) {
        return toAjax(personalService.auditApply(dto));
    }

    /** 库管员确认出库 */
    @PreAuthorize("@ss.hasPermi('personal:audit')")
    @Log(title = "个人领书", businessType = BusinessType.UPDATE)
    @PostMapping("/issue/{id}")
    public AjaxResult issue(@PathVariable Long id) {
        return toAjax(personalService.confirmIssue(id));
    }
}
```

---

### 2.6 缺书管理（ShortageController）

```java
@RestController
@RequestMapping("/api/shortage")
public class ShortageController extends BaseController {

    /** 查询缺书列表 */
    @PreAuthorize("@ss.hasPermi('shortage:list')")
    @GetMapping("/list")
    public TableDataInfo list(ShortageQueryDTO query) {
        startPage();
        List<ShortageVO> list = shortageService.selectList(query);
        return getDataTable(list);
    }

    /** 登记缺书（教师和库管员都可以） */
    @PreAuthorize("@ss.hasAnyPermi('shortage:add')")
    @Log(title = "缺书管理", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@Validated @RequestBody ShortageDTO dto) {
        return success(shortageService.register(dto));
    }

    /** 一键转采购单 */
    @PreAuthorize("@ss.hasPermi('shortage:add')")
    @Log(title = "缺书管理", businessType = BusinessType.INSERT)
    @PostMapping("/convert/{id}")
    public AjaxResult convertToPurchase(@PathVariable Long id) {
        return success(shortageService.convertToPurchase(id));
    }
}
```

---

### 2.7 库存管理（StockController）

```java
@RestController
@RequestMapping("/api/stock")
public class StockController extends BaseController {

    /** 查询库存列表 */
    @PreAuthorize("@ss.hasPermi('stock:list')")
    @GetMapping("/list")
    public TableDataInfo list(StockQueryDTO query) {
        startPage();
        List<StockVO> list = stockService.selectList(query);
        return getDataTable(list);
    }

    /** 查询库存预警列表 */
    @PreAuthorize("@ss.hasPermi('stock:list')")
    @GetMapping("/alert")
    public TableDataInfo alertList() {
        startPage();
        List<StockVO> list = stockService.selectAlertList();
        return getDataTable(list);
    }

    /** 查询库存流水（只读） */
    @PreAuthorize("@ss.hasPermi('stock:flow')")
    @GetMapping("/flow/list")
    public TableDataInfo flowList(StockFlowQueryDTO query) {
        startPage();
        List<StockFlowVO> list = stockService.selectFlowList(query);
        return getDataTable(list);
    }
}
```

---

### 2.8 通知管理（NotificationController）

```java
@RestController
@RequestMapping("/api/notification")
public class NotificationController extends BaseController {

    /** 查询当前用户的通知列表 */
    @GetMapping("/list")
    public TableDataInfo list(NotificationQueryDTO query) {
        query.setUserId(SecurityUtils.getUserId());
        startPage();
        List<NotificationVO> list = notificationService.selectList(query);
        return getDataTable(list);
    }

    /** 获取未读通知数量 */
    @GetMapping("/unreadCount")
    public AjaxResult unreadCount() {
        Long userId = SecurityUtils.getUserId();
        int count = notificationService.countUnread(userId);
        return success(count);
    }

    /** 标记通知为已读 */
    @PutMapping("/read/{id}")
    public AjaxResult markRead(@PathVariable Long id) {
        return toAjax(notificationService.markRead(id));
    }

    /** 全部标记已读 */
    @PutMapping("/readAll")
    public AjaxResult markAllRead() {
        return toAjax(notificationService.markAllRead(SecurityUtils.getUserId()));
    }
}
```

---

## 三、DTO设计规范

### 3.1 命名规范

| 类型 | 后缀 | 用途 |
|------|------|------|
| QueryDTO | `QueryDTO` | 查询参数（GET请求） |
| DTO | `DTO` | 新增/修改参数（POST/PUT请求） |
| VO | `VO` | 响应数据 |

### 3.2 参数校验注解

```java
public class PersonalApplyDTO {

    @NotNull(message = "教材ID不能为空")
    private Long textbookId;

    @NotBlank(message = "ISBN不能为空")
    @Pattern(regexp = "^(\\d{10}|\\d{13})$", message = "ISBN格式不正确，必须为10位或13位数字")
    private String isbn;

    @NotNull(message = "申请数量不能为空")
    @Min(value = 1, message = "申请数量最少为1")
    @Max(value = 9999, message = "申请数量最大为9999")
    private Integer applyQty;

    @NotBlank(message = "申请用途不能为空")
    @Size(max = 500, message = "申请用途不能超过500字")
    private String purpose;
}
```

### 3.3 采购导入DTO（Excel列映射）

```java
public class PurchaseImportDTO {

    /** 第1列：ISBN */
    @ExcelProperty(index = 0)
    @NotBlank(message = "ISBN不能为空")
    private String isbn;

    /** 第2列：教材名称 */
    @ExcelProperty(index = 1)
    @NotBlank(message = "教材名称不能为空")
    private String bookName;

    /** 第3列：采购数量 */
    @ExcelProperty(index = 2)
    @NotNull(message = "采购数量不能为空")
    @Min(value = 1, message = "采购数量必须为正整数")
    @Max(value = 9999, message = "采购数量不能超过9999")
    private Integer purchaseQty;

    /** 第4列：申请学院 */
    @ExcelProperty(index = 3)
    @NotBlank(message = "申请学院不能为空")
    private String collegeName;

    /** 第5列：申请专业 */
    @ExcelProperty(index = 4)
    @NotBlank(message = "申请专业不能为空")
    private String majorName;

    /** 第6列：适用班级（可选） */
    @ExcelProperty(index = 5)
    private String className;

    /** 第7列：备注（可选） */
    @ExcelProperty(index = 6)
    private String remark;
}
```

---

## 四、接口权限矩阵

| 接口 | 超级管理员 | 库管员 | 教师 | 供应商 |
|------|-----------|--------|------|--------|
| 教材信息 CRUD | ✅ | ✅ | 仅查看 | ❌ |
| 采购单管理 | ✅ | ✅ | ❌ | 仅查看本人 |
| 采购Excel导入 | ✅ | ✅ | ❌ | ❌ |
| 供应商确认发货 | ❌ | ❌ | ❌ | ✅ |
| 入库确认 | ✅ | ✅ | ❌ | ❌ |
| 领书通知管理 | ✅ | ✅ | ❌ | ❌ |
| 出库确认 | ✅ | ✅ | ❌ | ❌ |
| 个人领书申请 | ❌ | ❌ | ✅ | ❌ |
| 个人领书审核 | ✅ | ✅ | ❌ | ❌ |
| 缺书登记 | ✅ | ✅ | ✅ | ❌ |
| 缺书转采购 | ✅ | ✅ | ❌ | ❌ |
| 库存查询 | ✅ | ✅ | 仅查看 | ❌ |
| 库存流水 | ✅ | ✅ | ❌ | ❌ |
| 通知查看 | ✅ | ✅ | ✅ | ✅ |

---

## 五、错误码设计

| 错误码 | 说明 |
|--------|------|
| 200 | 操作成功 |
| 401 | 未登录或Token过期 |
| 403 | 无权限 |
| 500 | 服务器内部错误 |
| 1001 | ISBN已存在 |
| 1002 | ISBN不存在 |
| 1003 | ISBN格式不正确 |
| 1004 | 库存不足 |
| 1005 | 采购单状态不允许此操作 |
| 1006 | 文件已导入过 |
| 1007 | 文件格式不正确 |
| 1008 | 文件超过大小限制 |
| 1009 | 领书申请状态不允许此操作 |
| 1010 | 学院/专业不在字典中 |
