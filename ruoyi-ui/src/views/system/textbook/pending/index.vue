<template>
  <div class="app-container">
    <el-card>
      <template #header>
        <div class="card-header">
          <span>待购管理</span>
          <div>
            <el-button type="warning" icon="el-icon-plus" @click="handleAdd" v-hasPermi="['textbook:pending:add']">新增采购单</el-button>
            <el-button type="success" icon="el-icon-download" @click="handleExport" v-hasPermi="['textbook:pending:export']">导出</el-button>
          </div>
        </div>
      </template>

      <!-- 搜索区域 -->
      <el-form :inline="true" :model="queryParams" class="search-form">
        <el-form-item label="采购单号">
          <el-input v-model="queryParams.pendingNo" placeholder="请输入采购单号" clearable style="width: 200px" />
        </el-form-item>
        <el-form-item label="教材名称">
          <el-input v-model="queryParams.bookName" placeholder="请输入教材名称" clearable style="width: 180px" />
        </el-form-item>
        <el-form-item label="ISBN">
          <el-input v-model="queryParams.isbn" placeholder="请输入ISBN" clearable style="width: 170px" />
        </el-form-item>
        <el-form-item label="供应商">
          <el-input v-model="queryParams.supplier" placeholder="请输入供应商" clearable style="width: 150px" />
        </el-form-item>
        <el-form-item label="状态">
          <el-select v-model="queryParams.status" placeholder="全部" clearable style="width: 120px">
            <el-option label="待采购" value="0" />
            <el-option label="采购中" value="1" />
            <el-option label="已到货" value="2" />
            <el-option label="已入库" value="3" />
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" icon="el-icon-search" @click="handleQuery">查询</el-button>
          <el-button icon="el-icon-refresh" @click="resetQuery">重置</el-button>
        </el-form-item>
      </el-form>

      <!-- 数据表格 -->
      <el-table :data="pendingList" v-loading="loading" border stripe :max-height="tableMaxHeight">
        <el-table-column type="index" label="序号" width="60" align="center" />
        <el-table-column label="采购单号" min-width="190">
          <template slot-scope="scope">
            <span class="order-no" @click="copyToClipboard(scope.row.pendingNo)">
              {{ scope.row.pendingNo }}
              <i class="el-icon-document-copy copy-icon"></i>
            </span>
          </template>
        </el-table-column>
        <el-table-column prop="bookName" label="教材名称" min-width="150" show-overflow-tooltip />
        <el-table-column prop="isbn" label="ISBN" width="145">
          <template slot-scope="scope">
            <span class="isbn-text">{{ scope.row.isbn }}</span>
          </template>
        </el-table-column>
        <el-table-column prop="supplier" label="供应商" min-width="120" show-overflow-tooltip>
          <template slot-scope="scope">
            {{ scope.row.supplier || '-' }}
          </template>
        </el-table-column>
        <el-table-column prop="purchaseNum" label="采购数量" width="95" align="center">
          <template slot-scope="scope">
            <span class="num-highlight purchase-num">{{ scope.row.purchaseNum || 0 }}</span>
            <span class="unit">本</span>
          </template>
        </el-table-column>
        <el-table-column prop="status" label="状态" width="90" align="center">
          <template slot-scope="scope">
            <el-tag :type="getStatusType(scope.row.status)" size="small" effect="dark">
              {{ getStatusText(scope.row.status) }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="expectedDate" label="预计到货" width="110" align="center">
          <template slot-scope="scope">
            {{ scope.row.expectedDate || '-' }}
          </template>
        </el-table-column>
        <el-table-column prop="actualDate" label="实际到货" width="110" align="center">
          <template slot-scope="scope">
            <span :class="{ 'date-arrived': scope.row.actualDate }">{{ scope.row.actualDate || '-' }}</span>
          </template>
        </el-table-column>
        <el-table-column prop="purchaserName" label="采购负责人" width="100" align="center">
          <template slot-scope="scope">
            {{ scope.row.purchaserName || '-' }}
          </template>
        </el-table-column>
        <el-table-column prop="createTime" label="创建时间" width="155" align="center" sortable />
        <el-table-column label="操作" width="180" align="center" fixed="right">
          <template slot-scope="scope">
            <el-button size="mini" type="primary" icon="el-icon-view" @click="handleView(scope.row)">详情</el-button>
            <el-button v-if="scope.row.status === '0'" size="mini" type="warning" icon="el-icon-edit" @click="handleEdit(scope.row)" v-hasPermi="['textbook:pending:edit']">编辑</el-button>
            <el-button v-if="scope.row.status === '0'" size="mini" type="success" icon="el-icon-shopping-cart-2" @click="handleStartPurchase(scope.row)" v-hasPermi="['textbook:pending:edit']" v-hasRole="['admin','purchaser']">开始采购</el-button>
            <el-button v-if="scope.row.status === '1'" size="mini" type="warning" icon="el-icon-box" @click="handleArrive(scope.row)" v-hasPermi="['textbook:pending:edit']" v-hasRole="['admin','purchaser']">标记到货</el-button>
            <el-button v-if="scope.row.status === '2'" size="mini" type="success" icon="el-icon-finished" @click="handleInbound(scope.row)" v-hasPermi="['textbook:pending:edit']" v-hasRole="['admin','purchaser']">确认入库</el-button>
            <el-button v-if="scope.row.status !== '3'" size="mini" type="danger" icon="el-icon-delete" @click="handleDelete(scope.row)" v-hasPermi="['textbook:pending:remove']">删除</el-button>
          </template>
        </el-table-column>
      </el-table>

      <!-- 分页 -->
      <div class="pagination-container">
        <el-pagination
          :current-page="queryParams.pageNum"
          :page-size="queryParams.pageSize"
          :total="total"
          :page-sizes="[10, 20, 50, 100]"
          layout="total, sizes, prev, pager, next, jumper"
          @size-change="handleSizeChange"
          @current-change="handleCurrentChange"
        />
      </div>
    </el-card>

    <!-- 详情对话框 -->
    <el-dialog title="采购单详情" :visible.sync="detailVisible" width="650px" append-to-body>
      <el-descriptions :column="2" border size="medium">
        <el-descriptions-item label="采购单号" :span="2">
          <span class="detail-order-no">{{ detailData.pendingNo }}</span>
          <el-button type="text" icon="el-icon-document-copy" @click="copyToClipboard(detailData.pendingNo)" style="margin-left:8px">复制</el-button>
        </el-descriptions-item>
        <el-descriptions-item label="教材名称">{{ detailData.bookName }}</el-descriptions-item>
        <el-descriptions-item label="ISBN"><span class="isbn-text">{{ detailData.isbn }}</span></el-descriptions-item>
        <el-descriptions-item label="供应商">{{ detailData.supplier || '-' }}</el-descriptions-item>
        <el-descriptions-item label="供应商电话">{{ detailData.supplierPhone || '-' }}</el-descriptions-item>
        <el-descriptions-item label="采购数量">
          <span class="num-highlight purchase-num">{{ detailData.purchaseNum || 0 }}</span> 本
        </el-descriptions-item>
        <el-descriptions-item label="当前状态">
          <el-tag :type="getStatusType(detailData.status)" size="small" effect="dark">{{ getStatusText(detailData.status) }}</el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="预计到货">{{ detailData.expectedDate || '-' }}</el-descriptions-item>
        <el-descriptions-item label="实际到货">
          <span :class="{ 'date-arrived': detailData.actualDate }">{{ detailData.actualDate || '-' }}</span>
        </el-descriptions-item>
        <el-descriptions-item label="采购负责人">{{ detailData.purchaserName || '-' }}</el-descriptions-item>
        <el-descriptions-item label="创建时间">{{ detailData.createTime }}</el-descriptions-item>
        <el-descriptions-item label="备注" :span="2">{{ detailData.remark || '无' }}</el-descriptions-item>
      </el-descriptions>
      <div slot="footer">
        <el-button @click="detailVisible = false">关闭</el-button>
      </div>
    </el-dialog>

    <!-- 新增/编辑对话框 -->
    <el-dialog :title="dialogTitle" :visible.sync="dialogVisible" width="600px" append-to-body>
      <el-form :model="form" :rules="rules" ref="form" label-width="110px">
        <el-form-item label="教材名称" prop="bookId">
          <el-select v-model="form.bookId" filterable remote reserve-keyword
            placeholder="请搜索选择教材" :remote-method="searchBooks" :loading="bookLoading"
            style="width: 100%" @change="onBookSelect">
            <el-option v-for="item in bookOptions" :key="item.bookId"
              :label="item.bookName + (item.isbn ? ' (' + item.isbn + ')' : '')" :value="item.bookId" />
          </el-select>
        </el-form-item>
        <el-form-item label="ISBN">
          <el-input v-model="form.isbn" disabled />
        </el-form-item>
        <el-form-item label="采购数量" prop="purchaseNum">
          <el-input-number v-model="form.purchaseNum" :min="1" :max="9999" style="width: 100%" />
        </el-form-item>
        <el-form-item label="供应商" prop="supplier">
          <el-input v-model="form.supplier" placeholder="请输入供应商名称" />
        </el-form-item>
        <el-form-item label="供应商电话">
          <el-input v-model="form.supplierPhone" placeholder="请输入供应商联系电话" />
        </el-form-item>
        <el-form-item label="预计到货日期">
          <el-date-picker v-model="form.expectedDate" type="date" placeholder="选择预计到货日期"
            value-format="yyyy-MM-dd" style="width: 100%" />
        </el-form-item>
        <el-form-item label="采购负责人">
          <el-input v-model="form.purchaserName" placeholder="请输入采购负责人姓名" />
        </el-form-item>
        <el-form-item label="备注">
          <el-input v-model="form.remark" type="textarea" :rows="3" placeholder="请输入备注信息" />
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
import { getPendingList, getPendingInfo, addPending, updatePending, deletePending, processPending, confirmInbound } from '@/api/textbook/pending'
import { listBook } from '@/api/textbook/book'
import { getToken } from '@/utils/auth'

export default {
  name: 'PendingIndex',
  data() {
    return {
      loading: false,
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        pendingNo: '',
        bookName: '',
        isbn: '',
        supplier: '',
        status: ''
      },
      pendingList: [],
      total: 0,
      tableMaxHeight: 0,
      detailVisible: false,
      detailData: {},
      dialogVisible: false,
      dialogTitle: '',
      form: {
        pendingId: undefined,
        bookId: undefined,
        isbn: '',
        bookName: '',
        purchaseNum: 1,
        supplier: '',
        supplierPhone: '',
        expectedDate: '',
        purchaserName: '',
        remark: ''
      },
      rules: {
        bookId: [{ required: true, message: '请选择教材', trigger: 'change' }],
        purchaseNum: [
          { required: true, message: '请输入采购数量', trigger: 'blur' },
          { type: 'number', min: 1, max: 9999, message: '采购数量应在 1-9999 之间', trigger: 'blur' }
        ],
        supplier: [
          { required: true, message: '请输入供应商', trigger: 'blur' },
          { min: 2, max: 50, message: '供应商名称长度应在 2-50 个字符之间', trigger: 'blur' }
        ],
        supplierPhone: [
          { pattern: /^1[3-9]\d{9}$|^(\d{3,4}-)?\d{7,8}(-\d{1,4})?$/, message: '请输入正确的手机号或座机号（如：13800138000 或 010-12345678）', trigger: 'blur' }
        ],
        expectedDate: [
          { validator: (rule, value, callback) => {
            if (value) {
              const selected = new Date(value)
              const today = new Date()
              today.setHours(0, 0, 0, 0)
              if (selected < today) {
                callback(new Error('预计到货日期不能早于今天'))
              } else {
                callback()
              }
            } else {
              callback()
            }
          }, trigger: 'change' }
        ]
      },
      bookLoading: false,
      bookOptions: []
    }
  },
  created() {
    this.getList()
    this.calculateTableHeight()
    window.addEventListener('resize', this.calculateTableHeight)
  },
  beforeDestroy() {
    window.removeEventListener('resize', this.calculateTableHeight)
  },
  methods: {
    getList() {
      this.loading = true
      getPendingList(this.queryParams).then(response => {
        this.pendingList = response.rows
        this.total = response.total
        this.loading = false
      }).catch(error => {
        console.error('获取采购列表失败:', error)
        this.loading = false
        this.$message.error('获取采购列表失败')
      })
    },
    handleQuery() {
      this.queryParams.pageNum = 1
      this.getList()
    },
    resetQuery() {
      this.queryParams = { pageNum: 1, pageSize: 10, pendingNo: '', bookName: '', isbn: '', supplier: '', status: '' }
      this.getList()
    },
    handleSizeChange(size) {
      this.queryParams.pageSize = size
      this.getList()
    },
    handleCurrentChange(current) {
      this.queryParams.pageNum = current
      this.getList()
    },
    searchBooks(query) {
      if (query.length < 1) { this.bookOptions = []; return }
      this.bookLoading = true
      listBook({ bookName: query, pageSize: 20 }).then(res => {
        this.bookOptions = res.rows || []
        this.bookLoading = false
      }).catch(error => {
        console.error('搜索教材失败:', error)
        this.bookLoading = false
      })
    },
    onBookSelect(bookId) {
      const selected = this.bookOptions.find(item => item.bookId === bookId)
      if (selected) {
        this.form.isbn = selected.isbn || ''
        this.form.bookName = selected.bookName || ''
      }
    },
    handleAdd() {
      this.dialogTitle = '新增采购单'
      this.form = {
        pendingId: undefined, bookId: undefined, isbn: '', bookName: '',
        purchaseNum: 1, supplier: '', supplierPhone: '', expectedDate: '', purchaserName: '', remark: ''
      }
      this.bookOptions = []
      this.dialogVisible = true
    },
    handleEdit(row) {
      this.dialogTitle = '编辑采购单'
      getPendingInfo(row.pendingId).then(response => {
        this.form = {
          pendingId: response.pendingId,
          bookId: response.bookId,
          isbn: response.isbn || '',
          bookName: response.bookName || '',
          purchaseNum: response.purchaseNum || 1,
          supplier: response.supplier || '',
          supplierPhone: response.supplierPhone || '',
          expectedDate: response.expectedDate || '',
          purchaserName: response.purchaserName || '',
          remark: response.remark || ''
        }
        this.dialogVisible = true
      })
    },
    handleView(row) {
      getPendingInfo(row.pendingId).then(response => {
        this.detailData = response
        this.detailVisible = true
      })
    },
    handleDelete(row) {
      this.$confirm('确定要删除采购单 "' + row.pendingNo + '" 吗？删除后不可恢复。', '警告', {
        confirmButtonText: '确定删除',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        deletePending(row.pendingId).then(() => {
          this.$message.success('删除成功')
          this.getList()
        }).catch(error => {
          console.error('删除采购单失败:', error)
          this.$message.error('删除失败')
        })
      })
    },
    handleStartPurchase(row) {
      this.$confirm('确定开始采购 "' + row.bookName + '" 吗？状态将变更为【采购中】', '确认操作', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'info'
      }).then(() => {
        processPending(row.pendingId).then(() => {
          this.$message.success('已开始采购')
          this.getList()
        }).catch(error => {
          console.error('开始采购失败:', error)
          this.$message.error('操作失败')
        })
      })
    },
    handleArrive(row) {
      this.$confirm('确定标记 "' + row.bookName + '" 已到货吗？状态将变更为【已到货】', '确认操作', {
        confirmButtonText: '确定到货',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        updatePending({ pendingId: row.pendingId, status: '2' }).then(() => {
          this.$message.success('已标记到货')
          this.getList()
        }).catch(error => {
          console.error('标记到货失败:', error)
          this.$message.error('操作失败')
        })
      })
    },
    handleInbound(row) {
      this.$confirm('确定将「' + row.bookName + '」确认入库吗？<br/>将增加库存 ' + row.purchaseNum + ' 本并生成入库记录', '确认入库', {
        confirmButtonText: '确认入库',
        cancelButtonText: '取消',
        type: 'success',
        dangerouslyUseHTMLString: true
      }).then(() => {
        this.loading = true
        confirmInbound(row.pendingId).then(() => {
          this.$message.success('已入库，库存已增加 ' + row.purchaseNum + ' 本')
          this.getList()
        }).catch(err => {
          console.error('确认入库失败:', err)
          this.$message.error(err.message || '入库失败')
        }).finally(() => { this.loading = false })
      })
    },
    handleSubmitForm() {
      this.$refs.form.validate((valid) => {
        if (!valid) return
        const submitData = { ...this.form }
        if (this.form.pendingId) {
          updatePending(submitData).then(() => {
            this.$message.success('修改成功')
            this.dialogVisible = false
            this.getList()
          }).catch(error => {
            console.error('修改采购单失败:', error)
            this.$message.error('修改失败')
          })
        } else {
          addPending(submitData).then(() => {
            this.$message.success('新增成功')
            this.dialogVisible = false
            this.getList()
          }).catch(error => {
            console.error('新增采购单失败:', error)
            this.$message.error('新增失败')
          })
        }
      })
    },
    getStatusType(status) {
      const map = { '0': 'info', '1': 'warning', '2': '', '3': 'success' }
      return map[status] || 'info'
    },
    getStatusText(status) {
      const map = { '0': '待采购', '1': '采购中', '2': '已到货', '3': '已入库' }
      return map[status] || '未知'
    },
    copyToClipboard(text) {
      if (!text) return
      if (navigator.clipboard && navigator.clipboard.writeText) {
        navigator.clipboard.writeText(text).then(() => {
          this.$message.success('已复制: ' + text)
        }).catch(() => {
          this.fallbackCopy(text)
        })
      } else {
        this.fallbackCopy(text)
      }
    },

    fallbackCopy(text) {
      const input = document.createElement('input')
      input.value = text
      document.body.appendChild(input)
      input.select()
      document.execCommand('copy')
      document.body.removeChild(input)
      this.$message.success('已复制: ' + text)
    },
    calculateTableHeight() {
      this.tableMaxHeight = window.innerHeight - 280
    },

    handleExport() {
      this.$confirm('确认导出所有待购数据?', '提示', { confirmButtonText: '确定', cancelButtonText: '取消', type: 'warning' }).then(() => {
        const queryParams = { ...this.queryParams }
        delete queryParams.pageNum
        delete queryParams.pageSize
        const form = document.createElement('form')
        form.method = 'POST'
        form.action = process.env.VUE_APP_BASE_API + '/textbook/pending/export'
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
.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.search-form {
  margin-bottom: 16px;
}

.pagination-container {
  margin-top: 16px;
  display: flex;
  justify-content: flex-end;
}

.order-no {
  color: #E6A23C;
  font-weight: 600;
  font-family: 'Courier New', monospace;
  cursor: pointer;
  font-size: 13px;
}

.order-no:hover {
  color: #F56C6C;
}

.copy-icon {
  margin-left: 4px;
  font-size: 12px;
  color: #909399;
}

.copy-icon:hover {
  color: #E6A23C;
}

.isbn-text {
  font-family: 'Courier New', monospace;
  font-size: 12.5px;
  color: #606266;
  letter-spacing: 0.3px;
}

.num-highlight {
  font-weight: 700;
  font-size: 15px;
}

.purchase-num {
  color: #E6A23C;
}

.unit {
  color: #909399;
  font-size: 12px;
  margin-left: 2px;
}

.date-arrived {
  color: #67C23A;
  font-weight: 600;
}

.detail-order-no {
  color: #E6A23C;
  font-weight: 600;
  font-family: 'Courier New', monospace;
  font-size: 14px;
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
