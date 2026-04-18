---
name: test
description: 教材采购与库存管理系统测试技能。用于编写和执行系统测试，包括单元测试、集成测试、业务流程测试。涵盖采购Excel导入、入库出库事务、并发超卖、权限隔离、状态流转等核心场景的测试用例设计。适用于 SpringBoot 2.x + MyBatis + MySQL + JUnit5 + Mockito 技术栈。
---

# 教材采购与库存管理系统 — 测试技能

## 一、测试规范

### 1.1 技术栈

- **单元测试**：JUnit 5 + Mockito
- **集成测试**：SpringBoot Test + MyBatis Test
- **数据库**：H2内存数据库（测试环境）或 MySQL测试库
- **断言库**：AssertJ
- **HTTP测试**：MockMvc / RestTemplate

### 1.2 测试分层

| 层次 | 测试对象 | 框架 | 覆盖率目标 |
|------|---------|------|-----------|
| 单元测试 | Service层业务逻辑 | JUnit5 + Mockito | ≥ 80% |
| 集成测试 | Controller + Mapper | SpringBoot Test | ≥ 60% |
| 接口测试 | REST API | MockMvc | 核心接口100% |
| 业务测试 | 端到端流程 | 多接口组合 | 核心流程100% |

### 1.3 测试命名规范

```java
// 格式：方法名_场景_预期结果
@Test
void confirmInbound_库存充足_入库成功();
@Test
void confirmInbound_库存为负_抛出异常();
@Test
void importExcel_ISBN不存在_标记失败行();
@Test
void confirmIssue_并发出库_库存不为负();
```

---

## 二、单元测试

### 2.1 采购管理测试

