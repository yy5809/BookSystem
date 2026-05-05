<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="职工号" prop="userName">
        <el-input v-model="queryParams.userName" placeholder="请输入职工号" clearable style="width: 200px" @keyup.enter.native="handleQuery" />
      </el-form-item>
      <el-form-item label="姓名" prop="nickName">
        <el-input v-model="queryParams.nickName" placeholder="请输入姓名" clearable style="width: 200px" @keyup.enter.native="handleQuery" />
      </el-form-item>
      <el-form-item label="所属部门" prop="deptId">
        <el-select v-model="queryParams.deptId" placeholder="请选择部门" clearable style="width: 200px">
          <el-option v-for="dept in deptOptions" :key="dept.deptId" :label="dept.deptName" :value="dept.deptId" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button type="primary" plain icon="el-icon-plus" size="mini" @click="handleAdd" v-hasPermi="['textbook:teacher:add']">新增</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="success" plain icon="el-icon-edit" size="mini" :disabled="single" @click="handleUpdate" v-hasPermi="['textbook:teacher:edit']">修改</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="danger" plain icon="el-icon-delete" size="mini" :disabled="multiple" @click="handleDelete" v-hasPermi="['textbook:teacher:remove']">删除</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="info" plain icon="el-icon-upload2" size="mini" @click="handleImport" v-hasPermi="['textbook:teacher:import']">导入</el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="teacherList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="50" align="center" />
      <el-table-column label="姓名" align="center" prop="nickName" show-overflow-tooltip />
      <el-table-column label="职工号" align="center" prop="userName" show-overflow-tooltip />
      <el-table-column label="所属部门" align="center" prop="dept.deptName" show-overflow-tooltip />
      <el-table-column label="状态" align="center" width="80">
        <template slot-scope="scope">
          <el-switch v-model="scope.row.status" active-value="0" inactive-value="1" @change="handleStatusChange(scope.row)"></el-switch>
        </template>
      </el-table-column>
      <el-table-column label="创建时间" align="center" width="160">
        <template slot-scope="scope">
          <span>{{ parseTime(scope.row.createTime) }}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作" align="center" width="180" class-name="small-padding fixed-width">
        <template slot-scope="scope">
          <el-button size="mini" type="text" icon="el-icon-edit" @click="handleUpdate(scope.row)" v-hasPermi="['textbook:teacher:edit']">修改</el-button>
          <el-button size="mini" type="text" icon="el-icon-key" @click="handleResetPwd(scope.row)" v-hasPermi="['textbook:teacher:resetPwd']">重置密码</el-button>
          <el-button size="mini" type="text" icon="el-icon-delete" @click="handleDelete(scope.row)" v-hasPermi="['textbook:teacher:remove']">删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />

    <el-dialog :title="title" :visible.sync="open" width="500px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="80px">
        <el-form-item label="姓名" prop="nickName">
          <el-input v-model="form.nickName" placeholder="请输入姓名" maxlength="30" />
        </el-form-item>
        <el-form-item label="职工号" prop="userName">
          <el-input v-model="form.userName" placeholder="请输入职工号" maxlength="30" :disabled="form.userId != undefined" />
        </el-form-item>
        <el-form-item label="所属部门" prop="deptId">
          <el-select v-model="form.deptId" placeholder="请选择所属部门" style="width: 100%">
            <el-option v-for="dept in deptOptions" :key="dept.deptId" :label="dept.deptName" :value="dept.deptId" />
          </el-select>
        </el-form-item>
        <el-form-item v-if="form.userId == undefined" label="密码" prop="password">
          <el-input v-model="form.password" placeholder="请输入密码" type="password" maxlength="20" show-password />
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitForm">确 定</el-button>
        <el-button @click="cancel">取 消</el-button>
      </div>
    </el-dialog>

    <el-dialog :title="upload.title" :visible.sync="upload.open" width="400px" append-to-body>
      <el-upload ref="upload" :limit="1" accept=".xlsx, .xls" :headers="upload.headers" :action="upload.url" :disabled="upload.isUploading" :on-progress="handleFileUploadProgress" :on-success="handleFileSuccess" :auto-upload="false" drag>
        <i class="el-icon-upload"></i>
        <div class="el-upload__text">将文件拖到此处，或<em>点击上传</em></div>
        <div class="el-upload__tip text-center" slot="tip">
          <span>仅允许导入xls、xlsx格式文件。</span>
          <el-link type="primary" :underline="false" style="font-size: 12px; vertical-align: baseline" @click="importTemplate">下载模板</el-link>
        </div>
      </el-upload>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitFileForm">确 定</el-button>
        <el-button @click="upload.open = false">取 消</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { listTeacher, getTeacher, addTeacher, updateTeacher, delTeacher, resetTeacherPwd, changeTeacherStatus } from "@/api/textbook/teacher"
import { getToken } from "@/utils/auth"

