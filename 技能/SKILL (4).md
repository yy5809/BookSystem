---
name: security
description: 教材采购与库存管理系统安全加固技能。用于检测和修复系统安全漏洞，包括SQL注入、XSS攻击、CSRF防护、越权访问、文件上传安全、敏感信息保护、接口安全。基于RuoYi-Vue 3.9.0框架的安全特性，提供完整的安全加固方案。适用于 SpringBoot 2.x + Spring Security + Vue2 + MySQL 技术栈。
---

# 教材采购与库存管理系统 — 安全加固技能

## 一、安全威胁概览

### 1.1 系统安全风险矩阵

| 威胁类型 | 风险等级 | 影响范围 | 本系统特殊风险 |
|---------|---------|---------|--------------|
| SQL注入 | 🔴 严重 | 数据泄露/篡改 | MyBatis `${}` 拼接 |
| XSS攻击 | 🔴 严重 | 用户信息窃取 | `v-html` 渲染用户输入 |
| 越权访问 | 🔴 严重 | 数据泄露 | 教师/供应商数据隔离 |
| 文件上传 | 🔴 严重 | 服务器被入侵 | Excel导入接口 |
| CSRF攻击 | 🟡 高 | 未授权操作 | 表单提交 |
| 敏感信息泄露 | 🟡 高 | 信息泄露 | 日志打印密码/Token |
| 接口滥用 | 🟠 中 | 服务拒绝 | Excel导入/批量操作 |
| 并发超卖 | 🔴 严重 | 数据不一致 | 库存扣减 |

---

## 二、SQL注入防护

### 2.1 检测规则

```bash
# 搜索所有 ${} 用法（高风险）
grep -rn '\${' src/main/resources/mapper/

# 搜索动态排序（中风险）
grep -rn 'ORDER BY.*\${' src/
```

### 2.2 修复规范

```xml
<!-- ❌ 严禁：${} 拼接用户输入 -->
<select id="selectList" resultMap="TextbookResult">
    SELECT * FROM textbook
    WHERE del_flag = '0'
    AND book_name LIKE '%${bookName}%'
    ORDER BY ${orderBy} ${orderDir}
</select>

<!-- ✅ 正确：#{} 参数化查询 -->
<select id="selectList" resultMap="TextbookResult">
    SELECT * FROM textbook
    WHERE del_flag = '0'
    AND book_name LIKE CONCAT('%', #{bookName}, '%')
    ORDER BY
    <choose>
        <when test="orderBy == 'stock'">stock</when>
        <when test="orderBy == 'price'">price</when>
        <when test="orderBy == 'create_time'">create_time</when>
        <otherwise>create_time</otherwise>
    </choose>
    <choose>
        <when test="orderDir == 'asc'">ASC</when>
        <otherwise>DESC</otherwise>
    </choose>
</select>
```

### 2.3 白名单校验（必须使用 ${} 的场景）

```java
// Service层白名单校验
private static final Set<String> ALLOWED_ORDER_COLUMNS =
    Set.of("stock", "price", "book_name", "create_time");

private static final Set<String> ALLOWED_ORDER_DIRS = Set.of("asc", "desc");

public List<Textbook> selectList(TextbookQueryDTO query) {
    // 校验排序字段
    if (query.getOrderBy() != null && !ALLOWED_ORDER_COLUMNS.contains(query.getOrderBy())) {
        query.setOrderBy("create_time"); // 默认值
    }
    if (query.getOrderDir() != null && !ALLOWED_ORDER_DIRS.contains(query.getOrderDir().toLowerCase())) {
        query.setOrderDir("desc"); // 默认值
    }
    return textbookMapper.selectList(query);
}
```

---

## 三、XSS防护

### 3.1 后端防护（RuoYi内置）

```java
// 确认 XSS 过滤器已启用
// 1. 检查 XssFilter.java 是否存在
// 2. 检查 FilterRegistrationBean 是否注册
// 3. 检查 application.yml 配置

// application.yml
xss:
  enabled: true
  excludes: /api/notice/content  # 需要排除的路径（如富文本内容）
  urlPatterns: /api/*
```

### 3.2 前端防护

```vue
<!-- ❌ 严禁：直接渲染用户输入的HTML -->
<div v-html="userInput"></div>
<el-input v-model="form.remark" />  <!-- 输入后用 v-html 显示 -->

<!-- ✅ 正确：使用文本插值（自动转义） -->
<div>{{ userInput }}</div>
<div>{{ form.remark }}</div>

<!-- ✅ 如必须渲染HTML，使用DOMPurify过滤 -->
<script>
import DOMPurify from 'dompurify'
export default {
  methods: {
    sanitize(html) {
      return DOMPurify.sanitize(html, {
        ALLOWED_TAGS: ['b', 'i', 'u', 'br', 'p', 'span'],
        ALLOWED_ATTR: ['style', 'class']
      })
    }
  }
}
</script>
<div v-html="sanitize(notification.content)"></div>
```

