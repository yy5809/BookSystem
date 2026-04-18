---
name: perf
description: 教材采购与库存管理系统性能优化技能。用于诊断和优化系统性能问题，包括SQL调优、索引优化、N+1查询消除、缓存策略、异步处理、大事务拆分、前端性能优化等。针对教材采购、Excel导入、库存查询、出库并发等高频场景提供优化方案。适用于 SpringBoot 2.x + MyBatis + MySQL + Redis + Vue2 技术栈。
---

# 教材采购与库存管理系统 — 性能优化技能

## 一、性能优化概览

### 1.1 系统性能瓶颈分析

| 场景 | 瓶颈类型 | 严重程度 | 优化方向 |
|------|---------|---------|---------|
| Excel导入（1000行） | CPU + DB写入 | 🟡 高 | 批量插入、异步处理 |
| 库存列表查询 | DB查询 | 🟠 中 | 索引优化、缓存 |
| 并发出库 | DB行锁竞争 | 🔴 严重 | 乐观锁、减少锁范围 |
| 领书单列表（含明细） | N+1查询 | 🟡 高 | 批量查询、JOIN |
| 采购单状态更新 | DB事务 | 🟠 中 | 小事务、异步通知 |
| 前端页面加载 | 网络请求 | 🟠 中 | 懒加载、分页 |
| 库存流水查询 | DB全表扫描 | 🟡 高 | 索引、分表 |

---

## 二、SQL优化

### 2.1 索引优化

```sql
-- 1. 分析慢查询
SHOW VARIABLES LIKE 'slow_query_log%';
SET GLOBAL slow_query_log = 'ON';
SET GLOBAL long_query_time = 1; -- 超过1秒记录

-- 2. 使用EXPLAIN分析执行计划
EXPLAIN SELECT * FROM book_textbook WHERE isbn = '9787111544937';
-- 预期：type=const, key=uk_textbook_isbn

EXPLAIN SELECT * FROM book_purchase_order WHERE status = '0' AND del_flag = '0';
-- 预期：type=ref, key=idx_purchase_status

-- 3. 检查索引使用情况
SELECT table_name, index_name, seq_in_index, column_name
FROM information_schema.statistics
WHERE table_schema = 'ruoyi_book'
ORDER BY table_name, index_name, seq_in_index;

-- 4. 检查冗余索引
SELECT a.table_name, a.index_name, a.column_name, b.index_name AS duplicate_index
FROM information_schema.statistics a
JOIN information_schema.statistics b
ON a.table_name = b.table_name
  AND a.column_name = b.column_name
  AND a.index_name != b.index_name
WHERE a.table_schema = 'ruoyi_book'
  AND a.seq_in_index = 1 AND b.seq_in_index = 1;
```

### 2.2 N+1查询优化

```java
// ❌ 错误：N+1查询（循环中查数据库）
public List<PurchaseOrderVO> selectList(PurchaseOrderQueryDTO query) {
    List<PurchaseOrder> orders = orderMapper.selectList(query);
    for (PurchaseOrder order : orders) {
        // 每个采购单都查一次明细 → N次查询
        List<PurchaseOrderDetail> details = detailMapper.selectByOrderId(order.getOrderId());
        order.setDetails(details);
    }
    return orders;
}

// ✅ 正确：批量查询（2次查询）
public List<PurchaseOrderVO> selectList(PurchaseOrderQueryDTO query) {
    List<PurchaseOrder> orders = orderMapper.selectList(query);
    if (orders.isEmpty()) {
        return Collections.emptyList();
    }
    // 批量查询所有明细 → 1次查询
    List<Long> orderIds = orders.stream().map(PurchaseOrder::getOrderId).collect(Collectors.toList());
    List<PurchaseOrderDetail> allDetails = detailMapper.selectByOrderIds(orderIds);

    // 内存中分组
    Map<Long, List<PurchaseOrderDetail>> detailMap = allDetails.stream()
        .collect(Collectors.groupingBy(PurchaseOrderDetail::getOrderId));

    orders.forEach(order -> order.setDetails(detailMap.getOrDefault(order.getOrderId(), Collections.emptyList())));
    return orders;
}
```

```xml
<!-- Mapper XML：批量查询 -->
<select id="selectByOrderIds" resultMap="DetailResult">
    SELECT * FROM book_purchase_order_detail
    WHERE order_id IN
    <foreach collection="orderIds" item="id" open="(" separator="," close=")">
        #{id}
    </foreach>
</select>
```

### 2.3 分页查询优化

