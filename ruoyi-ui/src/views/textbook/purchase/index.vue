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
        <el-table-column label="操作" align="center" class-name="small-padding fixed-width" width="380">
          <template slot-scope="scope">
            <el-button size="mini" type="text" icon="el-icon-view" @click="handleView(scope.row)">详情</el-button>
            <el-button size="mini" type="text" icon="el-icon-check" style="color:#67C23A" @click="handleAudit(scope.row)" v-if="scope.row.auditStatus === '0'" v-hasRole="['admin','warehouse']">通过</el-button>
            <el-button size="mini" type="text" icon="el-icon-close" style="color:#F56C6C" @click="handleReject(scope.row)" v-if="scope.row.auditStatus === '0'" v-hasRole="['admin','warehouse']">驳回</el-button>
            <el-button size="mini" type="text" icon="el-icon-s-claim" style="color:#E6A23A" @click="handleConfirmOrder(scope.row)" v-if="scope.row.purchaseStatus === '0'" v-hasRole="['admin','warehouse']">确认下单</el-button>
            <el-button size="mini" type="text" icon="el-icon-truck" style="color:#409EFF" @click="handleConfirmArrived(scope.row)" v-if="scope.row.purchaseStatus === '3'" v-hasRole="['admin','warehouse']">确认到货</el-button>
            <el-button size="mini" type="text" icon="el-icon-s-data" style="color:#67C23A" @click="handleConfirmInbound(scope.row)" v-if="scope.row.purchaseStatus === '4'" v-hasRole="['admin','warehouse']">确认入库</el-button>
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

    <el-dialog title="Excel导入采购单" :visible.sync="importDialogVisible" width="800px" append-to-body :close-on-click-modal="false">
      <el-steps :active="importStep" align-center style="margin-bottom: 20px;">
        <el-step title="下载模板" description="下载标准导入模板"></el-step>
        <el-step title="上传文件" description="选择填好的Excel文件"></el-step>
        <el-step title="预览数据" description="校验并预览导入数据"></el-step>
        <el-step title="确认导入" description="确认数据并执行导入"></el-step>
      </el-steps>

      <div v-if="importStep === 0" style="text-align: center; padding: 30px 0;">
        <i class="el-icon-download" style="font-size: 48px; color: #409EFF;"></i>
        <p style="margin: 15px 0; color: #606266;">请先下载标准导入模板，按模板格式填写采购数据</p>
        <el-button type="primary" icon="el-icon-download" @click="downloadTemplate" plain>下载导入模板</el-button>
        <div style="margin-top: 20px;">
          <el-button type="primary" @click="importStep = 1">下一步 <i class="el-icon-arrow-right"></i></el-button>
        </div>
      </div>

      <div v-if="importStep === 1 && !previewData">
        <el-upload ref="uploadRef"
                   drag
                   :auto-upload="false"
                   :limit="1"
                   accept=".xlsx"
                   :on-change="handleFileChange"
                   :on-remove="handleFileRemove"
                   :file-list="fileList"
                   action=""
                   class="upload-area">
          <i class="el-icon-upload"></i>
          <div class="el-upload__text">将文件拖到此处，或<em>点击上传</em></div>
          <div slot="tip" class="el-upload__tip">
            仅支持 .xlsx 格式，文件 ≤ 10MB，单次 ≤ 1000 行
          </div>
        </el-upload>
        <div style="text-align: center; margin-top: 20px;">
          <el-button @click="importStep = 0"><i class="el-icon-arrow-left"></i> 上一步</el-button>
          <el-button type="primary" @click="doPreview" :disabled="!selectedFile" :loading="isPreviewing">
            {{ isPreviewing ? '正在校验...' : '上传并预览' }} <i class="el-icon-view"></i>
          </el-button>
        </div>
      </div>

      <div v-if="importStep === 2 && previewData" style="max-height: 55vh; overflow-y: auto;">
        <el-alert :title="'文件：' + (previewData.fileName || '未知') + '，共 ' + previewData.totalRows + ' 行数据'"
                  :type="previewData.failCount > 0 ? 'warning' : 'success'"
                  :closable="false" show-icon style="margin-bottom: 15px;">
          <template slot="default">
            <span>校验通过 <strong style="color:#67c23a">{{ previewData.successCount }}</strong> 行，
            校验失败 <strong style="color:#f56c6c">{{ previewData.failCount }}</strong> 行</span>
            <span v-if="previewData.failCount > 0" style="margin-left:10px; color:#e6a23c;">失败行将被跳过，仅导入校验通过的数据</span>
          </template>
        </el-alert>

        <el-row :gutter="16" style="margin-bottom: 15px;">
          <el-col :span="8">
            <el-card shadow="hover" class="stat-card stat-total" body-style="padding:10px;">
              <div class="stat-number">{{ previewData.totalRows }}</div>
              <div class="stat-label">总数据量</div>
            </el-card>
          </el-col>
          <el-col :span="8">
            <el-card shadow="hover" class="stat-card stat-success" body-style="padding:10px;">
              <div class="stat-number">{{ previewData.successCount }}</div>
              <div class="stat-label">校验通过</div>
            </el-card>
          </el-col>
          <el-col :span="8">
            <el-card shadow="hover" class="stat-card stat-fail" body-style="padding:10px;">
              <div class="stat-number">{{ previewData.failCount }}</div>
              <div class="stat-label">校验失败</div>
            </el-card>
          </el-col>
        </el-row>

        <el-tabs v-model="previewActiveTab">
          <el-tab-pane label="校验通过数据" name="success">
            <span slot="label"><i class="el-icon-check" style="color:#67c23a"></i> 校验通过 ({{ previewData.successCount }})</span>
            <el-table :data="previewData.successList" border stripe max-height="300" size="small">
              <el-table-column label="行号" prop="rowIndex" width="70" align="center">
                <template slot-scope="scope"><el-tag size="mini">第{{ scope.row.rowIndex }}行</el-tag></template>
              </el-table-column>
              <el-table-column label="ISBN" prop="isbn" width="140" align="center"/>
              <el-table-column label="教材名称" prop="bookName" min-width="180" show-overflow-tooltip/>
              <el-table-column label="数量" prop="quantity" width="80" align="center"/>
              <el-table-column label="学院" prop="college" width="120" show-overflow-tooltip/>
              <el-table-column label="专业" prop="major" width="120" show-overflow-tooltip/>
              <el-table-column label="年级" prop="grade" width="120" show-overflow-tooltip/>
              <el-table-column label="备注" prop="remark" min-width="120" show-overflow-tooltip/>
            </el-table>
          </el-tab-pane>
          <el-tab-pane label="校验失败数据" name="fail" v-if="previewData.failCount > 0">
            <span slot="label"><i class="el-icon-close" style="color:#f56c6c"></i> 校验失败 ({{ previewData.failCount }})</span>
            <el-table :data="previewData.failList" border stripe max-height="300" size="small">
              <el-table-column label="行号" prop="rowIndex" width="70" align="center">
                <template slot-scope="scope"><el-tag size="mini" type="danger">第{{ scope.row.rowIndex }}行</el-tag></template>
              </el-table-column>
              <el-table-column label="ISBN" prop="isbn" width="130" align="center"/>
              <el-table-column label="教材名称" prop="bookName" min-width="150" show-overflow-tooltip/>
              <el-table-column label="数量" prop="quantity" width="70" align="center"/>
              <el-table-column label="学院" prop="college" width="100" show-overflow-tooltip/>
              <el-table-column label="专业" prop="major" width="100" show-overflow-tooltip/>
              <el-table-column label="失败原因" prop="errorMsg" min-width="220" align="left">
                <template slot-scope="scope">
                  <el-tag size="mini" type="danger" effect="plain">{{ scope.row.errorMsg }}</el-tag>
                </template>
              </el-table-column>
            </el-table>
          </el-tab-pane>
        </el-tabs>

        <div style="text-align: center; margin-top: 20px;">
          <el-button @click="backToUpload"><i class="el-icon-arrow-left"></i> 重新选择文件</el-button>
          <el-button type="primary" @click="importStep = 3" :disabled="previewData.successCount === 0">
            确认导入 <i class="el-icon-arrow-right"></i>
          </el-button>
        </div>
      </div>

      <div v-if="importStep === 3 && previewData && !importResult" style="text-align: center; padding: 20px 0;">
        <el-alert title="请确认导入信息" type="warning" :closable="false" show-icon style="margin-bottom: 15px;">
          <template slot="default">
            <p>已选择文件：<strong>{{ previewData.fileName || '未知' }}</strong></p>
            <p>校验通过 <strong style="color:#67c23a">{{ previewData.successCount }}</strong> 行，
            失败 <strong style="color:#f56c6c">{{ previewData.failCount }}</strong> 行（失败行将被跳过）</p>
            <p style="color:#e6a23c;">点击"开始导入"按钮执行导入操作，此操作不可撤销</p>
          </template>
        </el-alert>
        <div style="margin-top: 20px;">
          <el-button @click="importStep = 2"><i class="el-icon-arrow-left"></i> 返回预览</el-button>
          <el-button type="danger" icon="el-icon-upload2" @click="doConfirmImport" :disabled="isUploading" :loading="isUploading">
            {{ isUploading ? '正在导入...' : '开始导入' }}
          </el-button>
        </div>
      </div>

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

    <!-- 确认下单对话框 -->
    <el-dialog title="确认下单通知供应商" :visible.sync="dispatchOpen" width="420px" append-to-body :close-on-click-modal="false">
      <div style="text-align: center; padding: 10px 0;">
        <p>采购单号：<strong>{{ dispatchData.purchaseNo }}</strong></p>
      </div>
      <el-form label-width="80px">
        <el-form-item label="选择供应商" required>
          <el-select v-model="dispatchSupplierId" placeholder="请选择供应商" style="width: 100%" filterable>
            <el-option v-for="s in supplierOptions" :key="s.supplierId" :label="s.supplierName" :value="s.supplierId" />
          </el-select>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="dispatchOpen = false">取 消</el-button>
        <el-button type="warning" @click="confirmOrder" :disabled="!dispatchSupplierId">确认下单并通知供应商</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { listPurchase, auditPurchase, confirmOrder, confirmArrived, confirmInbound, previewPurchaseExcel, confirmPurchaseImport, downloadImportTemplate } from '@/api/textbook/purchase'
