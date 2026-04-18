---
name: excel
description: 教材采购与库存管理系统Excel导入导出技能。用于设计和实现系统的Excel功能，包括采购单Excel导入（核心功能）、教材信息导入导出、领书单打印导出。涵盖模板设计、列映射规则、校验逻辑、两阶段导入流程、错误处理。适用于 Apache POI + EasyExcel + RuoYi ExcelUtil 技术栈。
---

# 教材采购与库存管理系统 — Excel导入导出技能

## 一、Excel功能概述

### 1.1 系统中的Excel场景

| 场景 | 类型 | 说明 | 优先级 |
|------|------|------|--------|
| 采购单导入 | 导入 | 教务处Excel导入生成采购单（核心功能） | 🔴 最高 |
| 教材信息导入 | 导入 | 批量导入教材基础信息 | 🟡 高 |
| 教材信息导出 | 导出 | 导出教材列表 | 🟡 高 |
| 领书单导出 | 导出 | 导出/打印领书单（含签名栏） | 🟡 高 |
| 库存报表导出 | 导出 | 导出库存统计报表 | 🟠 中 |
| 采购导入模板 | 下载 | 下载固定格式的导入模板 | 🟡 高 |

### 1.2 技术选型

- **RuoYi ExcelUtil**：基于 POI 封装，适用于简单导入导出
- **EasyExcel**（推荐）：阿里巴巴开源，内存占用低，适合大数据量
- **Apache POI**：底层库，灵活但内存占用高

---

## 二、采购单Excel导入（核心功能）

### 2.1 导入模板设计

**模板文件名**：`教材采购导入模板.xlsx`

**固定列定义（顺序不可变）：**

| 列序 | 字段名 | 必填 | 数据类型 | 校验规则 | 宽度 |
|------|--------|------|---------|---------|------|
| A (0) | ISBN | 是 | 文本 | 10位或13位数字，系统中必须存在 | 20 |
| B (1) | 教材名称 | 是 | 文本 | 与系统记录一致（仅校验，不覆盖） | 30 |
| C (2) | 采购数量 | 是 | 整数 | 1-9999的正整数 | 12 |
| D (3) | 申请学院 | 是 | 文本 | 必须在数据字典中存在 | 20 |
| E (4) | 申请专业 | 是 | 文本 | 必须在数据字典中存在 | 20 |
| F (5) | 适用班级 | 否 | 文本 | 如"计科2301、2302" | 25 |
| G (6) | 备注 | 否 | 文本 | 最多200字 | 30 |

**模板样式要求：**
- 第1行为表头，背景色浅蓝，字体加粗
- ISBN列设置为文本格式（防止长数字被Excel自动转为科学计数法）
- 采购数量列设置为整数格式
- 冻结首行
- 添加数据验证（学院/专业列使用下拉列表）

### 2.2 生成模板代码

```java
/**
 * 生成采购导入模板
 */
public void generateImportTemplate(HttpServletResponse response) {
    // 方法一：使用RuoYi ExcelUtil
    ExcelUtil<PurchaseImportDTO> util = new ExcelUtil<>(PurchaseImportDTO.class);
    util.importTemplateExcel(response, "教材采购导入模板");

    // 方法二：使用EasyExcel自定义模板
    response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
    response.setHeader("Content-Disposition", "attachment;filename=purchase_template.xlsx");

    EasyExcel.write(response.getOutputStream(), PurchaseImportDTO.class)
        .sheet("采购导入")
        .registerWriteHandler(new LongestMatchColumnWidthStyleStrategy())
        .doWrite(new ArrayList<>()); // 写空数据，只生成表头
}
```

### 2.3 DTO定义（列映射）

