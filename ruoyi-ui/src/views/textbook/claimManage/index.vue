<template>
  <div class="app-container">
    <el-tabs v-model="activeTab" type="card" @tab-click="onTabClick">
      <el-tab-pane label="班级领书" name="class">
        <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
          <el-form-item label="学期" prop="semester">
            <el-input v-model="queryParams.semester" placeholder="如：2025-2026-2" clearable @keyup.enter.native="handleQuery" />
          </el-form-item>
          <el-form-item label="状态" prop="status">
            <el-select v-model="queryParams.status" placeholder="请选择" clearable>
              <el-option label="进行中" value="1" />
              <el-option label="已完成" value="3" />
            </el-select>
          </el-form-item>
          <el-form-item>
            <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
            <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
          </el-form-item>
        </el-form>
        <el-row :gutter="10" class="mb8">
          <el-col :span="1.5">
            <el-button type="primary" plain icon="el-icon-plus" size="mini" @click="handleAdd" v-hasPermi="['textbook:noticeManage:add']">新建领书计划</el-button>
          </el-col>
          <right-toolbar :showSearch.sync="showSearch" @queryTable="getList" />
        </el-row>
        <el-table v-loading="loading" :data="noticeList" border stripe row-key="noticeId">
          <el-table-column type="expand">
            <template slot-scope="scope">
              <div style="padding: 10px 20px;" v-loading="scope.row._loading">
                <el-table v-if="scope.row._forms && scope.row._forms.length" :data="scope.row._forms" border stripe size="small" style="margin: 0;">
                  <el-table-column label="领书单号" prop="formNo" width="180" />
                  <el-table-column label="班级信息" min-width="140">
                    <template slot-scope="s">{{ s.row.collegeName }} {{ s.row.majorName }} {{ formatGradeLevel(s.row.gradeLevel) }}{{ s.row.className }}</template>
                  </el-table-column>
                  <el-table-column label="应发" prop="plannedQty" width="50" />
                  <el-table-column label="已发" prop="issuedQty" width="50" />
                  <el-table-column label="状态" width="65" align="center">
                    <template slot-scope="s">
                      <el-tag :type="s.row.status==='2'?'success':s.row.status==='1'?'warning':''" size="mini">{{ s.row.status==='2'?'已出库':s.row.status==='1'?'部分':'待领' }}</el-tag>
                    </template>
                  </el-table-column>
                  <el-table-column label="领书人" prop="receiverName" width="60" />
                  <el-table-column label="操作" class-name="small-padding fixed-width" width="155" align="center">
                    <template slot-scope="s">
                      <el-button size="mini" type="text" icon="el-icon-view" @click.stop="viewFormDetail(s.row)" v-hasPermi="['textbook:noticeManage:query']">明细</el-button>
                      <el-button size="mini" type="text" icon="el-icon-sold-out" @click.stop="handleOutbound(s.row)" v-if="s.row.status !== '2'" v-hasPermi="['textbook:claimForm:outbound']">出库</el-button>
                      <el-button size="mini" type="text" icon="el-icon-printer" @click.stop="handlePrint(s.row)" v-hasPermi="['textbook:noticeManage:query']">打印</el-button>
                    </template>
                  </el-table-column>
                </el-table>
                <el-empty v-else description="暂无领书单" :image-size="60" />
              </div>
            </template>
          </el-table-column>
          <el-table-column label="批次编号" prop="noticeNo" width="195" />
          <el-table-column label="学期" prop="semester" width="105" />
          <el-table-column label="领取时间" width="210">
            <template slot-scope="s">{{ (s.row.pickupStart||'') + ' ~ ' + (s.row.pickupEnd||'') }}</template>
          </el-table-column>
          <el-table-column label="领取地点" prop="pickupLocation" min-width="120" show-overflow-tooltip />
          <el-table-column label="状态" width="70" align="center">
            <template slot-scope="s">
              <el-tag :type="s.row.status==='3'?'success':''" size="small">{{ s.row.status==='3'?'已完成':'进行中' }}</el-tag>
            </template>
          </el-table-column>
          <el-table-column label="班级进度" prop="classProgress" width="80" align="center" />
          <el-table-column label="创建时间" prop="createTime" width="145" />
          <el-table-column label="操作" class-name="small-padding fixed-width" width="90" align="center" fixed="right">
            <template slot-scope="scope">
              <el-button size="mini" type="danger" icon="el-icon-delete" @click.stop="handleDelete(scope.row)" v-hasPermi="['textbook:noticeManage:remove']">删除</el-button>
            </template>
          </el-table-column>
        </el-table>
        <pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />
      </el-tab-pane>
      <el-tab-pane label="个人领书申请" name="personal">
        <el-form :model="paParams" ref="paFormRef" size="small" :inline="true" label-width="68px">
          <el-form-item label="申请人">
            <el-input v-model="paParams.teacherName" placeholder="申请人" clearable @keyup.enter.native="getPaList" />
          </el-form-item>
          <el-form-item label="状态">
            <el-select v-model="paParams.status" placeholder="请选择" clearable @change="getPaList">
              <el-option label="待审核" value="0" />
              <el-option label="已通过" value="1" />
              <el-option label="已驳回" value="2" />
              <el-option label="已出库" value="3" />
            </el-select>
          </el-form-item>
          <el-form-item>
            <el-button type="primary" icon="el-icon-search" size="mini" @click="getPaList">搜索</el-button>
          </el-form-item>
        </el-form>
        <el-table v-loading="paLoading" :data="paList" border stripe>
          <el-table-column label="申请编号" prop="applyNo" min-width="170" show-overflow-tooltip />
          <el-table-column label="申请人" prop="teacherName" width="85" />
          <el-table-column label="教材名称" prop="bookName" show-overflow-tooltip min-width="120" />
          <el-table-column label="申请数量" prop="applyQty" width="70" align="center" />
          <el-table-column label="用途" prop="purpose" show-overflow-tooltip min-width="100" />
          <el-table-column label="状态" width="75" align="center">
            <template slot-scope="s">
              <el-tag :type="{0:'warning',1:'success',2:'danger',3:''}[s.row.status]" size="mini">{{ paStatusText(s.row.status) }}</el-tag>
            </template>
          </el-table-column>
          <el-table-column label="审核意见" prop="auditOpinion" show-overflow-tooltip width="110" />
          <el-table-column label="申请时间" prop="createTime" width="145" />
          <el-table-column label="操作" class-name="small-padding fixed-width" width="155" align="center">
            <template slot-scope="s">
              <el-button size="mini" type="text" icon="el-icon-view" @click="paView(s.row)">详情</el-button>
              <el-button size="mini" type="text" icon="el-icon-check" style="color:#67C23A" @click="paAuditOpen=true;paForm=s.row" v-if="s.row.status==='0'" v-hasPermi="['textbook:personalApply:audit']">审核</el-button>
              <el-button size="mini" type="text" icon="el-icon-sold-out" @click="paIssue(s.row)" v-if="s.row.status==='1'" v-hasPermi="['textbook:personalApply:issue']">出库</el-button>
            </template>
          </el-table-column>
        </el-table>
        <pagination v-show="paTotal > 0" :total="paTotal" :page.sync="paParams.pageNum" :limit.sync="paParams.pageSize" @pagination="getPaList" />
      </el-tab-pane>
    </el-tabs>

    <!-- 新建/编辑领书计划 -->
    <el-dialog :title="title" :visible.sync="open" width="750px" append-to-body :close-on-click-modal="false">
      <el-form ref="form" :model="form" :rules="rules" label-width="100px">
        <el-form-item label="学期" prop="semester">
          <el-input v-model="form.semester" placeholder="如：2025-2026-2" />
        </el-form-item>
        <el-form-item label="领取地点" prop="pickupLocation">
          <el-input v-model="form.pickupLocation" placeholder="如：图书馆一楼大厅" />
        </el-form-item>
        <el-form-item label="领取开始" prop="pickupStart">
          <el-date-picker v-model="form.pickupStart" type="datetime" placeholder="选择开始时间" value-format="yyyy-MM-dd HH:mm:ss" style="width:100%" />
        </el-form-item>
        <el-form-item label="领取结束" prop="pickupEnd">
          <el-date-picker v-model="form.pickupEnd" type="datetime" placeholder="选择结束时间" value-format="yyyy-MM-dd HH:mm:ss" style="width:100%" />
        </el-form-item>
        <el-divider>领书明细</el-divider>
        <el-table :data="form.details" border stripe size="small" v-if="form.details && form.details.length">
          <el-table-column label="班级" prop="className" width="100" />
          <el-table-column label="教材名称" prop="bookName" show-overflow-tooltip min-width="140" />
          <el-table-column label="ISBN" prop="isbn" width="130" />
          <el-table-column label="数量" prop="plannedQty" width="70" align="center" />
          <el-table-column label="操作" class-name="small-padding fixed-width" width="140" align="center">
            <template slot-scope="scope">
              <el-button type="primary" size="mini" @click="editDetail(scope.$index)"><i class="el-icon-edit"></i></el-button>
              <el-button type="danger" size="mini" @click="removeDetail(scope.$index)"><i class="el-icon-delete"></i></el-button>
            </template>
          </el-table-column>
        </el-table>
        <el-alert v-else type="info" title="请添加领书明细" :closable="false" />
        <div style="text-align:right;margin-top:10px;">
          <el-button type="primary" size="small" icon="el-icon-plus" @click="openDetailDialog()">添加明细</el-button>
        </div>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitForm">确 定</el-button>
        <el-button @click="cancel">取 消</el-button>
      </div>
    </el-dialog>

    <!-- 添加/编辑明细 -->
    <el-dialog :title="detailForm._editIndex !== undefined ? '编辑明细' : '添加明细'" :visible.sync="detailDialogVisible" width="550px" append-to-body>
      <el-form ref="detailFormRef" :model="detailForm" label-width="80px" size="small">
        <el-form-item label="入学年份（级）">
          <el-input v-model="detailForm.gradeLevel" placeholder="如：22级" />
        </el-form-item>
        <el-form-item label="班级">
          <el-input v-model="detailForm.className" placeholder="如：1班" />
        </el-form-item>
        <el-form-item label="选择教材">
          <el-select v-model="detailForm.textbookIds" multiple filterable remote reserve-keyword :remote-method="searchBook" :loading="bookLoading" placeholder="输入ISBN/书名搜索" style="width:100%">
            <el-option v-for="b in bookOpts" :key="b.bookId" :label="b.isbn + ' - ' + b.bookName" :value="b.bookId" />
          </el-select>
        </el-form-item>
        <el-form-item label="数量">
          <el-input-number v-model="detailForm.plannedQty" :min="1" style="width:100%" />
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="confirmAddDetail">确 定</el-button>
        <el-button @click="detailDialogVisible = false">取 消</el-button>
      </div>
    </el-dialog>

    <!-- 领书单明细 -->
    <el-dialog title="领书单明细" :visible.sync="formDetailVisible" width="800px" append-to-body>
      <el-table :data="formDetailList" border stripe size="small">
        <el-table-column label="教材名称" prop="bookName" show-overflow-tooltip min-width="140" />
        <el-table-column label="ISBN" prop="isbn" width="130" />
        <el-table-column label="作者" prop="author" width="85" />
        <el-table-column label="出版社" prop="publisher" width="120" show-overflow-tooltip />
        <el-table-column label="应发" prop="plannedQty" width="55" align="center" />
        <el-table-column label="实发" prop="issuedQty" width="55" align="center" />
      </el-table>
      <div slot="footer"><el-button @click="formDetailVisible = false">关 闭</el-button></div>
    </el-dialog>

    <!-- 出库弹窗 -->
    <el-dialog title="确认出库" :visible.sync="outboundOpen" width="400px" append-to-body>
      <el-form label-width="80px" size="small">
        <el-form-item label="领书人" required>
          <el-input v-model="outboundForm.receiverName" placeholder="请填写领书人姓名" />
        </el-form-item>
      </el-form>
      <div slot="footer">
        <el-button type="primary" @click="submitOutbound">确认出库</el-button>
        <el-button @click="outboundOpen = false">取 消</el-button>
      </div>
    </el-dialog>

    <!-- 个人申请审核弹窗 -->
    <el-dialog title="审核" :visible.sync="paAuditOpen" width="500px" append-to-body>
      <el-descriptions :column="1" border v-if="paForm.applyId">
        <el-descriptions-item label="申请人">{{ paForm.teacherName }}</el-descriptions-item>
        <el-descriptions-item label="教材">{{ paForm.bookName }}</el-descriptions-item>
        <el-descriptions-item label="数量">{{ paForm.applyQty }} 本</el-descriptions-item>
        <el-descriptions-item label="用途">{{ paForm.purpose || '-' }}</el-descriptions-item>
        <el-descriptions-item label="申请时间">{{ paForm.createTime }}</el-descriptions-item>
      </el-descriptions>
      <el-form :model="paForm" label-width="80px" size="small" style="margin-top:15px;">
        <el-form-item label="审核结果">
          <el-radio-group v-model="paForm.status">
            <el-radio label="1">通过</el-radio>
            <el-radio label="2">驳回</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="审核意见">
          <el-input v-model="paForm.auditOpinion" type="textarea" :rows="2" placeholder="可选填审核意见" />
        </el-form-item>
        <el-form-item label="紧急程度" v-if="paForm.status==='2'">
          <el-select v-model="paForm.shortageUrgency">
            <el-option label="普通" value="0" />
            <el-option label="紧急" value="1" />
            <el-option label="特急" value="2" />
          </el-select>
        </el-form-item>
      </el-form>
      <div slot="footer">
        <el-button type="primary" @click="paSubmitAudit">确 定</el-button>
        <el-button @click="paAuditOpen=false">取 消</el-button>
      </div>
    </el-dialog>

    <!-- 个人申请详情弹窗 -->
    <el-dialog title="申请详情" :visible.sync="paViewOpen" width="550px" append-to-body>
      <el-descriptions :column="1" border v-if="paForm.applyId">
        <el-descriptions-item label="申请编号">{{ paForm.applyNo }}</el-descriptions-item>
        <el-descriptions-item label="申请人">{{ paForm.teacherName }}</el-descriptions-item>
        <el-descriptions-item label="教材名称">{{ paForm.bookName }}</el-descriptions-item>
        <el-descriptions-item label="ISBN">{{ paForm.isbn }}</el-descriptions-item>
        <el-descriptions-item label="数量">{{ paForm.applyQty }} 本</el-descriptions-item>
        <el-descriptions-item label="用途" :span="2">{{ paForm.purpose || '-' }}</el-descriptions-item>
        <el-descriptions-item label="状态">{{ paStatusText(paForm.status) }}</el-descriptions-item>
        <el-descriptions-item label="审核意见" :span="2">{{ paForm.auditOpinion || '-' }}</el-descriptions-item>
        <el-descriptions-item label="审核人">{{ paForm.auditBy || '-' }}</el-descriptions-item>
        <el-descriptions-item label="审核时间">{{ paForm.auditTime || '-' }}</el-descriptions-item>
        <el-descriptions-item label="出库时间" :span="2">{{ paForm.issueTime || '-' }}</el-descriptions-item>
      </el-descriptions>
      <div slot="footer"><el-button @click="paViewOpen=false">关 闭</el-button></div>
    </el-dialog>
  </div>
