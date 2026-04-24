<template>
  <div class="dashboard-container">
    <el-row :gutter="20" type="flex" justify="space-between">
      <el-col :span="4" :xs="12">
        <div class="dashboard-card" @click="$router.push({ path: '/textbook/bookManage', query: { infoStatus: '0' } })" style="cursor: pointer;">
          <div class="card-icon" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);">
            <i class="el-icon-warning-outline"></i>
          </div>
          <div class="card-info">
            <div class="card-title">库存预警</div>
            <div class="card-number">{{ stats.warningCount }}</div>
            <div class="card-desc">低于预警阈值</div>
          </div>
        </div>
      </el-col>
      <el-col :span="4" :xs="12">
        <div class="dashboard-card" @click="$router.push({ path: '/textbook/bookManage', query: { infoStatus: '0' } })" style="cursor: pointer;">
          <div class="card-icon" style="background: linear-gradient(135deg, #f5af19 0%, #f12711 100%);">
            <i class="el-icon-edit-outline"></i>
          </div>
          <div class="card-info">
            <div class="card-title">待完善教材</div>
            <div class="card-number">{{ stats.incompleteBookCount }}</div>
            <div class="card-desc">信息不完整</div>
          </div>
        </div>
      </el-col>
      <el-col :span="4" :xs="12">
        <div class="dashboard-card">
          <div class="card-icon" style="background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);">
            <i class="el-icon-s-check"></i>
          </div>
          <div class="card-info">
            <div class="card-title">待审核申请</div>
            <div class="card-number">{{ stats.pendingApplyCount }}</div>
            <div class="card-desc">个人领书申请</div>
          </div>
        </div>
      </el-col>
      <el-col :span="4" :xs="12">
        <div class="dashboard-card">
          <div class="card-icon" style="background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);">
            <i class="el-icon-box"></i>
          </div>
          <div class="card-info">
            <div class="card-title">待到货采购</div>
            <div class="card-number">{{ stats.pendingPurchaseCount }}</div>
            <div class="card-desc">采购中/已发货</div>
          </div>
        </div>
      </el-col>
      <el-col :span="4" :xs="12">
        <div class="dashboard-card" @click="$router.push('/textbook/shortage')" style="cursor: pointer;">
          <div class="card-icon" style="background: linear-gradient(135deg, #fa709a 0%, #fee140 100%);">
            <i class="el-icon-warning-outline"></i>
          </div>
          <div class="card-info">
            <div class="card-title">待处理缺书</div>
            <div class="card-number">{{ stats.pendingShortageCount }}</div>
            <div class="card-desc">未处理登记</div>
          </div>
        </div>
      </el-col>
    </el-row>

    <el-row :gutter="20" style="margin-top: 20px;">
      <el-col :span="16" :xs="24">
        <el-card shadow="hover">
          <div slot="header">
            <span>库存预警列表</span>
            <el-button style="float: right; padding: 3px 0" type="text" @click="$router.push('/textbook/inventory')">查看全部</el-button>
          </div>
          <el-table :data="warningList" size="small" v-loading="loading" max-height="300" border stripe>
            <el-table-column label="ISBN" prop="isbn" width="140" />
            <el-table-column label="教材名称" prop="bookName" show-overflow-tooltip />
            <el-table-column label="当前库存" prop="stockNum" width="90" align="center">
              <template slot-scope="scope">
                <span style="color: #F56C6C; font-weight: bold;">{{ scope.row.stockNum || 0 }}</span>
              </template>
            </el-table-column>
            <el-table-column label="预警阈值" prop="warningThreshold" width="90" align="center" />
          </el-table>
          <el-empty v-if="!loading && warningList.length === 0" description="暂无库存预警" :image-size="60" />
        </el-card>
      </el-col>
      <el-col :span="8" :xs="24">
        <el-card shadow="hover">
          <div slot="header"><span>快捷操作</span></div>
          <div class="quick-actions">
            <div class="action-item" @click="$router.push('/textbook/purchase')">
              <i class="el-icon-shopping"></i>
              <span>采购管理</span>
            </div>
            <div class="action-item" @click="$router.push('/textbook/inbound')">
              <i class="el-icon-box"></i>
              <span>入库管理</span>
            </div>
            <div class="action-item" @click="$router.push('/textbook/noticeManage')">
              <i class="el-icon-document"></i>
              <span>领书通知</span>
            </div>
            <div class="action-item" @click="$router.push('/textbook/personalApply')">
              <i class="el-icon-s-check"></i>
              <span>审核申请</span>
            </div>
            <div class="action-item" @click="$router.push('/textbook/shortage')">
              <i class="el-icon-warning-outline"></i>
              <span>缺书管理</span>
            </div>
            <div class="action-item" @click="$router.push('/textbook/inventory')">
              <i class="el-icon-coin"></i>
              <span>库存查询</span>
            </div>
          </div>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script>
