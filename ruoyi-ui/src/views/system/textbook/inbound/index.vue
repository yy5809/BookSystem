<template>
  <div class="app-container">
    <el-card>
      <template #header>
        <div class="card-header">
          <span>入库管理</span>
          <div class="header-actions">
            <el-tag type="success" size="small">入库流水记录</el-tag>
            <el-button type="primary" icon="el-icon-plus" @click="handleManualInbound" v-hasPermi="['textbook:inbound:add']" v-hasRole="['admin','purchaser']">手动入库</el-button>
            <el-button type="success" icon="el-icon-download" @click="handleExport" v-hasPermi="['textbook:inbound:export']">导出</el-button>
          </div>
        </div>
      </template>

      <!-- 搜索区域 -->
      <el-form :inline="true" :model="queryParams" class="search-form">
        <el-form-item label="入库单号">
          <el-input v-model="queryParams.inboundNo" placeholder="请输入入库单号" clearable style="width: 200px" />
        </el-form-item>
        <el-form-item label="教材名称">
          <el-input v-model="queryParams.bookName" placeholder="请输入教材名称" clearable style="width: 180px" />
        </el-form-item>
        <el-form-item label="ISBN">
          <el-input v-model="queryParams.isbn" placeholder="请输入ISBN" clearable style="width: 160px" />
        </el-form-item>
        <el-form-item label="供应商">
          <el-input v-model="queryParams.supplier" placeholder="请输入供应商名称" clearable style="width: 150px" />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" icon="el-icon-search" @click="handleQuery">查询</el-button>
          <el-button icon="el-icon-refresh" @click="resetQuery">重置</el-button>
        </el-form-item>
      </el-form>

      <!-- 数据表格 -->
      <el-table :data="inboundList" v-loading="loading" style="width: 100%" border stripe :max-height="tableMaxHeight">
        <template slot="empty">
          <div class="empty-state">
            <i class="el-icon-download empty-icon"></i>
            <p class="empty-title">暂无入库记录</p>
            <p class="empty-desc">采购到货后可自动入库，或手动登记入库（如捐赠、调拨等）</p>
            <el-button type="success" icon="el-icon-plus" size="small" @click="handleManualInbound" v-hasPermi="['textbook:inbound:add']">手动登记入库</el-button>
          </div>
        </template>
        <el-table-column type="index" label="序号" width="60" align="center" fixed/>
        <el-table-column prop="inboundNo" label="入库单号" width="200" fixed show-overflow-tooltip>
          <template slot-scope="scope">
            <span class="inbound-no">{{ scope.row.inboundNo }}</span>
            <i class="el-icon-copy-document copy-btn" title="复制单号" @click="copyInboundNo(scope.row.inboundNo)"></i>
          </template>
        </el-table-column>
        <el-table-column prop="bookName" label="教材名称" min-width="160" show-overflow-tooltip/>
        <el-table-column prop="isbn" label="ISBN" width="150" show-overflow-tooltip>
          <template slot-scope="scope">
            <span class="isbn-text">{{ scope.row.isbn }}</span>
          </template>
        </el-table-column>
        <el-table-column prop="supplier" label="供应商" width="130" show-overflow-tooltip/>
        <el-table-column prop="inNum" label="入库数量" width="90" align="center">
          <template slot-scope="scope">
            <span class="in-num">{{ scope.row.inNum }}<span class="unit">本</span></span>
          </template>
        </el-table-column>
        <el-table-column prop="unitPrice" label="单价" width="90" align="right">
          <template slot-scope="scope">
            <span>{{ formatPrice(scope.row.unitPrice) }}</span>
          </template>
        </el-table-column>
        <el-table-column prop="totalPrice" label="总价" width="110" align="right">
          <template slot-scope="scope">
            <span class="total-price">{{ formatPrice(scope.row.totalPrice) }}</span>
          </template>
        </el-table-column>
        <el-table-column prop="inTime" label="入库时间" width="160" align="center"/>
        <el-table-column prop="operatorName" label="操作人" width="100" align="center"/>
        <el-table-column label="操作" width="180" align="center" fixed="right">
          <template slot-scope="scope">
            <el-button size="mini" type="text" icon="el-icon-view" @click="handleView(scope.row)">详情</el-button>
            <el-button size="mini" type="text" icon="el-icon-edit" @click="handleEdit(scope.row)" v-hasPermi="['textbook:inbound:edit']">编辑</el-button>
            <el-button size="mini" type="text" icon="el-icon-delete" style="color:#F56C6C" @click="handleDelete(scope.row)" v-hasPermi="['textbook:inbound:remove']">删除</el-button>
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
    <el-dialog title="入库详情" :visible.sync="detailVisible" width="680px" append-to-body>
      <el-descriptions :column="2" border size="medium" v-loading="detailLoading">
        <el-descriptions-item label="入库单号" :span="2">
          <span class="detail-no">{{ detailData.inboundNo }}</span>
          <el-button type="text" icon="el-icon-copy-document" size="mini" @click="copyInboundNo(detailData.inboundNo)">复制</el-button>
        </el-descriptions-item>
        <el-descriptions-item label="入库时间">{{ detailData.inTime || '-' }}</el-descriptions-item>
        <el-descriptions-item label="操作人">{{ detailData.operatorName || '-' }}</el-descriptions-item>
        <el-descriptions-item label="教材名称" :span="2">
          <strong>{{ detailData.bookName || '-' }}</strong>
        </el-descriptions-item>
        <el-descriptions-item label="ISBN">{{ detailData.isbn || '-' }}</el-descriptions-item>
        <el-descriptions-item label="入库数量">
          <span class="in-num-lg">{{ detailData.inNum || 0 }}<span class="unit"> 本</span></span>
        </el-descriptions-item>
        <el-descriptions-item label="供应商">{{ detailData.supplier || '-' }}</el-descriptions-item>
        <el-descriptions-item label="供应商电话">{{ detailData.supplierPhone || '-' }}</el-descriptions-item>
        <el-descriptions-item label="单价">{{ formatPrice(detailData.unitPrice) || '-' }}</el-descriptions-item>
        <el-descriptions-item label="总价">
          <span class="total-price-lg">{{ formatPrice(detailData.totalPrice) || '0.00' }}<span class="unit"> 元</span></span>
        </el-descriptions-item>
        <el-descriptions-item label="备注" :span="2">{{ detailData.remark || '无' }}</el-descriptions-item>
      </el-descriptions>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" icon="el-icon-printer" @click="handlePrintInbound">打印入库单</el-button>
        <el-button @click="detailVisible = false">关闭</el-button>
      </div>
    </el-dialog>

    <!-- 手动入库对话框 -->
    <el-dialog title="手动登记入库" :visible.sync="manualDialogVisible" width="650px" append-to-body destroy-on-close :close-on-click-modal="false" v-loading="submitLoading" element-loading-text="正在提交..." element-loading-background="rgba(255,255,255,0.9)">
      <el-alert
        title="注意：手动入库将直接增加库存，请确认教材信息和数量准确无误"
        type="success"
        :closable="false"
        show-icon
        style="margin-bottom: 16px"
      ></el-alert>

      <el-form ref="manualForm" :model="manualForm" :rules="manualRules" label-width="110px">
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="教材名称" prop="bookId">
              <el-select v-model="manualForm.bookId" filterable remote reserve-keyword
                placeholder="请搜索选择教材" :remote-method="searchBooksForInbound" :loading="bookLoading"
                style="width: 100%" @change="onBookSelectForInbound">
                <el-option v-for="item in bookOptions" :key="item.stockId || item.bookId"
                  :label="item.bookName + (item.isbn ? ' (' + item.isbn + ')' : '')"
                  :value="item.stockId || item.bookId">
                </el-option>
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="ISBN">
              <el-input v-model="manualForm.isbn" disabled />
            </el-form-item>
          </el-col>
        </el-row>

        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="入库数量" prop="inNum">
              <el-input-number v-model="manualForm.inNum" :min="1" :max="9999" controls-position="right" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="当前库存">
              <el-tag type="info">{{ manualForm.currentStock || 0 }} 本 → 入库后 {{ (manualForm.currentStock || 0) + (manualForm.inNum || 0) }} 本</el-tag>
            </el-form-item>
          </el-col>
        </el-row>

        <el-divider content-position="left">供应商信息</el-divider>

        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="供应商" prop="supplier">
              <el-input v-model="manualForm.supplier" placeholder="请输入供应商名称" maxlength="50" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="联系电话" prop="supplierPhone">
              <el-input v-model="manualForm.supplierPhone" placeholder="请输入联系电话" maxlength="20" />
            </el-form-item>
          </el-col>
        </el-row>

        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="单价（元）" prop="unitPrice">
              <el-input-number v-model="manualForm.unitPrice" :min="0" :precision="2" :step="1" controls-position="right" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="总价（元）">
              <el-input :value="calculateTotal()" disabled>
                <template slot="prepend">¥</template>
              </el-input>
            </el-form-item>
          </el-col>
        </el-row>

        <el-form-item label="入库原因" prop="inReason">
          <el-select v-model="manualForm.inReason" placeholder="请选择入库原因" style="width: 100%">
            <el-option label="采购到货" value="purchase_arrive" />
            <el-option label="捐赠入库" value="donation" />
            <el-option label="调拨转入" value="transfer_in" />
            <el-option label="退货入库" value="return_in" />
            <el-option label="盘盈入库" value="inventory_profit" />
            <el-option label="其他原因" value="other" />
          </el-select>
        </el-form-item>

        <el-form-item label="备注">
          <el-input v-model="manualForm.remark" type="textarea" :rows="3" placeholder="请输入备注信息（可选）" maxlength="200" show-word-limit />
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="manualDialogVisible = false">取消</el-button>
        <el-button type="primary" icon="el-icon-check" :loading="submitLoading" @click="submitManualInbound">确认入库</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { getInboundList, getInboundInfo, addInbound, updateInbound, deleteInbound } from '@/api/textbook/inbound'
