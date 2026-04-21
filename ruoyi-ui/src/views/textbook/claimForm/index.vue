<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="领书通知" prop="noticeNo">
        <el-input v-model="queryParams.noticeNo" placeholder="请输入通知编号" clearable @keyup.enter.native="handleQuery" />
      </el-form-item>
      <el-form-item label="班级名称" prop="className">
        <el-input v-model="queryParams.className" placeholder="请输入班级名称" clearable @keyup.enter.native="handleQuery" />
      </el-form-item>
      <el-form-item label="状态" prop="status">
        <el-select v-model="queryParams.status" placeholder="请选择状态" clearable>
          <el-option v-for="dict in dict.type.tb_claim_form_status" :key="dict.value" :label="dict.label" :value="dict.value" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-table v-loading="loading" :data="claimFormList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="领书单号" align="center" prop="formNo" width="200" />
      <el-table-column label="班级" align="center" prop="className" width="120" />
      <el-table-column label="专业" align="center" prop="majorName" width="120" show-overflow-tooltip />
      <el-table-column label="学院" align="center" prop="collegeName" width="120" show-overflow-tooltip />
      <el-table-column label="应发数量" align="center" prop="plannedQty" width="90" />
      <el-table-column label="实发数量" align="center" prop="issuedQty" width="90">
        <template slot-scope="scope">{{ scope.row.issuedQty || 0 }}</template>
      </el-table-column>
      <el-table-column label="领书人" align="center" prop="receiverName" width="100" />
      <el-table-column label="状态" align="center" prop="status" width="100">
        <template slot-scope="scope">
          <dict-tag :options="dict.type.tb_claim_form_status" :value="scope.row.status" />
        </template>
      </el-table-column>
      <el-table-column label="出库时间" align="center" prop="issueTime" width="160" />
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width" width="220">
        <template slot-scope="scope">
          <el-button size="mini" type="text" icon="el-icon-view" @click="handleView(scope.row)">详情</el-button>
          <el-button size="mini" type="text" icon="el-icon-sell" @click="handleOutbound(scope.row)" v-if="scope.row.status !== '2'" v-hasPermi='["textbook:claimForm:outbound"]'>确认出库</el-button>
          <el-button size="mini" type="text" icon="el-icon-printer" @click="handlePrint(scope.row)" v-hasPermi='["textbook:claimForm:query"]'>打印</el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />

    <el-dialog title="确认出库" :visible.sync="outboundOpen" width="550px" append-to-body>
      <el-alert title="班委已到仓库领取教材并在纸质领书单上签名，请确认以下信息后完成出库操作" type="info" :closable="false" show-icon style="margin-bottom: 15px;" />
      <el-descriptions :column="1" border>
        <el-descriptions-item label="领书单号">{{ outboundForm.formNo }}</el-descriptions-item>
        <el-descriptions-item label="班级">{{ outboundForm.className }} ({{ outboundForm.majorName }})</el-descriptions-item>
        <el-descriptions-item label="应发总数">{{ outboundForm.plannedQty }} 本</el-descriptions-item>
      </el-descriptions>
      <el-form ref="outboundFormRef" :model="outboundForm" label-width="100px" style="margin-top: 15px;">
        <el-form-item label="实发数量" required>
          <el-input-number v-model="outboundForm.issuedQty" :min="1" :max="outboundForm.plannedQty || 9999" />
          <div style="color: #E6A23C; font-size: 12px; margin-top: 4px;">支持分批出库，本次实发数量不能超过应发数量</div>
        </el-form-item>
        <el-form-item label="领书人姓名" required>
          <el-input v-model="outboundForm.receiverName" placeholder="请填写纸质签名的班委姓名" maxlength="20" />
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitOutbound">确 认 出 库</el-button>
        <el-button @click="outboundOpen = false">取 消</el-button>
      </div>
    </el-dialog>

    <el-dialog title="领书单详情" :visible.sync="viewOpen" width="800px" append-to-body>
      <el-descriptions :column="2" border style="margin-bottom: 16px;">
        <el-descriptions-item label="领书单号" :span="2">{{ viewData.formNo }}</el-descriptions-item>
        <el-descriptions-item label="学院">{{ viewData.collegeName }}</el-descriptions-item>
        <el-descriptions-item label="专业">{{ viewData.majorName }}</el-descriptions-item>
        <el-descriptions-item label="班级">{{ viewData.className }}</el-descriptions-item>
        <el-descriptions-item label="状态">
          <dict-tag :options="dict.type.tb_claim_form_status" :value="viewData.status" />
        </el-descriptions-item>
        <el-descriptions-item label="应发总数">{{ viewData.plannedQty }} 本</el-descriptions-item>
        <el-descriptions-item label="实发总数">{{ viewData.issuedQty || 0 }} 本</el-descriptions-item>
        <el-descriptions-item label="领书人">{{ viewData.receiverName || '-' }}</el-descriptions-item>
        <el-descriptions-item label="出库时间">{{ viewData.issueTime || '-' }}</el-descriptions-item>
      </el-descriptions>

      <el-divider content-position="left">教材明细</el-divider>

      <el-table :data="detailList" size="small" border>
        <el-table-column label="ISBN" prop="isbn" width="140" />
        <el-table-column label="教材名称" prop="bookName" show-overflow-tooltip />
        <el-table-column label="作者" prop="author" width="80" />
        <el-table-column label="应发数量" prop="plannedQty" width="80" align="center" />
        <el-table-column label="实发数量" prop="issuedQty" width="80" align="center">
          <template slot-scope="scope">{{ scope.row.issuedQty || 0 }}</template>
        </el-table-column>
        <el-table-column label="定价" prop="price" width="70" align="right">
          <template slot-scope="scope">¥{{ scope.row.price }}</template>
        </el-table-column>
      </el-table>

      <div slot="footer" class="dialog-footer">
        <el-button @click="viewOpen = false">关 闭</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { listClaimForm, getClaimForm, confirmOutbound, listClaimFormDetail } from "@/api/textbook/claimForm";