```xml
<!-- ❌ 错误：大偏移量分页（深分页性能差） -->
<select id="selectList" resultMap="TextbookResult">
    SELECT * FROM book_textbook
    WHERE del_flag = '0'
    ORDER BY create_time DESC
    LIMIT #{offset}, #{pageSize}
</select>

<!-- ✅ 正确：使用游标分页（推荐） -->
<select id="selectList" resultMap="TextbookResult">
    SELECT * FROM book_textbook
    WHERE del_flag = '0'
    <if test="lastId != null">
        AND textbook_id &lt; #{lastId}
    </if>
    ORDER BY textbook_id DESC
    LIMIT #{pageSize}
</select>

<!-- ✅ 备选：延迟关联（深分页优化） -->
<select id="selectList" resultMap="TextbookResult">
    SELECT t.* FROM book_textbook t
    INNER JOIN (
        SELECT textbook_id FROM book_textbook
        WHERE del_flag = '0'
        ORDER BY create_time DESC
        LIMIT #{offset}, #{pageSize}
    ) tmp ON t.textbook_id = tmp.textbook_id
</select>
```

### 2.4 批量插入优化

```xml
<!-- ❌ 错误：逐条插入（1000行 = 1000次INSERT） -->
<!-- 循环调用 detailMapper.insert(detail) -->

<!-- ✅ 正确：批量插入（1000行 = 1次INSERT） -->
<insert id="batchInsert" parameterType="java.util.List">
    INSERT INTO book_purchase_order_detail
    (order_id, textbook_id, isbn, book_name, purchase_qty, college_name, major_name, class_name, create_time)
    VALUES
    <foreach collection="list" item="item" separator=",">
        (#{item.orderId}, #{item.textbookId}, #{item.isbn}, #{item.bookName},
         #{item.purchaseQty}, #{item.collegeName}, #{item.majorName}, #{item.className}, NOW())
    </foreach>
</insert>
```

```java
// 批量插入（每500条一批，防止SQL过长）
public void batchInsertDetails(List<PurchaseOrderDetail> details) {
    int batchSize = 500;
    for (int i = 0; i < details.size(); i += batchSize) {
        int end = Math.min(i + batchSize, details.size());
        List<PurchaseOrderDetail> batch = details.subList(i, end);
        detailMapper.batchInsert(batch);
    }
}
```

---

## 三、缓存优化

### 3.1 Redis缓存策略

```java
/**
 * 缓存策略：
 * 1. 教材信息：读多写少，适合缓存
 * 2. 数据字典：几乎不变，适合永久缓存
 * 3. 库存数量：实时性要求高，短时间缓存
 * 4. 采购单状态：中等频率更新，中等缓存时间
 */
@Service
public class TextbookCacheServiceImpl {

    private static final String CACHE_KEY = "textbook:";
    private static final String CACHE_LIST_KEY = "textbook:list:";
    private static final int CACHE_EXPIRE = 30; // 30分钟

    @Autowired
    private RedisCache redisCache;
    @Autowired
    private BookTextbookMapper textbookMapper;

    /**
     * 查询教材详情（带缓存）
     */
    public BookTextbook selectById(Long id) {
        String key = CACHE_KEY + id;
        BookTextbook book = redisCache.getCacheObject(key);
        if (book != null) {
            return book;
        }
        book = textbookMapper.selectById(id);
        if (book != null) {
            redisCache.setCacheObject(key, book, CACHE_EXPIRE, TimeUnit.MINUTES);
        }
        return book;
    }

    /**
     * 按ISBN查询（带缓存）
     */
    public BookTextbook selectByIsbn(String isbn) {
        String key = CACHE_KEY + "isbn:" + isbn;
        BookTextbook book = redisCache.getCacheObject(key);
        if (book != null) {
            return book;
        }
        book = textbookMapper.selectByIsbn(isbn);
        if (book != null) {
            redisCache.setCacheObject(key, book, CACHE_EXPIRE, TimeUnit.MINUTES);
        }
        return book;
    }

    /**
     * 更新教材时清除缓存
     */
    public int update(BookTextbook book) {
        int rows = textbookMapper.update(book);
        if (rows > 0) {
            // 清除详情缓存
            redisCache.deleteObject(CACHE_KEY + book.getTextbookId());
            redisCache.deleteObject(CACHE_KEY + "isbn:" + book.getIsbn());
            // 清除列表缓存
            Set<String> keys = redisCache.keys(CACHE_LIST_KEY + "*");
            redisCache.deleteObject(keys);
        }
        return rows;
    }
}
```