```java
@ExtendWith(MockitoExtension.class)
class PurchaseServiceTest {

    @Mock
    private PurchaseOrderMapper orderMapper;
    @Mock
    private PurchaseOrderDetailMapper detailMapper;
    @Mock
    private TextbookMapper textbookMapper;
    @Mock
    private BookShortageMapper shortageMapper;
    @Mock
    private BookImportLogMapper importLogMapper;

    @InjectMocks
    private PurchaseServiceImpl purchaseService;

    // --- Excel导入测试 ---

    @Test
    @DisplayName("导入成功：所有行校验通过，返回成功结果")
    void importExcel_全部校验通过_返回成功结果() {
        // 准备数据
        MultipartFile file = mock(MultipartFile.class);
        List<PurchaseImportDTO> list = new ArrayList<>();
        list.add(createImportDTO("9787111544937", "Java核心技术", 50, "计算机学院", "计科", "计科2301"));
        list.add(createImportDTO("9787040123456", "高等数学", 100, "理学院", "数学", "数学2301"));

        when(textbookMapper.selectByIsbn("9787111544937")).thenReturn(createTextbook());
        when(textbookMapper.selectByIsbn("9787040123456")).thenReturn(createTextbook());

        // 执行
        ImportResult result = purchaseService.parseAndValidate(file, list);

        // 验证
        assertThat(result.getSuccessCount()).isEqualTo(2);
        assertThat(result.getFailCount()).isEqualTo(0);
        assertThat(result.getErrorList()).isEmpty();
    }

    @Test
    @DisplayName("导入失败：ISBN不存在，标记失败行但不阻断其他行")
    void importExcel_ISBN不存在_标记失败行() {
        MultipartFile file = mock(MultipartFile.class);
        List<PurchaseImportDTO> list = new ArrayList<>();
        list.add(createImportDTO("9787111544937", "Java核心技术", 50, "计算机学院", "计科", "计科2301"));
        list.add(createImportDTO("9999999999999", "不存在的书", 10, "计算机学院", "计科", "计科2301")); // ISBN不存在
        list.add(createImportDTO("9787040123456", "高等数学", 100, "理学院", "数学", "数学2301"));

        when(textbookMapper.selectByIsbn("9787111544937")).thenReturn(createTextbook());
        when(textbookMapper.selectByIsbn("9999999999999")).thenReturn(null); // 不存在
        when(textbookMapper.selectByIsbn("9787040123456")).thenReturn(createTextbook());

        ImportResult result = purchaseService.parseAndValidate(file, list);

        assertThat(result.getSuccessCount()).isEqualTo(2);
        assertThat(result.getFailCount()).isEqualTo(1);
        assertThat(result.getErrorList().get(0).getRowNum()).isEqualTo(2);
        assertThat(result.getErrorList().get(0).getReason()).contains("ISBN在系统中不存在");
    }

    @Test
    @DisplayName("导入失败：采购数量为0，标记失败行")
    void importExcel_数量为0_标记失败行() {
        MultipartFile file = mock(MultipartFile.class);
        List<PurchaseImportDTO> list = new ArrayList<>();
        list.add(createImportDTO("9787111544937", "Java核心技术", 0, "计算机学院", "计科", "计科2301")); // 数量为0

        ImportResult result = purchaseService.parseAndValidate(file, list);

        assertThat(result.getFailCount()).isEqualTo(1);
        assertThat(result.getErrorList().get(0).getReason()).contains("采购数量必须为正整数");
    }

    @Test
    @DisplayName("导入失败：同一文件重复导入")
    void importExcel_文件已导入_抛出异常() {
        MultipartFile file = mock(MultipartFile.class);
        when(importLogMapper.countByMd5(anyString())).thenReturn(1); // 已存在

        assertThatThrownBy(() -> purchaseService.importExcel(file))
            .isInstanceOf(ServiceException.class)
            .hasMessageContaining("该文件已导入过");
    }

    @Test
    @DisplayName("导入不修改库存：验证导入过程中没有调用库存更新方法")
    void importExcel_不应修改库存() {
        MultipartFile file = mock(MultipartFile.class);
        List<PurchaseImportDTO> list = new ArrayList<>();
        list.add(createImportDTO("9787111544937", "Java核心技术", 50, "计算机学院", "计科", "计科2301"));

        when(textbookMapper.selectByIsbn(anyString())).thenReturn(createTextbook());
        when(importLogMapper.countByMd5(anyString())).thenReturn(0);

        purchaseService.confirmImport(list);

        // 验证：绝对没有调用任何库存更新方法
        verify(textbookMapper, never()).updateStock(anyString(), anyInt());
        verify(textbookMapper, never()).increaseStock(anyString(), anyInt());
    }

    // --- 状态流转测试 ---

    @Test
    @DisplayName("状态流转：待采购→采购中→已到货→已入库（正常流程）")
    void statusFlow_正常流程_成功() {
        Long orderId = 1L;
        when(orderMapper.selectById(orderId)).thenReturn(createOrder("0"));

        purchaseService.updateStatus(orderId, "1"); // 待采购→采购中
        verify(orderMapper).updateStatus(orderId, "1");

        when(orderMapper.selectById(orderId)).thenReturn(createOrder("1"));
        purchaseService.updateStatus(orderId, "2"); // 采购中→已到货
        verify(orderMapper).updateStatus(orderId, "2");

        when(orderMapper.selectById(orderId)).thenReturn(createOrder("2"));
        purchaseService.updateStatus(orderId, "3"); // 已到货→已入库
        verify(orderMapper).updateStatus(orderId, "3");
    }

    @Test
    @DisplayName("状态流转：待采购直接跳到已入库，应抛出异常")
    void statusFlow_跳转_抛出异常() {
        Long orderId = 1L;
        when(orderMapper.selectById(orderId)).thenReturn(createOrder("0"));

        assertThatThrownBy(() -> purchaseService.updateStatus(orderId, "3"))
            .isInstanceOf(ServiceException.class)
            .hasMessageContaining("不允许从");
    }

    @Test
    @DisplayName("已入库采购单禁止编辑")
    void editOrder_已入库_抛出异常() {
        PurchaseOrderDTO dto = new PurchaseOrderDTO();
        dto.setOrderId(1L);
        when(orderMapper.selectById(1L)).thenReturn(createOrder("3")); // 已入库

        assertThatThrownBy(() -> purchaseService.updateOrder(dto))
            .isInstanceOf(ServiceException.class)
            .hasMessageContaining("已入库");
    }
}
```

---

### 2.2 入库管理测试