### 3.3 富文本内容处理

```java
// 通知内容等富文本字段，存储前过滤危险标签
public void sendNotification(String content) {
    // 使用 Jsoup 清理HTML
    String cleanHtml = Jsoup.clean(content, Whitelist.relaxed()
        .removeTags("script", "iframe", "object", "embed")
        .removeAttributes("on*")); // 移除所有on事件属性
    notification.setContent(cleanHtml);
    notificationMapper.insert(notification);
}
```

---

## 四、越权访问防护

### 4.1 水平越权防护（数据隔离）

```java
// 教师接口：强制过滤本人数据
@GetMapping("/api/personal/list")
public TableDataInfo list(PersonalApplyQueryDTO query) {
    // ✅ 强制设置当前用户ID，忽略前端传入值
    query.setTeacherId(SecurityUtils.getUserId());
    startPage();
    return getDataTable(personalService.selectList(query));
}

// 供应商接口：强制过滤本人数据
@GetMapping("/api/purchase/list")
public TableDataInfo list(PurchaseOrderQueryDTO query) {
    if (SecurityUtils.isSupplier()) {
        // ✅ 供应商只能看自己的采购单
        query.setSupplierId(SecurityUtils.getSupplierId());
    }
    startPage();
    return getDataTable(purchaseService.selectList(query));
}

// 详情接口：校验数据归属
@GetMapping("/api/personal/{id}")
public AjaxResult getInfo(@PathVariable Long id) {
    BookPersonalApply apply = personalService.selectById(id);
    // ✅ 校验当前用户是否有权查看
    if (!apply.getTeacherId().equals(SecurityUtils.getUserId())) {
        throw new ServiceException("无权查看他人的申请记录");
    }
    return success(apply);
}
```

### 4.2 垂直越权防护（接口权限）

```java
// ✅ 每个接口必须有权限注解
@PreAuthorize("@ss.hasPermi('textbook:add')")  // 库管员权限
@PostMapping("/api/textbook")
public AjaxResult add(@RequestBody TextbookDTO dto) { ... }

// ❌ 错误：没有权限注解，任何登录用户都能调用
@PostMapping("/api/textbook")
public AjaxResult add(@RequestBody TextbookDTO dto) { ... }
```

### 4.3 MyBatis数据权限

```xml
<!-- RuoYi数据权限注解：自动拼接数据权限SQL -->
<select id="selectList" resultMap="PersonalApplyResult">
    SELECT * FROM book_personal_apply
    WHERE del_flag = '0'
    <!-- 数据权限：教师角色自动加 teacher_id = #{userId} -->
    ${params.dataScope}
</select>
```

---

## 五、文件上传安全

### 5.1 Excel导入接口加固

```java
/**
 * 文件上传安全校验
 */
@PostMapping("/api/purchase/import")
public AjaxResult importExcel(@RequestParam("file") MultipartFile file) {
    // 1. 文件非空校验
    if (file == null || file.isEmpty()) {
        throw new ServiceException("请选择文件");
    }

    // 2. 文件扩展名校验（白名单）
    String originalFilename = file.getOriginalFilename();
    String extension = originalFilename.substring(originalFilename.lastIndexOf(".")).toLowerCase();
    Set<String> allowedExtensions = Set.of(".xlsx", ".xls");
    if (!allowedExtensions.contains(extension)) {
        throw new ServiceException("仅支持 .xlsx 或 .xls 格式");
    }

    // 3. 文件大小校验
    long maxSize = 10 * 1024 * 1024; // 10MB
    if (file.getSize() > maxSize) {
        throw new ServiceException("文件大小不能超过10MB");
    }

    // 4. 文件内容校验（防止伪装扩展名）
    try (InputStream is = file.getInputStream()) {
        // 检查文件魔数（Magic Number）
        byte[] header = new byte[8];
        is.read(header);
        String fileHeader = bytesToHex(header);
        // xlsx: 504B0304  xls: D0CF11E0
        if (!fileHeader.startsWith("504b0304") && !fileHeader.startsWith("d0cf11e0")) {
            throw new ServiceException("文件内容与扩展名不匹配");
        }
    }

    // 5. 文件名安全处理（防止路径穿越）
    String safeFilename = originalFilename.replaceAll("[\\\\/]", "_");

    // 6. 行数限制
    // ... 解析后检查行数不超过1000

    return success(purchaseService.uploadAndValidate(file));
}
```

### 5.2 文件存储安全

```java
// ✅ 安全的文件存储路径
String uploadDir = RuoYiConfig.getUploadPath(); // 配置的上传目录
String filePath = uploadDir + "/" + DateUtils.datePath() + "/" + UUID.randomUUID() + extension;

// ❌ 危险：使用用户传入的文件名作为路径
String filePath = "/uploads/" + originalFilename; // 可能路径穿越
```

---