import { getToken } from "@/utils/auth";

export default {
  name: "BookClaimForm",
  dicts: ['tb_claim_form_status'],
  data() {
    return {
      loading: true,
      ids: [],
      total: 0,
      claimFormList: [],
      detailList: [],
      showSearch: true,
      outboundOpen: false,
      viewOpen: false,
      outboundForm: {},
      viewData: {},
      queryParams: { pageNum: 1, pageSize: 10, noticeNo: null, className: null, status: null }
    };
  },
  created() {
    this.getList();
  },
  methods: {
    getList() {
      this.loading = true;
      listClaimForm(this.queryParams).then(response => {
        this.claimFormList = response.rows;
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
    handleSelectionChange(selection) {
      this.ids = selection.map(item => item.formId);
    },
    async handleView(row) {
      this.viewData = row;
      try {
        const res = await listClaimFormDetail(row.formId);
        this.detailList = res.data || [];
      } catch (e) {
        this.detailList = [];
      }
      this.viewOpen = true;
    },
    handleOutbound(row) {
      const remaining = (row.plannedQty || 0) - (row.issuedQty || 0);
      this.outboundForm = {
        formId: row.formId, formNo: row.formNo, className: row.className, majorName: row.majorName,
        plannedQty: row.plannedQty, issuedQty: remaining > 0 ? remaining : (row.plannedQty || 1), receiverName: ''
      };
      this.outboundOpen = true;
    },
    submitOutbound() {
      if (!this.outboundForm.receiverName || !this.outboundForm.receiverName.trim()) {
        this.$modal.msgError("请填写领书人姓名");
        return;
      }
      const data = {
        formId: this.outboundForm.formId,
        issuedQty: this.outboundForm.issuedQty,
        receiverName: this.outboundForm.receiverName
      };
      confirmOutbound(data).then(response => {
        this.$modal.msgSuccess("出库成功！库存已扣减，流水已生成");
        this.outboundOpen = false;
        this.getList();
      });
    },
    handlePrint(row) {
      const token = getToken();
      window.open(process.env.VUE_APP_BASE_API + '/textbook/claimForm/pdf/' + row.formId + '?token=' + token);
    }
  }
};
</script>