```java
@ExtendWith(MockitoExtension.class)
class WarehouseServiceTest {

    @Mock private PurchaseOrderMapper orderMapper;
    @Mock private PurchaseOrderDetailMapper detailMapper;
    @Mock private TextbookMapper textbookMapper;
    @Mock private BookStockFlowMapper flowMapper;
    @Mock private BookShortageMapper shortageMapper;
    @Mock private NotificationService notificationService;

    @InjectMocks
    private WarehouseServiceImpl warehouseService;

    @Test
    @DisplayName("入库成功：库存增加 + 流水生成 + 状态更新 + 通知发送")
    void confirmInbound_正常入库_全部操作执行() {
        Long orderId = 1L;
        PurchaseOrder order = createOrder("2"); // 已到货
        List<PurchaseOrderDetail> details = createDetails();

        when(orderMapper.selectById(orderId)).thenReturn(order);
        when(detailMapper.selectByOrderId(orderId)).thenReturn(details);
        when(textbookMapper.getStock("9787111544937")).thenReturn(0);
        when(textbookMapper.increaseStock(anyString(), anyInt())).thenReturn(1);

        InboundConfirmDTO dto = createInboundDTO();
        warehouseService.confirmInbound(orderId, dto);

        // 验证库存增加
        verify(textbookMapper).increaseStock("9787111544937", 50);

        // 验证流水生成
        verify(flowMapper).insert(argThat(flow ->
            flow.getBusinessType().equals("1") &&
            flow.getChangeQty() == 50 &&
            flow.getStockBefore() == 0 &&
            flow.getStockAfter() == 50
        ));

        // 验证采购单状态更新
        verify(orderMapper).updateStatus(orderId, "3");

        // 验证通知发送
        verify(notificationService).sendInboundNotice(any());
    }

    @Test
    @DisplayName("入库失败：采购单状态不是已到货，应抛出异常")
    void confirmInbound_状态不是已到货_抛出异常() {
        Long orderId = 1L;
        when(orderMapper.selectById(orderId)).thenReturn(createOrder("1")); // 采购中

        assertThatThrownBy(() -> warehouseService.confirmInbound(orderId, new InboundConfirmDTO()))
            .isInstanceOf(ServiceException.class)
            .hasMessageContaining("已到货");
    }
}
```

---

### 2.3 出库管理测试

