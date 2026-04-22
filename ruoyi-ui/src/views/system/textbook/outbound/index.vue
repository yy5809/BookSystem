<template>
  <div class="app-container">
    <el-card>
      <template #header>
        <div class="card-header">
          <span>出库管理</span>
          <div class="header-actions">
            <el-tag type="info" size="small">出库流水记录</el-tag>
            <el-button type="primary" icon="el-icon-plus" @click="handleManualOutbound" v-hasPermi="['textbook:outbound:add']" v-hasRole="['admin','issuer']">手动出库</el-button>
            <el-button type="success" icon="el-icon-download" @click="handleExport" v-hasPermi="['textbook:outbound:export']">导出</el-button>
          </div>
        </div>
      </template>

      <!-- 搜索区域 -->
      <el-form :inline="true" :model="queryParams" class="search-form">
        <el-form-item label="出库单号">
          <el-input v-model="queryParams.outboundNo" placeholder="请输入出库单号" clearable style="width: 200px" />
        </el-form-item>
        <el-form-item label="教材名称">
          <el-input v-model="queryParams.bookName" placeholder="请输入教材名称" clearable style="width: 180px" />
        </el-form-item>
        <el-form-item label="ISBN">
          <el-input v-model="queryParams.isbn" placeholder="请输入ISBN" clearable style="width: 160px" />
        </el-form-item>
        <el-form-item label="领书人">
          <el-input v-model="queryParams.userName" placeholder="请输入领书人姓名" clearable style="width: 120px" />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" icon="el-icon-search" @click="handleQuery">查询</el-button>
          <el-button icon="el-icon-refresh" @click="resetQuery">重置</el-button>
        </el-form-item>
      </el-form>

      <!-- 数据表格 -->
      <el-table :data="outboundList" v-loading="loading" style="width: 100%" border stripe :max-height="tableMaxHeight">
        <template slot="empty">
          <div class="empty-state">
            <i class="el-icon-upload2 empty-icon"></i>
            <p class="empty-title">暂无出库记录</p>
            <p class="empty-desc">可以通过采购审核自动生成出库单，或手动登记出库</p>
            <el-button type="primary" icon="el-icon-plus" size="small" @click="handleManualOutbound" v-hasPermi="['textbook:outbound:add']">手动登记出库</el-button>
          </div>
        </template>
        <el-table-column type="index" label="序号" width="60" align="center" fixed/>
        <el-table-column prop="outboundNo" label="出库单号" width="200" fixed show-overflow-tooltip>
          <template slot-scope="scope">
            <span class="outbound-no">{{ scope.row.outboundNo }}</span>
            <i class="el-icon-copy-document copy-btn" title="复制单号" @click="copyOutboundNo(scope.row.outboundNo)"></i>
          </template>
        </el-table-column>
        <el-table-column prop="bookName" label="教材名称" min-width="160" show-overflow-tooltip/>
        <el-table-column prop="isbn" label="ISBN" width="150" show-overflow-tooltip>
          <template slot-scope="scope">
            <span class="isbn-text">{{ scope.row.isbn }}</span>
          </template>
        </el-table-column>
        <el-table-column prop="userName" label="领书人" width="100" align="center"/>
        <el-table-column prop="deptName" label="部门/班级" width="120" show-overflow-tooltip/>
        <el-table-column prop="outNum" label="出库数量" width="90" align="center">
          <template slot-scope="scope">
            <span class="out-num">{{ scope.row.outNum }}<span class="unit">本</span></span>
          </template>
        </el-table-column>
        <el-table-column prop="outTime" label="出库时间" width="160" align="center"/>
        <el-table-column prop="operatorName" label="操作人" width="100" align="center"/>
        <el-table-column label="操作" width="180" align="center" fixed="right">
          <template slot-scope="scope">
            <el-button size="mini" type="text" icon="el-icon-view" @click="handleView(scope.row)">详情</el-button>
            <el-button size="mini" type="text" icon="el-icon-edit" @click="handleEdit(scope.row)" v-hasPermi="['textbook:outbound:edit']">编辑</el-button>
            <el-button size="mini" type="text" icon="el-icon-delete" style="color:#F56C6C" @click="handleDelete(scope.row)" v-hasPermi="['textbook:outbound:remove']">删除</el-button>
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
    <el-dialog title="出库详情" :visible.sync="detailVisible" width="650px" append-to-body>
      <el-descriptions :column="2" border size="medium" v-loading="detailLoading">
        <el-descriptions-item label="出库单号" :span="2">
          <span class="detail-no">{{ detailData.outboundNo }}</span>
          <el-button type="text" icon="el-icon-copy-document" size="mini" @click="copyOutboundNo(detailData.outboundNo)">复制</el-button>
        </el-descriptions-item>
        <el-descriptions-item label="关联申请单号">{{ detailData.purchaseNo || '-' }}</el-descriptions-item>
        <el-descriptions-item label="出库时间">{{ detailData.outTime || '-' }}</el-descriptions-item>
        <el-descriptions-item label="教材名称" :span="2">
          <strong>{{ detailData.bookName || '-' }}</strong>
        </el-descriptions-item>
        <el-descriptions-item label="ISBN">{{ detailData.isbn || '-' }}</el-descriptions-item>
        <el-descriptions-item label="出库数量">
          <span class="out-num-lg">{{ detailData.outNum || 0 }}<span class="unit"> 本</span></span>
        </el-descriptions-item>
        <el-descriptions-item label="领书人">{{ detailData.userName || '-' }}</el-descriptions-item>
        <el-descriptions-item label="部门/班级">{{ detailData.deptName || '-' }}</el-descriptions-item>
        <el-descriptions-item label="操作人">{{ detailData.operatorName || '-' }}</el-descriptions-item>
        <el-descriptions-item label="备注" :span="2">{{ detailData.remark || '无' }}</el-descriptions-item>
      </el-descriptions>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" icon="el-icon-printer" @click="handlePrintOutbound">打印出库单</el-button>
        <el-button @click="detailVisible = false">关闭</el-button>
      </div>
    </el-dialog>

    <!-- 手动出库对话框 -->
    <el-dialog title="手动登记出库" :visible.sync="manualDialogVisible" width="600px" append-to-body destroy-on-close :close-on-click-modal="false" v-loading="submitLoading" element-loading-text="正在提交..." element-loading-background="rgba(255,255,255,0.9)">
      <el-alert
        title="注意：手动出库将直接扣减库存，请确认教材信息和数量准确无误"
        type="warning"
        :closable="false"
        show-icon
        style="margin-bottom: 16px"
      ></el-alert>

      <el-form ref="manualForm" :model="manualForm" :rules="manualRules" label-width="110px">
        <el-form-item label="教材名称" prop="bookId">
          <el-select v-model="manualForm.bookId" filterable remote reserve-keyword
            placeholder="请搜索选择教材" :remote-method="searchBooksForOutbound" :loading="bookLoading"
            style="width: 100%" @change="onBookSelectForOutbound">
            <el-option v-for="item in bookOptions" :key="item.stockId || item.bookId"
              :label="item.bookName + (item.isbn ? ' (' + item.isbn + ')' : '') + ' [库存:' + (item.stockNum || 0) + ']'"
              :value="item.stockId || item.bookId">
              <span style="float: left">{{ item.bookName }}</span>
              <span style="float: right; color: #8492a6; font-size: 12px">
                库存: {{ item.stockNum || 0 }}
                <el-tag v-if="(item.stockNum || 0) <= 0" type="danger" size="mini">缺货</el-tag>
                <el-tag v-else-if="(item.stockNum || 0) <= (item.warningNum || 10)" type="warning" size="mini">预警</el-tag>
              </span>
            </el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="ISBN">
          <el-input v-model="manualForm.isbn" disabled />
        </el-form-item>
        <el-form-item label="当前库存">
          <el-tag :type="(manualForm.currentStock || 0) > 0 ? 'success' : 'danger'">{{ manualForm.currentStock || 0 }} 本</el-tag>
        </el-form-item>
        <el-form-item label="出库数量" prop="outNum">
          <el-input-number v-model="manualForm.outNum" :min="1" :max="manualForm.currentStock || 9999" controls-position="right" style="width: 100%" />
          <div class="form-tip" v-if="manualForm.outNum > (manualForm.currentStock || 0)">
            <i class="el-icon-warning-outline"></i> 出库数量超过当前库存！
          </div>
        </el-form-item>
        <el-form-item label="领书人" prop="userName">
          <el-input v-model="manualForm.userName" placeholder="请输入领书人姓名" maxlength="20" />
        </el-form-item>
        <el-form-item label="部门/班级" prop="deptName">
          <el-input v-model="manualForm.deptName" placeholder="请输入部门或班级" maxlength="50" />
        </el-form-item>
        <el-form-item label="出库原因" prop="remark">
          <el-select v-model="manualForm.outReason" placeholder="请选择出库原因" style="width: 100%">
            <el-option label="教师领用" value="teacher_use" />
            <el-option label="学生补发" value="student_resend" />
            <el-option label="临时借阅" value="borrow" />
            <el-option label="其他用途" value="other" />
          </el-select>
        </el-form-item>
        <el-form-item label="备注">
          <el-input v-model="manualForm.remark" type="textarea" :rows="3" placeholder="请输入备注信息（可选）" maxlength="200" show-word-limit />
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="manualDialogVisible = false">取消</el-button>
        <el-button type="primary" icon="el-icon-check" :loading="submitLoading" @click="submitManualOutbound">确认出库</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { getOutboundList, getOutboundInfo, addOutbound, updateOutbound, deleteOutbound } from '@/api/textbook/outbound'
