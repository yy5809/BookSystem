<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="88px">
      <el-form-item label="供应商名称" prop="supplierName">
        <el-input v-model="queryParams.supplierName" placeholder="请输入供应商名称" clearable @keyup.enter.native="handleQuery" />
      </el-form-item>
      <el-form-item label="联系人" prop="contactPerson">
        <el-input v-model="queryParams.contactPerson" placeholder="请输入联系人" clearable @keyup.enter.native="handleQuery" />
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button type="primary" plain icon="el-icon-plus" size="mini" @click="handleAdd" v-hasPermi="['textbook:supplier:add']">新增</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="success" plain icon="el-icon-download" size="mini" @click="handleExport" v-hasPermi="['textbook:supplier:export']">导出</el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="supplierList" border stripe>
      <el-table-column label="供应商编码" align="center" prop="supplierCode" width="130" />
      <el-table-column label="供应商名称" align="center" prop="supplierName" min-width="180" show-overflow-tooltip />
      <el-table-column label="联系人" align="center" prop="contactPerson" width="100" />
      <el-table-column label="联系电话" align="center" prop="contactPhone" width="130" />
      <el-table-column label="折扣率(%)" align="center" prop="discountRate" width="100">
        <template slot-scope="scope">{{ scope.row.discountRate || 100 }}%</template>
      </el-table-column>
      <el-table-column label="付款账期" align="center" prop="paymentTerm" width="100" />
      <el-table-column label="状态" align="center" prop="status" width="80">
        <template slot-scope="scope">
          <el-tag :type="scope.row.status === '0' ? 'success' : 'danger'" size="mini">{{ scope.row.status === '0' ? '正常' : '停用' }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width" width="150">
        <template slot-scope="scope">
          <el-button size="mini" type="text" icon="el-icon-edit" @click="handleUpdate(scope.row)" v-hasPermi="['textbook:supplier:edit']">修改</el-button>
          <el-button size="mini" type="text" icon="el-icon-delete" style="color:#F56C6C" @click="handleDelete(scope.row)" v-hasPermi="['textbook:supplier:remove']">删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />

    <el-dialog :title="title" :visible.sync="open" width="550px" append-to-body :close-on-click-modal="false">
      <el-form ref="form" :model="form" :rules="rules" label-width="100px">
        <el-form-item label="供应商编码" prop="supplierCode">
          <el-input v-model="form.supplierCode" placeholder="请输入供应商编码" />
        </el-form-item>
        <el-form-item label="供应商名称" prop="supplierName">
          <el-input v-model="form.supplierName" placeholder="请输入供应商名称" />
        </el-form-item>
        <el-form-item label="联系人" prop="contactPerson">
          <el-input v-model="form.contactPerson" placeholder="请输入联系人" />
        </el-form-item>
        <el-form-item label="联系电话" prop="contactPhone">
          <el-input v-model="form.contactPhone" placeholder="请输入联系电话" />
        </el-form-item>
        <el-form-item label="折扣率(%)" prop="discountRate">
          <el-input-number v-model="form.discountRate" :min="0" :max="100" :precision="1" />
        </el-form-item>
        <el-form-item label="付款账期" prop="paymentTerm">
          <el-input v-model="form.paymentTerm" placeholder="如：月结30天" />
        </el-form-item>
        <el-form-item label="状态" prop="status">
          <el-radio-group v-model="form.status">
            <el-radio label="0">正常</el-radio>
            <el-radio label="1">停用</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="备注" prop="remark">
          <el-input v-model="form.remark" type="textarea" placeholder="请输入备注" :rows="3" />
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitForm">确 定</el-button>
        <el-button @click="cancel">取 消</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { listSupplier, getSupplier, addSupplier, updateSupplier, delSupplier } from "@/api/textbook/supplier";

export default {
  name: "SupplierManage",
  data() {
    return {
      loading: true,
      total: 0,
      supplierList: [],
      showSearch: true,
      title: "",
      open: false,
      form: {},
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        supplierName: null,
        contactPerson: null
      },
      rules: {
        supplierCode: [{ required: true, message: "请输入供应商编码", trigger: "blur" }],
        supplierName: [{ required: true, message: "请输入供应商名称", trigger: "blur" }],
        contactPerson: [{ required: true, message: "请输入联系人", trigger: "blur" }],
        contactPhone: [{ required: true, message: "请输入联系电话", trigger: "blur" }]
      }
    };
  },
  created() {
    this.getList();
  },
  methods: {
    getList() {
      this.loading = true;
      listSupplier(this.queryParams).then(response => {
        this.supplierList = response.rows;
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
      this.title = "新增供应商";
      this.open = true;
    },
    handleUpdate(row) {
      this.reset();
      getSupplier(row.supplierId).then(response => {
        this.form = response.data;
        this.title = "修改供应商";
        this.open = true;
      });
    },
    reset() {
      this.form = { supplierId: null, supplierCode: null, supplierName: null, contactPerson: null, contactPhone: null, discountRate: 100, paymentTerm: null, status: '0', remark: null };
      this.resetForm("form");
    },
    cancel() {
      this.open = false;
      this.reset();
    },
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.supplierId != null) {
            updateSupplier(this.form).then(() => {
              this.$modal.msgSuccess("修改成功");
              this.open = false;
              this.getList();
            });
          } else {
            addSupplier(this.form).then(() => {
              this.$modal.msgSuccess("新增成功");
              this.open = false;
              this.getList();
            });
          }
        }
      });
    },
    handleDelete(row) {
      this.$modal.confirm('是否确认删除供应商"' + row.supplierName + '"？').then(() => {
        return delSupplier(row.supplierId);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("删除成功");
      }).catch(() => {});
    },
    handleExport() {
      this.download('textbook/supplier/export', { ...this.queryParams }, `供应商数据_${new Date().getTime()}.xlsx`);
    }
  }
};
</script>