import { listBook } from '@/api/textbook/book'
import { getInventoryList } from '@/api/textbook/inventory'
import { getToken } from '@/utils/auth'

export default {
  name: 'InboundIndex',
  data() {
    return {
      loading: false,
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        inboundNo: '',
        bookName: '',
        isbn: '',
        supplier: ''
      },
      inboundList: [],
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
        inNum: 1,
        supplier: '',
        supplierPhone: '',
        unitPrice: 0,
        inReason: '',
        remark: ''
      },
      manualRules: {
        bookId: [{ required: true, message: '请选择教材', trigger: 'change' }],
        inNum: [
          { required: true, message: '请输入入库数量', trigger: 'blur' },
          { type: 'number', min: 1, max: 9999, message: '入库数量必须在1-9999之间', trigger: 'blur' }
        ],
        supplier: [
          { required: true, message: '请输入供应商名称', trigger: 'blur' },
          { min: 2, max: 50, message: '供应商名称长度在2-50个字符之间', trigger: 'blur' }
        ],
        supplierPhone: [
          { pattern: /^1[3-9]\d{9}$|^(\d{3,4}-)?\d{7,8}(-\d{1,4})?$/, message: '请输入正确的手机号或座机号', trigger: 'blur' }
        ],
        unitPrice: [
          { type: 'number', min: 0, max: 10000, message: '单价必须在0-10000元之间', trigger: 'blur' }
        ],
        inReason: [{ required: true, message: '请选择入库原因', trigger: 'change' }]
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
      getInboundList(this.queryParams).then(response => {
        this.inboundList = response.rows
        this.total = response.total
        this.loading = false
      }).catch(error => {
        console.error('获取入库列表失败:', error)
        this.$message.error('获取入库列表失败')
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
        inboundNo: '',
        bookName: '',
        isbn: '',
        supplier: ''
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
      getInboundInfo(row.inId).then(response => {
        this.detailData = response.data || response
        this.detailLoading = false
      }).catch(error => {
        console.error('获取入库详情失败:', error)
        this.$message.error('获取入库详情失败')
        this.detailLoading = false
      })
    },

    copyInboundNo(no) {
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
    handlePrintInbound() {
      const d = this.detailData
      const printContent = `
        <div style="font-family: 'Microsoft YaHei', sans-serif; padding: 30px; max-width: 600px; margin: 0 auto;">
          <h2 style="text-align: center; margin-bottom: 20px; border-bottom: 2px solid #333; padding-bottom: 10px;">教材入库单</h2>
          <table style="width: 100%; border-collapse: collapse; font-size: 14px;">
            <tr><td style="border:1px solid #ddd; padding:8px; width:120px; background:#f5f5f5;">入库单号</td><td style="border:1px solid #ddd; padding:8px;">${d.inboundNo || '-'}</td></tr>
            <tr><td style="border:1px solid #ddd; padding:8px; background:#f5f5f5;">入库时间</td><td style="border:1px solid #ddd; padding:8px;">${d.inTime || '-'}</td></tr>
            <tr><td style="border:1px solid #ddd; padding:8px; background:#f5f5f5;">操作人</td><td style="border:1px solid #ddd; padding:8px;">${d.operatorName || '-'}</td></tr>
            <tr><td style="border:1px solid #ddd; padding:8px; background:#f5f5f5;">教材名称</td><td style="border:1px solid #ddd; padding:8px;"><strong>${d.bookName || '-'}</strong></td></tr>
            <tr><td style="border:1px solid #ddd; padding:8px; background:#f5f5f5;">ISBN</td><td style="border:1px solid #ddd; padding:8px;">${d.isbn || '-'}</td></tr>
            <tr><td style="border:1px solid #ddd; padding:8px; background:#f5f5f5;">入库数量</td><td style="border:1px solid #ddd; padding:8px;"><strong>${d.inNum || 0} 本</strong></td></tr>
            <tr><td style="border:1px solid #ddd; padding:8px; background:#f5f5f5;">供应商</td><td style="border:1px solid #ddd; padding:8px;">${d.supplier || '-'}</td></tr>
            <tr><td style="border:1px solid #ddd; padding:8px; background:#f5f5f5;">单价</td><td style="border:1px solid #ddd; padding:8px;">${this.formatPrice(d.unitPrice)} 元</td></tr>
            <tr><td style="border:1px solid #ddd; padding:8px; background:#f5f5f5;">总价</td><td style="border:1px solid #ddd; padding:8px;"><strong>${this.formatPrice(d.totalPrice)} 元</strong></td></tr>
            <tr><td style="border:1px solid #ddd; padding:8px; background:#f5f5f5;">备注</td><td style="border:1px solid #ddd; padding:8px;">${d.remark || '无'}</td></tr>
          </table>
          <div style="margin-top: 40px; display: flex; justify-content: space-between;">
            <span>经办人：_______________</span>
            <span>日期：${new Date().toLocaleDateString()}</span>
          </div>
        </div>
      `
      const printWindow = window.open('', '_blank')
      printWindow.document.write('<html><head><title>入库单打印</title></head><body>' + printContent + '</body></html>')
      printWindow.document.close()
      printWindow.onload = () => { printWindow.print() }
    },

    formatPrice(price) {
      if (price === null || price === undefined || price === '') return ''
      return Number(price).toFixed(2)
    },

    calculateTableHeight() {
      this.tableMaxHeight = window.innerHeight - 280
    },

    // ====== 手动入库相关 ======
    handleManualInbound() {
      this.manualForm = {
        bookId: undefined,
        isbn: '',
        bookName: '',
        currentStock: 0,
        inNum: 1,
        supplier: '',
        supplierPhone: '',
        unitPrice: 0,
        inReason: '',
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

    searchBooksForInbound(query) {
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

    onBookSelectForInbound(stockId) {
      const selected = this.bookOptions.find(item => (item.stockId || item.bookId) === stockId)
      if (selected) {
        this.manualForm.isbn = selected.isbn || ''
        this.manualForm.bookName = selected.bookName || ''
        this.manualForm.currentStock = selected.stockNum || 0
      }
    },

    calculateTotal() {
      const num = this.manualForm.inNum || 0
      const price = this.manualForm.unitPrice || 0
      return (num * price).toFixed(2)
    },

    submitManualInbound() {
      this.$refs.manualForm.validate(valid => {
        if (!valid) return

        this.submitLoading = true

        const submitData = {
          bookId: this.manualForm.bookId,
          bookName: this.manualForm.bookName,
          isbn: this.manualForm.isbn,
          inNum: this.manualForm.inNum,
          supplier: this.manualForm.supplier,
          supplierPhone: this.manualForm.supplierPhone,
          unitPrice: this.manualForm.unitPrice,
          totalPrice: parseFloat(this.calculateTotal()),
          inReason: this.manualForm.inReason,
          remark: this.manualForm.remark
        }

        addInbound(submitData).then(() => {
          this.$message.success(`入库成功！已增加 ${this.manualForm.inNum} 本${this.manualForm.bookName}`)
          this.manualDialogVisible = false
          this.getList()
        }).catch(error => {
          console.error('手动入库失败:', error)
          this.$message.error('入库失败：' + (error.message || '未知错误'))
        }).finally(() => {
          this.submitLoading = false
        })
      })
    },

    handleExport() {
      this.$confirm('确认导出所有入库数据?', '提示', { confirmButtonText: '确定', cancelButtonText: '取消', type: 'warning' })
        .then(() => {
          const queryParams = { ...this.queryParams }
          delete queryParams.pageNum
          delete queryParams.pageSize
          const form = document.createElement('form')
          form.method = 'POST'
          form.action = process.env.VUE_APP_BASE_API + '/textbook/inbound/export'
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
      getInboundInfo(row.inId).then(response => {
        const data = response.data || response
        this.detailData = data
        this.detailVisible = true
        this.$nextTick(() => {
          this.$message.info('如需修改入库信息，请删除后重新登记入库')
        })
      }).catch(error => {
        console.error('获取入库详情失败:', error)
        this.$message.error('获取详情失败')
      })
    },

    handleDelete(row) {
      this.$confirm(`确定删除入库单「${row.inboundNo}」吗？<br/>库存将扣减 ${row.inNum} 本。`, '警告', {
        confirmButtonText: '确定删除',
        cancelButtonText: '取消',
        type: 'warning',
        dangerouslyUseHTMLString: true
      }).then(() => {
        deleteInbound(row.inId).then(() => {
          this.$message.success('已删除，库存已扣减')
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

.inbound-no {
  font-family: 'Courier New', monospace;
  font-weight: 600;
  color: #67C23A;
}

.copy-btn {
  margin-left: 6px;
  cursor: pointer;
  color: #909399;
  font-size: 12px;
}

.copy-btn:hover {
  color: #67C23A;
}

.isbn-text {
  font-family: 'Courier New', monospace;
  font-size: 12px;
  color: #606266;
}

.in-num {
  font-weight: bold;
  font-size: 15px;
  color: #67C23A;
}

.unit {
  font-size: 12px;
  font-weight: normal;
  color: #909399;
  margin-left: 2px;
}

.in-num-lg {
  font-weight: bold;
  font-size: 18px;
  color: #67C23A;
}

.total-price {
  font-weight: bold;
  color: #E6A23C;
}

.total-price-lg {
  font-weight: bold;
  font-size: 18px;
  color: #E6A23C;
}

.detail-no {
  font-family: 'Courier New', monospace;
  font-weight: 600;
  color: #67C23A;
  font-size: 14px;
}

.dialog-footer {
  text-align: center;
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