import { listSupplierOptions } from '@/api/textbook/supplier'

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
      importStep: 0,
      selectedFile: null,
      fileList: [],
      isPreviewing: false,
      isUploading: false,
      previewData: null,
      previewActiveTab: 'success',
      importResult: null,
      dispatchOpen: false,
      dispatchData: {},
      dispatchSupplierId: null,
      supplierOptions: []
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
      }).catch(() => {
        this.loading = false
      })
    },

    handleView(row) {
      this.$router.push({ path: '/warehouse/purchase/detail', query: { id: row.buyId } })
    },
    handleAudit(row) {
      this.$modal.confirm('确认审核通过采购单 ' + row.purchaseNo + ' ？').then(() => {
        return auditPurchase({ buyId: row.buyId, status: '1' })
      }).then(() => {
        this.$modal.msgSuccess('审核通过')
        this.getList()
      }).catch(() => {})
    },
    handleReject(row) {
      this.$prompt('请输入驳回原因', '驳回采购单', {
        confirmButtonText: '确定驳回',
        cancelButtonText: '取消',
        inputPlaceholder: '请输入驳回原因（可选）'
      }).then(({ value }) => {
        return auditPurchase({ buyId: row.buyId, status: '2', rejectReason: value || '' })
      }).then(() => {
        this.$modal.msgSuccess('已驳回')
        this.getList()
      }).catch(() => {})
    },

    handleConfirmOrder(row) {
      this.dispatchData = row
      this.dispatchSupplierId = null
      this.loadSupplierOptions()
      this.dispatchOpen = true
    },
    loadSupplierOptions() {
      listSupplierOptions().then(res => {
        this.supplierOptions = res.data || []
      }).catch(() => {})
    },
    confirmOrder() {
      const s = this.supplierOptions.find(item => item.supplierId === this.dispatchSupplierId)
      const supplierName = s ? s.supplierName : '未知'
      confirmOrder(this.dispatchData.buyId, this.dispatchSupplierId).then(() => {
        this.$modal.msgSuccess('已通知供应商【' + supplierName + '】，采购单进入采购中状态')
        this.dispatchOpen = false
        this.getList()
      }).catch(() => {})
    },
    handleConfirmArrived(row) {
      this.$modal.confirm('确认采购单 ' + row.purchaseNo + ' 已到货？').then(() => {
        return confirmArrived(row.buyId)
      }).then(() => {
        this.$modal.msgSuccess('已确认到货')
        this.getList()
      }).catch(() => {})
    },
    handleConfirmInbound(row) {
      this.$modal.confirm('确认将采购单 ' + row.purchaseNo + ' 的教材验收入库？入库后将增加库存。').then(() => {
        return confirmInbound(row.buyId)
      }).then(() => {
        this.$modal.msgSuccess('已验收入库，库存已更新')
        this.getList()
      }).catch(() => {})
    },

    statusText(status) {
      const map = { '0': '待审核', '1': '已通过', '2': '已驳回', '3': '已领书', '4': '已到货', '5': '已入库', '6': '已发货' }
      return map[status] || '未知'
    },
    statusTagType(status) {
      const map = { '0': 'warning', '1': 'success', '2': 'danger', '3': '', '4': 'info', '5': 'success', '6': '' }
      return map[status] || ''
    },

    handleImport() {
      this.importDialogVisible = true
      this.importStep = 0
      this.resetImportState()
    },
    resetImportState() {
      this.selectedFile = null
      this.fileList = []
      this.isPreviewing = false
      this.isUploading = false
      this.previewData = null
      this.previewActiveTab = 'success'
      this.importResult = null
      if (this.$refs.uploadRef) this.$refs.uploadRef.clearFiles()
    },

    handleFileChange(file, fileList) {
      const isExcel = file.name.endsWith('.xlsx') || file.name.endsWith('.xls')
      const isLt10M = file.size / 1024 / 1024 < 10

      if (!isExcel) {
        this.$modal.msgError('仅支持 .xlsx 或 .xls 格式')
        this.$refs.uploadRef.uploadFiles = []
        return
      }
      if (!isLt10M) {
        this.$modal.msgError('文件大小不能超过 10MB')
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

    async downloadTemplate() {
      try {
        const response = await downloadImportTemplate()
        const blob = new Blob([response], { type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' })
        const link = document.createElement('a')
        link.href = window.URL.createObjectURL(blob)
        link.download = '教材采购单导入模板.xlsx'
        link.click()
        window.URL.revokeObjectURL(link.href)
        this.$modal.msgSuccess('模板下载成功')
      } catch (e) {
        console.error(e)
        this.$modal.msgError('模板下载失败')
      }
    },

    async doPreview() {
      if (!this.selectedFile) {
        this.$modal.msgWarning('请先选择要导入的Excel文件')
        return
      }

      this.isPreviewing = true
      try {
        const res = await previewPurchaseExcel(this.selectedFile)
        if (res.code === 200) {
          this.previewData = res.data
          this.previewActiveTab = this.previewData.failCount > 0 ? 'fail' : 'success'
          this.importStep = 2

          if (this.previewData.successCount === 0) {
            this.$modal.msgWarning('所有数据校验均未通过，请修正后重新上传')
          } else if (this.previewData.failCount > 0) {
            this.$modal.msgWarning(`校验完成：${this.previewData.successCount}条通过，${this.previewData.failCount}条失败`)
          } else {
            this.$modal.msgSuccess(`校验全部通过，共${this.previewData.successCount}条数据`)
          }
        } else {
          this.$modal.msgError(res.msg || '预览校验失败')
        }
      } catch (err) {
        console.error('Preview error:', err)
        this.$modal.msgError(err.message || '预览校验异常，请重试')
      } finally {
        this.isPreviewing = false
      }
    },

    backToUpload() {
      this.previewData = null
      this.selectedFile = null
      this.fileList = []
      if (this.$refs.uploadRef) this.$refs.uploadRef.clearFiles()
      this.importStep = 1
    },

    async doConfirmImport() {
      if (!this.previewData || !this.previewData.previewToken) {
        this.$modal.msgError('预览数据异常，请重新上传文件')
        this.backToUpload()
        return
      }

      this.isUploading = true
      try {
        const res = await confirmPurchaseImport(this.previewData.previewToken)
        if (res.code === 200) {
          const data = res.data
          this.importResult = {
            msg: data.purchaseNo ? '导入成功' : '导入完成',
            purchaseNo: data.purchaseNo || '-',
            purchaseId: data.purchaseId,
            totalRows: data.totalRows || (data.successCount + data.failCount),
            successCount: data.successCount || 0,
            failCount: data.failCount || 0,
            autoCreatedCount: data.autoCreatedCount || 0,
            autoCreatedList: data.autoCreatedList || [],
            errorList: data.failList || []
          }

          if (this.importResult.failCount === 0 && this.importResult.successCount > 0) {
            const autoMsg = this.importResult.autoCreatedCount > 0 ? `，自动新增${this.importResult.autoCreatedCount}本教材` : ''
            this.$modal.msgSuccess(`导入成功！共 ${this.importResult.successCount} 条${autoMsg}，请到教材信息管理中补充完善。`)
          } else if (this.importResult.failCount > 0) {
            this.$modal.msgWarning(`部分数据导入失败，请查看错误明细`)
          }
        } else {
          this.$modal.msgError(res.msg || '导入失败')
        }
      } catch (err) {
        console.error('Confirm import error:', err)
        this.$modal.msgError(err.message || '导入异常，请重试')
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
      this.previewData = null
      this.selectedFile = null
      this.fileList = []
      this.importStep = 1
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
