---
name: bugfix
description: 教材采购与库存管理系统Bug修复技能。用于定位、分析和修复系统中的Bug，涵盖业务逻辑错误、数据不一致、事务失败、权限越权、并发超卖、前端显示异常、Excel导入异常等常见问题。基于系统设计文档中的业务规则、数据模型、角色权限和状态流转进行Bug诊断和修复。适用于 RuoYi-Vue 3.9.0 + SpringBoot 2.x + Vue2 + ElementUI + MySQL + Redis 技术栈。
---

# 教材采购与库存管理系统 — Bug修复技能

## 一、Bug修复概述

### 1.1 系统信息

- **系统名称**：教材采购与库存管理系统
- **技术栈**：RuoYi-Vue 3.9.0、SpringBoot 2.x、Vue2、ElementUI、MySQL、Redis
- **系统角色**：超级管理员、教师、库管员、供应商
- **核心业务**：教材采购（Excel导入）、入库管理、班级领书、个人领书、缺书管理、库存管理

### 1.2 Bug修复原则

1. **先定位后修复**：充分理解Bug现象和根因，不要盲目修改
2. **最小改动原则**：只修改修复Bug所需的最小代码范围
3. **不引入新Bug**：修复后必须验证相关功能不受影响
4. **事务一致性**：涉及数据修改的修复必须保证事务完整性
5. **回归测试**：修复后必须验证该模块的核心流程

---

## 二、常见Bug分类与修复指南

### 2.1 业务逻辑Bug

#### BUG-001：采购Excel导入后库存被修改

**现象**：导入教务处Excel生成采购单后，教材库存数量发生变化。

**根因**：导入Service中误调用了库存更新方法，或SQL中包含了UPDATE stock语句。

**定位方法**：
```bash
# 搜索导入相关代码
grep -rn 'importExcel\|importPurchase' src/
# 检查是否有stock相关操作
grep -rn 'stock' src/main/java/**/purchase/
```

**修复方案**：
```java
// ❌ 错误：导入时修改了库存
public void importPurchase(List<PurchaseImportDTO> list) {
    for (PurchaseImportDTO dto : list) {
        // ... 生成采购单
        textbookMapper.updateStock(dto.getIsbn(), dto.getQty()); // 错误！
    }
}

// ✅ 正确：导入只生成采购单，不修改库存
@Transactional
public void importPurchase(List<PurchaseImportDTO> list) {
    // 生成采购主单
    PurchaseOrder order = createPurchaseOrder();
    // 逐行生成采购明细
    for (PurchaseImportDTO dto : list) {
        PurchaseOrderDetail detail = new PurchaseOrderDetail();
        detail.setIsbn(dto.getIsbn());
        detail.setQty(dto.getQty());
        // ... 设置其他字段
        detailMapper.insert(detail);
    }
    // 关联缺书单
    linkShortageOrders(order.getOrderId());
    // 记录操作日志
    saveOperLog(order.getOrderNo(), list.size());
    // 绝对没有 stock 更新操作
}
```

---

#### BUG-002：出库后库存与流水不一致

**现象**：确认出库后，库存数量正确但流水记录缺失，或流水数量与库存变动不符。

**根因**：出库Service没有使用 `@Transactional`，或事务范围内遗漏了流水记录生成。

**定位方法**：
```bash
# 搜索出库相关代码
grep -rn 'confirmOutbound\|confirmIssue\|出库' src/
# 检查事务注解
grep -rn '@Transactional' src/main/java/**/claim/
grep -rn '@Transactional' src/main/java/**/personal/
```