```java
@ExtendWith(MockitoExtension.class)
class ClaimServiceTest {

    @Mock private BookClaimFormMapper formMapper;
    @Mock private BookClaimFormDetailMapper detailMapper;
    @Mock private TextbookMapper textbookMapper;
    @Mock private BookStockFlowMapper flowMapper;
    @Mock private BookNoticeMapper noticeMapper;

    @InjectMocks
    private ClaimServiceImpl claimService;

    @Test
    @DisplayName("出库成功：库存扣减 + 流水生成 + 状态更新")
    void confirmIssue_正常出库_全部操作执行() {
        IssueConfirmDTO dto = new IssueConfirmDTO();
        dto.setFormId(1L);
        dto.setReceiverName("张三");
        dto.setDetails(List.of(new IssueDetailDTO(1L, 30)));

        BookClaimForm form = createForm("0"); // 待领取
        form.setPlannedQty(50);
        form.setIssuedQty(0);

        when(formMapper.selectById(1L)).thenReturn(form);
        when(textbookMapper.getStock("9787111544937")).thenReturn(100);
        when(textbookMapper.decreaseStock("9787111544937", 30)).thenReturn(1);

        claimService.confirmIssue(dto);

        // 验证库存扣减
        verify(textbookMapper).decreaseStock("9787111544937", 30);

        // 验证流水生成（出库为负数）
        verify(flowMapper).insert(argThat(flow ->
            flow.getChangeQty() == -30 &&
            flow.getStockBefore() == 100 &&
            flow.getStockAfter() == 70
        ));

        // 验证领书单状态：部分出库
        verify(formMapper).updateById(argThat(f ->
            f.getStatus().equals("1") && f.getIssuedQty() == 30
        ));
    }

    @Test
    @DisplayName("分批出库：第一次30本（部分出库），第二次20本（全部出库）")
    void confirmIssue_分批出库_状态正确流转() {
        // 第一次出库：30本
        BookClaimForm form = createForm("0");
        form.setPlannedQty(50);
        form.setIssuedQty(0);
        when(formMapper.selectById(1L)).thenReturn(form);
        when(textbookMapper.getStock(anyString())).thenReturn(100);
        when(textbookMapper.decreaseStock(anyString(), anyInt())).thenReturn(1);

        IssueConfirmDTO dto1 = new IssueConfirmDTO();
        dto1.setFormId(1L);
        dto1.setReceiverName("张三");
        dto1.setDetails(List.of(new IssueDetailDTO(1L, 30)));
        claimService.confirmIssue(dto1);

        // 验证状态为"部分出库"
        verify(formMapper).updateById(argThat(f -> f.getStatus().equals("1")));

        // 第二次出库：20本
        form.setIssuedQty(30);
        when(formMapper.selectById(1L)).thenReturn(form);
        IssueConfirmDTO dto2 = new IssueConfirmDTO();
        dto2.setFormId(1L);
        dto2.setReceiverName("李四");
        dto2.setDetails(List.of(new IssueDetailDTO(1L, 20)));
        claimService.confirmIssue(dto2);

        // 验证状态为"已出库"
        verify(formMapper).updateById(argThat(f -> f.getStatus().equals("2")));
    }

    @Test
    @DisplayName("出库失败：库存不足，应抛出异常")
    void confirmIssue_库存不足_抛出异常() {
        IssueConfirmDTO dto = new IssueConfirmDTO();
        dto.setFormId(1L);
        dto.setDetails(List.of(new IssueDetailDTO(1L, 100)));

        BookClaimForm form = createForm("0");
        when(formMapper.selectById(1L)).thenReturn(form);
        when(textbookMapper.getStock(anyString())).thenReturn(50); // 库存只有50
        when(textbookMapper.decreaseStock(anyString(), anyInt())).thenReturn(0); // 扣减失败

        assertThatThrownBy(() -> claimService.confirmIssue(dto))
            .isInstanceOf(ServiceException.class)
            .hasMessageContaining("库存不足");
    }

    @Test
    @DisplayName("出库失败：实发数量超过应发数量")
    void confirmIssue_超过应发数量_抛出异常() {
        IssueConfirmDTO dto = new IssueConfirmDTO();
        dto.setFormId(1L);
        dto.setDetails(List.of(new IssueDetailDTO(1L, 60))); // 应发50，实发60

        BookClaimForm form = createForm("0");
        form.setPlannedQty(50);
        form.setIssuedQty(0);
        when(formMapper.selectById(1L)).thenReturn(form);

        assertThatThrownBy(() -> claimService.confirmIssue(dto))
            .isInstanceOf(ServiceException.class)
            .hasMessageContaining("超过应发数量");
    }
}
```

---

### 2.4 权限隔离测试

```java
@ExtendWith(MockitoExtension.class)
class PermissionTest {

    @Mock private BookPersonalApplyMapper applyMapper;
    @Mock private PurchaseOrderMapper orderMapper;

    @InjectMocks
    private PersonalApplyServiceImpl personalService;

    @Test
    @DisplayName("教师查询：只能看到本人数据")
    void teacherQuery_只能看本人数据() {
        Long teacherId = 100L;
        PersonalApplyQueryDTO query = new PersonalApplyQueryDTO();
        query.setTeacherId(teacherId);

        personalService.selectList(query);

        // 验证Mapper查询参数包含teacher_id
        verify(applyMapper).selectList(argThat(q -> q.getTeacherId().equals(teacherId)));
    }

    @Test
    @DisplayName("教师取消申请：只能取消自己的待审核申请")
    void cancelApply_非本人申请_抛出异常() {
        Long applyId = 1L;
        BookPersonalApply apply = new BookPersonalApply();
        apply.setApplyId(applyId);
        apply.setTeacherId(200L); // 申请人是200
        apply.setStatus("0");

        when(applyMapper.selectById(applyId)).thenReturn(apply);
        // SecurityUtils.getUserId() 返回 100L（当前登录用户）

        assertThatThrownBy(() -> personalService.cancelApply(applyId))
            .isInstanceOf(ServiceException.class)
            .hasMessageContaining("无权操作");
    }

    @Test
    @DisplayName("教师取消申请：已审核的申请不能取消")
    void cancelApply_已审核_抛出异常() {
        Long applyId = 1L;
        BookPersonalApply apply = new BookPersonalApply();
        apply.setApplyId(applyId);
        apply.setTeacherId(100L);
        apply.setStatus("1"); // 已通过

        when(applyMapper.selectById(applyId)).thenReturn(apply);

        assertThatThrownBy(() -> personalService.cancelApply(applyId))
            .isInstanceOf(ServiceException.class)
            .hasMessageContaining("待审核");
    }
}
```

