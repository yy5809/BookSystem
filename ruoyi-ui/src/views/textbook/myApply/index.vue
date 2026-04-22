<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="教材名称" prop="bookName">
        <el-input v-model="queryParams.bookName" placeholder="请输入教材名称" clearable @keyup.enter.native="handleQuery" />
      </el-form-item>
      <el-form-item label="状态" prop="status">
        <el-select v-model="queryParams.status" placeholder="请选择状态" clearable>
          <el-option v-for="dict in dict.type.tb_personal_apply_status" :key="dict.value" :label="dict.label" :value="dict.value" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button type="primary" plain icon="el-icon-plus" size="mini" @click="handleAdd" v-hasPermi="['textbook:myApply:add']">提交申请</el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="applyList" border stripe>
      <el-table-column label="申请编号" align="center" prop="applyNo" width="180" />
      <el-table-column label="教材名称" align="center" prop="bookName" show-overflow-tooltip />
      <el-table-column label="ISBN" align="center" prop="isbn" width="140" />
      <el-table-column label="申请数量" align="center" prop="applyQty" width="80" />
      <el-table-column label="用途说明" align="center" prop="purpose" show-overflow-tooltip />
      <el-table-column label="状态" align="center" prop="status" width="90">
        <template slot-scope="scope">
          <dict-tag :options="dict.type.tb_personal_apply_status" :value="scope.row.status" />
        </template>
      </el-table-column>
      <el-table-column label="审核意见" align="center" prop="auditOpinion" width="150" show-overflow-tooltip />
      <el-table-column label="申请时间" align="center" prop="createTime" width="160">
        <template slot-scope="scope">{{ scope.row.createTime }}</template>
      </el-table-column>
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width" width="180">
        <template slot-scope="scope">
          <el-button size="mini" type="text" icon="el-icon-view" @click="handleView(scope.row)">详情</el-button>
          <el-button size="mini" type="text" icon="el-icon-close" @click="handleCancel(scope.row)" v-if="scope.row.status === '0'" v-hasPermi="['textbook:myApply:cancel']">取消</el-button>
          <el-button size="mini" type="text" icon="el-icon-refresh-right" @click="handleReapply(scope.row)" v-if="scope.row.status === '2'" v-hasPermi="['textbook:myApply:add']">重新申请</el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />

    <el-dialog title="提交领书申请" :visible.sync="open" width="700px" append-to-body :close-on-click-modal="false">
      <el-form ref="form" :model="form" :rules="rules" label-width="100px">
        <el-form-item label="选择教材" prop="textbookId">
          <el-select v-model="form.textbookId" filterable remote reserve-keyword :remote-method="searchBook" :loading="bookSearching" placeholder="输入ISBN或书名搜索" style="width: 100%" @change="handleBookSelect">
            <el-option v-for="book in bookOptions" :key="book.bookId" :label="book.isbn + ' - ' + book.bookName + (book.author ? ' - ' + book.author : '')" :value="book.bookId" />
          </el-select>
        </el-form-item>
        <div v-if="bookOptions.length === 0 && searchKeyword && !bookSearching" style="margin: -10px 0 10px 100px;">
          <el-button type="text" icon="el-icon-plus" @click="showQuickAdd = true" style="color: #E6A23C;">该教材不存在，点击快速新增</el-button>
        </div>

        <el-card v-if="showQuickAdd" shadow="hover" style="margin-bottom: 15px;">
          <div slot="header"><span>快速新增教材</span></div>
          <el-form ref="quickAddForm" :model="quickAddForm" :rules="quickAddRules" label-width="80px" size="small">
            <el-row :gutter="20">
              <el-col :span="12">
                <el-form-item label="ISBN" prop="isbn">
                  <el-input v-model="quickAddForm.isbn" placeholder="10位或13位数字" />
                </el-form-item>
              </el-col>
              <el-col :span="12">
                <el-form-item label="书名" prop="bookName">
                  <el-input v-model="quickAddForm.bookName" placeholder="请输入书名" />
                </el-form-item>
              </el-col>
            </el-row>
            <el-row :gutter="20">
              <el-col :span="12">
                <el-form-item label="作者" prop="author">
                  <el-input v-model="quickAddForm.author" placeholder="请输入作者" />
                </el-form-item>
              </el-col>
              <el-col :span="12">
                <el-form-item label="出版社">
                  <el-input v-model="quickAddForm.publisher" placeholder="选填" />
                </el-form-item>
              </el-col>
            </el-row>
            <el-row :gutter="20">
              <el-col :span="12">
                <el-form-item label="定价">
                  <el-input-number v-model="quickAddForm.price" :precision="2" :min="0" style="width: 100%" />
                </el-form-item>
              </el-col>
              <el-col :span="12">
                <el-form-item label="适用课程">
                  <el-input v-model="quickAddForm.courseName" placeholder="选填" />
                </el-form-item>
              </el-col>
            </el-row>
          </el-form>
          <el-alert type="info" :closable="false" style="margin-top: 10px;">
            <template slot="default">快速新增的教材信息不完整，库管员后续会补充完善。</template>
          </el-alert>
          <div style="text-align: right; margin-top: 10px;">
            <el-button size="small" @click="showQuickAdd = false">取消新增</el-button>
            <el-button type="primary" size="small" @click="handleQuickAdd" :loading="quickAddLoading">确认新增并继续</el-button>
          </div>
        </el-card>

        <el-form-item label="ISBN">
          <el-input v-model="form.isbn" disabled />
        </el-form-item>
        <el-form-item label="申请数量" prop="applyQty">
          <el-input-number v-model="form.applyQty" :min="1" :max="9999" />
        </el-form-item>
        <el-form-item label="用途说明" prop="purpose">
          <el-input v-model="form.purpose" type="textarea" placeholder="请输入申请原因/用途（如：教学参考、个人学习等）" :rows="3" />
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitForm" :loading="submitLoading">提 交</el-button>
        <el-button @click="cancel">取 消</el-button>
      </div>
    </el-dialog>

    <el-dialog title="申请详情" :visible.sync="viewOpen" width="650px" append-to-body>
      <el-descriptions :column="2" border>
        <el-descriptions-item label="申请编号">{{ viewData.applyNo }}</el-descriptions-item>
        <el-descriptions-item label="状态">
          <dict-tag :options="dict.type.tb_personal_apply_status" :value="viewData.status" />
        </el-descriptions-item>
        <el-descriptions-item label="教材名称" :span="2">{{ viewData.bookName }}</el-descriptions-item>
        <el-descriptions-item label="ISBN" :span="2">{{ viewData.isbn }}</el-descriptions-item>
        <el-descriptions-item label="申请数量">{{ viewData.applyQty }} 本</el-descriptions-item>
        <el-descriptions-item label="用途说明" :span="2">{{ viewData.purpose || '-' }}</el-descriptions-item>
        <el-descriptions-item label="审核人">{{ viewData.auditBy || '-' }}</el-descriptions-item>
        <el-descriptions-item label="审核时间">{{ viewData.auditTime || '-' }}</el-descriptions-item>
        <el-descriptions-item label="审核意见" :span="2">{{ viewData.auditOpinion || '-' }}</el-descriptions-item>
        <el-descriptions-item label="出库时间" :span="2">{{ viewData.issueTime || '未出库' }}</el-descriptions-item>
      </el-descriptions>
      <div slot="footer" class="dialog-footer">
        <el-button @click="viewOpen = false">关 闭</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { listMyApply, addPersonalApply, cancelApply, getPersonalApply } from "@/api/textbook/personalApply";
