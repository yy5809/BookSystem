<template>
  <div class="app-container">
    <el-row :gutter="20">
      <el-col :span="24">
        <el-card class="box-card">
          <div slot="header" class="clearfix">
            <span>通知管理</span>
            <el-button style="float: right; padding: 3px 0" type="text" @click="markAllRead">
              全部标记已读
            </el-button>
            <el-badge :value="unreadCount" :max="99" class="notification-badge" style="float: right; margin-right: 20px;">
              <span>未读消息</span>
            </el-badge>
          </div>

          <el-form :model="queryParams" ref="queryForm" :inline="true" label-width="68px" size="small">
            <el-form-item label="通知标题" prop="noticeTitle">
              <el-input v-model="queryParams.noticeTitle" placeholder="请输入通知标题" clearable @keyup.enter.native="handleQuery"/>
            </el-form-item>
            <el-form-item label="业务类型" prop="bizType">
              <el-select v-model="queryParams.bizType" placeholder="请选择业务类型" clearable>
                <el-option label="领书单" value="1"/>
                <el-option label="采购单" value="2"/>
                <el-option label="入库单" value="3"/>
                <el-option label="缺书登记" value="4"/>
                <el-option label="供应商通知" value="5"/>
                <el-option label="库存预警" value="6"/>
              </el-select>
            </el-form-item>
            <el-form-item label="阅读状态" prop="readStatus">
              <el-select v-model="queryParams.readStatus" placeholder="请选择阅读状态" clearable>
                <el-option label="未读" value="0"/>
                <el-option label="已读" value="1"/>
              </el-select>
            </el-form-item>
            <el-form-item>
              <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
              <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
            </el-form-item>
          </el-form>

          <el-table v-loading="loading" :data="noticeList" border stripe @selection-change="handleSelectionChange">
            <el-table-column type="selection" width="55" align="center"/>
            <el-table-column label="通知ID" align="center" prop="noticeId" width="80"/>
            <el-table-column label="标题" align="center" prop="noticeTitle" :show-overflow-tooltip="true" min-width="150"/>
            <el-table-column label="业务类型" align="center" prop="bizType" width="120">
              <template slot-scope="scope">
                <el-tag :type="getBizTypeTag(scope.row.bizType)">{{ getBizTypeName(scope.row.bizType) }}</el-tag>
              </template>
            </el-table-column>
            <el-table-column label="阅读状态" align="center" prop="readStatus" width="100">
              <template slot-scope="scope">
                <el-tag :type="scope.row.readStatus === '0' ? 'danger' : 'success'">
                  {{ scope.row.readStatus === '0' ? '未读' : '已读' }}
                </el-tag>
              </template>
            </el-table-column>
            <el-table-column label="创建时间" align="center" prop="createTime" width="160">
              <template slot-scope="scope">
                <span>{{ parseTime(scope.row.createTime, '{y}-{m}-{d} {h}:{i}:{s}') }}</span>
              </template>
            </el-table-column>
            <el-table-column label="操作" align="center" class-name="small-padding fixed-width" width="200">
              <template slot-scope="scope">
                <el-button size="mini" type="text" icon="el-icon-view" @click="handleView(scope.row)">查看</el-button>
                <el-button
                  v-if="scope.row.readStatus === '0'"
                  size="mini"
                  type="text"
                  icon="el-icon-check"
                  @click="handleMarkRead(scope.row)"
                >标记已读</el-button>
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
      </el-col>
    </el-row>

    <el-dialog title="通知详情" :visible.sync="open" width="700px" append-to-body>
      <div class="notice-detail">
        <h3>{{ form.noticeTitle }}</h3>
        <el-divider></el-divider>
        <div class="notice-meta">
          <el-descriptions :column="2" border>
            <el-descriptions-item label="业务类型">{{ getBizTypeName(form.bizType) }}</el-descriptions-item>
            <el-descriptions-item label="阅读状态">
              <el-tag :type="form.readStatus === '0' ? 'danger' : 'success'">
                {{ form.readStatus === '0' ? '未读' : '已读' }}
              </el-tag>
            </el-descriptions-item>
            <el-descriptions-item label="创建时间">{{ parseTime(form.createTime) }}</el-descriptions-item>
          </el-descriptions>
        </div>
        <div class="notice-content">
          <pre>{{ form.noticeContent }}</pre>
        </div>
      </div>
      <div slot="footer" class="dialog-footer">
        <el-button v-if="form.readStatus === '0'" type="primary" @click="handleMarkReadAndClose">标记为已读并关闭</el-button>
        <el-button @click="open = false">关 闭</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { listNotice, getUnreadCount, markAsRead, batchMarkAsRead, markAllAsRead } from '@/api/textbook/notice'

export default {
  name: 'TbNotice',
  data() {
    return {
      loading: true,
      ids: [],
      unreadCount: 0,
      noticeList: [],
      total: 0,
      open: false,
      form: {},
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        noticeTitle: undefined,
        bizType: undefined,
        readStatus: undefined
      }
    }
  },
  created() {
    this.getList()
    this.getUnreadCount()
  },
  methods: {
    getList() {
      this.loading = true
      listNotice(this.queryParams).then(response => {
        this.noticeList = response.rows
        this.total = response.total
        this.loading = false
        this.getUnreadCount()
      })
    },

    getUnreadCount() {
      getUnreadCount().then(response => {
        this.unreadCount = response.data
      })
    },

    handleQuery() {
      this.queryParams.pageNum = 1
      this.getList()
    },

    resetQuery() {
      this.resetForm('queryForm')
      this.handleQuery()
    },

    handleSelectionChange(selection) {
      this.ids = selection.map(item => item.noticeId)
    },

    handleView(row) {
      this.form = row
      this.open = true
    },

    async handleMarkRead(row) {
      await markAsRead(row.noticeId)
      this.$message.success('标记成功')
      this.getList()
    },

    async handleMarkReadAndClose() {
      if (this.form.noticeId) {
        await markAsRead(this.form.noticeId)
        this.$message.success('标记成功')
        this.open = false
        this.getList()
      }
    },

    async markAllRead() {
      const confirmResult = await this.$confirm('确定将所有通知标记为已读吗？', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).catch(() => null)

      if (confirmResult === 'confirm') {
        await markAllAsRead()
        this.$message.success('全部标记成功')
        this.getList()
      }
    },

    getBizTypeName(bizType) {
      const map = {
        '1': '领书单',
        '2': '采购单',
        '3': '入库单',
        '4': '缺书登记',
        '5': '供应商通知',
        '6': '库存预警'
      }
      return map[bizType] || '未知'
    },

    getBizTypeTag(bizType) {
      const map = {
        '1': '',
        '2': 'warning',
        '3': 'success',
        '4': 'danger',
        '5': 'info',
        '6': 'danger'
      }
      return map[bizType] || ''
    }
  }
}
</script>

<style scoped>
.notification-badge {
  cursor: pointer;
}

.notice-detail h3 {
  margin: 0;
  color: #303133;
  font-size: 18px;
}

.notice-meta {
  margin-bottom: 20px;
}

.notice-content {
  background-color: #f5f7fa;
  padding: 15px;
  border-radius: 4px;
  min-height: 100px;
  max-height: 300px;
  overflow-y: auto;
}

.notice-content pre {
  white-space: pre-wrap;
  word-wrap: break-word;
  margin: 0;
  font-family: inherit;
  line-height: 1.6;
  color: #606266;
}
</style>
