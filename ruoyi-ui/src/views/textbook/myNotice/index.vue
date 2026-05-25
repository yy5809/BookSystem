<template>
  <div class="app-container">
    <el-row :gutter="20" class="mb20">
      <el-col :span="6">
        <div class="stat-card stat-card-primary">
          <i class="el-icon-bell stat-icon"></i>
          <div class="stat-info">
            <div class="stat-num">{{ stats.total }}</div>
            <div class="stat-label">全部通知</div>
          </div>
        </div>
      </el-col>
      <el-col :span="6">
        <div class="stat-card stat-card-warning">
          <i class="el-icon-reading stat-icon"></i>
          <div class="stat-info">
            <div class="stat-num">{{ stats.unread }}</div>
            <div class="stat-label">未读</div>
          </div>
        </div>
      </el-col>
      <el-col :span="6">
        <div class="stat-card stat-card-success">
          <i class="el-icon-circle-check stat-icon"></i>
          <div class="stat-info">
            <div class="stat-num">{{ stats.approved }}</div>
            <div class="stat-label">审核通过</div>
          </div>
        </div>
      </el-col>
      <el-col :span="6">
        <div class="stat-card stat-card-danger">
          <i class="el-icon-circle-close stat-icon"></i>
          <div class="stat-info">
            <div class="stat-num">{{ stats.rejected }}</div>
            <div class="stat-label">审核驳回</div>
          </div>
        </div>
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

    <el-table v-loading="loading" :data="noticeList" border stripe @row-click="handleRowClick" highlight-current-row style="width:100%">
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
      <el-table-column label="类型" align="center" width="80">
        <template slot-scope="scope">
          <el-tag size="mini" :type="noticeTypeTag(scope.row.noticeType)">{{ noticeTypeLabel(scope.row.noticeType) }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="发送时间" align="center" prop="createTime" width="170" />
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width" width="80">
        <template slot-scope="scope">
          <el-button size="mini" type="text" v-if="scope.row.readStatus === '0'" @click.stop="handleMarkRead(scope.row)">标记已读</el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />

    <el-dialog title="通知详情" :visible.sync="open" width="550px" append-to-body>
      <div v-if="currentNotice.noticeId">
        <h3 style="margin: 0 0 10px 0;">{{ currentNotice.noticeTitle }}</h3>
        <p style="color: #909399; margin: 0 0 15px 0;">{{ currentNotice.createTime }}</p>
        <div style="line-height: 1.8; padding: 10px; background: #f5f7fa; border-radius: 4px;">{{ currentNotice.noticeContent || '-' }}</div>
      </div>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="open = false">关 闭</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { listNotice, markAsRead, markAllAsRead } from "@/api/textbook/notice";

export default {
  name: "MyNotice",
  data() {
    return {
      loading: true,
      total: 0,
      noticeList: [],
      open: false,
      currentNotice: {},
      stats: { total: 0, unread: 0, approved: 0, rejected: 0 },
      queryParams: { pageNum: 1, pageSize: 10, readStatus: '' }
    }
  },
  created() {
    this.getList()
  },
  methods: {
    getList() {
      this.loading = true
      listNotice(this.queryParams).then(response => {
        this.noticeList = response.rows
        this.total = response.total
        const rows = response.rows || []
        this.stats.total = response.total
        this.stats.unread = rows.filter(n => n.readStatus === '0').length
        this.stats.approved = rows.filter(n => n.bizType === '1' && n.noticeTitle && n.noticeTitle.includes('通过')).length
        this.stats.rejected = rows.filter(n => n.bizType === '1' && n.noticeTitle && n.noticeTitle.includes('驳回')).length
        this.loading = false
      })
    },
    handleQuery() {
      this.queryParams.pageNum = 1
      this.getList()
    },
    handleMarkAllRead() {
      if (this.stats.unread === 0) return
      this.$modal.confirm('确认将所有未读通知标记为已读?').then(() => {
        return markAllAsRead()
      }).then(() => {
        this.$modal.msgSuccess("操作成功")
        this.getList()
      }).catch(() => {})
    },
    handleMarkRead(row) {
      markAsRead(row.noticeId).then(() => {
        row.readStatus = '1'
        this.stats.unread--
      })
    },
    handleRowClick(row) {
      if (row.readStatus === '0') { this.handleMarkRead(row) }
      this.currentNotice = row
      this.open = true
    },
    noticeTypeTag(type) {
      const m = { '1': '', '2': 'warning', '3': 'success', '4': 'danger', '5': 'info' }
      return m[type] || ''
    },
    noticeTypeLabel(type) {
      const m = { '1': '领书单', '2': '采购单', '3': '入库单', '4': '缺书登记', '5': '其他' }
      return m[type] || type
    }
  }
}
</script>

<style scoped>
.app-container { overflow-x: auto; }
.stat-card { display: flex; align-items: center; padding: 16px; border-radius: 4px; cursor: default; }
.stat-card-primary { background: #ecf0fe; }
.stat-card-warning { background: #fdf6ec; }
.stat-card-success { background: #eaf8f2; }
.stat-card-danger { background: #fef0f0; }
.stat-card-primary .stat-icon { color: #409EFF; }
.stat-card-warning .stat-icon { color: #E6A23C; }
.stat-card-success .stat-icon { color: #67C23A; }
.stat-card-danger .stat-icon { color: #F56C6C; }
.stat-icon { font-size: 30px; margin-right: 14px; }
.stat-info { flex: 1; }
.stat-num { font-size: 26px; font-weight: bold; color: #303133; line-height: 1.2; }
.stat-label { font-size: 13px; color: #909399; margin-top: 4px; }
.mb20 { margin-bottom: 20px; }
</style>