```java
/**
 * 采购导入DTO - 使用固定列索引映射（不按表头名称匹配）
 */
public class PurchaseImportDTO {

    /** 第1列(A)：ISBN */
    @ExcelProperty(index = 0, value = "ISBN")
    @NotBlank(message = "ISBN不能为空")
    @Pattern(regexp = "^(\\d{10}|\\d{13})$", message = "ISBN格式不正确")
    private String isbn;

    /** 第2列(B)：教材名称 */
    @ExcelProperty(index = 1, value = "教材名称")
    @NotBlank(message = "教材名称不能为空")
    private String bookName;

    /** 第3列(C)：采购数量 */
    @ExcelProperty(index = 2, value = "采购数量")
    @NotNull(message = "采购数量不能为空")
    @Min(value = 1, message = "采购数量必须大于0")
    @Max(value = 9999, message = "采购数量不能超过9999")
    private Integer purchaseQty;

    /** 第4列(D)：申请学院 */
    @ExcelProperty(index = 3, value = "申请学院")
    @NotBlank(message = "申请学院不能为空")
    private String collegeName;

    /** 第5列(E)：申请专业 */
    @ExcelProperty(index = 4, value = "申请专业")
    @NotBlank(message = "申请专业不能为空")
    private String majorName;

    /** 第6列(F)：适用班级（可选） */
    @ExcelProperty(index = 5, value = "适用班级")
    private String className;

    /** 第7列(G)：备注（可选） */
    @ExcelProperty(index = 6, value = "备注")
    private String remark;

    // 以下为非Excel字段，用于导入过程中存储校验结果
    @ExcelIgnore
    private boolean valid = true;

    @ExcelIgnore
    private String errorMsg;

    @ExcelIgnore
    private Long textbookId; // 校验通过后填充
}
```

### 2.4 两阶段导入流程

```
阶段一：上传校验（不写数据库）
  ├─ 前端校验（文件格式、大小、行数）
  ├─ 后端解析Excel（按固定列索引读取）
  ├─ 逐行校验（ISBN/数量/学院/专业）
  ├─ 返回校验结果（成功数/失败数/失败原因）
  └─ 前端展示预览（失败行标红）

阶段二：确认导入（写数据库）
  ├─ 前端发送确认请求（携带batchId）
  ├─ 后端从缓存/临时表读取校验通过的数据
  ├─ @Transactional 事务执行：
  │   ├─ 生成采购主单
  │   ├─ 逐行生成采购明细
  │   ├─ 关联缺书单
  │   ├─ 记录导入日志（含MD5）
  │   └─ 绝不修改库存
  └─ 返回采购单号
```

### 2.5 阶段一：上传校验实现

```java
@Service
public class PurchaseImportServiceImpl {

    @Autowired
    private TextbookMapper textbookMapper;
    @Autowired
    private DictService dictService;
    @Autowired
    private RedisCache redisCache;

    /**
     * 阶段一：上传并校验Excel
     */
    public ImportResult uploadAndValidate(MultipartFile file) {
        // 1. 前端校验（Controller层已完成，这里做后端兜底）
        validateFile(file);

        // 2. 解析Excel
        List<PurchaseImportDTO> dataList = parseExcel(file);

        // 3. 逐行校验
        ImportResult result = validateRows(dataList);

        // 4. 将校验通过的数据存入Redis（临时，30分钟过期）
        String batchId = "batch_" + System.currentTimeMillis();
        List<PurchaseImportDTO> successList = dataList.stream()
            .filter(PurchaseImportDTO::isValid)
            .collect(Collectors.toList());
        redisCache.setCacheObject(batchId, successList, 30, TimeUnit.MINUTES);

        result.setBatchId(batchId);
        return result;
    }

    private void validateFile(MultipartFile file) {
        if (file == null || file.isEmpty()) {
            throw new ServiceException("请选择要导入的文件");
        }
        String filename = file.getOriginalFilename();
        if (filename == null || (!filename.endsWith(".xlsx") && !filename.endsWith(".xls"))) {
            throw new ServiceException("文件格式不正确，仅支持 .xlsx 或 .xls");
        }
        if (file.getSize() > 10 * 1024 * 1024) { // 10MB
            throw new ServiceException("文件大小不能超过10MB");
        }
    }

    private List<PurchaseImportDTO> parseExcel(MultipartFile file) {
        try {
            // 使用EasyExcel按固定列索引读取
            return EasyExcel.read(file.getInputStream())
                .head(PurchaseImportDTO.class)
                .sheet()
                .headRowNumber(1) // 第1行为表头
                .doReadSync();
        } catch (Exception e) {
            throw new ServiceException("Excel文件解析失败：" + e.getMessage());
        }
    }

    private ImportResult validateRows(List<PurchaseImportDTO> dataList) {
        ImportResult result = new ImportResult();
        result.setTotal(dataList.size());

        for (int i = 0; i < dataList.size(); i++) {
            PurchaseImportDTO dto = dataList.get(i);
            int rowNum = i + 2; // Excel行号（第1行是表头，数据从第2行开始）

            try {
                // 校验1：ISBN格式
                if (!dto.getIsbn().matches("^(\\d{10}|\\d{13})$")) {
                    throw new ServiceException("ISBN格式不正确，必须为10位或13位数字");
                }

                // 校验2：ISBN在系统中存在
                Textbook textbook = textbookMapper.selectByIsbn(dto.getIsbn());
                if (textbook == null) {
                    throw new ServiceException("ISBN[" + dto.getIsbn() + "]在系统中不存在");
                }
                dto.setTextbookId(textbook.getTextbookId());

                // 校验3：教材名称一致性（仅校验，不覆盖）
                if (!textbook.getBookName().equals(dto.getBookName())) {
                    throw new ServiceException("教材名称不一致，系统记录为[" + textbook.getBookName() + "]");
                }

                // 校验4：采购数量
                if (dto.getPurchaseQty() == null || dto.getPurchaseQty() < 1 || dto.getPurchaseQty() > 9999) {
                    throw new ServiceException("采购数量必须为1-9999的正整数");
                }

                // 校验5：学院在字典中存在
                if (!dictService.existsDict("book_college", dto.getCollegeName())) {
                    throw new ServiceException("申请学院[" + dto.getCollegeName() + "]不在系统字典中");
                }

                // 校验6：专业在字典中存在
                if (!dictService.existsDict("book_major", dto.getMajorName())) {
                    throw new ServiceException("申请专业[" + dto.getMajorName() + "]不在系统字典中");
                }

                dto.setValid(true);
                result.incrementSuccess();

            } catch (Exception e) {
                dto.setValid(false);
                dto.setErrorMsg(e.getMessage());
                result.addError(rowNum, dto.getIsbn(), e.getMessage());
                result.incrementFail();
            }
        }

        return result;
    }
}
```

