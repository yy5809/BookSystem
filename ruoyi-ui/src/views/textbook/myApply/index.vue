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

    <el-table v-loading="loading" :data="applyList">
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
        </template>
      </el-table-column>
    </el-table>

    <pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />

    <el-dialog title="提交领书申请" :visible.sync="open" width="600px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="100px">
        <el-form-item label="选择教材" prop="textbookId">
          <el-select v-model="form.textbookId" filterable placeholder="请选择或搜索教材" style="width: 100%" @change="handleBookSelect">
            <el-option v-for="book in bookList" :key="book.bookId" :label="book.bookName + ' - ' + book.isbn" :value="book.bookId" />
          </el-select>
        </el-form-item>
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
        <el-button type="primary" @click="submitForm">提 交</el-button>
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
import { listBook } from "@/api/textbook/book";

export default {
  name: "MyApply",
  dicts: ['tb_personal_apply_status'],
  data() {
    return {
      loading: true,
      total: 0,
      applyList: [],
      bookList: [],
      showSearch: true,
      open: false,
      viewOpen: false,
      form: {},
      viewData: {},
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
      }
    };
  },
  created() {
    this.getList();
    this.getBookList();
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
    getBookList() {
      listBook({}).then(response => {
        this.bookList = response.rows || [];
      });
    },
    handleBookSelect(val) {
      const book = this.bookList.find(b => b.bookId === val);
      if (book) {
        this.form.isbn = book.isbn;
        this.form.bookName = book.bookName;
      }
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
      this.resetForm("form");
    },
    cancel() {
      this.open = false;
      this.reset();
    },
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          addPersonalApply(this.form).then(response => {
            this.$modal.msgSuccess("申请提交成功，等待库管员审核");
            this.open = false;
            this.getList();
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
    }
  }
};
</script>