import { listBook } from '@/api/textbook/book'
import { getInventoryList } from '@/api/textbook/inventory'
import { getToken } from '@/utils/auth'

export default {
  name: 'OutboundIndex',
  data() {
    return {
      loading: false,
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        outboundNo: '',
        bookName: '',
        isbn: '',
        userName: ''
      },
      outboundList: [],
      total: 0,
      tableMaxHeight: 500,
      detailVisible: false,
      detailLoading: false,
      detailData: {},
      manualDialogVisible: false,
      submitLoading: false,
      bookLoading: false,
      bookOptions: [],
      manualForm: {
        bookId: undefined,
        isbn: '',
        bookName: '',
        currentStock: 0,
        outNum: 1,
        userName: '',
        deptName: '',
        outReason: '',
        remark: ''
      },
      manualRules: {
        bookId: [{ required: true, message: '请选择教材', trigger: 'change' }],
        outNum: [
          { required: true, message: '请输入出库数量', trigger: 'blur' },
          { type: 'number', min: 1, max: 9999, message: '出库数量必须在1-9999之间', trigger: 'blur' }
        ],
        userName: [
          { required: true, message: '请输入领书人姓名', trigger: 'blur' },
          { min: 2, max: 20, message: '姓名长度在2-20个字符之间', trigger: 'blur' }
        ],
        deptName: [
          { required: true, message: '请输入部门或班级', trigger: 'blur' },
          { min: 2, max: 50, message: '部门/班级长度在2-50个字符之间', trigger: 'blur' }
        ],
        outReason: [{ required: true, message: '请选择出库原因', trigger: 'change' }]
      }
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
      getOutboundList(this.queryParams).then(response => {
        this.outboundList = response.rows
        this.total = response.total
        this.loading = false
      }).catch(error => {
        console.error('获取出库列表失败:', error)
        this.$message.error('获取出库列表失败')
        this.loading = false
      })
    },

    handleQuery() {
      this.queryParams.pageNum = 1
      this.getList()
    },

    resetQuery() {
      this.queryParams = {
        pageNum: 1,
        pageSize: 10,
        outboundNo: '',
        bookName: '',
        isbn: '',
        userName: ''
      }
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

    handleView(row) {
      this.detailLoading = true
      this.detailVisible = true
      getOutboundInfo(row.outId).then(response => {
        this.detailData = response.data || response
        this.detailLoading = false
      }).catch(error => {
        console.error('获取出库详情失败:', error)
        this.$message.error('获取出库详情失败')
        this.detailLoading = false
      })
    },

    copyOutboundNo(no) {
      if (!no) return
      if (navigator.clipboard && navigator.clipboard.writeText) {
        navigator.clipboard.writeText(no).then(() => {
          this.$message.success('单号已复制: ' + no)
        }).catch(() => {
          this.fallbackCopy(no)
        })
      } else {
        this.fallbackCopy(no)
      }
    },

    fallbackCopy(text) {
      const input = document.createElement('input')
      input.value = text
      document.body.appendChild(input)
      input.select()
      document.execCommand('copy')
      document.body.removeChild(input)
      this.$message.success('单号已复制: ' + text)
    },
    handlePrintOutbound() {
      const d = this.detailData
      const e = this.$options.filters?.escapeHtml || (s => s || '-')
      const esc = (v) => { const div = document.createElement('div'); div.textContent = v || '-'; return div.innerHTML }
      const printContent = `
        <div style="font-family: 'Microsoft YaHei', sans-serif; padding: 30px; max-width: 600px; margin: 0 auto;">
          <h2 style="text-align: center; margin-bottom: 20px; border-bottom: 2px solid #333; padding-bottom: 10px;">教材出库单（领书确认单）</h2>
          <table style="width: 100%; border-collapse: collapse; font-size: 14px;">
            <tr><td style="border:1px solid #ddd; padding:8px; width:120px; background:#f5f5f5;">出库单号</td><td style="border:1px solid #ddd; padding:8px;">${esc(d.outboundNo)}</td></tr>
            <tr><td style="border:1px solid #ddd; padding:8px; background:#f5f5f5;">出库时间</td><td style="border:1px solid #ddd; padding:8px;">${esc(d.outTime)}</td></tr>
            <tr><td style="border:1px solid #ddd; padding:8px; background:#f5f5f5;">教材名称</td><td style="border:1px solid #ddd; padding:8px;"><strong>${esc(d.bookName)}</strong></td></tr>
            <tr><td style="border:1px solid #ddd; padding:8px; background:#f5f5f5;">ISBN</td><td style="border:1px solid #ddd; padding:8px;">${esc(d.isbn)}</td></tr>
            <tr><td style="border:1px solid #ddd; padding:8px; background:#f5f5f5;">出库数量</td><td style="border:1px solid #ddd; padding:8px;"><strong>${d.outNum || 0} 本</strong></td></tr>
            <tr><td style="border:1px solid #ddd; padding:8px; background:#f5f5f5;">领书人</td><td style="border:1px solid #ddd; padding:8px;">${esc(d.userName)}</td></tr>
            <tr><td style="border:1px solid #ddd; padding:8px; background:#f5f5f5;">部门/班级</td><td style="border:1px solid #ddd; padding:8px;">${esc(d.deptName)}</td></tr>
            <tr><td style="border:1px solid #ddd; padding:8px; background:#f5f5f5;">操作人</td><td style="border:1px solid #ddd; padding:8px;">${esc(d.operatorName)}</td></tr>
          </table>
          <div style="margin-top: 40px;">
            <p>领书人签字：_______________________ &nbsp;&nbsp;&nbsp;&nbsp; 日期：${new Date().toLocaleDateString()}</p>
            <p style="margin-top:15px;">经办人签字：_______________________</p>
          </div>
        </div>
      `
      const printWindow = window.open('', '_blank')
      printWindow.document.write('<html><head><title>出库单打印</title></head><body>' + printContent + '</body></html>')
      printWindow.document.close()
      printWindow.onload = () => { printWindow.print() }
    },

    calculateTableHeight() {
      this.tableMaxHeight = window.innerHeight - 280
    },

    // ====== 手动出库相关 ======
    handleManualOutbound() {
      this.manualForm = {
        bookId: undefined,
        isbn: '',
        bookName: '',
        currentStock: 0,
        outNum: 1,
        userName: '',
        deptName: '',
        outReason: '',
        remark: ''
      }
      this.bookOptions = []
      this.manualDialogVisible = true
      this.$nextTick(() => {
        if (this.$refs.manualForm) {
          this.$refs.manualForm.clearValidate()
        }
      })
    },

    searchBooksForOutbound(query) {
      if (query.length < 1) {
        this.bookOptions = []
        return
      }
      this.bookLoading = true
      getInventoryList({ bookName: query, pageSize: 20 }).then(res => {
        this.bookOptions = res.rows || []
        this.bookLoading = false
      }).catch(error => {
        console.error('搜索教材失败:', error)
        this.bookLoading = false
      })
    },

    onBookSelectForOutbound(stockId) {
      const selected = this.bookOptions.find(item => (item.stockId || item.bookId) === stockId)
      if (selected) {
        this.manualForm.isbn = selected.isbn || ''
        this.manualForm.bookName = selected.bookName || ''
        this.manualForm.currentStock = selected.stockNum || 0
        if (this.manualForm.outNum > this.manualForm.currentStock) {
          this.manualForm.outNum = Math.max(1, this.manualForm.currentStock)
        }
      }
    },

    submitManualOutbound() {
      this.$refs.manualForm.validate(valid => {
        if (!valid) return

        if (this.manualForm.outNum > this.manualForm.currentStock) {
          this.$confirm(`当前库存仅剩 ${this.manualForm.currentStock} 本，出库数量 ${this.manualForm.outNum} 本将导致库存为负数。是否继续？`, '库存不足警告', {
            confirmButtonText: '继续出库',
            cancelButtonText: '取消修改',
            type: 'warning'
          }).then(() => {
            this.doSubmitOutbound()
          }).catch(() => {})
        } else {
          this.doSubmitOutbound()
        }
      })
    },

    doSubmitOutbound() {
      this.submitLoading = true

      const submitData = {
        bookId: this.manualForm.bookId,
        bookName: this.manualForm.bookName,
        isbn: this.manualForm.isbn,
        outNum: this.manualForm.outNum,
        userName: this.manualForm.userName,
        deptName: this.manualForm.deptName,
        outReason: this.manualForm.outReason,
        remark: this.manualForm.remark
      }

      addOutbound(submitData).then(() => {
        this.$message.success('出库成功')
        this.manualDialogVisible = false
        this.getList()
      }).catch(error => {
        console.error('手动出库失败:', error)
        this.$message.error('出库失败：' + (error.message || '未知错误'))
      }).finally(() => {
        this.submitLoading = false
      })
    },

    handleExport() {
      this.$confirm('确认导出所有出库数据?', '提示', { confirmButtonText: '确定', cancelButtonText: '取消', type: 'warning' })
        .then(() => {
          const queryParams = { ...this.queryParams }
          delete queryParams.pageNum
          delete queryParams.pageSize
          const form = document.createElement('form')
          form.method = 'POST'
          form.action = process.env.VUE_APP_BASE_API + '/textbook/outbound/export'
          const tokenInput = document.createElement('input')
          tokenInput.type = 'hidden'
          tokenInput.name = 'Authorization'
          tokenInput.value = 'Bearer ' + getToken()
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
    },

    handleEdit(row) {
      getOutboundInfo(row.outId).then(response => {
        const data = response.data || response
        this.detailData = data
        this.detailVisible = true
        this.$nextTick(() => {
          this.$message.info('如需修改出库信息，请删除后重新登记出库')
        })
      }).catch(error => {
        console.error('获取出库详情失败:', error)
        this.$message.error('获取详情失败')
      })
    },

    handleDelete(row) {
      this.$confirm(`确定删除出库单「${row.outboundNo}」吗？<br/>库存将回退 ${row.outNum} 本。`, '警告', {
        confirmButtonText: '确定删除',
        cancelButtonText: '取消',
        type: 'warning',
        dangerouslyUseHTMLString: true
      }).then(() => {
        deleteOutbound(row.outId).then(() => {
          this.$message.success('已删除，库存已回退')
          this.getList()
        }).catch(error => {
          console.error('删除失败:', error)
          this.$message.error('删除失败')
        })
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

.header-actions {
  display: flex;
  align-items: center;
  gap: 10px;
}

.search-form {
  margin-bottom: 16px;
}

.pagination-container {
  margin-top: 16px;
  display: flex;
  justify-content: flex-end;
}

.outbound-no {
  font-family: 'Courier New', monospace;
  font-weight: 600;
  color: #409EFF;
}

.copy-btn {
  margin-left: 6px;
  cursor: pointer;
  color: #909399;
  font-size: 12px;
}

.copy-btn:hover {
  color: #409EFF;
}

.isbn-text {
  font-family: 'Courier New', monospace;
  font-size: 12px;
  color: #606266;
}

.out-num {
  font-weight: bold;
  font-size: 15px;
  color: #E6A23C;
}

.unit {
  font-size: 12px;
  font-weight: normal;
  color: #909399;
  margin-left: 2px;
}

.out-num-lg {
  font-weight: bold;
  font-size: 18px;
  color: #E6A23C;
}

.detail-no {
  font-family: 'Courier New', monospace;
  font-weight: 600;
  color: #409EFF;
  font-size: 14px;
}

.dialog-footer {
  text-align: center;
}

.form-tip {
  color: #F56C6C;
  font-size: 12px;
  margin-top: 4px;
}
.form-tip i {
  margin-right: 4px;
}

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
</style>
