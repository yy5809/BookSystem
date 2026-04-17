<template>
  <div class="app-container">
    <el-card>
      <template #header>
        <div class="card-header">
          <span>采购管理</span>
          <div>
            <el-button type="primary" icon="el-icon-plus" @click="handleAddPurchase" v-hasPermi="['textbook:purchase:add']" v-hasRole="['admin','teacher','student']">提交购书申请</el-button>
            <el-tag type="info" size="small">学生购书单审核与领书</el-tag>
          </div>
        </div>
      </template>

      <el-form :inline="true" :model="queryParams" class="search-form">
        <el-form-item label="购书单号">
          <el-input v-model="queryParams.purchaseNo" placeholder="请输入购书单号" clearable style="width: 200px" />
        </el-form-item>
        <el-form-item label="申请人">
          <el-input v-model="queryParams.userName" placeholder="请输入申请人姓名" clearable style="width: 140px" />
        </el-form-item>
        <el-form-item label="部门/班级">
          <el-input v-model="queryParams.deptName" placeholder="请输入部门或班级" clearable style="width: 150px" />
        </el-form-item>
        <el-form-item label="审核状态">
          <el-select v-model="queryParams.auditStatus" placeholder="全部" clearable style="width: 120px">
            <el-option label="待审核" value="0" />
            <el-option label="已通过" value="1" />
            <el-option label="已驳回" value="2" />
            <el-option label="已取消" value="4" />
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" icon="el-icon-search" @click="handleQuery">查询</el-button>
          <el-button icon="el-icon-refresh" @click="resetQuery">重置</el-button>
        </el-form-item>
      </el-form>

      <el-table ref="tableRef" :data="purchaseList" v-loading="loading" border stripe>
        <el-table-column type="index" label="序号" width="60" align="center" />
        <el-table-column prop="purchaseNo" label="购书单号" width="190">
          <template slot-scope="scope">
            <span class="order-no" @click="copyNo(scope.row.purchaseNo)">{{ scope.row.purchaseNo }}</span>
            <i class="el-icon-copy-document copy-btn" title="复制" @click.stop="copyNo(scope.row.purchaseNo)"></i>
          </template>
        </el-table-column>
        <el-table-column prop="userName" label="申请人" width="90" align="center" />
        <el-table-column prop="userType" label="身份" width="70" align="center">
          <template slot-scope="scope">
            <el-tag :type="scope.row.userType === '1' ? '' : 'warning'" size="mini">{{ scope.row.userType === '1' ? '教师' : '学生' }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="deptName" label="部门/班级" width="120" show-overflow-tooltip />
        <el-table-column prop="buyNum" label="申请数量" width="90" align="center">
          <template slot-scope="scope"><span class="num-blue">{{ scope.row.buyNum || 0 }}</span></template>
        </el-table-column>
        <el-table-column prop="auditStatus" label="审核状态" width="90" align="center">
          <template slot-scope="scope">
            <el-tag :type="auditTagType(scope.row.auditStatus)" size="small">{{ auditText(scope.row.auditStatus) }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="receiveStatus" label="领书状态" width="85" align="center">
          <template slot-scope="scope">
            <el-tag v-if="scope.row.receiveStatus === '1'" type="success" size="small">已领书</el-tag>
            <el-tag v-else type="info" size="small">未领书</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="createTime" label="申请时间" width="155" align="center" sortable />
        <el-table-column label="操作" width="220" align="center" fixed="right">
          <template slot-scope="scope">
            <el-button size="mini" type="text" icon="el-icon-view" @click="handleView(scope.row)">详情</el-button>
            <el-button v-if="scope.row.auditStatus === '0'" size="mini" type="text" icon="el-icon-check" style="color:#67C23A" @click="handleApprove(scope.row)" v-hasRole="['admin','issuer']">通过</el-button>
            <el-button v-if="scope.row.auditStatus === '0'" size="mini" type="text" icon="el-icon-close" style="color:#F56C6C" @click="handleReject(scope.row)" v-hasRole="['admin','issuer']">驳回</el-button>
            <el-button v-if="scope.row.auditStatus === '1' && scope.row.receiveStatus !== '1'" size="mini" type="text" icon="el-icon-finished" style="color:#409EFF" @click="handleConfirmReceive(scope.row)" v-hasRole="['admin','teacher','student','issuer']">确认领书</el-button>
            <el-button v-if="scope.row.auditStatus === '0' || scope.row.auditStatus === '2'" size="mini" type="text" icon="el-icon-delete" style="color:#F56C6C" @click="handleDelete(scope.row)" v-hasRole="['admin','issuer']">删除</el-button>
          </template>
        </el-table-column>
      </el-table>

      <el-pagination class="pagination-container" :current-page="queryParams.pageNum" :page-size="queryParams.pageSize"
        :total="total" :page-sizes="[10, 20, 50, 100]" layout="total, sizes, prev, pager, next, jumper"
        @size-change="handleSizeChange" @current-change="handleCurrentChange" />
    </el-card>

    <!-- 详情面板 -->
    <el-dialog title="购书单详情" :visible.sync="detailVisible" width="700px" append-to-body>
      <el-descriptions :column="2" border size="medium">
        <el-descriptions-item label="购书单号" :span="2">{{ detailData.purchaseNo }}</el-descriptions-item>
        <el-descriptions-item label="申请人">{{ detailData.userName }}</el-descriptions-item>
        <el-descriptions-item label="身份">
          <el-tag :type="detailData.userType === '1' ? '' : 'warning'" size="mini">{{ detailData.userType === '1' ? '教师' : '学生' }}</el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="部门/班级" :span="2">{{ detailData.deptName }}</el-descriptions-item>
        <el-descriptions-item label="申请数量"><span class="num-blue-lg">{{ detailData.buyNum || 0 }}</span> 本</el-descriptions-item>
        <el-descriptions-item label="审核状态">
          <el-tag :type="auditTagType(detailData.auditStatus)" size="small">{{ auditText(detailData.auditStatus) }}</el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="领书状态">
          <el-tag :type="detailData.receiveStatus === '1' ? 'success' : 'info'" size="small">{{ detailData.receiveStatus === '1' ? '已领书' : '未领书' }}</el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="申请时间" :span="2">{{ detailData.createTime }}</el-descriptions-item>
        <el-descriptions-item label="驳回原因" v-if="detailData.auditStatus === '2'" :span="2"><span style="color:#F56C6C">{{ detailData.rejectReason || '-' }}</span></el-descriptions-item>
      </el-descriptions>
      <el-divider content-position="left">教材明细</el-divider>
      <el-table :data="detailList" border size="mini" max-height="200">
        <el-table-column type="index" label="#" width="40" align="center"/>
        <el-table-column prop="bookName" label="教材名称" min-width="160" show-overflow-tooltip/>
        <el-table-column prop="isbn" label="ISBN" width="140"/>
        <el-table-column prop="quantity" label="数量" width="60" align="center"/>
        <el-table-column prop="unitPrice" label="单价" width="80" align="center"/>
        <el-table-column prop="totalPrice" label="小计" width="80" align="center"/>
      </el-table>
      <div slot="footer"><el-button @click="detailVisible = false">关闭</el-button></div>
    </el-dialog>

    <!-- 驳回对话框 -->
    <el-dialog title="驳回购书单" :visible.sync="rejectVisible" width="450px" append-to-body destroy-on-close>
      <el-form :model="rejectForm" :rules="rejectRules" ref="rejectFormRef" label-width="80px">
        <el-form-item label="驳回原因" prop="reason">
          <el-input v-model="rejectForm.reason" type="textarea" :rows="3" placeholder="请输入驳回原因（必填）" maxlength="200" show-word-limit />
        </el-form-item>
      </el-form>
      <div slot="footer">
        <el-button @click="rejectVisible = false">取消</el-button>
        <el-button type="danger" icon="el-icon-close" @click="confirmReject">确认驳回</el-button>
      </div>
    </el-dialog>

    <!-- 提交购书申请对话框 -->
    <el-dialog title="提交购书申请" :visible.sync="addPurchaseVisible" width="600px" append-to-body destroy-on-close :close-on-click-modal="false">
      <el-alert title="请选择需要购买的教材并填写数量，提交后等待管理员审核" type="info" :closable="false" show-icon style="margin-bottom: 16px" />
      <el-form ref="addPurchaseForm" :model="addPurchaseForm" :rules="addPurchaseRules" label-width="100px">
        <el-form-item label="教材名称" prop="bookId">
          <el-select v-model="addPurchaseForm.bookId" filterable remote reserve-keyword
            placeholder="请搜索选择教材" :remote-method="searchBooksForPurchase" :loading="bookLoading"
            style="width: 100%" @change="onBookSelectForPurchase">
            <el-option v-for="item in bookOptions" :key="item.bookId"
              :label="item.bookName + (item.isbn ? ' (' + item.isbn + ')' : '') + ' - ' + (item.author || '')"
              :value="item.bookId">
              <div style="display:flex;justify-content:space-between;">
                <span>{{ item.bookName }}</span>
                <span style="color:#909399;font-size:12px;">{{ item.author || '' }} | {{ item.publisher || '' }}</span>
              </div>
            </el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="ISBN">
          <el-input v-model="addPurchaseForm.isbn" disabled />
        </el-form-item>
        <el-form-item label="作者/出版社">
          <el-input v-model="addPurchaseForm.authorPublisher" disabled />
        </el-form-item>
        <el-form-item label="购买数量" prop="buyNum">
          <el-input-number v-model="addPurchaseForm.buyNum" :min="1" :max="50" controls-position="right" style="width: 200px" />
          <span style="margin-left:10px;color:#909399;font-size:13px;">每人限购50本</span>
        </el-form-item>
        <el-form-item label="备注">
          <el-input v-model="addPurchaseForm.remark" type="textarea" :rows="2" placeholder="选填：如特殊需求说明等" maxlength="200" show-word-limit />
        </el-form-item>
      </el-form>
      <div slot="footer">
        <el-button @click="addPurchaseVisible = false">取消</el-button>
        <el-button type="primary" icon="el-icon-check" :loading="submitLoading" @click="confirmAddPurchase">提交申请</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { listPurchase, getPurchase, auditPurchase, confirmReceive, deletePurchase, addPurchase } from '@/api/textbook/purchase'
import { listBook } from '@/api/textbook/book'

export default {
  name: 'PurchaseIndex',
  data() {
    return {
      loading: false,
      queryParams: { pageNum: 1, pageSize: 10, purchaseNo: '', userName: '', deptName: '', auditStatus: '' },
      purchaseList: [],
      total: 0,
      detailVisible: false,
      detailData: {},
      detailList: [],
      rejectVisible: false,
      rejectForm: { buyId: null, reason: '' },
      rejectRules: { reason: [{ required: true, message: '请输入驳回原因', trigger: 'blur' }] },
      addPurchaseVisible: false,
      submitLoading: false,
      bookLoading: false,
      bookOptions: [],
      addPurchaseForm: {
        bookId: undefined,
        isbn: '',
        authorPublisher: '',
        buyNum: 1,
        remark: ''
      },
      addPurchaseRules: {
        bookId: [{ required: true, message: '请选择教材', trigger: 'change' }],
        buyNum: [
          { required: true, message: '请输入购买数量', trigger: 'blur' },
          { type: 'number', min: 1, max: 50, message: '购买数量在1-50本之间', trigger: 'blur' }
        ]
      }
    }
  },
  created() {
    this.getList()
    document.addEventListener('keydown', this.handleKeydown)
  },
  beforeDestroy() {
    document.removeEventListener('keydown', this.handleKeydown)
  },
  methods: {
    getList() {
      this.loading = true
      listPurchase(this.queryParams).then(res => {
        this.purchaseList = res.rows || []
        this.total = res.total || 0
      }).catch(error => {
        console.error('获取采购列表失败:', error)
        this.$message.error('获取采购列表失败')
      }).finally(() => { this.loading = false })
    },
    handleQuery() { this.queryParams.pageNum = 1; this.getList() },
    resetQuery() { this.queryParams = { pageNum: 1, pageSize: 10, purchaseNo: '', userName: '', deptName: '', auditStatus: '' }; this.getList() },
    handleSizeChange(val) { this.queryParams.pageSize = val; this.getList() },
    handleCurrentChange(val) { this.queryParams.pageNum = val; this.getList() },

    auditText(s) { const m = { '0': '待审核', '1': '已通过', '2': '已驳回', '3': '已领书', '4': '已取消' }; return m[s] || '未知' },
    auditTagType(s) { const m = { '0': 'warning', '1': 'success', '2': 'danger', '4': 'info' }; return m[s] || 'info' },

    handleView(row) {
      getPurchase(row.buyId).then(res => {
        this.detailData = res.data || res
        this.detailList = this.detailData.details || []
        this.detailVisible = true
      }).catch(error => {
        console.error('获取采购详情失败:', error)
        this.$message.error('获取采购详情失败')
      })
    },

    handleApprove(row) {
      this.$confirm(`确定通过「${row.userName}」的购书申请？<br/>将自动检查库存，不足则登记缺书。`, '审核通过', {
        confirmButtonText: '确定通过', cancelButtonText: '取消', type: 'success', dangerouslyUseHTMLString: true
      }).then(() => {
        this.loading = true
        auditPurchase({ buyId: String(row.buyId), status: '1', rejectReason: '' }).then(() => {
          this.$message.success('已通过审核')
          this.getList()
        }).catch(err => {
          console.error('审核通过失败:', err)
          this.$message.error(err.message || '审核失败')
        }).finally(() => { this.loading = false })
      }).catch(() => {})
    },

    handleReject(row) {
      this.rejectForm = { buyId: row.buyId, reason: '' }
      this.rejectVisible = true
      this.$nextTick(() => this.$refs.rejectFormRef && this.$refs.rejectFormRef.clearValidate())
    },

    confirmReject() {
      this.$refs.rejectFormRef.validate(valid => {
        if (!valid) return
        this.loading = true
        auditPurchase({ buyId: String(this.rejectForm.buyId), status: '2', rejectReason: this.rejectForm.reason }).then(() => {
          this.$message.success('已驳回')
          this.rejectVisible = false
          this.getList()
        }).catch(err => {
          console.error('驳回失败:', err)
          this.$message.error(err.message || '驳回失败')
        }).finally(() => { this.loading = false })
      })
    },

    handleConfirmReceive(row) {
      this.$confirm(`确定为「${row.userName}」办理领书出库？<br/>将从库存中扣减 ${row.buyNum} 本并生成出库记录。`, '确认领书', {
        confirmButtonText: '确认领书', cancelButtonText: '取消', type: 'warning', dangerouslyUseHTMLString: true
      }).then(() => {
        this.loading = true
        confirmReceive(row.buyId).then(() => {
          this.$message.success('领书成功，已生成出库记录')
          this.getList()
        }).catch(err => {
          console.error('领书失败:', err)
          this.$message.error(err.message || '领书失败')
        }).finally(() => { this.loading = false })
      }).catch(() => {})
    },

    handleDelete(row) {
      this.$confirm(`确定删除「${row.userName}」的购书单吗？`, '提示', { type: 'warning' }).then(() => {
        deletePurchase(row.buyId).then(() => {
          this.$message.success('删除成功')
          this.getList()
        }).catch(error => {
          console.error('删除购书单失败:', error)
          this.$message.error('删除失败')
        })
      }).catch(() => {})
    },

    copyNo(no) {
      if (!no) return
      if (navigator.clipboard && navigator.clipboard.writeText) {
        navigator.clipboard.writeText(no).then(() => {
          this.$message.success('已复制: ' + no)
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
      this.$message.success('已复制: ' + text)
    },
    handleKeydown(e) {
      if (e.key === 'Enter' && !this.detailVisible && !this.rejectVisible && !this.addPurchaseVisible) {
        e.preventDefault()
        this.handleQuery()
      } else if (e.key === 'Escape') {
        if (this.detailVisible) { this.detailVisible = false }
        if (this.rejectVisible) { this.rejectVisible = false }
        if (this.addPurchaseVisible) { this.addPurchaseVisible = false }
      }
    },

    // ====== 提交购书申请 ======
    handleAddPurchase() {
      this.addPurchaseForm = { bookId: undefined, isbn: '', authorPublisher: '', buyNum: 1, remark: '' }
      this.bookOptions = []
      this.addPurchaseVisible = true
      this.$nextTick(() => {
        if (this.$refs.addPurchaseForm) this.$refs.addPurchaseForm.clearValidate()
      })
    },
    searchBooksForPurchase(query) {
      if (query.length < 1) { this.bookOptions = []; return }
      this.bookLoading = true
      listBook({ bookName: query, pageSize: 20 }).then(res => {
        this.bookOptions = res.rows || []
        this.bookLoading = false
      }).catch(() => { this.bookLoading = false })
    },
    onBookSelectForPurchase(bookId) {
      const selected = this.bookOptions.find(item => item.bookId === bookId)
      if (selected) {
        this.addPurchaseForm.isbn = selected.isbn || ''
        this.addPurchaseForm.authorPublisher = (selected.author || '') + ' / ' + (selected.publisher || '')
      }
    },
    confirmAddPurchase() {
      this.$refs.addPurchaseForm.validate(valid => {
        if (!valid) return
        this.submitLoading = true
        const selectedBook = this.bookOptions.find(item => item.bookId === this.addPurchaseForm.bookId)
        const submitData = {
          bookId: this.addPurchaseForm.bookId,
          bookName: selectedBook ? selectedBook.bookName : '',
          buyNum: this.addPurchaseForm.buyNum,
          remark: this.addPurchaseForm.remark
        }
        addPurchase(submitData).then(() => {
          this.$message.success('购书申请已提交，请等待审核')
          this.addPurchaseVisible = false
          this.getList()
        }).catch(err => {
          console.error('提交购书申请失败:', err)
          this.$message.error(err.message || '提交失败，请重试')
        }).finally(() => { this.submitLoading = false })
      })
    }
  }
}
</script>

<style scoped>
.card-header { display: flex; justify-content: space-between; align-items: center; }
.search-form { margin-bottom: 16px; }
.pagination-container { margin-top: 18px; display: flex; justify-content: flex-end; }
.order-no { color: #409EFF; font-weight: 600; font-family: 'Courier New', monospace; cursor: pointer; font-size: 13px; }
.order-no:hover { color: #66b1ff; }
.copy-btn { margin-left: 6px; cursor: pointer; color: #909399; font-size: 12px; }
.copy-btn:hover { color: #409EFF; }
.num-blue { color: #409EFF; font-weight: bold; font-size: 15px; }
.num-blue-lg { color: #409EFF; font-weight: bold; font-size: 18px; }
</style>