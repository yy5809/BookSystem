<template>
  <div class="app-container">
    <el-card>
      <template #header>
        <div class="card-header">
          <span>库存盘点</span>
          <div class="header-right">
            <el-tag :type="'info'" size="small" effect="dark" class="stats-tag">
              待执行: {{ stats.pendingCount || 0 }}
            </el-tag>
            <el-tag :type="'warning'" size="small" effect="dark" class="stats-tag">
              进行中: {{ stats.ongoingCount || 0 }}
            </el-tag>
            <el-tag :type="'success'" size="small" effect="dark" class="stats-tag">
              已完成: {{ stats.completedCount || 0 }}
            </el-tag>
            <el-button type="primary" icon="el-icon-plus" @click="handleAdd" v-hasPermi="['textbook:inventoryCheck:add']" v-hasRole="['admin','warehouseman']">新建盘点</el-button>
          </div>
        </div>
      </template>

      <el-form :inline="true" :model="queryParams" class="search-form">
        <el-form-item label="盘点单号">
          <el-input v-model="queryParams.checkNo" placeholder="请输入盘点单号" clearable style="width: 200px" />
        </el-form-item>
        <el-form-item label="盘点类型">
          <el-select v-model="queryParams.checkType" placeholder="全部" clearable style="width: 120px">
            <el-option label="全盘" value="1" />
            <el-option label="抽盘" value="2" />
            <el-option label="循环盘" value="3" />
          </el-select>
        </el-form-item>
        <el-form-item label="状态">
          <el-select v-model="queryParams.checkStatus" placeholder="全部" clearable style="width: 110px">
            <el-option label="待执行" value="0" />
            <el-option label="进行中" value="1" />
            <el-option label="已完成" value="2" />
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" icon="el-icon-search" @click="handleQuery">查询</el-button>
          <el-button icon="el-icon-refresh" @click="resetQuery">重置</el-button>
        </el-form-item>
      </el-form>

      <el-table :data="checkList" v-loading="loading" border stripe>
        <template slot="empty">
          <div class="empty-state">
            <i class="el-icon-document-checked empty-icon"></i>
            <p class="empty-title">暂无盘点任务</p>
            <p class="empty-desc">创建盘点任务来检查库存准确性</p>
            <el-button type="primary" icon="el-icon-plus" size="small" @click="handleAdd" v-hasPermi="['textbook:inventoryCheck:add']" v-hasRole="['admin','warehouseman']">新建第一个盘点任务</el-button>
          </div>
        </template>
        <el-table-column type="index" label="序号" width="60" align="center" />
        <el-table-column prop="checkNo" label="盘点单号" width="180" align="center">
          <template slot-scope="scope">
            <span class="check-no">{{ scope.row.checkNo }}</span>
          </template>
        </el-table-column>
        <el-table-column prop="checkType" label="类型" width="80" align="center">
          <template slot-scope="scope">
            <el-tag :type="getTypeTagType(scope.row.checkType)" size="small" effect="dark">
              {{ getTypeText(scope.row.checkType) }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="checkStatus" label="状态" width="85" align="center">
          <template slot-scope="scope">
            <el-tag :type="getStatusTagType(scope.row.checkStatus)" size="small">
              {{ getStatusText(scope.row.checkStatus) }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="totalItems" label="应盘项数" width="90" align="center">
          <template slot-scope="scope">
            <span class="num-text">{{ scope.row.totalItems || 0 }}</span>
          </template>
        </el-table-column>
        <el-table-column prop="checkedItems" label="已盘项数" width="90" align="center">
          <template slot-scope="scope">
            <span class="num-text checked-num">{{ scope.row.checkedItems || 0 }}</span>
          </template>
        </el-table-column>
        <el-table-column prop="diffItems" label="差异项数" width="90" align="center">
          <template slot-scope="scope">
            <span :class="{ 'diff-highlight': scope.row.diffItems > 0 }">{{ scope.row.diffItems || 0 }}</span>
          </template>
        </el-table-column>
        <el-table-column prop="warehousemanName" label="库管员" width="85" align="center" />
        <el-table-column prop="planStartTime" label="计划时间" width="170" align="center" show-overflow-tooltip>
          <template slot-scope="scope">
            {{ formatPlanTime(scope.row) }}
          </template>
        </el-table-column>
        <el-table-column prop="createTime" label="创建时间" width="155" align="center" sortable />
        <el-table-column label="操作" width="220" align="center" fixed="right">
          <template slot-scope="scope">
            <el-button size="mini" type="text" icon="el-icon-view" @click="handleView(scope.row)">详情</el-button>
            <el-button v-if="scope.row.checkStatus === '0'" size="mini" type="success" icon="el-icon-video-play" @click="handleStart(scope.row)" v-hasPermi="['textbook:inventoryCheck:edit']" v-hasRole="['admin','warehouseman']">开始</el-button>
            <el-button v-if="scope.row.checkStatus === '1'" size="mini" type="warning" icon="el-icon-edit" @click="handleExecute(scope.row)" v-hasPermi="['textbook:inventoryCheck:edit']" v-hasRole="['admin','warehouseman']">录入</el-button>
            <el-button v-if="scope.row.checkStatus === '1'" size="mini" type="primary" icon="el-icon-finished" @click="handleComplete(scope.row)" v-hasPermi="['textbook:inventoryCheck:edit']" v-hasRole="['admin','warehouseman']">完成</el-button>
            <el-button v-if="scope.row.checkStatus !== '2'" size="mini" type="danger" icon="el-icon-delete" style="color:#F56C6C" @click="handleDelete(scope.row)" v-hasPermi="['textbook:inventoryCheck:remove']" v-hasRole="['admin','warehouseman']">删除</el-button>
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

    <el-dialog title="盘点报告" :visible.sync="reportVisible" width="800px" append-to-body>
      <div class="report-header">
        <h3>📋 盘点报告 - {{ reportData.checkNo }}</h3>
        <p class="report-subtitle">生成时间：{{ reportData.actualEndTime || new Date().toLocaleString() }}</p>
      </div>

      <el-descriptions :column="2" border size="medium" class="report-info">
        <el-descriptions-item label="盘点类型">
          <el-tag :type="getTypeTagType(reportData.checkType)" size="small">{{ getTypeText(reportData.checkType) }}</el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="最终状态">
          <el-tag :type="getStatusTagType(reportData.checkStatus)" size="small">{{ getStatusText(reportData.checkStatus) }}</el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="库管员">{{ reportData.warehousemanName || '-' }}</el-descriptions-item>
        <el-descriptions-item label="实际耗时">
          {{ calculateDuration(reportData) }}
        </el-descriptions-item>
      </el-descriptions>

      <el-divider content-position="left">📊 统计摘要</el-divider>
      <el-row :gutter="20" class="stats-cards">
        <el-col :span="6">
          <div class="stat-card stat-total">
            <div class="stat-value">{{ reportData.totalItems || 0 }}</div>
            <div class="stat-label">应盘项数</div>
          </div>
        </el-col>
        <el-col :span="6">
          <div class="stat-card stat-checked">
            <div class="stat-value">{{ reportData.checkedItems || 0 }}</div>
            <div class="stat-label">已盘项数</div>
          </div>
        </el-col>
        <el-col :span="6">
          <div class="stat-card stat-normal">
            <div class="stat-value">{{ (reportData.totalItems || 0) - (reportData.diffItems || 0) }}</div>
            <div class="stat-label">正常项数</div>
          </div>
        </el-col>
        <el-col :span="6">
          <div class="stat-card stat-diff">
            <div class="stat-value">{{ reportData.diffItems || 0 }}</div>
            <div class="stat-label">差异项数</div>
          </div>
        </el-col>
      </el-row>

      <el-alert
        v-if="reportData.diffItems > 0"
        :title="'发现 ' + reportData.diffItems + ' 项差异，总差异金额：¥' + (reportData.totalDiffAmount || 0).toFixed(2)"
        type="warning"
        show-icon
        :closable="false"
        class="diff-alert"
      />

      <el-divider content-position="left">📝 差异明细</el-divider>
      <el-table :data="detailList" border stripe max-height="300" size="small">
        <el-table-column type="index" label="#" width="45" align="center" />
        <el-table-column prop="bookName" label="教材名称" min-width="150" show-overflow-tooltip />
        <el-table-column prop="isbn" label="ISBN" width="130" />
        <el-table-column prop="location" label="存放位置" width="120" show-overflow-tooltip />
        <el-table-column prop="bookQuantity" label="账面数量" width="90" align="center" />
        <el-table-column prop="actualQuantity" label="实盘数量" width="90" align="center">
          <template slot-scope="scope">
            <span :class="{ 'actual-input': true, 'has-diff': scope.row.diffQuantity !== 0 }">{{ scope.row.actualQuantity }}</span>
          </template>
        </el-table-column>
        <el-table-column prop="diffQuantity" label="差异数量" width="95" align="center">
          <template slot-scope="scope">
            <span :class="getDiffClass(scope.row.diffQuantity)">
              {{ formatDiff(scope.row.diffQuantity) }}
            </span>
          </template>
        </el-table-column>
        <el-table-column prop="unitPrice" label="单价" width="75" align="center">
          <template slot-scope="scope">¥{{ (scope.row.unitPrice || 0).toFixed(2) }}</template>
        </el-table-column>
        <el-table-column prop="diffAmount" label="差异金额" width="100" align="center">
          <template slot-scope="scope">
            <span :class="getDiffClass(scope.row.diffAmount)">¥{{ (scope.row.diffAmount || 0).toFixed(2) }}</span>
          </template>
        </el-table-column>
        <el-table-column prop="checkResult" label="结果" width="75" align="center">
          <template slot-scope="scope">
            <el-tag :type="getResultTagType(scope.row.checkResult)" size="mini">
              {{ getResultText(scope.row.checkResult) }}
            </el-tag>
          </template>
        </el-table-column>
      </el-table>

      <div slot="footer">
        <el-button @click="reportVisible = false">关闭</el-button>
        <el-button type="primary" icon="el-icon-download" @click="exportReport">导出报告</el-button>
      </div>
    </el-dialog>

    <el-dialog title="录入盘点数据" :visible.sync="executeVisible" width="900px" append-to-body top="5vh">
      <div class="execute-header">
        <span>盘点单号：<strong>{{ executeData.checkNo }}</strong></span>
        <span class="ml-4 text-muted">应盘 {{ executeData.totalItems || 0 }} 项 | 已盘 {{ executeData.checkedItems || 0 }} 项</span>
        <el-progress :percentage="getProgress()" :stroke-width="18" class="progress-bar" />
      </div>

      <el-table :data="detailList" border stripe max-height="450" size="small" v-loading="detailLoading">
        <el-table-column type="index" label="#" width="40" align="center" />
        <el-table-column prop="bookName" label="教材名称" min-width="140" show-overflow-tooltip />
        <el-table-column prop="isbn" label="ISBN" width="120" />
        <el-table-column prop="location" label="存放位置" width="110" show-overflow-tooltip />
        <el-table-column prop="bookQuantity" label="账面数量" width="85" align="center">
          <template slot-scope="scope">
            <span class="book-qty">{{ scope.row.bookQuantity }}</span>
          </template>
        </el-table-column>
        <el-table-column label="实盘数量" width="110" align="center">
          <template slot-scope="scope">
            <el-input-number v-model="scope.row.actualQuantity" :min="0" :max="99999" size="mini" controls-position="right" @change="(val) => handleQuantityChange(scope.row, val)" />
          </template>
        </el-table-column>
        <el-table-column label="差异" width="70" align="center">
          <template slot-scope="scope">
            <span :class="getDiffClass(calcDiff(scope.row))">
              {{ formatDiff(calcDiff(scope.row)) }}
            </span>
          </template>
        </el-table-column>
        <el-table-column prop="remark" label="备注" width="120">
          <template slot-scope="scope">
            <el-input v-model="scope.row.remark" size="mini" placeholder="备注" maxlength="255" />
          </template>
        </el-table-column>
      </el-table>

      <div slot="footer" class="dialog-footer">
        <el-button @click="executeVisible = false">关闭</el-button>
        <el-button type="warning" icon="el-icon-refresh" @click="saveProgress">保存进度</el-button>
        <el-button type="primary" icon="el-icon-check" @click="confirmCompleteFromExecute">完成盘点</el-button>
      </div>
    </el-dialog>

    <el-dialog title="新建盘点任务" :visible.sync="addVisible" width="550px" append-to-body destroy-on-close>
      <el-form ref="addForm" :model="addForm" :rules="addRules" label-width="110px">
        <el-form-item label="盘点类型" prop="checkType">
          <el-radio-group v-model="addForm.checkType">
            <el-radio label="1">
              <div class="radio-option">
                <strong>全盘</strong>
                <span class="radio-desc">盘点全部教材</span>
              </div>
            </el-radio>
            <el-radio label="2">
              <div class="radio-option">
                <strong>抽盘</strong>
                <span class="radio-desc">随机抽取约10%</span>
              </div>
            </el-radio>
            <el-radio label="3">
              <div class="radio-option">
                <strong>循环盘</strong>
                <span class="radio-desc">按库区分批轮换</span>
              </div>
            </el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="计划开始时间" prop="planStartTime">
          <el-date-picker v-model="addForm.planStartTime" type="datetime" placeholder="选择开始时间"
            value-format="yyyy-MM-dd HH:mm:ss" style="width: 100%" />
        </el-form-item>
        <el-form-item label="计划完成日期" prop="planEndTime">
          <el-date-picker v-model="addForm.planEndTime" type="date" placeholder="选择完成日期"
            value-format="yyyy-MM-dd" style="width: 100%" />
        </el-form-item>
        <el-form-item label="备注">
          <el-input v-model="addForm.remark" type="textarea" :rows="3" placeholder="备注信息（可选）" maxlength="1000" />
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="addVisible = false">取消</el-button>
        <el-button type="primary" @click="handleSubmitAdd">创建任务</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { listInventoryCheck, getInventoryCheck, addInventoryCheck, startCheck, completeCheck, delInventoryCheck, getInventoryCheckStats } from '@/api/textbook/inventoryCheck'

export default {
  name: 'InventoryCheckIndex',
  data() {
    return {
      loading: false,
      queryParams: { pageNum: 1, pageSize: 10, checkNo: '', checkType: '', checkStatus: '' },
      checkList: [],
      total: 0,
      stats: {},
      reportVisible: false,
      reportData: {},
      detailList: [],
      detailLoading: false,
      executeVisible: false,
      executeData: {},
      addVisible: false,
      addForm: {
        checkType: '1',
        planStartTime: '',
        planEndTime: '',
        remark: ''
      },
      addRules: {
        checkType: [{ required: true, message: '请选择盘点类型', trigger: 'change' }],
        planStartTime: [{ required: true, message: '请选择计划开始时间', trigger: 'change' }],
        planEndTime: [
          { required: true, message: '请选择计划完成日期', trigger: 'change' },
          { validator: (rule, value, callback) => {
            if (value && this.addForm.planStartTime) {
              const end = new Date(value)
              const start = new Date(this.addForm.planStartTime)
              if (end <= start) {
                callback(new Error('完成日期必须晚于开始时间'))
              } else {
                callback()
              }
            } else {
              callback()
            }
          }, trigger: 'change' }
        ]
      }
    }
  },
  created() {
    this.getList()
    this.getStats()
  },
  methods: {
    getList() {
      this.loading = true
      listInventoryCheck(this.queryParams).then(response => {
        this.checkList = response.rows || []
        this.total = response.total || 0
      }).catch(err => {
        console.error('=== CHECK LIST ERROR ===', err)
        this.$message.error('获取盘点列表失败')
      }).finally(() => { this.loading = false })
    },

    getStats() {
      getInventoryCheckStats().then(response => {
        this.stats = response.data || {}
      })
    },

    handleQuery() {
      this.queryParams.pageNum = 1
      this.getList()
    },

    resetQuery() {
      this.queryParams = { pageNum: 1, pageSize: 10, checkNo: '', checkType: '', checkStatus: '' }
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

    getTypeText(type) {
      const map = { '1': '全盘', '2': '抽盘', '3': '循环盘' }
      return map[type] || '未知'
    },

    getTypeTagType(type) {
      const map = { '1': '', '2': 'warning', '3': 'info' }
      return map[type] || ''
    },

    getStatusText(status) {
      const map = { '0': '待执行', '1': '进行中', '2': '已完成' }
      return map[status] || '未知'
    },

    getStatusTagType(status) {
      const map = { '0': 'info', '1': 'warning', '2': 'success' }
      return map[status] || ''
    },

    formatPlanTime(row) {
      if (row.planStartTime) {
        const start = row.planStartTime.substring(5, 16)
        const end = row.planEndTime ? row.planEndTime.substring(5) : ''
        return start + (end ? ' ~ ' + end : '')
      }
      return '-'
    },

    calculateDuration(row) {
      if (row.actualStartTime && row.actualEndTime) {
        const start = new Date(row.actualStartTime)
        const end = new Date(row.actualEndTime)
        const mins = Math.round((end - start) / 60000)
        if (mins < 60) return mins + '分钟'
        return Math.floor(mins / 60) + '小时' + (mins % 60) + '分'
      }
      return '-'
    },

    getProgress() {
      if (!this.executeData.totalItems) return 0
      return Math.round((this.executeData.checkedItems || 0) / this.executeData.totalItems * 100)
    },

    calcDiff(row) {
      return (row.actualQuantity || 0) - (row.bookQuantity || 0)
    },

    formatDiff(diff) {
      if (!diff) return '0'
      return diff > 0 ? '+' + diff : diff.toString()
    },

    getDiffClass(value) {
      if (!value) return ''
      if (value > 0) return 'diff-positive'
      if (value < 0) return 'diff-negative'
      return ''
    },

    getResultTagType(result) {
      const map = { '0': 'success', '1': 'warning', '2': 'danger' }
      return map[result] || 'info'
    },

    getResultText(result) {
      const map = { '0': '正常', '1': '盘盈', '2': '盘亏' }
      return map[result] || '-'
    },

    handleView(row) {
      getInventoryCheck(row.checkId).then(response => {
        this.reportData = response.data || {}
        this.reportVisible = true
        this.loadDetailList(row.checkId)
      })
    },

    loadDetailList(checkId) {
      this.detailLoading = true
      getInventoryCheck(checkId).then(response => {
        this.detailList = response.data.details || []
      }).finally(() => { this.detailLoading = false })
    },

    handleAdd() {
      this.addForm = {
        checkType: '1',
        planStartTime: '',
        planEndTime: '',
        remark: ''
      }
      if (this.$refs.addForm) {
        this.$refs.addForm.clearValidate()
      }
      this.addVisible = true
    },

    handleSubmitAdd() {
      this.$refs.addForm.validate(valid => {
        if (!valid) return
        addInventoryCheck(this.addForm).then(() => {
          this.$message.success('盘点任务创建成功')
          this.addVisible = false
          this.getList()
          this.getStats()
        }).catch(() => {
          this.$message.error('创建失败')
        })
      })
    },

    handleStart(row) {
      this.$confirm(`确定开始执行盘点「${row.checkNo}」吗？`, '确认开始', {
        confirmButtonText: '确定开始',
        cancelButtonText: '取消',
        type: 'info'
      }).then(() => {
        startCheck(row.checkId).then(() => {
          this.$message.success('已开始盘点，请录入实盘数据')
          this.getList()
          this.handleExecute(row)
        }).catch(() => {
          this.$message.error('操作失败')
        })
      })
    },

    handleExecute(row) {
      getInventoryCheck(row.checkId).then(response => {
        this.executeData = response.data || {}
        this.loadDetailList(row.checkId)
        this.executeVisible = true
      })
    },

    handleQuantityChange(row, val) {
      row.actualQuantity = val
      row.diffQuantity = (val || 0) - (row.bookQuantity || 0)
      row.diffAmount = row.diffQuantity * (row.unitPrice || 0)
      row.checkResult = !val ? '0' : (val > row.bookQuantity ? '1' : (val < row.bookQuantity ? '2' : '0'))
    },

    saveProgress() {
      this.$message.info('进度已保存（模拟）')
    },

    confirmCompleteFromExecute() {
      const uncheckedCount = this.detailList.filter(d => d.actualQuantity == null || d.actualQuantity === undefined).length
      if (uncheckedCount > 0) {
        this.$confirm(`还有 ${uncheckedCount} 项未录入实盘数量，确定要完成盘点吗？`, '提示', {
          confirmButtonText: '强制完成',
          cancelButtonText: '继续录入',
          type: 'warning'
        }).then(() => {
          this.doComplete(this.executeData.checkId)
        })
      } else {
        this.doComplete(this.executeData.checkId)
      }
    },

    doComplete(checkId) {
      completeCheck(checkId).then(() => {
        this.$message.success('盘点完成！正在计算差异...')
        this.executeVisible = false
        this.getList()
        this.getStats()
        setTimeout(() => {
          getInventoryCheck(checkId).then(response => {
            this.reportData = response.data || {}
            this.reportVisible = true
            this.loadDetailList(checkId)
          })
        }, 500)
      }).catch(() => {
        this.$message.error('完成失败')
      })
    },

    handleComplete(row) {
      this.$confirm(`确定完成盘点「${row.checkNo}」吗？系统将自动计算所有差异。`, '确认完成', {
        confirmButtonText: '确定完成',
        cancelButtonText: '取消',
        type: 'info'
      }).then(() => {
        completeCheck(row.checkId).then(() => {
          this.$message.success('盘点完成！')
          this.getList()
          this.getStats()
        }).catch(() => {
          this.$message.error('操作失败')
        })
      })
    },

    handleDelete(row) {
      this.$confirm(`确定删除盘点任务「${row.checkNo}」吗？`, '警告', {
        confirmButtonText: '确定删除',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        delInventoryCheck([row.checkId]).then(() => {
          this.$message.success('删除成功')
          this.getList()
          this.getStats()
        }).catch(() => {
          this.$message.error('删除失败')
        })
      })
    },

    exportReport() {
      this.$message.success('导出功能开发中...')
    }
  }
}
</script>

<style scoped>
.card-header { display: flex; justify-content: space-between; align-items: center; }
.header-right { display: flex; gap: 8px; align-items: center; }
.stats-tag { margin-left: 8px; }
.search-form { margin-bottom: 16px; }
.pagination-container { margin-top: 18px; display: flex; justify-content: flex-end; }

.check-no {
  color: #E6A23C;
  font-weight: 600;
  font-family: 'Courier New', monospace;
  font-size: 13px;
}
.num-text { font-weight: 600; font-size: 14px; }
.checked-num { color: #67C23A; }
.diff-highlight { color: #F56C6C; font-weight: bold; }

.empty-state { padding: 40px 20px; text-align: center; }
.empty-icon { font-size: 64px; color: #dcdfe6; margin-bottom: 16px; }
.empty-title { font-size: 16px; color: #606266; margin: 0 0 8px 0; font-weight: 500; }
.empty-desc { font-size: 13px; color: #909399; margin: 0 0 20px 0; }

.ml-4 { margin-left: 16px; }
.text-muted { color: #909399; font-size: 13px; }

.report-header { text-align: center; margin-bottom: 24px; }
.report-header h3 { margin: 0 0 8px 0; color: #303133; }
.report-subtitle { margin: 0; color: #909399; font-size: 13px; }
.stats-cards { margin-bottom: 16px; }
.stat-card {
  padding: 16px;
  text-align: center;
  border-radius: 8px;
  background: #f5f7fa;
  border: 1px solid #e4e7ed;
}
.stat-value { font-size: 28px; font-weight: 700; line-height: 1.2; }
.stat-label { font-size: 13px; color: #909399; margin-top: 4px; }
.stat-total .stat-value { color: #409EFF; }
.stat-checked .stat-value { color: #67C23A; }
.stat-normal .stat-value { color: #909399; }
.stat-diff .stat-value { color: #F56C6C; }
.diff-alert { margin: 12px 0; }

.execute-header { margin-bottom: 16px; }
.progress-bar { max-width: 300px; margin-left: 16px; vertical-align: middle; }
.book-qty { color: #909399; font-family: monospace; }
.actual-input { font-weight: 600; }
.has-diff { color: #E6A23C; }

.dialog-footer { text-align: right; }

.radio-option { line-height: 1.4; }
.radio-option strong { display: block; font-size: 14px; }
.radio-desc { font-size: 12px; color: #909399; }

.diff-positive { color: #67C23A; font-weight: 600; }
.diff-negative { color: #F56C6C; font-weight: 600; }

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
