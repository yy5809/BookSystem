<template>
  <div class="app-container" v-loading="loading" element-loading-text="正在加载数据..." element-loading-background="rgba(255,255,255,0.9)">
    <el-row :gutter="20">
      <!-- 数据概览卡片 -->
      <el-col :span="6" v-for="item in statCards" :key="item.title" :xs="24" :sm="12" :md="6">
        <el-card class="stat-card" shadow="hover" @click.native="item.route && $router.push(item.route)">
          <div class="stat-content">
            <div class="stat-icon" :style="{ background: item.color }">
              <i :class="item.icon"></i>
            </div>
            <div class="stat-info">
              <div class="stat-value" :style="{ color: item.color }">{{ item.value }}</div>
              <div class="stat-title">{{ item.title }}</div>
            </div>
          </div>
        </el-card>
      </el-col>
    </el-row>

    <el-row :gutter="20" style="margin-top: 20px">
      <!-- 待办任务 -->
      <el-col :span="16" :xs="24" :sm="24" :md="16">
        <el-card class="task-card">
          <template #header>
            <div class="card-header">
              <span><i class="el-icon-bell"></i> 待办事项</span>
              <el-button type="text" icon="el-icon-refresh" @click="loadDashboardData">刷新</el-button>
            </div>
          </template>

          <el-tabs v-model="activeTaskTab">
            <el-tab-pane label="待审核采购" name="audit">
              <div v-if="todoList.audit.length === 0" class="empty-tip">
                <i class="el-icon-check"></i>
                <p>暂无待审核的购书申请</p>
              </div>
              <div v-else class="task-list">
                <div v-for="item in todoList.audit.slice(0, 5)" :key="item.buyId" class="task-item" @click="$router.push('/textbook/purchase')">
                  <div class="task-info">
                    <span class="task-name">{{ item.userName }} - {{ item.bookName || '购书申请' }}</span>
                    <span class="task-time">{{ item.createTime }}</span>
                  </div>
                  <el-tag type="warning" size="mini">待审核</el-tag>
                </div>
                <div v-if="todoList.audit.length > 5" class="task-more" @click="$router.push('/textbook/purchase')">
                  还有 {{ todoList.audit.length - 5 }} 条待处理...
                </div>
              </div>
            </el-tab-pane>

            <el-tab-pane label="待确认领书" name="receive">
              <div v-if="todoList.receive.length === 0" class="empty-tip">
                <i class="el-icon-check"></i>
                <p>暂无待领书的申请</p>
              </div>
              <div v-else class="task-list">
                <div v-for="item in todoList.receive.slice(0, 5)" :key="item.buyId" class="task-item" @click="$router.push('/textbook/purchase')">
                  <div class="task-info">
                    <span class="task-name">{{ item.userName }} - 领取{{ item.buyNum }}本</span>
                    <span class="task-time">{{ item.createTime }}</span>
                  </div>
                  <el-tag type="success" size="mini">已通过</el-tag>
                </div>
                <div v-if="todoList.receive.length > 5" class="task-more" @click="$router.push('/textbook/purchase')">
                  还有 {{ todoList.receive.length - 5 }} 条待处理...
                </div>
              </div>
            </el-tab-pane>

            <el-tab-pane label="待入库" name="inbound">
              <div v-if="todoList.inbound.length === 0" class="empty-tip">
                <i class="el-icon-check"></i>
                <p>暂无待入库的采购单</p>
              </div>
              <div v-else class="task-list">
                <div v-for="item in todoList.inbound.slice(0, 5)" :key="item.pendingId" class="task-item" @click="$router.push('/textbook/pending')">
                  <div class="task-info">
                    <span class="task-name">{{ item.bookName }} - {{ item.purchaseNum }}本</span>
                    <span class="task-time">供应商：{{ item.supplier || '未知' }}</span>
                  </div>
                  <el-tag :type="item.status === '2' ? '' : 'warning'" size="mini">{{ item.status === '2' ? '已到货' : '采购中' }}</el-tag>
                </div>
                <div v-if="todoList.inbound.length > 5" class="task-more" @click="$router.push('/textbook/pending')">
                  还有 {{ todoList.inbound.length - 5 }} 条待处理...
                </div>
              </div>
            </el-tab-pane>

            <el-tab-pane label="缺书预警" name="shortage">
              <div v-if="todoList.shortage.length === 0" class="empty-tip">
                <i class="el-icon-check"></i>
                <p>当前没有教材短缺</p>
              </div>
              <div v-else class="task-list">
                <div v-for="item in todoList.shortage.slice(0, 5)" :key="item.stockId" class="task-item" @click="$router.push('/textbook/inventory')">
                  <div class="task-info">
                    <span class="task-name">{{ item.bookName }} - 库存仅剩{{ item.stockNum }}本</span>
                    <span class="task-time">预警阈值：{{ item.warningNum || 10 }}本</span>
                  </div>
                  <el-tag :type="item.stockNum <= 0 ? 'danger' : 'warning'" size="mini">{{ item.stockNum <= 0 ? '短缺' : '预警' }}</el-tag>
                </div>
                <div v-if="todoList.shortage.length > 5" class="task-more" @click="$router.push('/textbook/inventory')">
                  还有 {{ todoList.shortage.length - 5 }} 本异常...
                </div>
              </div>
            </el-tab-pane>
          </el-tabs>
        </el-card>
      </el-col>

      <!-- 快捷操作 -->
      <el-col :span="8" :xs="24" :sm="24" :md="8">
        <el-card class="quick-card">
          <template #header>
            <div class="card-header">
              <span><i class="el-icon-star-off"></i> 常用功能</span>
            </div>
          </template>

          <div class="quick-grid">
            <div class="quick-item" v-for="item in quickActions" :key="item.name" @click="$router.push(item.route)">
              <div class="quick-icon" :style="{ background: item.color }">
                <i :class="item.icon"></i>
              </div>
              <span class="quick-name">{{ item.name }}</span>
            </div>
          </div>
        </el-card>

        <el-card style="margin-top: 20px">
          <template #header>
            <div class="card-header">
              <span><i class="el-icon-data-line"></i> 系统动态</span>
            </div>
          </template>
          <div class="activity-list">
            <div v-for="(log, index) in recentLogs.slice(0, 8)" :key="index" class="activity-item">
              <div class="activity-dot" :class="getActivityClass(log.bizType)"></div>
              <div class="activity-content">
                <p>{{ log.remark || getBizTypeText(log.bizType) }}</p>
                <span class="activity-time">{{ log.createTime }}</span>
              </div>
            </div>
            <div v-if="recentLogs.length === 0" class="empty-tip-sm">
              暂无系统动态
            </div>
          </div>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script>
