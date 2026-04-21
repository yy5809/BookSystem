<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="采购单号" prop="purchaseNo">
        <el-input v-model="queryParams.purchaseNo" placeholder="请输入采购单号" clearable @keyup.enter.native="handleQuery" />
      </el-form-item>
      <el-form-item label="状态" prop="status">
        <el-select v-model="queryParams.status" placeholder="请选择状态" clearable>
          <el-option label="已到货" value="2" />
          <el-option label="已入库" value="3" />
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

    <el-table v-loading="loading" :data="inboundList">
      <el-table-column type="index" label="序号" align="center" width="55" />
      <el-table-column label="采购单号" align="center" prop="purchaseNo" width="200" />
      <el-table-column label="教材名称" align="center" prop="bookName" show-overflow-tooltip min-width="180" />
      <el-table-column label="ISBN" align="center" prop="isbn" width="140" />
      <el-table-column label="采购数量" align="center" prop="quantity" width="90" />
      <el-table-column label="实收数量" align="center" prop="actualQty" width="90" />
      <el-table-column label="单价" align="center" prop="unitPrice" width="80">¥{{ scope.row.unitPrice }}</el-table-column>
      <el-table-column label="总金额" align="center" width="100">
        <template slot-scope="scope">
          <span style="font-weight: bold; color: #E6A23C;">¥{{ ((scope.row.actualQty || 0) * (scope.row.unitPrice || 0)).toFixed(2) }}</span>
        </template>
      </el-table-column>
      <el-table-column label="状态" align="center" prop="status" width="100">
        <template slot-scope="scope">
          <dict-tag :options="dict.type.tb_purchase_status" :value="scope.row.status" />
        </template>
      </el-table-column>
      <el-table-column label="入库时间" align="center" prop="inboundTime" width="160" />
      <el-table-column label="操作人" align="center" prop="operator" width="80" />
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width" width="150">
        <template slot-scope="scope">
          <el-button size="mini" type="text" icon="el-icon-view" @click="handleView(scope.row)">详情</el-button>
          <el-button size="mini" type="text" icon="el-icon-box-plug" @click="handleInbound(scope.row)" v-if="scope.row.status === '2'" v-hasPermi='["textbook:inbound:add"]'>确认入库</el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />

    <el-dialog title="确认入库" :visible.sync="inboundOpen" width="550px" append-to-body>
      <el-alert title="请核对实物后确认入库，系统将自动增加库存并生成流水记录" type="warning" :closable="false" show-icon style="margin-bottom: 15px;" />
      <el-descriptions :column="1" border>
        <el-descriptions-item label="采购单号">{{ inboundForm.purchaseNo }}</el-descriptions-item>
        <el-descriptions-item label="教材名称">{{ inboundForm.bookName }}</el-descriptions-item>
        <el-descriptions-item label="ISBN">{{ inboundForm.isbn }}</el-descriptions-item>
        <el-descriptions-item label="采购数量">{{ inboundForm.quantity }} 本</el-descriptions-item>
      </el-descriptions>
      <el-form ref="inboundFormRef" :model="inboundForm" label-width="100px" style="margin-top: 15px;">
        <el-form-item label="实收数量" required>
          <el-input-number v-model="inboundForm.actualQty" :min="0" :max="9999" />
        </el-form-item>
        <el-form-item label="质量检查">
          <el-radio-group v-model="inboundForm.qualityCheck">
            <el-radio label="1">合格</el-radio>
            <el-radio label="2">有瑕疵（部分）</el-radio>
            <el-radio label="3">不合格（拒收）</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="备注">
          <el-input v-model="inboundForm.remark" type="textarea" placeholder="如有异常请备注说明" :rows="2" />
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitInbound">确 认 入 库</el-button>
        <el-button @click="inboundOpen = false">取 消</el-button>
      </div>
    </el-dialog>

    <el-dialog title="入库详情" :visible.sync="viewOpen" width="650px" append-to-body>
      <el-descriptions :column="2" border>
        <el-descriptions-item label="采购单号" :span="2">{{ viewData.purchaseNo }}</el-descriptions-item>
        <el-descriptions-item label="ISBN">{{ viewData.isbn }}</el-descriptions-item>
        <el-descriptions-item label="教材名称" :span="2">{{ viewData.bookName }}</el-descriptions-item>
        <el-descriptions-item label="采购数量">{{ viewData.quantity }} 本</el-descriptions-item>
        <el-descriptions-item label="实收数量">{{ viewData.actualQty || '-' }} 本</el-descriptions-item>
        <el-descriptions-item label="单价">¥{{ viewData.unitPrice }}</el-descriptions-item>
        <el-descriptions-item label="总金额">
          <span style="font-weight: bold; color: #E6A23C;">¥{{ ((viewData.actualQty || viewData.quantity || 0) * (viewData.unitPrice || 0)).toFixed(2) }}</span>
        </el-descriptions-item>
        <el-descriptions-item label="质量检查">{{ getQualityLabel(viewData.qualityCheck) }}</el-descriptions-item>
        <el-descriptions-item label="操作人">{{ viewData.operator || '-' }}</el-descriptions-item>
        <el-descriptions-item label="入库时间">{{ viewData.inboundTime || '-' }}</el-descriptions-item>
        <el-descriptions-item label="备注" :span="2">{{ viewData.remark || '-' }}</el-descriptions-item>
      </el-descriptions>
      <div slot="footer" class="dialog-footer">
        <el-button @click="viewOpen = false">关 闭</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { listPurchase } from "@/api/textbook/purchase";
import { processInbound } from "@/api/textbook/inbound";

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
      inboundOpen: false,
      viewOpen: false,
      inboundForm: {},
      viewData: {},
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        purchaseNo: null,
        status: '2'
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
      params.statusIn = ['2', '3'];
      listPurchase(params).then(response => {
        this.inboundList = response.rows;
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
    },
    handleView(row) {
      this.viewData = row;
      this.viewOpen = true;
    },
    handleInbound(row) {
      this.inboundForm = { ...row, actualQty: row.quantity, qualityCheck: '1', remark: '' };
      this.inboundOpen = true;
    },
    submitInbound() {
      if (!this.inboundForm.actualQty || this.inboundForm.actualQty <= 0) {
        this.$modal.msgError("请输入有效的实收数量");
        return;
      }
      const data = {
        buyId: this.inboundForm.buyId || this.inboundForm.id,
        actualQty: this.inboundForm.actualQty,
        qualityCheck: this.inboundForm.qualityCheck,
        remark: this.inboundForm.remark
      };
      processInbound(data).then(response => {
        this.$modal.msgSuccess("入库成功！库存已增加，流水已生成");
        this.inboundOpen = false;
        this.getList();
      });
    },
    getQualityLabel(val) { return val === '1' ? '合格' : val === '2' ? '有瑕疵' : val === '3' ? '不合格' : '-'; }
  }
};
</script>
