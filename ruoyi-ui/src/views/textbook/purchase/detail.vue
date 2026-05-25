<template>
  <div class="app-container">
    <el-card>
      <template slot="header">
        <span>采购单详情</span>
        <el-button type="primary" size="small" style="margin-left: 20px" @click="goBack">返回列表</el-button>
        <el-button type="danger" size="small" icon="el-icon-delete" style="float: right" @click="handleDelete" v-hasPermi="['textbook:purchase:remove']" :disabled="!canDelete">删除采购单</el-button>
      </template>

      <el-form :model="purchaseInfo" label-width="100px" size="small">
        <el-row :gutter="20">
          <el-col :span="8"><el-form-item label="采购单号"><el-input :value="purchaseInfo.purchaseNo" disabled /></el-form-item></el-col>
          <el-col :span="8"><el-form-item label="申请人"><el-input :value="purchaseInfo.userName" disabled /></el-form-item></el-col>
          <el-col :span="8"><el-form-item label="部门"><el-input :value="purchaseInfo.deptName" disabled /></el-form-item></el-col>
        </el-row>
        <el-row :gutter="20">
          <el-col :span="8"><el-form-item label="审核状态">
            <el-tag :type="auditStatusTag(purchaseInfo.auditStatus)">{{ auditStatusText(purchaseInfo.auditStatus) }}</el-tag>
          </el-form-item></el-col>
          <el-col :span="8"><el-form-item label="采购状态">
            <el-tag :type="purchaseStatusTag(purchaseInfo.purchaseStatus)">{{ purchaseStatusText(purchaseInfo.purchaseStatus) }}</el-tag>
          </el-form-item></el-col>
          <el-col :span="8"><el-form-item label="经费来源"><el-input :value="purchaseInfo.fundingSource" disabled /></el-form-item></el-col>
        </el-row>
        <el-row :gutter="20" v-if="purchaseInfo.logisticsCompany || purchaseInfo.logisticsNo || purchaseInfo.invoiceNo">
          <el-col :span="8"><el-form-item label="物流公司"><el-input :value="purchaseInfo.logisticsCompany || '-'" disabled /></el-form-item></el-col>
          <el-col :span="8"><el-form-item label="快递单号"><el-input :value="purchaseInfo.logisticsNo || '-'" disabled /></el-form-item></el-col>
          <el-col :span="8"><el-form-item label="发票号"><el-input :value="purchaseInfo.invoiceNo || '-'" disabled /></el-form-item></el-col>
        </el-row>
        <el-row :gutter="20" v-if="purchaseInfo.rejectReason">
          <el-col :span="24"><el-form-item label="驳回原因"><el-input type="textarea" :value="purchaseInfo.rejectReason" disabled /></el-form-item></el-col>
        </el-row>
      </el-form>

      <el-card class="detail-card">
        <template slot="header"><span>采购明细</span></template>
        <el-table :data="purchaseDetails" border stripe style="width: 100%">
          <el-table-column label="ISBN" prop="isbn" width="135" align="center" />
          <el-table-column label="教材名称" prop="bookName" min-width="150" show-overflow-tooltip />
          <el-table-column label="版次" prop="edition" width="70" align="center" />
          <el-table-column label="作者" prop="author" width="70" show-overflow-tooltip />
          <el-table-column label="出版社" align="center" prop="publisher" width="90" show-overflow-tooltip />
          <el-table-column label="教材类型" width="90" align="center">
            <template slot-scope="scope">
              <dict-tag :options="dict.type.textbook_type" :value="scope.row.textbookType" />
            </template>
          </el-table-column>
          <el-table-column label="学院" prop="college" width="80" show-overflow-tooltip />
          <el-table-column label="专业" align="center" prop="major" width="80" show-overflow-tooltip />
          <el-table-column label="适用年级" prop="grade" width="80" align="center" />
          <el-table-column label="数量" prop="quantity" width="55" align="center" />
          <el-table-column label="单价" prop="unitPrice" width="70" align="center"><template slot-scope="scope">{{ scope.row.unitPrice || '-' }}</template></el-table-column>
          <el-table-column label="总价" prop="totalPrice" width="70" align="center"><template slot-scope="scope">{{ scope.row.totalPrice || '-' }}</template></el-table-column>
          <el-table-column label="供应商反馈" width="130" align="center">
            <template slot-scope="scope">
              <el-tag v-if="scope.row.supplierFeedback === '1'" type="success" size="mini">可供货</el-tag>
              <el-tag v-else-if="scope.row.supplierFeedback === '2'" type="danger" size="mini">缺货</el-tag>
              <el-tag v-else-if="scope.row.supplierFeedback === '3'" type="warning" size="mini">信息有误</el-tag>
              <span v-else style="color:#c0c4cc">-</span>
            </template>
          </el-table-column>
          <el-table-column label="核准状态" width="100" align="center">
            <template slot-scope="scope">
              <el-tag v-if="scope.row.verifyStatus === '0'" type="info" size="mini">待核准</el-tag>
              <el-tag v-else-if="scope.row.verifyStatus === '1'" type="success" size="mini">核准通过</el-tag>
              <el-tag v-else-if="scope.row.verifyStatus === '2'" type="" size="mini">已收货</el-tag>
              <el-tag v-else-if="scope.row.verifyStatus === '3'" type="danger" size="mini">已退货</el-tag>
              <el-tag v-else-if="scope.row.verifyStatus === '4'" type="warning" size="mini">信息已修正</el-tag>
              <el-tag v-else-if="scope.row.verifyStatus === '5'" type="danger" size="mini">缺货登记</el-tag>
              <el-tag v-else-if="scope.row.verifyStatus === '6'" type="success" size="mini">已入库</el-tag>
              <span v-else style="color:#c0c4cc">-</span>
            </template>
          </el-table-column>
          <el-table-column label="核准操作" width="240" align="center" fixed="right">
            <template slot-scope="scope" v-if="purchaseInfo.purchaseStatus === '4' || purchaseInfo.purchaseStatus === '6'">
              <template v-if="purchaseInfo.verifyResult">
                <el-button size="mini" type="success" icon="el-icon-s-data" style="color:#67C23A" @click="handleDirectInbound(scope.row)" v-if="scope.row.verifyStatus === '1'" v-hasRole="['admin','warehouse']">核准入库</el-button>
                <el-button size="mini" type="text" icon="el-icon-back" style="color:#F56C6C" @click="handleReturnDetail(scope.row)" v-if="scope.row.verifyStatus === '1'" v-hasRole="['admin','warehouse']">退货</el-button>
                <el-tag v-if="scope.row.verifyStatus === '1'" type="success" size="mini" style="margin-left:4px">已核准</el-tag>
                <el-tag v-else-if="scope.row.verifyStatus !== '0' && scope.row.verifyStatus !== '1'" type="info" size="mini" style="margin-left:4px">异常</el-tag>
              </template>
              <template v-else>
                <el-button size="mini" type="text" icon="el-icon-check" style="color:#67C23A" @click="handleVerifyDetail(scope.row)" v-if="scope.row.verifyStatus === '0' || scope.row.verifyStatus === '4'" v-hasRole="['admin','warehouse']">核准</el-button>
                <el-button size="mini" type="success" icon="el-icon-s-data" style="color:#67C23A" @click="handleDirectInbound(scope.row)" v-if="scope.row.verifyStatus === '1'" v-hasRole="['admin','warehouse']">核准入库</el-button>
                <el-button size="mini" type="text" icon="el-icon-back" style="color:#F56C6C" @click="handleReturnDetail(scope.row)" v-if="scope.row.verifyStatus === '1'" v-hasRole="['admin','warehouse']">退货</el-button>
                <el-button size="mini" type="text" icon="el-icon-edit" style="color:#E6A23C" @click="handleCorrectInfo(scope.row)" v-if="scope.row.verifyStatus === '0'" v-hasRole="['admin','warehouse']">修正</el-button>
                <el-button size="mini" type="text" icon="el-icon-warning" style="color:#F56C6C" @click="handleShortage(scope.row)" v-if="scope.row.verifyStatus === '0'" v-hasRole="['admin','warehouse']">缺货</el-button>
              </template>
            </template>
          </el-table-column>
        </el-table>
      </el-card>
    </el-card>

    <!-- 核准弹窗 -->
    <el-dialog title="逐条核准" :visible.sync="verifyDialogVisible" width="400px" append-to-body>
      <p>教材：<strong>{{ verifyForm.bookName }}</strong></p>
      <el-form label-width="80px" size="small">
        <el-form-item label="核准结果">
          <el-radio-group v-model="verifyForm.verifyStatus">
            <el-radio label="1">核准通过</el-radio>
            <el-radio label="4">信息修正</el-radio>
            <el-radio label="5">缺货登记</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="备注"><el-input v-model="verifyForm.remark" type="textarea" :rows="2" /></el-form-item>
      </el-form>
      <div slot="footer"><el-button @click="verifyDialogVisible=false">取消</el-button><el-button type="primary" @click="confirmVerifyDetail">确定</el-button></div>
    </el-dialog>

    <!-- 退货弹窗 -->
    <el-dialog title="退货处理" :visible.sync="returnDialogVisible" width="400px" append-to-body>
      <p>教材：<strong>{{ returnForm.bookName }}</strong>，数量：{{ returnForm.quantity }}</p>
      <el-form label-width="80px" size="small">
        <el-form-item label="退货数量"><el-input-number v-model="returnForm.returnQty" :min="1" :max="returnForm.quantity" style="width:100%" /></el-form-item>
        <el-form-item label="退货原因"><el-input v-model="returnForm.returnReason" type="textarea" :rows="2" placeholder="请填写退货原因" /></el-form-item>
      </el-form>
      <div slot="footer"><el-button @click="returnDialogVisible=false">取消</el-button><el-button type="danger" @click="confirmReturnDetail">确认退货</el-button></div>
    </el-dialog>

    <!-- 信息修正弹窗 -->
    <el-dialog title="信息修正" :visible.sync="correctInfoVisible" width="500px" append-to-body>
      <p>教材：<strong>{{ correctForm.bookName }}</strong></p>
      <el-form label-width="80px" size="small">
        <el-form-item label="修正说明"><el-input v-model="correctForm.infoCorrection" type="textarea" :rows="4" placeholder="请描述信息错误及修正内容，格式: 字段名=新值" /></el-form-item>
      </el-form>
      <div slot="footer"><el-button @click="correctInfoVisible=false">取消</el-button><el-button type="warning" @click="confirmCorrectInfo">提交修正</el-button></div>
    </el-dialog>

    <!-- 缺货登记弹窗 -->
    <el-dialog title="缺货登记" :visible.sync="shortageVisible" width="400px" append-to-body>
      <p>教材：<strong>{{ shortageForm.bookName }}</strong></p>
      <el-form label-width="80px" size="small">
        <el-form-item label="缺货说明"><el-input v-model="shortageForm.remark" type="textarea" :rows="3" placeholder="描述缺货情况及处理方案" /></el-form-item>
      </el-form>
      <div slot="footer"><el-button @click="shortageVisible=false">取消</el-button><el-button type="danger" @click="confirmShortage">确认登记</el-button></div>
    </el-dialog>
  </div>
