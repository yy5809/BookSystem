# 教材快速新增功能 — TRAE 开发指令

> 直接复制以下内容给 TRAE 执行。本指令解决"业务流程中教材不存在于系统"的问题。

---

## 指令正文（直接复制 ↓）

```
基于现有教材采购系统（RuoYi-Vue 3.9.0），实现「教材快速新增」功能。
当教师在提交领书申请/登记缺书时，或库管员Excel导入采购单时，
如果教材不存在于系统中，允许快速创建基础教材信息并继续业务流程。

═══════════════════════════════════════════════════════════════
一、数据库变更
═══════════════════════════════════════════════════════════════

1.1 textbook_info 表新增两个字段：

ALTER TABLE textbook_info ADD COLUMN `info_status` char(1) DEFAULT '1' COMMENT '信息完整度 0待完善 1已完善';
ALTER TABLE textbook_info ADD COLUMN `info_source` char(1) DEFAULT '0' COMMENT '来源 0手动录入 1教师领书快速新增 2缺书快速新增 3导入自动新增';

1.2 TextbookInfo 实体类新增对应属性：

/** 信息完整度 0待完善 1已完善 */
@Excel(name = "信息状态", readConverterExp = "0=待完善,1=已完善")
private String infoStatus;

/** 来源 0手动录入 1教师领书快速新增 2缺书快速新增 3导入自动新增 */
private String infoSource;

1.3 新增数据字典：

字典类型：textbook_info_status
字典标签：待完善(0)、已完善(1)

字典类型：textbook_info_source
字典标签：手动录入(0)、教师快速新增(1)、缺书快速新增(2)、导入自动新增(3)

═══════════════════════════════════════════════════════════════
二、后端接口
═══════════════════════════════════════════════════════════════

2.1 新增接口：快速新增教材

Controller：TextbookInfoController
路径：POST /textbook/book/quickAdd
权限：@PreAuthorize("@ss.hasPermi('textbook:book:quickAdd')")

Service 方法：ITextbookInfoService.quickAdd(TextbookInfo info)

逻辑：
  @Transactional
  1. 校验 ISBN 非空、格式合法（10或13位）
  2. 校验书名非空
  3. 校验 ISBN 唯一性（查询 textbook_info 是否已存在该 ISBN）
  4. 设置 info_status = '0'（待完善）
  5. 设置 info_source = 传入的 source 参数
  6. 设置 create_by、create_time
  7. INSERT textbook_info
  8. 自动 INSERT textbook_stock（stock_num=0, warning_num=30, stock_status='shortage', version=0）
  9. 返回新创建的教材信息（含 book_id）

请求参数：
{
  "isbn": "9787111543287",      // 必填
  "bookName": "数据结构",         // 必填
  "author": "严蔚敏",             // 选填
  "publisher": "清华大学出版社",   // 选填
  "publishTime": "2023-01-01",   // 选填
  "edition": "第2版",             // 选填
  "price": 39.00,                // 选填
  "courseName": "数据结构",       // 选填
  "major": "软件工程",            // 选填
  "grade": "大三",                // 选填
  "textbookType": "专业核心课",   // 选填
  "source": "1"                   // 必填，来源标识
}

2.2 新增接口：补充完善教材信息

Controller：TextbookInfoController
路径：PUT /textbook/book/completeInfo
权限：@PreAuthorize("@ss.hasPermi('textbook:book:edit')")

Service 方法：ITextbookInfoService.completeInfo(TextbookInfo info)

逻辑：
  1. 根据 book_id 查询教材是否存在
  2. 如果 info_status 已经是 '1'，抛出异常"该教材信息已完善"
  3. 更新教材信息（补全出版社、版次、定价、课程等字段）
  4. 设置 info_status = '1'（已完善）
  5. 设置 update_by、update_time
  6. UPDATE textbook_info

2.3 修改接口：Excel导入采购单

修改现有导入逻辑中 ISBN 不存在时的处理方式：

原逻辑：ISBN 不存在 → 该行标记失败 → 跳过
新逻辑：ISBN 不存在 → 自动创建教材 → 标记为"自动新增" → 继续生成采购明细

具体修改点（在 TextbookPendingServiceImpl 的 importPurchase 方法中）：

  TextbookInfo existBook = textbookInfoMapper.selectByIsbn(isbn);
  if (existBook == null) {
      // 自动创建教材
      TextbookInfo newBook = new TextbookInfo();
      newBook.setIsbn(isbn);
      newBook.setBookName(row.getBookName());
      newBook.setInfoStatus("0");
      newBook.setInfoSource("3");
      newBook.setCreateBy(getUsername());
      newBook.setCreateTime(DateUtils.getNowDate());
      textbookInfoMapper.insertTextbookInfo(newBook);
      // 自动创建库存记录
      TextbookStock stock = new TextbookStock();
      stock.setBookId(newBook.getBookId());
      stock.setStockNum(0);
      stock.setWarningNum(30);
      stock.setStockStatus("shortage");
      stock.setVersion(0);
      textbookStockMapper.insertTextbookStock(stock);
      existBook = newBook;
      autoCreatedCount++;
  }

同时修改导入结果返回值，增加 autoCreatedCount 字段：
{
  "total": 50,
  "success": 50,
  "fail": 0,
  "autoCreated": 3,
  "failRows": [],
  "autoCreatedRows": [
    {"rowNum": 5, "isbn": "9787123...", "bookName": "人工智能导论"},
    {"rowNum": 9, "isbn": "9787456...", "bookName": "深度学习"},
    {"rowNum": 23, "isbn": "9787890...", "bookName": "区块链技术"}
  ]
}

2.4 修改接口：教材信息管理列表查询

修改 TextbookInfoMapper.xml 中的查询 SQL，增加 info_status 字段的返回。
在 WHERE 条件中增加 info_status 的筛选支持（搜索栏增加"信息状态"下拉）。

2.5 权限字符补充

在 sys_menu 表中为教材信息管理菜单(menu_id=2129)新增按钮：
  menu_id 自增，parent_id=2129，menu_name=快速新增，perms=textbook:book:quickAdd，menu_type=F

═══════════════════════════════════════════════════════════════
三、前端页面修改
═══════════════════════════════════════════════════════════════

3.1 教材信息管理页面（textbook/bookManage/index）

修改点：
a) 搜索栏增加"信息状态"下拉筛选：信息状态：[全部 ▾]（选项：全部/待完善/已完善）
b) 数据表格增加"信息状态"列（放在"库存状态"列旁边）：
   - info_status='0' → <el-tag type="warning" size="small">待完善</el-tag> 橙色，整行背景浅黄 #fdf6ec
   - info_status='1' → <el-tag type="success" size="small">已完善</el-tag> 绿色
c) 操作列增加"补充完善"按钮（仅 info_status='0' 时显示）：
   <el-button v-if="scope.row.infoStatus === '0'" type="text" @click="handleComplete(scope.row)">补充完善</el-button>
d) "补充完善"弹窗：与编辑弹窗类似，标题为"补充完善教材信息"，顶部显示提示：
   <el-alert type="warning" :closable="false">该教材由教师快速新增/导入自动创建，信息不完整，请补充完善。</el-alert>
   表单中所有字段都可编辑，提交时调用 PUT /textbook/book/completeInfo

3.2 我的领书申请页面（textbook/myApply/index）

修改"提交领书申请"弹窗：

a) 教材选择下拉框改为支持远程搜索的 el-select：
   <el-select v-model="form.bookId" filterable remote reserve-keyword :remote-method="searchBook" placeholder="输入ISBN或书名搜索">
     <el-option v-for="item in bookOptions" :key="item.bookId" :label="item.isbn + ' - ' + item.bookName + ' - ' + item.author" :value="item.bookId" />
   </el-select>

b) 搜索无结果时，下拉框下方显示快速新增入口：
   <div v-if="bookOptions.length === 0 && searchKeyword" class="quick-add-hint">
     <el-button type="text" icon="el-icon-plus" @click="showQuickAdd = true">该教材不存在，点击快速新增</el-button>
   </div>

c) 快速新增表单（内联在弹窗内，v-if="showQuickAdd"）：
   使用 el-card 包裹，标题"📝 快速新增教材"，内部 el-form label-width="80px"。
   表单字段（两列布局 el-row :gutter="20"，el-col :span="12"）：
   - 第一行：ISBN*（el-input）、书名*（el-input）
   - 第二行：作者*（el-input）、出版社（el-input，选填）
   - 第三行：定价（el-input-number）、适用课程（el-input，选填）
   - 第四行：专业（el-select 字典）、年级（el-select 字典）、教材类型（el-select 字典）
   底部提示：<el-alert type="info" :closable="false">快速新增的教材信息不完整，库管员后续会补充完善。</el-alert>
   底部按钮：[取消新增] [确认新增并继续]

d) 快速新增的 JS 逻辑：
   handleQuickAdd() {
     this.$refs.quickAddForm.validate(valid => {
       if (!valid) return;
       quickAdd(this.quickAddForm).then(res => {
         this.$message.success('教材快速新增成功');
         this.showQuickAdd = false;
         this.bookOptions.push(res.data);
         this.form.bookId = res.data.bookId;
         this.quickAddForm = { isbn: '', bookName: '', author: '', publisher: '', price: null, courseName: '', major: '', grade: '', textbookType: '' };
       });
     });
   }

e) 校验规则：
   quickAddRules: {
     isbn: [{ required: true, message: '请输入ISBN', trigger: 'blur' }, { pattern: /^(\d{10}|\d{13})$/, message: 'ISBN格式不正确（10或13位数字）', trigger: 'blur' }],
     bookName: [{ required: true, message: '请输入书名', trigger: 'blur' }],
     author: [{ required: true, message: '请输入作者', trigger: 'blur' }]
   }

3.3 缺书登记页面（textbook/registerShortage/index）

与 3.2 完全相同的快速新增逻辑，复用同一个 quickAdd 组件/方法。
区别仅在于 source 参数传 '2'（缺书快速新增），而不是 '1'（教师领书快速新增）。

3.4 采购管理 - Excel导入弹窗（textbook/purchase/index）

修改导入预览结果展示：
a) 统计区域增加"自动新增"数量：<span class="auto-created">⚠️ 自动新增教材：{{ importResult.autoCreated }}</span>
b) 预览表格增加"状态"列：正常行=success标签，自动新增行=warning标签+浅黄背景，失败行=danger标签+浅红背景
c) 确认导入按钮文字：[确认导入（50条，含3本自动新增教材）]
d) 导入完成后提示：this.$message.success('导入成功！成功${res.success}条，自动新增${res.autoCreated}本教材，请到教材信息管理中补充完善。');

3.5 库管员首页（textbook/warehouseDashboard/index）

统计卡片增加"待完善教材"（数量查询 info_status='0' 的教材数）。
点击跳转到教材信息管理页面，自动携带查询参数 info_status=0。

3.6 API 接口文件

新增或修改以下 API（api/textbook/book.js）：

export function quickAddBook(data) {
  return request({ url: '/textbook/book/quickAdd', method: 'post', data })
}
export function completeBookInfo(data) {
  return request({ url: '/textbook/book/completeInfo', method: 'put', data })
}
export function searchBookList(query) {
  return request({ url: '/textbook/book/searchList', method: 'get', params: { query } })
}

后端新增搜索接口：
Controller：TextbookInfoController
路径：GET /textbook/book/searchList?query=xxx
权限：@PreAuthorize("@ss.hasPermi('textbook:book:query')")
逻辑：LIKE 模糊匹配 ISBN 或 bookName，返回 bookId、isbn、bookName、author、stockNum、infoStatus

═══════════════════════════════════════════════════════════════
四、关键约束
═══════════════════════════════════════════════════════════════

4.1 快速新增的教材库存为 0，不等于有库存可以出库。教师提交领书申请时如果教材库存为 0，库管员审核时仍会因库存不足而驳回。快速新增只是登记了教材信息，实际库存需要走采购→入库流程。

4.2 快速新增时 ISBN 仍需唯一校验，防止并发重复创建。使用数据库唯一索引 + INSERT 时捕获 DuplicateKeyException。

4.3 Excel 导入自动新增时，书名取 Excel 中的值，但库管员完善时可以修改。因为 Excel 中的书名可能不准确（如简写、错别字），系统以库管员最终确认为准。

4.4 采购入库时，如果关联的教材 info_status 仍为 '0'，自动更新为 '1'。在入库确认逻辑中增加：
   if ("0".equals(bookInfo.getInfoStatus())) {
       bookInfo.setInfoStatus("1");
       textbookInfoMapper.updateTextbookInfo(bookInfo);
   }

4.5 快速新增教材的删除规则：info_status='0' 且未被任何业务单据引用（采购单、领书单、缺书单）时允许删除。已被引用的教材不允许删除，只能编辑补充完善。

4.6 不修改 RuoYi 核心表结构，仅修改业务表 textbook_info。

═══════════════════════════════════════════════════════════════
五、输出产物清单
═══════════════════════════════════════════════════════════════

请按以下顺序交付：

1. SQL 变更脚本（ALTER TABLE + INSERT 字典数据 + INSERT 菜单权限）
2. TextbookInfo.java 实体类（新增 infoStatus、infoSource 字段）
3. ITextbookInfoService.java（新增 quickAdd、completeInfo 方法声明）
4. TextbookInfoServiceImpl.java（新增 quickAdd、completeInfo 方法实现）
5. TextbookInfoController.java（新增 quickAdd、completeInfo、searchList 接口）
6. TextbookInfoMapper.java（新增 selectByIsbn 方法）
7. TextbookInfoMapper.xml（新增 selectByIsbn SQL、修改列表查询 SQL 增加 info_status）
8. TextbookPendingServiceImpl.java（修改 importPurchase 方法，ISBN不存在时自动创建）
9. 前端 api/textbook/book.js（新增 quickAddBook、completeBookInfo、searchBookList）
10. 前端 textbook/myApply/index.vue（修改提交弹窗，增加快速新增）
11. 前端 textbook/registerShortage/index.vue（修改登记弹窗，增加快速新增）
12. 前端 textbook/purchase/index.vue（修改导入弹窗预览展示）
13. 前端教材信息管理页面（增加信息状态列、补充完善按钮和弹窗）
14. 前端库管员首页（增加待完善教材统计卡片）

请现在开始实现，按顺序逐个文件交付。
```

---

## 使用说明

直接复制上面代码块中的全部内容，粘贴给 TRAE 即可。指令中包含了：

| 内容 | 说明 |
|---|---|
| 数据库变更 | 2个 ALTER TABLE + 字典数据 + 菜单权限 |
| 后端接口 | 3个新接口 + 1个修改接口（quickAdd、completeInfo、searchList、importPurchase） |
| 前端修改 | 5个页面修改（教材管理、我的领书申请、缺书登记、采购导入、库管员首页） |
| 关键约束 | 6条必须遵守的业务规则 |
| 交付清单 | 14个文件的明确顺序 |
