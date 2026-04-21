<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="88px">
      <el-form-item label="盘点单号" prop="checkNo">
        <el-input v-model="queryParams.checkNo" placeholder="请输入盘点单号" clearable @keyup.enter.native="handleQuery" />
      </el-form-item>
      <el-form-item label="盘点状态" prop="status">
        <el-select v-model="queryParams.status" placeholder="请选择状态" clearable>
          <el-option v-for="dict in dict.type.textbook_check_status" :key="dict.value" :label="dict.label" :value="dict.value" />
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

    <el-table v-loading="loading" :data="checkList">
      <el-table-column label="盘点单号" align="center" prop="checkNo" />
      <el-table-column label="盘点范围" align="center" prop="checkScope" />
      <el-table-column label="教材数量" align="center" prop="bookCount" />
      <el-table-column label="差异数量" align="center" prop="diffCount" />
      <el-table-column label="状态" align="center" prop="status">
        <template slot-scope="scope">
          <dict-tag :options="dict.type.textbook_check_status" :value="scope.row.status" />
        </template>
      </el-table-column>
      <el-table-column label="创建时间" align="center" prop="createTime" width="180" />
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template slot-scope="scope">
          <el-button size="mini" type="text" icon="el-icon-view" @click="handleView(scope.row)" v-hasPermi="['textbook:inventoryCheck:query']">详情</el-button>
          <el-button size="mini" type="text" icon="el-icon-edit" @click="handleStart(scope.row)" v-if="scope.row.status === '0'" v-hasPermi="['textbook:inventoryCheck:edit']">开始盘点</el-button>
          <el-button size="mini" type="text" icon="el-icon-check" @click="handleFinish(scope.row)" v-if="scope.row.status === '1'" v-hasPermi="['textbook:inventoryCheck:edit']">完成盘点</el-button>
          <el-button size="mini" type="text" icon="el-icon-delete" @click="handleDelete(scope.row)" v-if="scope.row.status === '0'" v-hasPermi="['textbook:inventoryCheck:remove']">删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />
  </div>
</template>

<script>
import { listCheck, delCheck, startCheck, finishCheck } from '@/api/textbook/inventoryCheck'

export default {
  name: 'InventoryCheck',
  dicts: ['textbook_check_status'],
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
        status: null
      }
    }
  },
  created() {
    this.getList()
  },
  methods: {
    getList() {
      this.loading = true
      listCheck(this.queryParams).then(response => {
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
      this.$message.info('新建盘点功能开发中')
    },
    handleView(row) {
      this.$message.info('盘点详情功能开发中')
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
      this.$modal.confirm('是否确认完成盘点？将生成库存调整记录。').then(() => {
        return finishCheck(row.checkId)
      }).then(() => {
        this.getList()
        this.$modal.msgSuccess('盘点已完成')
      }).catch(() => {})
    },
    handleDelete(row) {
      this.$modal.confirm('是否确认删除盘点单？').then(() => {
        return delCheck(row.checkId)
      }).then(() => {
        this.getList()
        this.$modal.msgSuccess('删除成功')
      }).catch(() => {})
    }
  }
}
</script>