**修复方案**：
```java
// ❌ 错误：没有事务保证
public void confirmOutbound(Long formId, Integer issuedQty, String receiverName) {
    // 扣减库存
    textbookMapper.decreaseStock(isbn, issuedQty);
    // 如果这里异常，流水不会生成，但库存已经扣了
    stockFlowMapper.insert(flow);
}

// ✅ 正确：事务保证原子性
@Transactional(rollbackFor = Exception.class)
public void confirmOutbound(Long formId, Integer issuedQty, String receiverName) {
    // 1. 查询领书单
    BookClaimForm form = formMapper.selectById(formId);
    String isbn = form.getIsbn();

    // 2. 查询当前库存（用于流水记录）
    int stockBefore = textbookMapper.getStock(isbn);

    // 3. 扣减库存（带库存充足校验）
    int rows = textbookMapper.decreaseStock(isbn, issuedQty);
    if (rows == 0) {
        throw new ServiceException("库存不足，出库失败");
    }

    // 4. 生成库存流水
    BookStockFlow flow = new BookStockFlow();
    flow.setIsbn(isbn);
    flow.setBusinessType("2"); // 班级领书出库
    flow.setBusinessNo(form.getFormNo());
    flow.setChangeQty(-issuedQty);
    flow.setStockBefore(stockBefore);
    flow.setStockAfter(stockBefore - issuedQty);
    flow.setOperator(SecurityUtils.getUsername());
    flow.setOperateTime(new Date());
    stockFlowMapper.insert(flow);

    // 5. 更新领书单状态
    form.setIssuedQty(form.getIssuedQty() + issuedQty);
    if (form.getIssuedQty() >= form.getPlannedQty()) {
        form.setStatus("2"); // 已出库
    } else {
        form.setStatus("1"); // 部分出库
    }
    form.setReceiverName(receiverName);
    form.setIssueTime(new Date());
    formMapper.updateById(form);
}
```

---

#### BUG-003：并发出库导致库存为负数（超卖）

**现象**：多人同时确认出库时，库存变为负数。

**根因**：库存扣减没有并发控制，多个线程同时读取库存并扣减。

**定位方法**：
```bash
# 搜索库存扣减SQL
grep -rn 'decreaseStock\|UPDATE.*textbook.*stock' mapper/
```

**修复方案**：

**方案一：数据库层面校验（推荐，最简单）**
```xml
<!-- ❌ 错误：没有库存校验 -->
<update id="decreaseStock">
    UPDATE textbook SET stock = stock - #{qty} WHERE isbn = #{isbn}
</update>

<!-- ✅ 正确：WHERE条件保证库存不为负 -->
<update id="decreaseStock">
    UPDATE textbook SET stock = stock - #{qty}
    WHERE isbn = #{isbn} AND stock >= #{qty}
</update>
```

**方案二：乐观锁（适合高并发场景）**
```xml
<!-- 教材表增加 version 字段 -->
<update id="decreaseStockWithVersion">
    UPDATE textbook
    SET stock = stock - #{qty}, version = version + 1
    WHERE isbn = #{isbn} AND stock >= #{qty} AND version = #{version}
</update>
```
```java
public void confirmOutboundWithLock(String isbn, int qty) {
    int retryCount = 0;
    final int MAX_RETRY = 3;
    while (retryCount < MAX_RETRY) {
        Textbook book = textbookMapper.selectByIsbn(isbn);
        int rows = textbookMapper.decreaseStockWithVersion(
            isbn, qty, book.getVersion());
        if (rows > 0) {
            break; // 成功
        }
        retryCount++;
        if (retryCount >= MAX_RETRY) {
            throw new ServiceException("操作频繁，请稍后重试");
        }
    }
}
```

**方案三：悲观锁（适合极高并发场景）**
```xml
<select id="selectForUpdate" resultType="Textbook">
    SELECT * FROM textbook WHERE isbn = #{isbn} FOR UPDATE
</select>
```

---

#### BUG-004：采购单状态跳转异常

**现象**：采购单从"待采购"直接变为"已入库"，跳过了中间状态。

**根因**：状态更新接口没有校验当前状态，允许任意跳转。

**定位方法**：
```bash
# 搜索状态更新相关代码
grep -rn 'updateStatus\|changeStatus' src/
```

**修复方案**：
```java
// ❌ 错误：没有状态校验
public void updateStatus(Long orderId, String newStatus) {
    PurchaseOrder order = new PurchaseOrder();
    order.setOrderId(orderId);
    order.setStatus(newStatus);
    orderMapper.updateById(order);
}

// ✅ 正确：校验状态流转合法性
private static final Map<String, Set<String>> STATUS_TRANSITIONS = new HashMap<>();
static {
    STATUS_TRANSITIONS.put("0", new HashSet<>(Arrays.asList("1"))); // 待采购 → 采购中
    STATUS_TRANSITIONS.put("1", new HashSet<>(Arrays.asList("2"))); // 采购中 → 已到货
    STATUS_TRANSITIONS.put("2", new HashSet<>(Arrays.asList("3"))); // 已到货 → 已入库
}

public void updateStatus(Long orderId, String newStatus) {
    PurchaseOrder order = orderMapper.selectById(orderId);
    String currentStatus = order.getStatus();

    // 校验状态流转是否合法
    Set<String> allowedNext = STATUS_TRANSITIONS.get(currentStatus);
    if (allowedNext == null || !allowedNext.contains(newStatus)) {
        throw new ServiceException("不允许从[" + currentStatus + "]变更为[" + newStatus + "]");
    }

    // 已到货/已入库的采购单禁止编辑
    if ("2".equals(currentStatus) || "3".equals(currentStatus)) {
        throw new ServiceException("已到货或已入库的采购单不允许修改状态");
    }

    order.setStatus(newStatus);
    orderMapper.updateById(order);
}
```

