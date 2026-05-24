<template>
  <div class="app-container">
    <el-tabs v-model="activeTab" type="card" @tab-click="onTabClick">
      <el-tab-pane label="班级领书" name="class">
        <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
          <el-form-item label="学期" prop="semester">
            <el-input v-model="queryParams.semester" placeholder="如：2025-2026-2" clearable @keyup.enter.native="handleQuery" />
          </el-form-item>
          <el-form-item label="状态" prop="status">
          <el-select v-model="queryParams.status" placeholder="请选择" clearable @change="handleQuery">
            <el-option label="草稿" value="0" />
            <el-option label="已发布" value="1" />
            <el-option label="领取中" value="2" />
            <el-option label="已完成" value="3" />
          </el-select>
          </el-form-item>
          <el-form-item>
            <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
            <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
          </el-form-item>
        </el-form>
        <el-row :gutter="10" class="mb8">
          <el-col :span="1.5">
            <el-button type="primary" plain icon="el-icon-plus" size="mini" @click="handleAdd" v-hasPermi="['textbook:noticeManage:add']">新建领书计划</el-button>
          </el-col>
          <right-toolbar :showSearch.sync="showSearch" @queryTable="getList" />
        </el-row>
        <el-table v-loading="loading" :data="noticeList" border stripe row-key="noticeId" @expand-change="onNoticeExpand">
          <el-table-column type="expand">
            <template slot-scope="scope">
              <div style="padding: 10px 20px;" v-loading="scope.row._loading">
                <el-table v-if="scope.row._forms && scope.row._forms.length" :data="scope.row._forms" border stripe size="small" style="margin: 0;">
                  <el-table-column label="领书单号" prop="formNo" width="180" />
                  <el-table-column label="班级信息" min-width="140">
                    <template slot-scope="s">{{ s.row.collegeName }} {{ s.row.majorName }} {{ formatGradeLevel(s.row.gradeLevel) }}{{ s.row.className }}</template>
                  </el-table-column>
                  <el-table-column label="应发" prop="plannedQty" width="50" />
                  <el-table-column label="已发" prop="issuedQty" width="50" />
                  <el-table-column label="状态" width="65" align="center">
                    <template slot-scope="s">
                      <el-tag :type="s.row.status==='2'?'success':s.row.status==='1'?'warning':''" size="mini">{{ s.row.status==='2'?'已出库':s.row.status==='1'?'部分':'待领' }}</el-tag>
                    </template>
                  </el-table-column>
                  <el-table-column label="领书人" prop="receiverName" width="60" />
                  <el-table-column label="操作" class-name="small-padding fixed-width" width="240" align="center">
                    <template slot-scope="s">
                      <el-button size="mini" type="text" icon="el-icon-view" @click.stop="viewFormDetail(s.row)" v-hasPermi="['textbook:noticeManage:query']">明细</el-button>
                      <el-button size="mini" type="text" icon="el-icon-printer" @click.stop="handlePrint(s.row)" v-hasPermi="['textbook:claimForm:query']">打印</el-button>
                      <el-button size="mini" type="text" icon="el-icon-sold-out" @click.stop="handleOutbound(s.row)" v-if="s.row.status !== '2'" v-hasPermi="['textbook:claimForm:outbound']">出库</el-button>
                      <template v-if="scope.row.status === '0'">
                        <el-dropdown size="mini" @command="(cmd) => handleFormAction(cmd, s.row)" v-if="(s.row.status==='0' || s.row.status==='1')" v-hasPermi="['textbook:claimForm:edit']" style="margin-left:8px">
                          <el-button size="mini" type="text">更多<i class="el-icon-arrow-down el-icon--right"></i></el-button>
                          <el-dropdown-menu slot="dropdown">
                            <el-dropdown-item command="withdraw" v-if="s.row.status==='0'" icon="el-icon-back">撤回</el-dropdown-item>
                            <el-dropdown-item command="close" v-if="s.row.status!=='2' && s.row.status!=='5'" icon="el-icon-circle-close">关闭</el-dropdown-item>
                            <el-dropdown-item command="reissue" v-if="s.row.status==='1'" icon="el-icon-refresh">补发</el-dropdown-item>
                          </el-dropdown-menu>
                        </el-dropdown>
                      </template>
                      <template v-else>
                        <el-tooltip content="计划已发布，不可撤回/关闭领书单" placement="top">
                          <span style="color:#c0c4cc;font-size:12px;margin-left:8px;cursor:not-allowed">已锁定</span>
                        </el-tooltip>
                      </template>
                    </template>
                  </el-table-column>
                </el-table>
                <el-empty v-else description="暂无领书单" :image-size="60" />
              </div>
            </template>
          </el-table-column>
          <el-table-column label="批次编号" prop="noticeNo" width="195" />
          <el-table-column label="学期" prop="semester" width="105" />
          <el-table-column label="领取时间" width="210">
            <template slot-scope="s">{{ (s.row.pickupStart||'') + ' ~ ' + (s.row.pickupEnd||'') }}</template>
          </el-table-column>
          <el-table-column label="领取地点" prop="pickupLocation" min-width="120" show-overflow-tooltip />
          <el-table-column label="状态" width="75" align="center">
            <template slot-scope="s">
              <el-tag :type="{0:'info',1:'',2:'warning',3:'success',4:'danger'}[s.row.status]" size="small">{{ noticeStatusText(s.row.status) }}</el-tag>
            </template>
          </el-table-column>
          <el-table-column label="班级进度" width="90" align="center">
            <template slot-scope="s">{{ s.row.issuedClasses || 0 }} / {{ s.row.totalClasses || 0 }}</template>
          </el-table-column>
          <el-table-column label="创建时间" prop="createTime" width="145" />
          <el-table-column label="操作" class-name="small-padding fixed-width" width="270" align="center" fixed="right">
            <template slot-scope="scope">
              <el-button size="mini" type="text" icon="el-icon-s-promotion" style="color:#409EFF" @click.stop="handlePublish(scope.row)" v-if="scope.row.status==='0'" v-hasPermi="['textbook:noticeManage:publish']">发布</el-button>
              <el-button size="mini" type="text" icon="el-icon-circle-close" style="color:#E6A23C" @click.stop="handleCancel(scope.row)" v-if="scope.row.status==='1' || scope.row.status==='2'" v-hasPermi="['textbook:noticeManage:edit']">作废</el-button>
              <el-button size="mini" type="text" icon="el-icon-timer" @click.stop="handleExtend(scope.row)" v-if="scope.row.status==='1' || scope.row.status==='2'" v-hasPermi="['textbook:noticeManage:edit']">延长</el-button>
              <el-button size="mini" type="danger" icon="el-icon-delete" @click.stop="handleDelete(scope.row)" v-if="scope.row.status==='0'" v-hasPermi="['textbook:noticeManage:remove']">删除</el-button>
            </template>
          </el-table-column>
        </el-table>
        <pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />
      </el-tab-pane>
      <el-tab-pane label="个人领书申请" name="personal">
        <el-form :model="paParams" ref="paFormRef" size="small" :inline="true" label-width="68px">
          <el-form-item label="申请人">
            <el-input v-model="paParams.teacherName" placeholder="申请人" clearable @keyup.enter.native="getPaList" />
          </el-form-item>
          <el-form-item label="状态">
            <el-select v-model="paParams.status" placeholder="请选择" clearable @change="getPaList">
              <el-option label="待审核" value="0" />
              <el-option label="已通过" value="1" />
              <el-option label="已驳回" value="2" />
              <el-option label="已出库" value="3" />
            </el-select>
          </el-form-item>
          <el-form-item>
            <el-button type="primary" icon="el-icon-search" size="mini" @click="getPaList">搜索</el-button>
          </el-form-item>
        </el-form>
        <el-table v-loading="paLoading" :data="paList" border stripe>
          <el-table-column label="申请编号" prop="applyNo" min-width="170" show-overflow-tooltip />
          <el-table-column label="申请人" prop="teacherName" width="85" />
          <el-table-column label="教材名称" prop="bookName" show-overflow-tooltip min-width="120" />
          <el-table-column label="申请数量" prop="applyQty" width="70" align="center" />
          <el-table-column label="用途" prop="purpose" show-overflow-tooltip min-width="100" />
          <el-table-column label="状态" width="75" align="center">
            <template slot-scope="s">
              <el-tag :type="{0:'warning',1:'success',2:'danger',3:''}[s.row.status]" size="mini">{{ paStatusText(s.row.status) }}</el-tag>
            </template>
          </el-table-column>
          <el-table-column label="缺书进度" width="95" align="center">
            <template slot-scope="s">
              <el-tag v-if="s.row.shortageStatus==='0'" type="info" size="mini">待采购</el-tag>
              <el-tag v-else-if="s.row.shortageStatus==='1'" type="warning" size="mini">采购中</el-tag>
              <el-tag v-else-if="s.row.shortageStatus==='2'" type="" size="mini">已到货</el-tag>
              <el-tag v-else-if="s.row.shortageStatus==='3'" type="success" size="mini">已入库</el-tag>
              <span v-else style="color:#c0c4cc">-</span>
            </template>
          </el-table-column>
          <el-table-column label="审核意见" prop="auditOpinion" show-overflow-tooltip width="100" />
          <el-table-column label="申请时间" prop="createTime" width="140" />
          <el-table-column label="操作" class-name="small-padding fixed-width" width="170" align="center">
            <template slot-scope="s">
              <el-button size="mini" type="text" icon="el-icon-view" @click="paView(s.row)">详情</el-button>
              <el-button size="mini" type="text" icon="el-icon-check" style="color:#67C23A" @click="paAuditOpen=true;paForm=s.row" v-if="s.row.status==='0'" v-hasPermi="['textbook:personalApply:audit']">审核</el-button>
              <el-button size="mini" type="text" icon="el-icon-sold-out" style="color:#67C23A" @click="paIssue(s.row)" v-if="(s.row.status==='1' || s.row.shortageStatus==='3') && s.row.status!=='3'" v-hasPermi="['textbook:personalApply:issue']">确认领书</el-button>
              <el-tag v-if="s.row.status==='2' && s.row.shortageStatus && s.row.shortageStatus!=='3'" type="info" size="mini" style="cursor:default">缺书处理中</el-tag>
            </template>
          </el-table-column>
        </el-table>
        <pagination v-show="paTotal > 0" :total="paTotal" :page.sync="paParams.pageNum" :limit.sync="paParams.pageSize" @pagination="getPaList" />
      </el-tab-pane>
    </el-tabs>

    <!-- 新建/编辑领书计划 -->
    <el-dialog :title="title" :visible.sync="open" width="750px" append-to-body :close-on-click-modal="false">
      <el-form ref="form" :model="form" :rules="rules" label-width="100px">
        <el-form-item label="学期" prop="semester">
          <el-input v-model="form.semester" placeholder="如：2025-2026-2" style="width: 70%" />
          <el-button type="success" size="small" icon="el-icon-download" style="margin-left:8px" @click="loadBindingData" :loading="bindingLoading">加载采购绑定</el-button>
        </el-form-item>
        <el-form-item label="领取地点" prop="pickupLocation">
          <el-input v-model="form.pickupLocation" placeholder="如：图书馆一楼大厅" />
        </el-form-item>
        <el-form-item label="领取开始" prop="pickupStart">
          <el-date-picker v-model="form.pickupStart" type="datetime" placeholder="选择开始时间" value-format="yyyy-MM-dd HH:mm:ss" style="width:100%" />
        </el-form-item>
        <el-form-item label="领取结束" prop="pickupEnd">
          <el-date-picker v-model="form.pickupEnd" type="datetime" placeholder="选择结束时间" value-format="yyyy-MM-dd HH:mm:ss" style="width:100%" />
        </el-form-item>
        <el-divider>领书明细</el-divider>
        <el-table :data="form.details" border stripe size="small" v-if="form.details && form.details.length">
          <el-table-column label="班级" prop="className" width="100" />
          <el-table-column label="教材名称" prop="bookName" show-overflow-tooltip min-width="140" />
          <el-table-column label="ISBN" prop="isbn" width="130" />
          <el-table-column label="数量" prop="plannedQty" width="70" align="center" />
          <el-table-column label="操作" class-name="small-padding fixed-width" width="140" align="center">
            <template slot-scope="scope">
              <el-button type="primary" size="mini" @click="editDetail(scope.$index)"><i class="el-icon-edit"></i></el-button>
              <el-button type="danger" size="mini" @click="removeDetail(scope.$index)"><i class="el-icon-delete"></i></el-button>
            </template>
          </el-table-column>
        </el-table>
        <el-alert v-else type="info" title="请添加领书明细" :closable="false" />
        <div style="text-align:right;margin-top:10px;">
          <el-button type="primary" size="small" icon="el-icon-plus" @click="openDetailDialog()">添加明细</el-button>
        </div>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitForm">确 定</el-button>
        <el-button @click="cancel">取 消</el-button>
      </div>
    </el-dialog>

    <!-- 添加/编辑明细 -->
    <el-dialog :title="detailForm._editIndex !== undefined ? '编辑明细' : '添加明细'" :visible.sync="detailDialogVisible" width="550px" append-to-body>
      <el-form ref="detailFormRef" :model="detailForm" label-width="80px" size="small">
        <el-form-item label="入学年份（级）">
          <el-select v-model="detailForm.gradeLevel" placeholder="请选择年级" clearable style="width:100%">
            <el-option v-for="d in dict.type.tb_enrollment_year" :key="d.value" :label="d.label" :value="d.value" />
          </el-select>
        </el-form-item>
        <el-form-item label="班级">
          <el-input v-model="detailForm.className" placeholder="如：1班" />
        </el-form-item>
        <el-form-item label="选择教材">
          <el-select v-model="detailForm.textbookIds" multiple filterable remote reserve-keyword :remote-method="searchBook" :loading="bookLoading" placeholder="输入ISBN/书名搜索" style="width:100%">
            <el-option v-for="b in bookOpts" :key="b.bookId" :label="b.isbn + ' - ' + b.bookName" :value="b.bookId" />
          </el-select>
        </el-form-item>
        <el-form-item label="数量">
          <el-input-number v-model="detailForm.plannedQty" :min="1" style="width:100%" />
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="confirmAddDetail">确 定</el-button>
        <el-button @click="detailDialogVisible = false">取 消</el-button>
      </div>
    </el-dialog>

    <!-- 领书单明细 -->
    <el-dialog title="领书单明细" :visible.sync="formDetailVisible" width="800px" append-to-body>
      <el-table :data="formDetailList" border stripe size="small">
        <el-table-column label="教材名称" prop="bookName" show-overflow-tooltip min-width="140" />
        <el-table-column label="ISBN" prop="isbn" width="130" />
        <el-table-column label="作者" prop="author" width="85" />
        <el-table-column label="出版社" prop="publisher" width="120" show-overflow-tooltip />
        <el-table-column label="应发" prop="plannedQty" width="55" align="center" />
        <el-table-column label="实发" prop="issuedQty" width="55" align="center" />
      </el-table>
      <div slot="footer"><el-button @click="formDetailVisible = false">关 闭</el-button></div>
    </el-dialog>

    <!-- 领书确认单（出库+打印） -->
    <el-dialog title="领书确认单" :visible.sync="outboundOpen" width="820px" append-to-body :close-on-click-modal="false">
      <div v-if="outboundForm.formId">
        <el-descriptions :column="2" border size="small">
          <el-descriptions-item label="领书单号">{{ outboundForm.formNo }}</el-descriptions-item>
          <el-descriptions-item label="班级">{{ outboundForm.className || '-' }}</el-descriptions-item>
          <el-descriptions-item label="年级">{{ outboundForm.gradeLevel || '-' }}</el-descriptions-item>
          <el-descriptions-item label="状态">{{ outboundForm.status === '2' ? '已出库' : outboundForm.status === '1' ? '部分出库' : '待领取' }}</el-descriptions-item>
        </el-descriptions>
        <el-divider content-position="left">教材明细</el-divider>
        <el-table :data="outboundForm.books" border stripe size="small" max-height="300">
          <el-table-column label="教材名称" prop="bookName" min-width="130" show-overflow-tooltip />
          <el-table-column label="ISBN" prop="isbn" width="140" />
          <el-table-column label="应发" prop="plannedQty" width="60" align="center" />
          <el-table-column label="已发" prop="alreadyIssued" width="60" align="center" />
          <el-table-column label="本次实发" width="130" align="center">
            <template slot-scope="s">
              <el-input-number v-model="s.row.thisIssue" :min="0" :max="s.row.plannedQty - s.row.alreadyIssued" size="mini" style="width:75px" controls-position="right" />
            </template>
          </el-table-column>
          <el-table-column label="剩余" width="60" align="center">
            <template slot-scope="s">{{ s.row.plannedQty - s.row.alreadyIssued - (s.row.thisIssue||0) }}</template>
          </el-table-column>
        </el-table>
        <el-divider content-position="left">签收信息</el-divider>
        <el-form label-width="80px" size="small">
          <el-form-item label="领书人" required>
            <el-input v-model="outboundForm.receiverName" placeholder="请班委签名（必填）" style="width:220px" />
          </el-form-item>
        </el-form>
      </div>
      <div slot="footer">
        <el-button type="primary" icon="el-icon-sold-out" @click="submitOutbound">确认出库并打印</el-button>
        <el-button @click="outboundOpen = false">取 消</el-button>
      </div>
    </el-dialog>

    <!-- 个人申请审核弹窗 -->
    <el-dialog title="审核" :visible.sync="paAuditOpen" width="500px" append-to-body>
      <el-descriptions :column="1" border v-if="paForm.applyId">
        <el-descriptions-item label="申请人">{{ paForm.teacherName }}</el-descriptions-item>
        <el-descriptions-item label="教材">{{ paForm.bookName }}</el-descriptions-item>
        <el-descriptions-item label="数量">{{ paForm.applyQty }} 本</el-descriptions-item>
        <el-descriptions-item label="用途">{{ paForm.purpose || '-' }}</el-descriptions-item>
        <el-descriptions-item label="申请时间">{{ paForm.createTime }}</el-descriptions-item>
      </el-descriptions>
      <el-form :model="paForm" label-width="80px" size="small" style="margin-top:15px;">
        <el-form-item label="审核结果">
          <el-radio-group v-model="paForm.status">
            <el-radio label="1">通过</el-radio>
            <el-radio label="2">驳回</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="审核意见">
          <el-input v-model="paForm.auditOpinion" type="textarea" :rows="2" placeholder="可选填审核意见" />
        </el-form-item>
        <el-form-item label="紧急程度" v-if="paForm.status==='2'">
          <el-select v-model="paForm.shortageUrgency">
            <el-option label="普通" value="0" />
            <el-option label="紧急" value="1" />
            <el-option label="特急" value="2" />
          </el-select>
        </el-form-item>
      </el-form>
      <div slot="footer">
        <el-button type="primary" @click="paSubmitAudit">确 定</el-button>
        <el-button @click="paAuditOpen=false">取 消</el-button>
      </div>
    </el-dialog>

    <!-- 确认领书弹窗 -->
    <el-dialog title="确认教师领书" :visible.sync="paReceiveOpen" width="500px" append-to-body :close-on-click-modal="false">
      <el-form :model="paReceiveForm" label-width="80px" size="small" v-if="paReceiveForm.applyId">
        <el-descriptions :column="1" border>
          <el-descriptions-item label="申请人">{{ paReceiveForm.teacherName }}</el-descriptions-item>
          <el-descriptions-item label="教材">{{ paReceiveForm.bookName }}</el-descriptions-item>
          <el-descriptions-item label="ISBN">{{ paReceiveForm.isbn }}</el-descriptions-item>
          <el-descriptions-item label="申请数量">{{ paReceiveForm.applyQty }} 本</el-descriptions-item>
        </el-descriptions>
        <el-divider />
        <el-form-item label="实发数量" required>
          <el-input-number v-model="paReceiveForm.receivedQty" :min="1" :max="paReceiveForm.applyQty" style="width:100%" />
        </el-form-item>
        <el-form-item label="领取地点">
          <el-input v-model="paReceiveForm.location" placeholder="如：图书馆一楼书库" />
        </el-form-item>
        <el-form-item label="备注">
          <el-input v-model="paReceiveForm.remark" type="textarea" :rows="2" placeholder="选填" />
        </el-form-item>
      </el-form>
      <div slot="footer">
        <el-button type="primary" @click="paSubmitReceive">确认领书</el-button>
        <el-button @click="paReceiveOpen = false">取 消</el-button>
      </div>
    </el-dialog>

    <!-- 个人申请详情弹窗 -->
    <el-dialog title="申请详情" :visible.sync="paViewOpen" width="550px" append-to-body>
      <el-descriptions :column="1" border v-if="paForm.applyId">
        <el-descriptions-item label="申请编号">{{ paForm.applyNo }}</el-descriptions-item>
        <el-descriptions-item label="申请人">{{ paForm.teacherName }}</el-descriptions-item>
        <el-descriptions-item label="教材名称">{{ paForm.bookName }}</el-descriptions-item>
        <el-descriptions-item label="ISBN">{{ paForm.isbn }}</el-descriptions-item>
        <el-descriptions-item label="数量">{{ paForm.applyQty }} 本</el-descriptions-item>
        <el-descriptions-item label="用途" :span="2">{{ paForm.purpose || '-' }}</el-descriptions-item>
        <el-descriptions-item label="状态">{{ paStatusText(paForm.status) }}</el-descriptions-item>
        <el-descriptions-item label="审核意见" :span="2">{{ paForm.auditOpinion || '-' }}</el-descriptions-item>
        <el-descriptions-item label="审核人">{{ paForm.auditBy || '-' }}</el-descriptions-item>
        <el-descriptions-item label="审核时间">{{ paForm.auditTime || '-' }}</el-descriptions-item>
        <el-descriptions-item label="出库时间" :span="2">{{ paForm.issueTime || '-' }}</el-descriptions-item>
      </el-descriptions>
      <div slot="footer"><el-button @click="paViewOpen=false">关 闭</el-button></div>
    </el-dialog>
  </div>
