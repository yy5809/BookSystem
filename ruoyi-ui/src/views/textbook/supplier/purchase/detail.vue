<template>
  <div class="app-container">
    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button type="default" plain icon="el-icon-back" size="mini" @click="$router.go(-1)">返回</el-button>
      </el-col>
    </el-row>

    <el-descriptions :column="2" border size="small">
      <el-descriptions-item label="采购单号">{{ purchaseInfo.purchaseNo }}</el-descriptions-item>
      <el-descriptions-item label="申请人">{{ purchaseInfo.userName }}</el-descriptions-item>
      <el-descriptions-item label="状态">
        <el-tag :type="statusType(purchaseInfo.purchaseStatus)" size="mini">{{ statusText(purchaseInfo.purchaseStatus) }}</el-tag>
      </el-descriptions-item>
      <el-descriptions-item label="创建时间">{{ purchaseInfo.createTime }}</el-descriptions-item>
      <el-descriptions-item label="物流公司" v-if="purchaseInfo.logisticsCompany">{{ purchaseInfo.logisticsCompany }}</el-descriptions-item>
      <el-descriptions-item label="物流单号" v-if="purchaseInfo.logisticsNo">{{ purchaseInfo.logisticsNo }}</el-descriptions-item>
    </el-descriptions>

    <el-card class="mt15">
      <template slot="header">
        <span>采购明细</span>
      </template>
      <el-table :data="purchaseDetails" border stripe>
        <el-table-column label="教材名称" align="center" prop="bookName" min-width="150" show-overflow-tooltip />
        <el-table-column label="版次" align="center" prop="edition" width="65" />
        <el-table-column label="作者" align="center" prop="author" width="85" show-overflow-tooltip />
        <el-table-column label="出版社" align="center" prop="publisher" width="100" show-overflow-tooltip />
        <el-table-column label="ISBN" align="center" prop="isbn" width="130" />
        <el-table-column label="数量" align="center" prop="quantity" width="60" />
        <el-table-column label="学院" align="center" prop="college" width="80" show-overflow-tooltip />
        <el-table-column label="入学年份" align="center" prop="grade" width="80" />
      </el-table>
    </el-card>

    <div style="text-align: right; margin-top: 15px;" v-if="purchaseInfo.purchaseStatus === '1' || purchaseInfo.purchaseStatus === '2'">
      <el-button type="success" icon="el-icon-check" size="mini" @click="handleAccept" v-if="purchaseInfo.purchaseStatus === '1'">确认接单</el-button>
      <el-button type="primary" icon="el-icon-truck" size="mini" @click="handleShipment" v-if="purchaseInfo.purchaseStatus === '2'">确认发货</el-button>
    </div>

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
        <el-form-item label="备注">
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
import { getSupplierPurchaseDetail, acceptOrder, confirmShipment } from '@/api/textbook/supplier'

export default {
  name: "SupplierPurchaseDetail",
  data() {
    return {
      purchaseInfo: {},
      purchaseDetails: [],
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
      }
    }
  },
  created() {
    this.loadDetail()
  },
  methods: {
    loadDetail() {
      getSupplierPurchaseDetail(this.$route.params.id).then(response => {
        this.purchaseInfo = response.data
        this.purchaseDetails = response.data.details || []
      })
    },
    statusType(status) {
      const m = { '0': 'info', '1': 'warning', '2': '', '3': '', '4': 'info', '5': 'success' }
      return m[status] || 'info'
    },
    statusText(status) {
      const m = { '0': '待采购', '1': '采购中', '2': '已接单', '3': '已发货', '4': '已到货', '5': '已入库' }
      return m[status] || '未知'
    },
    handleAccept() {
      this.$modal.confirm('确认接单该采购单？').then(() => {
        return acceptOrder(this.purchaseInfo.buyId)
      }).then(() => {
        this.$modal.msgSuccess('已接单')
        this.loadDetail()
      }).catch(() => {})
    },
    handleShipment() {
      this.shipmentForm = {
        purchaseId: this.purchaseInfo.buyId,
        purchaseNo: this.purchaseInfo.purchaseNo,
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
            this.loadDetail()
          }).catch(() => {})
        }
      })
    }
  }
}
</script>

<style scoped>
.mt15 { margin-top: 15px; }
</style>