---

#### BUG-005：教师能看到其他教师的领书记录

**现象**：教师A登录后，在个人领书管理中看到了教师B的申请记录。

**根因**：查询接口没有加 teacher_id 条件过滤，或MyBatis数据权限配置错误。

**定位方法**：
```bash
# 搜索个人领书查询
grep -rn 'personalApply\|personal.*list\|PersonalApplyMapper' src/
```

**修复方案**：

**后端修复**：
```java
// ❌ 错误：没有数据权限过滤
@GetMapping("/list")
public TableDataInfo list(BookPersonalApply apply) {
    startPage();
    List<BookPersonalApply> list = applyService.selectList(apply);
    return getDataTable(list);
}

// ✅ 正确：强制过滤当前用户数据
@GetMapping("/list")
public TableDataInfo list(BookPersonalApply apply) {
    // 强制设置当前用户ID，防止前端传入其他用户ID
    apply.setTeacherId(SecurityUtils.getUserId());
    startPage();
    List<BookPersonalApply> list = applyService.selectList(apply);
    return getDataTable(list);
}
```

**Mapper修复**：
```xml
<!-- ❌ 错误：没有teacher_id条件 -->
<select id="selectList" resultMap="PersonalApplyResult">
    SELECT * FROM book_personal_apply
    WHERE del_flag = '0'
    <if test="status != null and status != ''">AND status = #{status}</if>
</select>

<!-- ✅ 正确：强制加teacher_id条件 -->
<select id="selectList" resultMap="PersonalApplyResult">
    SELECT * FROM book_personal_apply
    WHERE del_flag = '0' AND teacher_id = #{teacherId}
    <if test="status != null and status != ''">AND status = #{status}</if>
</select>
```

---

#### BUG-006：供应商能看到其他供应商的采购单

**现象**：供应商A登录后，看到了分配给供应商B的采购单。

**根因**：采购单查询没有按 supplier_id 过滤。

**修复方案**：
```java
@GetMapping("/list")
public TableDataInfo list(PurchaseOrder order) {
    // 供应商角色：强制过滤自己的数据
    if (SecurityUtils.isSupplier()) {
        order.setSupplierId(SecurityUtils.getSupplierId());
    }
    startPage();
    List<PurchaseOrder> list = orderService.selectList(order);
    return getDataTable(list);
}
```

---

### 2.2 Excel导入Bug

#### BUG-007：Excel导入按表头匹配导致数据错位

**现象**：教务处提供的Excel列顺序与模板一致，但表头文字略有不同，导致数据读取错位。

**根因**：代码使用表头名称匹配列，而非固定列索引。

**修复方案**：
```java
// ❌ 错误：按表头名称匹配
Row row = sheet.getRow(i);
String isbn = getCellValue(row, "ISBN");          // 表头文字变化就出错
String bookName = getCellValue(row, "教材名称");

// ✅ 正确：按固定列下标读取（与设计文档一致）
Row row = sheet.getRow(i);
String isbn = getCellValue(row, 0);               // 第1列：ISBN
String bookName = getCellValue(row, 1);           // 第2列：教材名称
String qtyStr = getCellValue(row, 2);             // 第3列：采购数量
String college = getCellValue(row, 3);            // 第4列：申请学院
String major = getCellValue(row, 4);              // 第5列：申请专业
String className = getCellValue(row, 5);          // 第6列：适用班级（可选）
String remark = getCellValue(row, 6);             // 第7列：备注（可选）
```

---

#### BUG-008：Excel导入一行失败导致整批回滚

**现象**：100行数据中有1行ISBN不存在，整批导入失败，99行正确数据也丢失。

**根因**：没有逐行try-catch，异常直接抛出到事务层导致回滚。

