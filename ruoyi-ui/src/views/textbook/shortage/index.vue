<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="ISBN" prop="isbn">
        <el-input v-model="queryParams.isbn" placeholder="请输入ISBN" clearable @keyup.enter.native="handleQuery" />
      </el-form-item>
      <el-form-item label="教材名称" prop="bookName">
        <el-input v-model="queryParams.bookName" placeholder="请输入教材名称" clearable @keyup.enter.native="handleQuery" />
      </el-form-item>
      <el-form-item label="紧急程度" prop="urgency">
        <el-select v-model="queryParams.urgency" placeholder="请选择" clearable>
          <el-option label="普通" value="0" />
          <el-option label="紧急" value="1" />
          <el-option label="特急" value="2" />
        </el-select>
      </el-form-item>
      <el-form-item label="处理状态" prop="handleStatus">
        <el-select v-model="queryParams.handleStatus" placeholder="请选择" clearable>
          <el-option label="未处理" value="0" />
          <el-option label="已纳入采购" value="1" />
          <el-option label="已到货" value="2" />
          <el-option label="已完成" value="3" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button type="primary" plain icon="el-icon-plus" size="mini" @click="handleAdd" v-hasPermi="['textbook:shortage:add']">登记缺书</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="success" plain icon="el-icon-download" size="mini" @click="handleExport" v-hasPermi="['textbook:shortage:export']">导出</el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="shortageList" border stripe>
      <el-table-column label="ISBN" align="center" prop="isbn" width="140" />
      <el-table-column label="教材名称" align="center" prop="bookName" show-overflow-tooltip min-width="180" />
      <el-table-column label="缺书数量" align="center" prop="lackNum" width="90" />
      <el-table-column label="紧急程度" align="center" prop="urgency" width="100">
        <template slot-scope="scope">
          <el-tag :type="getUrgencyType(scope.row.urgency)" size="mini">{{ getUrgencyLabel(scope.row.urgency) }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="来源" align="center" prop="source" width="100">
        <template slot-scope="scope">
          <el-tag :type="scope.row.source === '1' ? '' : scope.row.source === '2' ? 'warning' : 'info'" size="mini">
            {{ scope.row.source === '1' ? '领书缺货' : scope.row.source === '2' ? '审核转入' : '库存预警' }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column label="登记人" align="center" prop="createBy" width="90" />
      <el-table-column label="处理状态" align="center" prop="handleStatus" width="100">
        <template slot-scope="scope">
          <el-tag :type="getStatusType(scope.row.handleStatus)" size="mini">{{ getStatusLabel(scope.row.handleStatus) }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="登记时间" align="center" prop="registerTime" width="160" />
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width" width="200">
        <template slot-scope="scope">
          <el-button size="mini" type="text" icon="el-icon-view" @click="handleView(scope.row)">详情</el-button>
          <el-button size="mini" type="text" icon="el-icon-s-claim" style="color:#E6A23C" @click="handleProcess(scope.row)" v-if="scope.row.handleStatus === '0'" v-hasPermi="['textbook:shortage:edit']">转采购</el-button>
          <el-button size="mini" type="text" icon="el-icon-edit" @click="handleEdit(scope.row)" v-if="scope.row.handleStatus === '0'" v-hasPermi="['textbook:shortage:edit']">编辑</el-button>
          <el-button size="mini" type="text" icon="el-icon-delete" style="color:#F56C6C" @click="handleDelete(scope.row)" v-if="scope.row.handleStatus === '0'" v-hasPermi="['textbook:shortage:remove']">删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />

    <el-dialog :title="title" :visible.sync="open" width="550px" append-to-body :close-on-click-modal="false">
      <el-form ref="form" :model="form" :rules="rules" label-width="100px">
        <el-form-item label="教材" prop="bookId">
          <el-select v-model="form.bookId" filterable remote reserve-keyword placeholder="请搜索选择教材" :remote-method="searchBooks" :loading="bookLoading" style="width: 100%" @change="onBookSelect">
            <el-option v-for="item in bookOptions" :key="item.bookId" :label="item.bookName + (item.isbn ? ' (' + item.isbn + ')' : '')" :value="item.bookId" />
          </el-select>
        </el-form-item>
        <el-form-item label="ISBN">
          <el-input v-model="form.isbn" disabled />
        </el-form-item>
        <el-form-item label="缺书数量" prop="lackNum">
          <el-input-number v-model="form.lackNum" :min="1" :max="9999" />
        </el-form-item>
        <el-form-item label="紧急程度" prop="urgency">
          <el-radio-group v-model="form.urgency">
            <el-radio label="0">普通</el-radio>
            <el-radio label="1">紧急</el-radio>
            <el-radio label="2">特急</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="备注" prop="remark">
          <el-input v-model="form.remark" type="textarea" placeholder="请输入备注说明" :rows="3" />
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitForm">确 定</el-button>
        <el-button @click="cancel">取 消</el-button>
      </div>
    </el-dialog>

    <el-dialog title="缺书详情" :visible.sync="viewOpen" width="600px" append-to-body>
      <el-descriptions :column="2" border>
        <el-descriptions-item label="ISBN">{{ viewData.isbn }}</el-descriptions-item>
        <el-descriptions-item label="教材名称" :span="2">{{ viewData.bookName }}</el-descriptions-item>
        <el-descriptions-item label="缺书数量">{{ viewData.lackNum }} 本</el-descriptions-item>
        <el-descriptions-item label="紧急程度">
          <el-tag :type="getUrgencyType(viewData.urgency)">{{ getUrgencyLabel(viewData.urgency) }}</el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="来源">
          <el-tag :type="viewData.source === '1' ? '' : 'warning'">{{ viewData.source === '1' ? '领书缺货' : viewData.source === '2' ? '审核转入' : '库存预警' }}</el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="状态">
          <el-tag :type="getStatusType(viewData.handleStatus)">{{ getStatusLabel(viewData.handleStatus) }}</el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="登记人">{{ viewData.createBy }}</el-descriptions-item>
        <el-descriptions-item label="登记时间">{{ viewData.registerTime }}</el-descriptions-item>
        <el-descriptions-item label="备注" :span="2">{{ viewData.remark || '-' }}</el-descriptions-item>
      </el-descriptions>
      <div slot="footer" class="dialog-footer">
        <el-button v-if="viewData.handleStatus === '0'" type="warning" @click="handleProcess(viewData); viewOpen = false">转采购</el-button>
        <el-button @click="viewOpen = false">关 闭</el-button>
      </div>
    </el-dialog>

    <el-dialog title="转采购确认" :visible.sync="processOpen" width="420px" append-to-body :close-on-click-modal="false">
      <div style="text-align: center; padding: 10px 0;">
        <i class="el-icon-warning-outline" style="font-size: 40px; color: #E6A23C; margin-bottom: 12px;"></i>
        <p>确定将以下缺书记录转为采购需求？</p>
        <p style="font-size: 16px; font-weight: bold; margin: 8px 0;">{{ processData.bookName }}</p>
        <p>缺书数量：<span style="color: #E6A23C; font-weight: bold; font-size: 18px;">{{ processData.lackNum }}</span> 本</p>
      </div>
      <div slot="footer" class="dialog-footer">
        <el-button @click="processOpen = false">取 消</el-button>
        <el-button type="warning" @click="confirmProcess">确认转采购</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { getShortageList, getShortageInfo, addShortage, updateShortage, deleteShortage, processShortage } from "@/api/textbook/shortage";
import { listBook } from "@/api/textbook/book";

export default {
  name: "ShortageManage",
  data() {
    return {
      loading: true,
      total: 0,
      shortageList: [],
      showSearch: true,
      title: "",
      open: false,
      viewOpen: false,
      processOpen: false,
      viewData: {},
      processData: {},
      form: {},
      bookLoading: false,
      bookOptions: [],
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        isbn: null,
        bookName: null,
        urgency: null,
        handleStatus: null
      },
      rules: {
        bookId: [{ required: true, message: "请选择教材", trigger: "change" }],
        lackNum: [{ required: true, message: "请输入缺书数量", trigger: "blur" }],
        urgency: [{ required: true, message: "请选择紧急程度", trigger: "change" }]
      }
    };
  },
  created() {
    this.getList();
  },
  methods: {
    getList() {
      this.loading = true;
      getShortageList(this.queryParams).then(response => {
        this.shortageList = response.rows;
        this.total = response.total;
        this.loading = false;
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
      this.title = "登记缺书";
      this.open = true;
    },
    handleEdit(row) {
      this.reset();
      getShortageInfo(row.lackId).then(response => {
        this.form = response.data;
        this.title = "编辑缺书";
        this.open = true;
      });
    },
    reset() {
      this.form = { lackId: null, bookId: null, isbn: null, bookName: null, lackNum: 1, urgency: '0', remark: null };
      this.bookOptions = [];
      this.resetForm("form");
    },
    cancel() {
      this.open = false;
      this.reset();
    },
    searchBooks(query) {
      if (query.length < 1) { this.bookOptions = []; return; }
      this.bookLoading = true;
      listBook({ bookName: query, pageSize: 20 }).then(res => {
        this.bookOptions = res.rows || [];
        this.bookLoading = false;
      }).catch(() => { this.bookLoading = false; });
    },
    onBookSelect(bookId) {
      const selected = this.bookOptions.find(item => item.bookId === bookId);
      if (selected) {
        this.form.isbn = selected.isbn || '';
        this.form.bookName = selected.bookName || '';
      }
    },
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.lackId != null) {
            updateShortage(this.form).then(() => {
              this.$modal.msgSuccess("修改成功");
              this.open = false;
              this.getList();
            });
          } else {
            addShortage(this.form).then(() => {
              this.$modal.msgSuccess("登记成功");
              this.open = false;
              this.getList();
            });
          }
        }
      });
    },
    handleView(row) {
      getShortageInfo(row.lackId).then(response => {
        this.viewData = response.data;
        this.viewOpen = true;
      });
    },
    handleProcess(row) {
      this.processData = { ...row };
      this.processOpen = true;
    },
    confirmProcess() {
      processShortage(this.processData.lackId, '1').then(() => {
        this.$modal.msgSuccess("已转为采购需求");
        this.processOpen = false;
        this.getList();
      });
    },
    handleDelete(row) {
      this.$modal.confirm('是否确认删除该缺书记录？').then(() => {
        return deleteShortage(row.lackId);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("删除成功");
      }).catch(() => {});
    },
    handleExport() {
      this.download('textbook/shortage/export', { ...this.queryParams }, `缺书数据_${new Date().getTime()}.xlsx`);
    },
    getUrgencyType(level) { return level === '2' ? 'danger' : level === '1' ? 'warning' : 'info'; },
    getUrgencyLabel(level) { return level === '2' ? '特急' : level === '1' ? '紧急' : '普通'; },
    getStatusType(status) { return status === '3' ? 'success' : status === '2' ? 'info' : status === '1' ? 'warning' : 'danger'; },
    getStatusLabel(status) { return status === '3' ? '已完成' : status === '2' ? '已到货' : status === '1' ? '已纳入采购' : '未处理'; }
  }
};
</script>