import { searchBookList, quickAddBook } from "@/api/textbook/book";

export default {
  name: "MyApply",
  dicts: ['tb_personal_apply_status'],
  data() {
    return {
      loading: true,
      submitLoading: false,
      quickAddLoading: false,
      bookSearching: false,
      total: 0,
      applyList: [],
      bookOptions: [],
      searchKeyword: '',
      showQuickAdd: false,
      open: false,
      viewOpen: false,
      form: {},
      viewData: {},
      quickAddForm: {
        isbn: '',
        bookName: '',
        author: '',
        publisher: '',
        price: null,
        courseName: '',
        infoSource: '1'
      },
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        bookName: null,
        status: null
      },
      rules: {
        textbookId: [{ required: true, message: "请选择教材", trigger: "change" }],
        applyQty: [{ required: true, message: "请输入申请数量", trigger: "blur" }],
        purpose: [{ required: true, message: "请输入用途说明", trigger: "blur" }]
      },
      quickAddRules: {
        isbn: [
          { required: true, message: '请输入ISBN', trigger: 'blur' },
          { pattern: /^(\d{10}|\d{13})$/, message: 'ISBN格式不正确（10或13位数字）', trigger: 'blur' }
        ],
        bookName: [{ required: true, message: '请输入书名', trigger: 'blur' }],
        author: [{ required: true, message: '请输入作者', trigger: 'blur' }]
      }
    };
  },
  created() {
    this.getList();
    if (this.$route.query.textbookId || this.$route.query.isbn) {
      this.$nextTick(() => {
        this.handleAdd();
        this.$nextTick(() => {
          if (this.$route.query.textbookId) {
            this.form.textbookId = parseInt(this.$route.query.textbookId);
          }
          if (this.$route.query.isbn) {
            this.form.isbn = this.$route.query.isbn;
          }
          if (this.$route.query.bookName) {
            this.form.bookName = this.$route.query.bookName;
          }
        });
      });
    }
  },
  methods: {
    getList() {
      this.loading = true;
      listMyApply(this.queryParams).then(response => {
        this.applyList = response.rows;
        this.total = response.total;
        this.loading = false;
      });
    },
    searchBook(query) {
      this.searchKeyword = query;
      if (query) {
        this.bookSearching = true;
        searchBookList(query).then(response => {
          this.bookOptions = response.data || [];
        }).finally(() => {
          this.bookSearching = false;
        });
      } else {
        this.bookOptions = [];
      }
    },
    handleBookSelect(val) {
      const book = this.bookOptions.find(b => b.bookId === val);
      if (book) {
        this.form.isbn = book.isbn;
        this.form.bookName = book.bookName;
      }
    },
    handleQuickAdd() {
      this.$refs["quickAddForm"].validate(valid => {
        if (valid) {
          this.quickAddLoading = true;
          quickAddBook(this.quickAddForm).then(res => {
            this.$modal.msgSuccess("教材快速新增成功");
            this.showQuickAdd = false;
            const newBook = res.data;
            this.bookOptions.push(newBook);
            this.form.textbookId = newBook.bookId;
            this.form.isbn = newBook.isbn;
            this.form.bookName = newBook.bookName;
            this.quickAddForm = { isbn: '', bookName: '', author: '', publisher: '', price: null, courseName: '', infoSource: '1' };
          }).finally(() => {
            this.quickAddLoading = false;
          });
        }
      });
    },
    handleQuery() {
      this.queryParams.pageNum = 1;
      this.getList();
    },
    resetQuery() {
      this.resetForm("queryForm");
      this.handleQuery();
    },
    handleAdd() {
      this.reset();
      this.open = true;
    },
    reset() {
      this.form = {
        textbookId: null,
        isbn: null,
        bookName: null,
        applyQty: 1,
        purpose: null
      };
      this.bookOptions = [];
      this.searchKeyword = '';
      this.showQuickAdd = false;
      this.quickAddForm = { isbn: '', bookName: '', author: '', publisher: '', price: null, courseName: '', infoSource: '1' };
      this.resetForm("form");
    },
    cancel() {
      this.open = false;
      this.reset();
    },
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          this.submitLoading = true;
          addPersonalApply(this.form).then(response => {
            this.$modal.msgSuccess("申请提交成功，等待库管员审核");
            this.open = false;
            this.getList();
          }).finally(() => {
            this.submitLoading = false;
          });
        }
      });
    },
    handleView(row) {
      this.viewData = row;
      this.viewOpen = true;
    },
    handleCancel(row) {
      this.$confirm('确认取消该领书申请?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        return cancelApply(row.applyId);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("已取消");
      });
    },
    handleReapply(row) {
      this.reset();
      this.open = true;
      this.$nextTick(() => {
        this.form.textbookId = row.textbookId;
        this.form.isbn = row.isbn;
        this.form.bookName = row.bookName;
        this.form.applyQty = row.applyQty;
        this.form.purpose = row.purpose;
        this.bookOptions = row.isbn ? [{ bookId: row.textbookId, isbn: row.isbn, bookName: row.bookName }] : [];
      });
    }
  }
};
</script>
