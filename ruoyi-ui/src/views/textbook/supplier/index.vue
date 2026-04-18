<template>
  <div class="supplier-home">
    <el-card class="stats-card">
      <h3>供应商工作台</h3>
      <div class="stats-grid">
        <el-card class="stat-item">
          <div class="stat-icon">
            <i class="el-icon-message"></i>
          </div>
          <div class="stat-info">
            <h4>未读通知</h4>
            <p class="stat-number">{{ unreadNoticeCount }}</p>
          </div>
        </el-card>
        <el-card class="stat-item">
          <div class="stat-icon">
            <i class="el-icon-sell"></i>
          </div>
          <div class="stat-info">
            <h4>待确认发货</h4>
            <p class="stat-number">{{ pendingShipmentCount }}</p>
          </div>
        </el-card>
      </div>
    </el-card>
    
    <el-card class="recent-purchases">
      <template slot="header">
        <span>最近采购单</span>
        <el-button type="primary" size="small" @click="goToPurchaseList">查看全部</el-button>
      </template>
      <el-table :data="recentPurchases" style="width: 100%">
        <el-table-column prop="purchaseNo" label="采购单号" width="180"></el-table-column>
        <el-table-column prop="purchaseStatus" label="状态">
          <template slot-scope="scope">
            <el-tag :type="getStatusType(scope.row.purchaseStatus)">
              {{ getStatusText(scope.row.purchaseStatus) }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="createTime" label="创建时间" width="180"></el-table-column>
        <el-table-column label="操作" width="120">
          <template slot-scope="scope">
            <el-button type="primary" size="small" @click="viewPurchase(scope.row)" v-if="scope.row.purchaseStatus === '1'">
              确认发货
            </el-button>
            <el-button type="info" size="small" @click="viewPurchase(scope.row)" v-else>
              查看详情
            </el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>
  </div>
</template>

<script>
import { getSupplierDashboard, listSupplierPurchases } from '@/api/textbook/supplier'

export default {
  name: 'SupplierHome',
  data() {
    return {
      unreadNoticeCount: 0,
      pendingShipmentCount: 0,
      recentPurchases: []
    }
  },
  created() {
    this.loadDashboardData()
  },
  methods: {
    loadDashboardData() {
      // 获取仪表盘数据
      getSupplierDashboard().then(response => {
        this.unreadNoticeCount = response.data.unreadNoticeCount || 0
        this.pendingShipmentCount = response.data.pendingShipmentCount || 0
      })
      
      // 获取最近采购单
      listSupplierPurchases({ pageSize: 5 }).then(response => {
        this.recentPurchases = response.data.rows || []
      })
    },
    getStatusType(status) {
      const typeMap = {
        '0': 'info',
        '1': 'warning',
        '2': 'success',
        '3': 'success'
      }
      return typeMap[status] || 'info'
    },
    getStatusText(status) {
      const textMap = {
        '0': '待采购',
        '1': '采购中',
        '2': '已到货',
        '3': '已入库'
      }
      return textMap[status] || '未知'
    },
    viewPurchase(purchase) {
      this.$router.push(`/textbook/supplier/purchase/${purchase.buyId}`)
    },
    goToPurchaseList() {
      this.$router.push('/textbook/supplier/purchase')
    }
  }
}
</script>

<style scoped>
.supplier-home {
  padding: 20px;
}

.stats-card {
  margin-bottom: 20px;
}

.stats-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 20px;
  margin-top: 20px;
}

.stat-item {
  display: flex;
  align-items: center;
  padding: 20px;
}

.stat-icon {
  font-size: 36px;
  color: #409EFF;
  margin-right: 20px;
}

.stat-info h4 {
  margin: 0 0 10px 0;
  color: #606266;
  font-size: 16px;
}

.stat-number {
  margin: 0;
  font-size: 24px;
  font-weight: bold;
  color: #303133;
}

.recent-purchases {
  margin-top: 20px;
}
</style>