### 2.6 阶段二：确认导入实现

```java
@Service
public class PurchaseImportServiceImpl {

    /**
     * 阶段二：确认导入
     */
    @Transactional(rollbackFor = Exception.class)
    public String confirmImport(String batchId) {
        // 1. 从Redis获取校验通过的数据
        List<PurchaseImportDTO> successList = redisCache.getCacheObject(batchId);
        if (successList == null || successList.isEmpty()) {
            throw new ServiceException("导入数据已过期，请重新上传");
        }

        // 2. 防重复校验
        String md5 = (String) redisCache.getCacheObject(batchId + "_md5");
        if (importLogMapper.countByMd5(md5) > 0) {
            throw new ServiceException("该文件已导入过，请勿重复导入");
        }

        // 3. 生成采购主单
        PurchaseOrder order = new PurchaseOrder();
        order.setOrderNo(generateOrderNo()); // CG + yyyyMMddHHmmss + 3位序号
        order.setStatus("0"); // 待采购
        order.setOrderType("0"); // Excel导入
        order.setTotalQty(successList.stream().mapToInt(PurchaseImportDTO::getPurchaseQty).sum());
        orderMapper.insert(order);

        // 4. 逐行生成采购明细
        for (PurchaseImportDTO dto : successList) {
            PurchaseOrderDetail detail = new PurchaseOrderDetail();
            detail.setOrderId(order.getOrderId());
            detail.setTextbookId(dto.getTextbookId());
            detail.setIsbn(dto.getIsbn());
            detail.setBookName(dto.getBookName());
            detail.setPurchaseQty(dto.getPurchaseQty());
            detail.setCollegeName(dto.getCollegeName());
            detail.setMajorName(dto.getMajorName());
            detail.setClassName(dto.getClassName());
            detail.setRemark(dto.getRemark());
            detailMapper.insert(detail);
        }

        // 5. 自动关联缺书单
        linkShortageOrders(successList, order.getOrderId());

        // 6. 记录导入日志
        BookImportLog log = new BookImportLog();
        log.setFileName((String) redisCache.getCacheObject(batchId + "_filename"));
        log.setFileMd5(md5);
        log.setTotalCount(successList.size());
        log.setSuccessCount(successList.size());
        log.setOrderNo(order.getOrderNo());
        log.setOperator(SecurityUtils.getUsername());
        importLogMapper.insert(log);

        // 7. 清理Redis缓存
        redisCache.deleteObject(batchId);
        redisCache.deleteObject(batchId + "_md5");
        redisCache.deleteObject(batchId + "_filename");

        // 8. 绝对没有库存更新操作！
        return order.getOrderNo();
    }

    /**
     * 关联同ISBN的未处理缺书单
     */
    private void linkShortageOrders(List<PurchaseImportDTO> list, Long orderId) {
        Set<String> isbnSet = list.stream()
            .map(PurchaseImportDTO::getIsbn)
            .collect(Collectors.toSet());

        for (String isbn : isbnSet) {
            List<BookShortage> shortages = shortageMapper.selectByIsbnAndStatus(isbn, "0");
            for (BookShortage shortage : shortages) {
                shortage.setStatus("1"); // 已纳入采购
                shortage.setPurchaseOrderId(orderId);
                shortageMapper.updateById(shortage);
            }
        }
    }
}
```

