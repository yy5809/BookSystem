<template>
  <div class="app-container">
    <el-row :gutter="20" style="margin-bottom: 20px;">
      <el-col :span="6">
        <el-card shadow="hover" class="notice-card notice-card--primary">
          <div class="notice-card__icon"><i class="el-icon-bell"></i></div>
          <div class="notice-card__info">
            <div class="notice-card__number">{{ stats.total }}</div>
            <div class="notice-card__label">全部通知</div>
          </div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card shadow="hover" class="notice-card notice-card--warning">
          <div class="notice-card__icon"><i class="el-icon-reading"></i></div>
          <div class="notice-card__info">
            <div class="notice-card__number">{{ stats.unread }}</div>
            <div class="notice-card__label">未读</div>
          </div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card shadow="hover" class="notice-card notice-card--success">
          <div class="notice-card__icon"><i class="el-icon-circle-check"></i></div>
          <div class="notice-card__info">
            <div class="notice-card__number">{{ stats.inbound }}</div>
            <div class="notice-card__label">进书通知</div>
          </div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card shadow="hover" class="notice-card notice-card--danger">
          <div class="notice-card__icon"><i class="el-icon-alarm-clock"></i></div>
          <div class="notice-card__info">
            <div class="notice-card__number">{{ stats.shortage }}</div>
            <div class="notice-card__label">缺书通知</div>
          </div>
        </el-card>
      </el-col>
    </el-row>

    <el-form :model="queryParams" size="small" :inline="true" label-width="68px">
      <el-form-item label="状态">
        <el-radio-group v-model="queryParams.readStatus" @change="handleQuery">
          <el-radio-button label="">全部</el-radio-button>
          <el-radio-button label="0">未读</el-radio-button>
          <el-radio-button label="1">已读</el-radio-button>
        </el-radio-group>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-check" size="mini" @click="handleMarkAllRead">全部标为已读</el-button>
      </el-form-item>
    </el-form>

    <el-table v-loading="loading" :data="noticeList" @row-click="handleRowClick" highlight-current-row border stripe>
      <el-table-column width="50">
        <template slot-scope="scope">
          <el-badge :is-dot="scope.row.readStatus === '0'" />
        </template>
      </el-table-column>
      <el-table-column label="通知标题" prop="noticeTitle" show-overflow-tooltip min-width="200">
        <template slot-scope="scope">
          <span :style="{ fontWeight: scope.row.readStatus === '0' ? 'bold' : 'normal' }">{{ scope.row.noticeTitle }}</span>
        </template>
      </el-table-column>
      <el-table-column label="类型" align="center" prop="bizType" width="120">
        <template slot-scope="scope">
          <el-tag size="mini" :type="getBizTypeTag(scope.row.bizType)">{{ getBizTypeLabel(scope.row.bizType) }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="关联单号" prop="bizId" width="150" show-overflow-tooltip />
      <el-table-column label="发送时间" align="center" prop="createTime" width="160" />
      <el-table-column label="操作" align="center" width="100">
        <template slot-scope="scope">
          <el-button size="mini" type="text" v-if="scope.row.readStatus === '0'" @click.stop="handleMarkRead(scope.row)">标记已读</el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />

    <el-dialog title="通知详情" :visible.sync="detailOpen" width="600px" append-to-body>
      <el-descriptions :column="1" border>
        <el-descriptions-item label="标题">{{ currentNotice.noticeTitle }}</el-descriptions-item>
        <el-descriptions-item label="类型">
          <el-tag :type="getBizTypeTag(currentNotice.bizType)">{{ getBizTypeLabel(currentNotice.bizType) }}</el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="关联单号">{{ currentNotice.bizId }}</el-descriptions-item>
        <el-descriptions-item label="时间">{{ currentNotice.createTime }}</el-descriptions-item>
        <el-descriptions-item label="内容" :span="2">
          <div style="line-height: 1.8; padding: 10px; background: #f5f7fa; border-radius: 4px;">{{ currentNotice.noticeContent || '-' }}</div>
        </el-descriptions-item>
      </el-descriptions>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="detailOpen = false">关 闭</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { listNotice, markAsRead, markAllAsRead } from "@/api/textbook/notice";

export default {
  name: "WarehouseNotice",
  data() {
    return {
      loading: true,
      total: 0,
      noticeList: [],
      detailOpen: false,
      currentNotice: {},
      stats: { total: 0, unread: 0, inbound: 0, shortage: 0 },
      queryParams: { pageNum: 1, pageSize: 10, readStatus: '' }
    };
  },
  created() {
    this.getList();
  },
  methods: {
    getList() {
      this.loading = true;
      listNotice(this.queryParams).then(response => {
        this.noticeList = response.rows;
        this.total = response.total;
        const rows = response.rows || [];
        this.stats.total = response.total;
        this.stats.unread = rows.filter(n => n.readStatus === '0').length;
        this.stats.inbound = rows.filter(n => n.bizType === '3').length;
        this.stats.shortage = rows.filter(n => n.bizType === '4').length;
        this.loading = false;
      });
    },
    handleQuery() {
      this.queryParams.pageNum = 1;
      this.getList();
    },
    handleMarkAllRead() {
      const ids = this.noticeList.filter(n => n.readStatus === '0').map(n => n.noticeId);
      if (ids.length === 0) return;
      this.$confirm('确认将所有未读通知标记为已读?', '提示', { confirmButtonText: '确定', cancelButtonText: '取消', type: 'info' }).then(() => {
        markAllAsRead().then(() => {
          this.$modal.msgSuccess("操作成功");
          this.getList();
        });
      });
    },
    handleMarkRead(row) {
      markAsRead(row.noticeId).then(() => {
        row.readStatus = '1';
        this.stats.unread--;
      });
    },
    handleRowClick(row) {
      if (row.readStatus === '0') {
        this.handleMarkRead(row);
      }
      this.currentNotice = row;
      this.detailOpen = true;
    },
    getBizTypeTag(type) {
      const map = { '1': 'success', '2': 'warning', '3': 'info', '4': 'danger', '5': 'primary', '6': 'danger', '7': 'success', '8': '', '9': 'warning' };
      return map[type] || '';
    },
    getBizTypeLabel(type) {
      const map = { '1': '领书单', '2': '采购单', '3': '入库单', '4': '缺书登记', '5': '供应商通知', '6': '库存预警', '7': '班级领书出库', '8': '领书通知发布', '9': '供应商发货' };
      return map[type] || type;
    }
  }
};
</script>

<style scoped>
.notice-card { cursor: default; }
.notice-card .el-card__body { display: flex; align-items: center; padding: 20px; }
.notice-card__icon { font-size: 32px; margin-right: 16px; color: #fff; width: 56px; height: 56px; border-radius: 12px; display: flex; align-items: center; justify-content: center; flex-shrink: 0; }
.notice-card--primary .notice-card__icon { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); }
.notice-card--warning .notice-card__icon { background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%); }
.notice-card--success .notice-card__icon { background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%); }
.notice-card--danger .notice-card__icon { background: linear-gradient(135deg, #ff6b6b 0%, #ee5a24 100%); }
.notice-card__number { font-size: 28px; font-weight: bold; color: #303133; line-height: 1.2; }
.notice-card__label { font-size: 13px; color: #909399; margin-top: 4px; }
</style>