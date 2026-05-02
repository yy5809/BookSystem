<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="ISBN" prop="isbn"><el-input v-model="queryParams.isbn" placeholder="请输入ISBN" clearable @keyup.enter.native="handleQuery" /></el-form-item>
      <el-form-item label="教材名称" prop="bookName"><el-input v-model="queryParams.bookName" placeholder="请输入教材名称" clearable @keyup.enter.native="handleQuery" /></el-form-item>
      <el-form-item label="紧急程度" prop="urgency">
        <el-select v-model="queryParams.urgency" placeholder="请选择" clearable><el-option label="普通" value="0" /><el-option label="紧急" value="1" /><el-option label="特急" value="2" /></el-select>
      </el-form-item>
      <el-form-item label="状态" prop="handleStatus">
        <el-select v-model="queryParams.handleStatus" placeholder="请选择" clearable><el-option label="未处理" value="0" /><el-option label="已纳入采购" value="1" /><el-option label="已到货" value="2" /><el-option label="已完成" value="3" /></el-select>
      </el-form-item>
      <el-form-item><el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button><el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button></el-form-item>
    </el-form>
    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5"><el-button type="primary" plain icon="el-icon-plus" size="mini" @click="handleAdd" v-hasPermi="['textbook:shortage:add']">登记缺书</el-button></el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>
    <el-table v-loading="loading" :data="shortageList" border stripe>
      <el-table-column label="ISBN" align="center" prop="isbn" width="140" />
      <el-table-column label="教材名称" align="center" prop="bookName" show-overflow-tooltip min-width="180" />
      <el-table-column label="缺书数量" align="center" prop="lackNum" width="90" />
      <el-table-column label="紧急程度" align="center" prop="urgency" width="100"><template slot-scope="scope"><el-tag :type="getUrgencyType(scope.row.urgency)" size="mini">{{ getUrgencyLabel(scope.row.urgency) }}</el-tag></template></el-table-column>
      <el-table-column label="状态" align="center" prop="handleStatus" width="100"><template slot-scope="scope"><el-tag :type="getStatusType(scope.row.handleStatus)" size="mini">{{ getStatusLabel(scope.row.handleStatus) }}</el-tag></template></el-table-column>
      <el-table-column label="登记人" align="center" prop="createBy" width="90" />
      <el-table-column label="登记时间" align="center" prop="registerTime" width="160" />
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width" width="150">
        <template slot-scope="scope">
          <el-button size="mini" type="text" icon="el-icon-view" @click="handleView(scope.row)">详情</el-button>
          <el-button size="mini" type="text" icon="el-icon-close" @click="handleCancel(scope.row)" v-if="isPending(scope.row)" v-hasPermi="['textbook:shortage:list']">取消</el-button>
        </template>
      </el-table-column>
    </el-table>
    <pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />

    <el-dialog :title="title" :visible.sync="open" width="650px" append-to-body :close-on-click-modal="false">
      <el-form ref="form" :model="form" :rules="rules" label-width="100px">
        <el-form-item label="选择教材" prop="bookId">
          <el-select v-model="form.bookId" filterable remote reserve-keyword :remote-method="searchBook" :loading="bookSearching" placeholder="输入ISBN或书名搜索" style="width: 100%" @change="handleBookSelect">
            <el-option v-for="book in bookOptions" :key="book.bookId" :label="book.isbn + ' - ' + book.bookName + (book.author ? ' - ' + book.author : '')" :value="book.bookId" />
          </el-select>
        </el-form-item>
        <div v-if="bookOptions.length === 0 && searchKeyword && !bookSearching" style="margin: -10px 0 10px 100px;">
          <el-button type="text" icon="el-icon-plus" @click="showQuickAdd = true" style="color: #E6A23C;">该教材不存在，点击快速新增</el-button>
        </div>
        <el-card v-if="showQuickAdd" shadow="hover" style="margin-bottom: 15px;">
          <div slot="header"><span>快速新增教材</span></div>
          <el-form ref="quickAddForm" :model="quickAddForm" :rules="quickAddRules" label-width="80px" size="small">
            <el-row :gutter="20"><el-col :span="12"><el-form-item label="ISBN" prop="isbn"><el-input v-model="quickAddForm.isbn" placeholder="10位或13位数字" /></el-form-item></el-col><el-col :span="12"><el-form-item label="书名" prop="bookName"><el-input v-model="quickAddForm.bookName" placeholder="请输入书名" /></el-form-item></el-col></el-row>
            <el-row :gutter="20"><el-col :span="12"><el-form-item label="作者" prop="author"><el-input v-model="quickAddForm.author" placeholder="请输入作者" /></el-form-item></el-col><el-col :span="12"><el-form-item label="出版社" prop="publisher"><el-input v-model="quickAddForm.publisher" placeholder="请输入出版社" /></el-form-item></el-col></el-row>
          </el-form>
          <el-alert type="info" :closable="false" style="margin-top: 10px;"><template slot="default">快速新增的教材基本信息将被录入系统，后续可由库管员补充完善其他字段。</template></el-alert>
          <div style="text-align: right; margin-top: 10px;"><el-button size="small" @click="showQuickAdd = false">取消新增</el-button><el-button type="primary" size="small" @click="handleQuickAdd" :loading="quickAddLoading">确认新增并继续</el-button></div>
        </el-card>
        <el-form-item label="ISBN"><el-input v-model="form.isbn" disabled /></el-form-item>
        <el-form-item label="缺书数量" prop="lackNum"><el-input-number v-model="form.lackNum" :min="1" :max="9999" /></el-form-item>
        <el-form-item label="紧急程度" prop="urgency"><el-radio-group v-model="form.urgency"><el-radio label="0">普通</el-radio><el-radio label="1">紧急</el-radio><el-radio label="2">特急</el-radio></el-radio-group></el-form-item>
        <el-form-item label="备注说明" prop="remark"><el-input v-model="form.remark" type="textarea" placeholder="请输入缺书原因或补充说明" :rows="3" /></el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer"><el-button type="primary" @click="submitForm" :loading="submitLoading">确 定</el-button><el-button @click="cancel">取 消</el-button></div>
    </el-dialog>

    <el-dialog title="缺书详情" :visible.sync="viewOpen" width="600px" append-to-body>
      <el-descriptions :column="2" border>
        <el-descriptions-item label="ISBN">{{ viewData.isbn }}</el-descriptions-item>
        <el-descriptions-item label="教材名称" :span="2">{{ viewData.bookName }}</el-descriptions-item>
        <el-descriptions-item label="缺书数量">{{ viewData.lackNum }} 本</el-descriptions-item>
        <el-descriptions-item label="紧急程度"><el-tag :type="getUrgencyType(viewData.urgency)">{{ getUrgencyLabel(viewData.urgency) }}</el-tag></el-descriptions-item>
        <el-descriptions-item label="状态"><el-tag :type="getStatusType(viewData.handleStatus)">{{ getStatusLabel(viewData.handleStatus) }}</el-tag></el-descriptions-item>
        <el-descriptions-item label="登记人">{{ viewData.createBy }}</el-descriptions-item>
        <el-descriptions-item label="登记时间">{{ viewData.registerTime }}</el-descriptions-item>
        <el-descriptions-item label="备注" :span="2">{{ viewData.remark || '-' }}</el-descriptions-item>
      </el-descriptions>
      <div slot="footer" class="dialog-footer"><el-button @click="viewOpen = false">关 闭</el-button></div>
    </el-dialog>
  </div>
