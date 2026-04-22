<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="88px">
      <el-form-item label="盘点单号" prop="checkNo">
        <el-input v-model="queryParams.checkNo" placeholder="请输入盘点单号" clearable @keyup.enter.native="handleQuery" />
      </el-form-item>
      <el-form-item label="盘点状态" prop="checkStatus">
        <el-select v-model="queryParams.checkStatus" placeholder="请选择状态" clearable>
          <el-option label="待执行" value="0" />
          <el-option label="进行中" value="1" />
          <el-option label="已完成" value="2" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button type="primary" plain icon="el-icon-plus" size="mini" @click="handleAdd" v-hasPermi="['textbook:inventoryCheck:add']">新建盘点</el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="checkList" border stripe>
      <el-table-column label="盘点单号" align="center" prop="checkNo" width="200" />
      <el-table-column label="盘点项目数" align="center" prop="totalItems" width="120" />
      <el-table-column label="已盘项目数" align="center" prop="checkedItems" width="120" />
      <el-table-column label="差异数" align="center" prop="diffItems" width="100" />
      <el-table-column label="差异金额" align="center" prop="totalDiffAmount" width="120" />
      <el-table-column label="状态" align="center" prop="checkStatus" width="100">
        <template slot-scope="scope">
          <el-tag v-if="scope.row.checkStatus === '0'" type="info">待执行</el-tag>
          <el-tag v-else-if="scope.row.checkStatus === '1'" type="warning">进行中</el-tag>
          <el-tag v-else-if="scope.row.checkStatus === '2'" type="success">已完成</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="创建时间" align="center" prop="createTime" width="160" />
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width" width="280">
        <template slot-scope="scope">
          <el-button size="mini" type="text" icon="el-icon-view" @click="handleView(scope.row)" v-hasPermi="['textbook:inventoryCheck:query']">详情</el-button>
          <el-button size="mini" type="text" icon="el-icon-video-play" @click="handleStart(scope.row)" v-if="scope.row.checkStatus === '0'" v-hasPermi="['textbook:inventoryCheck:edit']">开始盘点</el-button>
          <el-button size="mini" type="text" icon="el-icon-circle-check" @click="handleFinish(scope.row)" v-if="scope.row.checkStatus === '1'" v-hasPermi="['textbook:inventoryCheck:edit']">完成盘点</el-button>
          <el-button size="mini" type="text" icon="el-icon-delete" @click="handleDelete(scope.row)" v-if="scope.row.checkStatus === '0'" v-hasPermi="['textbook:inventoryCheck:remove']">删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />

    <el-dialog title="新建盘点任务" :visible.sync="addOpen" width="500px" append-to-body :close-on-click-modal="false">
      <el-form ref="addForm" :model="addForm" :rules="addRules" label-width="100px">
        <el-form-item label="备注" prop="remark">
          <el-input v-model="addForm.remark" type="textarea" :rows="3" placeholder="可选填写备注信息" />
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitAdd" :loading="addLoading">确 定</el-button>
        <el-button @click="addOpen = false">取 消</el-button>
      </div>
    </el-dialog>

    <el-dialog title="盘点详情" :visible.sync="detailOpen" width="900px" append-to-body>
      <el-descriptions :column="3" border size="small" style="margin-bottom: 15px;">
        <el-descriptions-item label="盘点单号">{{ currentCheck.checkNo }}</el-descriptions-item>
        <el-descriptions-item label="状态">
          <el-tag v-if="currentCheck.checkStatus === '0'" type="info">待执行</el-tag>
          <el-tag v-else-if="currentCheck.checkStatus === '1'" type="warning">进行中</el-tag>
          <el-tag v-else-if="currentCheck.checkStatus === '2'" type="success">已完成</el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="创建时间">{{ currentCheck.createTime }}</el-descriptions-item>
        <el-descriptions-item label="盘点项目数">{{ currentCheck.totalItems || 0 }}</el-descriptions-item>
        <el-descriptions-item label="已盘项目数">{{ currentCheck.checkedItems || 0 }}</el-descriptions-item>
        <el-descriptions-item label="差异数量">{{ currentCheck.diffItems || 0 }}</el-descriptions-item>
        <el-descriptions-item label="差异金额">{{ currentCheck.totalDiffAmount || 0 }}</el-descriptions-item>
        <el-descriptions-item label="备注">{{ currentCheck.remark || '-' }}</el-descriptions-item>
      </el-descriptions>
      <el-table :data="detailList" border stripe size="small" max-height="400" v-loading="detailLoading">
        <el-table-column label="教材名称" prop="book_name" show-overflow-tooltip />
        <el-table-column label="ISBN" prop="isbn" width="140" />
        <el-table-column label="存放位置" prop="location" width="120" />
        <el-table-column label="账面数量" prop="book_quantity" width="90" align="center" />
        <el-table-column label="实盘数量" prop="actual_quantity" width="90" align="center" />
        <el-table-column label="差异数量" prop="diff_quantity" width="90" align="center">
          <template slot-scope="scope">
            <span :style="{ color: scope.row.diff_quantity > 0 ? '#67C23A' : scope.row.diff_quantity < 0 ? '#F56C6C' : '' }">{{ scope.row.diff_quantity || 0 }}</span>
          </template>
        </el-table-column>
        <el-table-column label="差异金额" prop="diff_amount" width="100" align="center" />
        <el-table-column label="盘点结果" prop="check_result" width="90" align="center">
          <template slot-scope="scope">
            <el-tag v-if="scope.row.check_result === '0'" type="success" size="mini">一致</el-tag>
            <el-tag v-else-if="scope.row.check_result === '1'" type="warning" size="mini">盘盈</el-tag>
            <el-tag v-else-if="scope.row.check_result === '2'" type="danger" size="mini">盘亏</el-tag>
          </template>
        </el-table-column>
      </el-table>
      <div slot="footer" class="dialog-footer">
        <el-button @click="detailOpen = false">关 闭</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { listInventoryCheck, addInventoryCheck, getInventoryCheck, startCheck, completeCheck, delInventoryCheck } from '@/api/textbook/inventoryCheck'

