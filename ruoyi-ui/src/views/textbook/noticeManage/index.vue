<template>
  <div class="app-container">
    <el-card>
      <div slot="header" class="clearfix">
        <span>领书通知管理</span>
        <el-button v-hasPermi="['textbook:noticeManage:add']"
                   style="float: right; padding: 3px 0"
                   type="primary"
                   icon="el-icon-plus"
                   size="mini"
                   @click="handleAdd">
          新建通知
        </el-button>
      </div>

      <!-- 搜索区域 -->
      <el-form :model="queryParams" ref="queryForm" :inline="true" size="small">
        <el-form-item label="学期" prop="semester">
          <el-input v-model="queryParams.semester" placeholder="如：2025-2026-2" clearable @keyup.enter.native="handleQuery"/>
        </el-form-item>
        <el-form-item label="状态" prop="status">
          <el-select v-model="queryParams.status" placeholder="全部" clearable>
            <el-option label="草稿" value="0"/>
            <el-option label="已发布" value="1"/>
            <el-option label="领取中" value="2"/>
            <el-option label="已完成" value="3"/>
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
          <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
        </el-form-item>
      </el-form>

      <!-- 表格 -->
      <el-table v-loading="loading" :data="noticeList" border stripe>
        <el-table-column label="通知编号" prop="noticeNo" width="180" align="center"/>
        <el-table-column label="学期" prop="semester" width="140" align="center"/>
        <el-table-column label="领取时间" width="220" align="center">
          <template slot-scope="scope">
            {{ scope.row.pickupStart }} ~ {{ scope.row.pickupEnd }}
          </template>
        </el-table-column>
        <el-table-column label="领取地点" prop="pickupLocation" width="150" align="center" show-overflow-tooltip/>
        <el-table-column label="状态" prop="status" width="100" align="center">
          <template slot-scope="scope">
            <el-tag :type="statusTagType(scope.row.status)">{{ statusText(scope.row.status) }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column label="进度" width="120" align="center">
          <template slot-scope="scope">
            <el-progress :percentage="getProgress(scope.row)" :status="getProgressStatus(scope.row)" :stroke-width="10"/>
          </template>
        </el-table-column>
        <el-table-column label="创建时间" prop="createTime" width="160" align="center"/>
        <el-table-column label="操作" fixed="right" align="center" width="280">
          <template slot-scope="scope">
            <el-button v-if="scope.row.status === '0'" size="mini" type="success" icon="el-icon-upload2" @click="handlePublish(scope.row)">发布</el-button>
            <el-button v-if="scope.row.status !== '0'" size="mini" type="warning" icon="el-icon-document" @click="handleViewForms(scope.row)">查看领书单</el-button>
            <el-button v-if="scope.row.status === '0'" size="mini" type="primary" icon="el-icon-edit" @click="handleUpdate(scope.row)">编辑</el-button>
            <el-button v-if="scope.row.status === '0'" size="mini" type="danger" icon="el-icon-delete" @click="handleDelete(scope.row)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>

      <pagination
        v-show="total > 0"
        :total="total"
        :page.sync="queryParams.pageNum"
        :limit.sync="queryParams.pageSize"
        @pagination="getList"
      />
    </el-card>

    <!-- 新增/编辑弹窗 -->
    <el-dialog :title="dialogTitle" :visible.sync="open" width="800px" append-to-body :close-on-click-modal="false">
      <el-form ref="form" :model="form" :rules="rules" label-width="100px">
        <el-row>
          <el-col :span="12">
            <el-form-item label="学期" prop="semester">
              <el-input v-model="form.semester" placeholder="如：2025-2026-2"/>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="领取地点" prop="pickupLocation">
              <el-input v-model="form.pickupLocation" placeholder="如：图书馆一楼书库"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="开始时间" prop="pickupStart">
              <el-date-picker v-model="form.pickupStart" type="datetime" placeholder="选择日期时间" value-format="yyyy-MM-dd HH:mm:ss" style="width: 100%"/>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="结束时间" prop="pickupEnd">
              <el-date-picker v-model="form.pickupEnd" type="datetime" placeholder="选择日期时间" value-format="yyyy-MM-dd HH:mm:ss" style="width: 100%"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-form-item label="备注" prop="remark">
          <el-input v-model="form.remark" type="textarea" :rows="3" placeholder="可选填写"/>
        </el-form-item>
        
        <!-- 领书明细 -->
        <el-form-item label="领书明细">
          <el-button type="primary" size="small" @click="addDetail" style="margin-bottom: 10px">
            <i class="el-icon-plus"></i> 添加领书明细
          </el-button>
          <el-table v-if="form.details && form.details.length > 0" :data="form.details" border stripe style="margin-bottom: 10px">
            <el-table-column label="学院" prop="collegeName" width="120"/>
            <el-table-column label="专业" prop="majorName" width="120"/>
            <el-table-column label="班级" prop="className" width="120"/>
            <el-table-column label="教材名称" prop="bookName" show-overflow-tooltip/>
            <el-table-column label="ISBN" prop="isbn" width="150"/>
            <el-table-column label="应发数量" prop="plannedQty" width="100"/>
            <el-table-column label="操作" width="100" align="center">
              <template slot-scope="scope">
                <el-button type="danger" size="mini" @click="removeDetail(scope.$index)">
                  <i class="el-icon-delete"></i> 删除
                </el-button>
              </template>
            </el-table-column>
          </el-table>
          <el-alert v-else type="info" title="请添加领书明细" :closable="false"/>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitForm">确 定</el-button>
        <el-button @click="cancel">取 消</el-button>
      </div>
    </el-dialog>
    
    <!-- 添加领书明细弹窗 -->
    <el-dialog title="添加领书明细" :visible.sync="detailDialogVisible" width="700px" append-to-body>
      <el-form ref="detailForm" :model="detailForm" :rules="detailRules" label-width="100px">
        <el-form-item label="学院" prop="collegeId">
          <el-select v-model="detailForm.collegeId" placeholder="选择学院" style="width: 100%" @change="handleCollegeChange">
            <el-option v-for="college in colleges" :key="college.id" :label="college.name" :value="college.id"/>
          </el-select>
        </el-form-item>
        <el-form-item label="专业" prop="majorId">
          <el-select v-model="detailForm.majorId" placeholder="选择专业" style="width: 100%" :disabled="!detailForm.collegeId" @change="handleMajorChange">
            <el-option v-for="major in majors" :key="major.id" :label="major.name" :value="major.id"/>
          </el-select>
        </el-form-item>
        <el-form-item label="班级" prop="classId">
          <el-select v-model="detailForm.classId" placeholder="选择班级" style="width: 100%" :disabled="!detailForm.majorId">
            <el-option v-for="cls in classes" :key="cls.id" :label="cls.name" :value="cls.id"/>
          </el-select>
        </el-form-item>
        <el-form-item label="教材" prop="textbookId">
          <el-select v-model="detailForm.textbookId" placeholder="选择教材" style="width: 100%" filterable>
            <el-option v-for="book in books" :key="book.bookId" :label="book.bookName + ' (' + book.isbn + ')'" :value="book.bookId"/>
          </el-select>
        </el-form-item>
        <el-form-item label="应发数量" prop="plannedQty">
          <el-input-number v-model="detailForm.plannedQty" :min="1" :max="999" style="width: 100%"/>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="confirmAddDetail">确 定</el-button>
        <el-button @click="detailDialogVisible = false">取 消</el-button>
      </div>
    </el-dialog>

    <!-- 查看领书单弹窗 -->
    <el-dialog title="领书单列表" :visible.sync="formsDialogVisible" width="900px" append-to-body>
      <el-alert :title="'通知编号：' + currentNotice.noticeNo + ' | 学期：' + currentNotice.semester" type="info" :closable="false" style="margin-bottom: 15px;"/>
      <el-table :data="claimFormList" border stripe max-height="400">
        <el-table-column label="领书单号" prop="formNo" width="180" align="center"/>
        <el-table-column label="班级名称" prop="className" width="120" align="center"/>
        <el-table-column label="应发数量" prop="plannedQty" width="90" align="center"/>
        <el-table-column label="实发数量" prop="issuedQty" width="90" align="center"/>
        <el-table-column label="状态" prop="status" width="90" align="center">
          <template slot-scope="scope">
            <el-tag :type="formStatusTagType(scope.row.status)">{{ formStatusText(scope.row.status) }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column label="领书人" prop="receiverName" width="80" align="center"/>
        <el-table-column label="出库时间" prop="issueTime" width="160" align="center"/>
        <el-table-column label="操作" fixed="right" align="center" width="150">
          <template slot-scope="scope">
            <el-button size="mini" type="text" icon="el-icon-view" @click="handleViewDetail(scope.row)">详情</el-button>
            <el-button size="mini" type="primary" icon="el-icon-printer" @click="handlePrint(scope.row)">打印</el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-dialog>
  </div>
</template>

<script>
import { listNotice, getNotice, addNotice, updateNotice, publishNotice, delNotice, getClaimForms, getBooks, getColleges, getMajors, getClasses } from '@/api/textbook/noticeManage'

export default {
  name: 'BookNotice',
  data() {
    return {
      loading: true,
      total: 0,
      noticeList: [],
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        semester: undefined,
        status: undefined
      },
      open: false,
      dialogTitle: '',
      form: {
        details: []
      },
      rules: {
        semester: [{ required: true, message: '学期不能为空', trigger: 'blur' }],
        pickupStart: [{ required: true, message: '开始时间不能为空', trigger: 'change' }],
        pickupEnd: [{ required: true, message: '结束时间不能为空', trigger: 'change' }],
        pickupLocation: [{ required: true, message: '领取地点不能为空', trigger: 'blur' }]
      },
      formsDialogVisible: false,
      claimFormList: [],
      currentNotice: {},
      detailDialogVisible: false,
      detailForm: {
        collegeId: undefined,
        majorId: undefined,
        classId: undefined,
        textbookId: undefined,
        plannedQty: 1
      },
      detailRules: {
        collegeId: [{ required: true, message: '请选择学院', trigger: 'change' }],
        majorId: [{ required: true, message: '请选择专业', trigger: 'change' }],
        classId: [{ required: true, message: '请选择班级', trigger: 'change' }],
        textbookId: [{ required: true, message: '请选择教材', trigger: 'change' }],
        plannedQty: [{ required: true, message: '请输入应发数量', trigger: 'blur' }]
      },
      books: [],
      colleges: [],
      majors: [],
      classes: []
    }
  },
  created() {
    this.getList()
    this.initData()
  },
  methods: {
    initData() {
      // 加载教材列表
      getBooks().then(response => {
        this.books = response.data || []
      })
      // 加载学院列表
      getColleges().then(response => {
        this.colleges = response.data || []
      })
    },
    getList() {
      this.loading = true
      listNotice(this.queryParams).then(response => {
        this.noticeList = response.rows
        this.total = response.total
        this.loading = false
      })
    },
    handleQuery() {
      this.queryParams.pageNum = 1
      this.getList()
    },
    resetQuery() {
      this.resetForm('queryForm')
      this.handleQuery()
    },
    handleAdd() {
      this.reset()
      this.open = true
      this.dialogTitle = '新建领书通知'
    },
    handleUpdate(row) {
      this.reset()
      const noticeId = row.noticeId || this.ids
      getNotice(noticeId).then(response => {
        this.form = response.data
        this.open = true
        this.dialogTitle = '编辑领书通知'
      })
    },
    submitForm() {
      this.$refs['form'].validate(valid => {
        if (valid) {
          if (this.form.noticeId != null) {
            updateNotice(this.form).then(response => {
              this.$modal.msgSuccess('修改成功')
              this.open = false
              this.getList()
            })
          } else {
            addNotice(this.form).then(response => {
              this.$modal.msgSuccess('新增成功')
              this.open = false
              this.getList()
            })
          }
        }
      })
    },
    cancel() {
      this.open = false
      this.reset()
    },
    reset() {
      this.form = {
        noticeId: undefined,
        semester: undefined,
        pickupStart: undefined,
        pickupEnd: undefined,
        pickupLocation: undefined,
        remark: undefined,
        details: []
      }
      this.resetForm('form')
    },
    // 学院变化时加载专业列表
    handleCollegeChange() {
      if (this.detailForm.collegeId) {
        getMajors(this.detailForm.collegeId).then(response => {
          this.majors = response.data || []
          this.detailForm.majorId = undefined
          this.detailForm.classId = undefined
          this.classes = []
        })
      } else {
        this.majors = []
        this.detailForm.majorId = undefined
        this.detailForm.classId = undefined
        this.classes = []
      }
    },
    // 专业变化时加载班级列表
    handleMajorChange() {
      if (this.detailForm.majorId) {
        getClasses(this.detailForm.majorId).then(response => {
          this.classes = response.data || []
          this.detailForm.classId = undefined
        })
      } else {
        this.classes = []
        this.detailForm.classId = undefined
      }
    },
    // 添加领书明细
    addDetail() {
      this.detailForm = {
        collegeId: undefined,
        majorId: undefined,
        classId: undefined,
        textbookId: undefined,
        plannedQty: 1
      }
      this.detailDialogVisible = true
    },
    // 确认添加领书明细
    confirmAddDetail() {
      this.$refs['detailForm'].validate(valid => {
        if (valid) {
          const college = this.colleges.find(c => c.id === this.detailForm.collegeId)
          const major = this.majors.find(m => m.id === this.detailForm.majorId)
          const cls = this.classes.find(c => c.id === this.detailForm.classId)
          const book = this.books.find(b => b.bookId === this.detailForm.textbookId)
          
          if (college && major && cls && book) {
            const detail = {
              collegeId: this.detailForm.collegeId,
              majorId: this.detailForm.majorId,
              classId: this.detailForm.classId,
              textbookId: this.detailForm.textbookId,
              plannedQty: this.detailForm.plannedQty,
              collegeName: college.name,
              majorName: major.name,
              className: cls.name,
              bookName: book.bookName,
              isbn: book.isbn
            }
            this.form.details.push(detail)
            this.detailDialogVisible = false
          } else {
            this.$modal.msgError('数据加载失败，请重试')
          }
        }
      })
    },
    // 删除领书明细
    removeDetail(index) {
      this.form.details.splice(index, 1)
    },
    handlePublish(row) {
      this.$confirm('确认发布该领书通知？', '警告', { confirmButtonText: '确定', cancelButtonText: '取消', type: 'warning' }).then(() => {
        publishNotice(row.noticeId).then(() => {
          this.$modal.msgSuccess('发布成功')
          this.getList()
        })
      }).catch(() => {})
    },
    handleDelete(row) {
      const noticeIds = row.noticeId || this.ids
      this.$confirm('是否确认删除选中的数据项?', '警告', { confirmButtonText: '确定', cancelButtonText: '取消', type: 'warning' }).then(() => {
        return delNotice(noticeIds)
      }).then(() => {
        this.getList()
        this.$modal.msgSuccess('删除成功')
      }).catch(() => {})
    },
    async handleViewForms(row) {
      this.currentNotice = row
      try {
        const response = await getClaimForms(row.noticeId)
        this.claimFormList = response.data || []
        this.formsDialogVisible = true
      } catch (error) {
        this.$modal.msgError('获取领书单失败')
      }
    },
    handleViewDetail(row) {
      this.$router.push({ path: '/textbook/claimForm', query: { formId: row.formId }})
    },
    statusTagType(status) {
      const map = { '0': 'info', '1': '', '2': 'warning', '3': 'success' }
      return map[status] || ''
    },
    statusText(status) {
      const map = { '0': '草稿', '1': '已发布', '2': '领取中', '3': '已完成' }
      return map[status] || '未知'
    },
    formStatusTagType(status) {
      const map = { '0': 'info', '1': 'warning', '2': 'success' }
      return map[status] || ''
    },
    formStatusText(status) {
      const map = { '0': '待领取', '1': '部分出库', '2': '已出库' }
      return map[status] || '未知'
    },
    getProgress(row) {
      if (!row.totalClasses || row.totalClasses === 0) return 0
      return Math.round((row.issuedClasses / row.totalClasses) * 100)
    },
    getProgressStatus(row) {
      const progress = this.getProgress(row)
      if (progress >= 100) return 'success'
      if (progress > 0) return ''
      return undefined
    },
    // 打印领书单
    handlePrint(row) {
      this.$confirm('确认打印该领书单？', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'info'
      }).then(() => {
        // 这里实现打印功能
        this.$modal.msgSuccess('打印功能已触发，实际项目中可调用打印API')
      }).catch(() => {})
    }
  }
}
</script>

<style scoped>
.el-progress {
  margin-top: 5px;
}
</style>