**修复方案**：
```java
// ❌ 错误：异常直接抛出
@Transactional
public ImportResult importExcel(List<PurchaseImportDTO> list) {
    for (PurchaseImportDTO dto : list) {
        validateRow(dto); // 任何一行校验失败直接抛异常，整批回滚
        detailMapper.insert(dto);
    }
}

// ✅ 正确：逐行校验，失败行标记但不阻断
public ImportResult importExcel(List<PurchaseImportDTO> list) {
    ImportResult result = new ImportResult();
    result.setTotal(list.size());

    List<PurchaseImportDTO> successList = new ArrayList<>();
    List<ImportError> errorList = new ArrayList<>();

    for (int i = 0; i < list.size(); i++) {
        try {
            PurchaseImportDTO dto = list.get(i);
            validateRow(dto); // 校验失败抛异常
            successList.add(dto);
        } catch (Exception e) {
            result.fail();
            ImportError error = new ImportError();
            error.setRowNum(i + 1); // 行号（从1开始）
            error.setReason(e.getMessage());
            errorList.add(error);
        }
    }

    result.setSuccessList(successList);
    result.setErrorList(errorList);
    return result; // 返回给前端预览，用户确认后再执行入库
}

// 用户确认导入后，只导入校验通过的数据
@Transactional(rollbackFor = Exception.class)
public void confirmImport(List<PurchaseImportDTO> successList) {
    // 生成采购单（只包含校验通过的数据）
    PurchaseOrder order = createPurchaseOrder();
    for (PurchaseImportDTO dto : successList) {
        PurchaseOrderDetail detail = convertToDetail(dto);
        detailMapper.insert(detail);
    }
}
```

---

#### BUG-009：同一Excel文件重复导入

**现象**：库管员不小心将同一文件导入了两次，生成了重复的采购单。

**根因**：没有防重复导入机制。

**修复方案**：
```java
public ImportResult importExcel(MultipartFile file, List<PurchaseImportDTO> list) {
    // 计算文件MD5
    String fileMd5 = DigestUtils.md5Hex(file.getInputStream());

    // 检查是否已导入过
    int exists = importLogMapper.countByMd5(fileMd5);
    if (exists > 0) {
        throw new ServiceException("该文件已导入过，请勿重复导入");
    }

    // ... 执行导入逻辑

    // 记录导入日志（包含MD5）
    ImportLog log = new ImportLog();
    log.setFileMd5(fileMd5);
    log.setFileName(file.getOriginalFilename());
    log.setSuccessCount(successList.size());
    log.setFailCount(errorList.size());
    log.setOperator(SecurityUtils.getUsername());
    importLogMapper.insert(log);
}
```

---

### 2.3 前端显示Bug

#### BUG-010：库存预警不显示

**现象**：教材库存已低于预警阈值，但前端列表中没有标红提示。

**根因**：前端没有对比库存和预警阈值，或后端没有返回预警阈值字段。

**修复方案**：

**后端**：确保返回预警阈值字段
```java
// Textbook实体中确保有 alertThreshold 字段
public class Textbook {
    private Integer stock;          // 当前库存
    private Integer alertThreshold; // 预警阈值
    // getter/setter
}
```

**前端**：
```vue
<!-- ❌ 错误：没有预警判断 -->
<el-table-column prop="stock" label="库存数量" />

<!-- ✅ 正确：库存低于阈值标红 -->
<el-table-column prop="stock" label="库存数量">
  <template slot-scope="scope">
    <span :style="{ color: scope.row.stock <= scope.row.alertThreshold ? '#F56C6C' : '' }">
      {{ scope.row.stock }}
      <el-tag v-if="scope.row.stock <= scope.row.alertThreshold" type="danger" size="mini">
        库存不足
      </el-tag>
    </span>
  </template>
</el-table-column>
```

---

#### BUG-011：领书通知状态显示错误

**现象**：所有班级已出库完成，但领书通知状态仍显示"领取中"。

**根因**：出库确认时没有检查并更新领书通知的进度。

**修复方案**：
```java
@Transactional(rollbackFor = Exception.class)
public void confirmOutbound(Long formId, Integer issuedQty, String receiverName) {
    // ... 出库逻辑（扣库存、生成流水、更新领书单）

    // 检查领书通知下所有班级是否都已出库
    BookClaimForm form = formMapper.selectById(formId);
    BookNotice notice = noticeMapper.selectById(form.getNoticeId());

    int totalClasses = notice.getTotalClasses();
    int issuedClasses = formMapper.countIssuedByNoticeId(notice.getNoticeId());

    notice.setIssuedClasses(issuedClasses);
    if (issuedClasses >= totalClasses) {
        notice.setStatus("3"); // 已完成
    } else if (issuedClasses > 0) {
        notice.setStatus("2"); // 领取中
    }
    noticeMapper.updateById(notice);
}
```