import { getDashboardStats } from '@/api/textbook/dashboard'

export default {
  name: 'TextbookDashboard',
  data() {
    return {
      loading: false,
      activeTaskTab: 'audit',
      stats: {
        totalBooks: 0,
        totalStock: 0,
        pendingAudit: 0,
        pendingReceive: 0,
        shortageCount: 0,
        warningCount: 0,
        pendingInbound: 0,
        todayInbound: 0,
        todayOutbound: 0
      },
      todoList: {
        audit: [],
        receive: [],
        inbound: [],
        shortage: []
      },
      recentLogs: []
    }
  },
  computed: {
    statCards() {
      return [
        {
          title: '教材种类',
          value: this.stats.totalBooks,
          icon: 'el-icon-notebook-2',
          color: '#409EFF',
          route: '/textbook/inventory'
        },
        {
          title: '库存总量',
          value: this.stats.totalStock + ' 本',
          icon: 'el-icon-box',
          color: '#67C23A',
          route: '/textbook/inventory'
        },
        {
          title: '待处理事项',
          value: this.stats.pendingAudit + this.stats.pendingReceive + this.stats.pendingInbound,
          icon: 'el-icon-warning-outline',
          color: '#E6A23C',
          route: null
        },
        {
          title: '短缺/预警',
          value: (this.stats.shortageCount || 0) + '/' + (this.stats.warningCount || 0),
          icon: 'el-icon-bell',
          color: '#F56C6C',
          route: '/textbook/inventory'
        }
      ]
    },
    quickActions() {
      return [
        { name: '库存管理', icon: 'el-icon-box', color: '#67C23A', route: '/textbook/inventory' },
        { name: '采购审核', icon: 'el-icon-s-check', color: '#E6A23C', route: '/textbook/purchase' },
        { name: '登记缺书', icon: 'el-icon-warning', color: '#F56C6C', route: '/textbook/shortage' },
        { name: '新增采购', icon: 'el-icon-shopping-cart-2', color: '#409EFF', route: '/textbook/pending' },
        { name: '入库记录', icon: 'el-icon-download', color: '#909399', route: '/textbook/inbound' },
        { name: '出库记录', icon: 'el-icon-upload2', color: '#909399', route: '/textbook/outbound' }
      ]
    }
  },
  created() {
    this.loadDashboardData()
  },
  methods: {
    async loadDashboardData() {
      this.loading = true
      try {
        const res = await getDashboardStats()
        if (res.data) {
          this.stats.totalBooks = res.data.totalBooks || 0
          this.stats.totalStock = res.data.totalStock || 0
          this.stats.pendingAudit = res.data.pendingAudit || 0
          this.stats.pendingReceive = res.data.pendingReceive || 0
          this.stats.shortageCount = res.data.shortageCount || 0
          this.stats.warningCount = res.data.warningCount || 0
          this.stats.pendingInbound = res.data.pendingInbound || 0
          this.todoList.audit = res.data.auditList || []
          this.todoList.receive = res.data.receiveList || []
          this.todoList.inbound = res.data.inboundList || []
          this.todoList.shortage = res.data.shortageList || []
          this.recentLogs = res.data.recentLogs || []
        }
      } catch (error) {
        console.error('加载仪表盘数据失败:', error)
        this.$message.error('加载数据失败')
      } finally {
        this.loading = false
      }
    },

    handleInventoryData(rows) {
      this.stats.totalBooks = rows.length
      let totalStock = 0
      let shortageCount = 0
      let warningCount = 0

      rows.forEach(row => {
        totalStock += row.stockNum || 0
        if (row.stockNum != null) {
          if (row.stockNum <= 0) shortageCount++
          else if (row.stockNum <= (row.warningNum || 10)) warningCount++
        }
      })

      this.stats.totalStock = totalStock
      this.stats.shortageCount = shortageCount
      this.stats.warningCount = warningCount
      this.todoList.shortage = rows.filter(row => row.stockNum !== undefined && row.stockNum <= (row.warningNum || 10))
    },

    handlePurchaseData(rows) {
      const auditList = rows.filter(r => r.auditStatus === '0')
      const receiveList = rows.filter(r => r.auditStatus === '1' && r.receiveStatus !== '1')

      this.stats.pendingAudit = auditList.length
      this.stats.pendingReceive = receiveList.length
      this.todoList.audit = auditList
      this.todoList.receive = receiveList
    },

    handlePendingData(rows) {
      const inboundList = rows.filter(r => r.status === '1' || r.status === '2')
      this.stats.pendingInbound = inboundList.length
      this.todoList.inbound = inboundList
    },

    getActivityClass(bizType) {
      const map = {
        purchase_in: 'activity-success',
        issue_out: 'activity-danger',
        return_in: 'activity-info',
        manual_adj: 'activity-warning'
      }
      return map[bizType] || 'activity-default'
    },

    getBizTypeText(type) {
      const map = {
        purchase_in: '采购入库',
        issue_out: '领书出库',
        return_in: '退货入库',
        manual_adj: '人工调整'
      }
      return map[type] || '库存变动'
    }
  }
}
</script>

