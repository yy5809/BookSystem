<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="ISBN" prop="isbn">
        <el-input v-model="queryParams.isbn" placeholder="请输入ISBN" clearable @keyup.enter.native="handleQuery" />
      </el-form-item>
      <el-form-item label="业务类型" prop="businessType">
        <el-select v-model="queryParams.businessType" placeholder="请选择" clearable>
          <el-option v-for="dict in dict.type.tb_stock_flow_type" :key="dict.value" :label="dict.label" :value="dict.value" />
        </el-select>
      </el-form-item>
      <el-form-item label="关联单号" prop="businessNo">
        <el-input v-model="queryParams.businessNo" placeholder="请输入关联单号" clearable @keyup.enter.native="handleQuery" />
      </el-form-item>
      <el-form-item label="操作时间">
        <el-date-picker v-model="dateRange" style="width: 240px" value-format="yyyy-MM-dd" type="daterange"
          range-separator="-" start-placeholder="开始日期" end-placeholder="结束日期"></el-date-picker>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-table v-loading="loading" :data="flowList">
      <el-table-column type="index" label="序号" align="center" width="55" />
      <el-table-column label="教材ISBN" align="center" prop="isbn" width="140" />
      <el-table-column label="业务类型" align="center" prop="businessType" width="120">
        <template slot-scope="scope">
          <dict-tag :options="dict.type.tb_stock_flow_type" :value="scope.row.businessType" />
        </template>
      </el-table-column>
      <el-table-column label="关联单号" align="center" prop="businessNo" width="180" />
      <el-table-column label="变动数量" align="center" prop="changeQty" width="100">
        <template slot-scope="scope">
          <span :style="{ color: scope.row.changeQty > 0 ? '#67C23A' : '#F56C6C', fontWeight: 'bold' }">
            {{ scope.row.changeQty > 0 ? '+' : '' }}{{ scope.row.changeQty }}
          </span>
        </template>
      </el-table-column>
      <el-table-column label="变动前库存" align="center" prop="stockBefore" width="110" />
      <el-table-column label="变动后库存" align="center" prop="stockAfter" width="110" />
      <el-table-column label="操作人" align="center" prop="operator" width="100" />
      <el-table-column label="操作时间" align="center" prop="operateTime" width="160" />
    </el-table>

    <pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />
  </div>
</template>

<script>
import { listStockFlow } from "@/api/textbook/stockFlow";

export default {
  name: "StockFlow",
  dicts: ['tb_stock_flow_type'],
  data() {
    return {
      loading: true,
      total: 0,
      flowList: [],
      showSearch: true,
      dateRange: [],
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        isbn: null,
        businessType: null,
        businessNo: null
      }
    };
  },
  created() {
    this.getList();
  },
  methods: {
    getList() {
      this.loading = true;
      listStockFlow(this.addDateRange(this.queryParams, this.dateRange)).then(response => {
        this.flowList = response.rows;
        this.total = response.total;
        this.loading = false;
      });
    },
    handleQuery() {
      this.queryParams.pageNum = 1;
      this.getList();
    },
    resetQuery() {
      this.dateRange = [];
      this.resetForm("queryForm");
      this.handleQuery();
    }
  }
};
</script>
