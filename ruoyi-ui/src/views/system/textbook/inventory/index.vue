<template>
  <div class="app-container">
    <el-card>
      <template #header>
        <div class="card-header">
          <span>库存管理</span>
          <div>
            <el-button type="warning" icon="el-icon-warning" @click="handleWarningList">预警列表</el-button>
            <el-button type="primary" icon="el-icon-document" @click="handleShowLog">库存流水</el-button>
            <el-button type="success" icon="el-icon-download" @click="handleExport" v-hasPermi="['textbook:inventory:export']">导出</el-button>
          </div>
        </div>
      </template>

      <!-- 预警提示条 -->
      <el-alert
        v-if="warningCount > 0 || shortageCount > 0"
        :title="`当前库存异常：${shortageCount > 0 ? shortageCount + ' 本教材短缺' : ''}${warningCount > 0 && shortageCount > 0 ? '，' : ''}${warningCount > 0 ? warningCount + ' 本低于预警阈值' : ''}`"
        :type="shortageCount > 0 ? 'error' : 'warning'"
        show-icon
        :closable="false"
        style="margin-bottom: 16px">
      </el-alert>

      <!-- 搜索区域 -->
      <el-form :inline="true" :model="queryParams" class="mb-3">
        <el-form-item label="教材名称">
          <el-input v-model="queryParams.bookName" placeholder="请输入教材名称" clearable style="width: 180px" />
        </el-form-item>
        <el-form-item label="ISBN">
          <el-input v-model="queryParams.isbn" placeholder="请输入ISBN" clearable style="width: 160px" />
        </el-form-item>
        <el-form-item label="作者">
          <el-input v-model="queryParams.author" placeholder="请输入作者" clearable style="width: 120px" />
        </el-form-item>
        <el-form-item label="出版社">
          <el-input v-model="queryParams.publisher" placeholder="请输入出版社" clearable style="width: 140px" />
        </el-form-item>
        <el-form-item label="库存状态">
          <el-select v-model="queryParams.stockStatus" placeholder="全部" clearable style="width: 110px">
            <el-option label="正常" value="normal" />
            <el-option label="预警" value="warning" />
            <el-option label="短缺" value="shortage" />
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" icon="el-icon-search" @click="handleQuery">查询</el-button>
          <el-button icon="el-icon-refresh" @click="resetQuery">重置</el-button>
        </el-form-item>
      </el-form>

      <!-- 数据表格 -->
      <el-table :data="inventoryList" style="width: 100%" :max-height="tableMaxHeight"
                :row-class-name="tableRowClassName" border stripe>
        <el-table-column type="index" label="序号" width="55" align="center"></el-table-column>
        <el-table-column prop="bookName" label="教材名称" min-width="160" show-overflow-tooltip></el-table-column>
        <el-table-column prop="isbn" label="ISBN" width="140">
          <template slot-scope="scope">
            <span class="mono">{{ scope.row.isbn }}</span>
          </template>
        </el-table-column>
        <el-table-column prop="author" label="作者" width="90" show-overflow-tooltip></el-table-column>
        <el-table-column prop="publisher" label="出版社" width="120" show-overflow-tooltip></el-table-column>
        <el-table-column prop="storageAddr" label="存放位置" width="100" show-overflow-tooltip>
          <template slot-scope="scope">
            <span>{{ scope.row.storageAddr || '-' }}</span>
          </template>
        </el-table-column>
        <el-table-column prop="stockNum" label="当前库存" width="80" align="center">
          <template slot-scope="scope">
            <span :class="{ 'stock-danger': scope.row.stockNum <= 0, 'stock-warning': scope.row.stockNum > 0 && scope.row.stockNum <= (scope.row.warningNum || 10) }">
              {{ scope.row.stockNum }}
            </span>
          </template>
        </el-table-column>
        <el-table-column prop="warningNum" label="预警阈值" width="80" align="center"></el-table-column>
        <el-table-column prop="totalPurchase" label="累计入库" width="80" align="center">
          <template slot-scope="scope">
            <span>{{ scope.row.totalPurchase || 0 }}</span>
          </template>
        </el-table-column>
        <el-table-column prop="totalIssued" label="累计出库" width="80" align="center">
          <template slot-scope="scope">
            <span>{{ scope.row.totalIssued || 0 }}</span>
          </template>
        </el-table-column>
        <el-table-column label="库存状态" width="85" align="center">
          <template slot-scope="scope">
            <el-tag :type="statusTagType(scope.row)" size="small" effect="dark">
              {{ statusLabel(scope.row) }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="150" align="center" fixed="right">
          <template slot-scope="scope">
            <el-button size="mini" type="text" icon="el-icon-view" @click="handleView(scope.row)">详情</el-button>
            <el-button size="mini" type="text" icon="el-icon-document" @click="handleViewLog(scope.row)">流水</el-button>
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
    <el-dialog title="库存详情" :visible.sync="detailVisible" width="600px" append-to-body>
      <el-descriptions :column="2" border size="medium" v-if="detailData.stockId">
        <el-descriptions-item label="教材名称" :span="2">{{ detailData.bookName }}</el-descriptions-item>
        <el-descriptions-item label="ISBN">{{ detailData.isbn }}</el-descriptions-item>
        <el-descriptions-item label="作者">{{ detailData.author || '-' }}</el-descriptions-item>
        <el-descriptions-item label="出版社">{{ detailData.publisher || '-' }}</el-descriptions-item>
        <el-descriptions-item label="适用专业">{{ detailData.major || '-' }}</el-descriptions-item>
        <el-descriptions-item label="存放位置">{{ detailData.storageAddr || '-' }}</el-descriptions-item>
        <el-descriptions-item label="当前库存">
          <span :class="{ 'stock-num-bold': true, 'stock-danger': detailData.stockNum <= 0 }">
            {{ detailData.stockNum }}
          </span>
        </el-descriptions-item>
        <el-descriptions-item label="预警阈值">{{ detailData.warningNum || 10 }}</el-descriptions-item>
        <el-descriptions-item label="累计入库">{{ detailData.totalPurchase || 0 }} 本</el-descriptions-item>
        <el-descriptions-item label="累计出库">{{ detailData.totalIssued || 0 }} 本</el-descriptions-item>
        <el-descriptions-item label="库存状态" :span="2">
          <el-tag :type="statusTagType(detailData)" size="small" effect="dark">
            {{ statusLabel(detailData) }}
          </el-tag>
        </el-descriptions-item>
      </el-descriptions>
      <div slot="footer">
        <el-button @click="detailVisible = false">关闭</el-button>
        <el-button type="primary" icon="el-icon-document" @click="handleViewLog(detailData)">查看流水记录</el-button>
      </div>
    </el-dialog>

    <!-- 库存流水对话框 -->
    <el-dialog title="库存流水记录" :visible.sync="logVisible" width="800px" append-to-body>
      <div class="log-header" v-if="logBookName">
        <span class="log-book-name">{{ logBookName }}</span>
        <span class="log-isbn">ISBN: {{ logIsbn }}</span>
      </div>
      <el-table :data="logList" border size="small" max-height="400" v-loading="logLoading">
        <el-table-column type="index" label="#" width="45" align="center"></el-table-column>
        <el-table-column label="业务类型" width="110" align="center">
          <template slot-scope="scope">
            <el-tag :type="bizTypeTagType(scope.row.bizType)" size="mini">
              {{ bizTypeLabel(scope.row.bizType) }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="changeNum" label="变动数量" width="80" align="center">
          <template slot-scope="scope">
            <span :style="{ color: scope.row.changeNum > 0 ? '#67C23A' : '#F56C6C', fontWeight: 'bold' }">
              {{ scope.row.changeNum > 0 ? '+' : '' }}{{ scope.row.changeNum }}
            </span>
          </template>
        </el-table-column>
        <el-table-column prop="beforeStock" label="变动前" width="75" align="center"></el-table-column>
        <el-table-column prop="afterStock" label="变动后" width="75" align="center"></el-table-column>
        <el-table-column prop="operatorName" label="操作人" width="90" show-overflow-tooltip></el-table-column>
        <el-table-column prop="remark" label="备注" min-width="140" show-overflow-tooltip></el-table-column>
        <el-table-column prop="createTime" label="操作时间" width="155" align="center"></el-table-column>
      </el-table>
      <div slot="footer">
        <el-button @click="logVisible = false">关闭</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { getInventoryList, getInventoryInfo, exportInventory } from '@/api/textbook/inventory'
import { getStockLogList } from '@/api/textbook/stockLog'

export default {
  name: 'InventoryIndex',
  data() {
    return {
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        bookName: '',
        isbn: '',
        author: '',
        publisher: '',
        stockStatus: ''
      },
      inventoryList: [],
      total: 0,
      tableMaxHeight: 500,
      warningCount: 0,
      shortageCount: 0,
      detailVisible: false,
      detailData: {},
      logVisible: false,
      logLoading: false,
      logList: [],
      logBookName: '',
      logIsbn: '',
      currentBookId: null
    }
  },
  created() {
    this.getList()
    this.calculateTableHeight()
    window.addEventListener('resize', this.calculateTableHeight)
    document.addEventListener('keydown', this.handleKeydown)
  },
  beforeDestroy() {
    window.removeEventListener('resize', this.calculateTableHeight)
    document.removeEventListener('keydown', this.handleKeydown)
  },
  methods: {
    getList() {
      getInventoryList(this.queryParams).then(response => {
        this.inventoryList = response.rows || []
        this.total = response.total || 0
        this.warningCount = 0
        this.shortageCount = 0
        ;(response.rows || []).forEach(row => {
          if (row.stockNum != null) {
            if (row.stockNum <= 0) this.shortageCount++
            else if (row.stockNum <= (row.warningNum || 10)) this.warningCount++
          }
        })
      }).catch(error => {
        console.error('获取库存列表失败:', error)
        this.$message.error('获取库存列表失败')
      })
    },
    handleQuery() {
      this.queryParams.pageNum = 1
      this.getList()
    },
    resetQuery() {
      this.queryParams = { pageNum: 1, pageSize: 10, bookName: '', isbn: '', author: '', publisher: '', stockStatus: '' }
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

    // ====== 状态计算方法 ======
    statusLabel(row) {
      if (!row || row.stockNum == null) return '-'
      if (row.stockNum <= 0) return '短缺'
      if (row.stockNum <= (row.warningNum || 10)) return '预警'
      return '正常'
    },
    statusTagType(row) {
      if (!row || row.stockNum == null) return 'info'
      if (row.stockNum <= 0) return 'danger'
      if (row.stockNum <= (row.warningNum || 10)) return 'warning'
      return 'success'
    },
    tableRowClassName({ row }) {
      if (row && row.stockNum != null && row.stockNum <= 0) return 'stock-row-shortage'
      if (row && row.stockNum != null && row.stockNum <= (row.warningNum || 10)) return 'stock-row-warning'
      return ''
    },

    // ====== 流水相关 ======
    bizTypeLabel(type) {
      const map = { purchase_in: '采购入库', issue_out: '领书出库', return_in: '退货入库', manual_adj: '人工调整' }
      return map[type] || type || '-'
    },
    bizTypeTagType(type) {
      const map = { purchase_in: 'success', issue_out: 'danger', return_in: 'info', manual_adj: 'warning' }
      return map[type] || 'info'
    },
    loadLog(bookId, bookName, isbn) {
      this.logLoading = true
      this.logBookName = bookName || ''
      this.logIsbn = isbn || ''
      getStockLogList({ bookId: bookId }).then(res => {
        this.logList = res.rows || []
      }).catch(error => {
        console.error('获取流水记录失败:', error)
        this.$message.error('获取流水记录失败')
      }).finally(() => {
        this.logLoading = false
      })
    },

    // ====== 操作事件 ======
    handleView(row) {
      getInventoryInfo(row.stockId).then(res => {
        this.detailData = res
        this.detailVisible = true
      }).catch(error => {
        console.error('获取库存详情失败:', error)
        this.$message.error('获取库存详情失败')
      })
    },
    handleViewLog(row) {
      this.currentBookId = row.bookId || row.stockId
      this.logVisible = true
      this.loadLog(row.bookId, row.bookName, row.isbn)
    },
    handleWarningList() {
      this.queryParams.stockStatus = 'warning'
      this.handleQuery()
    },
    handleShowLog() {
      this.logVisible = true
      this.logBookName = '全部教材'
      this.logIsbn = ''
      this.logLoading = true
      getStockLogList({}).then(res => {
        this.logList = res.rows || []
      }).catch(error => {
        console.error('获取流水记录失败:', error)
        this.$message.error('获取流水记录失败')
      }).finally(() => {
        this.logLoading = false
      })
    },
    handleExport() {
      this.$confirm('确认导出所有库存数据?', '提示', { confirmButtonText: '确定', cancelButtonText: '取消', type: 'warning' })
        .then(() => {
          this.downloadLoading = true
          exportInventory(this.queryParams).then(res => {
            const blob = new Blob([res], { type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' })
            const url = window.URL.createObjectURL(blob)
            const link = document.createElement('a')
            link.href = url
            link.download = '库存数据_' + new Date().getTime() + '.xlsx'
            link.click()
            window.URL.revokeObjectURL(url)
            this.$message.success('导出成功')
          }).catch(err => {
            console.error('导出失败:', err)
            this.$message.error('导出失败，请重试')
          }).finally(() => {
            this.downloadLoading = false
          })
        }).catch(() => {})
    },
    calculateTableHeight() {
      this.tableMaxHeight = window.innerHeight - 260
    },
    handleKeydown(e) {
      if (e.key === 'Enter' && !this.detailVisible && !this.logVisible) {
        e.preventDefault()
        this.handleQuery()
      } else if (e.key === 'Escape') {
        if (this.detailVisible) { this.detailVisible = false }
        if (this.logVisible) { this.logVisible = false }
      }
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
.pagination-container { margin-top: 20px; display: flex; justify-content: flex-end; }
.mb-3 { margin-bottom: 15px; }

.mono { font-family: Consolas, Monaco, monospace; font-size: 12px; color: #606266; }

/* 库存数字样式 */
.stock-danger { color: #F56C6C !important; font-weight: bold; font-size: 15px; }
.stock-warning { color: #E6A23C !important; font-weight: bold; }
.stock-num-bold { font-weight: bold; font-size: 14px; }

/* 行背景色 */
::v-deep .stock-row-shortage { background-color: #fef0f0 !important; }
::v-deep .stock-row-warning { background-color: #fdf6ec !important; }

/* 流水头部 */
.log-header { margin-bottom: 12px; padding: 8px 12px; background: #f5f7fa; border-radius: 4px; }
.log-book-name { font-weight: bold; font-size: 15px; margin-right: 16px; }
.log-isbn { color: #909399; font-family: monospace; font-size: 13px; }

@media screen and (max-width: 1200px) {
  .el-table { font-size: 13px; }
  .el-button--mini { padding: 4px 8px; font-size: 12px; }
}
</style>