---

#### BUG-012：分批出库数量计算错误

**现象**：班级50人，第一次出库30份，第二次出库20份，但领书单状态仍为"部分出库"。

**根因**：累计实发数量计算有误，或状态判断条件不正确。

**修复方案**：
```java
// ❌ 错误：直接用本次出库数量判断
form.setIssuedQty(issuedQty); // 覆盖了之前的数量！
if (issuedQty >= form.getPlannedQty()) {
    form.setStatus("2");
}

// ✅ 正确：累加实发数量
int totalIssued = form.getIssuedQty() + issuedQty;
form.setIssuedQty(totalIssued);
if (totalIssued >= form.getPlannedQty()) {
    form.setStatus("2"); // 已出库
} else {
    form.setStatus("1"); // 部分出库
}
```

---

### 2.4 安全相关Bug

#### BUG-013：SQL注入漏洞

**现象**：在搜索框输入特殊字符（如 `' OR 1=1 --`），查询返回了非预期数据。

**根因**：MyBatis XML中使用了 `${}` 拼接用户输入。

**修复方案**：
```xml
<!-- ❌ 错误：${} 直接拼接，存在SQL注入 -->
<select id="selectList" resultMap="TextbookResult">
    SELECT * FROM textbook
    WHERE del_flag = '0'
    AND book_name LIKE '%${bookName}%'
</select>

<!-- ✅ 正确：#{} 参数化查询 -->
<select id="selectList" resultMap="TextbookResult">
    SELECT * FROM textbook
    WHERE del_flag = '0'
    AND book_name LIKE CONCAT('%', #{bookName}, '%')
</select>

<!-- ✅ 如果必须动态列名，使用白名单校验 -->
<select id="selectList" resultMap="TextbookResult">
    SELECT * FROM textbook
    WHERE del_flag = '0'
    ORDER BY
    <choose>
        <when test="orderBy == 'stock'">stock</when>
        <when test="orderBy == 'price'">price</when>
        <otherwise>create_time</otherwise>
    </choose>
    ${orderDir} <!-- orderDir 只能是 ASC 或 DESC，在Service层校验 -->
</select>
```

---

#### BUG-014：XSS攻击漏洞

**现象**：在教材名称或备注中输入 `<script>alert('xss')</script>`，页面执行了脚本。

**根因**：前端使用 `v-html` 渲染用户输入，或后端没有过滤HTML标签。

**修复方案**：

**前端**：
```vue
<!-- ❌ 错误：直接渲染HTML -->
<div v-html="row.remark"></div>

<!-- ✅ 正确：使用文本插值（自动转义） -->
<div>{{ row.remark }}</div>

<!-- ✅ 如果确实需要渲染HTML，使用DOMPurify过滤 -->
<div v-html="sanitize(row.remark)"></div>
```

**后端**（RuoYi框架已内置XSS过滤，确认配置开启）：
```java
// 确认 RuoYi 的 XSS 过滤器已配置
// 检查 XssFilter.java 和 XssHttpServletRequestWrapper.java 是否存在
// 确认 FilterRegistrationBean 已注册
```

---

#### BUG-015：已审核的领书申请仍可取消

**现象**：教师提交的领书申请已被库管员审核通过，但教师仍能点击"取消"按钮。

**根因**：前端没有根据状态禁用取消按钮，或后端没有校验状态。

**修复方案**：

**前端**：
```vue
<!-- ❌ 错误：没有状态判断 -->
<el-button @click="cancelApply(row)">取消申请</el-button>

<!-- ✅ 正确：只有待审核状态才能取消 -->
<el-button
  v-if="row.status === '0'"
  @click="cancelApply(row)"
>取消申请</el-button>
```

**后端**：
```java
public void cancelApply(Long applyId) {
    BookPersonalApply apply = applyMapper.selectById(applyId);
    // 校验状态
    if (!"0".equals(apply.getStatus())) {
        throw new ServiceException("只有待审核的申请才能取消");
    }
    // 校验数据权限（只能取消自己的申请）
    if (!apply.getTeacherId().equals(SecurityUtils.getUserId())) {
        throw new ServiceException("无权操作他人的申请");
    }
    apply.setStatus("-1"); // 已取消
    applyMapper.updateById(apply);
}
```

