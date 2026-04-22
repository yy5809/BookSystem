<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="申请编号" prop="applyNo">
        <el-input v-model="queryParams.applyNo" placeholder="请输入申请编号" clearable @keyup.enter.native="handleQuery" />
      </el-form-item>
      <el-form-item label="申请人" prop="teacherName">
        <el-input v-model="queryParams.teacherName" placeholder="请输入申请人" clearable @keyup.enter.native="handleQuery" />
      </el-form-item>
      <el-form-item label="ISBN" prop="isbn">
        <el-input v-model="queryParams.isbn" placeholder="请输入ISBN" clearable @keyup.enter.native="handleQuery" />
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
        <el-button type="primary" plain icon="el-icon-plus" size="mini" @click="handleAdd" v-hasPermi="['textbook:personalApply:add']">新增</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="danger" plain icon="el-icon-delete" size="mini" :disabled="multiple" @click="handleDelete" v-hasPermi="['textbook:personalApply:remove']">删除</el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="applyList" :row-key="row => row.applyId" border stripe>
      <el-table-column label="申请编号" align="center" prop="applyNo" width="180" />
      <el-table-column label="申请人" align="center" prop="teacherName" width="100" />
      <el-table-column label="教材名称" align="center" prop="bookName" show-overflow-tooltip />
      <el-table-column label="ISBN" align="center" prop="isbn" width="140" />
      <el-table-column label="申请数量" align="center" prop="applyQty" width="80" />
      <el-table-column label="用途说明" align="center" prop="purpose" show-overflow-tooltip />
      <el-table-column label="状态" align="center" prop="status" width="90">
        <template slot-scope="scope">
          <dict-tag :options="dict.type.tb_personal_apply_status" :value="scope.row.status" />
        </template>
      </el-table-column>
      <el-table-column label="审核意见" align="center" prop="auditOpinion" show-overflow-tooltip />
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width" width="220">
        <template slot-scope="scope">
          <el-button size="mini" type="text" icon="el-icon-view" @click="handleView(scope.row)" v-hasPermi="['textbook:personalApply:query']">详情</el-button>
          <el-button size="mini" type="text" icon="el-icon-check" @click="handleAudit(scope.row)" v-if="scope.row.status === '0'" v-hasPermi="['textbook:personalApply:audit']">审核</el-button>
          <el-button size="mini" type="text" icon="el-icon-sell" @click="handleIssue(scope.row)" v-if="scope.row.status === '1'" v-hasPermi="['textbook:personalApply:issue']">出库</el-button>
          <el-button size="mini" type="text" icon="el-icon-close" @click="handleCancel(scope.row)" v-if="scope.row.status === '0'" v-hasPermi="['textbook:personalApply:cancel']">取消</el-button>
          <el-button size="mini" type="text" icon="el-icon-delete" @click="handleDelete(scope.row)" v-hasPermi="['textbook:personalApply:remove']">删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />

    <el-dialog title="提交领书申请" :visible.sync="open" width="600px" append-to-body :close-on-click-modal="false">
      <el-form ref="form" :model="form" :rules="rules" label-width="100px">
        <el-row>
          <el-col :span="24">
            <el-form-item label="选择教材" prop="textbookId">
              <el-select v-model="form.textbookId" filterable placeholder="请选择或搜索教材" style="width: 100%" @change="handleBookSelect">
                <el-option v-for="book in bookList" :key="book.bookId" :label="book.bookName + ' - ' + book.isbn" :value="book.bookId" />
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="ISBN">
              <el-input v-model="form.isbn" disabled />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="书名">
              <el-input v-model="form.bookName" disabled />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="申请数量" prop="applyQty">
              <el-input-number v-model="form.applyQty" :min="1" :max="9999" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="24">
            <el-form-item label="用途说明" prop="purpose">
              <el-input v-model="form.purpose" type="textarea" placeholder="请输入申请原因/用途" :rows="3" />
            </el-form-item>
          </el-col>
        </el-row>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitForm">确 定</el-button>
        <el-button @click="cancel">取 消</el-button>
      </div>
    </el-dialog>

    <el-dialog title="审核申请" :visible.sync="auditOpen" width="550px" append-to-body :close-on-click-modal="false">
      <el-form ref="auditForm" :model="auditForm" :rules="auditRules" label-width="100px">
        <el-form-item label="申请信息">
          <div style="padding: 10px; background: #f5f7fa; border-radius: 4px; margin-bottom: 15px;">
            <p>申请人：{{ currentApply.teacherName }}</p>
            <p>教材：{{ currentApply.bookName }} ({{ currentApply.isbn }})</p>
            <p>数量：{{ currentApply.applyQty }}</p>
            <p>用途：{{ currentApply.purpose || '-' }}</p>
          </div>
        </el-form-item>
        <el-form-item label="审核结果" prop="status">
          <el-radio-group v-model="auditForm.status">
            <el-radio label="1">通过</el-radio>
            <el-radio label="2">驳回</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="审核意见" prop="auditOpinion">
          <el-input v-model="auditForm.auditOpinion" type="textarea" placeholder="请输入审核意见" :rows="2" />
        </el-form-item>
        <el-divider v-if="auditForm.status === '2'" />
        <template v-if="auditForm.status === '2'">
          <el-form-item label="同时登记缺书">
            <el-switch v-model="auditForm.registerShortage" active-text="是" inactive-text="否" />
          </el-form-item>
          <template v-if="auditForm.registerShortage">
            <el-form-item label="缺书数量" prop="shortageQty">
              <el-input-number v-model="auditForm.shortageQty" :min="1" :max="9999" />
              <span style="color: #909399; font-size: 12px; margin-left: 8px;">默认取申请数量，可修改</span>
            </el-form-item>
            <el-form-item label="紧急程度" prop="shortageUrgency">
              <el-radio-group v-model="auditForm.shortageUrgency">
                <el-radio label="0">普通</el-radio>
                <el-radio label="1">紧急</el-radio>
                <el-radio label="2">特急</el-radio>
              </el-radio-group>
            </el-form-item>
            <el-form-item label="缺书备注">
              <el-input v-model="auditForm.shortageRemark" type="textarea" placeholder="请输入缺书备注（选填）" :rows="2" />
            </el-form-item>
          </template>
        </template>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitAudit">确 定</el-button>
        <el-button @click="auditOpen = false">取 消</el-button>
      </div>
    </el-dialog>

    <el-dialog title="申请详情" :visible.sync="viewOpen" width="650px" append-to-body>
      <el-descriptions :column="2" border>
        <el-descriptions-item label="申请编号">{{ viewData.applyNo }}</el-descriptions-item>
        <el-descriptions-item label="状态">
          <dict-tag :options="dict.type.tb_personal_apply_status" :value="viewData.status" />
        </el-descriptions-item>
        <el-descriptions-item label="申请人">{{ viewData.teacherName }}</el-descriptions-item>
        <el-descriptions-item label="申请时间">{{ viewData.createTime }}</el-descriptions-item>
        <el-descriptions-item label="教材名称" :span="2">{{ viewData.bookName }}</el-descriptions-item>
        <el-descriptions-item label="ISBN" :span="2">{{ viewData.isbn }}</el-descriptions-item>
        <el-descriptions-item label="申请数量">{{ viewData.applyQty }}</el-descriptions-item>
        <el-descriptions-item label="用途说明" :span="2">{{ viewData.purpose || '-' }}</el-descriptions-item>
        <el-descriptions-item label="审核人">{{ viewData.auditBy || '-' }}</el-descriptions-item>
        <el-descriptions-item label="审核时间">{{ viewData.auditTime || '-' }}</el-descriptions-item>
        <el-descriptions-item label="审核意见" :span="2">{{ viewData.auditOpinion || '-' }}</el-descriptions-item>
        <el-descriptions-item label="出库时间" :span="2">{{ viewData.issueTime || '-' }}</el-descriptions-item>
      </el-descriptions>
      <div slot="footer" class="dialog-footer">
        <el-button @click="viewOpen = false">关 闭</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { listPersonalApply, getPersonalApply, addPersonalApply, delPersonalApply, auditApply, issueApply, cancelApply } from "@/api/textbook/personalApply";
