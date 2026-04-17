<template>
  <div class="app-container">
    <el-card>
      <template #header>
        <div class="card-header">
          <span>供应商管理</span>
          <div>
            <el-button type="primary" icon="el-icon-plus" @click="handleAdd" v-hasPermi="['textbook:supplier:add']" v-hasRole="['admin','purchaser']">新增</el-button>
            <el-button type="success" icon="el-icon-download" @click="handleExport" v-hasPermi="['textbook:supplier:export']">导出</el-button>
          </div>
        </div>
      </template>

      <el-form :inline="true" :model="queryParams" class="search-form">
        <el-form-item label="供应商编码">
          <el-input v-model="queryParams.supplierCode" placeholder="请输入编码" clearable style="width: 180px" />
        </el-form-item>
        <el-form-item label="供应商名称">
          <el-input v-model="queryParams.supplierName" placeholder="请输入名称" clearable style="width: 200px" />
        </el-form-item>
        <el-form-item label="联系人">
          <el-input v-model="queryParams.contactPerson" placeholder="请输入联系人" clearable style="width: 120px" />
        </el-form-item>
        <el-form-item label="状态">
          <el-select v-model="queryParams.status" placeholder="全部" clearable style="width: 100px">
            <el-option label="正常" value="0" />
            <el-option label="停用" value="1" />
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" icon="el-icon-search" @click="handleQuery">查询</el-button>
          <el-button icon="el-icon-refresh" @click="resetQuery">重置</el-button>
        </el-form-item>
      </el-form>

      <el-table ref="tableRef" :data="supplierList" v-loading="loading" border stripe @selection-change="handleSelectionChange">
        <template slot="empty">
          <div class="empty-state">
            <i class="el-icon-office-building empty-icon"></i>
            <p class="empty-title">暂无供应商记录</p>
            <p class="empty-desc">您可以添加常用的教材出版社和供应商信息</p>
            <el-button type="primary" icon="el-icon-plus" size="small" @click="handleAdd" v-hasPermi="['textbook:supplier:add']" v-hasRole="['admin','purchaser']">添加第一个供应商</el-button>
          </div>
        </template>
        <el-table-column type="selection" width="45" align="center" />
        <el-table-column type="index" label="序号" width="60" align="center" />
        <el-table-column prop="supplierCode" label="供应商编码" width="120" align="center">
          <template slot-scope="scope">
            <span class="code-text">{{ scope.row.supplierCode }}</span>
          </template>
        </el-table-column>
        <el-table-column prop="supplierName" label="供应商名称" min-width="160" show-overflow-tooltip>
          <template slot-scope="scope">
            <strong>{{ scope.row.supplierName }}</strong>
          </template>
        </el-table-column>
        <el-table-column prop="contactPerson" label="联系人" width="90" align="center" />
        <el-table-column prop="contactPhone" label="联系电话" width="120" align="center">
          <template slot-scope="scope">
            <span v-if="scope.row.contactPhone" class="phone-text">{{ scope.row.contactPhone }}</span>
            <span v-else class="text-muted">-</span>
          </template>
        </el-table-column>
        <el-table-column prop="discountRate" label="折扣率" width="85" align="center">
          <template slot-scope="scope">
            <el-tag :type="getDiscountType(scope.row.discountRate)" size="small">{{ scope.row.discountRate }}%</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="paymentTerms" label="付款账期" width="100" align="center" show-overflow-tooltip />
        <el-table-column prop="address" label="地址" min-width="150" show-overflow-tooltip />
        <el-table-column prop="status" label="状态" width="75" align="center">
          <template slot-scope="scope">
            <el-tag :type="scope.row.status === '0' ? 'success' : 'danger'" size="small">
              {{ scope.row.status === '0' ? '正常' : '停用' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="createTime" label="创建时间" width="155" align="center" sortable />
        <el-table-column label="操作" width="200" align="center" fixed="right">
          <template slot-scope="scope">
            <el-button size="mini" type="text" icon="el-icon-view" @click="handleView(scope.row)">详情</el-button>
            <el-button size="mini" type="text" icon="el-icon-edit" @click="handleEdit(scope.row)" v-hasPermi="['textbook:supplier:edit']" v-hasRole="['admin','purchaser']">修改</el-button>
            <el-button size="mini" type="text" icon="el-icon-delete" style="color:#F56C6C" @click="handleDelete(scope.row)" v-hasPermi="['textbook:supplier:remove']" v-hasRole="['admin','purchaser']">删除</el-button>
          </template>
        </el-table-column>
      </el-table>

      <el-pagination
        class="pagination-container"
        :current-page="queryParams.pageNum"
        :page-size="queryParams.pageSize"
        :total="total"
        :page-sizes="[10, 20, 50, 100]"
        layout="total, sizes, prev, pager, next, jumper"
        @size-change="handleSizeChange"
        @current-change="handleCurrentChange"
      />
    </el-card>

    <el-dialog title="供应商详情" :visible.sync="detailVisible" width="700px" append-to-body>
      <el-descriptions :column="2" border size="medium">
        <el-descriptions-item label="供应商编码" :span="1"><span class="code-text-lg">{{ detailData.supplierCode }}</span></el-descriptions-item>
        <el-descriptions-item label="状态" :span="1">
          <el-tag :type="detailData.status === '0' ? 'success' : 'danger'" size="small">{{ detailData.status === '0' ? '正常' : '停用' }}</el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="供应商名称" :span="2"><strong>{{ detailData.supplierName }}</strong></el-descriptions-item>
        <el-descriptions-item label="联系人">{{ detailData.contactPerson || '-' }}</el-descriptions-item>
        <el-descriptions-item label="联系电话">
          <span v-if="detailData.contactPhone" class="phone-text">{{ detailData.contactPhone }}</span>
          <span v-else>-</span>
        </el-descriptions-item>
        <el-descriptions-item label="联系邮箱">{{ detailData.contactEmail || '-' }}</el-descriptions-item>
        <el-descriptions-item label="折扣率">
          <el-tag :type="getDiscountType(detailData.discountRate)" size="small">{{ detailData.discountRate }}%</el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="付款账期">{{ detailData.paymentTerms || '未设置' }}</el-descriptions-item>
        <el-descriptions-item label="开户银行">{{ detailData.bankName || '-' }}</el-descriptions-item>
        <el-descriptions-item label="银行账号">
          <span v-if="detailData.bankAccount" class="account-text">{{ detailData.bankAccount }}</span>
          <span v-else>-</span>
        </el-descriptions-item>
        <el-descriptions-item label="税号">{{ detailData.taxNumber || '-' }}</el-descriptions-item>
        <el-descriptions-item label="地址" :span="2">{{ detailData.address || '-' }}</el-descriptions-item>
        <el-descriptions-item label="创建时间">{{ detailData.createTime }}</el-descriptions-item>
        <el-descriptions-item label="备注" :span="2">{{ detailData.remark || '无' }}</el-descriptions-item>
      </el-descriptions>
      <div slot="footer">
        <el-button @click="detailVisible = false">关闭</el-button>
        <el-button type="primary" icon="el-icon-edit" @click="handleEditFromDetail" v-hasPermi="['textbook:supplier:edit']" v-hasRole="['admin','purchaser']">编辑</el-button>
      </div>
    </el-dialog>

    <el-dialog :title="dialogTitle" :visible.sync="dialogVisible" width="650px" append-to-body destroy-on-close>
      <el-form ref="form" :model="form" :rules="rules" label-width="110px">
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="供应商编码" prop="supplierCode">
              <el-input v-model="form.supplierCode" placeholder="如：SUP006" maxlength="32" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="供应商名称" prop="supplierName">
              <el-input v-model="form.supplierName" placeholder="请输入供应商名称" maxlength="100" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="联系人" prop="contactPerson">
              <el-input v-model="form.contactPerson" placeholder="请输入联系人姓名" maxlength="50" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="联系电话" prop="contactPhone">
              <el-input v-model="form.contactPhone" placeholder="手机或座机" maxlength="20" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="联系邮箱">
              <el-input v-model="form.contactEmail" placeholder="可选" maxlength="100" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="状态" prop="status">
              <el-radio-group v-model="form.status">
                <el-radio label="0">正常</el-radio>
                <el-radio label="1">停用</el-radio>
              </el-radio-group>
            </el-form-item>
          </el-col>
        </el-row>
        <el-form-item label="地址">
          <el-input v-model="form.address" placeholder="详细地址" maxlength="255" />
        </el-form-item>
        <el-divider content-position="left">商务信息</el-divider>
        <el-row :gutter="20">
          <el-col :span="8">
            <el-form-item label="折扣率(%)" prop="discountRate">
              <el-input-number v-model="form.discountRate" :min="0" :max="100" :precision="2" controls-position="right" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="付款账期">
              <el-select v-model="form.paymentTerms" placeholder="选择账期" style="width: 100%">
                <el-option label="现结" value="现结" />
                <el-option label="月结15天" value="月结15天" />
                <el-option label="月结30天" value="月结30天" />
                <el-option label="月结45天" value="月结45天" />
                <el-option label="月结60天" value="月结60天" />
                <el-option label="季结" value="季结" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="税号">
              <el-input v-model="form.taxNumber" placeholder="纳税人识别号" maxlength="32" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="开户银行">
              <el-input v-model="form.bankName" placeholder="可选" maxlength="100" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="银行账号">
              <el-input v-model="form.bankAccount" placeholder="可选" maxlength="32" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-form-item label="备注">
          <el-input v-model="form.remark" type="textarea" :rows="3" placeholder="备注信息（可选）" maxlength="500" />
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleSubmitForm">确定</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { listSupplier, getSupplier, addSupplier, updateSupplier, delSupplier } from '@/api/textbook/supplier'

export default {
  name: 'SupplierIndex',
  data() {
    return {
      loading: false,
      queryParams: { pageNum: 1, pageSize: 10, supplierCode: '', supplierName: '', contactPerson: '', status: '' },
      supplierList: [],
      total: 0,
      selectedRows: [],
      detailVisible: false,
      detailData: {},
      dialogVisible: false,
      dialogTitle: '',
      form: {
        supplierId: undefined,
        supplierCode: '',
        supplierName: '',
        contactPerson: '',
        contactPhone: '',
        contactEmail: '',
        address: '',
        discountRate: 100.00,
        paymentTerms: '月结30天',
        bankName: '',
        bankAccount: '',
        taxNumber: '',
        status: '0',
        remark: ''
      },
      rules: {
        supplierCode: [
          { required: true, message: '请输入供应商编码', trigger: 'blur' },
          { pattern: /^[A-Z]{2,}\d{2,}$/, message: '编码格式：大写字母+数字（如SUP001）', trigger: 'blur' }
        ],
        supplierName: [
          { required: true, message: '请输入供应商名称', trigger: 'blur' },
          { min: 2, max: 100, message: '名称长度在 2 到 100 个字符之间', trigger: 'blur' }
        ],
        discountRate: [
          { required: true, message: '请输入折扣率', trigger: 'blur' }
        ],
        status: [
          { required: true, message: '请选择状态', trigger: 'change' }
        ]
      }
    }
  },
  created() {
    this.getList()
  },
  methods: {
    getList() {
      this.loading = true
      listSupplier(this.queryParams).then(response => {
        this.supplierList = response.rows || []
        this.total = response.total || 0
      }).catch(err => {
        console.error('=== SUPPLIER LIST ERROR ===', err)
        this.$message.error('获取供应商列表失败')
      }).finally(() => { this.loading = false })
    },
    handleQuery() {
      this.queryParams.pageNum = 1
      this.getList()
    },
    resetQuery() {
      this.queryParams = { pageNum: 1, pageSize: 10, supplierCode: '', supplierName: '', contactPerson: '', status: '' }
      this.getList()
    },
    handleSizeChange(val) {
      this.queryParams.pageSize = val
      this.getList()
    },
    handleCurrentChange(val) {
      this.queryParams.pageNum = val
      this.getList()
    },
    handleSelectionChange(rows) {
      this.selectedRows = rows
    },

    getDiscountType(rate) {
      if (rate >= 90) return ''
      if (rate >= 80) return 'success'
      if (rate >= 70) return 'warning'
      return 'danger'
    },

    handleView(row) {
      getSupplier(row.supplierId).then(response => {
        this.detailData = response.data
        this.detailVisible = true
      })
    },

    handleAdd() {
      this.dialogTitle = '新增供应商'
      this.resetForm()
      this.dialogVisible = true
    },

    handleEdit(row) {
      this.dialogTitle = '编辑供应商'
      getSupplier(row.supplierId).then(response => {
        this.form = { ...response.data }
        this.dialogVisible = true
      })
    },

    handleEditFromDetail() {
      this.detailVisible = false
      this.handleEdit(this.detailData)
    },

    resetForm() {
      this.form = {
        supplierId: undefined,
        supplierCode: '',
        supplierName: '',
        contactPerson: '',
        contactPhone: '',
        contactEmail: '',
        address: '',
        discountRate: 100.00,
        paymentTerms: '月结30天',
        bankName: '',
        bankAccount: '',
        taxNumber: '',
        status: '0',
        remark: ''
      }
      if (this.$refs.form) {
        this.$refs.form.clearValidate()
      }
    },

    handleSubmitForm() {
      this.$refs.form.validate(valid => {
        if (!valid) return
        const action = this.form.supplierId ? updateSupplier(this.form) : addSupplier(this.form)
        action.then(() => {
          this.$message.success(this.form.supplierId ? '修改成功' : '新增成功')
          this.dialogVisible = false
          this.getList()
        }).catch(() => {
          this.$message.error(this.form.supplierId ? '修改失败' : '新增失败')
        })
      })
    },

    handleDelete(row) {
      this.$confirm(`确定删除供应商「${row.supplierName}」吗？`, '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        delSupplier(row.supplierId).then(() => {
          this.$message.success('删除成功')
          this.getList()
        }).catch(() => {
          this.$message.error('删除失败')
        })
      }).catch(() => {})
    },

    handleExport() {
      this.$confirm('确认导出所有供应商数据?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        const queryParams = { ...this.queryParams }
        delete queryParams.pageNum
        delete queryParams.pageSize
        const form = document.createElement('form')
        form.method = 'POST'
        form.action = process.env.VUE_APP_BASE_API + '/textbook/supplier/export'
        Object.keys(queryParams).forEach(key => {
          if (queryParams[key]) {
            const input = document.createElement('input')
            input.type = 'hidden'
            input.name = key
            input.value = queryParams[key]
            form.appendChild(input)
          }
        })
        form.style.display = 'none'
        document.body.appendChild(form)
        form.submit()
        document.body.removeChild(form)
        this.$message.success('正在导出，请稍候...')
      }).catch(() => {})
    }
  }
}
</script>