</template>

<script>
import { getPurchase, deletePurchase, verifyDetail, directInboundDetail, returnDetail, correctDetailInfo, registerShortageDetail, batchVerify } from '@/api/textbook/purchase'

export default {
  name: 'PurchaseDetail',
  dicts: ['textbook_type'],
  data() {
    return {
      purchaseInfo: {}, purchaseDetails: [],
      verifyDialogVisible: false,
      verifyForm: { detailId: null, bookName: '', verifyStatus: '1', remark: '' },
      returnDialogVisible: false,
      returnForm: { detailId: null, bookName: '', quantity: 0, returnQty: 0, returnReason: '' },
      correctInfoVisible: false,
      correctForm: { detailId: null, bookName: '', infoCorrection: '' },
      shortageVisible: false,
      shortageForm: { detailId: null, bookName: '', remark: '' }
    }
  },
  computed: {
    canDelete() {
      return this.purchaseInfo.purchaseStatus === '0' || this.purchaseInfo.auditStatus === '0'
    }
  },
  created() {
    const purchaseId = this.$route.query.id
    if (purchaseId) { this.getDetail(purchaseId) }
  },
  methods: {
    getDetail(id) {
      getPurchase(id).then(response => {
        this.purchaseInfo = response.data
        this.purchaseDetails = response.data.details || []
      })
    },
    handleDelete() {
      this.$modal.confirm('确认删除采购单「' + this.purchaseInfo.purchaseNo + '」？删除后无法恢复。').then(() => {
        return deletePurchase(this.purchaseInfo.buyId)
      }).then(() => {
        this.$modal.msgSuccess('采购单已删除')
        this.$router.push('/textbook/purchase')
      }).catch(() => {})
    },
    handleVerifyDetail(row) {
      this.verifyForm = { detailId: row.detailId, bookName: row.bookName, verifyStatus: '1', remark: '' }; this.verifyDialogVisible = true
    },
    confirmVerifyDetail() {
      verifyDetail(this.verifyForm.detailId, this.verifyForm.verifyStatus, this.verifyForm.remark).then(() => {
        this.$modal.msgSuccess('核准完成')
        this.verifyDialogVisible = false
        this.getDetail(this.purchaseInfo.buyId)
      }).catch(() => {})
    },
    handleDirectInbound(row) {
      this.$modal.confirm('确认将《' + row.bookName + '》核准入库？入库后将增加库存。').then(() => {
        return directInboundDetail(row.detailId)
      }).then(() => {
        this.$modal.msgSuccess('《' + row.bookName + '》已核准入库，库存已更新')
        this.getDetail(this.purchaseInfo.buyId)
      }).catch(() => {})
    },
    handleReturnDetail(row) {
      this.returnForm = { detailId: row.detailId, bookName: row.bookName, quantity: row.quantity, returnQty: row.quantity, returnReason: '' }; this.returnDialogVisible = true
    },
    confirmReturnDetail() {
      if (!this.returnForm.returnReason) { this.$modal.msgError('请填写退货原因'); return }
      returnDetail(this.returnForm.detailId, this.returnForm.returnQty, this.returnForm.returnReason).then(() => {
        this.$modal.msgSuccess('退货处理完成')
        this.returnDialogVisible = false
        this.getDetail(this.purchaseInfo.buyId)
      }).catch(() => {})
    },
    handleCorrectInfo(row) {
      this.correctForm = { detailId: row.detailId, bookName: row.bookName, infoCorrection: '' }; this.correctInfoVisible = true
    },
    confirmCorrectInfo() {
      if (!this.correctForm.infoCorrection) { this.$modal.msgError('请填写修正信息'); return }
      correctDetailInfo(this.correctForm.detailId, this.correctForm.infoCorrection).then(() => {
        this.$modal.msgSuccess('信息修正已提交')
        this.correctInfoVisible = false
        this.getDetail(this.purchaseInfo.buyId)
      }).catch(() => {})
    },
    handleShortage(row) {
      this.shortageForm = { detailId: row.detailId, bookName: row.bookName, remark: '' }; this.shortageVisible = true
    },
    confirmShortage() {
      registerShortageDetail(this.shortageForm.detailId, this.shortageForm.remark).then(() => {
        this.$modal.msgSuccess('缺货已登记')
        this.shortageVisible = false
        this.getDetail(this.purchaseInfo.buyId)
      }).catch(() => {})
    },
    goBack() { this.$router.go(-1) },
    auditStatusText(status) {
      return { '0': '待审核', '1': '已通过', '2': '已驳回', '3': '已领书' }[status] || '未知'
    },
    auditStatusTag(status) {
      return { '0': 'warning', '1': 'success', '2': 'danger', '3': '' }[status] || 'info'
    },
    purchaseStatusText(status) {
      return { '0': '待采购', '1': '已下单', '2': '已接单', '3': '已发货', '4': '已到货', '5': '已入库', '6': '核准中', 'X': '已取消' }[status] || '未知'
    },
    purchaseStatusTag(status) {
      return { '0': 'info', '1': 'warning', '2': '', '3': '', '4': 'info', '5': 'success', '6': 'warning', 'X': 'danger' }[status] || 'info'
    }
  }
}
</script>

<style scoped>
.detail-card { margin-top: 20px; }
.app-container { overflow-x: auto; }
</style>