---

### 2.5 通知相关Bug

#### BUG-016：审核后教师未收到通知

**现象**：库管员审核通过教师的领书申请后，教师的通知中心没有收到消息。

**根因**：审核Service中没有调用通知发送逻辑。

**修复方案**：
```java
@Transactional(rollbackFor = Exception.class)
public void auditApply(Long applyId, String status, String opinion) {
    BookPersonalApply apply = applyMapper.selectById(applyId);

    // 校验库存
    if ("1".equals(status)) {
        Textbook book = textbookMapper.selectByIsbn(apply.getIsbn());
        if (book.getStock() < apply.getApplyQty()) {
            throw new ServiceException("库存不足，无法通过审核");
        }
    }

    // 更新审核信息
    apply.setStatus(status);
    apply.setAuditOpinion(opinion);
    apply.setAuditBy(SecurityUtils.getUsername());
    apply.setAuditTime(new Date());
    applyMapper.updateById(apply);

    // ✅ 发送通知给教师
    SysNotice notice = new SysNotice();
    notice.setUserId(apply.getTeacherId());
    notice.setBusinessType("personal_apply_audit");
    notice.setBusinessId(applyId);
    notice.setTitle("领书申请审核结果");
    notice.setContent("1".equals(status)
        ? "您的领书申请已通过，请到书库领取。"
        : "您的领书申请已被驳回，原因：" + opinion);
    noticeMapper.insert(notice);
}
```

---

#### BUG-017：缺书单转采购后状态未更新

**现象**：库管员将缺书单一键转采购单后，缺书单状态仍为"未处理"。

**根因**：转采购方法中遗漏了缺书单状态更新。

**修复方案**：
```java
@Transactional(rollbackFor = Exception.class)
public PurchaseOrder convertToPurchase(Long shortageId) {
    BookShortage shortage = shortageMapper.selectById(shortageId);

    // 1. 创建采购单
    PurchaseOrder order = new PurchaseOrder();
    order.setOrderNo(generateOrderNo());
    order.setStatus("0"); // 待采购
    orderMapper.insert(order);

    // 2. 创建采购明细
    PurchaseOrderDetail detail = new PurchaseOrderDetail();
    detail.setOrderId(order.getOrderId());
    detail.setIsbn(shortage.getIsbn());
    detail.setQty(shortage.getQty());
    detailMapper.insert(detail);

    // 3. ✅ 更新缺书单状态
    shortage.setStatus("1"); // 已纳入采购
    shortage.setPurchaseOrderId(order.getOrderId());
    shortageMapper.updateById(shortage);

    return order;
}
```

---

### 2.6 数据模型Bug

#### BUG-018：逻辑删除数据被查询出来

**现象**：已删除的教材/采购单/领书单仍然出现在列表中。

**根因**：Mapper XML的查询SQL没有加 `del_flag = '0'` 条件。

**修复方案**：
```xml
<!-- ❌ 错误：没有del_flag过滤 -->
<select id="selectList" resultMap="TextbookResult">
    SELECT * FROM textbook WHERE 1=1
    <if test="bookName != null">AND book_name LIKE #{bookName}</if>
</select>

<!-- ✅ 正确：所有查询都加del_flag条件 -->
<select id="selectList" resultMap="TextbookResult">
    SELECT * FROM textbook WHERE del_flag = '0'
    <if test="bookName != null">AND book_name LIKE CONCAT('%',#{bookName},'%')</if>
</select>
```

**全局检查方法**：
```bash
# 搜索所有没有del_flag条件的SELECT语句
grep -rn 'SELECT.*FROM' mapper/xml/ | grep -v 'del_flag'
```

---

#### BUG-019：领书单应发数量与明细不一致

**现象**：领书单显示应发总数100，但明细中各教材数量加起来只有80。

**根因**：发布领书通知时，领书单的 planned_qty 没有正确汇总明细数量。

