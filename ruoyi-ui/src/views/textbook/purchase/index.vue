<template>
  <div class="app-container">
    <el-card>
      <div slot="header" class="clearfix">
        <span>教材采购单管理</span>
        <el-button v-hasPermi="['textbook:import:excel']"
                   style="float: right; padding: 3px 0"
                   type="success"
                   icon="el-icon-upload2"
                   size="mini"
                   @click="handleImport">
          Excel导入采购单
        </el-button>
      </div>

      <el-table v-loading="loading" :data="purchaseList" border stripe>
        <el-table-column label="采购单号" prop="purchaseNo" width="180" align="center"/>
        <el-table-column label="申请人" prop="userName" width="100" align="center"/>
        <el-table-column label="部门" prop="deptName" width="120" align="center"/>
        <el-table-column label="状态" prop="auditStatus" width="100" align="center">
          <template slot-scope="scope">
            <el-tag :type="statusTagType(scope.row.auditStatus)">{{ statusText(scope.row.auditStatus) }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column label="提交时间" prop="submitTime" width="160" align="center"/>
        <el-table-column label="操作" align="center" width="200">
          <template slot-scope="scope">
            <el-button size="mini" type="text" icon="el-icon-view" @click="handleView(scope.row)">详情</el-button>
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

    <!-- 导入弹窗 -->
    <el-dialog title="Excel导入采购单" :visible.sync="importDialogVisible" width="720px" append-to-body :close-on-click-modal="false">
      <div class="import-step" v-if="!importResult">
        <el-alert title="请按以下步骤操作" type="info" :closable="false" show-icon style="margin-bottom: 15px;">
          <template slot="default">
            <ol style="margin: 5px 0 0 18px; line-height: 1.8; font-size: 13px;">
              <li>点击下方按钮<strong>下载标准模板</strong></li>
              <li>按照模板格式填写数据（ISBN必须存在于系统中）</li>
              <li>选择文件并上传，系统自动校验</li>
            </ol>
          </template>
        </el-alert>

        <el-upload ref="uploadRef"
                   drag
                   :auto-upload="false"
                   :limit="1"
                   accept=".xlsx,.xls"
                   :on-change="handleFileChange"
                   :on-remove="handleFileRemove"
                   :before-upload="beforeUpload"
                   :file-list="fileList"
                   action=""
                   class="upload-area">
          <i class="el-icon-upload"></i>
          <div class="el-upload__text">将文件拖到此处，或<em>点击上传</em></div>
          <div slot="tip" class="el-upload__tip">
            仅支持 .xlsx/.xls 格式，文件 ≤ 10MB，单次 ≤ 1000 行
          </div>
        </el-upload>

        <div style="text-align: center; margin-top: 20px;">
          <el-button type="primary" icon="el-icon-download" @click="downloadTemplate" plain>下载导入模板</el-button>
          <el-button type="warning" icon="el-icon-upload2" @click="startImport" :disabled="!selectedFile || isUploading" :loading="isUploading">
            {{ isUploading ? '正在导入...' : '开始导入' }}
          </el-button>
        </div>
      </div>

      <!-- 导入结果 -->
      <div v-if="importResult" class="import-result-area">
        <el-result :icon="importResult.failCount === 0 ? 'success' : 'warning'"
                    :title="importResult.msg"
                    :sub-title="'采购单号：' + (importResult.purchaseNo || '-')">
        </el-result>

        <el-row :gutter="20" style="margin-top: 20px;" v-if="importResult.totalRows > 0">
          <el-col :span="6">
            <el-card shadow="hover" class="stat-card stat-total">
              <div class="stat-number">{{ importResult.totalRows }}</div>
              <div class="stat-label">总数据量</div>
            </el-card>
          </el-col>
          <el-col :span="6">
            <el-card shadow="hover" class="stat-card stat-success">
              <div class="stat-number">{{ importResult.successCount }}</div>
              <div class="stat-label">成功导入</div>
            </el-card>
          </el-col>
          <el-col :span="6">
            <el-card shadow="hover" class="stat-card stat-fail">
              <div class="stat-number">{{ importResult.failCount }}</div>
              <div class="stat-label">失败数量</div>
            </el-card>
          </el-col>
          <el-col :span="6">
            <el-card shadow="hover" class="stat-card stat-auto">
              <div class="stat-number">{{ importResult.autoCreatedCount || 0 }}</div>
              <div class="stat-label">自动新增教材</div>
            </el-card>
          </el-col>
        </el-row>

        <div v-if="importResult.autoCreatedList && importResult.autoCreatedList.length > 0" style="margin-top: 15px;">
          <el-divider content-position="left"><i class="el-icon-plus"></i> 自动新增教材（{{ importResult.autoCreatedCount }}本，请到教材管理中补充完善）</el-divider>
          <el-table :data="importResult.autoCreatedList" border stripe max-height="200" size="small">
            <el-table-column label="行号" prop="rowIndex" width="70" align="center">
              <template slot-scope="scope"><el-tag size="mini" type="warning">第{{ scope.row.rowIndex }}行</el-tag></template>
            </el-table-column>
            <el-table-column label="ISBN" prop="isbn" width="140" align="center" />
            <el-table-column label="教材名称" prop="bookName" min-width="200" show-overflow-tooltip />
            <el-table-column label="状态" width="100" align="center">
              <template slot-scope="scope"><el-tag size="mini" type="warning">自动新增</el-tag></template>
            </el-table-column>
          </el-table>
        </div>

        <!-- 失败明细表格 -->
        <div v-if="importResult.errorList && importResult.errorList.length > 0" style="margin-top: 20px;">
          <el-divider content-position="left"><i class="el-icon-warning"></i> 失败明细（共{{ importResult.errorList.length }}条）</el-divider>
          <el-table :data="importResult.errorList" border stripe max-height="300" size="small">
            <el-table-column label="#" type="index" width="50" align="center"/>
            <el-table-column label="行号" prop="rowIndex" width="70" align="center">
              <template slot-scope="scope">
                <el-tag size="mini" type="danger">第{{ scope.row.rowIndex }}行</el-tag>
              </template>
            </el-table-column>
            <el-table-column label="ISBN" prop="isbn" width="130" align="center"/>
            <el-table-column label="教材名称" prop="bookName" min-width="150" show-overflow-tooltip/>
            <el-table-column label="数量" prop="quantity" width="70" align="center"/>
            <el-table-column label="学院" prop="college" width="120" show-overflow-tooltip/>
            <el-table-column label="专业" prop="major" width="120" show-overflow-tooltip/>
            <el-table-column label="失败原因" prop="errorMsg" min-width="220" align="left">
              <template slot-scope="scope">
                <el-tag size="mini" type="danger" effect="plain">{{ scope.row.errorMsg }}</el-tag>
              </template>
            </el-table-column>
          </el-table>
        </div>

        <div style="text-align: center; margin-top: 25px;">
          <el-button type="primary" @click="closeDialogAndRefresh">确定</el-button>
          <el-button v-if="importResult.failCount > 0" @click="resetAndRetry">重新导入</el-button>
        </div>
      </div>

      <div slot="footer" v-if="!importResult">
        <el-button @click="importDialogVisible = false">取消</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { listPurchase, importPurchaseExcel, downloadImportTemplate } from '@/api/textbook/purchase'

export default {
  name: 'TbBuy',
  data() {
    return {
      loading: false,
      total: 0,
      purchaseList: [],
      queryParams: {
        pageNum: 1,
        pageSize: 10
      },
      importDialogVisible: false,
      selectedFile: null,
      fileList: [],
      isUploading: false,
      importResult: null
    }
  },
  created() {
    this.getList()
  },
  methods: {
    getList() {
      this.loading = true
      listPurchase(this.queryParams).then(response => {
        this.purchaseList = response.rows
        this.total = response.total
        this.loading = false
      })
    },

    handleView(row) {
      this.$router.push({ path: '/textbook/purchase', query: { id: row.buyId } })
    },

    statusText(status) {
      const map = { '0': '待审核', '1': '已通过', '2': '已驳回' }
      return map[status] || '未知'
    },
    statusTagType(status) {
      const map = { '0': 'warning', '1': 'success', '2': 'danger' }
      return map[status] || ''
    },

    handleImport() {
      this.importDialogVisible = true
      this.resetImportState()
    },
    resetImportState() {
      this.selectedFile = null
      this.fileList = []
      this.isUploading = false
      this.importResult = null
      if (this.$refs.uploadRef) this.$refs.uploadRef.clearFiles()
    },

    handleFileChange(file, fileList) {
      const isExcel = file.name.endsWith('.xlsx') || file.name.endsWith('.xls')
      const isLt10M = file.size / 1024 / 1024 < 10

      if (!isExcel) {
        this.$message.error('仅支持 .xlsx 或 .xls 格式')
        this.$refs.uploadRef.uploadFiles = []
        return
      }
      if (!isLt10M) {
        this.$message.error('文件大小不能超过 10MB')
        this.$refs.uploadRef.uploadFiles = []
        return
      }

      this.selectedFile = file.raw
      this.fileList = [file]
    },
    handleFileRemove() {
      this.selectedFile = null
      this.fileList = []
    },
    beforeUpload(file) {
      return false
    },

    async downloadTemplate() {
      try {
        const response = await downloadImportTemplate()
        const blob = new Blob([response], { type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' })
        const link = document.createElement('a')
        link.href = window.URL.createObjectURL(blob)
        link.download = '教材采购单导入模板.xlsx'
        link.click()
        window.URL.revokeObjectURL(link.href)
        this.$message.success('模板下载成功')
      } catch (e) {
        console.error(e)
        this.$message.error('模板下载失败')
      }
    },

    async startImport() {
      if (!this.selectedFile) {
        this.$message.warning('请先选择要导入的Excel文件')
        return
      }

      this.isUploading = true
      try {
        const res = await importPurchaseExcel(this.selectedFile)

        if (res.code === 200) {
          const data = res.data
          this.importResult = {
            msg: data.msg,
            purchaseNo: data.purchaseNo,
            purchaseId: data.purchaseId,
            totalRows: data.totalRows || (data.successCount + data.failCount),
            successCount: data.successCount || 0,
            failCount: data.failCount || 0,
            autoCreatedCount: data.autoCreatedCount || 0,
            autoCreatedList: data.autoCreatedList || [],
            errorList: data.errorList || []
          }

          if (this.importResult.failCount === 0 && this.importResult.successCount > 0) {
            const autoMsg = this.importResult.autoCreatedCount > 0 ? `，自动新增${this.importResult.autoCreatedCount}本教材` : ''
            this.$message.success(`导入成功！共 ${this.importResult.successCount} 条${autoMsg}，请到教材信息管理中补充完善。`)
          } else if (this.importResult.failCount > 0) {
            this.$message.warning(`⚠️ 部分数据导入失败，请查看错误明细`)
          }
        } else {
          this.$message.error(res.msg || '导入失败')
        }
      } catch (err) {
        console.error('Import error:', err)
        this.$message.error(err.message || '导入异常，请重试')
      } finally {
        this.isUploading = false
      }
    },

    closeDialogAndRefresh() {
      this.importDialogVisible = false
      this.getList()
    },
    resetAndRetry() {
      this.importResult = null
      this.selectedFile = null
      this.fileList = []
      if (this.$refs.uploadRef) this.$refs.uploadRef.clearFiles()
    }
  }
}
</script>

<style scoped>
.upload-area { text-align: center; margin: 15px 0; }
.upload-area .el-upload-dragger { width: 100%; }

.stat-card { text-align: center; padding: 12px 0; }
.stat-card .stat-number { font-size: 32px; font-weight: bold; color: #303133; }
.stat-card .stat-label { font-size: 13px; color: #909399; margin-top: 6px; }
.stat-success .stat-number { color: #67c23a; }
.stat-fail .stat-number { color: #f56c6c; }
.stat-total .stat-number { color: #409eff; }
.stat-auto .stat-number { color: #e6a23c; }

.import-result-area { max-height: 70vh; overflow-y: auto; }
</style>