### 3.2 库存查询缓存

```java
/**
 * 库存预警列表缓存（5分钟）
 * 库存数据实时性要求高，但预警列表可以短时间缓存
 */
public List<StockAlertVO> selectAlertList() {
    String key = "stock:alert:list";
    List<StockAlertVO> list = redisCache.getCacheObject(key);
    if (list != null) {
        return list;
    }
    list = stockMapper.selectAlertList();
    redisCache.setCacheObject(key, list, 5, TimeUnit.MINUTES);
    return list;
}
```

### 3.3 数据字典缓存

```java
/**
 * 数据字典缓存（启动时加载，永不过期）
 * RuoYi框架已内置字典缓存机制
 */
// 使用方式：
String label = dictService.selectDictLabel("book_college", collegeCode);
```

---

## 四、异步处理

### 4.1 异步通知发送

```java
/**
 * 入库/出库后的通知发送改为异步
 * 避免通知失败导致事务回滚
 */
@Configuration
@EnableAsync
public class AsyncConfig {

    @Bean("notificationExecutor")
    public Executor notificationExecutor() {
        ThreadPoolTaskExecutor executor = new ThreadPoolTaskExecutor();
        executor.setCorePoolSize(2);
        executor.setMaxPoolSize(5);
        executor.setQueueCapacity(100);
        executor.setThreadNamePrefix("notify-");
        executor.setRejectedExecutionHandler(new ThreadPoolExecutor.CallerRunsPolicy());
        executor.initialize();
        return executor;
    }
}

@Service
public class NotificationServiceImpl {

    @Async("notificationExecutor")
    public void sendInboundNoticeAsync(PurchaseOrder order) {
        try {
            // 发送通知逻辑
            sendInboundNotice(order);
        } catch (Exception e) {
            log.error("发送进书通知失败，采购单：{}", order.getOrderNo(), e);
            // 记录失败，后续补偿
        }
    }
}
```

### 4.2 Excel导入异步化（大数据量）

```java
/**
 * Excel导入超过500行时，改为异步处理
 */
@Service
public class PurchaseImportServiceImpl {

    @Async("importExecutor")
    public void asyncImport(String batchId, String username) {
        try {
            List<PurchaseImportDTO> list = redisCache.getCacheObject(batchId);
            String orderNo = confirmImport(list);

            // 更新导入状态
            redisCache.setCacheObject(batchId + "_status", "SUCCESS", 1, TimeUnit.HOURS);
            redisCache.setCacheObject(batchId + "_result", orderNo, 1, TimeUnit.HOURS);
        } catch (Exception e) {
            log.error("异步导入失败，batchId：{}", batchId, e);
            redisCache.setCacheObject(batchId + "_status", "FAILED", 1, TimeUnit.HOURS);
            redisCache.setCacheObject(batchId + "_error", e.getMessage(), 1, TimeUnit.HOURS);
        }
    }
}
```

---

## 五、大事务拆分

### 5.1 入库事务优化

```java
// ❌ 错误：事务过大（包含通知发送）
@Transactional(rollbackFor = Exception.class)
public void confirmInbound(Long orderId, InboundConfirmDTO dto) {
    // 1. 校验状态
    // 2. 增加库存
    // 3. 生成流水
    // 4. 更新采购单状态
    // 5. 更新缺书单状态
    // 6. 发送通知（可能很慢，甚至失败） ← 不应在事务中
}

// ✅ 正确：拆分事务
@Transactional(rollbackFor = Exception.class)
public void confirmInbound(Long orderId, InboundConfirmDTO dto) {
    // 核心操作（必须在事务中）
    // 1. 校验状态
    // 2. 增加库存
    // 3. 生成流水
    // 4. 更新采购单状态
    // 5. 更新缺书单状态
}

// 事务提交后执行（异步）
@Async
public void afterInbound(PurchaseOrder order) {
    // 6. 发送通知（异步，不影响主事务）
    notificationService.sendInboundNoticeAsync(order);
}
```

### 5.2 Excel导入事务优化

```java
// ❌ 错误：1000行数据在一个事务中
@Transactional(rollbackFor = Exception.class)
public void confirmImport(List<PurchaseImportDTO> list) {
    PurchaseOrder order = createOrder();
    for (PurchaseImportDTO dto : list) {
        detailMapper.insert(convertToDetail(dto)); // 1000次INSERT
    }
}

// ✅ 正确：批量插入 + 小事务
@Transactional(rollbackFor = Exception.class)
public void confirmImport(List<PurchaseImportDTO> list) {
    PurchaseOrder order = createOrder();
    // 批量插入（每500条一批）
    batchInsertDetails(list.stream().map(this::convertToDetail).collect(Collectors.toList()));
}
```

