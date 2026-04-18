---
name: backend
description: 教材采购与库存管理系统后端开发技能。用于规范和指导系统后端开发，基于SpringBoot 2.x + MyBatis + RuoYi-Vue 3.9.0框架。涵盖分层架构、Service层事务管理、并发控制、异常处理、日志规范、数据权限、编号生成等核心开发模式。包括采购管理、入库管理、班级领书、个人领书等全部业务模块的后端实现规范。
---

# 教材采购与库存管理系统 — 后端开发技能

## 一、后端技术栈

| 技术 | 版本 | 用途 |
|------|------|------|
| SpringBoot | 2.x | 基础框架 |
| MyBatis | 3.5+ | ORM框架 |
| MySQL | 5.7+ / 8.0 | 数据库 |
| Redis | 5.0+ | 缓存/会话 |
| Spring Security | - | 安全框架 |
| Hutool | 5.x | 工具库 |
| RuoYi | 3.9.0 | 基础框架 |

---

## 二、项目分层架构

```
ruoyi-book/
├── ruoyi-admin/                  # 启动模块
│   └── com.ruoyi.web.controller/
│       └── book/                 # Controller层
│           ├── TextbookController.java
│           ├── PurchaseController.java
│           ├── WarehouseController.java
│           ├── ClaimController.java
│           ├── PersonalApplyController.java
│           ├── ShortageController.java
│           ├── StockController.java
│           └── NotificationController.java
├── ruoyi-system/                 # 系统模块（RuoYi自带）
└── ruoyi-common/                 # 公共模块
└── ruoyi-book/                   # 业务模块
    └── com.ruoyi.book/
        ├── domain/               # 实体类
        │   ├── BookTextbook.java
        │   ├── PurchaseOrder.java
        │   ├── BookClaimForm.java
        │   ├── BookStockFlow.java
        │   └── ...
        ├── mapper/               # Mapper接口
        │   ├── BookTextbookMapper.java
        │   └── ...
        ├── service/              # Service接口
        │   ├── ITextbookService.java
        │   └── ...
        ├── service/impl/         # Service实现
        │   ├── TextbookServiceImpl.java
        │   ├── PurchaseServiceImpl.java
        │   ├── WarehouseServiceImpl.java
        │   ├── ClaimServiceImpl.java
        │   └── ...
        └── enums/                # 枚举类
            ├── PurchaseStatus.java
            ├── NoticeStatus.java
            ├── ClaimStatus.java
            └── BusinessType.java
```

---

## 三、核心开发模式

### 3.1 事务管理模式

```java
/**
 * 事务管理规范：
 * 1. Service层方法使用 @Transactional
 * 2. 指定 rollbackFor = Exception.class
 * 3. 只读方法使用 readOnly = true
 * 4. 事务方法必须是 public
 */
@Service
public class WarehouseServiceImpl implements IWarehouseService {

    /**
     * 入库确认 - 核心事务方法
     * 事务范围：增加库存 + 生成流水 + 更新采购单状态 + 更新缺书单 + 发送通知
     */
    @Transactional(rollbackFor = Exception.class)
    public void confirmInbound(Long orderId, InboundConfirmDTO dto) {
        // 1. 校验采购单状态
        PurchaseOrder order = orderMapper.selectById(orderId);
        if (!"2".equals(order.getStatus())) {
            throw new ServiceException("只有已到货的采购单才能入库");
        }

        // 2. 查询采购明细
        List<PurchaseOrderDetail> details = detailMapper.selectByOrderId(orderId);

        // 3. 逐项入库
        for (InboundDetailDTO item : dto.getDetails()) {
            PurchaseOrderDetail detail = details.stream()
                .filter(d -> d.getDetailId().equals(item.getDetailId()))
                .findFirst().orElseThrow(() -> new ServiceException("明细不存在"));

            // 3.1 记录库存快照
            int stockBefore = textbookMapper.getStock(detail.getIsbn());
            int actualQty = item.getActualQty();

            // 3.2 增加库存
            textbookMapper.increaseStock(detail.getIsbn(), actualQty);

            // 3.3 生成库存流水
            BookStockFlow flow = new BookStockFlow();
            flow.setTextbookId(detail.getTextbookId());
            flow.setIsbn(detail.getIsbn());
            flow.setBusinessType("1"); // 采购入库
            flow.setBusinessNo(order.getOrderNo());
            flow.setChangeQty(actualQty);
            flow.setStockBefore(stockBefore);
            flow.setStockAfter(stockBefore + actualQty);
            flow.setOperator(SecurityUtils.getUsername());
            flow.setOperateTime(new Date());
            flowMapper.insert(flow);
        }

        // 4. 更新采购单状态
        orderMapper.updateStatus(orderId, "3"); // 已入库

        // 5. 更新关联缺书单状态
        shortageMapper.updateStatusByPurchaseOrderId(orderId, "3"); // 已完成

        // 6. 发送进书通知给供应商
        notificationService.sendInboundNotice(order);

        // 7. 绝对没有其他库存修改操作
    }

    /**
     * 只读查询 - 不需要事务
     */
    @Transactional(readOnly = true)
    public PurchaseOrderVO selectDetailById(Long orderId) {
        return orderMapper.selectDetailById(orderId);
    }
}
```

