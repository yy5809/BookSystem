<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="采购单号" prop="purchaseNo">
        <el-input v-model="queryParams.purchaseNo" placeholder="请输入采购单号" clearable style="width: 200px" @keyup.enter.native="handleQuery" />
      </el-form-item>
      <el-form-item label="状态" prop="purchaseStatus">
        <el-select v-model="queryParams.purchaseStatus" placeholder="请选择状态" clearable style="width: 150px">
          <el-option label="待采购" value="0" />
          <el-option label="采购中" value="1" />
          <el-option label="已接单" value="2" />
          <el-option label="已发货" value="3" />
          <el-option label="已到货" value="4" />
          <el-option label="已入库" value="5" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-table v-loading="loading" :data="purchaseList" border stripe>
      <el-table-column label="采购单号" align="center" prop="purchaseNo" width="185" show-overflow-tooltip />
      <el-table-column label="申请人" align="center" prop="userName" width="85" />
      <el-table-column label="状态" align="center" width="80">
        <template slot-scope="scope">
          <el-tag :type="statusType(scope.row.purchaseStatus)" size="mini">{{ statusText(scope.row.purchaseStatus) }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="创建时间" align="center" prop="createTime" width="145" />
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width" width="185">
        <template slot-scope="scope">
          <el-button size="mini" type="text" icon="el-icon-check" @click="handleAccept(scope.row)" v-if="scope.row.purchaseStatus === '1'">确认接单</el-button>
          <el-button size="mini" type="text" icon="el-icon-truck" @click="handleShipment(scope.row)" v-if="scope.row.purchaseStatus === '2'">确认发货</el-button>
          <el-button size="mini" type="text" icon="el-icon-view" @click="handleDetail(scope.row)">详情</el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />

    <el-dialog title="确认发货" :visible.sync="open" width="450px" append-to-body :close-on-click-modal="false">
      <el-form ref="shipmentForm" :model="shipmentForm" :rules="shipmentRules" label-width="80px">
        <el-form-item label="采购单号">
          <el-input v-model="shipmentForm.purchaseNo" disabled />
        </el-form-item>
        <el-form-item label="物流公司" prop="logisticsCompany">
          <el-input v-model="shipmentForm.logisticsCompany" placeholder="请输入物流公司" />
        </el-form-item>
        <el-form-item label="物流单号" prop="logisticsNo">
          <el-input v-model="shipmentForm.logisticsNo" placeholder="请输入物流单号" />
        </el-form-item>
        <el-form-item label="备注" prop="remark">
          <el-input v-model="shipmentForm.remark" type="textarea" placeholder="请输入备注" />
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitShipment">确 定</el-button>
        <el-button @click="open = false">取 消</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { listSupplierPurchases, acceptOrder, confirmShipment } from '@/api/textbook/supplier'

export default {
  name: "SupplierPurchaseList",
  data() {
    return {
      loading: true,
      total: 0,
      purchaseList: [],
      showSearch: true,
      open: false,
      shipmentForm: {
        purchaseId: undefined,
        purchaseNo: '',
        logisticsCompany: undefined,
        logisticsNo: undefined,
        remark: undefined
      },
      shipmentRules: {
        logisticsCompany: [{ required: true, message: '请输入物流公司', trigger: 'blur' }],
        logisticsNo: [{ required: true, message: '请输入物流单号', trigger: 'blur' }]
      },
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        purchaseNo: undefined,
        purchaseStatus: undefined
      }
    }
  },
  created() {
    this.getList()
  },
  methods: {
    getList() {
      this.loading = true
      listSupplierPurchases(this.queryParams).then(response => {
        this.purchaseList = response.rows
        this.total = response.total
        this.loading = false
      }).catch(() => { this.loading = false })
    },
    handleQuery() {
      this.queryParams.pageNum = 1
      this.getList()
    },
    resetQuery() {
      this.resetForm("queryForm")
      this.handleQuery()
    },
    statusType(status) {
      const m = { '0': 'info', '1': 'warning', '2': '', '3': '', '4': 'info', '5': 'success' }
      return m[status] || 'info'
    },
    statusText(status) {
      const m = { '0': '待采购', '1': '采购中', '2': '已接单', '3': '已发货', '4': '已到货', '5': '已入库' }
      return m[status] || '未知'
    },
    handleDetail(purchase) {
      this.$router.push(`/textbook/supplierPurchase/${purchase.buyId}`)
    },
    handleAccept(purchase) {
      this.$modal.confirm('确认接单采购单 ' + purchase.purchaseNo + ' ？').then(() => {
        return acceptOrder(purchase.buyId)
      }).then(() => {
        this.$modal.msgSuccess('已接单')
        this.getList()
      }).catch(() => {})
    },
    handleShipment(purchase) {
      this.shipmentForm = {
        purchaseId: purchase.buyId,
        purchaseNo: purchase.purchaseNo,
        logisticsCompany: undefined,
        logisticsNo: undefined,
        remark: undefined
      }
      this.resetForm("shipmentForm")
      this.open = true
    },
    submitShipment() {
      this.$refs["shipmentForm"].validate(valid => {
        if (valid) {
          confirmShipment(this.shipmentForm).then(() => {
            this.$modal.msgSuccess('发货确认成功')
            this.open = false
            this.getList()
          }).catch(() => {})
        }
      })
    }
  }
}
</script>
