<template>
  <div class="app-container">
    <el-card>
      <template slot="header">
        <span>采购单详情</span>
        <el-button type="primary" size="small" style="margin-left: 20px" @click="goBack">返回列表</el-button>
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
        <el-table :data="purchaseDetails" border stripe>
          <el-table-column label="ISBN" prop="isbn" width="135" align="center" />
          <el-table-column label="教材名称" prop="bookName" min-width="150" show-overflow-tooltip />
          <el-table-column label="版次" prop="edition" width="70" align="center" />
          <el-table-column label="作者" prop="author" width="70" show-overflow-tooltip />
          <el-table-column label="出版社" prop="publisher" width="90" show-overflow-tooltip />
          <el-table-column label="教材类型" width="90" align="center">
            <template slot-scope="scope">
              <dict-tag :options="dict.type.textbook_type" :value="scope.row.textbookType" />
            </template>
          </el-table-column>
          <el-table-column label="学院" prop="college" width="80" show-overflow-tooltip />
          <el-table-column label="专业" prop="major" width="80" show-overflow-tooltip />
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
        </el-table>
      </el-card>
    </el-card>
  </div>
</template>

<script>
import { getPurchase } from '@/api/textbook/purchase'

export default {
  name: 'PurchaseDetail',
  dicts: ['textbook_type'],
  data() {
    return { purchaseInfo: {}, purchaseDetails: [] }
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
    goBack() { this.$router.go(-1) },
    auditStatusText(status) {
      return { '0': '待审核', '1': '已通过', '2': '已驳回', '3': '已领书', '4': '已到货', '5': '已入库', '6': '已发货' }[status] || '未知'
    },
    auditStatusTag(status) {
      return { '0': 'warning', '1': 'success', '2': 'danger', '3': '', '4': 'info', '5': 'success', '6': '' }[status] || 'info'
    },
    purchaseStatusText(status) {
      return { '0': '待采购', '1': '已下单', '2': '已接单', '3': '已发货', '4': '已到货', '5': '已入库' }[status] || '未知'
    },
    purchaseStatusTag(status) {
      return { '0': 'info', '1': 'warning', '2': '', '3': '', '4': 'info', '5': 'success' }[status] || 'info'
    }
  }
}
</script>

<style scoped>
.detail-card { margin-top: 20px; }
</style>
