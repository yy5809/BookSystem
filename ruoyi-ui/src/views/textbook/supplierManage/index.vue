<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="88px">
      <el-form-item label="供应商名称" prop="supplierName">
        <el-input v-model="queryParams.supplierName" placeholder="请输入供应商名称" clearable @keyup.enter.native="handleQuery" />
      </el-form-item>
      <el-form-item label="供应商编码" prop="supplierCode">
        <el-input v-model="queryParams.supplierCode" placeholder="请输入供应商编码" clearable @keyup.enter.native="handleQuery" />
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
      <el-table-column label="登录账号" align="center" prop="userName" width="130" show-overflow-tooltip />
      <el-table-column label="联系人" align="center" prop="contactPerson" width="100" />
      <el-table-column label="联系电话" align="center" prop="contactPhone" width="130" />
      <el-table-column label="付款账期" align="center" prop="paymentTerms" width="100" />
      <el-table-column label="状态" align="center" width="80">
        <template slot-scope="scope">
          <el-tag :type="scope.row.status === '0' ? 'success' : 'danger'" size="mini">{{ scope.row.status === '0' ? '正常' : '停用' }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width" width="180">
        <template slot-scope="scope">
          <el-button size="mini" type="text" icon="el-icon-edit" @click="handleUpdate(scope.row)" v-hasPermi="['textbook:supplier:edit']">修改</el-button>
          <el-button size="mini" type="text" icon="el-icon-key" @click="handleResetPwd(scope.row)" v-hasPermi="['textbook:supplier:edit']">重置密码</el-button>
          <el-button size="mini" type="text" icon="el-icon-delete" style="color:#F56C6C" @click="handleDelete(scope.row)" v-hasPermi="['textbook:supplier:remove']">删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />

    <el-dialog :title="title" :visible.sync="open" width="580px" append-to-body :close-on-click-modal="false">
      <el-form ref="form" :model="form" :rules="rules" label-width="100px">
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="供应商编码" prop="supplierCode">
              <el-input v-model="form.supplierCode" placeholder="请输入编码" :disabled="form.supplierId != null" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="供应商名称" prop="supplierName">
              <el-input v-model="form.supplierName" placeholder="请输入名称" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="联系人" prop="contactPerson">
              <el-input v-model="form.contactPerson" placeholder="请输入联系人" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="联系电话">
              <el-input v-model="form.contactPhone" placeholder="请输入联系电话" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="邮箱">
              <el-input v-model="form.contactEmail" placeholder="请输入邮箱" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="地址">
              <el-input v-model="form.address" placeholder="请输入地址" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="折扣率(%)">
              <el-input-number v-model="form.discountRate" :min="0" :max="100" :precision="1" style="width:100%" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="付款账期">
              <el-input v-model="form.paymentTerms" placeholder="如：月结30天" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="开户银行">
              <el-input v-model="form.bankName" placeholder="请输入开户银行" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="银行账号">
              <el-input v-model="form.bankAccount" placeholder="请输入银行账号" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="税号">
              <el-input v-model="form.taxNumber" placeholder="请输入税号" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item v-if="form.supplierId == null" label="登录密码" prop="password">
              <el-input v-model="form.password" placeholder="请输入登录密码" type="password" maxlength="20" show-password />
            </el-form-item>
          </el-col>
        </el-row>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitForm">确 定</el-button>
        <el-button @click="cancel">取 消</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { listSupplierAccount, getSupplierAccount, addSupplierAccount, updateSupplierAccount, delSupplierAccount, resetSupplierPwd } from "@/api/textbook/supplier";

export default {
  name: "SupplierManage",
  data() {
    return {
      loading: true,
      submitLoading: false,
      ids: [],
      single: true,
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
        supplierCode: null
      },
      rules: {
        supplierCode: [{ required: true, message: "请输入供应商编码", trigger: "blur" }],
        supplierName: [{ required: true, message: "请输入供应商名称", trigger: "blur" }],
        contactPerson: [{ required: true, message: "请输入联系人", trigger: "blur" }],
        password: [
          { required: true, message: "请输入登录密码", trigger: "blur" },
          { min: 5, max: 20, message: '密码长度必须介于 5 和 20 之间', trigger: 'blur' },
          { pattern: /^[^<>"'|\\]+$/, message: "不能包含非法字符：< > \" ' \\ |", trigger: "blur" }
        ]
      }
    };
  },
  created() {
    this.getList();
  },
  methods: {
    getList() {
      this.loading = true;
      listSupplierAccount(this.queryParams).then(response => {
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
      getSupplierAccount(row.supplierId).then(response => {
        this.form = response.data;
        this.form.userId = response.data.userId;
        this.title = "修改供应商";
        this.open = true;
      });
    },
    handleResetPwd(row) {
      this.$prompt('请输入供应商"' + row.supplierName + '"的新密码', "提示", {
        confirmButtonText: "确定",
        cancelButtonText: "取消",
        closeOnClickModal: false,
        inputPattern: /^.{5,20}$/,
        inputErrorMessage: "密码长度必须介于 5 和 20 之间",
        inputValidator: (value) => {
          if (/<|>|"|'|\||\\/.test(value)) {
            return "不能包含非法字符：< > \" ' \\ |"
          }
        }
      }).then(({ value }) => {
        resetSupplierPwd(row.userId, value).then(response => {
          this.$modal.msgSuccess("密码重置成功，新密码是：" + value)
        })
      }).catch(() => {});
    },
    reset() {
      this.form = {
        supplierId: null, supplierCode: null, supplierName: null,
        contactPerson: null, contactPhone: null, contactEmail: null,
        address: null, discountRate: 100, paymentTerms: null,
        bankName: null, bankAccount: null, taxNumber: null,
        status: '0', password: null, userId: null
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
          this.submitLoading = true;
          const data = { ...this.form };
          if (this.form.supplierId != null) {
            updateSupplierAccount(data).then(() => {
              this.$modal.msgSuccess("修改成功");
              this.open = false;
              this.getList();
            }).catch(() => {}).finally(() => { this.submitLoading = false; });
          } else {
            addSupplierAccount(data).then(() => {
              this.$modal.msgSuccess("新增成功");
              this.open = false;
              this.getList();
            }).catch(() => {}).finally(() => { this.submitLoading = false; });
          }
        }
      });
    },
    handleDelete(row) {
      this.$modal.confirm('是否确认删除供应商"' + row.supplierName + '"？<br/>将同时删除供应商的登录账号').then(() => {
        return delSupplierAccount(row.supplierId);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("删除成功");
      }).catch(() => {});
    },
    handleExport() {
      this.download('textbook/supplierAccount/export', { ...this.queryParams }, `供应商数据_${new Date().getTime()}.xlsx`);
    }
  }
};
</script>