<style scoped>
.stat-card {
  margin-bottom: 20px;
  cursor: pointer;
  transition: all 0.3s;
}
.stat-card:hover {
  transform: translateY(-4px);
}
.stat-content {
  display: flex;
  align-items: center;
  padding: 10px 0;
}
.stat-icon {
  width: 60px;
  height: 60px;
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-right: 16px;
}
.stat-icon i {
  font-size: 28px;
  color: #fff;
}
.stat-info {
  flex: 1;
}
.stat-value {
  font-size: 28px;
  font-weight: bold;
  line-height: 1.2;
}
.stat-title {
  font-size: 14px;
  color: #909399;
  margin-top: 4px;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.task-list {
  max-height: 300px;
  overflow-y: auto;
}
.task-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 12px 0;
  border-bottom: 1px solid #f0f0f0;
  cursor: pointer;
  transition: background 0.2s;
}
.task-item:hover {
  background: #f5f7fa;
  padding-left: 8px;
  padding-right: 8px;
}
.task-info {
  display: flex;
  flex-direction: column;
}
.task-name {
  font-size: 14px;
  color: #303133;
  font-weight: 500;
}
.task-time {
  font-size: 12px;
  color: #909399;
  margin-top: 4px;
}
.task-more {
  text-align: center;
  padding: 12px;
  color: #409EFF;
  cursor: pointer;
  font-size: 13px;
}

.empty-tip {
  text-align: center;
  padding: 40px 20px;
  color: #909399;
}
.empty-tip i {
  font-size: 48px;
  color: #c0c4cc;
  margin-bottom: 12px;
  display: block;
}
.empty-tip p {
  font-size: 14px;
}
.empty-tip-sm {
  text-align: center;
  padding: 30px 20px;
  color: #909399;
  font-size: 13px;
}

.quick-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 16px;
}
.quick-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 16px 8px;
  border-radius: 8px;
  cursor: pointer;
  transition: all 0.3s;
}
.quick-item:hover {
  background: #f5f7fa;
  transform: translateY(-2px);
}
.quick-icon {
  width: 44px;
  height: 44px;
  border-radius: 10px;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-bottom: 8px;
}
.quick-icon i {
  font-size: 22px;
  color: #fff;
}
.quick-name {
  font-size: 13px;
  color: #606266;
}

.activity-list {
  max-height: 320px;
  overflow-y: auto;
}
.activity-item {
  display: flex;
  padding: 10px 0;
  border-bottom: 1px solid #f5f5f5;
}
.activity-dot {
  width: 8px;
  height: 8px;
  border-radius: 50%;
  margin-top: 6px;
  margin-right: 10px;
  flex-shrink: 0;
}
.activity-success { background: #67C23A; }
.activity-danger { background: #F56C6C; }
.activity-info { background: #909399; }
.activity-warning { background: #E6A23C; }
.activity-default { background: #409EFF; }

.activity-content {
  flex: 1;
}
.activity-content p {
  font-size: 13px;
  color: #303133;
  margin: 0 0 4px 0;
  line-height: 1.4;
}
.activity-time {
  font-size: 11px;
  color: #c0c4cc;
}

@media screen and (max-width: 1200px) {
  .stat-value { font-size: 24px; }
  .stat-icon { width: 50px; height: 50px; }
  .stat-icon i { font-size: 24px; }
}
@media screen and (max-width: 768px) {
  .quick-grid { grid-template-columns: repeat(3, 1fr); gap: 10px; }
  .stat-card { margin-bottom: 15px; }
}
</style>