### 3.2 并发控制模式

```java
/**
 * 并发控制规范：
 * 1. 库存操作必须使用乐观锁或数据库条件校验
 * 2. 编号生成必须保证唯一性
 */
@Service
public class ClaimServiceImpl implements IClaimService {

    /**
     * 出库确认 - 并发安全
     */
    @Transactional(rollbackFor = Exception.class)
    public void confirmIssue(IssueConfirmDTO dto) {
        BookClaimForm form = formMapper.selectById(dto.getFormId());

        for (IssueDetailDTO item : dto.getDetails()) {
            BookClaimFormDetail detail = detailMapper.selectById(item.getDetailId());

            // ✅ 方案一：数据库条件校验（推荐）
            int rows = textbookMapper.decreaseStockWithCheck(
                detail.getIsbn(), item.getIssuedQty());
            if (rows == 0) {
                throw new ServiceException("教材[" + detail.getBookName() + "]库存不足");
            }

            // 生成流水...
        }

        // 更新领书单状态...
    }
}
```

```xml
<!-- Mapper XML：库存扣减（带条件校验） -->
<update id="decreaseStockWithCheck">
    UPDATE book_textbook
    SET stock = stock - #{qty}, version = version + 1
    WHERE isbn = #{isbn} AND stock >= #{qty}
</update>
```

### 3.3 编号生成模式

```java
/**
 * 编号生成器 - 基于Redis的原子递增
 */
@Component
public class OrderNoGenerator {

    @Autowired
    private RedisCache redisCache;

    private static final String ORDER_PREFIX = "CG";
    private static final String FORM_PREFIX = "LS";
    private static final String APPLY_PREFIX = "SQ";

    /**
     * 生成采购单号：CG + yyyyMMddHHmmss + 3位序号
     */
    public String generateOrderNo() {
        String dateStr = DateUtils.dateTimeNow("yyyyMMddHHmmss");
        String key = "order_no:" + dateStr;
        Long seq = redisCache.increment(key, 1);
        redisCache.expire(key, 2, TimeUnit.MINUTES); // 2分钟后过期
        return String.format("%s%s%03d", ORDER_PREFIX, dateStr, seq % 1000);
    }

    /**
     * 生成领书单号：LS + yyyyMMddHHmmss + 3位序号
     */
    public String generateFormNo() {
        String dateStr = DateUtils.dateTimeNow("yyyyMMddHHmmss");
        String key = "form_no:" + dateStr;
        Long seq = redisCache.increment(key, 1);
        redisCache.expire(key, 2, TimeUnit.MINUTES);
        return String.format("%s%s%03d", FORM_PREFIX, dateStr, seq % 1000);
    }
}
```

---

## 四、异常处理规范

### 4.1 自定义业务异常

```java
/**
 * 业务异常 - 继承 RuntimeException，事务会自动回滚
 */
public class ServiceException extends RuntimeException {
    private Integer code;
    private String message;
    private String detailMessage;

    public ServiceException(String message) {
        this.message = message;
    }

    public ServiceException(String message, Integer code) {
        this.message = message;
        this.code = code;
    }

    // 自定义错误码
    public static ServiceException isbnNotFound(String isbn) {
        return new ServiceException("ISBN[" + isbn + "]在系统中不存在", 1002);
    }

    public static ServiceException stockInsufficient(String bookName) {
        return new ServiceException("教材[" + bookName + "]库存不足", 1004);
    }

    public static ServiceException statusNotAllowed(String current, String target) {
        return new ServiceException("不允许从[" + current + "]变更为[" + target + "]", 1005);
    }
}
```

### 4.2 全局异常处理

```java
/**
 * 全局异常处理器（RuoYi已内置，以下为补充）
 */
@RestControllerAdvice
public class BookExceptionHandler {

    /**
     * 库存不足异常
     */
    @ExceptionHandler(StockInsufficientException.class)
    public AjaxResult handleStockInsufficient(StockInsufficientException e) {
        log.error("库存不足：{}", e.getMessage());
        return AjaxResult.error(1004, e.getMessage());
    }

    /**
     * 状态流转异常
     */
    @ExceptionHandler(StatusTransitionException.class)
    public AjaxResult handleStatusTransition(StatusTransitionException e) {
        log.error("状态流转异常：{}", e.getMessage());
        return AjaxResult.error(1005, e.getMessage());
    }
}
```

---

## 五、枚举设计规范

```java
/**
 * 采购单状态枚举
 */
public enum PurchaseStatus {
    PENDING("0", "待采购"),
    PURCHASING("1", "采购中"),
    RECEIVED("2", "已到货"),
    STORED("3", "已入库");

    private final String code;
    private final String label;

    PurchaseStatus(String code, String label) {
        this.code = code;
        this.label = label;
    }

    /**
     * 校验状态流转是否合法
     */
    public boolean canTransitionTo(PurchaseStatus target) {
        switch (this) {
            case PENDING: return target == PURCHASING;
            case PURCHASING: return target == RECEIVED;
            case RECEIVED: return target == STORED;
            default: return false;
        }
    }

    /**
     * 是否允许编辑
     */
    public boolean canEdit() {
        return this == PENDING || this == PURCHASING;
    }

    /**
     * 是否允许删除
     */
    public boolean canDelete() {
        return this == PENDING;
    }

    // getter...
}
```

