<template>
  <div class="supplier-notice">
    <el-card>
      <template slot="header">
        <span>通知中心</span>
        <el-button type="primary" size="small" @click="markAllAsRead" style="margin-left: 20px">全部标记为已读</el-button>
      </template>
      
      <el-table v-loading="loading" :data="noticeList" style="width: 100%" border stripe>
        <el-table-column label="状态" width="80">
          <template slot-scope="scope">
            <el-tag type="danger" v-if="scope.row.status === '0'">未读</el-tag>
            <el-tag type="success" v-else>已读</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="title" label="标题">
          <template slot-scope="scope">
            <span :class="{ 'unread': scope.row.status === '0' }" @click="viewNotice(scope.row)">
              {{ scope.row.title }}
            </span>
          </template>
        </el-table-column>
        <el-table-column prop="createTime" label="创建时间" width="180"></el-table-column>
        <el-table-column label="操作" width="100">
          <template slot-scope="scope">
            <el-button type="text" @click="viewNotice(scope.row)">查看</el-button>
          </template>
        </el-table-column>
      </el-table>
      
      <pagination
        v-show="total > 0"
        :total="total"
        :page.sync="queryParams.pageNum"
        :limit.sync="queryParams.pageSize"
        @pagination="getList"
      />
    </el-card>
    
    <!-- 通知详情对话框 -->
    <el-dialog title="通知详情" :visible.sync="noticeDialogVisible" width="600px" :close-on-click-modal="false">
      <div class="notice-detail">
        <h3>{{ currentNotice.title }}</h3>
        <p class="notice-time">{{ currentNotice.createTime }}</p>
        <div v-if="currentNotice.bizType === '5'" class="notice-biz-info">
          <el-descriptions :column="1" border size="small">
            <el-descriptions-item label="业务类型">进书确认</el-descriptions-item>
          </el-descriptions>
        </div>
        <div class="notice-content" style="white-space: pre-wrap;">{{ escapeHtml(currentNotice.content) }}</div>
      </div>
      <div slot="footer" class="dialog-footer">
        <el-button @click="noticeDialogVisible = false">关闭</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { listSupplierNotices, getSupplierNoticeDetail, markNoticeAsRead, markAllNoticesAsRead } from '@/api/textbook/supplier'

export default {
  name: 'SupplierNoticeList',
  data() {
    return {
      loading: false,
      noticeList: [],
      total: 0,
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        status: undefined
      },
      noticeDialogVisible: false,
      currentNotice: {}
    }
  },
  created() {
    this.getList()
  },
  methods: {
    getList() {
      this.loading = true
      listSupplierNotices(this.queryParams).then(response => {
        this.noticeList = response.rows
        this.total = response.total
        this.loading = false
      }).catch(() => {
        this.loading = false
      })
    },
    viewNotice(notice) {
      // 标记为已读
      if (notice.status === '0') {
        markNoticeAsRead(notice.noticeId).then(() => {
          notice.status = '1'
        })
      }
      // 查看详情
      getSupplierNoticeDetail(notice.noticeId).then(response => {
        this.currentNotice = response
        this.noticeDialogVisible = true
      })
    },
    markAllAsRead() {
      markAllNoticesAsRead().then(response => {
        this.$message.success('全部标记为已读成功')
        this.getList()
      })
    },
    escapeHtml(text) {
      if (!text) return ''
      const div = document.createElement('div')
      div.textContent = text
      return div.innerHTML
    }
  }
}
</script>

<style scoped>
.supplier-notice {
  padding: 20px;
}

.unread {
  font-weight: bold;
  color: #303133;
}

.notice-detail {
  padding: 20px 0;
}

.notice-time {
  color: #909399;
  margin: 10px 0 20px;
}

.notice-content {
  line-height: 1.6;
  color: #303133;
}
</style>