import { getInventoryWarningList } from "@/api/textbook/inventory";
import { listPersonalApply } from "@/api/textbook/personalApply";
import { listNotice } from "@/api/textbook/notice";
import { countIncompleteBook } from "@/api/textbook/book";
import { getShortageList } from "@/api/textbook/shortage";
import { listPurchase } from "@/api/textbook/purchase";

export default {
  name: "WarehouseDashboard",
  data() {
    return {
      loading: false,
      stats: {
        warningCount: 0,
        incompleteBookCount: 0,
        pendingApplyCount: 0,
        pendingPurchaseCount: 0,
        pendingShortageCount: 0,
        unreadNotice: 0
      },
      warningList: []
    };
  },
  created() {
    this.loadDashboardData();
  },
  methods: {
    loadDashboardData() {
      getInventoryWarningList().then(response => {
        this.warningList = (response.rows || []).slice(0, 5);
        this.stats.warningCount = response.total || 0;
      }).catch(() => {});

      listPersonalApply({ status: '0', pageNum: 1, pageSize: 1 }).then(response => {
        this.stats.pendingApplyCount = response.total || 0;
      }).catch(() => {});

      listNotice({ readStatus: '0', pageNum: 1, pageSize: 1 }).then(response => {
        this.stats.unreadNotice = response.total || 0;
      }).catch(() => {});

      countIncompleteBook().then(response => {
        this.stats.incompleteBookCount = response.data || 0;
      }).catch(() => {});

      getShortageList({ handleStatus: '0', pageNum: 1, pageSize: 1 }).then(response => {
        this.stats.pendingShortageCount = response.total || 0;
      }).catch(() => {});

      listPurchase({ status: '1', pageNum: 1, pageSize: 1 }).then(response => {
        this.stats.pendingPurchaseCount = response.total || 0;
        listPurchase({ status: '6', pageNum: 1, pageSize: 1 }).then(res => {
          this.stats.pendingPurchaseCount += (res.total || 0);
        }).catch(() => {});
      }).catch(() => {});
    }
  }
};
</script>

<style scoped>
.dashboard-container { padding: 20px; }
.dashboard-card {
  display: flex;
  align-items: center;
  padding: 20px;
  background: #fff;
  border-radius: 8px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.06);
  margin-bottom: 20px;
}
.card-icon {
  width: 64px;
  height: 64px;
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #fff;
  font-size: 28px;
  flex-shrink: 0;
  margin-right: 16px;
}
.card-info { flex: 1; }
.card-title { font-size: 14px; color: #909399; margin-bottom: 4px; }
.card-number { font-size: 28px; font-weight: bold; color: #303133; line-height: 1.2; }
.card-desc { font-size: 12px; color: #C0C4CC; margin-top: 4px; }

.quick-actions { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; }
.action-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 18px 10px;
  background: #f5f7fa;
  border-radius: 8px;
  cursor: pointer;
  transition: all 0.2s;
}
.action-item:hover { background: #e6e8eb; transform: translateY(-2px); }
.action-item i { font-size: 24px; color: #409EFF; margin-bottom: 8px; }
.action-item span { font-size: 13px; color: #303133; }
</style>