---

## 六、日志规范

```java
/**
 * 日志使用规范
 */
@Slf4j
@Service
public class PurchaseServiceImpl {

    /**
     * ✅ 正确：使用占位符，不拼接字符串
     */
    public void importExcel(MultipartFile file) {
        log.info("开始导入采购单，文件名：{}，大小：{}KB", file.getOriginalFilename(), file.getSize() / 1024);
        // ...
        log.info("导入完成，成功{}条，失败{}条", successCount, failCount);
    }

    /**
     * ❌ 错误：字符串拼接（性能差）
     */
    public void badLog(MultipartFile file) {
        log.info("开始导入采购单，文件名：" + file.getOriginalFilename());
    }

    /**
     * ✅ 正确：异常日志记录完整堆栈
     */
    public void confirmInbound(Long orderId) {
        try {
            // ...
        } catch (Exception e) {
            log.error("入库失败，采购单ID：{}", orderId, e);
            throw new ServiceException("入库失败：" + e.getMessage());
        }
    }

    /**
     * ❌ 错误：只记录消息，丢失堆栈
     */
    public void badLog(Long orderId) {
        try {
            // ...
        } catch (Exception e) {
            log.error("入库失败：" + e.getMessage()); // 丢失堆栈信息
        }
    }

    /**
     * ✅ 正确：debug级别记录详细参数
     */
    public void processRow(int rowNum, PurchaseImportDTO dto) {
        log.debug("处理第{}行：ISBN={}, 数量={}", rowNum, dto.getIsbn(), dto.getPurchaseQty());
    }
}
```

---

## 七、Mapper开发规范

### 7.1 XML规范

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN" "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="com.ruoyi.book.mapper.BookTextbookMapper">

    <resultMap type="BookTextbook" id="TextbookResult">
        <id     property="textbookId"    column="textbook_id"    />
        <result property="isbn"          column="isbn"          />
        <result property="bookName"      column="book_name"     />
        <result property="stock"         column="stock"         />
        <result property="delFlag"       column="del_flag"      />
    </resultMap>

    <!-- ✅ 所有查询必须加 del_flag = '0' -->
    <select id="selectList" resultMap="TextbookResult">
        SELECT * FROM book_textbook
        WHERE del_flag = '0'
        <if test="isbn != null and isbn != ''">AND isbn = #{isbn}</if>
        <if test="bookName != null and bookName != ''">AND book_name LIKE CONCAT('%',#{bookName},'%')</if>
        <if test="status != null and status != ''">AND status = #{status}</if>
        ORDER BY create_time DESC
    </select>

    <!-- ✅ 使用 #{} 防止SQL注入 -->
    <!-- ❌ 禁止使用 ${} 拼接用户输入 -->

</mapper>
```

### 7.2 禁止直接修改库存

```java
/**
 * ✅ TextbookMapper - 只提供查询和通过入库/出库变更库存的方法
 */
public interface BookTextbookMapper {
    List<BookTextbook> selectList(BookTextbookQuery query);
    BookTextbook selectById(Long id);
    BookTextbook selectByIsbn(String isbn);
    int insert(BookTextbook textbook);
    int update(BookTextbook textbook); // 不包含stock字段
    int deleteByIds(Long[] ids);       // 逻辑删除

    // 以下方法仅供 WarehouseService 和 ClaimService 内部调用
    int increaseStock(@Param("isbn") String isbn, @Param("qty") int qty);
    int decreaseStockWithCheck(@Param("isbn") String isbn, @Param("qty") int qty);
    int getStock(@Param("isbn") String isbn);

    // ❌ 绝对不提供以下方法：
    // int updateStock(@Param("isbn") String isbn, @Param("stock") int stock);
    // int setStock(@Param("isbn") String isbn, @Param("stock") int stock);
}
```

---

## 八、核心业务规则速查

| 规则 | 实现方式 |
|------|---------|
| 库存只能通过入库/出库变更 | Mapper不暴露 `updateStock` 方法 |
| 导入不修改库存 | `PurchaseServiceImpl.importExcel()` 中无库存操作 |
| 入库才加库存 | `WarehouseServiceImpl.confirmInbound()` 事务中增加 |
| 出库才减库存 | `ClaimServiceImpl.confirmIssue()` 事务中扣减 |
| 流水不可篡改 | `BookStockFlowMapper` 只有 `insert` 方法 |
| 事务保证 | `@Transactional(rollbackFor = Exception.class)` |
| 并发防超卖 | `UPDATE ... WHERE stock >= #{qty}` |
| 防重复导入 | 文件MD5 + `book_import_log` 表唯一索引 |
| 状态流转校验 | 枚举 `canTransitionTo()` 方法 |
| 数据权限隔离 | Controller层强制设置 `teacherId`/`supplierId` |
| 逻辑删除 | 所有查询加 `del_flag = '0'` |
