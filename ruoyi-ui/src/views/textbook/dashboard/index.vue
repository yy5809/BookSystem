<template>
  <div class="app-container">
    <el-row :gutter="20">
      <el-col :span="6" :xs="24">
        <div class="dashboard-card">
          <div class="card-icon" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);">
            <i class="el-icon-document"></i>
          </div>
          <div class="card-info">
            <div class="card-title">我的申请</div>
            <div class="card-number">{{ stats.myApplyCount }}</div>
            <div class="card-desc">待审核: {{ stats.pendingCount }} | 已通过: {{ stats.approvedCount }}</div>
          </div>
        </div>
      </el-col>
      <el-col :span="6" :xs="24">
        <div class="dashboard-card">
          <div class="card-icon" style="background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);">
            <i class="el-icon-warning"></i>
          </div>
          <div class="card-info">
            <div class="card-title">缺书登记</div>
            <div class="card-number">{{ stats.shortageCount }}</div>
            <div class="card-desc">待处理: {{ stats.pendingShortage }}</div>
          </div>
        </div>
      </el-col>
      <el-col :span="6" :xs="24">
        <div class="dashboard-card">
          <div class="card-icon" style="background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);">
            <i class="el-icon-reading"></i>
          </div>
          <div class="card-info">
            <div class="card-title">已领教材</div>
            <div class="card-number">{{ stats.issuedCount }}</div>
            <div class="card-desc">本学期累计</div>
          </div>
        </div>
      </el-col>
      <el-col :span="6" :xs="24">
        <div class="dashboard-card">
          <div class="card-icon" style="background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);">
            <i class="el-icon-bell"></i>
          </div>
          <div class="card-info">
            <div class="card-title">未读通知</div>
            <div class="card-number">{{ stats.unreadNotice }}</div>
            <div class="card-desc">条新通知</div>
          </div>
        </div>
      </el-col>
    </el-row>

    <el-row :gutter="20" style="margin-top: 20px;">
      <el-col :span="16" :xs="24">
        <el-card shadow="hover">
          <div slot="header">
            <span>我的最近申请</span>
            <el-button style="float: right; padding: 3px 0" type="text" @click="$router.push('/teacher/myApply')">查看全部</el-button>
          </div>
          <el-table :data="recentApplies" size="small" v-loading="loading" border stripe>
            <el-table-column label="教材名称" prop="bookName" show-overflow-tooltip />
            <el-table-column label="数量" prop="applyQty" width="60" align="center" />
            <el-table-column label="状态" width="90" align="center">
              <template slot-scope="scope">
                <el-tag :type="getStatusType(scope.row.status)" size="mini">{{ getStatusLabel(scope.row.status) }}</el-tag>
              </template>
            </el-table-column>
            <el-table-column label="申请时间" prop="createTime" width="160" />
          </el-table>
        </el-card>
      </el-col>
      <el-col :span="8" :xs="24">
        <el-card shadow="hover">
          <div slot="header"><span>快捷操作</span></div>
          <div class="quick-actions">
            <div class="action-item" @click="$router.push('/teacher/myApply')">
              <i class="el-icon-plus"></i>
              <span>提交领书申请</span>
            </div>
            <div class="action-item" @click="$router.push('/teacher/bookQuery')">
              <i class="el-icon-search"></i>
              <span>查询教材信息</span>
            </div>
            <div class="action-item" @click="$router.push('/teacher/registerShortage')">
              <i class="el-icon-edit-outline"></i>
              <span>登记缺书</span>
            </div>

            <div class="action-item" @click="$router.push('/teacher/myNotice')">
              <i class="el-icon-bell"></i>
              <span>查看通知</span>
            </div>
          </div>
        </el-card>


      </el-col>
    </el-row>
  </div>
</template>

<script>
import { listMyApply } from "@/api/textbook/personalApply";
import { listNotice } from "@/api/textbook/notice";

export default {
  name: "Dashboard",
  data() {
    return {
      loading: false,
      stats: {
        myApplyCount: 0,
        pendingCount: 0,
        approvedCount: 0,
        shortageCount: 0,
        pendingShortage: 0,
        issuedCount: 0,
        unreadNotice: 0
      },
      recentApplies: []
    };
  },
  created() {
    this.loadDashboardData();
  },
  methods: {
    loadDashboardData() {
      listMyApply({ pageNum: 1, pageSize: 5 }).then(response => {
        const rows = response.rows || [];
        this.recentApplies = rows;
        this.stats.myApplyCount = response.total || 0;
        this.stats.pendingCount = response.total > 0 ? rows.filter(r => r.status === '0').length : 0;
        this.stats.approvedCount = response.total > 0 ? rows.filter(r => r.status === '1' || r.status === '3').length : 0;
        this.stats.issuedCount = response.total > 0 ? rows.filter(r => r.status === '3').length : 0;
      });
      listNotice({ readStatus: '0', pageNum: 1, pageSize: 1 }).then(response => {
        this.stats.unreadNotice = response.total || 0;
      }).catch(() => {});
    },
    getStatusType(status) {
      const map = { '0': 'warning', '1': 'success', '2': 'danger', '3': '' };
      return map[status] || 'info';
    },
    getStatusLabel(status) {
      const map = { '0': '待审核', '1': '已通过', '2': '已驳回', '3': '已出库', '4': '已到货', '5': '已入库', '6': '已发货' };
      return map[status] || status;
    }
  }
};
</script>

<style scoped>
.dashboard-card {
  display: flex;
  align-items: center;
  padding: 20px;
  background: #fff;
  border-radius: 4px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
  margin-bottom: 15px;
}
.card-icon {
  width: 56px;
  height: 56px;
  border-radius: 8px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #fff;
  font-size: 24px;
  flex-shrink: 0;
  margin-right: 14px;
}
.card-info { flex: 1; }
.card-title { font-size: 13px; color: #909399; margin-bottom: 4px; }
.card-number { font-size: 26px; font-weight: bold; color: #303133; line-height: 1.2; }
.card-desc { font-size: 12px; color: #C0C4CC; margin-top: 4px; }

.quick-actions { display: grid; grid-template-columns: 1fr 1fr; gap: 10px; }
.action-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 16px 10px;
  background: #f5f7fa;
  border-radius: 4px;
  cursor: pointer;
}
.action-item:hover { background: #e6e8eb; }
.action-item i { font-size: 22px; color: #409EFF; margin-bottom: 6px; }
.action-item span { font-size: 13px; color: #303133; }
</style>
