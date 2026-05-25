<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="采购单号" prop="purchaseNo">
        <el-input v-model="queryParams.purchaseNo" placeholder="请输入采购单号" clearable @keyup.enter.native="handleQuery" />
      </el-form-item>
      <el-form-item label="采购状态" prop="purchaseStatus">
        <el-select v-model="queryParams.purchaseStatus" placeholder="请选择状态" clearable>
          <el-option label="已到货" value="4" />
          <el-option label="已入库" value="5" />
        </el-select>
      </el-form-item>
      <el-form-item label="入库时间">
        <el-date-picker v-model="dateRange" style="width: 240px" value-format="yyyy-MM-dd" type="daterange"
          range-separator="-" start-placeholder="开始日期" end-placeholder="结束日期"></el-date-picker>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-table v-loading="loading" :data="inboundList" border stripe style="width: 100%">
      <el-table-column type="index" label="#" align="center" width="45" />
      <el-table-column label="采购单号" align="center" prop="purchaseNo" min-width="180" show-overflow-tooltip />
      <el-table-column label="采购数量(TOTAL)" align="center" prop="buyNum" width="130" />
      <el-table-column label="采购状态" align="center" width="85">
        <template slot-scope="scope">
          <dict-tag :options="dict.type.tb_purchase_status" :value="scope.row.purchaseStatus" />
        </template>
      </el-table-column>
      <el-table-column label="创建时间" align="center" prop="createTime" width="170" />
      <el-table-column label="到货时间" align="center" prop="receiveTime" width="170" />
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width" min-width="150">
        <template slot-scope="scope">
          <el-button size="mini" type="text" icon="el-icon-view" @click="handleView(scope.row)" v-hasPermi="['textbook:inbound:query']">详情</el-button>
          <el-button size="mini" type="text" icon="el-icon-box-plug" @click="handleInbound(scope.row)" v-if="scope.row.purchaseStatus === '4'" v-hasPermi="['textbook:inbound:add']">确认入库</el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />

    <el-dialog title="采购单详情" :visible.sync="viewOpen" width="700px" append-to-body>
      <el-form :model="viewData" label-width="100px" size="small">
        <el-row :gutter="20">
          <el-col :span="12"><el-form-item label="采购单号"><el-input :value="viewData.purchaseNo" disabled /></el-form-item></el-col>
          <el-col :span="12"><el-form-item label="采购数量"><el-input :value="viewData.buyNum" disabled /></el-form-item></el-col>
        </el-row>
        <el-row :gutter="20">
          <el-col :span="12"><el-form-item label="经费来源"><el-input :value="viewData.fundingSource" disabled /></el-form-item></el-col>
          <el-col :span="12"><el-form-item label="采购状态"><dict-tag :options="dict.type.tb_purchase_status" :value="viewData.purchaseStatus" /></el-form-item></el-col>
        </el-row>
      </el-form>
      <el-card class="detail-card">
        <template slot="header"><span>采购明细</span></template>
        <el-table :data="viewDetails" border stripe style="width: 100%">
          <el-table-column label="ISBN" align="center" prop="isbn" width="130" />
          <el-table-column label="教材名称" align="center" prop="bookName" min-width="140" show-overflow-tooltip />
          <el-table-column label="作者" align="center" prop="author" width="90" show-overflow-tooltip />
          <el-table-column label="出版社" align="center" prop="publisher" width="120" show-overflow-tooltip />
          <el-table-column label="数量" align="center" prop="quantity" width="70" />
          <el-table-column label="供应商反馈" align="center" width="110">
            <template slot-scope="scope">
              <el-tag v-if="scope.row.supplierFeedback === '1'" type="success" size="mini">可供货</el-tag>
              <el-tag v-else-if="scope.row.supplierFeedback === '2'" type="danger" size="mini">⚠ 缺货-已跳过</el-tag>
              <el-tag v-else-if="scope.row.supplierFeedback === '3'" type="warning" size="mini">⚠ 有误-已跳过</el-tag>
              <span v-else style="color:#c0c4cc">未反馈</span>
            </template>
          </el-table-column>
        </el-table>
      </el-card>
      <div slot="footer"><el-button @click="viewOpen = false">关 闭</el-button></div>
    </el-dialog>
  </div>
</template>

<script>
import { listPurchase, getPurchase, confirmInbound } from "@/api/textbook/purchase";

export default {
  name: "TbInbound",
  dicts: ['tb_purchase_status'],
  data() {
    return {
      loading: true,
      total: 0,
      inboundList: [],
      showSearch: true,
      dateRange: [],
      viewOpen: false,
      viewData: {},
      viewDetails: [],
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        purchaseNo: null,
        purchaseStatus: null
      }
    };
  },
  created() {
    this.getList();
  },
  methods: {
    getList() {
      this.loading = true;
      const params = this.addDateRange(this.queryParams, this.dateRange);
      if (this.queryParams.purchaseStatus) {
        params.statusIn = [this.queryParams.purchaseStatus];
      } else {
        params.statusIn = ['4', '5'];
      }
      listPurchase(params).then(response => {
        this.inboundList = response.rows;
        this.total = response.total;
        this.loading = false;
      }).catch(() => { this.loading = false; });
    },
    handleQuery() {
      this.queryParams.pageNum = 1;
      this.getList();
    },
    resetQuery() {
      this.dateRange = [];
      this.resetForm("queryForm");
      this.handleQuery();
    },
    handleView(row) {
      getPurchase(row.buyId).then(response => {
        this.viewData = response.data;
        this.viewDetails = response.data.details || [];
        this.viewOpen = true;
      });
    },
    handleInbound(row) {
      this.$modal.confirm('确认将采购单 ' + row.purchaseNo + ' 验收入库？库存将自动增加。').then(() => {
        return confirmInbound(row.buyId);
      }).then(() => {
        this.$modal.msgSuccess('已验收入库，库存已更新');
        this.getList();
      }).catch(() => {
        this.getList();
      });
    }
  }
};
</script>

<style scoped>
.detail-card { margin-top: 15px; }
.app-container { overflow-x: auto; }
.app-container .el-table { margin: 0; }
</style>