---

## 三、教材信息导入导出

### 3.1 教材信息导出

```java
/**
 * 导出教材列表
 */
public class TextbookVO {
    @ExcelProperty("ISBN")
    private String isbn;

    @ExcelProperty("教材名称")
    private String bookName;

    @ExcelProperty("作者")
    private String author;

    @ExcelProperty("出版社")
    private String publisher;

    @ExcelProperty("版次")
    private String edition;

    @ExcelProperty("出版时间")
    @DateTimeFormat("yyyy-MM-dd")
    private Date publishDate;

    @ExcelProperty("定价")
    @NumberFormat("#.00")
    private BigDecimal price;

    @ExcelProperty("当前库存")
    private Integer stock;

    @ExcelProperty("预警阈值")
    private Integer alertThreshold;

    @ExcelProperty("教材类型")
    @ExcelDictFormat(dictType = "book_type") // RuoYi字典注解
    private String bookType;

    @ExcelProperty("适用课程")
    private String courseName;
}
```

### 3.2 教材信息导入

```java
/**
 * 教材信息导入DTO
 */
public class TextbookImportDTO {
    @ExcelProperty("ISBN")
    @NotBlank(message = "ISBN不能为空")
    @Pattern(regexp = "^(\\d{10}|\\d{13})$")
    private String isbn;

    @ExcelProperty("教材名称")
    @NotBlank(message = "教材名称不能为空")
    private String bookName;

    @ExcelProperty("作者")
    private String author;

    @ExcelProperty("出版社")
    private String publisher;

    @ExcelProperty("版次")
    private String edition;

    @ExcelProperty("出版时间")
    @DateTimeFormat("yyyy-MM-dd")
    private Date publishDate;

    @ExcelProperty("定价")
    private BigDecimal price;

    @ExcelProperty("库存预警阈值")
    private Integer alertThreshold;

    @ExcelProperty("教材类型")
    private String bookType;

    @ExcelProperty("适用课程")
    private String courseName;
}
```

---

## 四、领书单导出（打印）

### 4.1 领书单导出模板

```java
/**
 * 领书单打印VO
 */
public class ClaimFormPrintVO {

    @ExcelProperty("序号")
    private Integer rowNum;

    @ExcelProperty("ISBN")
    private String isbn;

    @ExcelProperty("教材名称")
    private String bookName;

    @ExcelProperty("作者")
    private String author;

    @ExcelProperty("出版社")
    private String publisher;

    @ExcelProperty("定价")
    @NumberFormat("#.00")
    private BigDecimal price;

    @ExcelProperty("应发数量")
    private Integer plannedQty;

    @ExcelProperty("实发数量")
    private Integer issuedQty;
}
```

### 4.2 领书单导出实现

```java
/**
 * 导出领书单（用于打印）
 */
public void exportClaimForm(Long formId, HttpServletResponse response) {
    // 1. 查询领书单信息
    BookClaimForm form = claimFormMapper.selectById(formId);

    // 2. 查询明细
    List<BookClaimFormDetail> details = detailMapper.selectByFormId(formId);
    List<ClaimFormPrintVO> printList = details.stream()
        .map(d -> {
            ClaimFormPrintVO vo = new ClaimFormPrintVO();
            vo.setIsbn(d.getIsbn());
            vo.setBookName(d.getBookName());
            vo.setAuthor(d.getAuthor());
            vo.setPublisher(d.getPublisher());
            vo.setPrice(d.getPrice());
            vo.setPlannedQty(d.getPlannedQty());
            vo.setIssuedQty(d.getIssuedQty());
            return vo;
        })
        .collect(Collectors.toList());

    // 3. 设置表头信息（使用Sheet名称传递）
    String sheetName = String.format("%s_%s领书单",
        form.getClassName(),
        form.getFormNo());

    // 4. 导出
    ExcelUtil<ClaimFormPrintVO> util = new ExcelUtil<>(ClaimFormPrintVO.class);
    util.exportExcel(response, printList, sheetName);
}
```

