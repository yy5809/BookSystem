<template>
  <div class="app-container">
    <el-alert
      v-if="warningCount > 0 || shortageCount > 0"
      :title="`库存异常：${shortageCount > 0 ? shortageCount + ' 本教材短缺' : ''}${warningCount > 0 && shortageCount > 0 ? '，' : ''}${warningCount > 0 ? warningCount + ' 本低于预警阈值' : ''}`"
      :type="shortageCount > 0 ? 'error' : 'warning'"
      show-icon
      :closable="false"
      style="margin-bottom: 16px">
    </el-alert>

    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="ISBN" prop="isbn">
        <el-input v-model="queryParams.isbn" placeholder="请输入ISBN" clearable @keyup.enter.native="handleQuery" />
      </el-form-item>
      <el-form-item label="教材名称" prop="bookName">
        <el-input v-model="queryParams.bookName" placeholder="请输入教材名称" clearable @keyup.enter.native="handleQuery" />
      </el-form-item>
      <el-form-item label="库存状态" prop="stockStatus">
        <el-select v-model="queryParams.stockStatus" placeholder="请选择" clearable>
          <el-option label="正常" value="normal" />
          <el-option label="预警" value="warning" />
          <el-option label="短缺" value="shortage" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button type="success" plain icon="el-icon-download" size="mini" @click="handleExport" v-hasPermi="['textbook:inventory:export']">导出</el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="inventoryList" :row-class-name="tableRowClassName">
      <el-table-column label="ISBN" align="center" prop="isbn" width="140" />
      <el-table-column label="教材名称" align="center" prop="bookName" show-overflow-tooltip min-width="180" />
      <el-table-column label="作者" align="center" prop="author" width="90" show-overflow-tooltip />
      <el-table-column label="出版社" align="center" prop="publisher" width="120" show-overflow-tooltip />
      <el-table-column label="当前库存" align="center" prop="stockNum" width="90">
        <template slot-scope="scope">
          <span :style="{ color: getStockColor(scope.row), fontWeight: 'bold' }">{{ scope.row.stockNum || 0 }}</span>
        </template>
      </el-table-column>
      <el-table-column label="预警阈值" align="center" prop="warningNum" width="90" />
      <el-table-column label="库存状态" align="center" width="90">
        <template slot-scope="scope">
          <el-tag :type="getStatusTagType(scope.row)" size="mini" effect="dark">{{ getStatusLabel(scope.row) }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="累计入库" align="center" prop="totalPurchase" width="90">
        <template slot-scope="scope">{{ scope.row.totalPurchase || 0 }}</template>
      </el-table-column>
      <el-table-column label="累计出库" align="center" prop="totalIssued" width="90">
        <template slot-scope="scope">{{ scope.row.totalIssued || 0 }}</template>
      </el-table-column>
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width" width="120">
        <template slot-scope="scope">
          <el-button size="mini" type="text" icon="el-icon-view" @click="handleView(scope.row)">详情</el-button>
          <el-button size="mini" type="text" icon="el-icon-document" @click="handleViewLog(scope.row)">流水</el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />

    <el-dialog title="库存详情" :visible.sync="detailOpen" width="600px" append-to-body>
      <el-descriptions :column="2" border v-if="detailData">
        <el-descriptions-item label="教材名称" :span="2">{{ detailData.bookName }}</el-descriptions-item>
        <el-descriptions-item label="ISBN">{{ detailData.isbn }}</el-descriptions-item>
        <el-descriptions-item label="作者">{{ detailData.author || '-' }}</el-descriptions-item>
        <el-descriptions-item label="出版社">{{ detailData.publisher || '-' }}</el-descriptions-item>
        <el-descriptions-item label="当前库存">
          <span :style="{ color: getStockColor(detailData), fontWeight: 'bold', fontSize: '16px' }">{{ detailData.stockNum || 0 }}</span>
        </el-descriptions-item>
        <el-descriptions-item label="预警阈值">{{ detailData.warningNum || 10 }}</el-descriptions-item>
        <el-descriptions-item label="累计入库">{{ detailData.totalPurchase || 0 }} 本</el-descriptions-item>
        <el-descriptions-item label="累计出库">{{ detailData.totalIssued || 0 }} 本</el-descriptions-item>
        <el-descriptions-item label="库存状态" :span="2">
          <el-tag :type="getStatusTagType(detailData)" effect="dark">{{ getStatusLabel(detailData) }}</el-tag>
        </el-descriptions-item>
      </el-descriptions>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" icon="el-icon-document" @click="handleViewLog(detailData); detailOpen = false">查看流水</el-button>
        <el-button @click="detailOpen = false">关 闭</el-button>
      </div>
    </el-dialog>

    <el-dialog title="库存流水记录" :visible.sync="logOpen" width="850px" append-to-body>
      <div v-if="logBookName" style="margin-bottom: 12px; padding: 8px 12px; background: #f5f7fa; border-radius: 4px;">
        <span style="font-weight: bold; font-size: 15px; margin-right: 16px;">{{ logBookName }}</span>
        <span style="color: #909399; font-family: monospace; font-size: 13px;">ISBN: {{ logIsbn }}</span>
      </div>
      <el-table :data="logList" size="small" border max-height="400" v-loading="logLoading">
        <el-table-column type="index" label="#" width="45" align="center" />
        <el-table-column label="业务类型" width="110" align="center">
          <template slot-scope="scope">
            <el-tag :type="getBizTypeTagType(scope.row.businessType)" size="mini">{{ getBizTypeLabel(scope.row.businessType) }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column label="关联单号" prop="businessNo" width="180" show-overflow-tooltip />
        <el-table-column label="变动数量" align="center" prop="changeQty" width="100">
          <template slot-scope="scope">
            <span :style="{ color: scope.row.changeQty > 0 ? '#67C23A' : '#F56C6C', fontWeight: 'bold' }">
              {{ scope.row.changeQty > 0 ? '+' : '' }}{{ scope.row.changeQty }}
            </span>
          </template>
        </el-table-column>
        <el-table-column label="变动前" prop="stockBefore" width="80" align="center" />
        <el-table-column label="变动后" prop="stockAfter" width="80" align="center" />
        <el-table-column label="操作人" prop="operator" width="90" />
        <el-table-column label="操作时间" prop="operateTime" width="160" align="center" />
      </el-table>
      <div slot="footer" class="dialog-footer">
        <el-button @click="logOpen = false">关 闭</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { getInventoryList, getInventoryInfo, exportInventory } from "@/api/textbook/inventory";
import { listStockFlow } from "@/api/textbook/stockFlow";

export default {
  name: "InventoryManage",
  data() {
    return {
      loading: true,
      total: 0,
      inventoryList: [],
      showSearch: true,
      warningCount: 0,
      shortageCount: 0,
      detailOpen: false,
      detailData: null,
      logOpen: false,
      logLoading: false,
      logList: [],
      logBookName: '',
      logIsbn: '',
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        isbn: null,
        bookName: null,
        stockStatus: null
      }
    };
  },
  created() {
    this.getList();
  },
  methods: {
    getList() {
      this.loading = true;
      getInventoryList(this.queryParams).then(response => {
        this.inventoryList = response.rows || [];
        this.total = response.total || 0;
        this.warningCount = 0;
        this.shortageCount = 0;
        (response.rows || []).forEach(row => {
          if (row.stockNum != null) {
            if (row.stockNum <= 0) this.shortageCount++;
            else if (row.stockNum <= (row.warningNum || 10)) this.warningCount++;
          }
        });
        this.loading = false;
      }).catch(() => { this.loading = false; });
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
      getInventoryInfo(row.stockId).then(res => {
        this.detailData = res.data || res;
        this.detailOpen = true;
      }).catch(() => {
        this.detailData = row;
        this.detailOpen = true;
      });
    },
    handleViewLog(row) {
      this.logBookName = row.bookName || '';
      this.logIsbn = row.isbn || '';
      this.logOpen = true;
      this.logLoading = true;
      listStockFlow({ isbn: row.isbn }).then(res => {
        this.logList = res.rows || [];
        this.logLoading = false;
      }).catch(() => { this.logLoading = false; });
    },
    handleExport() {
      this.download('textbook/inventory/export', { ...this.queryParams }, `库存数据_${new Date().getTime()}.xlsx`);
    },
    getStockColor(row) {
      const stock = row.stockNum || 0;
      if (stock <= 0) return '#F56C6C';
      if (stock <= (row.warningNum || 10)) return '#E6A23C';
      return '#67C23A';
    },
    getStatusLabel(row) {
      const stock = row.stockNum || 0;
      if (stock <= 0) return '短缺';
      if (stock <= (row.warningNum || 10)) return '预警';
      return '正常';
    },
    getStatusTagType(row) {
      const stock = row.stockNum || 0;
      if (stock <= 0) return 'danger';
      if (stock <= (row.warningNum || 10)) return 'warning';
      return 'success';
    },
    tableRowClassName({ row }) {
      const stock = row.stockNum || 0;
      if (stock <= 0) return 'stock-row-shortage';
      if (stock <= (row.warningNum || 10)) return 'stock-row-warning';
      return '';
    },
    getBizTypeLabel(type) {
      const map = { '1': '采购入库', '2': '班级领书出库', '3': '个人领书出库' };
      return map[type] || type || '-';
    },
    getBizTypeTagType(type) {
      const map = { '1': 'success', '2': 'danger', '3': 'warning' };
      return map[type] || 'info';
    }
  }
};
</script>

<style scoped>
::v-deep .stock-row-shortage { background-color: #fef0f0 !important; }
::v-deep .stock-row-warning { background-color: #fdf6ec !important; }
</style>