## 六、CSRF防护

### 6.1 Spring Security配置

```java
@Configuration
@EnableWebSecurity
public class SecurityConfig extends WebSecurityConfigurerAdapter {

    @Override
    protected void configure(HttpSecurity http) throws Exception {
        http
            // 前后端分离项目，通常使用Token认证，CSRF可以禁用
            // 但如果使用Cookie认证，必须启用CSRF
            .csrf()
                .csrfTokenRepository(CookieCsrfTokenRepository.withHttpOnlyFalse())
                .ignoringAntMatchers("/api/upload") // 文件上传接口排除
            .and()
            // ...
    }
}
```

### 6.2 Token安全

```java
// ✅ Token安全配置
// 1. Token有效期设置合理（如2小时）
// 2. Token存储在localStorage（非Cookie，防止CSRF）
// 3. 敏感操作需要二次验证
// 4. Token续期机制（滑动窗口）
```

---

## 七、敏感信息保护

### 7.1 日志脱敏

```java
// ❌ 错误：日志中打印敏感信息
log.info("用户登录：username={}, password={}", username, password);
log.info("Token: {}", token);

// ✅ 正确：脱敏处理
log.info("用户登录：username={}, password=***", username);
log.info("用户操作：userId={}, action={}", SecurityUtils.getUserId(), "导入采购单");
```

### 7.2 接口返回脱敏

```java
// 教师信息返回时脱敏手机号
public class TeacherVO {
    private String name;
    private String phone; // 前端展示时脱敏：138****1234
    // ...
}

// 密码字段绝对不能返回
public class UserVO {
    // ❌ private String password;
    // ✅ 不包含password字段
    private String username;
    private String nickname;
}
```

### 7.3 数据库加密

```sql
-- 敏感字段加密存储（如供应商联系电话）
-- 使用AES加密
INSERT INTO book_supplier (supplier_name, contact_phone, ...)
VALUES ('XX出版社', AES_ENCRYPT('13800138000', 'secret_key'), ...);

-- 查询时解密
SELECT supplier_name, AES_DECRYPT(contact_phone, 'secret_key') AS contact_phone
FROM book_supplier;
```

---

## 八、接口安全

### 8.1 接口限流

```java
/**
 * 使用Guava RateLimiter限制接口调用频率
 */
@Component
public class RateLimitInterceptor implements HandlerInterceptor {

    // Excel导入：每分钟最多5次
    private final RateLimiter importLimiter = RateLimiter.create(5.0 / 60.0);

    // 批量操作：每分钟最多10次
    private final RateLimiter batchLimiter = RateLimiter.create(10.0 / 60.0);

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) {
        String uri = request.getRequestURI();
        if (uri.contains("/import")) {
            if (!importLimiter.tryAcquire()) {
                throw new ServiceException("操作过于频繁，请稍后再试");
            }
        }
        return true;
    }
}
```

### 8.2 接口签名验证（可选）

```java
/**
 * 关键操作接口签名验证
 * 防止接口被恶意调用
 */
@GetMapping("/api/stock/flow/export")
public void exportFlow(
    @RequestParam String timestamp,
    @RequestParam String sign,
    HttpServletResponse response) {

    // 1. 校验时间戳（5分钟内有效）
    long ts = Long.parseLong(timestamp);
    if (System.currentTimeMillis() - ts > 5 * 60 * 1000) {
        throw new ServiceException("请求已过期");
    }

    // 2. 校验签名
    String expectedSign = DigestUtils.md5Hex(timestamp + SECRET_KEY);
    if (!expectedSign.equals(sign)) {
        throw new ServiceException("签名验证失败");
    }

    // 3. 执行导出
    // ...
}
```

---

## 九、安全检查清单

| # | 检查项 | 检查方法 | 修复方案 |
|---|--------|---------|---------|
| 1 | MyBatis无 `${}` 拼接 | `grep -rn '\${' mapper/` | 改为 `#{}` |
| 2 | 前端无 `v-html` 渲染用户输入 | `grep -rn 'v-html' views/` | 改为 `{{ }}` 或 DOMPurify |
| 3 | 所有接口有权限注解 | `grep -rn '@GetMapping\|@PostMapping' src/` | 添加 `@PreAuthorize` |
| 4 | 教师数据隔离 | 测试教师A查看教师B数据 | 强制 `teacher_id` 过滤 |
| 5 | 供应商数据隔离 | 测试供应商A查看供应商B数据 | 强制 `supplier_id` 过滤 |
| 6 | 文件上传校验 | 上传非Excel文件 | 白名单+魔数校验 |
| 7 | 日志无敏感信息 | `grep -rn 'password\|token' log/` | 脱敏处理 |
| 8 | 密码加密存储 | 检查数据库 | BCrypt加密 |
| 9 | Token有效期 | 检查配置 | 2小时，支持续期 |
| 10 | 接口限流 | 压测 | RateLimiter |
