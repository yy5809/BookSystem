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
          <el-col :span="8"><el-form-item label="状态">
            <el-tag :type="statusTagType(purchaseInfo.auditStatus)">{{ statusText(purchaseInfo.auditStatus) }}</el-tag>
          </el-form-item></el-col>
          <el-col :span="8"><el-form-item label="提交时间"><el-input :value="purchaseInfo.submitTime" disabled /></el-form-item></el-col>
          <el-col :span="8"><el-form-item label="经费来源"><el-input :value="purchaseInfo.fundingSource" disabled /></el-form-item></el-col>
        </el-row>
        <el-row :gutter="20" v-if="purchaseInfo.rejectReason">
          <el-col :span="24"><el-form-item label="驳回原因"><el-input type="textarea" :value="purchaseInfo.rejectReason" disabled /></el-form-item></el-col>
        </el-row>
      </el-form>

      <el-card class="detail-card">
        <template slot="header"><span>采购明细</span></template>
        <el-table :data="purchaseDetails" border stripe>
          <el-table-column label="ISBN" prop="isbn" width="150" align="center" />
          <el-table-column label="教材名称" prop="bookName" min-width="200" show-overflow-tooltip />
          <el-table-column label="数量" prop="quantity" width="100" align="center" />
          <el-table-column label="单价" prop="unitPrice" width="100" align="center"><template slot-scope="scope">{{ scope.row.unitPrice || '-' }}</template></el-table-column>
          <el-table-column label="总价" prop="totalPrice" width="100" align="center"><template slot-scope="scope">{{ scope.row.totalPrice || '-' }}</template></el-table-column>
        </el-table>
      </el-card>
    </el-card>
  </div>
</template>

<script>
import { getPurchase } from '@/api/textbook/purchase'

export default {
  name: 'PurchaseDetail',
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
    goBack() { this.$router.push('/warehouse/purchase') },
    statusText(status) {
      const map = { '0': '待审核', '1': '已通过', '2': '已驳回', '3': '已领书', '4': '已到货', '5': '已入库', '6': '已发货' }
      return map[status] || '未知'
    },
    statusTagType(status) {
      const map = { '0': 'warning', '1': 'success', '2': 'danger', '3': '', '4': 'info', '5': 'success', '6': '' }
      return map[status] || 'info'
    }
  }
}
</script>

<style scoped>
.detail-card { margin-top: 20px; }
</style>
