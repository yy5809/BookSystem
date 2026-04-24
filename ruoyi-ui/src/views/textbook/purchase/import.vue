<template>
  <div class="app-container">
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>Excel导入采购单</span>
        <el-button style="float: right; padding: 3px 0" type="text" @click="downloadTemplate">
          下载导入模板
        </el-button>
      </div>

      <el-form ref="form" :model="form" label-width="100px">
        <el-form-item label="选择Excel文件">
          <el-upload
            ref="upload"
            :limit="1"
            accept=".xlsx,.xls"
            :headers="headers"
            :action="importUrl"
            :disabled="isUploading"
            :on-progress="handleFileProgress"
            :on-success="handleFileSuccess"
            :on-error="handleFileError"
            :on-change="handleFileChange"
            :before-upload="beforeUpload"
            :auto-upload="false"
            drag
          >
            <i class="el-icon-upload"></i>
            <div class="el-upload__text">将文件拖到此处，或<em>点击上传</em></div>
            <div class="el-upload__tip" slot="tip">
              支持 .xlsx、.xls 格式，且不超过10MB
            </div>
          </el-upload>
        </el-form-item>

        <el-form-item>
          <el-button type="primary" @click="submitUpload" :loading="isUploading">
            {{ isUploading ? '正在导入...' : '开始导入' }}
          </el-button>
          <el-button @click="resetForm">重置</el-button>
          <el-button type="info" @click="downloadTemplate">
            下载模板
          </el-button>
        </el-form-item>
      </el-form>

      <!-- 导入结果展示 -->
      <div v-if="importResult" class="import-result">
        <el-divider content-position="left">导入结果</el-divider>
        <el-alert
          :title="importResult.msg"
          :type="importResult.failCount > 0 ? 'warning' : 'success'"
          :closable="false"
          show-icon
          style="margin-bottom: 20px;"
        >
        </el-alert>

        <el-descriptions :column="2" border v-if="importResult.purchaseNo">
          <el-descriptions-item label="采购单号">{{ importResult.purchaseNo }}</el-descriptions-item>
          <el-descriptions-item label="成功数量">{{ importResult.successCount }} 条</el-descriptions-item>
          <el-descriptions-item label="失败数量">{{ importResult.failCount }} 条</el-descriptions-item>
          <el-descriptions-item label="导入时间">{{ currentTime }}</el-descriptions-item>
        </el-descriptions>

        <!-- 错误信息列表 -->
        <div v-if="importResult.errors && importResult.errors.length > 0" style="margin-top: 20px;">
          <el-alert
            title="错误详情"
            type="error"
            :closable="false"
            show-icon
          >
          </el-alert>
          <el-table
            :data="errorTableData"
            border
            stripe
            style="width: 100%; margin-top: 10px;"
            max-height="300"
          >
            <el-table-column prop="index" label="行号" width="80" align="center"></el-table-column>
            <el-table-column prop="message" label="错误信息"></el-table-column>
          </el-table>
        </div>
      </div>

      <!-- 使用说明 -->
      <el-collapse style="margin-top: 30px;">
        <el-collapse-item title="使用说明" name="1">
          <div class="usage-tips">
            <h4>操作步骤：</h4>
            <ol>
              <li>点击"下载导入模板"按钮，获取标准Excel模板</li>
              <li>按照模板格式填写采购信息（教材名称为必填项）</li>
              <li>选择填写好的Excel文件并上传</li>
              <li>点击"开始导入"按钮完成导入</li>
              <li>查看导入结果，确认成功或修正错误后重新导入</li>
            </ol>

            <h4>字段说明：</h4>
            <ul>
              <li><strong>教材名称</strong>（必填）：要采购的教材名称</li>
              <li><strong>ISBN编号</strong>（选填）：教材的ISBN码，系统会自动匹配已有教材</li>
              <li><strong>作者</strong>（选填）：教材作者</li>
              <li><strong>出版社</strong>（选填）：教材出版社</li>
              <li><strong>采购数量</strong>（必填）：需要采购的数量，必须大于0</li>
              <li><strong>单价</strong>（选填）：采购单价，如不填则使用系统中教材定价</li>
              <li><strong>供应商</strong>（选填）：供应商名称</li>
              <li><strong>经费来源</strong>（选填）：经费来源说明</li>
              <li><strong>备注</strong>（选填）：其他备注信息</li>
            </ul>

            <h4>注意事项：</h4>
            <ul>
              <li>支持 .xlsx、.xls 格式的Excel文件</li>
              <li>文件大小不超过 10MB</li>
              <li>单次最多可导入 500 条数据</li>
              <li>如果ISBN匹配到系统中的教材，会自动关联教材ID和定价</li>
              <li>导入后会自动生成一个采购单，包含所有明细</li>
            </ul>
          </div>
        </el-collapse-item>
      </el-collapse>
    </el-card>
  </div>