</template>

<script>
import { getShortageList, addShortage, updateShortage, deleteShortage, cancelShortage } from "@/api/textbook/shortage";
import { searchBookList, quickAddBook } from "@/api/textbook/book";

export default {
  name: "RegisterShortage",
  dicts: ['emergency_level'],
  data() {
    return {
      loading: true, submitLoading: false, quickAddLoading: false, bookSearching: false,
      total: 0, shortageList: [], bookOptions: [], searchKeyword: '', showQuickAdd: false,
      title: "登记缺书", open: false, viewOpen: false, form: {}, viewData: {}, showSearch: true,
      quickAddForm: { isbn: '', bookName: '', author: '', publisher: '', infoSource: '2' },
      queryParams: { pageNum: 1, pageSize: 10, isbn: null, bookName: null, urgency: null, handleStatus: null },
      rules: {
        bookId: [{ required: true, message: "请选择教材", trigger: "change" }],
        lackNum: [{ required: true, message: "请输入缺书数量", trigger: "blur" }],
        urgency: [{ required: true, message: "请选择紧急程度", trigger: "change" }]
      },
      quickAddRules: {
        isbn: [{ required: true, message: '请输入ISBN', trigger: 'blur' }, { pattern: /^(\d{10}|\d{13})$/, message: 'ISBN格式不正确（10或13位数字）', trigger: 'blur' }],
        bookName: [{ required: true, message: '请输入书名', trigger: 'blur' }],
        author: [{ required: true, message: '请输入作者', trigger: 'blur' }],
        publisher: [{ required: true, message: '请输入出版社', trigger: 'blur' }]
      }
    };
  },
  created() { this.getList(); },
  methods: {
    getList() { this.loading = true; getShortageList(this.queryParams).then(response => { this.shortageList = response.rows; this.total = response.total; this.loading = false; }); },
    searchBook(query) {
      this.searchKeyword = query;
      if (query) { this.bookSearching = true; searchBookList(query).then(response => { this.bookOptions = response.data || []; }).finally(() => { this.bookSearching = false; }); }
      else { this.bookOptions = []; }
    },
    handleBookSelect(val) { const book = this.bookOptions.find(b => b.bookId === val); if (book) { this.form.isbn = book.isbn; this.form.bookName = book.bookName; } },
    handleQuickAdd() {
      this.$refs["quickAddForm"].validate(valid => {
        if (valid) { this.quickAddLoading = true; quickAddBook(this.quickAddForm).then(res => {
          this.$modal.msgSuccess("教材快速新增成功"); this.showQuickAdd = false;
          const newBook = res.data; this.bookOptions.push(newBook); this.form.bookId = newBook.bookId; this.form.isbn = newBook.isbn; this.form.bookName = newBook.bookName;
          this.quickAddForm = { isbn: '', bookName: '', author: '', publisher: '', infoSource: '2' };
        }).finally(() => { this.quickAddLoading = false; }); }
      });
    },
    handleQuery() { this.queryParams.pageNum = 1; this.getList(); },
    resetQuery() { this.resetForm("queryForm"); this.handleQuery(); },
    handleAdd() { this.reset(); this.title = "登记缺书"; this.open = true; },
    reset() { this.form = { lackId: null, bookId: null, isbn: null, bookName: null, lackNum: 1, urgency: '0', remark: null }; this.bookOptions = []; this.searchKeyword = ''; this.showQuickAdd = false; this.quickAddForm = { isbn: '', bookName: '', author: '', publisher: '', infoSource: '2' }; this.resetForm("form"); },
    cancel() { this.open = false; this.reset(); },
    submitForm() {
      this.$refs["form"].validate(valid => { if (valid) { this.submitLoading = true;
        addShortage(this.form).then(response => { this.$modal.msgSuccess("登记成功，系统已通知库管员处理"); this.open = false; this.getList(); }).finally(() => { this.submitLoading = false; });
      } });
    },
    handleView(row) { this.viewData = row; this.viewOpen = true; },
    handleCancel(row) {
      if (!row || !row.lackId) { this.$modal.msgError("缺少缺书ID"); return; }
      const shortageId = row.lackId;
      this.$confirm('是否确认取消该缺书申请?', "确认取消", { confirmButtonText: "确定", cancelButtonText: "取消", type: "warning" }).then(() => { return cancelShortage(shortageId); }).then(() => { this.getList(); this.$modal.msgSuccess("取消成功"); }).catch(() => { this.$modal.msgError("取消失败，请稍后重试"); });
    },
    getUrgencyType(level) { return level === '2' ? 'danger' : level === '1' ? 'warning' : 'info'; },
    getUrgencyLabel(level) { return level === '2' ? '特急' : level === '1' ? '紧急' : '普通'; },
    getStatusType(status) { return status === '3' ? 'success' : status === '2' ? 'info' : status === '1' ? 'warning' : status === '4' ? 'info' : 'danger'; },
    getStatusLabel(status) { return status === '3' ? '已完成' : status === '2' ? '已到货' : status === '1' ? '已纳入采购' : status === '4' ? '已取消' : '未处理'; },
    isPending(row) {
      if (!row) return false
      const s = row.handleStatus
      return !s || s === '' || s === '0'
    }
  }
};
</script>
