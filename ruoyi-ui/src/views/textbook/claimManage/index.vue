<template>
  <div class="app-container">
    <el-tabs v-model="activeTab" @tab-click="onTabClick">
      <!-- ========== Tab1: 班级领书 ========== -->
      <el-tab-pane label="班级领书" name="class">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="学期" prop="semester">
        <el-input v-model="queryParams.semester" placeholder="如 2025-2026-2" clearable @keyup.enter.native="handleQuery" />
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
    </el-row>

    <!-- 领书批次列表(可展开) -->
    <el-table v-loading="loading" :data="noticeList" border stripe @expand-change="onExpandChange">
      <el-table-column type="expand">
        <template slot-scope="props">
          <div v-loading="props.row._loading" style="padding: 8px 20px;">
            <el-table :data="props.row._forms" size="small" border stripe style="min-width: 780px" v-if="props.row._forms && props.row._forms.length">
              <el-table-column label="领书单号" prop="formNo" width="190" />
              <el-table-column label="班级信息" min-width="160">
                <template slot-scope="s">{{ s.row.collegeName }} {{ s.row.majorName }} {{ s.row.grade }}{{ s.row.className }}</template>
              </el-table-column>
              <el-table-column label="应发" prop="plannedQty" width="55" align="center" />
              <el-table-column label="已发" prop="issuedQty" width="55" align="center" />
              <el-table-column label="状态" width="70" align="center">
                <template slot-scope="s">
                  <el-tag :type="s.row.status==='2'?'success':s.row.status==='1'?'warning':''" size="mini">{{ s.row.status==='2'?'已出库':s.row.status==='1'?'部分':'待领' }}</el-tag>
                </template>
              </el-table-column>
              <el-table-column label="领书人" prop="receiverName" width="65" />
              <el-table-column label="操作" width="155" align="center">
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
      <el-table-column label="批次编号" prop="noticeNo" width="210" />
      <el-table-column label="学期" prop="semester" width="110" />
      <el-table-column label="领取时间" width="220">
        <template slot-scope="s">{{ (s.row.pickupStart||'') + ' ~ ' + (s.row.pickupEnd||'') }}</template>
      </el-table-column>
      <el-table-column label="领取地点" prop="pickupLocation" show-overflow-tooltip />
      <el-table-column label="状态" width="80" align="center">
        <template slot-scope="s">
          <el-tag :type="s.row.status==='3'?'success':''" size="small">{{ s.row.status==='3'?'已完成':'进行中' }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="班级进度" width="100" align="center">
        <template slot-scope="s">{{ s.row.issuedClasses||0 }} / {{ s.row.totalClasses||0 }}</template>
      </el-table-column>
      <el-table-column label="创建时间" prop="createTime" width="160" />
      <el-table-column label="操作" width="140" align="center" fixed="right">
        <template slot-scope="scope">
          <el-button size="mini" type="danger" icon="el-icon-delete" @click.stop="handleDelete(scope.row)" v-hasPermi="['textbook:noticeManage:remove']">删除</el-button>
        </template>
      </el-table-column>
    </el-table>
    <pagination v-show="total>0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />

    <!-- 新建领书计划弹窗 -->
    <el-dialog title="新建领书计划" :visible.sync="open" width="850px" append-to-body :close-on-click-modal="false" @closed="resetForm">
      <el-form ref="form" :model="form" :rules="rules" label-width="100px">
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="学期" prop="semester">
              <el-input v-model="form.semester" placeholder="如 2025-2026-2" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="领取地点" prop="pickupLocation">
              <el-input v-model="form.pickupLocation" placeholder="如 图书馆一楼大厅" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="领取开始" prop="pickupStart">
              <el-date-picker v-model="form.pickupStart" type="datetime" placeholder="选择开始时间" value-format="yyyy-MM-dd HH:mm:ss" style="width:100%" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="领取结束" prop="pickupEnd">
              <el-date-picker v-model="form.pickupEnd" type="datetime" placeholder="选择结束时间" value-format="yyyy-MM-dd HH:mm:ss" style="width:100%" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-form-item label="备注">
          <el-input v-model="form.remark" type="textarea" :rows="2" />
        </el-form-item>
        <el-form-item label="领书明细">
          <el-button type="primary" size="small" @click="addDetail" style="margin-bottom: 10px">
            <i class="el-icon-plus"></i> 添加领书明细
          </el-button>
          <el-table v-if="form.details && form.details.length > 0" :data="form.details" border stripe style="margin-bottom: 10px">
            <el-table-column label="学院" prop="collegeName" width="120"/>
            <el-table-column label="专业" prop="majorName" width="120"/>
            <el-table-column label="年级" prop="grade" width="80"/>
            <el-table-column label="班级" prop="className" width="80"/>
            <el-table-column label="教材名称" prop="bookName" show-overflow-tooltip/>
            <el-table-column label="ISBN" prop="isbn" width="150"/>
            <el-table-column label="数量" prop="plannedQty" width="80" align="center"/>
            <el-table-column label="操作" width="140" align="center">
              <template slot-scope="scope">
                <el-button type="primary" size="mini" @click="editDetail(scope.$index)"><i class="el-icon-edit"></i></el-button>
                <el-button type="danger" size="mini" @click="removeDetail(scope.$index)"><i class="el-icon-delete"></i></el-button>
              </template>
            </el-table-column>
          </el-table>
          <el-alert v-else type="info" title="请添加领书明细" :closable="false"/>
        </el-form-item>
      </el-form>
      <div slot="footer">
        <el-button type="primary" @click="submitForm">保存并生成领书单</el-button>
        <el-button @click="open = false">取 消</el-button>
      </div>
    </el-dialog>

    <!-- 领书明细弹窗 -->
    <el-dialog :title="editingIndex >= 0 ? '编辑领书明细' : '添加领书明细'" :visible.sync="detailDialogVisible" width="700px" append-to-body :close-on-click-modal="false">
      <el-form ref="detailForm" :model="detailForm" :rules="detailRules" label-width="100px">
        <el-form-item label="学院" prop="collegeId">
          <el-select v-model="detailForm.collegeId" placeholder="选择学院" style="width:100%" @change="handleCollegeChange">
            <el-option v-for="c in colleges" :key="c.id" :label="c.name" :value="c.id"/>
          </el-select>
        </el-form-item>
        <el-form-item label="专业" prop="majorId">
          <el-select v-model="detailForm.majorId" placeholder="选择专业" style="width:100%" :disabled="!detailForm.collegeId">
            <el-option v-for="m in majors" :key="m.id" :label="m.name" :value="m.id"/>
          </el-select>
        </el-form-item>
        <el-form-item label="年级">
          <el-input v-model="detailForm.grade" placeholder="如：2024级" />
        </el-form-item>
        <el-form-item label="班级">
          <el-input v-model="detailForm.className" placeholder="如：1班" />
        </el-form-item>
        <el-form-item label="教材" prop="textbookIds">
          <el-select v-model="detailForm.textbookIds" placeholder="选择教材（可多选）" style="width:100%" filterable multiple collapse-tags>
            <el-option v-for="b in books" :key="b.bookId" :label="b.bookName + ' (' + b.isbn + ')'" :value="b.bookId"/>
          </el-select>
        </el-form-item>
        <el-form-item label="数量" prop="plannedQty">
          <el-input-number v-model="detailForm.plannedQty" :min="1" :max="999" />
        </el-form-item>
      </el-form>
      <div slot="footer">
        <el-button type="primary" @click="confirmAddDetail">确 定</el-button>
        <el-button @click="detailDialogVisible = false">取 消</el-button>
      </div>
    </el-dialog>

    <!-- 领书单明细弹窗 -->
    <el-dialog title="领书单明细" :visible.sync="formDetailVisible" width="800px" append-to-body>
      <el-descriptions :column="2" border>
        <el-descriptions-item label="领书单号">{{ formDetailData.formNo }}</el-descriptions-item>
        <el-descriptions-item label="班级">{{ formDetailData.collegeName }} {{ formDetailData.majorName }} {{ formDetailData.className }}</el-descriptions-item>
        <el-descriptions-item label="应发">{{ formDetailData.plannedQty }}</el-descriptions-item>
        <el-descriptions-item label="已发">{{ formDetailData.issuedQty }}</el-descriptions-item>
      </el-descriptions>
      <el-table :data="formDetails" size="small" border stripe style="margin-top:15px">
        <el-table-column label="ISBN" prop="isbn" width="150" />
        <el-table-column label="教材名称" prop="bookName" show-overflow-tooltip />
        <el-table-column label="应发" prop="plannedQty" width="70" align="center" />
        <el-table-column label="已发" prop="issuedQty" width="70" align="center" />
      </el-table>
      <div slot="footer"><el-button @click="formDetailVisible = false">关 闭</el-button></div>
    </el-dialog>

    <!-- 确认出库弹窗 -->
    <el-dialog title="确认出库" :visible.sync="outboundOpen" width="450px" append-to-body :close-on-click-modal="false">
      <el-descriptions :column="1" border>
        <el-descriptions-item label="领书单号">{{ outboundForm.formNo }}</el-descriptions-item>
        <el-descriptions-item label="班级">{{ outboundForm.className }}</el-descriptions-item>
        <el-descriptions-item label="应发">{{ outboundForm.plannedQty }}</el-descriptions-item>
        <el-descriptions-item label="已发">{{ outboundForm.issuedQty }}</el-descriptions-item>
      </el-descriptions>
      <el-form ref="outboundFormRef" :model="outboundForm" label-width="80px" style="margin-top:15px">
        <el-form-item label="实发数量" required>
          <el-input-number v-model="outboundForm.issuedQty" :min="1" :max="outboundForm.plannedQty - (outboundForm._origIssued||0)" />
        </el-form-item>
        <el-form-item label="领书人" required>
          <el-input v-model="outboundForm.receiverName" placeholder="班委姓名" />
        </el-form-item>
      </el-form>
      <div slot="footer">
        <el-button type="primary" :loading="submitLoading" @click="submitOutbound">确认出库</el-button>
        <el-button @click="outboundOpen = false">取 消</el-button>
      </div>
    </el-dialog>
      </el-tab-pane>

      <!-- ========== Tab2: 个人领书申请 ========== -->
      <el-tab-pane label="个人领书申请" name="personal">
        <el-form :model="paParams" ref="paQueryForm" size="small" :inline="true" label-width="68px">
          <el-form-item label="申请编号"><el-input v-model="paParams.applyNo" placeholder="申请编号" clearable @keyup.enter.native="getPaList"/></el-form-item>
          <el-form-item label="申请人"><el-input v-model="paParams.teacherName" placeholder="申请人" clearable @keyup.enter.native="getPaList"/></el-form-item>
          <el-form-item label="状态">
            <el-select v-model="paParams.status" placeholder="请选择" clearable>
              <el-option label="待审核" value="0"/>
              <el-option label="已通过" value="1"/>
              <el-option label="已驳回" value="2"/>
              <el-option label="已出库" value="3"/>
            </el-select>
          </el-form-item>
          <el-form-item>
            <el-button type="primary" icon="el-icon-search" size="mini" @click="onPaSearch">搜索</el-button>
            <el-button icon="el-icon-refresh" size="mini" @click="onPaReset">重置</el-button>
          </el-form-item>
        </el-form>

        <el-table v-loading="paLoading" :data="paList" border stripe>
          <el-table-column label="申请编号" prop="applyNo" width="200"/>
          <el-table-column label="申请人" prop="teacherName" width="100"/>
          <el-table-column label="教材名称" prop="bookName" show-overflow-tooltip/>
          <el-table-column label="ISBN" prop="isbn" width="150"/>
          <el-table-column label="数量" prop="applyQty" width="70" align="center"/>
          <el-table-column label="用途" prop="purpose" show-overflow-tooltip width="120"/>
          <el-table-column label="状态" width="80" align="center">
            <template slot-scope="s">
              <el-tag :type="paStatusType(s.row.status)" size="small">{{ paStatusText(s.row.status) }}</el-tag>
            </template>
          </el-table-column>
          <el-table-column label="审核意见" prop="auditOpinion" show-overflow-tooltip width="120"/>
          <el-table-column label="申请时间" prop="createTime" width="160"/>
          <el-table-column label="操作" width="160" align="center">
            <template slot-scope="s">
              <el-button size="mini" type="text" icon="el-icon-view" @click="paView(s.row)">详情</el-button>
              <el-button size="mini" type="text" icon="el-icon-check" style="color:#67C23A" @click="paAudit(s.row)" v-if="s.row.status==='0'" v-hasPermi="['textbook:personalApply:audit']">审核</el-button>
              <el-button size="mini" type="text" icon="el-icon-sold-out" @click="paIssue(s.row)" v-if="s.row.status==='1'" v-hasPermi="['textbook:personalApply:issue']">出库</el-button>
            </template>
          </el-table-column>
        </el-table>
        <pagination v-show="paTotal>0" :total="paTotal" :page.sync="paParams.pageNum" :limit.sync="paParams.pageSize" @pagination="getPaList"/>

        <!-- 个人领书审核弹窗 -->
        <el-dialog title="审核申请" :visible.sync="paAuditOpen" width="500px" append-to-body>
          <el-descriptions :column="1" border>
            <el-descriptions-item label="申请人">{{ paForm.teacherName }}</el-descriptions-item>
            <el-descriptions-item label="教材">{{ paForm.bookName }}</el-descriptions-item>
            <el-descriptions-item label="数量">{{ paForm.applyQty }} 本</el-descriptions-item>
            <el-descriptions-item label="用途">{{ paForm.purpose || '-' }}</el-descriptions-item>
          </el-descriptions>
          <el-form ref="paAuditForm" :model="paForm" label-width="80px" style="margin-top:15px">
            <el-form-item label="审核结果" required>
              <el-radio-group v-model="paForm.status">
                <el-radio label="1">通过</el-radio>
                <el-radio label="2">驳回</el-radio>
              </el-radio-group>
            </el-form-item>
            <el-form-item label="审核意见">
              <el-input v-model="paForm.auditOpinion" type="textarea" :rows="2"/>
            </el-form-item>
            <el-form-item v-if="paForm.status==='2'">
              <el-checkbox v-model="paForm.registerShortage">同时登记缺书</el-checkbox>
            </el-form-item>
            <template v-if="paForm.status==='2' && paForm.registerShortage">
              <el-form-item label="缺书数量"><el-input-number v-model="paForm.shortageQty" :min="1"/></el-form-item>
              <el-form-item label="紧急程度">
                <el-select v-model="paForm.shortageUrgency"><el-option label="普通" value="0"/><el-option label="紧急" value="1"/><el-option label="特急" value="2"/></el-select>
              </el-form-item>
              <el-form-item label="缺书备注"><el-input v-model="paForm.shortageRemark"/></el-form-item>
            </template>
          </el-form>
          <div slot="footer"><el-button type="primary" @click="paSubmitAudit">确 定</el-button><el-button @click="paAuditOpen=false">取 消</el-button></div>
        </el-dialog>

        <!-- 个人领书详情弹窗 -->
        <el-dialog title="申请详情" :visible.sync="paViewOpen" width="550px" append-to-body>
          <el-descriptions :column="2" border>
            <el-descriptions-item label="申请编号" :span="2">{{ paForm.applyNo }}</el-descriptions-item>
            <el-descriptions-item label="申请人">{{ paForm.teacherName }}</el-descriptions-item>
            <el-descriptions-item label="教材">{{ paForm.bookName }}</el-descriptions-item>
            <el-descriptions-item label="ISBN">{{ paForm.isbn }}</el-descriptions-item>
            <el-descriptions-item label="数量">{{ paForm.applyQty }}</el-descriptions-item>
            <el-descriptions-item label="用途" :span="2">{{ paForm.purpose || '-' }}</el-descriptions-item>
            <el-descriptions-item label="状态">{{ paStatusText(paForm.status) }}</el-descriptions-item>
            <el-descriptions-item label="审核意见">{{ paForm.auditOpinion || '-' }}</el-descriptions-item>
            <el-descriptions-item label="审核人">{{ paForm.auditBy || '-' }}</el-descriptions-item>
            <el-descriptions-item label="审核时间">{{ paForm.auditTime || '-' }}</el-descriptions-item>
            <el-descriptions-item label="出库时间">{{ paForm.issueTime || '-' }}</el-descriptions-item>
          </el-descriptions>
          <div slot="footer"><el-button @click="paViewOpen=false">关 闭</el-button></div>
        </el-dialog>
      </el-tab-pane>
    </el-tabs>
  </div>
</template>

<script>
import { listNotice, saveAndGenerate, delNotice, getClaimForms, getBooks, getColleges, getMajors, listClaimFormDetail, confirmOutbound, listPersonalApply, getPersonalApply, auditApply, issuePersonalApply } from '@/api/textbook/claimManage'

export default {
  name: 'ClaimManage',
  data() {
    return {
      loading: true,
      total: 0,
      noticeList: [],
      showSearch: true,
      open: false,
      detailDialogVisible: false,
      editingIndex: -1,
      formDetailVisible: false,
      outboundOpen: false,
      submitLoading: false,
      formDetailData: {},
      formDetails: [],
      outboundForm: {},
      books: [],
      colleges: [],
      majors: [],
      detailForm: { collegeId: undefined, majorId: undefined, grade: '', className: '', textbookIds: [], plannedQty: 1 },
      detailRules: {
        collegeId: [{ required: true, message: '请选择学院', trigger: 'change' }],
        majorId: [{ required: true, message: '请选择专业', trigger: 'change' }],
        textbookIds: [{ required: true, message: '请至少选择一本教材', trigger: 'change' }],
        plannedQty: [{ required: true, message: '请输入数量', trigger: 'blur' }]
      },
      queryParams: { pageNum: 1, pageSize: 10, semester: null, status: null },
      form: { noticeId: null, semester: '', pickupLocation: '', pickupStart: '', pickupEnd: '', remark: '', details: [] },
      rules: {
        semester: [{ required: true, message: '请输入学期', trigger: 'blur' }],
        pickupLocation: [{ required: true, message: '请输入领取地点', trigger: 'blur' }],
        pickupStart: [{ required: true, message: '请选择开始时间', trigger: 'change' }],
        pickupEnd: [{ required: true, message: '请选择结束时间', trigger: 'change' }]
      },
      activeTab: 'class',
      // 个人领书申请
      paLoading: false,
      paList: [],
      paTotal: 0,
      paAuditOpen: false,
      paViewOpen: false,
      paForm: {},
      paParams: { pageNum: 1, pageSize: 10, applyNo: null, teacherName: null, status: null }
    }
  },
  created() {
    this.getList()
    this.loadBooks()
  },
  methods: {
    getList() {
      this.loading = true
      listNotice(this.queryParams).then(res => {
        this.noticeList = res.rows
        this.total = res.total
        this.loading = false
      }).catch(() => { this.loading = false })
    },
    loadBooks() { getBooks().then(res => { this.books = res.rows || [] }) },
    handleQuery() { this.queryParams.pageNum = 1; this.getList() },
    resetQuery() { this.resetForm('queryForm'); this.handleQuery() },
    handleAdd() {
      this.resetForm()
      this.open = true
    },
    resetForm() {
      this.form = { noticeId: null, semester: '', pickupLocation: '', pickupStart: '', pickupEnd: '', remark: '', details: [] }
      this.editingIndex = -1
      if (this.$refs.form) this.$refs.form.resetFields()
    },
    onExpandChange(row, expanded) {
      if (expanded && !row._forms) {
        row._loading = true
        this.$set(row, '_loading', true)
        getClaimForms(row.noticeId).then(res => {
          this.$set(row, '_forms', Array.isArray(res.data) ? res.data : [])
          this.$set(row, '_loading', false)
        }).catch(() => { this.$set(row, '_loading', false) })
      }
    },
    handleDelete(row) { this.$confirm('删除该批次？相关领书单也需要删除', '确认').then(() => delNotice(row.noticeId).then(() => { this.$modal.msgSuccess('已删除'); this.getList() })).catch(() => {}) },
    handleCollegeChange() {
      if (this.detailForm.collegeId) {
        getMajors(this.detailForm.collegeId).then(res => { this.majors = res.data || []; this.detailForm.majorId = undefined })
      } else { this.majors = []; this.detailForm.majorId = undefined }
    },
    addDetail() {
      this.editingIndex = -1
      this.detailForm = { collegeId: undefined, majorId: undefined, grade: '', className: '', textbookIds: [], plannedQty: 1 }
      getColleges().then(res => { this.colleges = res.data || [] })
      this.detailDialogVisible = true
    },
    editDetail(index) {
      const d = this.form.details[index]
      this.editingIndex = index
      const college = this.colleges.find(c => c.name === d.collegeName)
      if (college) {
        getMajors(college.id).then(res => {
          this.majors = res.data || []
          const major = this.majors.find(m => m.name === d.majorName)
          this.detailForm = { collegeId: college.id, majorId: major ? major.id : undefined, grade: d.grade||'', className: d.className||'', textbookIds: d.textbookId ? [d.textbookId] : [], plannedQty: d.plannedQty||1 }
          this.detailDialogVisible = true
        })
      } else {
        this.detailForm = { collegeId: undefined, majorId: undefined, grade: d.grade||'', className: d.className||'', textbookIds: d.textbookId ? [d.textbookId] : [], plannedQty: d.plannedQty||1 }
        this.detailDialogVisible = true
      }
    },
    confirmAddDetail() {
      this.$refs.detailForm.validate(valid => {
        if (valid) {
          const college = this.colleges.find(c => c.id === this.detailForm.collegeId)
          const major = this.majors.find(m => m.id === this.detailForm.majorId)
          if (college && major && this.detailForm.textbookIds.length > 0) {
            if (this.editingIndex >= 0) {
              const b = this.books.find(x => x.bookId === this.detailForm.textbookIds[0])
              if (b) this.form.details[this.editingIndex] = { collegeId: college.id, majorId: major.id, textbookId: b.bookId, plannedQty: this.detailForm.plannedQty, collegeName: college.name, majorName: major.name, grade: this.detailForm.grade||'', className: this.detailForm.className||'', bookName: b.bookName, isbn: b.isbn }
              this.$modal.msgSuccess('已更新')
            } else {
              this.detailForm.textbookIds.forEach(bid => {
                const b = this.books.find(x => x.bookId === bid)
                if (b) this.form.details.push({ collegeId: college.id, majorId: major.id, textbookId: bid, plannedQty: this.detailForm.plannedQty, collegeName: college.name, majorName: major.name, grade: this.detailForm.grade||'', className: this.detailForm.className||'', bookName: b.bookName, isbn: b.isbn })
              })
              this.$modal.msgSuccess('已添加 ' + this.detailForm.textbookIds.length + ' 本教材')
            }
            this.detailDialogVisible = false
          } else { this.$modal.msgError('请完善信息') }
        }
      })
    },
    removeDetail(index) { this.form.details.splice(index, 1) },
    submitForm() {
      this.$refs.form.validate(valid => {
        if (valid) {
          if (this.form.details.length === 0) { this.$modal.msgError('请添加领书明细'); return }
          saveAndGenerate(this.form).then(() => { this.$modal.msgSuccess('已保存，领书单已生成'); this.open = false; this.getList() })
        }
      })
    },
    viewFormDetail(row) {
      listClaimFormDetail(row.formId).then(res => { this.formDetailData = row; this.formDetails = res.data || []; this.formDetailVisible = true })
    },
    handleOutbound(row) {
      this.outboundForm = { ...row, _origIssued: row.issuedQty||0, issuedQty: 0, receiverName: '' }
      this.outboundOpen = true
    },
    submitOutbound() {
      if (!this.outboundForm.receiverName || !this.outboundForm.receiverName.trim()) { this.$modal.msgError('请填写领书人姓名'); return }
      this.submitLoading = true
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
      }).catch(() => {}).finally(() => { this.submitLoading = false })
    },
    handlePrint(row) { window.open('/dev-api/textbook/claimForm/pdf/' + row.formId, '_blank') },
    // -- 个人领书申请 --
    onTabClick() { if (this.activeTab === 'personal') this.getPaList() },
    getPaList() {
      this.paLoading = true
      listPersonalApply(this.paParams).then(res => {
        this.paList = res.rows; this.paTotal = res.total; this.paLoading = false
      }).catch(() => { this.paLoading = false })
    },
    onPaSearch() { this.paParams.pageNum = 1; this.getPaList() },
    onPaReset() { this.resetForm('paQueryForm'); this.onPaSearch() },
    paStatusText(s) { return {'0':'待审核','1':'已通过','2':'已驳回','3':'已出库'}[s] || '-' },
    paStatusType(s) { return {'0':'warning','1':'success','2':'danger','3':''}[s] || 'info' },
    paView(row) { getPersonalApply(row.applyId).then(res => { this.paForm = res.data || {}; this.paViewOpen = true }) },
    paAudit(row) {
      this.paForm = { ...row, status: '1', auditOpinion: '', registerShortage: false, shortageQty: row.applyQty, shortageUrgency: '0', shortageRemark: '' }
      this.paAuditOpen = true
    },
    paSubmitAudit() {
      const data = { applyId: this.paForm.applyId, status: this.paForm.status, auditOpinion: this.paForm.auditOpinion }
      if (this.paForm.registerShortage) {
        data.registerShortage = true; data.shortageQty = this.paForm.shortageQty; data.shortageUrgency = this.paForm.shortageUrgency; data.shortageRemark = this.paForm.shortageRemark
      }
      auditApply(data).then(() => {
        this.$modal.msgSuccess(this.paForm.status==='1'?'已通过':'已驳回')
        this.paAuditOpen = false; this.getPaList()
      })
    },
    paIssue(row) {
      this.$confirm('确认将该申请出库发放？将扣减库存。', '确认出库', { type: 'success' }).then(() => {
        issuePersonalApply(row.applyId).then(() => { this.$modal.msgSuccess('出库成功'); this.getPaList() })
      }).catch(() => {})
    },
  }
}
</script>

<style scoped>
.mb8 { margin-bottom: 8px; }
</style>
