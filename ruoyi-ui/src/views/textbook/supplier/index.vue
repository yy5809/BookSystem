<template>
  <div class="app-container">
    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button type="primary" plain icon="el-icon-bell" size="mini" @click="$router.push('/supplier/supplierNotice')">我的通知</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="success" plain icon="el-icon-s-order" size="mini" @click="$router.push('/supplier/supplierPurchase')">我的采购单</el-button>
      </el-col>
    </el-row>

    <el-row :gutter="20">
      <el-col :span="8">
        <div class="dashboard-card" style="background: #fdf6ec;">
          <i class="el-icon-message dashboard-icon" style="color: #E6A23C;"></i>
          <div class="dashboard-info">
            <div class="dashboard-title">未读通知</div>
            <div class="dashboard-num">{{ unreadNoticeCount }}</div>
          </div>
        </div>
      </el-col>
      <el-col :span="8">
        <div class="dashboard-card" style="background: #ecf5ff;">
          <i class="el-icon-truck dashboard-icon" style="color: #409EFF;"></i>
          <div class="dashboard-info">
            <div class="dashboard-title">待确认发货</div>
            <div class="dashboard-num">{{ pendingShipmentCount }}</div>
          </div>
        </div>
      </el-col>
    </el-row>

    <el-card class="mt20">
      <template slot="header">
        <span>最近采购单</span>
      </template>
      <el-table :data="recentPurchases" border stripe v-loading="loading">
        <el-table-column label="采购单号" align="center" prop="purchaseNo" width="200" show-overflow-tooltip />
        <el-table-column label="状态" align="center" width="100">
          <template slot-scope="scope">
            <el-tag :type="statusType(scope.row.purchaseStatus)" size="mini">{{ statusText(scope.row.purchaseStatus) }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column label="创建时间" align="center" prop="createTime" width="160" />
        <el-table-column label="操作" align="center" class-name="small-padding fixed-width" width="100">
          <template slot-scope="scope">
            <el-button size="mini" type="text" icon="el-icon-view" @click="viewPurchase(scope.row)">详情</el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>
  </div>
</template>

<script>
import { getSupplierDashboard, listSupplierPurchases } from '@/api/textbook/supplier'

export default {
  name: "SupplierHome",
  data() {
    return {
      loading: false,
      unreadNoticeCount: 0,
      pendingShipmentCount: 0,
      recentPurchases: []
    }
  },
  created() {
    this.loadData()
  },
  methods: {
    loadData() {
      this.loading = true
      getSupplierDashboard().then(response => {
        this.unreadNoticeCount = response.unreadNoticeCount || 0
        this.pendingShipmentCount = response.pendingShipmentCount || 0
      }).catch(() => {})
      listSupplierPurchases({ pageSize: 5 }).then(response => {
        this.recentPurchases = response.rows || []
        this.loading = false
      }).catch(() => { this.loading = false })
    },
    statusType(status) {
      const m = { '0': 'info', '1': 'warning', '2': '', '3': '', '4': 'info', '5': 'success' }
      return m[status] || 'info'
    },
    statusText(status) {
      const m = { '0': '待采购', '1': '采购中', '2': '已接单', '3': '已发货', '4': '已到货', '5': '已入库' }
      return m[status] || '未知'
    },
    viewPurchase(purchase) {
      this.$router.push(`/supplier/supplierPurchase/${purchase.buyId}`)
    }
  }
}
</script>

<style scoped>
.dashboard-card {
  display: flex;
  align-items: center;
  padding: 20px;
  border-radius: 4px;
  margin-bottom: 10px;
}
.dashboard-icon {
  font-size: 40px;
  margin-right: 20px;
}
.dashboard-title { font-size: 14px; color: #606266; }
.dashboard-num { font-size: 28px; font-weight: bold; color: #303133; }
.mt20 { margin-top: 20px; }
</style>