</template>

<script>
import { importPurchaseExcel, downloadImportTemplate } from '@/api/textbook/purchase'
import { getToken } from '@/utils/auth'

export default {
  name: 'PurchaseImport',
  data() {
    return {
      headers: { Authorization: 'Bearer ' + getToken() },
      importUrl: process.env.VUE_APP_BASE_API + '/textbook/buy/import',
      isUploading: false,
      form: {},
      importResult: null,
      errorTableData: [],
      currentTime: ''
    }
  },
  methods: {
    beforeUpload(file) {
      const isXlsx = file.type === 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
      const isXls = file.type === 'application/vnd.ms-excel'
      const isExcel = isXlsx || isXls || file.name.endsWith('.xlsx') || file.name.endsWith('.xls')
      const isLt10M = file.size / 1024 / 1024 < 10

      if (!isExcel) {
        this.$message.error('只能上传 Excel 文件（支持 .xlsx、.xls 格式）!')
        return false
      }
      if (!isLt10M) {
        this.$message.error('上传文件大小不能超过 10MB!')
        return false
      }
      return true
    },

    handleFileChange(file, fileList) {
      if (fileList.length > 0) {
        this.$refs.upload.uploadFiles = [fileList[fileList.length - 1]]
      }
    },

    handleFileProgress(event, file, fileList) {
      this.isUploading = true
    },

    async submitUpload() {
      if (this.$refs.upload.uploadFiles.length === 0) {
        this.$message.warning('请先选择要导入的Excel文件')
        return
      }

      const fileName = this.$refs.upload.uploadFiles[0].name
      try {
        await this.$confirm(`确认导入文件"${fileName}"中的采购数据？导入后将生成采购单，请确保数据正确。`, '确认导入', {
          confirmButtonText: '确认导入',
          cancelButtonText: '取消',
          type: 'warning'
        })
      } catch {
        return
      }

      this.isUploading = true
      this.importResult = null

      try {
        const file = this.$refs.upload.uploadFiles[0].raw
        const response = await importPurchaseExcel(file)

        if (response.code === 200) {
          const data = response.data
          this.importResult = {
            msg: data.msg,
            purchaseNo: data.purchaseNo,
            purchaseId: data.purchaseId,
            successCount: data.successCount,
            failCount: data.failCount,
            errors: data.errors || []
          }

          this.currentTime = new Date().toLocaleString()

          if (data.errors && data.errors.length > 0) {
            this.errorTableData = data.errors.map((error, index) => ({
              index: index + 1,
              message: error
            }))
          }

          if (data.failCount === 0 && data.successCount > 0) {
            this.$message.success(`导入成功！共导入 ${data.successCount} 条采购记录`)
          } else if (data.failCount > 0) {
            this.$message.warning(`部分数据导入失败，请检查错误详情`)
          }

          this.$refs.upload.clearFiles()
        } else {
          this.$message.error(response.msg || '导入失败')
        }
      } catch (error) {
        console.error('Import error:', error)
        this.$message.error('导入失败：' + (error.message || '未知错误'))
      } finally {
        this.isUploading = false
      }
    },

    handleFileSuccess(response, file, fileList) {
      this.isUploading = false
    },

    handleFileError(error, file, fileList) {
      this.isUploading = false
      this.$message.error('上传失败，请重试')
    },

    resetForm() {
      this.$refs.upload.clearFiles()
      this.importResult = null
      this.errorTableData = []
    },

    async downloadTemplate() {
      try {
        const response = await downloadImportTemplate()
        const blob = new Blob([response], {
          type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
        })
        const link = document.createElement('a')
        link.href = window.URL.createObjectURL(blob)
        link.download = '采购单导入模板.xlsx'
        link.click()
        window.URL.revokeObjectURL(link.href)
        this.$message.success('模板下载成功')
      } catch (error) {
        console.error('Download template error:', error)
        this.$message.error('模板下载失败')
      }
    }
  }
}
</script>

<style scoped>
.box-card {
  max-width: 1200px;
  margin: 20px auto;
}

.import-result {
  margin-top: 30px;
  padding: 20px;
  background-color: #f5f7fa;
  border-radius: 4px;
}

.usage-tips h4 {
  margin: 15px 0 10px 0;
  color: #303133;
  font-size: 14px;
}

.usage-tips ol, .usage-tips ul {
  margin-left: 20px;
  line-height: 1.8;
}

.usage-tips li {
  margin: 5px 0;
  color: #606266;
  font-size: 13px;
}

.el-upload__tip {
  color: #909399;
  font-size: 12px;
}
</style>
