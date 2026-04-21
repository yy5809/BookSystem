<template>
  <div class="supplier-purchase">
    <el-card>
      <template slot="header">
        <span>采购单管理</span>
      </template>
      <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch">
        <el-form-item label="采购单号" prop="purchaseNo">
          <el-input
            v-model="queryParams.purchaseNo"
            placeholder="请输入采购单号"
            clearable
            style="width: 200px"
            @keyup.enter.native="handleQuery"
          />
        </el-form-item>
        <el-form-item label="状态" prop="purchaseStatus">
          <el-select
            v-model="queryParams.purchaseStatus"
            placeholder="请选择状态"
            clearable
            style="width: 150px"
          >
            <el-option label="待采购" value="0"></el-option>
            <el-option label="采购中" value="1"></el-option>
            <el-option label="已到货" value="2"></el-option>
            <el-option label="已入库" value="3"></el-option>
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
          <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
        </el-form-item>
      </el-form>
      
      <el-table v-loading="loading" :data="purchaseList" style="width: 100%">
        <el-table-column prop="purchaseNo" label="采购单号" width="180"></el-table-column>
        <el-table-column prop="deptName" label="申请部门" width="150"></el-table-column>
        <el-table-column prop="purchaseStatus" label="状态">
          <template slot-scope="scope">
            <el-tag :type="getStatusType(scope.row.purchaseStatus)">
              {{ getStatusText(scope.row.purchaseStatus) }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="createTime" label="创建时间" width="180"></el-table-column>
        <el-table-column label="操作" width="150">
          <template slot-scope="scope">
            <el-button type="primary" size="small" @click="confirmShipment(scope.row)" v-if="scope.row.purchaseStatus === '1'">
              确认发货
            </el-button>
            <el-button type="info" size="small" @click="viewPurchaseDetail(scope.row)">
              查看详情
            </el-button>
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
    
    <!-- 确认发货对话框 -->
    <el-dialog title="确认发货" :visible.sync="shipmentDialogVisible" width="500px">
      <el-form :model="shipmentForm" :rules="shipmentRules" ref="shipmentForm">
        <el-form-item label="采购单号" prop="purchaseNo">
          <el-input v-model="shipmentForm.purchaseNo" disabled></el-input>
        </el-form-item>
        <el-form-item label="物流公司" prop="logisticsCompany">
          <el-input v-model="shipmentForm.logisticsCompany" placeholder="请输入物流公司"></el-input>
        </el-form-item>
        <el-form-item label="物流单号" prop="logisticsNo">
          <el-input v-model="shipmentForm.logisticsNo" placeholder="请输入物流单号"></el-input>
        </el-form-item>
        <el-form-item label="备注" prop="remark">
          <el-input v-model="shipmentForm.remark" type="textarea" placeholder="请输入备注"></el-input>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="shipmentDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="submitShipment">确认发货</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { listSupplierPurchases, confirmShipment } from '@/api/textbook/supplier'

export default {
  name: 'SupplierPurchaseList',
  data() {
    return {
      loading: false,
      purchaseList: [],
      total: 0,
      showSearch: true,
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        purchaseNo: undefined,
        purchaseStatus: undefined
      },
      shipmentDialogVisible: false,
      shipmentForm: {
        purchaseId: '',
        purchaseNo: '',
        logisticsCompany: '',
        logisticsNo: '',
        remark: ''
      },
      shipmentRules: {
        logisticsCompany: [
          { required: true, message: '请输入物流公司', trigger: 'blur' }
        ],
        logisticsNo: [
          { required: true, message: '请输入物流单号', trigger: 'blur' }
        ]
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
        this.purchaseList = response.data.rows
        this.total = response.data.total
        this.loading = false
      })
    },
    handleQuery() {
      this.queryParams.pageNum = 1
      this.getList()
    },
    resetQuery() {
      this.queryParams = {
        pageNum: 1,
        pageSize: 10,
        purchaseNo: undefined,
        purchaseStatus: undefined
      }
      this.getList()
    },
    getStatusType(status) {
      const typeMap = {
        '0': 'info',
        '1': 'warning',
        '2': 'success',
        '3': 'success'
      }
      return typeMap[status] || 'info'
    },
    getStatusText(status) {
      const textMap = {
        '0': '待采购',
        '1': '采购中',
        '2': '已到货',
        '3': '已入库'
      }
      return textMap[status] || '未知'
    },
    viewPurchaseDetail(purchase) {
      this.$router.push(`/textbook/supplierPurchase/${purchase.buyId}`)
    },
    confirmShipment(purchase) {
      this.shipmentForm = {
        purchaseId: purchase.buyId,
        purchaseNo: purchase.purchaseNo,
        logisticsCompany: '',
        logisticsNo: '',
        remark: ''
      }
      this.shipmentDialogVisible = true
    },
    submitShipment() {
      this.$refs.shipmentForm.validate((valid) => {
        if (valid) {
          confirmShipment(this.shipmentForm).then(response => {
            this.$message.success('发货确认成功')
            this.shipmentDialogVisible = false
            this.getList()
          }).catch(() => {
            this.$message.error('发货确认失败')
          })
        }
      })
    }
  }
}
</script>

<style scoped>
.supplier-purchase {
  padding: 20px;
}
</style>