import { listBook } from "@/api/textbook/book";

export default {
  name: "PersonalApply",
  dicts: ['tb_personal_apply_status'],
  data() {
    return {
      loading: true,
      ids: [],
      single: true,
      multiple: true,
      showSearch: true,
      total: 0,
      applyList: [],
      bookList: [],
      open: false,
      auditOpen: false,
      viewOpen: false,
      form: {},
      auditForm: {},
      viewData: {},
      currentApply: {},
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        applyNo: null,
        teacherName: null,
        isbn: null,
        status: null
      },
      rules: {
        textbookId: [{ required: true, message: "请选择教材", trigger: "change" }],
        applyQty: [{ required: true, message: "请输入申请数量", trigger: "blur" }],
        purpose: [{ required: true, message: "请输入用途说明", trigger: "blur" }]
      },
      auditRules: {
        status: [{ required: true, message: "请选择审核结果", trigger: "change" }]
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
      listPersonalApply(this.queryParams).then(response => {
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
    handleSelectionChange(selection) {
      this.ids = selection.map(item => item.applyId);
      this.single = selection.length !== 1;
      this.multiple = !selection.length;
    },
    handleAdd() {
      this.reset();
      this.open = true;
      this.title = "提交领书申请";
    },
    reset() {
      this.form = {
        applyId: null,
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
            this.$modal.msgSuccess("申请成功");
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
    handleAudit(row) {
      this.currentApply = row;
      this.auditForm = {
        applyId: row.applyId,
        status: null,
        auditOpinion: '',
        registerShortage: true,
        shortageQty: row.applyQty,
        shortageUrgency: '0',
        shortageRemark: ''
      };
      this.auditOpen = true;
    },
    submitAudit() {
      this.$refs["auditForm"].validate(valid => {
        if (valid) {
          auditApply(this.auditForm).then(response => {
            this.$modal.msgSuccess("审核完成");
            this.auditOpen = false;
            this.getList();
          });
        }
      });
    },
    handleIssue(row) {
      this.$confirm('确认该教师已领取教材并完成出库?', '确认出库', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        return issueApply(row.applyId);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("出库成功");
      });
    },
    handleDelete(row) {
      const applyIds = row.applyId || this.ids;
      this.$confirm('是否确认删除选中的数据项?', "警告", {
        confirmButtonText: "确定",
        cancelButtonText: "取消",
        type: "warning"
      }).then(function() {
        return delPersonalApply(applyIds);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("删除成功");
      });
    },
    handleCancel(row) {
      this.$confirm('是否确认取消该申请?', "确认取消", {
        confirmButtonText: "确定",
        cancelButtonText: "取消",
        type: "warning"
      }).then(() => {
        return cancelApply(row.applyId);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("取消成功");
      });
    }
  }
};
</script>