**修复方案**：
```java
// 发布领书通知时，自动生成领书单
private void generateClaimForms(BookNotice notice, List<NoticeDetailDTO> details) {
    // 按班级分组
    Map<Long, List<NoticeDetailDTO>> classGroup = details.stream()
        .collect(Collectors.groupingBy(NoticeDetailDTO::getClassId));

    for (Map.Entry<Long, List<NoticeDetailDTO>> entry : classGroup.entrySet()) {
        BookClaimForm form = new BookClaimForm();
        form.setFormNo(generateFormNo());
        form.setNoticeId(notice.getNoticeId());
        form.setClassId(entry.getKey());
        form.setStatus("0"); // 待领取

        // ✅ 正确计算应发总数
        int totalPlanned = entry.getValue().stream()
            .mapToInt(NoticeDetailDTO::getQty)
            .sum();
        form.setPlannedQty(totalPlanned);
        form.setIssuedQty(0);

        formMapper.insert(form);

        // 生成领书单明细
        for (NoticeDetailDTO dto : entry.getValue()) {
            BookClaimFormDetail detail = new BookClaimFormDetail();
            detail.setFormId(form.getFormId());
            detail.setIsbn(dto.getIsbn());
            detail.setPlannedQty(dto.getQty());
            detail.setIssuedQty(0);
            detailMapper.insert(detail);
        }
    }

    // 更新通知的班级总数
    notice.setTotalClasses(classGroup.size());
    noticeMapper.updateById(notice);
}
```

---

#### BUG-020：缺书单同一ISBN重复登记未合并

**现象**：教师A和教师B分别登记了同一ISBN缺书各5本，系统生成了两条缺书单，采购时只处理了一条。

**根因**：缺书登记没有做ISBN去重合并。

**修复方案**：
```java
public void registerShortage(BookShortage shortage) {
    // 检查是否已有相同ISBN的未处理缺书单
    BookShortage existing = shortageMapper.selectByIsbnAndStatus(
        shortage.getIsbn(), "0"); // 未处理

    if (existing != null) {
        // ✅ 合并：累加数量
        existing.setQty(existing.getQty() + shortage.getQty());
        // 取更高的紧急程度
        if (compareUrgency(shortage.getUrgency(), existing.getUrgency()) > 0) {
            existing.setUrgency(shortage.getUrgency());
        }
        shortageMapper.updateById(existing);
    } else {
        // 新增
        shortage.setStatus("0");
        shortageMapper.insert(shortage);
    }

    // 发送缺书通知给库管员
    sendShortageNotice(shortage);
}
```

---

## 三、Bug修复流程

### 3.1 标准修复流程

```
第一步：Bug复现
  ├─ 明确Bug现象（什么操作、什么结果、期望结果）
  ├─ 确认复现步骤
  ├─ 确认影响范围（哪些角色、哪些模块）
  └─ 截图/录屏留证

第二步：Bug定位
  ├─ 根据现象确定涉及的后端接口（Controller路径）
  ├─ 阅读Controller → Service → Mapper 完整调用链
  ├─ 检查数据库数据是否正确
  ├─ 检查前端请求参数是否正确
  └─ 查看后端日志是否有异常

第三步：根因分析
  ├─ 是业务逻辑错误？（对照设计文档）
  ├─ 是事务问题？（缺少@Transactional或事务范围不对）
  ├─ 是并发问题？（缺少锁机制）
  ├─ 是权限问题？（缺少数据权限过滤）
  ├─ 是前端问题？（状态判断错误、v-html等）
  └─ 确定根因，记录到Bug报告

第四步：制定修复方案
  ├─ 设计修复代码（参考本指南中的修复模板）
  ├─ 评估修复影响（是否影响其他功能）
  ├─ 确定是否需要数据库修复脚本
  └─ 编写修复代码

第五步：验证修复
  ├─ 原Bug是否已修复
  ├─ 相关功能是否正常（回归测试）
  ├─ 边界条件是否处理（空值、极值、并发）
  └─ 代码Review

第六步：清理与记录
  ├─ 提交代码（附Bug编号）
  ├─ 更新Bug状态
  └─ 如需修复脏数据，编写数据修复SQL
```

### 3.2 脏数据修复脚本模板

```sql
-- 修复库存与流水不一致
-- 步骤1：计算流水汇总
CREATE TEMPORARY TABLE tmp_stock_calc AS
SELECT isbn, SUM(change_qty) AS calc_stock
FROM book_stock_flow
GROUP BY isbn;

-- 步骤2：找出不一致的记录
SELECT t.isbn, t.stock AS current_stock, c.calc_stock AS should_stock
FROM textbook t
JOIN tmp_stock_calc c ON t.isbn = c.isbn
WHERE t.stock != c.calc_stock;

-- 步骤3：修复（谨慎执行，先备份）
UPDATE textbook t
JOIN tmp_stock_calc c ON t.isbn = c.isbn
SET t.stock = c.calc_stock
WHERE t.stock != c.calc_stock;

-- 修复领书单应发数量与明细不一致
UPDATE book_claim_form f
SET f.planned_qty = (
    SELECT IFNULL(SUM(d.planned_qty), 0)
    FROM book_claim_form_detail d
    WHERE d.form_id = f.form_id
)
WHERE f.del_flag = '0';
```

