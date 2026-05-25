<template>
  <div class="app-container">
    <el-table v-loading="loading" :data="noticeList" border stripe>
      <el-table-column label="状态" align="center" width="70">
        <template slot-scope="scope">
          <el-tag :type="scope.row.status === '0' ? 'danger' : 'success'" size="mini">{{ scope.row.status === '0' ? '未读' : '已读' }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="标题" align="center" prop="title" min-width="200" show-overflow-tooltip>
        <template slot-scope="scope">
          <span :style="{ fontWeight: scope.row.status === '0' ? 'bold' : 'normal', cursor: 'pointer' }" @click="handleView(scope.row)">{{ scope.row.title }}</span>
        </template>
      </el-table-column>
      <el-table-column label="创建时间" align="center" prop="createTime" width="160" />
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width" width="80">
        <template slot-scope="scope">
          <el-button size="mini" type="text" icon="el-icon-view" @click="handleView(scope.row)">查看</el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />

    <el-dialog title="通知详情" :visible.sync="open" width="550px" append-to-body>
      <div v-if="currentNotice.noticeId">
        <h3 style="margin: 0 0 10px 0;">{{ currentNotice.title }}</h3>
        <p style="color: #909399; margin: 0 0 15px 0;">{{ currentNotice.createTime }}</p>
        <div style="white-space: pre-wrap; line-height: 1.6; color: #303133;">{{ currentNotice.content }}</div>
      </div>
      <div slot="footer" class="dialog-footer">
        <el-button @click="open = false">关 闭</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { listSupplierNotices, getSupplierNoticeDetail, markNoticeAsRead, markAllNoticesAsRead } from '@/api/textbook/supplier'

export default {
  name: "SupplierNoticeList",
  data() {
    return {
      loading: true,
      total: 0,
      noticeList: [],
      open: false,
      currentNotice: {},
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        status: undefined
      }
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
      }).catch(() => { this.loading = false })
    },
    handleView(notice) {
      if (notice.status === '0') {
        markNoticeAsRead(notice.noticeId).then(() => { notice.status = '1' })
      }
      getSupplierNoticeDetail(notice.noticeId).then(response => {
        this.currentNotice = response
        this.open = true
      })
    }
  }
}
</script>

<style scoped>
.app-container { overflow-x: auto; }
</style>