---

## 六、前端性能优化

### 6.1 列表页优化

```vue
<template>
  <!-- 1. 虚拟滚动（大数据量列表） -->
  <el-table v-loading="loading" :data="dataList" :height="tableHeight">
    <!-- ... -->
  </el-table>

  <!-- 2. 分页加载（避免一次性加载过多数据） -->
  <pagination :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />

  <!-- 3. 防抖搜索（避免频繁请求） -->
  <el-input v-model="queryParams.bookName" placeholder="教材名称" clearable @input="debounceSearch" />
</template>

<script>
import { debounce } from '@/utils'

export default {
  created() {
    // 防抖搜索：500ms内只触发一次
    this.debounceSearch = debounce(() => {
      this.queryParams.pageNum = 1
      this.getList()
    }, 500)
  }
}
</script>
```

### 6.2 路由懒加载

```javascript
// router/index.js
{
  path: '/book/purchase',
  component: Layout,
  children: [
    {
      path: 'list',
      component: () => import('@/views/book/purchase/index'), // 懒加载
      name: 'PurchaseList'
    },
    {
      path: 'import',
      component: () => import('@/views/book/purchase/import'), // 懒加载
      name: 'PurchaseImport'
    }
  ]
}
```

### 6.3 接口请求优化

```javascript
// 1. 列表页和详情页数据分离
// 不要在列表接口中返回明细数据

// 2. 并行请求（无依赖的接口同时请求）
async function loadPageData() {
  const [listRes, dictRes] = await Promise.all([
    listPurchase(this.queryParams),
    getDicts('purchase_status')
  ])
  this.dataList = listRes.rows
  this.statusDict = dictRes.data
}

// 3. 取消重复请求（切换页面时取消未完成的请求）
// 使用 Axios CancelToken
```

---

## 七、性能监控

### 7.1 慢SQL监控

```sql
-- 开启慢查询日志
SET GLOBAL slow_query_log = 'ON';
SET GLOBAL long_query_time = 1;
SET GLOBAL slow_query_log_file = '/var/log/mysql/slow.log';

-- 查看当前慢查询
SHOW VARIABLES LIKE 'slow_query%';
```

### 7.2 接口响应时间监控

```java
/**
 * 使用Spring AOP记录接口响应时间
 */
@Aspect
@Component
@Slf4j
public class PerformanceAspect {

    @Pointcut("execution(* com.ruoyi.web.controller.book..*.*(..))")
    public void bookControllerPointcut() {}

    @Around("bookControllerPointcut()")
    public Object around(ProceedingJoinPoint point) throws Throwable {
        String methodName = point.getSignature().getName();
        long startTime = System.currentTimeMillis();

        Object result = point.proceed();

        long elapsedTime = System.currentTimeMillis() - startTime;
        if (elapsedTime > 3000) {
            log.warn("慢接口：{}，耗时：{}ms", methodName, elapsedTime);
        } else if (elapsedTime > 1000) {
            log.info("接口：{}，耗时：{}ms", methodName, elapsedTime);
        }

        return result;
    }
}
```

### 7.3 JVM监控

```bash
# 查看JVM内存使用
jstat -gcutil <pid> 1000

# 查看线程状态
jstack <pid>

# 查看堆内存详情
jmap -heap <pid>

# 导出堆转储（OOM分析）
jmap -dump:format=b,file=heap.hprof <pid>
```

---

## 八、优化检查清单

| # | 检查项 | 检查方法 | 优化方案 |
|---|--------|---------|---------|
| 1 | 慢SQL | 慢查询日志 | 加索引、优化SQL |
| 2 | N+1查询 | 检查循环中的数据库调用 | 批量查询 |
| 3 | 缺失索引 | EXPLAIN分析 | 添加索引 |
| 4 | 大事务 | 检查事务范围 | 拆分事务、异步处理 |
| 5 | 无缓存 | 热点数据每次查DB | Redis缓存 |
| 6 | 逐条插入 | 检查循环INSERT | 批量INSERT |
| 7 | 深分页 | LIMIT offset过大 | 游标分页 |
| 8 | 前端大包 | webpack-bundle-analyzer | 路由懒加载 |
| 9 | 频繁请求 | 浏览器Network面板 | 防抖/节流、缓存 |
| 10 | 并发锁竞争 | 监控数据库锁等待 | 乐观锁、减少锁范围 |