---

## 五、前端Excel处理

### 5.1 文件上传组件

```vue
<template>
  <el-upload
    action="#"
    :auto-upload="false"
    :limit="1"
    :on-change="handleFileChange"
    :on-exceed="handleExceed"
    accept=".xlsx,.xls"
    :before-upload="beforeUpload"
  >
    <el-button type="primary" icon="el-icon-upload2">选择文件</el-button>
    <div slot="tip" class="el-upload__tip">
      仅支持 .xlsx / .xls 格式，文件大小不超过10MB，数据不超过1000行
    </div>
  </el-upload>

  <el-button type="success" @click="handleImport" :disabled="!file">
    开始导入
  </el-button>

  <!-- 导入预览弹窗 -->
  <el-dialog title="导入预览" :visible.sync="previewVisible" width="80%">
    <el-alert
      :title="`共 ${previewData.total} 条，成功 ${previewData.successCount} 条，失败 ${previewData.failCount} 条`"
      :type="previewData.failCount > 0 ? 'warning' : 'success'"
      show-icon
      style="margin-bottom: 15px"
    />

    <el-table :data="previewData.errorList" v-if="previewData.failCount > 0"
      border stripe style="width: 100%">
      <el-table-column prop="rowNum" label="行号" width="80" />
      <el-table-column prop="isbn" label="ISBN" width="150" />
      <el-table-column prop="reason" label="失败原因" />
    </el-table>

    <span slot="footer">
      <el-button @click="previewVisible = false">取消</el-button>
      <el-button type="primary" @click="confirmImport"
        :disabled="previewData.successCount === 0">
        确认导入（{{ previewData.successCount }}条）
      </el-button>
    </span>
  </el-dialog>
</template>

<script>
export default {
  data() {
    return {
      file: null,
      previewVisible: false,
      previewData: {
        total: 0,
        successCount: 0,
        failCount: 0,
        batchId: '',
        errorList: []
      }
    }
  },
  methods: {
    beforeUpload(file) {
      const isExcel = file.name.endsWith('.xlsx') || file.name.endsWith('.xls')
      const isLt10M = file.size / 1024 / 1024 < 10
      if (!isExcel) {
        this.$message.error('仅支持 .xlsx / .xls 格式')
        return false
      }
      if (!isLt10M) {
        this.$message.error('文件大小不能超过10MB')
        return false
      }
      return true
    },
    handleFileChange(file) {
      this.file = file.raw
    },
    handleExceed() {
      this.$message.warning('只能上传一个文件')
    },
    async handleImport() {
      if (!this.file) return
      const formData = new FormData()
      formData.append('file', this.file)
      const res = await this.$http.post('/api/purchase/import', formData)
      if (res.code === 200) {
        this.previewData = res.data
        this.previewVisible = true
      }
    },
    async confirmImport() {
      const res = await this.$http.post('/api/purchase/import/confirm', {
        batchId: this.previewData.batchId
      })
      if (res.code === 200) {
        this.$message.success(`导入成功，采购单号：${res.data}`)
        this.previewVisible = false
        this.$emit('success')
      }
    }
  }
}
</script>
```

---

## 六、常见问题与解决方案

| 问题 | 原因 | 解决方案 |
|------|------|---------|
| ISBN被Excel转为科学计数法 | Excel自动识别长数字 | 模板中ISBN列设为文本格式；代码中用String接收 |
| 日期格式解析失败 | Excel日期格式多样 | 使用 `@DateTimeFormat` 指定多种格式 |
| 大文件导入OOM | POI一次性加载全部数据 | 使用EasyExcel（SAX模式）逐行读取 |
| 中文乱码 | 编码不一致 | 统一使用UTF-8，响应头设置 `charset=UTF-8` |
| 表头被用户修改导致错位 | 按表头名称匹配 | 改为固定列索引读取（本系统已采用） |
| 导入数据丢失 | 事务回滚但未告知用户 | 两阶段导入：先校验预览，再确认导入 |