---

## 三、并发测试

### 3.1 并发出库防超卖测试

```java
@SpringBootTest
@ThreadCount(10)
class ConcurrencyTest {

    @Autowired
    private ClaimService claimService;

    @Test
    @DisplayName("并发出库：10个线程同时出库，库存不能为负数")
    void concurrentIssue_库存不为负() {
        String isbn = "9787111544937";
        int initialStock = 50;
        int issueQtyPerThread = 10;
        int threadCount = 10;

        // 初始化库存
        textbookMapper.initStock(isbn, initialStock);

        // 10个线程同时出库
        ExecutorService executor = Executors.newFixedThreadPool(threadCount);
        CountDownLatch latch = new CountDownLatch(threadCount);
        AtomicInteger successCount = new AtomicInteger(0);
        AtomicInteger failCount = new AtomicInteger(0);

        for (int i = 0; i < threadCount; i++) {
            executor.submit(() -> {
                try {
                    latch.countDown();
                    latch.await();
                    IssueConfirmDTO dto = new IssueConfirmDTO();
                    dto.setFormId(1L);
                    dto.setDetails(List.of(new IssueDetailDTO(1L, issueQtyPerThread)));
                    claimService.confirmIssue(dto);
                    successCount.incrementAndGet();
                } catch (ServiceException e) {
                    failCount.incrementAndGet();
                }
            });
        }

        executor.shutdown();
        executor.awaitTermination(10, TimeUnit.SECONDS);

        // 验证：库存 >= 0
        int finalStock = textbookMapper.getStock(isbn);
        assertThat(finalStock).isGreaterThanOrEqualTo(0);

        // 验证：成功次数 + 失败次数 = 线程数
        assertThat(successCount.get() + failCount.get()).isEqualTo(threadCount);

        // 验证：库存 = 初始库存 - 成功出库数量
        assertThat(finalStock).isEqualTo(initialStock - successCount.get() * issueQtyPerThread);
    }
}
```

---

## 四、集成测试

### 4.1 Controller层测试

```java
@SpringBootTest
@AutoConfigureMockMvc
@Transactional
class PurchaseControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @Test
    @WithMockUser(username = "admin", authorities = {"purchase:list"})
    @DisplayName("GET /api/purchase/list - 查询采购单列表")
    void list_正常查询_返回分页数据() throws Exception {
        mockMvc.perform(get("/api/purchase/list")
                .param("status", "0")
                .param("pageNum", "1")
                .param("pageSize", "10"))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.code").value(200))
            .andExpect(jsonPath("$.rows").isArray());
    }

    @Test
    @WithMockUser(username = "admin", authorities = {"purchase:add"})
    @DisplayName("POST /api/purchase - 手动创建采购单")
    void add_正常创建_返回成功() throws Exception {
        String json = """
            {
                "supplierId": 1,
                "responsible": "张库管",
                "details": [
                    {"textbookId": 1, "isbn": "9787111544937", "purchaseQty": 50}
                ]
            }
            """;

        mockMvc.perform(post("/api/purchase")
                .contentType(MediaType.APPLICATION_JSON)
                .content(json))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.code").value(200));
    }

    @Test
    @WithMockUser(username = "teacher", authorities = {})
    @DisplayName("GET /api/purchase/list - 教师无权限访问")
    void list_无权限_返回403() throws Exception {
        mockMvc.perform(get("/api/purchase/list"))
            .andExpect(status().isForbidden());
    }
}
```

---

## 五、业务流程测试用例清单