</template>

<script>
import { listNotice, getNotice, saveAndGenerate, updateNotice, delNotice, getClaimForms, getBindingData, getClaimForm, exportPdf, publishNotice, cancelNotice, extendPickupTime, withdrawClaimForm, closeClaimForm, reissueClaimForm, listClaimFormDetail } from "@/api/textbook/claimManage";
import { listBook } from "@/api/textbook/book";
import { confirmOutbound } from "@/api/textbook/claimManage";
import { listPersonalApply, auditApply, issueApply, getPersonalApply } from "@/api/textbook/personalApply";

export default {
  name: "ClaimManage",
  dicts: ['tb_enrollment_year'],
  data() {
    return {
      loading: false,
      total: 0,
      noticeList: [],
      showSearch: true,
      open: false,
      title: "新建领书计划",
      form: { semester: '', pickupLocation: '', pickupStart: '', pickupEnd: '', details: [] },
      rules: {
        semester: [{ required: true, message: '请输入学期', trigger: 'blur' }],
        pickupLocation: [{ required: true, message: '请输入领取地点', trigger: 'blur' }],
        pickupStart: [{ required: true, message: '请选择开始时间', trigger: 'change' }]
      },
      queryParams: { pageNum: 1, pageSize: 10, semester: undefined, status: undefined, bizType: '8' },
      detailDialogVisible: false,
      detailForm: { _editIndex: undefined, gradeLevel: '', className: '', textbookIds: [], plannedQty: 1 },
      bookOpts: [],
      bookLoading: false,
      formDetailVisible: false,
      formDetailList: [],
      outboundOpen: false,
      outboundForm: { formId: undefined, formNo: '', className: '', gradeLevel: '', status: '', books: [], receiverName: '' },
      activeTab: 'class',
      paList: [],
      paTotal: 0,
      paLoading: false,
      paParams: { pageNum: 1, pageSize: 10, teacherName: undefined, status: undefined },
      paAuditOpen: false,
      paViewOpen: false,
      paForm: {},
      paReceiveOpen: false,
      paReceiveForm: { applyId: null, teacherName: '', bookName: '', isbn: '', applyQty: 0, receivedQty: 1, location: '仓库', remark: '' },
      bindingLoading: false
    }
  },
  created() {
    this.getList()
  },
  methods: {
    formatGradeLevel(val) {
      if (!val || val === '通用') return ''
      const match = val.match(/(\d{2})级/)
      if (match) {
        const year = parseInt(match[1])
        const enrollmentYear = year >= 50 ? 1900 + year : 2000 + year
        const now = new Date()
        const academicYear = now.getMonth() >= 8 ? now.getFullYear() : now.getFullYear() - 1
        const grade = academicYear - enrollmentYear + 1
        if (enrollmentYear > academicYear) return val + '/未入学'
        const names = ['大一', '大二', '大三', '大四']
        return val + '/' + (names[grade - 1] || '已毕业')
      }
      return val
    },
    getList() {
      this.loading = true
      return listNotice(this.queryParams).then(response => {
        this.noticeList = response.rows || []
        this.total = response.total
        this.loading = false
      })
    },
    handleQuery() {
      this.queryParams.pageNum = 1
      this.getList()
    },
    resetQuery() {
      this.resetForm("queryForm")
      this.handleQuery()
    },
    handleAdd() {
      const now = new Date()
      const y = now.getFullYear()
      const m = now.getMonth() + 1
      let semester = ''
      if (m >= 9) semester = y + '-' + (y+1) + '-1'
      else if (m >= 2) semester = (y-1) + '-' + y + '-2'
      else semester = (y-1) + '-' + y + '-1'
      this.form = { semester, pickupLocation: '', pickupStart: '', pickupEnd: '', details: [] }
      this.title = "新建领书计划"
      this.open = true
    },
    loadBindingData() {
      if (!this.form.semester || !this.form.semester.trim()) {
        this.$modal.msgError('请先输入学期(如2025-2026-2)')
        return
      }
      this.bindingLoading = true
      getBindingData(this.form.semester).then(response => {
        const data = response.data
        if (!data || data.length === 0) {
          this.$modal.msgWarning('该学期暂无采购绑定数据，请先导入采购单')
          return
        }
        const gradeNames = ['大一', '大二', '大三', '大四']
        const semesterParts = this.form.semester.split('-')
        const now = new Date()
        const dateAcademicYear = now.getMonth() >= 8 ? now.getFullYear() : now.getFullYear() - 1
        const academicYear = parseInt(semesterParts[0]) || dateAcademicYear
        const toEnrollmentLabel = (raw) => {
          if (!raw || raw === '通用') return raw || '通用'
          const match = raw.match(/^(\d{2})级$/)
          if (match) return raw
          const idx = gradeNames.indexOf(raw)
          if (idx >= 0) {
            const yr = academicYear - idx
            return String(yr).slice(2) + '级'
          }
          const numMatch = raw.match(/^(\d{4})$/)
          if (numMatch) return numMatch[1].slice(2) + '级'
          return raw
        }
        const details = []
        data.forEach(collegeMajor => {
          const college = collegeMajor.college || ''
          const major = collegeMajor.major || ''
          const classList = collegeMajor.classList || []
          classList.forEach(cls => {
            const className = cls.className || ''
            const rawGrade = className.replace(major, '')
            const gradeLevel = toEnrollmentLabel(rawGrade)
            const books = cls.books || []
            books.forEach(book => {
              details.push({
                textbookId: book.bookId,
                isbn: book.isbn || '',
                bookName: book.bookName || '',
                plannedQty: book.plannedQty || 0,
                className: className,
                gradeLevel: gradeLevel,
                collegeId: 0,
                majorId: 0,
                classId: 0,
                issuedQty: 0
              })
            })
          })
        })
        this.form.details = details
        this.$modal.msgSuccess(`已加载 ${details.length} 条绑定记录`)
      }).catch(() => {
        this.$modal.msgError('加载失败，请重试')
      }).finally(() => {
        this.bindingLoading = false
      })
    },
    handleDelete(row) {
      this.$modal.confirm('删除该批次？相关领书单也需要删除').then(() =>
        delNotice(row.noticeId).then(() => { this.$modal.msgSuccess('已删除'); this.getList() })
      ).catch(() => {})
    },
    cancel() {
      this.open = false
      this.form = { semester: '', pickupLocation: '', pickupStart: '', pickupEnd: '', details: [] }
    },
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (!valid) return
        if (!this.form.details || this.form.details.length === 0) {
          this.$modal.msgError('请添加领书明细')
          return
        }
        const data = { ...this.form }
        if (this.form.noticeId) {
          updateNotice(data).then(() => {
            this.$modal.msgSuccess('修改成功')
            this.open = false
            this.getList()
          })
        } else {
          saveAndGenerate(data).then(() => {
            this.$modal.msgSuccess('创建成功')
            this.open = false
            this.getList()
          })
        }
      })
    },
    searchBook(query) {
      if (!query) { this.bookOpts = []; return }
      this.bookLoading = true
      listBook({ bookName: query, pageNum: 1, pageSize: 20 }).then(res => {
        this.bookOpts = res.rows || []
      }).finally(() => { this.bookLoading = false })
    },
    openDetailDialog() { this.detailForm = { _editIndex: undefined, gradeLevel: '', className: '', textbookIds: [], plannedQty: 1 }; this.detailDialogVisible = true },
    editDetail(idx) {
      const d = this.form.details[idx]
      this.detailForm = { _editIndex: idx, gradeLevel: d.gradeLevel || '', className: d.className || '', textbookIds: d.textbookId ? [d.textbookId] : [], plannedQty: d.plannedQty || 1 }
      this.detailDialogVisible = true
    },
    removeDetail(idx) { this.form.details.splice(idx, 1) },
    confirmAddDetail() {
      if (!this.detailForm.textbookIds || !this.detailForm.textbookIds.length) {
        this.$modal.msgError('请选择教材')
        return
      }
      const bs = this.bookOpts.filter(b => this.detailForm.textbookIds.includes(b.bookId))
      const items = bs.map(b => ({
        textbookId: b.bookId,
        bookName: b.bookName,
        isbn: b.isbn,
        author: b.author,
        publisher: b.publisher,
        plannedQty: this.detailForm.plannedQty,
        gradeLevel: this.detailForm.gradeLevel,
        className: this.detailForm.className
      }))
      const existing = this.form.details || []
      if (this.detailForm._editIndex !== undefined) {
        this.$set(this.form.details, this.detailForm._editIndex, items[0])
        this.$modal.msgSuccess('已更新')
      } else {
        this.form.details = existing.concat(items)
        this.$modal.msgSuccess('已添加' + items.length + ' 本教材')
      }
      this.detailDialogVisible = false
    },
    onNoticeExpand(row, expandedRows) {
      expandedRows.forEach(r => this.toggleForms(r))
    },
    async toggleForms(row) {
      if (row._formsLoaded) return
      this.$set(row, '_loading', true)
      try {
        const res = await getClaimForms(row.noticeId)
        const list = Array.isArray(res.data) ? res.data : []
        console.log('[expand] noticeId=' + row.noticeId, 'forms=', list.length, list)
        this.$set(row, '_forms', list)
        this.$set(row, '_formsLoaded', true)
      } catch (e) {
        console.error('[expand] 加载失败', e)
        this.$modal.msgError('加载领书单失败：' + (e.message || '未知'))
      }
      this.$set(row, '_loading', false)
    },
    async viewFormDetail(row) {
      this.formDetailList = []
      this.formDetailVisible = true
      try {
        const res = await listClaimFormDetail(row.formId)
        this.formDetailList = Array.isArray(res.data) ? res.data : []
      } catch (e) {
        this.$modal.msgError('加载明细失败: ' + (e.message || '网络异常'))
      }
    },
    handleOutbound(row) {
      if (row.status === '2') { this.$modal.msgWarning('该领书单已全部出库'); return }
      getClaimForm(row.formId).then(res => {
        const form = res.data
        const books = (form.details || []).map(d => ({
          bookName: d.bookName, isbn: d.isbn, plannedQty: d.plannedQty || 0,
          alreadyIssued: d.issuedQty || 0, thisIssue: Math.max(0, (d.plannedQty||0) - (d.issuedQty||0))
        }))
        this.outboundForm = {
          formId: form.formId, formNo: form.formNo,
          className: form.className, gradeLevel: form.gradeLevel,
          status: form.status,
          books,
          receiverName: form.receiverName || ''
        }
        this.outboundOpen = true
      })
    },
    async handlePrint(row) {
      try {
        const blob = await exportPdf(row.formId)
        const blobObj = new Blob([blob], { type: 'application/pdf' })
        const url = window.URL.createObjectURL(blobObj)
        const link = document.createElement('a')
        link.href = url
        link.download = '领书单_' + (row.formNo || row.formId) + '.pdf'
        document.body.appendChild(link)
        link.click()
        document.body.removeChild(link)
        window.URL.revokeObjectURL(url)
        this.$modal.msgSuccess('PDF 下载成功')
      } catch (e) {
        this.$modal.msgError('PDF 生成失败：' + (e.message || '未知错误'))
      }
    },
    submitOutbound() {
      if (!this.outboundForm.receiverName || !this.outboundForm.receiverName.trim()) {
        this.$modal.msgError('请填写领书人姓名（班委签名）')
        return
      }
      const totalIssue = this.outboundForm.books.reduce((sum, b) => sum + (b.thisIssue || 0), 0)
      if (totalIssue <= 0) { this.$modal.msgError('本次实发总量必须大于0'); return }
      const partialDetail = this.outboundForm.books
        .filter(b => (b.thisIssue || 0) > 0)
        .map(b => ({ textbookId: b.textbookId, isbn: b.isbn, bookName: b.bookName, issueQty: b.thisIssue }))
      confirmOutbound({
        formId: this.outboundForm.formId,
        issuedQty: totalIssue,
        receiverName: this.outboundForm.receiverName,
        partialDetail: partialDetail
      }).then(() => {
        this.$modal.msgSuccess('出库成功')
        const fid = this.outboundForm.formId
        const fno = this.outboundForm.formNo
        this.outboundOpen = false
        exportPdf(fid).then(blob => {
          const blobObj = new Blob([blob], { type: 'application/pdf' })
          const url = window.URL.createObjectURL(blobObj)
          const link = document.createElement('a')
          link.href = url
          link.download = '领书单_' + fno + '.pdf'
          document.body.appendChild(link)
          link.click()
          document.body.removeChild(link)
          window.URL.revokeObjectURL(url)
        }).catch(e => { this.$modal.msgError('PDF 生成失败：' + (e.message || '未知错误')) })
        const noticedRow = this.noticeList.find(n => n._forms && n._forms.some(f => f.formId === fid))
        if (noticedRow) {
          this.$set(noticedRow, '_loading', true)
          getClaimForms(noticedRow.noticeId).then(res => {
            this.$set(noticedRow, '_forms', Array.isArray(res.data) ? res.data : [])
            this.$set(noticedRow, '_formsLoaded', true)
            this.$set(noticedRow, '_loading', false)
          }).catch(() => { this.$set(noticedRow, '_loading', false) })
        }
      }).catch(() => {})
    },
    handleFormAction(cmd, row) {
      switch (cmd) {
        case 'withdraw':
          this.$modal.confirm('确定撤回领书单「' + row.formNo + '」？撤回后无法恢复。').then(() => {
            withdrawClaimForm(row.formId).then(() => {
              this.$modal.msgSuccess('已撤回')
              this.refreshForms(row)
            })
          }).catch(() => {})
          break
        case 'close':
          this.$prompt('请输入关闭原因', '关闭领书单', { confirmButtonText: '确定', cancelButtonText: '取消', inputPattern: /.+/, inputErrorMessage: '原因不能为空' }).then(({ value }) => {
            closeClaimForm(row.formId, value).then(() => {
              this.$modal.msgSuccess('已关闭')
              this.refreshForms(row)
            })
          }).catch(() => {})
          break
        case 'reissue':
          this.$prompt('请输入补发数量（不填则补发全部差额）', '补发出库', { confirmButtonText: '确定', cancelButtonText: '取消' }).then(({ value }) => {
            const qty = value ? parseInt(value) : undefined
            reissueClaimForm(row.formId, qty).then(() => {
              this.$modal.msgSuccess('补发成功')
              this.refreshForms(row)
            })
          }).catch(() => {})
          break
      }
    },
    refreshForms(row) {
      const noticedRow = this.noticeList.find(n => n.noticeId === row.noticeId)
      if (noticedRow && noticedRow._formsLoaded) {
        this.$set(noticedRow, '_loading', true)
        getClaimForms(noticedRow.noticeId).then(res => {
          this.$set(noticedRow, '_forms', Array.isArray(res.data) ? res.data : [])
          this.$set(noticedRow, '_loading', false)
        }).catch(() => { this.$set(noticedRow, '_loading', false) })
      }
    },
    onTabClick() { if (this.activeTab === 'personal') this.getPaList() },
    getPaList() {
      this.paLoading = true
      listPersonalApply(this.paParams).then(res => {
        this.paList = res.rows || []
        this.paTotal = res.total
        this.paLoading = false
      })
    },
    paView(row) { this.paForm = row; this.paViewOpen = true },
    paStatusText(s) { return { '0': '待审核', '1': '已通过', '2': '已驳回', '3': '已领取' }[s] || '-' },
    noticeStatusText(s) { return { '0': '草稿', '1': '已发布', '2': '领取中', '3': '已完成', '4': '已作废' }[s] || '-' },
    paSubmitAudit() {
      const approved = this.paForm.status === '1'
      auditApply({ applyId: this.paForm.applyId, status: this.paForm.status, auditOpinion: this.paForm.auditOpinion, shortageUrgency: this.paForm.shortageUrgency }).then(() => {
        this.$modal.msgSuccess(approved ? '已通过' : '已驳回')
        this.paAuditOpen = false
        this.getPaList()
      }).catch(() => {
        this.getPaList()
      })
    },
    paIssue(row) {
      this.paReceiveForm = {
        applyId: row.applyId,
        teacherName: row.teacherName,
        bookName: row.bookName,
        isbn: row.isbn,
        applyQty: row.applyQty || 0,
        receivedQty: row.applyQty || 1,
        location: '仓库',
        remark: ''
      }
      this.paReceiveOpen = true
    },
    paSubmitReceive() {
      const data = {
        receivedQty: this.paReceiveForm.receivedQty,
        location: this.paReceiveForm.location,
        remark: this.paReceiveForm.remark
      }
      issueApply(this.paReceiveForm.applyId, data).then(() => {
        this.$modal.msgSuccess('领书确认成功，库存已扣减')
        this.paReceiveOpen = false
        this.getPaList()
      }).catch(() => {})
    },
    handlePublish(row) {
      this.$modal.confirm('确认发布领书通知「' + row.noticeNo + '」？发布后此通知下的领书单将立即可用。').then(() => {
        return publishNotice(row.noticeId)
      }).then((res) => {
        console.log('[publish] 后端返回', res)
        this.$modal.msgSuccess('发布成功（' + (res.data || '') + '）')
        return this.getList()
      }).then(() => {
        console.log('[publish] 列表已刷新')
      }).catch((e) => {
        if (e !== 'cancel' && e) {
          console.error('[publish] 失败', e)
          this.$modal.msgError('发布失败：' + (e.message || '未知'))
        }
      })
    },
    handleCancel(row) {
      this.$prompt('请输入作废原因', '作废通知', { confirmButtonText: '确定', cancelButtonText: '取消', inputPattern: /.+/, inputErrorMessage: '原因不能为空' }).then(({ value }) => {
        cancelNotice(row.noticeId, value).then(() => {
          this.$modal.msgSuccess('已作废')
          this.getList()
        })
      }).catch(() => {})
    },
    handleExtend(row) {
      this.$prompt('请输入新的领取截止时间（格式：yyyy-MM-dd HH:mm:ss）', '延长领取时间', { confirmButtonText: '确定', cancelButtonText: '取消', inputValue: row.pickupEnd || '', inputPattern: /^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}$/, inputErrorMessage: '格式不正确' }).then(({ value }) => {
        extendPickupTime(row.noticeId, value).then(() => {
          this.$modal.msgSuccess('已延长')
          this.getList()
        })
      }).catch(() => {})
    },
  }
}
</script>
