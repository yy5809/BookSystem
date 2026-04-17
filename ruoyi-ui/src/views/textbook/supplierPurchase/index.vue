<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="采购单号" prop="purchaseNo">
        <el-input v-model="queryParams.purchaseNo" placeholder="请输入采购单号" clearable @keyup.enter.native="handleQuery" />
      </el-form-item>
      <el-form-item label="状态" prop="status">
        <el-select v-model="queryParams.status" placeholder="请选择状态" clearable>
          <el-option v-for="dict in dict.type.tb_purchase_status" :key="dict.value" :label="dict.label" :value="dict.value" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-table v-loading="loading" :data="purchaseList">
      <el-table-column label="采购单号" align="center" prop="purchaseNo" width="200" />
      <el-table-column label="教材名称" align="center" prop="bookName" show-overflow-tooltip />
      <el-table-column label="ISBN" align="center" prop="isbn" width="140" />
      <el-table-column label="采购数量" align="center" prop="quantity" width="90" />
      <el-table-column label="单价" align="center" prop="unitPrice" width="80">
        <template slot-scope="scope">
          ¥{{ scope.row.unitPrice }}
        </template>
      </el-table-column>
      <el-table-column label="总金额" align="center" width="100">
        <template slot-scope="scope">
          <span style="font-weight: bold; color: #E6A23C;">¥{{ (scope.row.quantity * scope.row.unitPrice).toFixed(2) }}</span>
        </template>
      </el-table-column>
      <el-table-column label="状态" align="center" prop="status" width="90">
        <template slot-scope="scope">
          <dict-tag :options="dict.type.tb_purchase_status" :value="scope.row.status" />
        </template>
      </el-table-column>
      <el-table-column label="创建时间" align="center" prop="createTime" width="160" />
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width" width="150">
        <template slot-scope="scope">
          <el-button size="mini" type="text" icon="el-icon-view" @click="handleView(scope.row)">详情</el-button>
          <el-button size="mini" type="text" icon="el-icon-s-promotion" @click="handleShip(scope.row)" v-if="scope.row.status === '1'" v-hasPermi="['textbook:supplierPurchase:ship']">确认发货</el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />

    <el-dialog title="确认发货" :visible.sync="shipOpen" width="500px" append-to-body>
      <el-alert title="请确认以下信息后点击确定完成发货操作" type="info" :closable="false" style="margin-bottom: 15px;" />
      <el-descriptions :column="1" border>
        <el-descriptions-item label="采购单号">{{ shipForm.purchaseNo }}</el-descriptions-item>
        <el-descriptions-item label="教材名称">{{ shipForm.bookName }}</el-descriptions-item>
        <el-descriptions-item label="ISBN">{{ shipForm.isbn }}</el-descriptions-item>
        <el-descriptions-item label="数量">{{ shipForm.quantity }}</el-descriptions-item>
      </el-descriptions>
      <el-form ref="shipFormRef" :model="shipForm" label-width="80px">
        <el-form-item label="物流单号" prop="trackingNo">
          <el-input v-model="shipForm.trackingNo" placeholder="可选，填写物流追踪单号" />
        </el-form-item>
        <el-form-item label="快递公司" prop="expressCompany">
          <el-select v-model="shipForm.expressCompany" placeholder="可选，选择快递公司" filterable allow-create clearable>
            <el-option label="顺丰速运" value="SF" />
            <el-option label="中通快递" value="ZTO" />
            <el-option label="圆通速递" value="YTO" />
            <el-option label="韵达快递" value="YD" />
            <el-option label="申通快递" value="STO" />
            <el-option label="邮政EMS" value="EMS" />
            <el-option label="京东物流" value="JD" />
          </el-select>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitShip">确 认 发 货</el-button>
        <el-button @click="shipOpen = false">取 消</el-button>
      </div>
    </el-dialog>

    <el-dialog title="采购单详情" :visible.sync="viewOpen" width="650px" append-to-body>
      <el-descriptions :column="2" border>
        <el-descriptions-item label="采购单号" :span="2">{{ viewData.purchaseNo }}</el-descriptions-item>
        <el-descriptions-item label="状态">
          <dict-tag :options="dict.type.tb_purchase_status" :value="viewData.status" />
        </el-descriptions-item>
        <el-descriptions-item label="ISBN" :span="2">{{ viewData.isbn }}</el-descriptions-item>
        <el-descriptions-item label="教材名称" :span="2">{{ viewData.bookName }}</el-descriptions-item>
        <el-descriptions-item label="数量">{{ viewData.quantity }} 本</el-descriptions-item>
        <el-descriptions-item label="单价">¥{{ viewData.unitPrice }}</el-descriptions-item>
        <el-descriptions-item label="总金额" :span="2">
          <span style="font-weight: bold; color: #E6A23C; font-size: 16px;">¥{{ ((viewData.quantity || 0) * (viewData.unitPrice || 0)).toFixed(2) }}</span>
        </el-descriptions-item>
        <el-descriptions-item label="创建时间">{{ viewData.createTime }}</el-descriptions-item>
        <el-descriptions-item label="备注" :span="2">{{ viewData.remark || '-' }}</el-descriptions-item>
      </el-descriptions>
      <div slot="footer" class="dialog-footer">
        <el-button @click="viewOpen = false">关 闭</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { listPurchase, updatePurchase } from "@/api/textbook/purchase";

export default {
  name: "SupplierPurchase",
  dicts: ['tb_purchase_status'],
  data() {
    return {
      loading: true,
      total: 0,
      purchaseList: [],
      showSearch: true,
      shipOpen: false,
      viewOpen: false,
      shipForm: {},
      viewData: {},
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        purchaseNo: null,
        status: null
      }
    };
  },
  created() {
    this.getList();
  },
  methods: {
    getList() {
      this.loading = true;
      this.queryParams.supplierId = this.$store.state.user.userId;
      listPurchase(this.queryParams).then(response => {
        this.purchaseList = response.rows;
        this.total = response.total;
        this.loading = false;
      });
    },
    handleQuery() {
      this.queryParams.pageNum = 1;
      this.getList();
    },
    resetQuery() {
      this.resetForm("queryForm");
      this.handleQuery();
    },
    handleView(row) {
      this.viewData = row;
      this.viewOpen = true;
    },
    handleShip(row) {
      this.shipForm = { ...row };
      this.shipOpen = true;
    },
    submitShip() {
      const data = { ...this.shipForm, status: '2' };
      updatePurchase(data).then(response => {
        this.$modal.msgSuccess("已确认发货");
        this.shipOpen = false;
        this.getList();
      });
    }
  }
};
</script>
