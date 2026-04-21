<template>
  <div class="supplier-purchase-detail">
    <el-card>
      <template slot="header">
        <span>采购单详情</span>
        <el-button type="primary" size="small" @click="goBack" style="margin-left: 20px">返回列表</el-button>
      </template>
      
      <el-form :model="purchaseInfo" label-width="120px" size="small">
        <el-form-item label="采购单号">
          <el-input v-model="purchaseInfo.purchaseNo" disabled></el-input>
        </el-form-item>
        <el-form-item label="申请部门">
          <el-input v-model="purchaseInfo.deptName" disabled></el-input>
        </el-form-item>
        <el-form-item label="状态">
          <el-tag :type="getStatusType(purchaseInfo.purchaseStatus)">
            {{ getStatusText(purchaseInfo.purchaseStatus) }}
          </el-tag>
        </el-form-item>
        <el-form-item label="创建时间">
          <el-input v-model="purchaseInfo.createTime" disabled></el-input>
        </el-form-item>
        <el-form-item label="物流公司" v-if="purchaseInfo.logisticsCompany">
          <el-input v-model="purchaseInfo.logisticsCompany" disabled></el-input>
        </el-form-item>
        <el-form-item label="物流单号" v-if="purchaseInfo.logisticsNo">
          <el-input v-model="purchaseInfo.logisticsNo" disabled></el-input>
        </el-form-item>
      </el-form>
      
      <el-card class="purchase-details-card">
        <template slot="header">
          <span>采购明细</span>
        </template>
        <el-table :data="purchaseDetails" style="width: 100%">
          <el-table-column prop="bookName" label="教材名称"></el-table-column>
          <el-table-column prop="isbn" label="ISBN" width="150"></el-table-column>
          <el-table-column prop="quantity" label="数量" width="100"></el-table-column>
        </el-table>
      </el-card>
      
      <div class="action-buttons" v-if="purchaseInfo.purchaseStatus === '1'">
        <el-button type="primary" @click="confirmShipment">确认发货</el-button>
      </div>
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
import { getSupplierPurchaseDetail, confirmShipment } from '@/api/textbook/supplier'

export default {
  name: 'SupplierPurchaseDetail',
  data() {
    return {
      purchaseInfo: {},
      purchaseDetails: [],
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
    this.getPurchaseDetail()
  },
  methods: {
    getPurchaseDetail() {
      const purchaseId = this.$route.params.id
      getSupplierPurchaseDetail(purchaseId).then(response => {
        this.purchaseInfo = response.data
        this.purchaseDetails = response.data.details || []
      })
    },
    goBack() {
      this.$router.push('/textbook/supplierPurchase')
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
    confirmShipment() {
      this.shipmentForm = {
        purchaseId: this.purchaseInfo.buyId,
        purchaseNo: this.purchaseInfo.purchaseNo,
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
            this.getPurchaseDetail()
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
.supplier-purchase-detail {
  padding: 20px;
}

.purchase-details-card {
  margin-top: 20px;
}

.action-buttons {
  margin-top: 20px;
  text-align: right;
}
</style>