</template>

<script>
import { listNotice, getNotice, saveAndGenerate, updateNotice, delNotice, getClaimForms } from "@/api/textbook/claimManage";
import { listBook } from "@/api/textbook/book";
import { confirmOutbound } from "@/api/textbook/claimManage";
import { listPersonalApply, auditApply, issueApply, getPersonalApply } from "@/api/textbook/personalApply";

export default {
  name: "ClaimManage",
  data() {
    return {
      loading: false,
      total: 0,
      noticeList: [],
      showSearch: true,
      open: false,
      title: "新建领书计划",
      form: { semester: '', pickupLocation: '', pickupStart: '', pickupEnd: '', details: [] },
      rules: {
        semester: [{ required: true, message: '请输入学期', trigger: 'blur' }],
        pickupLocation: [{ required: true, message: '请输入领取地点', trigger: 'blur' }],
        pickupStart: [{ required: true, message: '请选择开始时间', trigger: 'change' }]
      },
      queryParams: { pageNum: 1, pageSize: 10, semester: undefined, status: undefined, bizType: '8' },
      detailDialogVisible: false,
      detailForm: { _editIndex: undefined, gradeLevel: '', className: '', textbookIds: [], plannedQty: 1 },
      bookOpts: [],
      bookLoading: false,
      formDetailVisible: false,
      formDetailList: [],
      outboundOpen: false,
      outboundForm: { formId: undefined, issuedQty: 0, receiverName: '' },
      activeTab: 'class',
      paList: [],
      paTotal: 0,
      paLoading: false,
      paParams: { pageNum: 1, pageSize: 10, teacherName: undefined, status: undefined },
      paAuditOpen: false,
      paViewOpen: false,
      paForm: {}
    }
  },
  created() {
    this.getList()
  },
  methods: {
    formatGradeLevel(val) {
      if (!val || val === '通用') return ''
      const match = val.match(/(\d{2})级/)
      if (match) {
        const year = parseInt(match[1])
        const currentYear = new Date().getFullYear()
        const enrollmentYear = year >= 50 ? 1900 + year : 2000 + year
        const grade = currentYear - enrollmentYear + 1
        const names = ['大一', '大二', '大三', '大四']
        return val + '/' + (names[grade - 1] || ('大' + grade))
      }
      return val
    },
    getList() {
      this.loading = true
      listNotice(this.queryParams).then(response => {
        this.noticeList = response.rows || []
        this.total = response.total
        this.loading = false
      })
    },
    handleQuery() {
      this.queryParams.pageNum = 1
      this.getList()
    },
    resetQuery() {
      this.resetForm("queryForm")
      this.handleQuery()
    },
    handleAdd() {
      this.form = { semester: '', pickupLocation: '', pickupStart: '', pickupEnd: '', details: [] }
      this.title = "新建领书计划"
      this.open = true
    },
    handleDelete(row) {
      this.$modal.confirm('删除该批次？相关领书单也需要删除').then(() =>
        delNotice(row.noticeId).then(() => { this.$modal.msgSuccess('已删除'); this.getList() })
      ).catch(() => {})
    },
    cancel() {
      this.open = false
      this.form = { semester: '', pickupLocation: '', pickupStart: '', pickupEnd: '', details: [] }
    },
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (!valid) return
        if (!this.form.details || this.form.details.length === 0) {
          this.$modal.msgError('请添加领书明细')
          return
        }
        const data = { ...this.form }
        if (this.form.noticeId) {
          updateNotice(data).then(() => {
            this.$modal.msgSuccess('修改成功')
            this.open = false
            this.getList()
          })
        } else {
          saveAndGenerate(data).then(() => {
            this.$modal.msgSuccess('创建成功')
            this.open = false
            this.getList()
          })
        }
      })
    },
    searchBook(query) {
      if (!query) { this.bookOpts = []; return }
      this.bookLoading = true
      listBook({ bookName: query, pageNum: 1, pageSize: 20 }).then(res => {
        this.bookOpts = res.rows || []
      }).finally(() => { this.bookLoading = false })
    },
    openDetailDialog() { this.detailForm = { _editIndex: undefined, gradeLevel: '', className: '', textbookIds: [], plannedQty: 1 }; this.detailDialogVisible = true },
    editDetail(idx) {
      const d = this.form.details[idx]
      this.detailForm = { _editIndex: idx, gradeLevel: d.gradeLevel || '', className: d.className || '', textbookIds: d.textbookId ? [d.textbookId] : [], plannedQty: d.plannedQty || 1 }
      this.detailDialogVisible = true
    },
    removeDetail(idx) { this.form.details.splice(idx, 1) },
    confirmAddDetail() {
      if (!this.detailForm.textbookIds || !this.detailForm.textbookIds.length) {
        this.$modal.msgError('请选择教材')
        return
      }
      const bs = this.bookOpts.filter(b => this.detailForm.textbookIds.includes(b.bookId))
      const items = bs.map(b => ({
        textbookId: b.bookId,
        bookName: b.bookName,
        isbn: b.isbn,
        author: b.author,
        publisher: b.publisher,
        plannedQty: this.detailForm.plannedQty,
        gradeLevel: this.detailForm.gradeLevel,
        className: this.detailForm.className
      }))
      const existing = this.form.details || []
      if (this.detailForm._editIndex !== undefined) {
        this.$set(this.form.details, this.detailForm._editIndex, items[0])
        this.$modal.msgSuccess('已更新')
      } else {
        this.form.details = existing.concat(items)
        this.$modal.msgSuccess('已添加' + items.length + ' 本教材')
      }
      this.detailDialogVisible = false
    },
    async toggleForms(row) {
      if (row._formsLoaded) return
      this.$set(row, '_loading', true)
      try {
        const res = await getClaimForms(row.noticeId)
        this.$set(row, '_forms', Array.isArray(res.data) ? res.data : [])
        this.$set(row, '_formsLoaded', true)
      } catch (e) { console.error(e) }
      this.$set(row, '_loading', false)
    },
    viewFormDetail(row) {
      this.formDetailList = row.details || []
      this.formDetailVisible = true
    },
    handleOutbound(row) {
      if (row.status === '2') { this.$modal.msgWarning('该领书单已全部出库'); return }
      this.outboundForm = { formId: row.formId, issuedQty: row.issuedQty || 0, receiverName: row.receiverName || '' }
      this.outboundOpen = true
    },
    handlePrint(row) {
      window.open('/dev-api/textbook/claimForm/pdf/' + row.formId, '_blank')
    },
    submitOutbound() {
      if (!this.outboundForm.receiverName || !this.outboundForm.receiverName.trim()) {
        this.$modal.msgError('请填写领书人姓名')
        return
      }
      confirmOutbound({ formId: this.outboundForm.formId, issuedQty: this.outboundForm.issuedQty, receiverName: this.outboundForm.receiverName }).then(() => {
        this.$modal.msgSuccess('出库成功')
        this.outboundOpen = false
        const noticedRow = this.noticeList.find(n => n._forms && n._forms.some(f => f.formId === this.outboundForm.formId))
        if (noticedRow) {
          this.$set(noticedRow, '_loading', true)
          getClaimForms(noticedRow.noticeId).then(res => {
            this.$set(noticedRow, '_forms', Array.isArray(res.data) ? res.data : [])
            this.$set(noticedRow, '_loading', false)
          }).catch(() => { this.$set(noticedRow, '_loading', false) })
        }
      }).catch(() => {})
    },
    onTabClick() { if (this.activeTab === 'personal') this.getPaList() },
    getPaList() {
      this.paLoading = true
      listPersonalApply(this.paParams).then(res => {
        this.paList = res.rows || []
        this.paTotal = res.total
        this.paLoading = false
      })
    },
    paView(row) { this.paForm = row; this.paViewOpen = true },
    paStatusText(s) { return { '0': '待审核', '1': '已通过', '2': '已驳回', '3': '已出库' }[s] || '-' },
    paSubmitAudit() {
      const approved = this.paForm.status === '1'
      auditApply({ applyId: this.paForm.applyId, status: this.paForm.status, auditOpinion: this.paForm.auditOpinion, shortageUrgency: this.paForm.shortageUrgency }).then(() => {
        this.$modal.msgSuccess(approved ? '已通过' : '已驳回')
        this.paAuditOpen = false
        this.getPaList()
      }).catch(() => {
        this.getPaList()
      })
    },
    paIssue(row) {
      this.$modal.confirm('确认将该申请出库发放？将扣减库存。').then(() => {
        issueApply(row.applyId).then(() => {
          this.$modal.msgSuccess('出库成功')
          this.getPaList()
        })
      }).catch(() => {})
    }
  }
}
</script>