<style scoped>
.card-header { display: flex; justify-content: space-between; align-items: center; }
.search-form { margin-bottom: 16px; }
.pagination-container { margin-top: 18px; display: flex; justify-content: flex-end; }

.code-text {
  color: #409EFF;
  font-weight: 600;
  font-family: 'Courier New', monospace;
  font-size: 13px;
}
.code-text-lg {
  color: #409EFF;
  font-weight: 600;
  font-family: 'Courier New', monospace;
  font-size: 15px;
}
.phone-text {
  font-family: 'Courier New', monospace;
  font-size: 13px;
  color: #606266;
}
.account-text {
  font-family: 'Courier New', monospace;
  font-size: 13px;
  letter-spacing: 1px;
}
.text-muted { color: #909399; }

.empty-state {
  padding: 40px 20px;
  text-align: center;
}
.empty-icon {
  font-size: 64px;
  color: #dcdfe6;
  margin-bottom: 16px;
}
.empty-title {
  font-size: 16px;
  color: #606266;
  margin: 0 0 8px 0;
  font-weight: 500;
}
.empty-desc {
  font-size: 13px;
  color: #909399;
  margin: 0 0 20px 0;
}

.dialog-footer {
  text-align: right;
}

@media screen and (max-width: 1400px) {
  .el-table { font-size: 13px; }
  .el-button--mini { padding: 4px 7px; font-size: 12px; }
}
@media screen and (max-width: 1100px) {
  .el-form-item { margin-right: 8px; }
  .el-input { width: 140px !important; }
  .el-select { width: 110px !important; }
}
</style>