export default {
  name: "TeacherManage",
  data() {
    return {
      loading: true,
      ids: [],
      single: true,
      multiple: true,
      showSearch: true,
      total: 0,
      teacherList: [],
      title: "",
      deptOptions: [],
      open: false,
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        userName: undefined,
        nickName: undefined,
        deptId: undefined
      },
      form: {},
      upload: {
        title: "",
        open: false,
        isUploading: false,
        headers: { Authorization: "Bearer " + getToken() },
        url: process.env.VUE_APP_BASE_API + "/textbook/teacher/importData"
      },
      rules: {
        userName: [
          { required: true, message: "职工号不能为空", trigger: "blur" },
          { min: 1, max: 30, message: '职工号长度必须介于 1 和 30 之间', trigger: 'blur' }
        ],
        nickName: [
          { required: true, message: "姓名不能为空", trigger: "blur" }
        ],
        password: [
          { required: true, message: "密码不能为空", trigger: "blur" },
          { min: 5, max: 20, message: '密码长度必须介于 5 和 20 之间', trigger: 'blur' },
          { pattern: /^[^<>"'|\\]+$/, message: "不能包含非法字符：< > \" ' \\ |", trigger: "blur" }
        ],
        deptId: [
          { required: true, message: "所属部门不能为空", trigger: "change" }
        ]
      }
    }
  },
  created() {
    this.getList()
    this.getDeptOptions()
  },
  methods: {
    getList() {
      this.loading = true
      listTeacher(this.queryParams).then(response => {
        this.teacherList = response.rows
        this.total = response.total
        this.loading = false
      })
    },
    getDeptOptions() {
      const deptList = [
        { deptId: 300, deptName: '环境科学与工程学院' },
        { deptId: 301, deptName: '智能制造学院' },
        { deptId: 302, deptName: '土木工程学院' },
        { deptId: 303, deptName: '管理学院' },
        { deptId: 304, deptName: '艺术学院' },
        { deptId: 305, deptName: '语言文化学院' },
        { deptId: 306, deptName: '公共教学部' },
        { deptId: 307, deptName: '马克思主义学院' }
      ]
      this.deptOptions = deptList
    },
    cancel() {
      this.open = false
      this.reset()
    },
    reset() {
      this.form = {
        userId: undefined,
        userName: undefined,
        nickName: undefined,
        deptId: undefined,
        password: undefined
      }
      this.resetForm("form")
    },
    handleQuery() {
      this.queryParams.pageNum = 1
      this.getList()
    },
    resetQuery() {
      this.resetForm("queryForm")
      this.handleQuery()
    },
    handleSelectionChange(selection) {
      this.ids = selection.map(item => item.userId)
      this.single = selection.length != 1
      this.multiple = !selection.length
    },
    handleStatusChange(row) {
      let text = row.status === "0" ? "启用" : "停用"
      this.$modal.confirm('确认要"' + text + '"' + row.userName + '吗？').then(function() {
        return changeTeacherStatus(row.userId, row.status)
      }).then(() => {
        this.$modal.msgSuccess(text + "成功")
      }).catch(function() {
        row.status = row.status === "0" ? "1" : "0"
      })
    },
    handleAdd() {
      this.reset()
      this.open = true
      this.title = "新增教师"
    },
    handleUpdate(row) {
      this.reset()
      const userId = row.userId || this.ids[0]
      getTeacher(userId).then(response => {
        this.form = response.data
        this.open = true
        this.title = "修改教师"
      })
    },
    handleResetPwd(row) {
      this.$prompt('请输入"' + row.userName + '"的新密码', "提示", {
        confirmButtonText: "确定",
        cancelButtonText: "取消",
        closeOnClickModal: false,
        inputPattern: /^.{5,20}$/,
        inputErrorMessage: "密码长度必须介于 5 和 20 之间",
        inputValidator: (value) => {
          if (/<|>|"|'|\||\\/.test(value)) {
            return "不能包含非法字符：< > \" ' \\ |"
          }
        }
      }).then(({ value }) => {
        resetTeacherPwd(row.userId, value).then(response => {
          this.$modal.msgSuccess("密码重置成功，新密码是：" + value)
        })
      }).catch(() => {})
    },
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.userId != undefined) {
            updateTeacher(this.form).then(response => {
              this.$modal.msgSuccess("修改成功")
              this.open = false
              this.getList()
            })
          } else {
            addTeacher(this.form).then(response => {
              this.$modal.msgSuccess("新增成功")
              this.open = false
              this.getList()
            })
          }
        }
      })
    },
    handleDelete(row) {
      const userIds = row.userId || this.ids.join(',')
      this.$modal.confirm('是否确认删除职工号为"' + userIds + '"的教师？').then(function() {
        return delTeacher(userIds)
      }).then(() => {
        this.getList()
        this.$modal.msgSuccess("删除成功")
      }).catch(() => {})
    },
    handleImport() {
      this.upload.title = "教师导入"
      this.upload.open = true
    },
    importTemplate() {
      this.download('textbook/teacher/importTemplate', {}, '教师导入模板.xlsx')
    },
    handleFileUploadProgress(event, file, fileList) {
      this.upload.isUploading = true
    },
    handleFileSuccess(response, file, fileList) {
      this.upload.open = false
      this.upload.isUploading = false
      this.$refs.upload.clearFiles()
      this.$alert("<div style='overflow: auto;overflow-x: hidden;max-height: 70vh;padding: 10px 20px 0;'>" + response.msg + "</div>", "导入结果", { dangerouslyUseHTMLString: true })
      this.getList()
    },
    submitFileForm() {
      this.$refs.upload.submit()
    }
  }
}
</script>