export default {
  name: 'InventoryCheck',
  data() {
    return {
      loading: true,
      showSearch: true,
      total: 0,
      checkList: [],
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        checkNo: null,
        checkStatus: null
      },
      addOpen: false,
      addLoading: false,
      addForm: { remark: '' },
      addRules: {},
      detailOpen: false,
      detailLoading: false,
      detailList: [],
      currentCheck: {}
    }
  },
  created() {
    this.getList()
  },
  methods: {
    getList() {
      this.loading = true
      listInventoryCheck(this.queryParams).then(response => {
        this.checkList = response.rows
        this.total = response.total
        this.loading = false
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
    handleAdd() {
      this.addForm = { remark: '' }
      this.addOpen = true
    },
    submitAdd() {
      this.addLoading = true
      addInventoryCheck(this.addForm).then(() => {
        this.$modal.msgSuccess('盘点任务创建成功')
        this.addOpen = false
        this.getList()
      }).finally(() => {
        this.addLoading = false
      })
    },
    handleView(row) {
      this.currentCheck = row
      this.detailLoading = true
      this.detailOpen = true
      getInventoryCheck(row.checkId).then(response => {
        this.currentCheck = response.data || row
        this.detailList = response.data && response.data.details ? response.data.details : []
        this.detailLoading = false
      }).catch(() => {
        this.detailList = []
        this.detailLoading = false
      })
    },
    handleStart(row) {
      this.$modal.confirm('是否确认开始盘点？').then(() => {
        return startCheck(row.checkId)
      }).then(() => {
        this.getList()
        this.$modal.msgSuccess('盘点已开始')
      }).catch(() => {})
    },
    handleFinish(row) {
      this.$modal.confirm('是否确认完成盘点？将自动计算盘点差异。').then(() => {
        return completeCheck(row.checkId)
      }).then(() => {
        this.getList()
        this.$modal.msgSuccess('盘点已完成')
      }).catch(() => {})
    },
    handleDelete(row) {
      this.$modal.confirm('是否确认删除该盘点单？').then(() => {
        return delInventoryCheck(row.checkId)
      }).then(() => {
        this.getList()
        this.$modal.msgSuccess('删除成功')
      }).catch(() => {})
    }
  }
}
</script>