---

## 四、调试技巧

### 4.1 日志排查

```java
// 在关键业务节点添加日志
@Slf4j
@Service
public class PurchaseServiceImpl {

    public void importPurchase(List<PurchaseImportDTO> list) {
        log.info("开始导入采购单，总行数：{}", list.size());
        for (int i = 0; i < list.size(); i++) {
            PurchaseImportDTO dto = list.get(i);
            log.debug("第{}行：ISBN={}, 数量={}", i+1, dto.getIsbn(), dto.getQty());
            try {
                validateRow(dto);
                log.debug("第{}行校验通过", i+1);
            } catch (Exception e) {
                log.warn("第{}行校验失败：{}", i+1, e.getMessage());
            }
        }
        log.info("导入完成，成功{}行，失败{}行", successCount, failCount);
    }
}
```

### 4.2 SQL排查

```sql
-- 检查库存流水一致性
SELECT t.isbn, t.book_name, t.stock,
       (SELECT SUM(change_qty) FROM book_stock_flow f WHERE f.isbn = t.isbn) AS flow_sum
FROM textbook t
HAVING t.stock != flow_sum;

-- 检查采购单状态异常（跳转）
SELECT order_no, status, create_time, update_time
FROM purchase_order
WHERE del_flag = '0'
ORDER BY create_time;

-- 检查领书单数量不一致
SELECT f.form_no, f.planned_qty,
       (SELECT SUM(d.planned_qty) FROM book_claim_form_detail d WHERE d.form_id = f.form_id) AS detail_sum
FROM book_claim_form f
WHERE f.del_flag = '0'
HAVING f.planned_qty != detail_sum;

-- 检查缺书单重复ISBN
SELECT isbn, COUNT(*) AS cnt, SUM(qty) AS total_qty
FROM book_shortage
WHERE del_flag = '0' AND status = '0'
GROUP BY isbn
HAVING cnt > 1;
```

### 4.3 接口测试

```bash
# 使用curl测试接口（替换TOKEN）
TOKEN="your_token_here"

# 测试教师个人领书列表（应只返回本人数据）
curl -H "Authorization: Bearer $TOKEN" \
  "http://localhost:8080/api/personal/apply/list"

# 测试出库接口
curl -X POST -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"formId":1,"issuedQty":30,"receiverName":"张三"}' \
  "http://localhost:8080/api/claim/confirmOutbound"

# 测试Excel导入
curl -X POST -H "Authorization: Bearer $TOKEN" \
  -F "file=@test_purchase.xlsx" \
  "http://localhost:8080/api/purchase/import"
```

---

## 五、状态枚举速查

```
采购单状态：0待采购 → 1采购中 → 2已到货 → 3已入库
领书通知状态：0草稿 → 1已发布 → 2领取中 → 3已完成
领书单状态：0待领取 → 1部分出库 → 2已出库
个人领书申请状态：0待审核 → 1已通过 → 2已驳回 → 3已出库
缺书单状态：0未处理 → 1已纳入采购 → 2已到货 → 3已完成
删除标志：0正常 → 1删除
```

---

## 六、核心业务规则速查

| 规则 | 说明 |
|------|------|
| 库存只能通过入库/出库变更 | 绝对禁止直接UPDATE stock |
| 导入不修改库存 | Excel导入只生成采购单 |
| 入库才加库存 | 采购单确认入库时才增加库存 |
| 出库才减库存 | 领书单/个人申请确认出库时才扣减库存 |
| 流水不可篡改 | book_stock_flow只能INSERT |
| Excel按列下标读取 | 硬编码列索引，不按表头匹配 |
| 单行失败不阻断 | 逐行try-catch |
| 已入库禁止编辑 | 状态校验 |
| 并发出库防超卖 | 乐观锁或WHERE stock >= qty |
| 教师只看本人数据 | teacher_id过滤 |
| 供应商只看本人数据 | supplier_id过滤 |
| 领书通知仅系统内展示 | 不推送消息给班委 |
| 班委纸质签名 | 系统只记录姓名 |
| 缺书单按ISBN合并 | 累加数量 |
| 事务保证 | 入库/出库必须@Transactional |
