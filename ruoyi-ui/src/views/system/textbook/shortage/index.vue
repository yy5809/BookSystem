<template>
  <div class="app-container">
    <el-card>
      <template #header>
        <div class="card-header">
          <span>缺书管理</span>
          <div>
            <el-button type="warning" icon="el-icon-s-claim" :disabled="!selectedRows.length" @click="handleBatchProcess" v-hasRole="['admin','issuer','purchaser']">批量转采购</el-button>
            <el-button type="primary" icon="el-icon-plus" @click="handleAdd" v-hasPermi="['textbook:shortage:add']" v-hasRole="['admin','issuer','purchaser']">登记缺书</el-button>
            <el-button type="success" icon="el-icon-download" @click="handleExport" v-hasPermi="['textbook:shortage:export']">导出</el-button>
          </div>
        </div>
      </template>

      <el-form :inline="true" :model="queryParams" class="search-form">
        <el-form-item label="教材名称">
          <el-input v-model="queryParams.bookName" placeholder="请输入教材名称" clearable style="width: 200px" />
        </el-form-item>
        <el-form-item label="ISBN">
          <el-input v-model="queryParams.isbn" placeholder="请输入ISBN" clearable style="width: 180px" />
        </el-form-item>
        <el-form-item label="处理状态">
          <el-select v-model="queryParams.handleStatus" placeholder="全部" clearable style="width: 130px">
            <el-option label="未处理" value="0" />
            <el-option label="已纳入采购" value="1" />
            <el-option label="已到货" value="2" />
            <el-option label="已完成" value="3" />
          </el-select>
        </el-form-item>
        <el-form-item label="紧急程度">
          <el-select v-model="queryParams.urgency" placeholder="全部" clearable style="width: 110px">
            <el-option label="普通" value="0" />
            <el-option label="紧急" value="1" />
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" icon="el-icon-search" @click="handleQuery">查询</el-button>
          <el-button icon="el-icon-refresh" @click="resetQuery">重置</el-button>
        </el-form-item>
      </el-form>

      <el-table ref="tableRef" :data="shortageList" v-loading="loading" @selection-change="handleSelectionChange" border stripe>
        <template slot="empty">
          <div class="empty-state">
            <i class="el-icon-document-checked empty-icon"></i>
            <p class="empty-title">暂无缺书记录</p>
            <p class="empty-desc">当教材库存不足或学生领书时，系统会自动登记缺书</p>
            <el-button type="warning" icon="el-icon-plus" size="small" @click="handleAdd" v-hasPermi="['textbook:shortage:add']">登记第一本缺书</el-button>
          </div>
        </template>
        <el-table-column type="selection" width="45" align="center" />
        <el-table-column type="index" label="序号" width="60" align="center" />
        <el-table-column prop="bookName" label="教材名称" min-width="180" show-overflow-tooltip />
        <el-table-column prop="isbn" label="ISBN" width="150" show-overflow-tooltip />
        <el-table-column prop="lackNum" label="缺书数量" width="95" align="center">
          <template slot-scope="scope">
            <span class="num-highlight">{{ scope.row.lackNum || 0 }}</span>
          </template>
        </el-table-column>
        <el-table-column prop="urgency" label="紧急程度" width="95" align="center">
          <template slot-scope="scope">
            <el-tag :type="scope.row.urgency === '1' ? 'danger' : 'info'" size="small" effect="dark">
              {{ scope.row.urgency === '1' ? '紧急' : '普通' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="source" label="缺书来源" width="100" align="center">
          <template slot-scope="scope">
            <el-tag :type="scope.row.source === '1' ? '' : 'warning'" size="small">
              {{ scope.row.source === '1' ? '领书缺货' : '库存预警' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="handleStatus" label="处理状态" width="100" align="center">
          <template slot-scope="scope">
            <el-tag :type="statusTagType(scope.row.handleStatus)" size="small">
              {{ statusText(scope.row.handleStatus) }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="registerTime" label="登记时间" width="160" align="center" sortable />
        <el-table-column label="操作" width="180" align="center" fixed="right">
          <template slot-scope="scope">
            <el-button size="mini" type="text" icon="el-icon-view" @click="handleView(scope.row)">详情</el-button>
            <el-button v-if="scope.row.handleStatus === '0'" size="mini" type="text" icon="el-icon-s-claim" style="color:#E6A23C" @click="handleProcess(scope.row)" v-hasRole="['admin','issuer','purchaser']">转采购</el-button>
            <el-button v-if="scope.row.handleStatus === '0'" size="mini" type="text" icon="el-icon-edit" @click="handleEdit(scope.row)" v-hasPermi="['textbook:shortage:edit']" v-hasRole="['admin','issuer','purchaser']">编辑</el-button>
            <el-button v-if="scope.row.handleStatus === '0'" size="mini" type="text" icon="el-icon-delete" style="color:#F56C6C" @click="handleDelete(scope.row)" v-hasPermi="['textbook:shortage:remove']" v-hasRole="['admin','issuer','purchaser']">删除</el-button>
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

    <el-dialog title="缺书登记详情" :visible.sync="detailVisible" width="650px" append-to-body>
      <el-descriptions :column="2" border size="medium">
        <el-descriptions-item label="缺书编号" :span="2">{{ detailData.lackId }}</el-descriptions-item>
        <el-descriptions-item label="教材名称" :span="2"><strong>{{ detailData.bookName }}</strong></el-descriptions-item>
        <el-descriptions-item label="ISBN">{{ detailData.isbn || '-' }}</el-descriptions-item>
        <el-descriptions-item label="缺书数量"><span class="num-highlight-lg">{{ detailData.lackNum || 0 }}</span> 本</el-descriptions-item>
        <el-descriptions-item label="紧急程度">
          <el-tag :type="detailData.urgency === '1' ? 'danger' : 'info'" size="small" effect="dark">{{ detailData.urgency === '1' ? '紧急' : '普通' }}</el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="缺书来源">
          <el-tag :type="detailData.source === '1' ? '' : 'warning'" size="small">{{ detailData.source === '1' ? '领书缺货' : '库存预警' }}</el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="处理状态" :span="2">
          <el-tag :type="statusTagType(detailData.handleStatus)" size="small">{{ statusText(detailData.handleStatus) }}</el-tag>
          <span v-if="detailData.purchaseId && detailData.handleStatus !== '0'" class="ml-2 text-muted">→ 已关联采购单 #{{ detailData.purchaseId }}</span>
        </el-descriptions-item>
        <el-descriptions-item label="登记时间" :span="2">{{ detailData.registerTime }}</el-descriptions-item>
        <el-descriptions-item label="来源记录ID" :span="2">{{ detailData.sourceId || '-' }}</el-descriptions-item>
      </el-descriptions>
      <div slot="footer">
        <el-button @click="detailVisible = false">关闭</el-button>
        <el-button v-if="detailData.handleStatus === '0'" type="warning" icon="el-icon-s-claim" @click="handleProcessFromDetail">转采购</el-button>
      </div>
    </el-dialog>

    <el-dialog :title="dialogTitle" :visible.sync="dialogVisible" width="550px" append-to-body destroy-on-close>
      <el-form ref="form" :model="form" :rules="rules" label-width="100px">
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
        <el-form-item label="缺书数量" prop="lackNum">
          <el-input-number v-model="form.lackNum" :min="1" :max="9999" controls-position="right" style="width: 100%" />
        </el-form-item>
        <el-form-item label="紧急程度" prop="urgency">
          <el-radio-group v-model="form.urgency">
            <el-radio label="0">普通</el-radio>
            <el-radio label="1">紧急</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="缺书来源" prop="source">
          <el-select v-model="form.source" placeholder="请选择来源" style="width: 100%">
            <el-option label="领书缺货" value="1" />
            <el-option label="库存预警" value="2" />
          </el-select>
        </el-form-item>
      </el-form>
      <div slot="footer">
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleSubmitForm">确定</el-button>
      </div>
    </el-dialog>

    <el-dialog title="转采购确认" :visible.sync="processDialogVisible" width="420px" append-to-body>
      <div class="process-tip">
        <i class="el-icon-warning-outline process-icon"></i>
        <p>确定将以下缺书记录转为采购需求？</p>
        <p class="process-book"><strong>{{ processData.bookName }}</strong></p>
        <p>缺书数量：<span class="num-highlight-lg">{{ processData.lackNum }}</span> 本</p>
      </div>
      <div slot="footer">
        <el-button @click="processDialogVisible = false">取消</el-button>
        <el-button type="warning" @click="confirmProcess">确认转采购</el-button>
      </div>
    </el-dialog>

    <!-- 批量操作结果对话框 -->
    <el-dialog title="批量操作结果" :visible.sync="resultDialogVisible" width="500px" append-to-body :close-on-click-modal="false">
      <div class="result-content">
        <div class="result-icon" :class="resultData.successCount === resultData.totalCount ? 'success' : 'warning'">
          <i :class="resultData.successCount === resultData.totalCount ? 'el-icon-circle-check' : 'el-icon-warning'"></i>
        </div>
        <h3 class="result-title">{{ resultData.successCount === resultData.totalCount ? '操作成功！' : '部分完成' }}</h3>
        <p class="result-desc">
          共处理 <strong>{{ resultData.totalCount }}</strong> 条记录，
          成功 <strong style="color: #67C23A">{{ resultData.successCount }}</strong> 条，
          失败 <strong style="color: #F56C6C">{{ resultData.totalCount - resultData.successCount }}</strong> 条
        </p>
        <div v-if="resultData.failedList && resultData.failedList.length > 0" class="failed-list">
          <p class="failed-title">失败记录：</p>
          <ul>
            <li v-for="(item, index) in resultData.failedList.slice(0, 5)" :key="index">
              {{ item.bookName }} - {{ item.lackNum }}本
            </li>
            <li v-if="resultData.failedList.length > 5">...等{{ resultData.failedList.length }}条</li>
          </ul>
        </div>
      </div>
      <div slot="footer">
        <el-button type="primary" @click="resultDialogVisible = false; getList()">查看结果</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { getShortageList, getShortageInfo, addShortage, updateShortage, deleteShortage, processShortage } from '@/api/textbook/shortage'
import { listBook } from '@/api/textbook/book'
import { getToken } from '@/utils/auth'

export default {
  name: 'ShortageIndex',
  data() {
    return {
      loading: false,
      queryParams: { pageNum: 1, pageSize: 10, bookName: '', isbn: '', handleStatus: '', urgency: '' },
      shortageList: [],
      total: 0,
      selectedRows: [],
      detailVisible: false,
      detailData: {},
      dialogVisible: false,
      dialogTitle: '',
      form: { lackId: undefined, bookId: undefined, bookName: '', isbn: '', lackNum: 1, urgency: '0', source: '1' },
      rules: {
        bookId: [{ required: true, message: '请选择教材', trigger: 'change' }],
        lackNum: [
          { required: true, message: '请输入缺书数量', trigger: 'blur' },
          { type: 'number', min: 1, max: 9999, message: '缺书数量应在 1-9999 之间', trigger: 'blur' }
        ],
        urgency: [{ required: true, message: '请选择紧急程度', trigger: 'change' }],
        source: [{ required: true, message: '请选择缺书来源', trigger: 'change' }]
      },
      processDialogVisible: false,
      processData: {},
      resultDialogVisible: false,
      resultData: { totalCount: 0, successCount: 0, failedList: [] },
      bookLoading: false,
      bookOptions: []
    }
  },
  created() { this.getList() },
  methods: {
    getList() {
      this.loading = true
      getShortageList(this.queryParams).then(response => {
        this.shortageList = response.rows || []
        this.total = response.total || 0
      }).catch(err => {
        console.error('=== SHORTAGE ERROR ===', err)
        this.$message.error('获取缺书列表失败')
      }).finally(() => { this.loading = false })
    },
    handleQuery() { this.queryParams.pageNum = 1; this.getList() },
    resetQuery() { this.queryParams = { pageNum: 1, pageSize: 10, bookName: '', isbn: '', handleStatus: '', urgency: '' }; this.getList() },
    handleSizeChange(val) { this.queryParams.pageSize = val; this.getList() },
    handleCurrentChange(val) { this.queryParams.pageNum = val; this.getList() },
    handleSelectionChange(rows) { this.selectedRows = rows },

    statusText(status) { const map = { '0': '未处理', '1': '已纳入采购', '2': '已到货', '3': '已完成' }; return map[status] || '未知' },
    statusTagType(status) { const map = { '0': 'danger', '1': 'warning', '2': 'info', '3': 'success' }; return map[status] || 'info' },

    handleView(row) { getShortageInfo(row.lackId).then(r => { this.detailData = r.data; this.detailVisible = true }) },

    handleAdd() { this.dialogTitle = '登记缺书'; this.form = { lackId: undefined, bookId: undefined, bookName: '', isbn: '', lackNum: 1, urgency: '0', source: '1' }; this.bookOptions = []; this.dialogVisible = true },

    searchBooks(query) {
      if (query.length < 1) { this.bookOptions = []; return }
      this.bookLoading = true
      listBook({ bookName: query, pageSize: 20 }).then(res => {
        this.bookOptions = res.rows || []
        this.bookLoading = false
      }).catch(() => { this.bookLoading = false })
    },
    onBookSelect(bookId) {
      const selected = this.bookOptions.find(item => item.bookId === bookId)
      if (selected) {
        this.form.isbn = selected.isbn || ''
        this.form.bookName = selected.bookName || ''
      }
    },

    handleEdit(row) { this.dialogTitle = '编辑缺书'; getShortageInfo(row.lackId).then(r => { this.form = { ...r.data }; this.dialogVisible = true }) },

    handleSubmitForm() {
      this.$refs.form.validate(valid => {
        if (!valid) return
        const action = this.form.lackId ? updateShortage(this.form) : addShortage(this.form)
        action.then(() => { this.$message.success(this.form.lackId ? '修改成功' : '登记成功'); this.dialogVisible = false; this.getList() })
          .catch(() => { this.$message.error(this.form.lackId ? '修改失败' : '登记失败') })
      })
    },

    handleProcess(row) { this.processData = { ...row }; this.processDialogVisible = true },
    handleProcessFromDetail() { this.detailVisible = false; this.processData = { ...this.detailData }; this.processDialogVisible = true },

    confirmProcess() {
      processShortage(this.processData.lackId, '1').then(() => { this.$message.success('已转为采购需求'); this.processDialogVisible = false; this.getList() })
        .catch(() => { this.$message.error('转采购失败') })
    },

    handleBatchProcess() {
      const unprocessed = this.selectedRows.filter(r => r.handleStatus === '0')
      if (!unprocessed.length) { this.$message.warning('请选择待采购的缺书记录'); return }
      this.$confirm(`确定将选中的 ${unprocessed.length} 条缺书记录全部转为采购需求?`, '批量转采购', { confirmButtonText: '确定', cancelButtonText: '取消', type: 'warning' }).then(() => {
        const loadingInstance = this.$loading({ lock: true, text: `正在处理 ${unprocessed.length} 条记录 (0/${unprocessed.length})...`, spinner: 'el-icon-loading', background: 'rgba(0, 0, 0, 0.7)' })
        let count = unprocessed.length, done = 0, successCount = 0
        const failedList = []
        unprocessed.forEach((row, index) => {
          processShortage(row.lackId, '1').then(() => {
            successCount++
            done++
            loadingInstance.text = `正在处理 ${unprocessed.length} 条记录 (${done}/${unprocessed.length})...`
            if (done === count) {
              loadingInstance.close()
              this.resultData = { totalCount: count, successCount: successCount, failedList: failedList }
              this.resultDialogVisible = true
              this.getList()
            }
          }).catch(() => {
            failedList.push(row)
            done++
            loadingInstance.text = `正在处理 ${unprocessed.length} 条记录 (${done}/${unprocessed.length})...`
            if (done === count) {
              loadingInstance.close()
              this.resultData = { totalCount: count, successCount: successCount, failedList: failedList }
              this.resultDialogVisible = true
              this.getList()
            }
          })
        })
      }).catch(() => {})
    },

    handleDelete(row) {
      this.$confirm(`确定删除缺书记录「${row.bookName}」吗?`, '提示', { confirmButtonText: '确定', cancelButtonText: '取消', type: 'warning' }).then(() => {
        deleteShortage(row.lackId).then(() => { this.$message.success('删除成功'); this.getList() }).catch(() => { this.$message.error('删除失败') })
      }).catch(() => {})
    },

    handleExport() {
      this.$confirm('确认导出所有缺书数据?', '提示', { confirmButtonText: '确定', cancelButtonText: '取消', type: 'warning' }).then(() => {
        const queryParams = { ...this.queryParams }
        delete queryParams.pageNum
        delete queryParams.pageSize
        const form = document.createElement('form')
        form.method = 'POST'
        form.action = process.env.VUE_APP_BASE_API + '/textbook/shortage/export'
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
.num-highlight { color: #E6A23C; font-weight: bold; font-size: 15px; }
.num-highlight-lg { color: #E6A23C; font-weight: bold; font-size: 18px; }
.ml-2 { margin-left: 10px; }
.text-muted { color: #909399; font-size: 13px; }
.process-tip { text-align: center; padding: 10px 0; }
.process-icon { font-size: 40px; color: #E6A23C; margin-bottom: 12px; }
.process-book { font-size: 16px; color: #303133; margin: 8px 0; }

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

.result-content {
  text-align: center;
  padding: 10px 0;
}
.result-icon {
  font-size: 64px;
  margin-bottom: 16px;
}
.result-icon.success { color: #67C23A; }
.result-icon.warning { color: #E6A23C; }
.result-title {
  font-size: 18px;
  color: #303133;
  margin: 0 0 12px 0;
}
.result-desc {
  font-size: 14px;
  color: #606266;
  margin: 0 0 16px 0;
  line-height: 1.6;
}
.failed-list {
  text-align: left;
  background: #fef0f0;
  border-radius: 4px;
  padding: 12px 16px;
  margin-top: 12px;
}
.failed-title {
  font-size: 13px;
  color: #F56C6C;
  margin: 0 0 8px 0;
  font-weight: 500;
}
.failed-list ul {
  margin: 0;
  padding-left: 20px;
  list-style: disc;
}
.failed-list li {
  font-size: 12px;
  color: #606266;
  line-height: 1.8;
}
</style>