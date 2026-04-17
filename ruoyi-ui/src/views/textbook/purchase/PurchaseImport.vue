<template>
  <div class="import-container">
    <el-upload
      class="upload-demo"
      drag
      :action="importUrl"
      :headers="headers"
      :before-upload="beforeUpload"
      :on-success="handleSuccess"
      :on-error="handleError"
      :show-file-list="false"
      accept=".xlsx,.xls"
      :limit="1">
      <i class="el-icon-upload"></i>
      <div class="el-upload__text">将Excel文件拖到此处，或<em>点击上传</em></div>
      <div class="el-upload__tip" slot="tip">
        只能上传 .xlsx/.xls 文件，且不超过 10MB / 1000行
        <el-button type="text" icon="el-icon-download" @click.stop="downloadTemplate" style="margin-left: 10px;">下载导入模板</el-button>
      </div>
    </el-upload>

    <div v-if="importResult" class="import-result" style="margin-top: 20px;">
      <el-alert :title="'导入完成：共 ' + importResult.totalRows + ' 行'" :type="importResult.failCount > 0 ? 'warning' : 'success'" :closable="false" show-icon style="margin-bottom: 15px;">
        <template slot="default">
          <span>成功：<strong>{{ importResult.successCount }}</strong> 条 | 失败：<strong>{{ importResult.failCount }}</strong> 条</span>
          <span v-if="importResult.message && importResult.message.startsWith('CG')"> | 采购单号：<strong>{{ importResult.message }}</strong></span>
        </template>
      </el-alert>

      <el-table v-if="importResult.failList && importResult.failList.length > 0" :data="importResult.failList" size="small" border max-height="300">
        <el-table-column label="行号" prop="rowIndex" width="70" align="center" />
        <el-table-column label="ISBN" prop="isbn" width="140" />
        <el-table-column label="教材名称" prop="bookName" show-overflow-tooltip />
        <el-table-column label="数量" prop="quantity" width="70" align="center" />
        <el-table-column label="错误原因" prop="errorMsg" min-width="200">
          <template slot-scope="scope">
            <el-tag type="danger" size="mini">{{ scope.row.errorMsg }}</el-tag>
          </template>
        </el-table-column>
      </el-table>
    </div>
  </div>
</template>

<script>
import { getToken } from "@/utils/auth"

export default {
  name: "PurchaseImport",
  data() {
    return {
      importUrl: process.env.VUE_APP_BASE_API + "/textbook/purchase/import/excel",
      headers: { Authorization: "Bearer " + getToken() },
      importResult: null
    }
  },
  methods: {
    beforeUpload(file) {
      const isExcel = file.name.endsWith('.xlsx') || file.name.endsWith('.xls')
      if (!isExcel) {
        this.$modal.msgError('只能上传 .xlsx 或 .xls 格式的文件!')
        return false
      }
      const isLt10M = file.size / 1024 / 1024 < 10
      if (!isLt10M) {
        this.$modal.msgError('文件大小不能超过 10MB!')
        return false
      }
      this.importResult = null
      return true
    },
    handleSuccess(response) {
      if (response.code === 200) {
        this.importResult = response.data
        if (this.importResult.failCount === 0) {
          this.$modal.msgSuccess(`导入成功！已生成采购单 ${this.importResult.message}`)
          this.$emit('success', response.data)
        } else {
          this.$modal.msgWarning(`部分数据导入失败，请查看下方失败列表`)
        }
      } else {
        this.$modal.msgError(response.msg || '导入失败')
      }
    },
    handleError() {
      this.$modal.msgError('文件上传失败，请检查网络连接或联系管理员')
    },
    downloadTemplate() {
      const token = getToken()
      window.open(process.env.VUE_APP_BASE_API + '/textbook/purchase/import/template?token=' + token)
    }
  }
}
</script>

<style scoped>
.import-container { padding: 20px; }
.upload-demo { text-align: center; padding: 40px 0; }
</style>
