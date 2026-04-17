<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="ISBN" prop="isbn">
        <el-input v-model="queryParams.isbn" placeholder="请输入ISBN" clearable @keyup.enter.native="handleQuery" />
      </el-form-item>
      <el-form-item label="教材名称" prop="bookName">
        <el-input v-model="queryParams.bookName" placeholder="请输入教材名称" clearable @keyup.enter.native="handleQuery" />
      </el-form-item>
      <el-form-item label="紧急程度" prop="urgencyLevel">
        <el-select v-model="queryParams.urgencyLevel" placeholder="请选择" clearable>
          <el-option v-for="dict in dict.type.emergency_level" :key="dict.value" :label="dict.label" :value="dict.value" />
        </el-select>
      </el-form-item>
      <el-form-item label="状态" prop="status">
        <el-select v-model="queryParams.status" placeholder="请选择" clearable>
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
        <el-button type="primary" plain icon="el-icon-plus" size="mini" @click="handleAdd" v-hasPermi="['textbook:registerShortage:add']">登记缺书</el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="shortageList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="ISBN" align="center" prop="isbn" width="140" />
      <el-table-column label="教材名称" align="center" prop="bookName" show-overflow-tooltip min-width="180" />
      <el-table-column label="缺书数量" align="center" prop="shortageQty" width="90" />
      <el-table-column label="紧急程度" align="center" prop="urgencyLevel" width="100">
        <template slot-scope="scope">
          <el-tag :type="getUrgencyType(scope.row.urgencyLevel)" size="mini">{{ getUrgencyLabel(scope.row.urgencyLevel) }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="状态" align="center" prop="status" width="100">
        <template slot-scope="scope">
          <el-tag :type="getStatusType(scope.row.status)" size="mini">{{ getStatusLabel(scope.row.status) }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="登记人" align="center" prop="createBy" width="90" />
      <el-table-column label="登记时间" align="center" prop="createTime" width="160" />
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width" width="150">
        <template slot-scope="scope">
          <el-button size="mini" type="text" icon="el-icon-view" @click="handleView(scope.row)">详情</el-button>
          <el-button size="mini" type="text" icon="el-icon-edit" @click="handleUpdate(scope.row)" v-if="scope.row.status === '0'" v-hasPermi="['textbook:registerShortage:add']">编辑</el-button>
          <el-button size="mini" type="text" icon="el-icon-delete" @click="handleDelete(scope.row)" v-if="scope.row.status === '0'" v-hasPermi="['textbook:registerShortage:add']">删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />

    <el-dialog :title="title" :visible.sync="open" width="550px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="100px">
        <el-form-item label="ISBN" prop="isbn">
          <el-input v-model="form.isbn" placeholder="请输入教材ISBN（10位或13位）" maxlength="13" />
        </el-form-item>
        <el-form-item label="教材名称" prop="bookName">
          <el-input v-model="form.bookName" placeholder="请输入教材名称" />
        </el-form-item>
        <el-form-item label="缺书数量" prop="shortageQty">
          <el-input-number v-model="form.shortageQty" :min="1" :max="9999" />
        </el-form-item>
        <el-form-item label="紧急程度" prop="urgencyLevel">
          <el-radio-group v-model="form.urgencyLevel">
            <el-radio v-for="dict in dict.type.emergency_level" :key="dict.value" :label="dict.value">{{ dict.label }}</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="备注说明" prop="remark">
          <el-input v-model="form.remark" type="textarea" placeholder="请输入缺书原因或补充说明" :rows="3" />
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
        <el-descriptions-item label="缺书数量">{{ viewData.shortageQty }} 本</el-descriptions-item>
        <el-descriptions-item label="紧急程度">
          <el-tag :type="getUrgencyType(viewData.urgencyLevel)">{{ getUrgencyLabel(viewData.urgencyLevel) }}</el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="状态">
          <el-tag :type="getStatusType(viewData.status)">{{ getStatusLabel(viewData.status) }}</el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="登记人">{{ viewData.createBy }}</el-descriptions-item>
        <el-descriptions-item label="登记时间">{{ viewData.createTime }}</el-descriptions-item>
        <el-descriptions-item label="备注" :span="2">{{ viewData.remark || '-' }}</el-descriptions-item>
      </el-descriptions>
      <div slot="footer" class="dialog-footer">
        <el-button @click="viewOpen = false">关 闭</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { listShortage, addShortage, updateShortage, delShortage } from "@/api/textbook/shortage";

export default {
  name: "RegisterShortage",
  dicts: ['emergency_level'],
  data() {
    return {
      loading: true,
      ids: [],
      single: true,
      multiple: true,
      total: 0,
      shortageList: [],
      title: "登记缺书",
      open: false,
      viewOpen: false,
      form: {},
      viewData: {},
      showSearch: true,
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        isbn: null,
        bookName: null,
        urgencyLevel: null,
        status: null
      },
      rules: {
        isbn: [{ required: true, message: "请输入ISBN", trigger: "blur" }],
        bookName: [{ required: true, message: "请输入教材名称", trigger: "blur" }],
        shortageQty: [{ required: true, message: "请输入缺书数量", trigger: "blur" }],
        urgencyLevel: [{ required: true, message: "请选择紧急程度", trigger: "change" }]
      }
    };
  },
  created() {
    this.getList();
  },
  methods: {
    getList() {
      this.loading = true;
      listShortage(this.queryParams).then(response => {
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
    handleSelectionChange(selection) {
      this.ids = selection.map(item => item.shortageId);
      this.single = selection.length !== 1;
      this.multiple = !selection.length;
    },
    handleAdd() {
      this.reset();
      this.title = "登记缺书";
      this.open = true;
    },
    handleUpdate(row) {
      this.reset();
      const data = { ...row };
      this.form = data;
      this.title = "编辑缺书信息";
      this.open = true;
    },
    reset() {
      this.form = { shortageId: null, isbn: null, bookName: null, shortageQty: 1, urgencyLevel: '0', remark: null };
      this.resetForm("form");
    },
    cancel() {
      this.open = false;
      this.reset();
    },
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.shortageId != null) {
            updateShortage(this.form).then(response => {
              this.$modal.msgSuccess("修改成功");
              this.open = false;
              this.getList();
            });
          } else {
            addShortage(this.form).then(response => {
              this.$modal.msgSuccess("登记成功，系统已通知库管员处理");
              this.open = false;
              this.getList();
            });
          }
        }
      });
    },
    handleView(row) {
      this.viewData = row;
      this.viewOpen = true;
    },
    handleDelete(row) {
      const shortageIds = row.shortageId || this.ids;
      this.$confirm('是否确认删除选中的数据项?', "警告", {
        confirmButtonText: "确定",
        cancelButtonText: "取消",
        type: "warning"
      }).then(function() {
        return delShortage(shortageIds);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("删除成功");
      });
    },
    getUrgencyType(level) { return level === '2' ? 'danger' : level === '1' ? 'warning' : 'info'; },
    getUrgencyLabel(level) { return level === '2' ? '特急' : level === '1' ? '紧急' : '普通'; },
    getStatusType(status) { return status === '3' ? 'success' : status === '2' ? '' : status === '1' ? 'warning' : 'danger'; },
    getStatusLabel(status) { return status === '3' ? '已完成' : status === '2' ? '已到货' : status === '1' ? '已纳入采购' : '未处理'; }
  }
};
</script>