### 5.1 采购流程

| # | 用例 | 前置条件 | 操作步骤 | 预期结果 |
|---|------|---------|---------|---------|
| T01 | Excel导入成功 | 教材已录入 | 上传正确格式的Excel | 生成采购单，状态为待采购 |
| T02 | Excel导入部分失败 | 教材部分ISBN不存在 | 上传含无效ISBN的Excel | 返回成功/失败行，不阻断 |
| T03 | Excel导入重复文件 | 文件已导入过 | 再次上传同一文件 | 提示"已导入过" |
| T04 | Excel导入不修改库存 | 库存为0 | 导入采购单 | 库存仍为0 |
| T05 | 手动创建采购单 | 供应商已存在 | 填写信息提交 | 生成采购单 |
| T06 | 状态正常流转 | 采购单待采购 | 依次推进状态 | 0→1→2→3 |
| T07 | 状态跳转被拒绝 | 采购单待采购 | 直接改为已入库 | 抛出异常 |
| T08 | 已入库禁止编辑 | 采购单已入库 | 尝试编辑 | 抛出异常 |

### 5.2 入库流程

| # | 用例 | 前置条件 | 操作步骤 | 预期结果 |
|---|------|---------|---------|---------|
| T09 | 入库成功 | 采购单已到货 | 确认入库 | 库存增加、流水生成、状态变为已入库 |
| T10 | 入库事务回滚 | 入库过程中异常 | 模拟异常 | 库存不变、无流水、状态不变 |
| T11 | 非已到货不能入库 | 采购单采购中 | 尝试入库 | 抛出异常 |
| T12 | 入库后通知供应商 | 采购单已入库 | 确认入库 | 供应商收到进书通知 |
| T13 | 入库后更新缺书单 | 缺书单已纳入采购 | 确认入库 | 缺书单状态变为已完成 |

### 5.3 领书流程

| # | 用例 | 前置条件 | 操作步骤 | 预期结果 |
|---|------|---------|---------|---------|
| T14 | 发布领书通知 | 教材已入库 | 创建并发布通知 | 自动生成领书单 |
| T15 | 库存不足不能发布 | 库存不够 | 尝试发布 | 提示差额 |
| T16 | 出库成功 | 领书单待领取 | 确认出库 | 库存扣减、流水生成、状态更新 |
| T17 | 分批出库 | 领书单50本 | 第一次30本 | 状态为部分出库 |
| T18 | 分批出库完成 | 已出30本 | 再出20本 | 状态为已出库 |
| T19 | 并发出库防超卖 | 库存50本 | 10线程各出10本 | 库存≥0 |
| T20 | 出库数量超限 | 应发50本 | 实发60本 | 抛出异常 |

### 5.4 个人领书流程

| # | 用例 | 前置条件 | 操作步骤 | 预期结果 |
|---|------|---------|---------|---------|
| T21 | 提交申请 | 教材库存充足 | 提交领书申请 | 状态为待审核 |
| T22 | 审核通过 | 申请待审核 | 库管员审核通过 | 状态为已通过，教师收到通知 |
| T23 | 审核驳回 | 库存不足 | 库管员驳回 | 状态为已驳回，教师收到通知 |
| T24 | 取消申请 | 申请待审核 | 教师取消 | 状态变为已取消 |
| T25 | 已审核不能取消 | 申请已通过 | 教师尝试取消 | 抛出异常 |
| T26 | 教师数据隔离 | 两个教师 | 教师A查询 | 只看到A的申请 |

### 5.5 缺书流程

| # | 用例 | 前置条件 | 操作步骤 | 预期结果 |
|---|------|---------|---------|---------|
| T27 | 登记缺书 | 教材脱销 | 填写缺书信息 | 状态为未处理，库管员收到通知 |
| T28 | 同ISBN合并 | 已有缺书记录 | 再登记同一ISBN | 数量累加，不新增记录 |
| T29 | 转采购单 | 缺书单未处理 | 一键转采购 | 生成采购单，缺书单状态变为已纳入采购 |
| T30 | 入库后缺书完成 | 缺书已纳入采购 | 采购入库 | 缺书单状态变为已完成 |
